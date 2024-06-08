Return-Path: <kvm+bounces-19115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C0F9010FA
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 11:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39B4A1F220CB
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 09:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615F2176FA2;
	Sat,  8 Jun 2024 09:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VDOqJQTi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCBC14286
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 09:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717837721; cv=none; b=FQlPvuJv2RJZVKDI1S5gHogf1pe94fWBqPXhCYBHC6J2pas4Sje7fIyFo+Tgl1+7Gg/2zblrVYUU88YzizD0v1tWJmZrfYnWuuiknCseNYKkiRv44NNrEA8M6tWFkXXXRodRlGJB3gXpGhViYZ6M10JXLczuo8BepF46H/NvRUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717837721; c=relaxed/simple;
	bh=GIRP//dzab7VaRyBtp8xO96ILd6erraF5mLo9wV+U8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQltW0n1eK+LBPSFkTVtwTakje5Gab3TNoa7DozxAtx928f6zGWfW7YB9jBRYAeMwUK+b369eB+sDkyPQrDVQ3UXbN4mCjLdnVZFjwU01OwHETiy6TR1rAs81UtAZ38IJ0HMJf4Z68i0pRCnpAa7Oc8GCelKPpdY53zcxTUy9Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VDOqJQTi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717837719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=asBlPx5Iz1CExNOh704ZiH+RVcx5UXxHaSGLztsg/bI=;
	b=VDOqJQTi/Qid1Yx4l2eQe8VI1NWyST3V8cq3p7/Lq54EScEwRqnQgaVBtN5xrbrfED7L64
	OwO8X1RDmflbeNOQp119G+YnLB11Fobq2ZkLX4OElc2+taT8mxpvOGpV+aHraXhHM0k5gX
	Uv6CmhO8g6mhVVha4zku2rzFdMlU6hk=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-Ro6PDRtvNVWKo0fCpzBoqQ-1; Sat, 08 Jun 2024 05:08:36 -0400
X-MC-Unique: Ro6PDRtvNVWKo0fCpzBoqQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6fc395e8808so2776399b3a.0
        for <kvm@vger.kernel.org>; Sat, 08 Jun 2024 02:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717837716; x=1718442516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asBlPx5Iz1CExNOh704ZiH+RVcx5UXxHaSGLztsg/bI=;
        b=SoW30Ni5XrH/hiiCn1n4wRMxWSOtvSxCP+g0tTTHXBbfHvCvGxQTlfTmj4Iokv1hk0
         TnsqR3Ff/XqvUad2Q5Gf3jBkYWrJRzTrsT2fZwSr5vmmlYp0ZF8XrQVmtasTg+cmew7q
         KuNm+WagWYDx8FBRYORx7J00yTLCNj0w68EwRgkzcEol7QbASpgUGPKZsizDGLe1CzY7
         t9nNVdp5WZUeh6eoB6NfTfd7cvj0R8l0U0ssekFSP6prRsNrje0sCTJxNe0PM82afIW6
         VTvGr9CrDAziHT88RAzac5eh7E7XDaMkMrTW2Wu1KvdT14nE0L/FxVYiYTtod8yyQ7Dq
         KHKw==
X-Forwarded-Encrypted: i=1; AJvYcCUB6809+pdAuoPznR1E5kJRwKFRidCz5AyI4mIV4ogYEzEV6Z1queWtqqVZOgf9F4WLmLW8xPrXRs5xRZXLu/TNeYX4
X-Gm-Message-State: AOJu0Yzsi2Ub3oQDuQoRGzIvadKjd7ULSreH6Ub0B8pRFyfCFR8C2JYg
	ObxnKKm9eU2XsEzhDYJESUFPTmSCjE0TzoFhAtReZ7ETC/yyy6gmWS7fOJvPbeApGPcwN1odG73
	MSeYaQSmk7qeG0gv+OJh8SyLkWxQwERtVXVBKFX+Z53v04hbluUzX6OBGMiYtJt6msXphz+wuYI
	vAT3EVJJRjFEGnGkGn/ezZhdpy
X-Received: by 2002:a05:6a20:9708:b0:1b0:18d1:c46c with SMTP id adf61e73a8af0-1b2f9aaf538mr3497916637.27.1717837715776;
        Sat, 08 Jun 2024 02:08:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsJMcYnCoDb0lbi+a8iMAYVK1/qeH4UoRjYuS06qHskAR4MrsrwIZYHaOUAAPtSqtyfWoiQOMm7faTY2oZNZE=
X-Received: by 2002:a05:6a20:9708:b0:1b0:18d1:c46c with SMTP id
 adf61e73a8af0-1b2f9aaf538mr3497906637.27.1717837715440; Sat, 08 Jun 2024
 02:08:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-7-rick.p.edgecombe@intel.com> <CABgObfZuv45Bphz=VLCO4AF=W+iQbmMbNVk4Q0CAsVd+sqfJLw@mail.gmail.com>
 <9423e6b83523c0a3828a88f38ffc3275a08e11dd.camel@intel.com>
In-Reply-To: <9423e6b83523c0a3828a88f38ffc3275a08e11dd.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 8 Jun 2024 11:08:21 +0200
Message-ID: <CABgObfbGeMoKKEMwY6108Z5UT1y=NzRhg-oBC-jpEpugD5_=Mg@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 8:39=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> > I think the code need not check kvm_gfn_direct_mask() here? In the old
> > patches that I have it check kvm_gfn_direct_mask() in the vmx/main.c
> > callback.
>
> You mean a VMX/TDX implementation of flush_remote_tlbs_range that just re=
turns
> -EOPNOTSUPP? Which version of the patches is this? I couldn't find anythi=
ng like
> that.

Something from Intel's GitHub, roughly June 2023... Looking at the
whole history, it starts with

     if (!kvm_x86_ops.flush_remote_tlbs_range)
         return -EOPNOTSUPP;

     return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages=
);

and it only assigns the callback in vmx.c (not main.c); then it adds
an implementation of the callback for TDX that has:

static int vt_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
gfn_t nr_pages)
{
        if (is_td(kvm))
                return tdx_sept_flush_remote_tlbs_range(kvm, gfn, nr_pages)=
;

        /* fallback to flush_remote_tlbs method */
        return -EOPNOTSUPP;
}

where the callback knows that it should flush both private GFN and
shared GFN. So I didn't remember it correctly, but still there is no
check for the presence of direct-mapping bits.

> The downside would be wider distribution of the concerns for dealing with
> multiple aliases for a GFN. Currently, the behavior to have multiple alia=
ses is
> implemented in core MMU code. While it's fine to pollute tdx.c with TDX s=
pecific
> knowledge of course, removing the handling of this corner from mmu.c migh=
t make
> it less understandable for non-tdx readers who are working in MMU code.
> Basically, if a concept fits into some non-TDX abstraction like this, hav=
ing it
> in core code seems the better default to me.

I am not sure why it's an MMU concept that "if you offset the shared
mappings you cannot implement flush_remote_tlbs_range". It seems more
like, you need to know what you're doing?

Right now it makes no difference because you don't set the callback;
but if you ever wanted to implement flush_remote_tlbs_range as an
optimization you'd have to remove the condition from the "if". So it's
better not to have it in the first place.

Perhaps add a comment instead, like:

     if (!kvm_x86_ops.flush_remote_tlbs_range)
         return -EOPNOTSUPP;

+    /*
+     * If applicable, the callback should flush GFNs both with and without
+     * the direct-mapping bits.
+     */
     return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages=
);

Paolo


