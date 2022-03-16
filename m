Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9161A4DA8F8
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 04:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352608AbiCPDfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 23:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiCPDfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 23:35:04 -0400
Received: from out0-154.mail.aliyun.com (out0-154.mail.aliyun.com [140.205.0.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1074ABC2A
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 20:33:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047209;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.N5XXwNx_1647401628;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.N5XXwNx_1647401628)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Mar 2022 11:33:48 +0800
Date:   Wed, 16 Mar 2022 11:33:48 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: x86/emulator: Emulate RDPID only if it is
 enabled in guest
Message-ID: <20220316033348.GA62465@k08j02272.eu95sqa>
References: <2b2774154f7532c96a6f04d71c82a8bec7d9e80b.1646655860.git.houwenlong.hwl@antgroup.com>
 <45a2dbcbf694c48f1fb6a834a0f97a36a226a172.1646655860.git.houwenlong.hwl@antgroup.com>
 <8968615c-4ef2-49b9-77eb-82d580259a9c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8968615c-4ef2-49b9-77eb-82d580259a9c@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 06:18:11AM +0800, Paolo Bonzini wrote:
> On 3/7/22 13:26, Hou Wenlong wrote:
> >When RDTSCP is supported but RDPID is not supported in host,
> >RDPID emulation is available. However, __kvm_get_msr() would
> >only fail when RDTSCP/RDPID both are disabled in guest, so
> >the emulator wouldn't inject a #UD when RDPID is disabled but
> >RDTSCP is enabled in guest.
> >
> >Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> >Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> >---
> >  arch/x86/kvm/emulate.c     | 4 +++-
> >  arch/x86/kvm/kvm_emulate.h | 1 +
> >  arch/x86/kvm/x86.c         | 6 ++++++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> >index 3497a35bd085..be83c9c8482d 100644
> >--- a/arch/x86/kvm/emulate.c
> >+++ b/arch/x86/kvm/emulate.c
> >@@ -3521,8 +3521,10 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
> >  {
> >  	u64 tsc_aux = 0;
> >-	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
> >+	if (!ctxt->ops->guest_has_rdpid(ctxt))
> >  		return emulate_ud(ctxt);
> >+
> >+	ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux);
> >  	ctxt->dst.val = tsc_aux;
> >  	return X86EMUL_CONTINUE;
> >  }
> >diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> >index 29ac5a9679e5..1cbd46cf71f9 100644
> >--- a/arch/x86/kvm/kvm_emulate.h
> >+++ b/arch/x86/kvm/kvm_emulate.h
> >@@ -228,6 +228,7 @@ struct x86_emulate_ops {
> >  	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
> >  	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
> >  	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
> >+	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
> >  	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 09c5677f4186..44f97038d3e5 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -7723,6 +7723,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
> >  	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
> >  }
> >+static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
> >+{
> >+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
> >+}
> >+
> >  static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
> >  {
> >  	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
> >@@ -7807,6 +7812,7 @@ static const struct x86_emulate_ops emulate_ops = {
> >  	.guest_has_long_mode = emulator_guest_has_long_mode,
> >  	.guest_has_movbe     = emulator_guest_has_movbe,
> >  	.guest_has_fxsr      = emulator_guest_has_fxsr,
> >+	.guest_has_rdpid     = emulator_guest_has_rdpid,
> >  	.set_nmi_mask        = emulator_set_nmi_mask,
> >  	.get_hflags          = emulator_get_hflags,
> >  	.exiting_smm         = emulator_exiting_smm,
> 
> Queued, thanks.
> 
> Would you try replacing the ->guest_has_... callbacks with just one
> that takes an X86_FEATURE_* constant as a second argument?
> 
> Paolo
I've tried doing it before sending the patch, but the compilation failed
due to BUILD_BUG_ON in reverse_cpuid_check(), which requires a constant.
