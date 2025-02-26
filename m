Return-Path: <kvm+bounces-39354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AD1A469ED
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23D411882D04
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0853722F163;
	Wed, 26 Feb 2025 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HmzauZTc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974E21CC53
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740595149; cv=none; b=VLPS8uznOFP7dNsq1mukknC3JOZ8e43hArUvf00m3d6bGBP8HPq8zzw9sVpnj1tFlfhYRJksFSBu9BiS0Z3fuVIQlsflhMAkwEI2cd5w2/N7lREtQEZwO7/bRixzRi0ilQd6PPtlARiiuqXnPXH94354HcbS+bmuypSonVJ703o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740595149; c=relaxed/simple;
	bh=lKrXR1KGRZSugNM5yC3co97RUFbsdNWdtgCIXHI7OTk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ust8kZLJcgrMBmkcIJh2D7h8r5OMOirixCc8vFQZ3YS1zYShFfAsiMlSB3TbGahLR9B7vgnVrbDIihy9XlRIKUOW7zpHgPjTUo/W51RkNAPlNjRWLIjEL4mquRP/umu7amuTiCXO23KNMSaDrtCWLoQ/rgQqvmkqDXU/X6fXXV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HmzauZTc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740595146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=90eXzmLAT43+01svPMQAHvvPwTa7z+5JsRENaBTrc8I=;
	b=HmzauZTcyi2+35OkqN+04SXSrkEgn6FrdAHAnprn64pIzYt+42amMjm7Uc9bGJo2w4jqMH
	LQWRGbb3XJwM0EEUP9JYnF0N/UeHu6h32flghu+I2I0jjrYf1bAyRQnOau6R/yK5Osy9pj
	tdieVoNCrN+p35epfAVeZ8QVTe9gsAk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-JrEinw21MqGzenmhmo3BVg-1; Wed, 26 Feb 2025 13:39:05 -0500
X-MC-Unique: JrEinw21MqGzenmhmo3BVg-1
X-Mimecast-MFC-AGG-ID: JrEinw21MqGzenmhmo3BVg_1740595145
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e65e656c41so3411266d6.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 10:39:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740595145; x=1741199945;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=90eXzmLAT43+01svPMQAHvvPwTa7z+5JsRENaBTrc8I=;
        b=vIs5MuRKoacijHOMBnDljUXg88T71UEqX5swgErc+i5UB/+qP4S3lkSaZXb9t5QfBt
         Q4K14PA6pKtI/n/bNZhsLwRHtt4sN8WaT2CdycoU3fJY5RQDbTKRv/gNbBJYSC7PYsIr
         toXmlpVSQu4ko5Lp8/7tP61D+OF74+7yjsYFHSPa7GN51EN0i4lTu9IO4T21LDLr/02V
         melXRipVUH28y8VgDPCeso6ctieJfajYsogmeEB6CYJyWejjUVKxxvtJyI7lLUbVyp7H
         BwlKskpdBeH4hyE3dYhV5NMxZ/bscp3qMF8M7jQf5HoJSgijRgTMkVz6/UsZOkkLlgGq
         Emww==
X-Forwarded-Encrypted: i=1; AJvYcCXzo0dRDRB3GefGp0uhsywgBQx9ou4g+CB2urNDIQAj+OKmsUsh2HyBz68LeWtu5PZIUQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHjxgWbtgixg3lbzJOpUpPZNcfpJU4lYseHbacNwW4m7QQph6H
	9tOKcaEJJtowWO9upShStu5VMnkgV63jdoCzGT5LAwBxGwMBI3A/HTYdQuCFIspdH/qWo8GgxHV
	15G3vjygev/5pBci5WUmXygrV1/Wqf82Np2zVOIQH3MlisXyw5Q==
X-Gm-Gg: ASbGnctxZ1l97JQMIfZtKwOY0jEFCohWywV8zhKpLU+9uMwtbcI8HKyKs6t6CJE5HT4
	FEiLFjv4p7KVJ+ry0+4mNlV/L6sZJKGtmuKznyKsq9Q14GBuecuh99bHShhqucSU83k0tRgm7gf
	SZdzGoPwc1u8seQFs18fC5jI5dJdgC0odvuYdy+A1W5hIHsIxTS/m2fiLnxhhHcXveLVuDlmfXC
	hrEQS6PO1cWJTdd0wG87+x4z9Kp/nZN6HA9aP3X4czk0MZRCWC5BQ4yWy3itF3t5ydvbpR2Rekz
	+zvpCDq5va/QVFs=
X-Received: by 2002:a0c:c587:0:b0:6e6:64ce:3111 with SMTP id 6a1803df08f44-6e88689c141mr38637946d6.24.1740595144724;
        Wed, 26 Feb 2025 10:39:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbOz3Tqr6hQCs7COjzgB8TX38rAHvlgqyAvPxtiLWjotGeTAS5snldmdaBWtJva1mdqP5ulQ==
X-Received: by 2002:a0c:c587:0:b0:6e6:64ce:3111 with SMTP id 6a1803df08f44-6e88689c141mr38637786d6.24.1740595144399;
        Wed, 26 Feb 2025 10:39:04 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e87b17194csm25604976d6.97.2025.02.26.10.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 10:39:04 -0800 (PST)
