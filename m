Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E772B58A00D
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiHDRy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 13:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiHDRyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 13:54:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738E06AA21
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 10:54:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so512844pjf.2
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 10:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=iHNZqto53xV1IH0gWWgHfI7Ia5I76zrw6b0mrZYyET8=;
        b=cLvElUGBK8DZUHwMj3dbwAONdpD9ZMvvS2FnB9pEl5ad987RtWTCI2f9J13dILEVhl
         V4kxMZRBhELc8k/lUJRwFsJntQ2utyP1HDhm6SjA/yGFp05Qrg6k+xbMjzGYNRnC0iYn
         YWW8P4hfDrChJUcAdEAPlW0vC8q5ZZiyimUkE9GrsYHp/Fp7QOr2+5C4R/gISuQERLtJ
         IcnBHyA02H6enXT/9PQGYErIjKFn2SEUCTQasDPW7JLU4sk8+nqFimyqe1dDGvZBFSGH
         3wBxX6IVkwukf1U/PYoRv03U9DtIr0IS6nO7oGQsVp2IcY6Zu+lzci/jVJgH4wlJpmcO
         m8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=iHNZqto53xV1IH0gWWgHfI7Ia5I76zrw6b0mrZYyET8=;
        b=No3O95+kxm74qHrxJgcyaprU/Lw60vzvFlR1OxtG1zq+BJfJCXYH368wfzu7dU/prs
         ZFkqmaswraKuaw+bboyKavgvR/xbNUTXsMZdoO/GxoTNvUq+3J7i7btVRPMzbhh5ivn+
         fNyHDdBg9pjgfK7vVFxW4RrAZMJsksBLR+T1Rr5NiLcAZg6w/znFusqCrzwjyda55Ky6
         12yUeNOLH1QHVykWVHOVw+x0mysDgDp0dCG7BxUY1kDPk7/qkDGsVAPjGc/NIH/ULLMu
         jb7vUaw/rRN8VRL57k9lsVxuVVwudb9ojfV9G511Vj+1K1VadcYdoiwAI30F9/zb+yBy
         mGbw==
X-Gm-Message-State: ACgBeo0RyxBEUceJT6CnJt0AtbCnluh3CopTrwB22pkI0kcRAhU279up
        i9UVqWXXT15DyfOFvzqbxEODcA==
X-Google-Smtp-Source: AA6agR5o9K51x+0Ols45O/O+17J2UJZywrx8gyh+qJpbl+X2Y8pQXcfWq8PGUuDTMnorXccUrpljtw==
X-Received: by 2002:a17:902:e748:b0:16f:8ae9:307f with SMTP id p8-20020a170902e74800b0016f8ae9307fmr1289675plf.135.1659635662808;
        Thu, 04 Aug 2022 10:54:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e67-20020a621e46000000b0052de390357esm1269976pfe.130.2022.08.04.10.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:54:22 -0700 (PDT)
Date:   Thu, 4 Aug 2022 17:54:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     suravee.suthikulpanit@amd.com, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: x86: Do not block APIC write for non ICR
 registers
Message-ID: <YuwHyhuwAtdECMyE@google.com>
References: <YutthQ3aWGGPk/sk@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YutthQ3aWGGPk/sk@kili>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Dan Carpenter wrote:
> Hello Suravee Suthikulpanit,
> 
> The patch 1bd9dfec9fd4: "KVM: x86: Do not block APIC write for non
> ICR registers" from Jul 25, 2022, leads to the following Smatch
> static checker warning:
> 
> 	arch/x86/kvm/lapic.c:2302 kvm_apic_write_nodecode()
> 	error: uninitialized symbol 'val'.
> 
> arch/x86/kvm/lapic.c
>   2282  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>   2283  {
>   2284          struct kvm_lapic *apic = vcpu->arch.apic;
>   2285          u64 val;
>   2286  
>   2287          if (apic_x2apic_mode(apic))
>   2288                  kvm_lapic_msr_read(apic, offset, &val);
> 
> Originally, this was only called when "offset == APIC_ICR", but the
> patch removed that condition.  Now, if kvm_lapic_msr_read() returns 1
> then "val" isn't initialized.
> 
>   2289          else
>   2290                  val = kvm_lapic_get_reg(apic, offset);
>   2291  
>   2292          /*
>   2293           * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
>   2294           * xAPIC, ICR writes need to go down the common (slightly slower) path
>   2295           * to get the upper half from ICR2.
>   2296           */
>   2297          if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
>   2298                  kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>   2299                  trace_kvm_apic_write(APIC_ICR, val);
>   2300          } else {
>   2301                  /* TODO: optimize to just emulate side effect w/o one more write */
>   2302                  kvm_lapic_reg_write(apic, offset, (u32)val);
> 
> The warning here is for when apic_x2apic_mode() is true but
> "offset != APIC_ICR" and kvm_lapic_msr_read() returns 1.

In theory this can't happen because kvm_apic_write_nodecode() is called if and only
if hardware successful wrote the vAPIC register, i.e. kvm_lapic_msr_read() should
never fail.  But I 100% agree that not guarding against a hardware/ucode/KVM bug is
unnecessarily dangerous.

There are more succinct ways to handle this, but they're rather gross and it's
probably best to bug the VM and bail, e.g. as opposed to zeroing out val and
continuing on.

---
 arch/x86/kvm/lapic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e2ce3556915e..9dda989a1cf0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2284,10 +2284,12 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;

-	if (apic_x2apic_mode(apic))
-		kvm_lapic_msr_read(apic, offset, &val);
-	else
+	if (apic_x2apic_mode(apic)) {
+		if (KVM_BUG_ON(kvm_lapic_msr_read(apic, offset, &val), vcpu->kvm))
+			return;
+	} else {
 		val = kvm_lapic_get_reg(apic, offset);
+	}

 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy

base-commit: e91e4455d92a5f2908eeb295d3512bd1a31e1558
--

