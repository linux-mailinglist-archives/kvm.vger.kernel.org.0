Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516A2758971
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 01:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjGRXve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 19:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjGRXu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 19:50:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EFD2718
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 16:49:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8b310553bso48763755ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 16:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724140; x=1692316140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RgixHOC4KKphqTDNjO+JFitY6BYM03Mxe9+IG67pQW4=;
        b=jr2fs44d+7BmMZPp9ybqRVhLe6DoUmnDVGGK/YxGf0Asu27qFmDOog5/7ezq8m4Ys7
         LB4TAF+aUXOU9vvZC3f7sCq7Qp6i9IPbi3VCM23iiZE2lWsjgfpk1UphaC4PromgcBa9
         nNuUO7C76a3+5q0Gf8ijV1dvvN0iI9MYocGBFlwlZWxo+oVA0VDDW9ZRP17wI+9kNKbR
         b/F5X7vtJ0QCTS7pjO0kMtxUEap2HU9N8Chl8h4VBmGvGutp4QtM3GkrHRbiuZH0RfDS
         Df8UlL/rj7lQEedr2TSELrHMasjkzJ51vXMKZpffeRoXHoSbQaRFODPANCOUb4yN0y8L
         ypGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724140; x=1692316140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RgixHOC4KKphqTDNjO+JFitY6BYM03Mxe9+IG67pQW4=;
        b=flnQM6hTLgD/hJqynIp6LkegM8X7c+h9v/bCtH7mZnfVRdveUoG8a5agJIZ8zw9IaT
         sRRrFnmGVBOaWNOZeSvTxnJ/HxyYTUS/aDXCSqAGRC4x/GL63ChykIhsmLoVyXiC63EW
         uiPusc1jtbrHCf9N/EtN/4x/PtpAgRuQq6Yv8NJS5339XwIDlsarXi460xJlUim/lk+C
         1O89UecBAALe2GvCfmeDkOTPJwVsPmrTHcr/WViCbA93xM2Uf5vDq7jp1oJ3mODDUw32
         fkzE7uXqstzBxcTTHHP4+mrYPVbxdYQc2p830duNsVto/0vHvL8F1ex8Uf7JAI8zfmat
         K85g==
X-Gm-Message-State: ABy/qLZgMCrw42we7KLMzjD1GABPHihH5Z3YdRo2EMBYRBi6tflU5QXt
        MT92BXvemftDiFV3FSUDfIBJMyvRaA0=
X-Google-Smtp-Source: APBJJlGmnxKpuVWpCwuKlcGO555af6O2CzLSJLrftIAb/WXIRBmN0a0otiSNa7LmthtetMuC6YJJMcmnlto=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2cf:b0:1ba:a36d:f82c with SMTP id
 n15-20020a170902d2cf00b001baa36df82cmr7700plc.7.1689724140625; Tue, 18 Jul
 2023 16:49:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 18 Jul 2023 16:44:58 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-16-seanjc@google.com>
Subject: [RFC PATCH v11 15/29] KVM: Drop superfluous __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
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
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 include/linux/kvm_host.h        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b87ff7b601fa..7a905e033932 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2105,7 +2105,6 @@ enum {
 #define HF_SMM_MASK		(1 << 1)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
-# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0d1e2ee8ae7a..5839ef44e145 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -693,7 +693,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
 #define KVM_MEM_SLOTS_NUM SHRT_MAX
 #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
 
-#ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
+#if KVM_ADDRESS_SPACE_NUM == 1
 static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.41.0.255.g8b1d071c50-goog

