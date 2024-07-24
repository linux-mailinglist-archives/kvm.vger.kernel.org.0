Return-Path: <kvm+bounces-22177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABBFB93B5EF
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE2D81C239DE
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7180615FA7E;
	Wed, 24 Jul 2024 17:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtHUxsNH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2292200B7
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842109; cv=none; b=hWhWJH9GnsS0XQebHwazWD8Y+SjqlZQwN+SDiiYAacIyhMdcjuife+yAIIhI60f1NBkmA1WyIMqq8DD9hpGaQUys0+0HkbBhpyOJGeqelfp496vXAT4BJhLAVTTmnqz652HxpTHxaHS8w1Pj+V48Gd9Fx9YInmtMGKzwwvwULK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842109; c=relaxed/simple;
	bh=2VeaS1E/HGfMQix54noAvSkDtEnAk5kpS0dJeN0Sn5o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QDbioxoUzuVvdWao4XQfTfLrespXvVRdwNJ8rnug2MT6ifBfPSVcSBOdVo8vOcPlTGWYDm9RBlXAr1omoyL2kpUmH842w9ro+xcEgfPgh/KGT9pcjL8iiCQAAiGjqSTRW7pEAuqkHNKrnZrxgDRS7yOTUYYZK7co1jnGOQFQ9Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DtHUxsNH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721842106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tDDVV6a2UENDBJXQHwHiykTSex1Gur6QCYekShyFFrU=;
	b=DtHUxsNHO6VAVxL80kBTtpJYeJZCYGUEJUVzd3yQWXMRzGjyJvl/8hzOIlNhwjammj/t1f
	5QMBPkDj74MDgio4eipLJvN5L+3qoUjvj0T9pxhb5JORphbrVqjldWfG0I6otC/V1desQZ
	qU2orZokZBLDHf1VFGgS/y35FBOzfA8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-iGn9siDrOwmDEbqk1zo9hA-1; Wed, 24 Jul 2024 13:28:23 -0400
X-MC-Unique: iGn9siDrOwmDEbqk1zo9hA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44930eb9a96so23901cf.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721842103; x=1722446903;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tDDVV6a2UENDBJXQHwHiykTSex1Gur6QCYekShyFFrU=;
        b=MeGWMbEaQP7/9aBiror5TyhQgVamupGmZskvPePtS6DTMxBbLjvAUIRO+nHVmf6D0R
         lMQtD4zfwwLxWu1lNI2xFQ99qGyYSXnuapYcTBq64HIisMw9Q+tGXUX8Lt5aFr+vfwAZ
         sOfWh48AyaHTcL0EsrndObzwWCKeNJAO8Z7hkZy/akyYvqMMOOMSIO+nkRGBAfnG29DY
         HNuGDRgKwXrIM9bgZEvSQyMwEMk02X8Fb9ZVj02UXGRl1MuZt8DSp7rqoEy1BWC18VAS
         Zma+Q4oq7d5M4gmAqyL8u0fHiVELE41fgJiLZAFNJoeDZv2Rhp2RG0PC/bvlMyYYshqW
         7+ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBardtqEqpczz8thBplZ29mFCYMhI/jW8Wsj5UEsYU4Hsodf+cgHKmcBcz8AZFyaYgUdHC7EHv2lOI6eNoVrdmodoo
X-Gm-Message-State: AOJu0YyWSRFOg/8fNp47+J5Fk02MsOn5aw1/DOps9iELvpiVQCvLYmAz
	qMVB1Dw51OVSqmw6pF6XS+70gkzEpErnauSjNfSO757vQmhmpeW39BVbIidaJ+RTAuYmI2zzWyg
	NkMcg1wrWFaSbd1GKMWYR++OMZouebxW/YnCW/uqoMDm/H8EeqA==
X-Received: by 2002:a05:622a:4a18:b0:44f:e158:3b1c with SMTP id d75a77b69052e-44fe32b7070mr5109541cf.3.1721842103261;
        Wed, 24 Jul 2024 10:28:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZoqWOqTihvmxToAoFhZig9SmHBat3PxjpB4nC6TeoR0n1hYHZ64T19fVeyNzdOpud6JWMzQ==
X-Received: by 2002:a05:622a:4a18:b0:44f:e158:3b1c with SMTP id d75a77b69052e-44fe32b7070mr5109151cf.3.1721842102849;
        Wed, 24 Jul 2024 10:28:22 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44f9cd13b51sm56210551cf.38.2024.07.24.10.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:28:21 -0700 (PDT)
