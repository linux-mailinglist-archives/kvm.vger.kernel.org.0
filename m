Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D714352A9
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJTS3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJTS3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:29:10 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89F3C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:26:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q5so23270852pgr.7
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lpDirkOm6AQE71MS9HbrUBcKh1Z3g4/nVuMaV719kjw=;
        b=pz1OLQGrbIRZPHfHHxlHFKNCOYGq/8nxJ1m/R/GZ1Ts1owYrrb/bTyQ5MjhyE0tmWw
         R6TCahdqd6QNyHMeHQUDjNgkr4n+E4F1cgnQRyPC5GXhRj+pZ5vSNOa3RIa1jZ4XIw/h
         NDQQdFeKkQvT4EfyG6hYCPFwFin5JTL1uAcv5PygteP3S308/OoVJLz7kUFmc5rqVJ3w
         2sBEKHoHNQdWno80Up+szUha2PJu1deoG5WuJGgpr+RK1dPe9pzXqiKOE+E+dhLeacv4
         CtWNnGcP3uLoAeTXhJ5OQdjbPEusNj6zgXbw9PniquWxn9DsCK3/oqfk+Lqc5inIqYMy
         GMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lpDirkOm6AQE71MS9HbrUBcKh1Z3g4/nVuMaV719kjw=;
        b=LSJz3FGnTCNyKGj0uGwWYLUvbZYKe+u9VSoqCOG5MhLtWGplnMix4nxxi93Vtgzwpv
         G6XymVP7yVx2lKVr6RvcZxZY8e2e9sPbDFTe8yBi423eYLUn23eg2z7dXweDtVcdwE9r
         y8fvqDxqTq2Ass3rkpvPri3o1l2vx9/M3XYkKHkJsRi/I/vfzVPiX3PcZS6f/gj5qsz1
         D1GnkfTm/z65blPk4EoENXBSHVjkNZWnTqopsphLnO1jAPu2wERCfGcPpX5KicgWrTqK
         C/l6JSnyrRoSDHKK/8G48snylAiqpGRnZHqi0UcAtDKQoYVz4QSmb8NtM7O62DGGQBo+
         RY1g==
X-Gm-Message-State: AOAM5318dMMCiCgYQSOVvTof0iK73JoGYWsRfb1+dV8lzKNTFxMA2eTH
        XDNL/YFW5+pqDA/8/+ovbrUCQw==
X-Google-Smtp-Source: ABdhPJxt36XSFVSdjeu9KOzBNBebEe71ZCBLzGOYaGh/OYfg2iPSJrtWhPzQiB1sC+8PhMaDZJGj7g==
X-Received: by 2002:a05:6a00:1344:b0:44c:4cd7:4d4b with SMTP id k4-20020a056a00134400b0044c4cd74d4bmr548248pfu.50.1634754415150;
        Wed, 20 Oct 2021 11:26:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nn14sm3001749pjb.27.2021.10.20.11.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 11:26:54 -0700 (PDT)
Date:   Wed, 20 Oct 2021 18:26:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
Message-ID: <YXBfaqenOhf+M3eA@google.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-2-jiangshanlai@gmail.com>
 <YW7jfIMduQti8Zqk@google.com>
 <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Lai Jiangshan wrote:
> On 2021/10/19 23:25, Sean Christopherson wrote:
> I just read some interception policy in vmx.c, if EPT=1 but vmx_need_pf_intercept()
> return true for some reasons/configs, #PF is intercepted.  But CR3 write is not
> intercepted, which means there will be an EPT fault _after_ (IIUC) the CR3 write if
> the GPA of the new CR3 exceeds the guest maxphyaddr limit.  And kvm queues a fault to
> the guest which is also _after_ the CR3 write, but the guest expects the fault before
> the write.
> 
> IIUC, it can be fixed by intercepting CR3 write or reversing the CR3 write in EPT
> violation handler.

KVM implicitly does the latter by emulating the faulting instruction.

  static int handle_ept_violation(struct kvm_vcpu *vcpu)
  {
	...

	/*
	 * Check that the GPA doesn't exceed physical memory limits, as that is
	 * a guest page fault.  We have to emulate the instruction here, because
	 * if the illegal address is that of a paging structure, then
	 * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
	 * would also use advanced VM-exit information for EPT violations to
	 * reconstruct the page fault error code.
	 */
	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
		return kvm_emulate_instruction(vcpu, 0);

	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
  }

and injecting a #GP when kvm_set_cr3() fails.

  static int em_cr_write(struct x86_emulate_ctxt *ctxt)
  {
	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
		return emulate_gp(ctxt, 0);

	/* Disable writeback. */
	ctxt->dst.type = OP_NONE;
	return X86EMUL_CONTINUE;
  }
