Return-Path: <kvm+bounces-18227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C203D8D2248
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4FA91C2260A
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C5D174EC7;
	Tue, 28 May 2024 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QTtzbF3K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738427D07D
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916631; cv=none; b=oowEpZLEt9KHt8qmXRci2MsjtpbQ466qjMMqJufl5wQWD8dLJJd17dOP3hRd9/yKi19H3QTBqjWim69UiXv4k5eNQZ1nDjuryI7DMSdO4Twsdh7nmiQqRwVJwc/fMkGWjQz5JeDDb48/6Z6dvvtHEkPydP3hMDwu+W3hkWveVTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916631; c=relaxed/simple;
	bh=e3FzVf5AJyeQVqf03E06CnqFFzFHN47V6kEQF2jfqVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z/3P4CnCQGxQTQGVG7RqxCuToTiBolICthTxrZmcOaZPQ8NyEzy2LE5aLZnr+vdTdvT5WXw7GILvLgeYvIH4IhbXrwj/Geu3hjk+R50xEbDmYLy05bol0RPQtLfK2woTSNh3NTz6s1fEtVGze8EVYCHdvkYwIzpLXOt69U35G6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QTtzbF3K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716916628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/hxDNkDnCmZAjM6loDR2xN7pavIvdCO0j6hC6Uv34c=;
	b=QTtzbF3K49Q6nO0Jpewba7IPvlZlEfHwuFtZXycONWbd3pCzKwZyiteuybr7xgHgyU4T9O
	iIHVQQdX/3bEA89zfGRi9jAEnMBK4FTZpmz1IC3S6FJFZNmjxH7l9b0Uw8QdPBMhPSiSLD
	TJD2NtWmlzl3hFa3hyw3XrTSu2/aMz0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-Fu3H2iozP-iZ9020AC6BOg-1; Tue, 28 May 2024 13:17:06 -0400
X-MC-Unique: Fu3H2iozP-iZ9020AC6BOg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2bdeed3b720so1132280a91.3
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716916626; x=1717521426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/hxDNkDnCmZAjM6loDR2xN7pavIvdCO0j6hC6Uv34c=;
        b=Xzq0aUBx1wbXAPdZhFeZMKbi6iDDJgWB7uUK6xRLIB5aVd9mBQkJQa5zix7X1niNwJ
         og2S3xSLFV3l6K/n9N1rm8TRp+F3Qd2XAFRhcezFtJEBspe3irijWxIEpnxEYFcyNHyh
         Cao+r9wIrzyA3tFUPPuCMQe3JoOjayYqnW1CWHNzzZVZI9Vp9dPCmnVRkIlVmNHr/Z1g
         lh+6my+dKuhd8wZa0j/Hb2xznBlDP5U/RecRTrY/XO0B2UHfJA+c8rXMRtcbqD3ySAsr
         gMVyBoXiwp1Q9MEA9P0+tnWJDRJydiZ/okhr+NaPI41hC82UNoWUjJ9UxKoinQs4vhj3
         pcMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0AHEU3Ghdx92hXZjcJStJowmqCz/Ir8Ht+kXG9f2Gwu3ZhaREOdlbV69RvQZI2EH/MH4A4PuVLUWOCk1Ial2AVP+Z
X-Gm-Message-State: AOJu0YwAh4drzKfBtJqw/D5rXN2RaAjyuAy3Gwzr/RyBV77gkkXwn6bc
	g+g3UdcRmmKlQnRN2uWJqn4lsmgIGSkICbUON+v1gVgPwArC41sgDT796QRjHrvwyKnjq4YWtQo
	imHmehOe0fLsv8Lym8n6GIBaO24gNz+OlpxpafX0lWLA67Z5VyxauovZJdPV232aBCEclvppXa0
	s+yzGIbpSGQnl5yQDzdDot+BOO
X-Received: by 2002:a17:90a:f416:b0:2b3:28be:ddfa with SMTP id 98e67ed59e1d1-2bf5f70ffe2mr12664077a91.38.1716916625813;
        Tue, 28 May 2024 10:17:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJNvQiwEbqAPGDEw/p+fB8WM9nAZhQI2C9xvV1Nfpny+XXfi8DW4ztWFyKNn35QRk+WTuDoPHoKm6BzuHzrFs=
X-Received: by 2002:a17:90a:f416:b0:2b3:28be:ddfa with SMTP id
 98e67ed59e1d1-2bf5f70ffe2mr12664054a91.38.1716916625380; Tue, 28 May 2024
 10:17:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com> <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com> <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com> <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
In-Reply-To: <20240517191630.GC412700@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 19:16:51 +0200
Message-ID: <CABgObfY=RnDFcs8Mxt3RZYmA1nQ24dux3Rhs4hK0ZfeE_OtLUw@mail.gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2024 at 9:16=E2=80=AFPM Isaku Yamahata <isaku.yamahata@inte=
l.com> wrote:
>
> On Fri, May 17, 2024 at 06:16:26PM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
>
> > On Fri, 2024-05-17 at 02:03 -0700, Isaku Yamahata wrote:
> > >
> > > On top of your patch, I created the following patch to remove
> > > kvm_gfn_for_root().
> > > Although I haven't tested it yet, I think the following shows my idea=
.
> > >
> > > - Add gfn_shared_mask to struct tdp_iter.
> > > - Use iter.gfn_shared_mask to determine the starting sptep in the roo=
t.
> > > - Remove kvm_gfn_for_root()
> >
> > I investigated it.
>
> Thanks for looking at it.
>
> > After this, gfn_t's never have shared bit. It's a simple rule. The MMU =
mostly
> > thinks it's operating on a shared root that is mapped at the normal GFN=
. Only
> > the iterator knows that the shared PTEs are actually in a different loc=
ation.
> >
> > There are some negative side effects:
> > 1. The struct kvm_mmu_page's gfn doesn't match it's actual mapping anym=
ore.
> > 2. As a result of above, the code that flushes TLBs for a specific GFN =
will be
> > confused. It won't functionally matter for TDX, just look buggy to see =
flushing
> > code called with the wrong gfn.
>
> flush_remote_tlbs_range() is only for Hyper-V optimization.  In other cas=
es,
> x86_op.flush_remote_tlbs_range =3D NULL or the member isn't defined at co=
mpile
> time.  So the remote tlb flush falls back to flushing whole range.  I don=
't
> expect TDX in hyper-V guest.  I have to admit that the code looks superfi=
cially
> broken and confusing.

You could add an "&& kvm_has_private_root(kvm)" to
kvm_available_flush_remote_tlbs_range(), since
kvm_has_private_root(kvm) is sort of equivalent to "there is no 1:1
correspondence between gfn and PTE to be flushed".

I am conflicted myself, but the upsides below are pretty substantial.

Paolo

> > On the positive effects side:
> > 1. There is code that passes sp->gfn into things that it shouldn't (if =
it has
> > shared bits) like memslot lookups.
> > 2. Also code that passes iter.gfn into things it shouldn't like
> > kvm_mmu_max_mapping_level().
> >
> > These places are not called by TDX, but if you know that gfn's might in=
clude
> > shared bits, then that code looks buggy.
> >
> > I think the solution in the diff is more elegant then before, because i=
t hides
> > what is really going on with the shared root. That is both good and bad=
. Can we
> > accept the downsides?
>
> Kai, do you have any thoughts?
> --
> Isaku Yamahata <isaku.yamahata@intel.com>
>


