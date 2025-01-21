Return-Path: <kvm+bounces-36143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B16A181CF
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C20F47A5292
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C939C1F4727;
	Tue, 21 Jan 2025 16:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DEqml4Mw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4F0224D7
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476035; cv=none; b=XObomw1nLfzFyJjU6+dGwT82yLBsDGvhkQVH1wkVYbtmClWHieIhDYIgfZIBL6TMTYYESYYO2ggm5g+tg2RHRXSfPty10OTn4oZ2TWLZX5kDmgWtP1zN1ZgK+E/7PWyT9zPJts9faZ9efWXgQ0MsSTxoXYxly29ERKJsXW6z/Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476035; c=relaxed/simple;
	bh=GM7czy+zZ2a/15ERxKVya+gt4AqfDlPsdy7sFT1UIxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=beELwPnK4N5eu1O69Yp8v17NFC1ldfr41KUnmLVadSTF7i73uLCERZDhiI4q0Tp6OhaDsFVGgV1pH+9oPemTcrksZL8HSM7vZOKNq3QnuIdFSWRjviHDy1j+T7cpBVW9DZuV4uErEACLyraZ64b+bGnHvb82o+KaRTNdiZ8Oivw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DEqml4Mw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef6ef9ba3fso10603739a91.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 08:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737476033; x=1738080833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BvpriF+2u2s9kkp5NUdJHhbThP0v/VNSPepec3ecsfs=;
        b=DEqml4MwQqMxWrHLikpbN0oMSkQ21qapv9H+jlUiCpNS5mJu5AgILkbQcohK9y1aC+
         gjtd9pqFeoBbTeV7rN9iMYWeiSk6TebCYlSkSiavjtJHwOjzn6LtCEb3l6qMu95Rq+5X
         wz4i1Fw8kgCZFo3dSJ0FFp33Yf0Unr+xLT4Z5n5w8Bv/LAV8HuRiTdWK4VFiEL3Dl1lq
         cDYbdOtQMsoy3qt2A3tYcDhn96CglKWew7O4YTvfEf9mwmVPl98YX4uA+BLhFAHFgv+b
         YuKF8Y6zK+1t/M9hJD9+93YP38MZ1sJL6RXVTWbyx6dX4BX8agAntgbzS4UMexJ14lak
         pMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737476033; x=1738080833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BvpriF+2u2s9kkp5NUdJHhbThP0v/VNSPepec3ecsfs=;
        b=bWUQoinU5jJxOxBSMSS8mzhk8/7fvS9A1L9UvE7G/LIRosIItAP7pT/hAHpX5q26h9
         kiPTMxD6vRjyO++P23Mjaf/0cYBAOCcsDhE9h6PEjaAXv4v7VNFPqCZANVTnELnTt+OS
         jLBT3MnkqVXIY7NqxtBQb4ZpKrCCWzhrVx93ZT6VlGiiSa5K8MTk4eUokidZxdQJhU8c
         1oHzK5RJ6WNKryUZoBvMyTPxRlXU4Am29CouR/PINb0GblyrjleGOH3d+UIW5Z2yJLMF
         gQd2qk3n7I8EP/cjDEK7ka10UGHqggBbW7iwhQIoB9d+f7jUWsBt6cPd8Y66OHTLMtv9
         e7IA==
X-Forwarded-Encrypted: i=1; AJvYcCVqp+Ap53GghD0D7SahYdaCPgwj9l2EB4MYk8XdrS/Sbj40o3jTmX/jSs2G9q3mcsp9ZW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YySYZKsdzwtiE7NM3YyeLMTqmYoFrfYQqrynWVXzKkuX1DCA9dZ
	MdJ751gYKfjSiM0ZirSvSHJP3Ik3JVOA6vLrL9vHq+74G3FOs1uFzZ6hhEPdLGUQl6FLey1ottw
	qxg==
X-Google-Smtp-Source: AGHT+IHfNc3oTB8Nb5L5q4f7wjaoPuPv56eNR/pXP8N9c2jx8SbzgPgfcQWIeZ9uEUsm66SqLt//O2HeyS4=
X-Received: from pfbch12.prod.google.com ([2002:a05:6a00:288c:b0:725:f14a:b57c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8013:b0:725:8c0f:6fa3
 with SMTP id d2e1a72fcca58-72dafbaae38mr24391174b3a.22.1737476032849; Tue, 21
 Jan 2025 08:13:52 -0800 (PST)
Date: Tue, 21 Jan 2025 08:13:51 -0800
In-Reply-To: <c1ce77cd-8921-402d-87b2-fd3fa11add4d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202501141009.30c629b4-lkp@intel.com> <Z4a_PmUVVmUtOd4p@google.com>
 <a2adf1b8-c394-4741-a42b-32288657b07e@linux.intel.com> <6c23d536-484f-4c4b-aa85-3e0b9544611a@linux.intel.com>
 <Z4qPWNscnU9-b30n@google.com> <c1ce77cd-8921-402d-87b2-fd3fa11add4d@linux.intel.com>
Message-ID: <Z4_HvwSYX592oQ5s@google.com>
Subject: Re: [linux-next:master] [KVM] 7803339fa9: kernel-selftests.kvm.pmu_counters_test.fail
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kernel test robot <oliver.sang@intel.com>, g@google.com, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	xudong.hao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Dapeng Mi wrote:
> On 1/18/2025 1:11 AM, Sean Christopherson wrote:
> > @@ -98,14 +149,12 @@ static uint8_t guest_get_pmu_version(void)
> >   * Sanity check that in all cases, the event doesn't count when it's disabled,
> >   * and that KVM correctly emulates the write of an arbitrary value.
> >   */
> > -static void guest_assert_event_count(uint8_t idx,
> > -				     struct kvm_x86_pmu_feature event,
> > -				     uint32_t pmc, uint32_t pmc_msr)
> > +static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr)
> >  {
> >  	uint64_t count;
> >  
> >  	count = _rdpmc(pmc);
> > -	if (!this_pmu_has(event))
> > +	if (!(hardware_pmu_arch_events & BIT(idx)))
> >  		goto sanity_checks;
> >  
> >  	switch (idx) {
> > @@ -126,7 +175,9 @@ static void guest_assert_event_count(uint8_t idx,
> >  		GUEST_ASSERT_NE(count, 0);
> >  		break;
> >  	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
> > -		GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
> > +		__GUEST_ASSERT(count < NUM_INSNS_RETIRED,
> 
> shouldn't be "__GUEST_ASSERT(count >= NUM_INSNS_RETIRED," ?

Yes.  I had intentionally inverted the check to verify the assert message and
forgot to flip it back before hitting "send".  Thankfully, I didn't forget before
posting formally[*].  Ugh, but I did forget to Cc you on that series, sorry :-/

[*] https://lore.kernel.org/all/20250117234204.2600624-6-seanjc@google.com

