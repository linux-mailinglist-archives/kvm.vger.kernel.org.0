Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DCB617250
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiKBXYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiKBXXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:23:54 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711EBBC19
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-367f94b9b16so819367b3.11
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mKnEtQX0QH/ggk+Ht36/d+63ROqx6WCYCltiz+Zzjv4=;
        b=SdQ/LsY4NGnVE1yE06OYtnoYVCRmFREHfZbDy+hy/qKLprusJ3oD9C3Z6OVRKqQrnE
         CInFERbmx9ZRnFYiATYzBK74mPS4+cAZJ+5ijRabgzbKKerJGVt8ZZlmJzt5Hj/aV0PA
         EGW/7VotUp9NojxVblVL/QpJZuKvGxyCajSBZEMqVRwQDUQw2wRSv4vj1QT6bcpnpc9t
         e4rP+2f3gLSJ/JJRtgPX3AbV2Tyauor4ctFIQiYJWU548K+/wXsudAS9Uik/E0jRBxNq
         qFZGa2xPRMU89uQ30BChflY3hdbUkhWTUyAN3U9JeOyLGBy95xzkfXnGKk726vF8pKbF
         n5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mKnEtQX0QH/ggk+Ht36/d+63ROqx6WCYCltiz+Zzjv4=;
        b=vj9pQ0lxmYyxzlwh8v3eqkNQ+HwVPPj0/PJhHeEuOgbezxgu0bVbGJF2X0tEkuzT42
         UdRbvO175NtI7H54YBRWJECSBxvLKMh7TV6BvZbsUjNFBGurglcOtiRcXB/owTENs4z0
         tSH41sSha6C81dwp9+FEVjPgpCtLowzip9gY6D2/dy2TDBDT9Ch92sQ3CzHoPoaIaxen
         1y9uH976bA+znm7JS0yOHFaiOHFYXkocS2nUe2ByBBBIXN2zrMFFStDooVN/9oX4mBx0
         lf0r/OrR6rTpn//FJRz1MLFRAGviqYxKknuYWMynmCS4AUkGiWbSEhmo3DfwowFyc+mi
         /O9w==
X-Gm-Message-State: ACrzQf2khRagYywtax4gmGEB6cIy/zqSeCCNxJ7EoGgU7kvfvkI+hVz2
        VVC1Kh6n5ra4jppXrOn2opVDtWSTnpo=
X-Google-Smtp-Source: AMsMyM58olcArAfGw4eM2juSx6NG/cSk/6KUdGGsxOwq8NmV4ZhdhKDU4RNI0GuMTLVYYG9b0/LsdP0LTpo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c615:0:b0:6c9:f71a:f95d with SMTP id
 k21-20020a25c615000000b006c9f71af95dmr26436245ybf.411.1667431202255; Wed, 02
 Nov 2022 16:20:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:55 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-29-seanjc@google.com>
Subject: [PATCH 28/44] KVM: VMX: Make VMCS configuration/capabilities structs
 read-only after init
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag vmcs_config and vmx_capability structs as __init, the canonical
configuration is generated during hardware_setup() and must never be
modified after that point.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 87c4e46daf37..2aaa0fd53d08 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -68,13 +68,13 @@ struct vmcs_config {
 	u64 misc;
 	struct nested_vmx_msrs nested;
 };
-extern struct vmcs_config vmcs_config;
+extern struct vmcs_config vmcs_config __ro_after_init;
 
 struct vmx_capability {
 	u32 ept;
 	u32 vpid;
 };
-extern struct vmx_capability vmx_capability;
+extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6adb60485839..81690fce0eb1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -489,8 +489,8 @@ static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
 
-struct vmcs_config vmcs_config;
-struct vmx_capability vmx_capability;
+struct vmcs_config vmcs_config __ro_after_init;
+struct vmx_capability vmx_capability __ro_after_init;
 
 #define VMX_SEGMENT_FIELD(seg)					\
 	[VCPU_SREG_##seg] = {                                   \
-- 
2.38.1.431.g37b22c650d-goog

