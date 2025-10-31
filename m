Return-Path: <kvm+bounces-61649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E83C2363B
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 07:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5C7C3ADAB6
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 06:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C402F8BD9;
	Fri, 31 Oct 2025 06:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZxFcScXu"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8712F7442;
	Fri, 31 Oct 2025 06:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761892094; cv=none; b=qvpkBHVmGzJgEMdctGrm22SSn/WNqRG48DKHvhzTHR+BW8jQpq8PinwF4hsT6LU6PepvmiSNG8LtyYG2GL+Aic2CsG78PGBVHg2a9cbEgnFPQ6vMI8dk+M181GVetPh2DTkxjI30CnfBkbds8XavevoUFKMWt3Frx/00/dSsn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761892094; c=relaxed/simple;
	bh=qZ8sSAg6LdTukdSO3xRwYSH4xcCqgQuncnsp6QO9xMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BaQGxQ2S2p1vo15mgHqypWriRqq6X73COm9qLvNCN/4GjubzvpI+UhV9s7GFTj9IquYQg+N5CyQGhcRmt/3iyEYpM42PK90DIpt0KgkVRj/wlhCLHToG9BM5QMQq5MYvUKysKmW0s+LO8RBOIaYLkGLwb5NIMcda/0gU1IqSkvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZxFcScXu; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761892088; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=8Syu7VWqGIYQ5g2Y0bYBRZ9HkZTN3zBj8saulIxh9yA=;
	b=ZxFcScXu9o8pKoyFXmsKHvUqc8L1kD7xEfQx3rrfhDF7ghHEGs78LX7ATerNGzsFhIpC6qyVxXYey3cVWlUZ1ycS2P1Cl5s/tXZ8UXzksugowv1Vgjg+gZJg6eufkQn2qkuaahqPyCAyRTwXa2Uc6MNXdiexQzHDIb8H2cafz0g=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WrO49tQ_1761892088 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Oct 2025 14:28:08 +0800
Date: Fri, 31 Oct 2025 14:28:07 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix an FPU+CET splat
Message-ID: <sr4fifgvdqmjg54waukwtfaws3vdblgsb5vtfxpp3crfwzbtzf@wzjlefmpc7vb>
References: <20251030185802.3375059-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030185802.3375059-1-seanjc@google.com>

On Thu, Oct 30, 2025 at 11:58:00AM +0800, Sean Christopherson wrote:
> Fix a explosion found via syzkaller+KASAN where KVM attempts to "put" an
> FPU without first having loading the FPU.  The underlying problem is the
> ugly hack for dealing with INIT being processed during MP_STATE.
>
> KVM needs to ensure the FPU state is resident in memory in order to clear
> MPX and CET state.  In most cases, INIT is emulated during KVM_RUN, and so
> KVM needs to put the FPU.  But for MP_STATE, the FPU doesn't need to be
> loaded, and so isn't.  Except when KVM predicts that the FPU will be
> unloaded.  CET enabling updated the "put" path but missed the prediction
> logic in MP_STATE.
>
> Rip out the ugly hack and instead do the obvious-in-hindsight thing of
> checking if the FPU is loaded (or not).  To retain a sanity check, e.g.
> that the FPU is loaded as expected during KVM_RUN, WARN if the FPU being
> loaded and the vCPU wanting to run aren't equal.
>
> Sean Christopherson (2):
>   KVM: x86: Unload "FPU" state on INIT if and only if its currently
>     in-use
>   KVM: x86: Harden KVM against imbalanced load/put of guest FPU state
>
>  arch/x86/kvm/x86.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
>
With my experience on KVM AMX related issue debugging before, and revisit
the kvm_load_guest_fpu() today:

Reviewed-by: Yao Yuan <yaoyuan@linux.alibaba.com>

>
> base-commit: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
> --
> 2.51.1.930.gacf6e81ea2-goog
>

