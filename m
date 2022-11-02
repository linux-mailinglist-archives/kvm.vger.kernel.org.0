Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91B661661D
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 16:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiKBP2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 11:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiKBP2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 11:28:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36E51F2C8;
        Wed,  2 Nov 2022 08:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CF9AB822A7;
        Wed,  2 Nov 2022 15:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C52C433C1;
        Wed,  2 Nov 2022 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667402896;
        bh=6lcwwfbMSlo8DEu9ecprjk+dui6Bhl8N83PSGT7Y0Zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNcjuhd1pizVJo7oRnnSsfbztclRcsZkJG+hDuzeKXaZp/JL75OrJitKOXi8Dz7Cj
         F/ytW/HsWJpMtMqCHM+JwSTLFY3Hjxt2kPkEdH1QEy0v7A4Thx064FkeTjVD4UcOis
         /oj8Op/fxT2Lbi5gWNz/T5bbxliTKX4cXEdH1LpURTNKh3IiuiDtERp195PYlKRUiH
         rBG7aqC/D7La2uo1K45OWlsp0ckZLgUpV26fMuGE7s6V/XNdIwtFr8+O/4SqLeJbVF
         oy9OWpKYaTpFcHmsjRLLNntKM0lAjHYCXlpfZbq/XST9y7Elxw0+hwdzLcNuaG0huP
         2dPN9lsB9dizA==
Date:   Wed, 2 Nov 2022 08:28:14 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, seanjc@google.com
Subject: Re: [PATCH 6/7] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to
 assembly
Message-ID: <20221102152814.lmuzib5472zsaroy@treble>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
 <20221028230723.3254250-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221028230723.3254250-7-pbonzini@redhat.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022 at 07:07:22PM -0400, Paolo Bonzini wrote:
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3918,10 +3918,21 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long vmcb_pa = svm->current_vmcb->pa;
>  
> +	/*
> +	 * For non-nested case:
> +	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
> +	 * save it.
> +	 *
> +	 * For nested case:
> +	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
> +	 * save it.
> +	 */
> +	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);

This triggers a warning:

  vmlinux.o: warning: objtool: svm_vcpu_enter_exit+0x3d: call to svm_msrpm_offset() leaves .noinstr.text section

svm_vcpu_enter_exit() is noinstr, but it's calling
msr_write_intercepted() which is not.

That's why in the VMX code I did the call to msr_write_intercepted() (in
__vmx_vcpu_run_flags) before calling vmx_vcpu_enter_exit().

-- 
Josh
