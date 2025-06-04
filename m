Return-Path: <kvm+bounces-48426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2ACACE238
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 804DD1742E7
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A5E1DFE12;
	Wed,  4 Jun 2025 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P+brBL3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521291DED66
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749054505; cv=none; b=QfPUnFyPzyyLESUTd0enYMMDaFHh15UiUONNSK0nFmJdCltQuXVPFtLuNOzSo6Xz7FnYWxT+tE+Ix3YObLoZYd/qzzg4QtofZxhxm804hKGAJdrJPoys3Evkl8KtxlxPJYrtbrXurP/0hXw+ehYW5bkOk32YCxii6poOk8OSwkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749054505; c=relaxed/simple;
	bh=ZJyIckFTExpj1Y90auHWc4FV90jywqVwpSKCRNl8zVM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ivpLboILITFsfy/mZBX7fDypL4Z8IP/CExWr9xRptL1yb/iIBjtbpKvmwsJkYRrPSgFgmS2DW4hGDVLEOczuAZeibsTn3/4cgmyFEDMvfdWRT8H9y9pu/bTQUl/oxMGkCB7zPAnFls+3QDjFAPf8/rnxdLGmyb4X1jGz0EHcimA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P+brBL3G; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312436c2224so55109a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 09:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749054503; x=1749659303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/PzlSGATB5QLnfIO/9xMz9wdcBK9gS0k4KlE7K+2X4=;
        b=P+brBL3GL+WkCqCZG73OPSkr1aeaFNiXEruGWSKDXLPmxdiJxBfu+xZmMeMYQDOBrN
         yvWoBMvhf/SjodiTb13kEGg2iIDG584yORArRgQH+6CoLI19I2RV4d4xtdB5u/F2ofvI
         bUlWii+utYBh0MBoiBqrZdFPijc4gPRPGFtcS/bsHY9oLzPKdK3YHlQAFT1OYD4ujQjV
         hKOcDzPyEKp0N4kjG6bHYhk1gAXCnsRiYgfQs1nP0Fc3dx2BHPiwqMFbYoRONDWoaAwh
         hQQCjMbDCE/yck5DLAi33NsXJzp/w0xPVznk10EgLQB9PfgBxE9JAM3f8kvl4/AXkY+A
         o9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749054503; x=1749659303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/PzlSGATB5QLnfIO/9xMz9wdcBK9gS0k4KlE7K+2X4=;
        b=OFFZlYdpDCrIbhOu4c69zJGwF+5i+Z06ANXYVpTqel+rE1Mv43rIpwQYZpaJAr/YVn
         UXepUsjdQXxeumMcXNA1jTns7M1oXoBwc1pjQRYgz1gAWJBFJ3TC+59dFZc81e5V0U9q
         5Xc/eRSpWdxgXp6TKoblzwbL71HC7ol44lbRttsmdRru47nURvpi9XY12Za32MIUyjgN
         NK1iOPHeIFCWUyne5XNi6zyeBxHLUu+NuKvJPgPvLA31K+uP/G5htr4DUUj8cZttQNe0
         +DN0JXtbjhsEa0stNk+L2snZZhykJfomX9Rqt+XXvnsLTv0qyacXBasWtI2nag3GjFRs
         PGrA==
X-Gm-Message-State: AOJu0YyGTxgxcxmhagIsBPb01GpTtdBEsTEmtAtqS5+ISzipQpS04HkN
	kxqWyAjrrjygtzSDxX5e2tVbqAXzI9dJMlUbV/+8pDPObM40oYQmdx/sA0X7h53gdrmX3zPkpHW
	f4OfK4w==
X-Google-Smtp-Source: AGHT+IEKjmRcgY92eBfv/tMGluyG//CiEtS2rija0phY6qR/oNwBHkY8e9r7FMkUXjtbaeAfSjA+T/QL5JE=
X-Received: from pfjt21.prod.google.com ([2002:a05:6a00:21d5:b0:747:a97f:513f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a24b:b0:1f5:a577:dd10
 with SMTP id adf61e73a8af0-21d22c86371mr6166950637.36.1749054503567; Wed, 04
 Jun 2025 09:28:23 -0700 (PDT)
Date: Wed, 4 Jun 2025 09:28:21 -0700
In-Reply-To: <a9f3f64c-2f82-40b0-80c0-ed1482861dc2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-26-seanjc@google.com>
 <a9f3f64c-2f82-40b0-80c0-ed1482861dc2@redhat.com>
Message-ID: <aEB0JZJNs3dDZWJx@google.com>
Subject: Re: [PATCH 25/28] KVM: nSVM: Access MSRPM in 4-byte chunks only for
 merging L0 and L1 bitmaps
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 04, 2025, Paolo Bonzini wrote:
> On 5/30/25 01:40, Sean Christopherson wrote:
> > @@ -1363,8 +1357,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
> >   static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
> >   {
> > -	u32 offset, msr, value;
> > -	int write, mask;
> > +	u32 offset, msr;
> > +	int write;
> > +	u8 value;
> >   	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
> >   		return NESTED_EXIT_HOST;
> > @@ -1372,18 +1367,15 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
> >   	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
> >   	offset = svm_msrpm_offset(msr);
> >   	write  = svm->vmcb->control.exit_info_1 & 1;
> > -	mask   = 1 << ((2 * (msr & 0xf)) + write);
> 
> This is wrong.  The bit to read isn't always bit 0 or bit 1, therefore mask
> needs to remain.

/facepalm

Duh.  I managed to forget that multiple MSRs are packed into a byte.  Hrm, which
means our nSVM test is even more worthless than I thought.  I'll see if I can get
it to detect this bug.

