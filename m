Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279674B5CDE
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiBNVcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:32:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiBNVay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:30:54 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E325F151D39
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:30:45 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id g19-20020a17090a579300b001b9d80f3714so253280pji.7
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hXpR7noM0Gaf4lClru7xk5v15uSEtIVKl1a1cXA9M1M=;
        b=opM0a70jMwKyYNCL/4+x4SLQVInaJjIS5wWZAnkGWH1MLUq+29JMkUmXFK2n0lixNI
         +i6H4pkYR6kn30Pnx/JuMlka/FLU9zI649GHIjICoCXFHhxt+1AnoQwWPgw2gy6eVm2j
         Ex7+LBWXPi92Hk7fyjGaZ5qgC7FFBLYugv41ZB/SnEz74chNWc6SozlJbjaJ2CIkz+kQ
         b8mktDR2AjDIGXtRbPvfcp2uRkw8ktdw0ohTHFuawITSEtczKc1u9bSWXKYhOdGEwTq/
         3PXGUO2Ym2mOqOKmrT96Jr+T4FRMLYilAYV1UtJMedqSMqnbRX0lgXHYqT4nyAVUioLL
         EEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hXpR7noM0Gaf4lClru7xk5v15uSEtIVKl1a1cXA9M1M=;
        b=q5GEgvUSFO3J8A3VnvKrmFBhGRVqVeWlw2W1sHxcW0niSRAdR7PB/NkkCHsXhoTu4p
         U5M1Cet24XdEQ0fHGICVhfwWd67nLbNWeCi533Aa5p55gWHUdzeaoTh4T2+5D2fSpcAj
         ke9rWLUynItbI/PuUqF0hiadd9HPe9z2nV4LF+mMbkEgveb3Cb0PtQ4O7STPNXT4sR2i
         K5wZE9yCALsLFJTNXdu5rLkkASd1NDoYgKTWVeMMWu4eEFZji07rJNIhSdcqgy6evRrb
         Wo3jF+t1gKpWewwwq/bBtcy+xbJjg/Yf27vQcokzNsp523Y+aX/CqYDvNxnqfw+tLn0J
         LR3Q==
X-Gm-Message-State: AOAM531KhRameikCCTGCP2Hg37bV9//JQotE9gc5+1Y4go5TtEgNsh9j
        ZGxg/gfFX6GaoeeRPAvybU1kyEgmcT+SposKbm3UeJhxVO+eEp+Qxhs1Xks7dCBl9HgvIprp2Rb
        24HAOn1mZRPrZUP0jSlhdWZBypSybafG5C9QlaQkfrg+Fk1rNQsfqIQiG1Vm8z79d1OUd
X-Google-Smtp-Source: ABdhPJy+D656uQyI/3L91U07uspkl0qIpUo4Z7HGSV9v5/PzmJo4qsMI+BHnu8zi2sn2WdC/XABVj6fH2cpzkcwH
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:aa7:99c9:: with SMTP id
 v9mr1110426pfi.8.1644874245257; Mon, 14 Feb 2022 13:30:45 -0800 (PST)
Date:   Mon, 14 Feb 2022 21:29:51 +0000
Message-Id: <20220214212950.1776943-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the capability KVM_CAP_ENABLE_CAP to x86 so userspace can ensure
KVM_ENABLE_CAP is available on a vcpu before using it.

Fixes: 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/x86.c             | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..3b4da6c7b25f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1394,7 +1394,7 @@ documentation when it pops into existence).
 -------------------
 
 :Capability: KVM_CAP_ENABLE_CAP
-:Architectures: mips, ppc, s390
+:Architectures: mips, ppc, s390, x86
 :Type: vcpu ioctl
 :Parameters: struct kvm_enable_cap (in)
 :Returns: 0 on success; -1 on error
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..757da29e98f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4233,6 +4233,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_SYS_ATTRIBUTES:
+	case KVM_CAP_ENABLE_CAP:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.35.1.265.g69c8d7142f-goog

