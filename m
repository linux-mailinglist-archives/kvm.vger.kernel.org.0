Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE05771D51
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjHGJnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 05:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjHGJnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 05:43:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754401701;
        Mon,  7 Aug 2023 02:43:15 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-564a0d2d35eso2052648a12.0;
        Mon, 07 Aug 2023 02:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691401395; x=1692006195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=39EEzKezMc6xodopxuIo6ZRgeTbCfZRChxumxhtp/FM=;
        b=mxHMQyaSOiY/aS8yiBkShK4dgrs5QZh/U6y6Bn0Pq1T5awerX0miafCAX/nu3cExWk
         AtFEZ32D76TRkEy3VZLIl+g5W4xow6g+BLcCfu8HDUSPQfmbDBxlPE/oVRsdS90USkoU
         /sOtP7ExllQI1x8dSCTk8Uyz4R71+vMEX7G0tEfOZasR0pT69Yp2foaLY7tc9Co9/6Fr
         IhQrltu+Z7sGrT4SgtZNFfPFi503qsQqJ52hkaxfgK5bCN97ffU+z6jqNjwQwURUUto6
         brSre94XpxeX7vaEcwjlT/qs5LWNUe7JzTs5ciFbpMMf+SABP3juqSEEAjNaFy2ZiSH0
         N2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691401395; x=1692006195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=39EEzKezMc6xodopxuIo6ZRgeTbCfZRChxumxhtp/FM=;
        b=LEsgKMIEc59S1OhrIZ/nbC3Wa6F6tzImWRjCLTTuNiigy+sSD3ZWIWWB8QEtreK8Cb
         z4i1n8W1O3u1nEOH2DzgYtreEgLavi1iroNOc0hOfEBffsIxBPwfgHX6UkPksN3qWJgL
         5d7wrhrtZ3unGDqmEcZxA1ZufvTEfD69UrO+JElGm5wOKzpfuhy9Uxdkk5CqSIxy7CKo
         bGNk9Jah8UvkJOMNgB3hTWgu66hHeg2mHdoBcDUQVSy5/Ksmyxu4bUHarnAQYkN5a615
         od+0p+QKX5E5m+8Veh3lRtCa/wd+Sj9bq3OEH0FHR5QHnaPbklWMAk239VNMnJVoKbGt
         fDaw==
X-Gm-Message-State: AOJu0YysavM48EeptqKvmkKAzlhUH6Dmi/rYYM4gVVx0KsVEtNd5m8I7
        NfM79CM09Px1U0AF71RpB3DDBKcNPLs4IKxB
X-Google-Smtp-Source: AGHT+IEyvi0w+FbeS2J9jh2Ijk09DU3+vm7M8mAkJGMtD9RfKYx/4/VZfsNOCDcBY9/hA6wqlap61A==
X-Received: by 2002:a05:6a20:428f:b0:140:6979:2952 with SMTP id o15-20020a056a20428f00b0014069792952mr5111915pzj.47.1691401394599;
        Mon, 07 Aug 2023 02:43:14 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090311c800b001bc675068e2sm2572378plh.111.2023.08.07.02.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 02:43:14 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Remove break statements that will never be executed
Date:   Mon,  7 Aug 2023 17:42:43 +0800
Message-ID: <20230807094243.32516-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Fix compiler warnings when compiling KVM with [-Wunreachable-code-break].
No functional change intended.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/emulate.c | 2 --
 arch/x86/kvm/hyperv.c  | 1 -
 arch/x86/kvm/x86.c     | 1 -
 3 files changed, 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 936a397a08cd..2673cd5c46cb 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1799,13 +1799,11 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 					       op->addr.mem,
 					       &op->val,
 					       op->bytes);
-		break;
 	case OP_MEM_STR:
 		return segmented_write(ctxt,
 				       op->addr.mem,
 				       op->data,
 				       op->bytes * op->count);
-		break;
 	case OP_XMM:
 		kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
 		break;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b28fd020066f..7c2dac6824e2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1293,7 +1293,6 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_VP_ASSIST_PAGE:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_MSR_APIC_ACCESS_AVAILABLE;
-		break;
 	case HV_X64_MSR_TSC_FREQUENCY:
 	case HV_X64_MSR_APIC_FREQUENCY:
 		return hv_vcpu->cpuid_cache.features_eax &
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34945c7dba38..f3f8d27acc96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4647,7 +4647,6 @@ static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
 		return 0;
 	default:
 		return -ENXIO;
-		break;
 	}
 }
 

base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0

