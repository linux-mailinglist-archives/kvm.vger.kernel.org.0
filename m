Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6528A76384B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjGZOFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 10:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjGZOFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 10:05:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA982132
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 07:05:21 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bb982d2572so19016665ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 07:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690380321; x=1690985121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PdewSqbu0kfeZ5E3lYwpUZYvX+SwKUd0gKg6LQczZgM=;
        b=5ZkzP+PZ8Zg+ooETP3j1Malqu4lrJVYLDxfQ1+HWqij6/F3aiyjzra61SwRftFJofT
         NT0Wik6Xa4RzqgfqeAdeylLSCiF+0ytzUBh3QJjmza7gN5aS/JB9UXcAVJe3zoCTInJf
         LioLJ2hnBgPVA24dNVPOeJZwLsHzUXbs9kirneMmHQE9E6hyZks0/zJNO/VS02uSPpgV
         0KneUR4j5gll0JPppwh4OnHRuQNsHsdCfBWhDywQDoG7eFP/4lMHScJsWn6ePWvkfgxY
         ageziXTOcUU02Jpe1DkTcQPgNfkDo5K8j52aTkqhWE55GgUOKevC1kMqbBKE9wh8qd6g
         NEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380321; x=1690985121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PdewSqbu0kfeZ5E3lYwpUZYvX+SwKUd0gKg6LQczZgM=;
        b=MlJUUUMYJzF46E5jbWM/JsvbTYsn6aatX35WJQ39NOqEJH/CqxqivqXVWVcSC3Acgx
         8lOqr7lq2VaaGBSMAgswTS8mEgk9mR+UWc+KqJUqLhDCJUcDfShE/PmpojA0L5ASiSDy
         NNS9CcVizuzUsp27FmWiFbzRtsglgO/CwmXjMlWZarmz6OJSPGRV6ru6yFJ/vcNew8MW
         yVogUz5BgPYa4HVk9aNy7KjTUJrYxkTCbHpcrquccH+Qb5d8yt5o6ee35pgcyOj+XhuY
         OD9hmIG/MKJYwJ/e9crwUHDMQ5cLKEYc8rNX4rYpe6zL5JvNA5jGhRWMZEizFLRL+9Ma
         BiAw==
X-Gm-Message-State: ABy/qLZmeG1/Y9Ey9ZDYHd/2kBkvBNgs/FnPdXsIfq0wBQkegDLD0Ylw
        vnZzgU2pWDlg3zY9IqTiUZ9gXBB6cYI=
X-Google-Smtp-Source: APBJJlH2ZV14iDS02gMqFKuTo7m8yR7AGDQ8PsYFtYhjoxWYaPBOKUuYD11G/99fkFgWTJ8CGJyJZuuQb4E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4cd:b0:1bb:83ec:841 with SMTP id
 o13-20020a170902d4cd00b001bb83ec0841mr9968plg.6.1690380320500; Wed, 26 Jul
 2023 07:05:20 -0700 (PDT)
Date:   Wed, 26 Jul 2023 07:05:18 -0700
In-Reply-To: <ZMDdp1A7DOsRNeTd@chao-email>
Mime-Version: 1.0
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-16-weijiang.yang@intel.com> <ZMDdp1A7DOsRNeTd@chao-email>
Message-ID: <ZMEoHgAm29baVbdp@google.com>
Subject: Re: [PATCH v4 15/20] KVM:VMX: Save host MSR_IA32_S_CET to VMCS field
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:47PM -0400, Yang Weijiang wrote:
> >Save host MSR_IA32_S_CET to VMCS field as host constant state.
> >Kernel IBT is supported now and the setting in MSR_IA32_S_CET
> >is static after post-boot except in BIOS call case, but vCPU
> >won't execute such BIOS call path currently, so it's safe to
> >make the MSR as host constant.
> >
> >Suggested-by: Sean Christopherson <seanjc@google.com>
> >Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >---
> > arch/x86/kvm/vmx/capabilities.h | 4 ++++
> > arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
> > 2 files changed, 12 insertions(+)
> >
> >diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> >index d0abee35d7ba..b1883f6c08eb 100644
> >--- a/arch/x86/kvm/vmx/capabilities.h
> >+++ b/arch/x86/kvm/vmx/capabilities.h
> >@@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
> > 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> > }
> > 
> >+static inline bool cpu_has_load_cet_ctrl(void)
> >+{
> >+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
> 
> VM_ENTRY_LOAD_CET_STATE is to load guest state. Strictly speaking, you
> should check VM_EXIT_LOAD_HOST_CET_STATE though I believe CPUs will
> support both or none.

No need, pairs are now handled by setup_vmcs_config().  See commit f5a81d0eb01e
("KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at kvm_intel load time"), and
then patch 17 does:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3eb4fe9c9ab6..3f2f966e327d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2641,6 +2641,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
                { VM_ENTRY_LOAD_IA32_EFER,              VM_EXIT_LOAD_IA32_EFER },
                { VM_ENTRY_LOAD_BNDCFGS,                VM_EXIT_CLEAR_BNDCFGS },
                { VM_ENTRY_LOAD_IA32_RTIT_CTL,          VM_EXIT_CLEAR_IA32_RTIT_CTL },
+               { VM_ENTRY_LOAD_CET_STATE,              VM_EXIT_LOAD_CET_STATE },
        };

> 
> >+}
> > static inline bool cpu_has_vmx_mpx(void)
> > {
> > 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 85cb7e748a89..cba24acf1a7a 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -109,6 +109,8 @@ module_param(enable_apicv, bool, S_IRUGO);
> > bool __read_mostly enable_ipiv = true;
> > module_param(enable_ipiv, bool, 0444);
> > 
> >+static u64 __read_mostly host_s_cet;
> 
> caching host's value is to save an MSR read on vCPU creation?

Yep.  And probably more importantly, to document that the host value is static,
i.e. that KVM doesn't need to refresh S_CET before every VM-Enter/VM-Exit sequence.
