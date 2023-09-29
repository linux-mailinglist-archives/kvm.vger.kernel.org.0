Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B30B7B2A04
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjI2A4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 20:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjI2A4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 20:56:10 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1177B4
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 17:56:08 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c73637061eso13939045ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 17:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695948968; x=1696553768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uGvZQ8YpSxeOMPmkaxrORq5gSBUXKw/fR0I9Pd9q5ps=;
        b=unGJT76FL6r8V8trxMysIFkCuWZ80CKWZOrpD7rZaa8BUnYcXNxAqWcMf+Q1xsbqF/
         DMsysrmVAZcXjOvL3t2NkNKhgRE5+L4ervKdy/8tP81o1byyxaIQRW9es8GVd8Z8UmlE
         fEPstRrEHqKEw54coOosTwjwcPEewQ8vTHWJ5yAT8tr9M31WQfCZ1P9YJutglgbcxzC1
         oj69g6/8yMc12w9Yoa4+vEoA6Q7SUM8WH/kZ+og9pyc9cWnK3pprG8iLeau7kVw6qk9i
         JMOpHM/P0VZjSgYO/cpfabX5r58eMcaKi/fdhoAKR1pSivDAZ6F4M4cKW0Yflq9wZzDc
         7oug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695948968; x=1696553768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uGvZQ8YpSxeOMPmkaxrORq5gSBUXKw/fR0I9Pd9q5ps=;
        b=o+lM6jXtrisV794EaMU6vNwktxdbc0Y4GYSMBDq6mgmTPKW9MzZmiLbyYP6jj3Copm
         pGHxgmmzLbFNpOncYeUWNBD1CCRgO/gFEAFIu1ii/7PZJL/2/y/zzsqqKkvy5xViqMd8
         8OGK4am58KqDZvFaIqU+orDVCmGLmsYpXtdQS75na2SvXQxY/FQEUVKqUsb94eXSkGjU
         TxgMR0O9gGy1qvzHgwm8ydHeGSOoCCzKbFBoju7ih3YEKp8nJxKd6ZAaI5laaMtPNp7c
         S0V17cMzbeNx1Wx1zgrp6pYft2p403obcMcfG1uKJdzN7bfPSEuuDwRQk0vS6FtN1jQ3
         gh6g==
X-Gm-Message-State: AOJu0YwlUIFStpzKDBo6uX373rvOH8pMzJKbX1hpXvt6keck/zFCWHBA
        BH628hlG1E+m4PYSF6qmHDvis/nvIVU=
X-Google-Smtp-Source: AGHT+IHlxHIHqiG5McaxVLw68ot8zHTSIXZt8jyY69UOvQrl7bz3STy4TtiKhkKt4EZZPGXaEdOfpiV9dp4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e742:b0:1b8:8c7:31e6 with SMTP id
 p2-20020a170902e74200b001b808c731e6mr41747plf.1.1695948968101; Thu, 28 Sep
 2023 17:56:08 -0700 (PDT)
Date:   Thu, 28 Sep 2023 17:56:06 -0700
In-Reply-To: <20230928185128.824140-3-jmattson@google.com>
Mime-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com> <20230928185128.824140-3-jmattson@google.com>
Message-ID: <ZRYgpnMJb1XYCeUs@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, "'Paolo Bonzini '" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Jim Mattson wrote:
> On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
> set. If it isn't set, they complain:
> 	[Firmware Bug]: TSC doesn't count with P0 frequency!
> 
> Allow userspace to set this bit in the virtual HWCR to eliminate the
> above complaint.
> 
> Attempts to clear this bit from within the guest are ignored, to match
> the behavior of modern AMD processors.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/x86.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1a323cae219c..9209fc0d1a51 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3700,11 +3700,26 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
>  		data &= ~(u64)0x8;	/* ignore TLB cache disable */
>  
> -		/* Handle McStatusWrEn */
> -		if (data & ~BIT_ULL(18)) {
> +		/*
> +		 * Ignore guest attempts to set TscFreqSel.
> +		 */

No need for a multi-line comment.
/
> +		if (!msr_info->host_initiated)
> +			data &= ~BIT_ULL(24);

There's no need to clear this before the check below.  The (arguably useless)
print will show the "supported" bit, but I can't imagine anyone will care.

> +
> +		/*
> +		 * Allow McStatusWrEn and (from the host) TscFreqSel.

This is unnecessarily confusing IMO, just state that writes to TscFreqSel are
architecturally ignored.  This would also be an opportune time to explain why
KVM allows this stupidity...

> +		 */
> +		if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
>  			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  			return 1;
>  		}
> +
> +		/*
> +		 * TscFreqSel is read-only from within the
> +		 * guest. Attempts to clear it are ignored.

Overly aggressive wrapping.

How about this?

---
 arch/x86/kvm/x86.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 791a644dd481..4dd64d359142 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3700,11 +3700,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
-		/* Handle McStatusWrEn */
-		if (data & ~BIT_ULL(18)) {
+		/*
+		 * Allow McStatusWrEn and TscFreqSel, some guests whine if they
+		 * aren't set.
+		 */
+		if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+
+		/* TscFreqSel is architecturally read-only, writes are ignored */
+		if (!msr_info->host_initiated)
+			data = ~(data & BIT_ULL(24)) |
+			       (vcpu->arch.msr_hwcr & BIT_ULL(24));
 		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:

base-commit: 831ee29a0d4a2219d30268f9fc577217d222e339
-- 

