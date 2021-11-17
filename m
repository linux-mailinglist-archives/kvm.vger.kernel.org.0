Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2945414B
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhKQG4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbhKQGz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:55:59 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5F5C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:01 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id l8-20020a056a0016c800b0049ffee8cebfso1093947pfc.20
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EWy90w7C8DEQ1vuhiOPoGiKAV2Py3BtH8vbgtJOob/M=;
        b=farwWaGHDp+BJPkIl9cjFCayMUEmwN32tMCgYlXLKI11ppCFUHe2zJGtjZbWjUwkRr
         yPM9N8gd7kYnReGOSL1Za3CcPR79kRzCUVmBh9dHLbUPbJIcE7b1HaqIoka5NOGOMUD9
         KjuFnNcXm4Y0gjLrBTYa4TPv7PV19P+647eUqA1GmjiA5J9+NxB5Ju9jfzOyadu6PCF4
         HwH660ONcWXcuuecLlZycXkSp3eaaEtZmZ8v9Cm1VreF4Mkr9lOEOWzuDQCqyg/szpTS
         dXe+J145D096FZQIdLj37NnlGYV0cirsUNPWclerfciCDssRW3GgCD70vV3vp3KEetIL
         P4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EWy90w7C8DEQ1vuhiOPoGiKAV2Py3BtH8vbgtJOob/M=;
        b=gbwDopCZQdZT9H50wHZz9Yvv4sCoy7PDvWDN/buq8YF5BL+wmbol7JELFtSstu8Aj2
         Pc+lsh8B3M9Kaavm0OCUmRwv7JmQg20t0Cf9k83V2F7/9nlma4cD/HjimL47aqtc6/93
         9RJpvjVeCTczMEmMAi0oCvYuD17Jp5XfVRX3qBjrz1ZAPgcwocuC+W1JOxnlTH3TWzu0
         UAS++ESU+JGPVb/ofwMdmshugklIFUZBtSqna4UhgnIbYnmHKW+Fp2NC8wwFvYxZKF36
         UrBle7NqsLl/6dLtuSmvYwAnTtYOCBg37Qj94JNl6ZxVJrZUcxNFdjzfnhNre9LGPY5b
         RSgw==
X-Gm-Message-State: AOAM5330LWRZNjdl2zEWr19KVbQGDa8KTmV6snNNbobQzukrvDWIYBhS
        t4iCXxTCzhQM+kkJGOHHMz3Rpx8P/sU=
X-Google-Smtp-Source: ABdhPJxTX5Ui25fj7I1/W09kifmBD7hv5qJ71Mwl9g4XyAIXdzKDt8IM28bi7JUXoF+/FHXLa6ILu2RhNVw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:390c:: with SMTP id
 y12mr314550pjb.0.1637131980501; Tue, 16 Nov 2021 22:53:00 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:39 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-10-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
exopse 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..fd7ad8193827 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.34.0.rc1.387.gb447b232ab-goog

