Return-Path: <kvm+bounces-57110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11ADEB4FF25
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1E4E1885988
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 14:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6343D3451B3;
	Tue,  9 Sep 2025 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k5oVGOib"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FEB1E5718
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427506; cv=none; b=WwmEDdTMDe2Bgs7f7rNoA+ym4Qyu2A34HXYazYoYAr/KxcTY+ZvEIV5ndHQnnvpLo0fr5kp9ikoPXrdGeZCRPNGy3IWTFeyp3C0BOgxOAHt6eW02gZfrzsLLjq7X7ZMVYmtdiYYN4V2wXk+9O2Gt2EvchQs2SB+Ln1u4DW10sA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427506; c=relaxed/simple;
	bh=nr6jAAPv1DstOpTATAmpLEi+i/7+vIDpb7U41NZDK3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cqRb5jRS1YdPUYxjkmXSeo77qAamyaJ+a5CmY4WU9HImbx8hdaBDn0scOv1ZufvN17F3ehs7fKHVoNIo+ootavvQRBdjZBpnG3eyGQxbOXuBzU0Dd731dxxlN7/8jqUdrcZycafzgfbkTW8LU/k2SwdKEICGjbdFgFF2kyyreIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k5oVGOib; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471737c5efso4100986a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 07:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757427504; x=1758032304; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uNEX+HX4i8Zee6p5GwSFppRRtMTU8aAW6YWdaSYbVnQ=;
        b=k5oVGOibIlUXK9X++g0buH1qTTEGAq8Ducb+XoDrL4b00u4ugoM7bty5K8VptnWbX6
         +SjTpo0H04jF8Xc5SM+4jF7kIgGu6+YyBHHExCV+zMooM8ozVLcllR72QXfORXvYJn24
         cZldndPhcl+pVfkIFOuuuFPUXx2IqoapFxL35uPGN3CZcmiXPfTUzBY9vemcBKzFhm2a
         fnFJZ3lvGFGvMr7Yj08OFbZoEvynWBbY7qz13YnFjmux7ZRhce5zRETavU0/Rf8jigxs
         bsVN764kBoC6rWIiZ9Hp2MnHxgl6bKZktGdPhKJw4EDaDb3j5qQGi3yeWxa9MKe66SyZ
         wIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757427504; x=1758032304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uNEX+HX4i8Zee6p5GwSFppRRtMTU8aAW6YWdaSYbVnQ=;
        b=RKkYN0HrM2x8vaKJi7PAhB4+UEJsmSv8uvWtjGByn/WhyoE427V8MKAEcBQw1m7GiF
         sWvp1MWCt6JroTxbeiSkZth56FfAiXIIo49yXa+UmxBVS+zBY6UhFbYX8gQXzbxXrq0M
         xL7IOI+kXCdt3e5vuvxLWNRmdiH2S7PrAjN5J4W7IxoDPDasiXJuCXuumcGW1f+QzBc+
         0eTxvJU/fPKnAVcZpDCOUe+t2fk6uesXYp7h4+dr45lOyWP8YBSfPEWucYhTbjmFaHOB
         XD0hNGIpOezWz9W396dJscwl52sd25nlsrLwvpkBq7COhTV7ouBbEBjSm4ewyvG+o5oq
         +/xA==
X-Forwarded-Encrypted: i=1; AJvYcCV6DWMyg2OCjmBFckafhKb8nrKeVgYvpBdzt07e/QWoKYXeevwHoixJyGXPb7eRZwPhKZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuuv573szRtmPYoiyvgqAYTQip7cyBdYEtMmrRHl/dMZNojiHt
	XuJi4EFc246YDs7ca2YJ2vnBvjpwISI8kQlrN98vB/qaiBE6PHcQ/zOrpvFilEwHlBTE1JQjiNB
	FpTOj4A==
X-Google-Smtp-Source: AGHT+IGjBKRuus6AQPq5wORgSoqZJ5Tvjrd4h24fLb2PTkSPtnUoSNeAfh5TUD6Fe2fxb8hp+hqfCAOt00c=
X-Received: from pjm15.prod.google.com ([2002:a17:90b:2fcf:b0:31e:3c57:ffc8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f786:b0:24b:74da:6273
 with SMTP id d9443c01a7336-2516f04e031mr162886165ad.3.1757427504302; Tue, 09
 Sep 2025 07:18:24 -0700 (PDT)
Date: Tue, 9 Sep 2025 07:18:22 -0700
In-Reply-To: <2257f7a6-e4f5-4b90-bb18-cb0af756323f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822070305.26427-1-yan.y.zhao@intel.com> <20250822070523.26495-1-yan.y.zhao@intel.com>
 <2257f7a6-e4f5-4b90-bb18-cb0af756323f@linux.intel.com>
Message-ID: <aMA3LjGP9nezNM7e@google.com>
Subject: Re: [PATCH v2 2/3] KVM: TDX: Do not retry locally when the retry is
 caused by invalid memslot
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, reinette.chatre@intel.com, 
	rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 09, 2025, Binbin Wu wrote:
> On 8/22/2025 3:05 PM, Yan Zhao wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 6784aaaced87..de2c4bb36069 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1992,6 +1992,11 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   	 * blocked by TDs, false positives are inevitable i.e., KVM may re-enter
> >   	 * the guest even if the IRQ/NMI can't be delivered.
> >   	 *
> > +	 * Breaking out of the local retries if a retry is caused by faulting
> > +	 * in an invalid memslot (indicating the slot is under removal), so that
> > +	 * the slot removal will not be blocked due to waiting for releasing
> > +	 * SRCU lock in the VMExit handler.
> > +	 *
> >   	 * Note: even without breaking out of local retries, zero-step
> >   	 * mitigation may still occur due to
> >   	 * - invoking of TDH.VP.ENTER after KVM_EXIT_MEMORY_FAULT,
> > @@ -2002,6 +2007,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   	 * handle retries locally in their EPT violation handlers.
> >   	 */
> >   	while (1) {
> > +		struct kvm_memory_slot *slot;
> > +
> >   		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> >   		if (ret != RET_PF_RETRY || !local_retry)
> > @@ -2015,6 +2022,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   			break;
> >   		}
> > +		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> > +		if (slot && slot->flags & KVM_MEMSLOT_INVALID)
> 
> The slot couldn't be NULL here, right?

Uh, hmm.  It could be NULL.  If the memslot deletion starts concurrently with the
S-EPT violation, then the memslot could be transitioned to INVALID (prepared for
deletion) prior to the vCPU acquiring SRCU after the VM-Exit.  Memslot deletion
could then assign to kvm->memslots with a NULL memslot.

  vCPU                          DELETE
  S-EPT Violation
                                Set KVM_MEMSLOT_INVALID
                                synchronize_srcu_expedited()
  Acquire SRCU
  __vmx_handle_ept_violation()
  RET_PF_RETRY due to INVALID
                                Set memslot NULL
  kvm_vcpu_gfn_to_memslot()

