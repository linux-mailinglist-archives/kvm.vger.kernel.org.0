Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CB179F717
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 03:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbjINB7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 21:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbjINB6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 21:58:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386F3210C
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 18:56:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5924b2aac52so6443137b3.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 18:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656573; x=1695261373; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TEdWNzKShragyniQ9J+Ve2p49++UXy1fA45JB0RVd2M=;
        b=h9V/U3frJpGPr9/ZrV/PZMNnMcU+CkRlFhv70JYTud9Ejn9icNw4ec9L81Uv7rs5yH
         rXWqSZZxrH2nqGYx25EhtWppAwILZ6lPQhxMqCDJ9G5FrfH0KavOQbxJgjh7zypWZDO6
         4F3lMCQOrEWKl59wNiJmdoURkihezNibt9aS+j8HkGQgcsXmgSSBaKaNZBnUBAvfBT8M
         /O4HZ25mSZuzSj7WB2M2XX2Bcm4J2vCq79Z2mcnH7YhjDp/mwSbdKS2NW5QwdVCc6wB5
         c+W2iX8Pign1/YTLJQlIk4VH8g/P5i7RaBc/0sSUd27K3AfyHKe0GStTBIe7SOyDLTUv
         smNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656573; x=1695261373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEdWNzKShragyniQ9J+Ve2p49++UXy1fA45JB0RVd2M=;
        b=jLpqVAH0f+jMSZDGt0FLYZic40ZjjLH1jA53y79Cepd8kPMRYJxgu+zWs9R6QUtaIJ
         4paZ6tU+kv1+PgQYvUeuOMOQsQTblUTq/vs8NsHjY6RSArgEC3kTHn1P/v1PUvh0NDPF
         LpIGfazIpFrSEyATPHx5oIT0TgtfGd0DARH5y7bmd/Qrj2sX6vdtO/+QQlw4+y6YMS/0
         UrC71ygdvQLtaLk+Fq7aC4yCkoCPdDEhZMrRWh/p8ulCBotJ4vRQsDyopyxhZTZ8N66M
         SyoAPwbXXHhsrWPiJdhYxkj4fs7+muDF8dUfdFlEqQ28Ih3UuLkXmIpZj7GBMnqQkrGw
         T+fw==
X-Gm-Message-State: AOJu0YwJSaZ1IurM9joRFQQZUxn1ZlGTYRKKimxnHPm9vUMpWkoeb4FJ
        qwiHSHIlZY/KcLbPDv2HlOETxdNJoMo=
X-Google-Smtp-Source: AGHT+IGYm//r9vLVsRhCBexYLsW+kyUM6dthNH5+IPZo7SQZB/dk4at291uiQmKPgon5iad9USRf5MgW9tA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:400c:0:b0:589:a855:7af with SMTP id
 l12-20020a81400c000000b00589a85507afmr107415ywn.7.1694656573483; Wed, 13 Sep
 2023 18:56:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Sep 2023 18:55:17 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-20-seanjc@google.com>
Subject: [RFC PATCH v12 19/33] KVM: Drop superfluous __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop __KVM_VCPU_MULTIPLE_ADDRESS_SPACE and instead check the value of
KVM_ADDRESS_SPACE_NUM.

No functional change intended.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 include/linux/kvm_host.h        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91a28ddf7cfd..78d641056ec5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2126,7 +2126,6 @@ enum {
 #define HF_SMM_MASK		(1 << 1)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
-# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18d8f02a99a3..aea1b4306129 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -692,7 +692,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
 #define KVM_MEM_SLOTS_NUM SHRT_MAX
 #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
 
-#ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
+#if KVM_ADDRESS_SPACE_NUM == 1
 static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.42.0.283.g2d96d420d3-goog

