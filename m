Return-Path: <kvm+bounces-52352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF504B04814
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 21:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D476C1A658D1
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 19:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E459923958A;
	Mon, 14 Jul 2025 19:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mrV7aq1d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDB21CD1F
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752522588; cv=none; b=gqED6I8RgCjxDwUn0Zt1vBy5xKdJDSFSaJR3WvSrXhqrcvN3zYw4LkSRNl7xGUct1jKzycvnCdiEhzyrvDUVRqdydZwYpWkr293WIwIL9EkAS1pdPr3oqe2muqcHBtPRd82cKvne0xWET0e6Ieo47sW64EtcCxtX6AiPK7s4KRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752522588; c=relaxed/simple;
	bh=yWOqjM+tnJXB+iS8z8RSLG6VbltiE5lZkB4fv77IZdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SZlCS/rYQAkJpX4+nUeF4yBtwaETKjgLuS7Jbr0EHaozvy4Bxfy/XYnwOrEz/jLyBB3M9PAG1dceHqUBfwoG3N7/DOLnSETbJBZbD6c1DDpBKeg0OH00u/CM7ATPFz00zygn8mf5q6aaAy1Wcztk9z6em2Q0NkyCel8doa7rLuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mrV7aq1d; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115fb801bcso4994780a12.3
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 12:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752522586; x=1753127386; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ICcg0kScB2Zwj8UqwZwwX6H3Hb3sbc2THMrldLCPfAE=;
        b=mrV7aq1dFqDxTapv8jzGX8ekE7CbCBPrU54VhTHi7AiBfBjispbdVQbQ5/J2l7xTLs
         ETphmykk5WEbzRoYKXK57QDPxsm2TcXZ+WnShdd8GA0jdmoxnQXMyjMTkRd3+B+5GRPY
         eVSLY8IBW00BWNfacBDeW5cNIXm9Un+hxXCcC4ZjSM6E/MzQGAK5CZGpE244jZtK7YYc
         UIlpmjC2rHto2Ksxv02HJ7gjjlpFFLyRl3KHHpvhhmgO1yNPn92tc9xYX6IHnTqe6AWX
         A2spY2bSkjZvtNUlQhAx+5GXl+qWEjFk+hl1cxZdTQ3deZVAyPZdKPZP50AXph+yGGbC
         RzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752522586; x=1753127386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ICcg0kScB2Zwj8UqwZwwX6H3Hb3sbc2THMrldLCPfAE=;
        b=rsoiTKG2/hARX8faZaKaRk+1WEyOHNoMejvedtQxh6uHDpkVyj01u9q2o4YZmKdJE+
         j/75xy8+yShYbnGgBJJtKPpkHuaX7Lj4kLl7POqvy7pRjbq9pnsQnzLsSfqJsD1djYVh
         gOnAutSSqWYX1+i62HOAK8LspxqTlKPOBdnfVRpr2mYMjvw/8zUPlpfxVcopp93mw58c
         IM2s1GVFqGFEgJ01c3iGtL9MuC03/dgS9ZFZc4ukW6/ekInveJKeBfhpURKm8F7NVK7/
         1byoARyRuf9NkF9CCLr8X79ak1fsHpgT3z2MH+YUjrkTx4U7csarRrp4pQtA+J2IWN2P
         wzFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAoCiIebcw5BH4YrqET7iD3wvRpuBNNxBj0L94HDGhvxabVgSSxhh72wpRcyiLqvFlyqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMgys2V/4ZhTQlJFEyeA0LRWxSfKiTcM/4sx/emrJKtA7VDYLD
	0T56bgUOTu04eVg6isXaRfChh42ZWFbJhF/YBWWSLMyCru8vIVoG7fmafpvV+lYdngZ9Nem1cpb
	XE73l2b4rpx1KEZsa6anstdWZTg==
X-Google-Smtp-Source: AGHT+IHYRx34pwTQ1/zxuK41iVUIxojsyjeG9fu7hIcirB2HtzSq/CDTqyAKgWSVpxntbG5X9IzCGePZMY1LK4n9RA==
X-Received: from pfblm11.prod.google.com ([2002:a05:6a00:3c8b:b0:748:f270:c438])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7f8e:b0:1f5:79c4:5da6 with SMTP id adf61e73a8af0-2311dc59daemr19721553637.5.1752522585949;
 Mon, 14 Jul 2025 12:49:45 -0700 (PDT)
Date: Mon, 14 Jul 2025 12:49:44 -0700
In-Reply-To: <4c70424ab8bc076142e5f6e8423f207539602ff1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com> <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com> <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com> <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
 <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com> <53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com>
 <aHCdRF10S0fU/EY2@yzhao56-desk> <4c70424ab8bc076142e5f6e8423f207539602ff1.camel@intel.com>
Message-ID: <diqzikju4ko7.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Du, Fan" <fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tabba@google.com" <tabba@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Fri, 2025-07-11 at 13:12 +0800, Yan Zhao wrote:
>> > Yan, is that your recollection? I guess the other points were that although
>> > TDX
>> I'm ok if KVM_BUG_ON() is considered loud enough to warn about the rare
>> potential corruption, thereby making TDX less special.
>> 
>> > doesn't need it today, for long term, userspace ABI around invalidations
>> > should
>> > support failure. But the actual gmem/kvm interface for this can be figured
>> > out
>> Could we elaborate what're included in userspace ABI around invalidations?
>
> Let's see what Ackerley says.
>

There's no specific invalidation command for ioctl but I assume you're
referring to the conversion ioctl?

There is a conversion ioctl planned for guest_memfd and the conversion
ioctl can return an error. The process of conversion involves
invalidating the memory that is to be converted, and for now,
guest_memfd assumes unmapping is successful (like Yan says), but that
can be changed.

>> 
>> I'm a bit confused as I think the userspace ABI today supports failure
>> already.
>> 
>> Currently, the unmap API between gmem and KVM does not support failure.
>
> Great. I'm just trying to summarize the internal conversations. I think the
> point was for a future looking user ABI, supporting failure is important. But we
> don't need the KVM/gmem interface figured out yet.
>

I'm onboard here. So "do nothing" means if there is a TDX unmap failure,

+ KVM_BUG_ON() and hence the TD in question stops running,
    + No more conversions will be possible for this TD since the TD
      stops running.
    + Other TDs can continue running?
+ No refcounts will be taken for the folio/page where the memory failure
  happened.
+ No other indication (including HWpoison) anywhere in folio/page to
  indicate this happened.
+ To round this topic up, do we do anything else as part of "do nothing"
  that I missed? Is there any record in the TDX module (TDX module
  itself, not within the kernel)?

I'll probably be okay with an answer like "won't know what will happen",
but just checking - what might happen if this page that had an unmap
failure gets reused? Suppose the KVM_BUG_ON() is noted but somehow we
couldn't get to the machine in time and the machine continues to serve,
and the memory is used by 

1. Some other non-VM user, something else entirely, say a database?
2. Some new non-TDX VM?
3. Some new TD?


>> 
>> In the future, we hope gmem can check if KVM allows a page to be unmapped
>> before
>> triggering the actual unmap.