Message-ID: <d3f4ae0dafb9a3ac3fcd7cec5de3dc4285896b82.camel@redhat.com>
Subject: Re: [PATCH v2 03/49] KVM: x86: Account for KVM-reserved CR4 bits
 when passing through CR4 on VMX
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:28:20 -0400
In-Reply-To: <Zo2WbN5m6eI03AW8@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-4-seanjc@google.com>
	 <2c8a398c9899a50c9d8f06fa916eb8eb13b6fbc5.camel@redhat.com>
	 <Zo2WbN5m6eI03AW8@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-09 at 12:58 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > Drop x86.c's local pre-computed cr4_reserved bits and instead fold KVM's
> > > reserved bits into the guest's reserved bits.  This fixes a bug where VMX's
> > > set_cr4_guest_host_mask() fails to account for KVM-reserved bits when
> > > deciding which bits can be passed through to the guest.  In most cases,
> > > letting the guest directly write reserved CR4 bits is ok, i.e. attempting
> > > to set the bit(s) will still #GP, but not if a feature is available in
> > > hardware but explicitly disabled by the host, e.g. if FSGSBASE support is
> > > disabled via "nofsgsbase".
> > > 
> > > Note, the extra overhead of computing host reserved bits every time
> > > userspace sets guest CPUID is negligible.  The feature bits that are
> > > queried are packed nicely into a handful of words, and so checking and
> > > setting each reserved bit costs in the neighborhood of ~5 cycles, i.e. the
> > > total cost will be in the noise even if the number of checked CR4 bits
> > > doubles over the next few years.  In other words, x86 will run out of CR4
> > > bits long before the overhead becomes problematic.
> > 
> > It might be just me, but IMHO this justification is confusing, leading me to
> > belive that maybe the code is on the hot-path instead.
> > 
> > The right justification should be just that this code is in
> > kvm_vcpu_after_set_cpuid is usually (*) only called once per vCPU (twice
> > after your patch #1)
> 
> Ya.  I was trying to capture that even if that weren't true, i.e. even if userspace
> was doing something odd, that the extra cost is irrelevant.  I'll expand and reword
> the paragraph to make it clear this isn't a hot path for any sane userspace.
Thank you!

> 
> > (*) Qemu also calls it, each time vCPU is hotplugged but this doesn't change
> > anything performance wise.
> 
> ...
> 
> > > @@ -9831,10 +9826,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> > >  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> > >  		kvm_caps.supported_xss = 0;
> > >  
> > > -#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> > > -	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> > > -#undef __kvm_cpu_cap_has
> > > -
> > >  	if (kvm_caps.has_tsc_control) {
> > >  		/*
> > >  		 * Make sure the user can only configure tsc_khz values that
> > 
> > I mostly agree with this patch - caching always carries risks and when it doesn't
> > value performance wise, it should always be removed.
> > 
> > 
> > However I don't think that this patch fixes a bug as it claims:
> > 
> > This is the code prior to this patch:
> > 
> > kvm_x86_vendor_init ->
> > 
> > 	r = ops->hardware_setup();
> > 		svm_hardware_setup
> > 			svm_set_cpu_caps + kvm_set_cpu_caps
> > 
> > 		-- or --
> > 
> > 		vmx_hardware_setup ->
> > 			vmx_set_cpu_caps + + kvm_set_cpu_caps
> > 
> > 
> > 	# read from 'kvm_cpu_caps'
> > 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> > 
> > 
> > AFAIK kvm cpu caps are never touched outside of svm_set_cpu_caps/vmx_hardware_setup
> > (they don't depend on some later post-processing, cpuid, etc).
> > 
> > In fact a good refactoring would to make kvm_cpu_caps const after this point,
> > using cast, assert or something like that.
> > 
> > This leads me to believe that cr4_reserved_bits is computed correctly.
> 
> cr4_reserved_bits is computed correctly.  The bug is that cr4_reserved_bits isn't
> consulted by set_cr4_guest_host_mask(), which is what I meant by "KVM-reserved
> bits" in the changelog.

Ah, I see it now.

I also see that set_cr4_guest_host_mask, limits the guest owned bits to a small
whitelist, and none of these bits looks scary, so it all make sense that this
is mostly a theoretical bug, but for sure worth fixing.


> 
> > I could be wrong, but then IMHO it is a very good idea to provide an explanation
> > on how this bug can happen.
> 
> The first paragraph of the changelog tries to do that, and I'm struggling to come
> up with different wording that makes it more clear what's wrong.  Any ideas/suggestions?
> 

I also re-read it, and now it all makes sense. I guess I just somehow got fixed on
thinking that cr4_reserved_bits was not computed incorrectly rather than just
not used.
The comment indeed now makes sense to me, so let it be as it is.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



