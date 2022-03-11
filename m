Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBDC4D5B50
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiCKGFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347305AbiCKGDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:55 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDC81A94A7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:21 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x9-20020a5b0809000000b00631d9edfb96so343091ybp.22
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VT9WintL5Ym+JFx3Nrk1+phRO6aH7MpQMfJGQNhWh1Y=;
        b=bFwfK4JfAVkqt1tf1xHmAoL0M7Njs7QuwGIqTRa8PLO4taBTNEwTDqtWBKaJCOyJ0P
         xpAFdOW1mJU3zu63xQ/Ce81U/7FRPYtPABCVYBFNt732Ok7zamOgqU/kxAchk2YSGZ28
         U52+TD4btpOnoXkni3xSFcbRoBaKJ7OmnSBSsHRtPi9QWtXbhRXUOYaCTvcb9dMYCkSm
         uVFv2zzrTHuKlS6VhQy/eJNk92FikqybqbOH9wlUQTTnZn64djBqiSm/4SIGlm/jLOuF
         2raR5vAQfu2pHjnyAQ/4ezZibVDeMuC9YGNK1whVK8cZMDswLjiQh4EYKJ5qamovBqLi
         e0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VT9WintL5Ym+JFx3Nrk1+phRO6aH7MpQMfJGQNhWh1Y=;
        b=Y3vw7RZGmUqphEFfKPMuaKoXIw8/ZD/D3jjJxZHRtnhoyXOR3FE2Sj4aQpzGnlwJR2
         Emh3vmW2Q7ZH2Y6sVgDKcu9wBBDLB1aF4FANakUn/YcPpzSgIfQWVvDdmZMQtfqnl+aG
         2bipxIZoHZAf8kzFG9P7KG4wzFbrz62RPPMiX2f5TybHc10Cz4Dlw/08DtyRg37aRvPV
         RN2iJmd3G6MgllIXh/LVhmtXWEJF07PWzzDXkaYZhu6UNE48MGczDXHRG1GtBjntpNK5
         6aJwhwhrTvaG3ifTijXLWBLkuSvUsHNAg0Jiw5F5DK0jUYSStRtnqdssJXENtrYZkSM7
         hpeA==
X-Gm-Message-State: AOAM530dv5qcAJISrE4NI95648ObJX2o6km3a33ZnNj7Gj692PfJygqC
        YHcVSQt4csuui0dr6habVetCwe2/yQyyDXscZvrVj3dsuIvIq1yXERkSMWnjxVC7PUtSB2E+RZP
        RobgS4p73sZhmqC03EmPnsezXsxBiZ5DZLBTeBtFr+RGckvnzVDockyu2mnZGaZE=
X-Google-Smtp-Source: ABdhPJyYTefolyTnht2/9c+t/yVvGC6aP5qIxASi1iZ8EPO20HO7P4WKmQotUQLTiX7IG4nmmi9g4mmhuDGEcA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:be8b:0:b0:628:bf04:f8d9 with SMTP id
 i11-20020a25be8b000000b00628bf04f8d9mr6695328ybk.472.1646978540808; Thu, 10
 Mar 2022 22:02:20 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:02:02 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 06/11] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ae21564241c8..c25c79f97695 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -702,6 +702,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	if (region->fd >= 0) {
+	/* There's an extra map if shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.35.1.723.g4982287a31-goog