Message-ID: <4c605b4e395a3538d9a2790918b78f4834912d72.camel@redhat.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  David Matlack <dmatlack@google.com>, David Rientjes
 <rientjes@google.com>, Marc Zyngier <maz@kernel.org>,  Oliver Upton
 <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao
 <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2025 13:39:02 -0500
In-Reply-To: <Z75lcJOEFfBMATAf@google.com>
References: <20250204004038.1680123-1-jthoughton@google.com>
	 <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
	 <Z7UwI-9zqnhpmg30@google.com>
	 <07788b85473e24627131ffe1a8d1d01856dd9cb5.camel@redhat.com>
	 <Z75lcJOEFfBMATAf@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-02-25 at 16:50 -0800, Sean Christopherson wrote:
> On Tue, Feb 25, 2025, Maxim Levitsky wrote:
> > On Tue, 2025-02-18 at 17:13 -0800, Sean Christopherson wrote:
> > > My understanding is that the behavior is deliberate.  Per Yu[1], page_idle/bitmap
> > > effectively isn't supported by MGLRU.
> > > 
> > > [1] https://lore.kernel.org/all/CAOUHufZeADNp_y=Ng+acmMMgnTR=ZGFZ7z-m6O47O=CmJauWjw@mail.gmail.com
> > 
> > Hi,
> > 
> > Reading this mail makes me think that the page idle interface isn't really
> > used anymore.
> 
> I'm sure it's still used in production somewhere.  And even if it's being phased
> out in favor of MGLRU, it's still super useful for testing purposes, because it
> gives userspace much more direct control over aging.

I also think that page_idle is used somewhere in production, and it probably works
more or less correctly with regular non VM processes, although I have no idea how well it works
when MGLRU is enabled.

My point was that using page_idle to track guest memory is something that is probably
not used because it doesn't work that well, and nobody seems to complain.
However I don't ask for it to be removed, although a note of deprecation might
be worth it if really nobody uses it.

> 
> > Maybe we should redo the access_tracking_perf_test to only use the MGLRU
> > specific interfaces/mode, and remove its classical page_idle mode altogher?
> 
> I don't want to take a hard dependency on MGLRU (unless page_idle gets fully
> deprecated/removed by the kernel), and I also don't think page_idle is the main
> problem with the test.
>    
> > The point I am trying to get across is that currently
> > access_tracking_perf_test main purpose is to test that page_idle works with
> > secondary paging and the fact is that it doesn't work well due to more that
> > one reason:
> 
> The primary purpose of the test is to measure performance.  Asserting that 90%+
> pages were dirtied is a sanity check, not an outright goal.

From my POV, a performance test can't really be a selftest unless it actually fails
when it detects an unusually low performance. 

Otherwise who is going to be alarmed when a regression happens and
things actually get slower?

> 
> > The mere fact that we don't flush TLB already necessitated hacks like the 90%
> > check, which for example doesn't work nested so another hack was needed, to
> > skip the check completely when hypervisor is detected, etc, etc.
> 
> 100% agreed here.
> 
> > And now as of 6.13, we don't propagate accessed bit when KVM zaps the SPTE at
> > all, which can happen at least in theory due to other reasons than NUMA balancing.
> > 
> > Tomorrow there will be something else that will cause KVM to zap the SPTEs,
> > and the test will fail again, and again...
> > 
> > What do you think?
> 
> What if we make the assertion user controllable?  I.e. let the user opt-out (or
> off-by-default and opt-in) via command line?  We did something similar for the
> rseq test, because the test would run far fewer iterations than expected if the
> vCPU task was migrated to CPU(s) in deep sleep states.
> 
> 	TEST_ASSERT(skip_sanity_check || i > (NR_TASK_MIGRATIONS / 2),
> 		    "Only performed %d KVM_RUNs, task stalled too much?\n\n"
> 		    "  Try disabling deep sleep states to reduce CPU wakeup latency,\n"
> 		    "  e.g. via cpuidle.off=1 or setting /dev/cpu_dma_latency to '0',\n"
> 		    "  or run with -u to disable this sanity check.", i);
> 
> This is quite similar, because as you say, it's impractical for the test to account
> for every possible environmental quirk.

No objections in principle, especially if sanity check is skipped by default, 
although this does sort of defeats the purpose of the check. 
I guess that the check might still be used for developers.


> 
> > > Aha!  I wonder if in the failing case, the vCPU gets migrated to a pCPU on a
> > > different node, and that causes NUMA balancing to go crazy and zap pretty much
> > > all of guest memory.  If that's what's happening, then a better solution for the
> > > NUMA balancing issue would be to affine the vCPU to a single NUMA node (or hard
> > > pin it to a single pCPU?).
> > 
> > Nope. I pinned main thread to  CPU 0 and VM thread to  CPU 1 and the problem
> > persists.  On 6.13, the only way to make the test consistently work is to
> > disable NUMA balancing.
> 
> Well that's odd.  While I'm quite curious as to what's happening, my stance is
> that enabling NUMA balancing with KVM is a terrible idea, so my vote is to sweep
> it under the rug and let the user disable the sanity check.
> 

One thing for sure, with NUMA balancing off, the test passes well (shows on average
around 100-200 idle pages) and I have run it for a long time.


Best regards,
	Maxim Levitsky



