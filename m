Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B511361A79A
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 05:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiKEE5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 00:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKEE5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 00:57:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D6D317E6
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 21:57:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b142-20020a253494000000b006ca86d5f40fso6641449yba.19
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 21:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BW+rPCZyrgfGjBQ3NJWBgC70ZM2E4N7Rxm+O8srguEk=;
        b=pAlbE6bcgnNjnuoJ+rX9hnRtuqI6cTg40qoUAFHN13LuRDcL3E92YcRjLGNk/oYc1n
         lMjbz30yCvufkdfqXQA3/fxMYImVQZbw8fw0LLfvujVII+d/gJtZGk5OZx3Y6xX2UlKX
         clwas/NpZLJ4598nf/qr4z3AU+hMroJYTuPVhS9X4Wn2eWqc7fHYGbaHKeSCL2ATiJNu
         8TZHj0l1n2OEFVQXolbTx96GQC5QgT9/DCwhp9kQQSokd2g6V9quOCvzJSUgR82+Y64R
         w+kULRNopwY+6Gwt94hupB3kAPy6suRLjrZ8REtS5eZPl30kqte/ubZfadv4N4iqV7V5
         Sdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BW+rPCZyrgfGjBQ3NJWBgC70ZM2E4N7Rxm+O8srguEk=;
        b=hoQzh4HAiuCX+UO5aeSDEe9/vxPxRtgbubiThSjw+rp2di0TH6IousnxqUqnASKz2x
         cTKfNbQQ4Eol2bnKZtmjHsH4u29J+6y9oHpLryAyQbj8I3Sc5Purp8nH5AcheAkpTdo5
         PoBJp9mbRbn4aEhTGsr/QDscR1NfAtimF4vgHB6YqVlRwTjlCqo3ou2k0KNVeeVpHF3Z
         G2vZMTCKpj2iuxRum+VMs4o+KtzdIC/DmLmzBrG0zKcnzVKp2sRXiKQQOsk0QFi0FAeK
         q7bBsPhmgHYjScZGT6NEelOOCKvvypbMzU9vwbqzjrk6s/oiZZnSablaOyZ32HYgWiCB
         C9cQ==
X-Gm-Message-State: ACrzQf0g+Zq6JSWifJG4UkFOZtQ62xCIiaCtXCYiVHmXrTNYS9AKI+ee
        odwMi312WYU/LJMCbdrfcizorwOy6K6v
X-Google-Smtp-Source: AMsMyM78gyHl/Ehhg39fKDPk6sd67w5nGZMpxmuBesaLcrfMLc4OytNZQthO+brQuFxPwEupOLckpKjKYoRe
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a5b:a0f:0:b0:691:6fea:deda with SMTP id
 k15-20020a5b0a0f000000b006916feadedamr37985774ybq.377.1667624233167; Fri, 04
 Nov 2022 21:57:13 -0700 (PDT)
Date:   Fri,  4 Nov 2022 21:57:00 -0700
In-Reply-To: <20221105045704.2315186-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221105045704.2315186-3-vipinsh@google.com>
Subject: [PATCH 2/6] KVM: x86: hyper-v: Add extended hypercall support in Hyper-v
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Add support for extended hypercall in Hyper-v. Hyper-v TLFS 6.0b
describes hypercalls above call code 0x8000 as extended hypercalls.

A Hyper-v hypervisor's guest VM finds availability of extended
hypercalls via CPUID.0x40000003.EBX BIT(20). If the bit is set then the
guest can call extended hypercalls.

All extended hypercalls will exit to userspace by default. This allows
for easy support of future hypercalls without being dependent on KVM
releases.

If there will be need to process the hypercall in KVM instead of
userspace then KVM can create a capability which userspace can query to
know which hypercalls can be handled by the KVM and enable handling
of those hypercalls.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/hyperv.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index db2f96a0ae23..85c6100f4451 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -40,6 +40,12 @@
 
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
 
+/*
+ * The TLFS carves out 64 possible extended hypercalls, numbered sequentially
+ * after the base capabilities extended hypercall.
+ */
+#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
+
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
 
@@ -2178,6 +2184,9 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 	case HVCALL_SEND_IPI:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_CLUSTER_IPI_RECOMMENDED;
+	case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
+		return hv_vcpu->cpuid_cache.features_ebx &
+				HV_ENABLE_EXTENDED_HYPERCALLS;
 	default:
 		break;
 	}
@@ -2331,6 +2340,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		goto hypercall_userspace_exit;
 	}
+	case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
+		if (unlikely(hc.fast)) {
+			ret = HV_STATUS_INVALID_PARAMETER;
+			break;
+		}
+		goto hypercall_userspace_exit;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
@@ -2489,6 +2504,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
+			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
-- 
2.38.1.273.g43a17bfeac-goog

