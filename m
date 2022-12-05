Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8006431B8
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiLETPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiLETO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:57 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D8825283
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:55 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id t1-20020a170902b20100b001893ac9f0feso14253149plr.4
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NZHzs4R3RCX31QVVJ85BRVRRL92U9PEqEoHkfVCQmZs=;
        b=X/UIA2KUIDIIls91CERs54EbSIQLyg2N577Z885xdpzw7J/Sg/wwRmjZYnMc/1T1W2
         goVJ1vyRrpWT7twWQ549uwcP/ftrwMt4yS1mwXcmVtiHci1tlOZXQUgFT1GPgFfSzDWy
         r+eIp/+xPM4cKEqKUljwufx50XSpVrvpDkpgqHPj/EeAQ3S6WuUjOI2Pd6hQam3Jn3t0
         X9T7d60x6yZVGx7fWraziYInrfYask20kf3C5dckoI9QXEPQFKWGMnnh9pgilIziAwXe
         3DS4Q6Eb5AKwf8gogC78FaHpy93VXjXh3fVrY/xmWOSkyAf+u5nDrCkZn2MagL2Rv8xT
         PrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZHzs4R3RCX31QVVJ85BRVRRL92U9PEqEoHkfVCQmZs=;
        b=0HY9/O6ZY1HoafGtkRdOOT3UgOTn9gy0ETSVCXELUL5FG2R6lCuOpO4+OyGtknJCUX
         fOhyS5QLEytnbiSJOSZcnrBaXJel2eCSLrapZ2scDg8QMoUIX6DMWP88C0cVPXeta9tI
         MJ9H21DpSiKDq1XuA9hPQJAObIu/1j7Gy7uhsHHLQngvvHlrTL0xK1KrcBZaNrXBY3yt
         WUDexPCj3lmVLcunMEx5N/+sOtfW2upj4bXVWJylDQdIsh22Ljoega/tbD0ifYkOtXWl
         6B8+YcmiRQXvs6FOUrLdLCnZqkx3OpNuplwZrZSprXkMXFDLMBxdq2ms6dRm9mndLmZa
         04sA==
X-Gm-Message-State: ANoB5pmKblpV6PiBCVREbTC7fZTvReZe+5NRqrU0P65RyUdyxdPcbf+e
        9k4sQEMxdlMDtumgE28A/ADTF+KSHxMG
X-Google-Smtp-Source: AA0mqf4CwGGTkFzIjAy/Yamf0HQ5Vuww80ot+BMy4O9RlnDW1BLSjOSWEv9cyZaWXbVDEn4Nz0H3MvjXFku4
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:3017:b0:56b:ac5c:f3dc with SMTP
 id ay23-20020a056a00301700b0056bac5cf3dcmr68084036pfb.77.1670267694980; Mon,
 05 Dec 2022 11:14:54 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:26 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-10-vipinsh@google.com>
Subject: [Patch v3 09/13] KVM: x86: hyper-v: Add extended hypercall support in Hyper-v
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

---
 arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2eb68533d188..e232ea578ba5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -43,6 +43,24 @@
 
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, HV_VCPUS_PER_SPARSE_BANK)
 
+/*
+ * As per Hyper-V TLFS, extended hypercalls start from 0x8001
+ * (HvExtCallQueryCapabilities). Response of this hypercalls is a 64 bit value
+ * where each bit tells which extended hypercall is available besides
+ * HvExtCallQueryCapabilities.
+ *
+ * 0x8001 - First extended hypercall, HvExtCallQueryCapabilities, no bit
+ * assigned.
+ *
+ * 0x8002 - Bit 0
+ * 0x8003 - Bit 1
+ * ..
+ * 0x8041 - Bit 63
+ *
+ * Therefore, HV_EXT_CALL_MAX = 0x8001 + 64
+ */
+#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
+
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
 
@@ -2429,6 +2447,9 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 	case HVCALL_SEND_IPI:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_CLUSTER_IPI_RECOMMENDED;
+	case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
+		return hv_vcpu->cpuid_cache.features_ebx &
+				HV_ENABLE_EXTENDED_HYPERCALLS;
 	default:
 		break;
 	}
@@ -2582,6 +2603,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
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
@@ -2741,6 +2768,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
+			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

