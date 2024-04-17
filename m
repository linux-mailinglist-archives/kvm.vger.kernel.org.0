Return-Path: <kvm+bounces-15015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66ECA8A8D8E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE8D0B222E3
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5ED44CB45;
	Wed, 17 Apr 2024 21:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UdFb+zMy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2DF4A9B0
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 21:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388441; cv=none; b=jpcMz5RYolQKUpBszBjlWrAhyR2kLyYkOeWRtPJxVf/I3guOSlot35Zgm7++nccF1QNH6xQIPBWYRXjMe7RQgv1+V14AGjWqmFxLgC1vSFgcAeMBwHXsK1AqdngjflIEMuYUmTkZ6bS1dqiIN+TnpFk6hOrLfa3tasqoT7QgyA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388441; c=relaxed/simple;
	bh=XA6YYQNkYOQfc0ccxU6fvBGiv4lH8yOBrPdb7vPQJoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FEq11CFyiXAEOOul5M4vcgDmdDNHWKMsRk9QNpU+Nhn1/I1L02xixJviA67BY3AmetEK6veI3FWv8bWsCcmpgy5OUpGu4ikfPM/+V8sDApIDFuDCXjKgJ+OQLdW9MFBBqEH9oFb6GxWxcgDLnHA7vhMpWwayKKcT9OCgZdtBIRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UdFb+zMy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713388439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2C9akPJAJwJZjxxljCty6JRoxRpyti3F4JswiGBS/o=;
	b=UdFb+zMyc3Vo+Z9ZbQsboxHXbmeLq0Yhp+R6de0N4iM+GA8jcXhg3OEYXnIUWvSL3jn0yt
	HQEI9UjP/gSPeGlTImMz9GGojjIkF90ummTidKsj4xsx/ENwDEbUle4hPfaTTXiN4z05/N
	nXEcRWHnfXYbXZtGzGVWZO1UhryrO00=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-yYYUQVRWPnOdzwrVlaOunA-1; Wed, 17 Apr 2024 17:13:57 -0400
X-MC-Unique: yYYUQVRWPnOdzwrVlaOunA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-349d779625eso114647f8f.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713388436; x=1713993236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2C9akPJAJwJZjxxljCty6JRoxRpyti3F4JswiGBS/o=;
        b=VitNvivRuZGPoPYnCZvdC12OIFVxy+XMQUNjPxeaGxFYyvmqxWFZDRget1QAgc/80S
         CMH27ducJqd1oWzvCcNEOL2IFjTxRmtChcjOBMXH2W8CD7mh4oDvMvQ3Sg1WVJH7O3yP
         +kgH/WmV30sia4H5UeFCU9OOn3ufikE6vLw9r1Mg4E15Vra7JhXurQ8xPgwrDzjbUAr4
         fU9/Ii4pyzUhi39x+w5Z9RxRvNlXcm3g6DoTJdozkkR9ln55i2M/2JASgqtf50sUYBjX
         PS/5p5J4GAhGBFL692tGi4LgnWARDVig8/hzCIM2hWwXk7NeQCzm554qi5533Mb0pAoQ
         geqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzYciSdSsyl7ymPS+/HosC1Hd5oStjIklnpGQG0yiGUeohcjUqX/SzPmlqYdWQDjKk6RtOUUTuYCy7/m5GEZctk4yA
X-Gm-Message-State: AOJu0Yzxp2xW6Ofh1qeOof5tS3myipN1R870+Sy1qx1lV1RkgnvPFpD9
	9nbs3flXJFapgtRzetxwG6qxtl95zTXXTv66RsNhmOGrV0IwcbLxproIS6289rbCRT5lRNEQhPl
	SPhVwSuCzVFGN2/xLfiWkLgWLtHPpm4OXyN58IWZRDxSDv8OuvWDWxzskU5RFRVX7ph4iC3zWUD
	r8IjsBAH4ZncFkUE58o//9JM04
X-Received: by 2002:a05:6000:1289:b0:343:ba58:97c2 with SMTP id f9-20020a056000128900b00343ba5897c2mr407281wrx.2.1713388436476;
        Wed, 17 Apr 2024 14:13:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGRugtsyJBzGMIe/V5ASLaTzpSHHpUaE76zkcW3p6ReO5WyJinae3xB1F2OEby8SIAw5N/b+PLo013PGBiEFA=
X-Received: by 2002:a05:6000:1289:b0:343:ba58:97c2 with SMTP id
 f9-20020a056000128900b00343ba5897c2mr407264wrx.2.1713388436104; Wed, 17 Apr
 2024 14:13:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-3-pbonzini@redhat.com>
 <20240417193625.GJ3039520@ls.amr.corp.intel.com> <ZiA6H9-0fknDPdFp@google.com>
In-Reply-To: <ZiA6H9-0fknDPdFp@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 23:13:34 +0200
Message-ID: <CABgObfYvfxkkcXNUpe1oCcc1mtUwv+henfm5ghHM2pG1aFNtiQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate
 guest memory
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 11:07=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Apr 17, 2024, Isaku Yamahata wrote:
> > > +   vcpu_load(vcpu);
> > > +   idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > > +
> > > +   r =3D 0;
> > > +   full_size =3D mapping->size;
> > > +   while (mapping->size) {
>
> Maybe pre-check !mapping->size?  E.g. there's no reason to load the vCPU =
and
> acquire SRCU just to do nothing.  Then this can be a do-while loop and do=
esn't
> need to explicitly initialize 'r'.

It's unlikely to make any difference but okay---easy enough.

> > > +           if (signal_pending(current)) {
> > > +                   r =3D -EINTR;
> > > +                   break;
> > > +           }
> > > +
> > > +           r =3D kvm_arch_vcpu_map_memory(vcpu, mapping);
>
> Requiring arch code to address @mapping is cumbersone.  If the arch call =
returns
> a long, then can't we do?
>
>                 if (r < 0)
>                         break;
>
>                 mapping->size -=3D r;
>                 mapping->gpa +=3D r;

Ok, I thought the same for the return value. I didn't expand the
arguments to arch code in case in the future we have flags or other
expansions of the struct.

> > > +           if (r)
> > > +                   break;
> > > +
> > > +           cond_resched();
> > > +   }
> > > +
> > > +   srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > > +   vcpu_put(vcpu);
> > > +
> > > +   /* Return success if at least one page was mapped successfully.  =
*/
> > > +   return full_size =3D=3D mapping->size ? r : 0;
>
> I just saw Paolo's update that this is intentional, but this strikes me a=
s odd,
> as it requires userspace to redo the ioctl() to figure out why the last o=
ne failed.

Yeah, the same is true of read() but I don't think it's a problem. If
we get an EINTR, then (unlike KVM_RUN which can change the signal
mask) the signal will be delivered right after the ioctl() returns and
you can just proceed. For EAGAIN you can just proceed in general.

And of course, if RET_PF_RETRY is handled in the kernel then EAGAIN
goes away and the only cause of premature exit can be EINTR.

Paolo

> Not a sticking point, just odd to my eyes.
>


