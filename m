Return-Path: <kvm+bounces-57119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9099CB50339
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49BF93B9114
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB9A35AAA8;
	Tue,  9 Sep 2025 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DA0HipQ2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A996031B116;
	Tue,  9 Sep 2025 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757436764; cv=none; b=gPats/vdqdrcNZeTvLqYcHaqcCdknmc72eQLaFaNCYpuRJKXZIJPDDg7frM9Xzt/+pfeMlwLK1Ij5VkCNM+jIRKpCsbVdpCwaPupYqMF6+GsqYcu5DTYiYANVqbHCGId2kz+RbTLEmmpbuDfQCWnfqHHhnfn81ne2ePILjo02wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757436764; c=relaxed/simple;
	bh=aD3RSi0sAefzgIScMQ42P+fDuZ6fZGW8SpuvjjA50Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgIV+sB9pcK3JLJURo3T7NbRK9A60xVyPC5FPstkoiv1iTntrK0lL4Kp0o4jYEHiLLs5T/uJGWGmXgYuUvJHfWeRheuQ05/PgPm/J4EjZLdZrEDoabSj0my2zdtkrOShEwUwbGtV21Zx4huD6t3I7trrEYrNwe4BR4q4clmPBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DA0HipQ2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C78C4CEF4;
	Tue,  9 Sep 2025 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757436764;
	bh=aD3RSi0sAefzgIScMQ42P+fDuZ6fZGW8SpuvjjA50Gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DA0HipQ285qxNS+wn7ibwRD0gh3Aiw+HOm32MQSQMeK97JwlLBlM55l0rpG2quZUX
	 ycnCICJnfME6uN+9TXCtITr4U8rACqVF8+yyLJOcsdffH4qi2dZ4te5v3i6gVz7dIX
	 /vG6ZhBIE8mr0RMUSrPHUTxWzRDWPUI1SW3df0ESC4hxE8ZsZWCte3drEqJpioTfK2
	 auZ+pfG1AVGuqOz3E+NQf861LUx8kQQcb8bCg3HLU8QJ6Ldhy8xT/1MpK9rPPBleSX
	 yCEcVmpO5M6+OEJ6098oYD9IdJk/Jp9FZ4SWq1utdxcd2fD4F4LfEwQzY2gMCPFG+X
	 /BVKeoLuGUDFg==
Date: Tue, 9 Sep 2025 22:20:47 +0530
From: Naveen N Rao <naveen@kernel.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR
 even if AVIC is active
Message-ID: <zic6q7jhw6yxmy5dlh3ntvotzlr7singrftmr7axb6z3qa6i77@3ajx25hwxfef>
References: <cover.1756139678.git.maciej.szmigiero@oracle.com>
 <c231be64280b1461e854e1ce3595d70cde3a2e9d.1756139678.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c231be64280b1461e854e1ce3595d70cde3a2e9d.1756139678.git.maciej.szmigiero@oracle.com>

On Mon, Aug 25, 2025 at 06:44:28PM +0200, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Commit 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
> inhibited pre-VMRUN sync of TPR from LAPIC into VMCB::V_TPR in
> sync_lapic_to_cr8() when AVIC is active.
> 
> AVIC does automatically sync between these two fields, however it does
> so only on explicit guest writes to one of these fields, not on a bare
> VMRUN.
> 
> This meant that when AVIC is enabled host changes to TPR in the LAPIC
> state might not get automatically copied into the V_TPR field of VMCB.
> 
> This is especially true when it is the userspace setting LAPIC state via
> KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
> VMCB.
> 
> Practice shows that it is the V_TPR that is actually used by the AVIC to
> decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
> so any leftover value in V_TPR will cause serious interrupt delivery issues
> in the guest when AVIC is enabled.
> 
> Fix this issue by doing pre-VMRUN TPR sync from LAPIC into VMCB::V_TPR
> even when AVIC is enabled.
> 
> Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")

Cc: stable@vger.kernel.org

> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/svm/svm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

I am able to reproduce this issue with your selftest changes and I can 
confirm that this change fixes it. For this patch:
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


