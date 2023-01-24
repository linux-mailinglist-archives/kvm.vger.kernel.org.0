Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD55667A730
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbjAXXtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbjAXXt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:49:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3BD49560
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:23 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id s24-20020a17090aa11800b00229fef3ac5dso131772pjp.5
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UzMRX5SFUfOVkL2DhNd2WmgacyEPpUxAyESmr0cYTPo=;
        b=U+2hjRjwdAw4rgSwJT4rTLx+XWZ6VA8xRr9CDH5MmtQ0DMC6I8AZu0utxcCMToxUt0
         qEvmcAkPf0Z2PX0nGGVKoNQUWR9l3i/D88vwPrfs8FLHGmwsaNXkyQ4SaZ0wNIo8qhJZ
         R8B0xXP4sv2OG4APlw8RdWx2ZdMWW2NUv5HfnHJ7M+2LhRT5WIz/p0YGDe3qGGVS8kRc
         WcwkOSYbpY2N7QzFWXEuHkLkmO9KTO0XKtPlZ+kjdrEluzgZ2iPKY0u7rrxc+5NhusWx
         XxSaFjfe7ss8AqeFDPdA+yjfi8DZ9I7MtXqYDCSNAlrfv5iKsocGtMA8YD6lzk6vGcYX
         foLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UzMRX5SFUfOVkL2DhNd2WmgacyEPpUxAyESmr0cYTPo=;
        b=zZgVgrV/FUhrrcB+Ydf0zo0mYng0dmXZZ6anyJcyJxHbgSrrx+86XvLfRaMknKgLqM
         QpIaUJ4PlFD/2bA1ECsj15huoCxF8eeX77ivZGtvxGsqVN9klZNhLazj50+bmQY0ptUQ
         CscGIDFYF3uzVLF46nCncGg/VGzKFa9pMYojdsKXiNuX1ld6cGvx0kIKslg+8HXPiQJs
         YyKwZKoWID4BrU4JrQoY3MOG2XkI0LmJMsURxWVM7Q5uPpTTbPXEJeiEPxwbWuIeKSjS
         Ec16CGg4gQF9mymWvUwDo4oXMDnnaJupEGs3AE4nBU4mksutEnvIFARzRlQA+BKaYJ6N
         jFaA==
X-Gm-Message-State: AFqh2krRzv4Td521abKrYFHMsErgbjARjA5IRnVkDTdLhllHAAvCIiZn
        KxCgOFiuzyFIpXfVTT7cSt2se5soj4c=
X-Google-Smtp-Source: AMrXdXuK/2YHhj4eTdRh15QrAi1gGGAbhQFHxWDpJQGzDuXV8X4TYOIqARvH1aClbII5MaCT1Ll9QeXYTuY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4088:b0:576:cc71:b8e4 with SMTP id
 bw8-20020a056a00408800b00576cc71b8e4mr3170694pfb.20.1674604163135; Tue, 24
 Jan 2023 15:49:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 24 Jan 2023 23:49:05 +0000
In-Reply-To: <20230124234905.3774678-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230124234905.3774678-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230124234905.3774678-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: x86/pmu: Provide "error" semantics for
 unsupported-but-known PMU MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
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

Provide "error" semantics (read zeros, drop writes) for userspace accesses
to MSRs that are ultimately unsupported for whatever reason, but for which
KVM told userspace to save and restore the MSR, i.e. for MSRs that KVM
included in KVM_GET_MSR_INDEX_LIST.

Previously, KVM special cased a few PMU MSRs that were problematic at one
point or another.  Extend the treatment to all PMU MSRs, e.g. to avoid
spurious unsupported accesses.

Note, the logic can also be used for non-PMU MSRs, but as of today only
PMU MSRs can end up being unsupported after KVM told userspace to save and
restore them.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 51 ++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c49c86b973d..64c567a1b32b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3561,6 +3561,18 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
+static bool kvm_is_msr_to_save(u32 msr_index)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_msrs_to_save; i++) {
+		if (msrs_to_save[i] == msr_index)
+			return true;
+	}
+
+	return false;
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u32 msr = msr_info->index;
@@ -3876,20 +3888,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
-	case MSR_IA32_PEBS_ENABLE:
-	case MSR_IA32_DS_AREA:
-	case MSR_PEBS_DATA_CFG:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
+
 		/*
 		 * Userspace is allowed to write '0' to MSRs that KVM reports
 		 * as to-be-saved, even if an MSRs isn't fully supported.
 		 */
-		return !msr_info->host_initiated || data;
-	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr))
-			return kvm_pmu_set_msr(vcpu, msr_info);
+		if (msr_info->host_initiated && !data &&
+		    kvm_is_msr_to_save(msr))
+			break;
+
 		return KVM_MSR_RET_INVALID;
 	}
 	return 0;
@@ -3979,20 +3989,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
 		msr_info->data = 0;
 		break;
-	case MSR_IA32_PEBS_ENABLE:
-	case MSR_IA32_DS_AREA:
-	case MSR_PEBS_DATA_CFG:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info);
-		/*
-		 * Userspace is allowed to read MSRs that KVM reports as
-		 * to-be-saved, even if an MSR isn't fully supported.
-		 */
-		if (!msr_info->host_initiated)
-			return 1;
-		msr_info->data = 0;
-		break;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
@@ -4248,6 +4244,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
+
+		/*
+		 * Userspace is allowed to read MSRs that KVM reports as
+		 * to-be-saved, even if an MSR isn't fully supported.
+		 */
+		if (msr_info->host_initiated &&
+		    kvm_is_msr_to_save(msr_info->index)) {
+			msr_info->data = 0;
+			break;
+		}
+
 		return KVM_MSR_RET_INVALID;
 	}
 	return 0;
-- 
2.39.1.456.gfc5497dd1b-goog

