Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB7F4AAC52
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 20:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354918AbiBETlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 14:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiBETlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Feb 2022 14:41:52 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BC5C061348
        for <kvm@vger.kernel.org>; Sat,  5 Feb 2022 11:41:51 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id t14so13624395ljh.8
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 11:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3owvFE1hG/67lI61bEflxHtvlzjGnvYg4R3h1wAR3A=;
        b=Q1V9Wx++abgaeTU6VkacuYFf5uOm7okgmKEb9B+/g4lxPn8Jjc6l5vP3c6kMVqCA6e
         hr5FsoZVcKbwSVS9wiA8UTU6Qw7ZttD6drqjyB9bW8LR5H8HbojgspTyx9GpAZYVd9Mm
         e/xyhA+s9YSFVhhUjAF9LBKB4Wow3n/62iY4DntAVBtZvdU7e+D1rjF+C/Tdu6yNTmpi
         b44ymYzCmcpcFH5yKmwbNakHwi0xwE+xvZWwPzVO2FaI4SJCHs7jhtRpFGB0GbBwQFvs
         mmvIRBXzP425Ur+37WgBmIQuPKwOIocZ4BIFp7RlTwyJ7mS//TiENPzWoKeW4QHn/B/e
         PYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3owvFE1hG/67lI61bEflxHtvlzjGnvYg4R3h1wAR3A=;
        b=7DeSbt4vA+ZayfzUdXc5+6qgtBhcdpKcLM1PWDcaHnTAypZOearnYdVirMKLkyFDKu
         WFI+VLP53AV5uPXMHM+xsjxMCbgiUqZ764mjE+cNvIdGPFsVbVZt/zazEZwLaXB+Qg5Y
         Am2hWJ+eVtXhxtM2H7o1xAHuYfRvKKw4hHhQ3NzT9nWLRb30CIII7kCEDBnDvnournKY
         zS1+6Gou+Wh4qrRakpiaxuiHJfNJiAvZ6JSJL1Nl1Q2NW+UvRwHSvq43Qa5Py28/n12E
         PsGb2faKX488Y7WCKeA/2MBX9o5JC3gdWz/KMeSxagaoqaiFkdR8FKUCwTG8LVUABzZZ
         Oa0g==
X-Gm-Message-State: AOAM531zfoLzSFar145tabc/B+xAHfJXDdIpzib+Mf0Y2g4g+woAEbwN
        FHHAfUaVR3rU5eMGtgHEj6Ud/Saxu8T66T+7rsnLRA==
X-Google-Smtp-Source: ABdhPJyxRLxYVUUr6SNSAXldSTtHVRrm3+rgnc4HnVWUxnFROxzjgr7u+4TE/1W62AkV64vUDaRTRbQ3wfWR+dGi98w=
X-Received: by 2002:a05:651c:108:: with SMTP id a8mr3727711ljb.479.1644090109217;
 Sat, 05 Feb 2022 11:41:49 -0800 (PST)
MIME-Version: 1.0
References: <20220204204705.3538240-4-oupton@google.com> <202202051529.y26BVBiF-lkp@intel.com>
In-Reply-To: <202202051529.y26BVBiF-lkp@intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Sat, 5 Feb 2022 11:41:37 -0800
Message-ID: <CAOQ_QsgWzfe-2-d709NFycJ_CpeBGR3Up4f9ORFseUCWMB=_UQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Roll all entry/exit ctl updates into a
 single helper
To:     kernel test robot <lkp@intel.com>
Cc:     kvm@vger.kernel.org, kbuild-all@lists.01.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 4, 2022 at 11:44 PM kernel test robot <lkp@intel.com> wrote:
> >> ERROR: modpost: "kvm_pmu_is_valid_msr" [arch/x86/kvm/kvm-intel.ko] undefined!

Argh... Local tooling defaults to building KVM nonmodular so I missed this.

Squashing the following in fixes the issue.

--
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f614f95acc6b..18430547357d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -396,6 +396,7 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
        return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
                kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
 }
+EXPORT_SYMBOL_GPL(kvm_pmu_is_valid_msr);

 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
