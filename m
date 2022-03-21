Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FFF4E1E77
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 01:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbiCUA2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 20:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343900AbiCUA2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 20:28:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A418DE91C
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:26:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e2-20020a17090301c200b001545acd89c9so146637plh.3
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ONXdbAN8amlEB9qh6OgAKGOjSA/PDIQV8SIv35wcs8A=;
        b=M+NOaEnG6mj6JNTytwlFELsq2MhitrDFldJcZeXo09FgI1nAz5E+TAv3aUmQVZQZnj
         3D1EbJ8yTnWcGrQnNk0NpqHgtPgIRkexkaos7Ic84kCeANiIoaiXaoVRmcNzC0r01STI
         BF33pX+0Uem/BI64+Tdln+4OqbAIgUNOoObYnK6wb6vPI/gWddA0PjEFLdkCMTcKfZdH
         M9ks8wNMR5HVMB/4es2FMurFj6AoIzhWTewYuQGw+DTIdzN/JK5ySU7ayXmkpgJYvXDv
         fq80XL3SnVLntF8x1coPEThYe+KNcfUz4NTk0WUSoiRjTJ0BCUV77/4evNYpEq0HIBK3
         GN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ONXdbAN8amlEB9qh6OgAKGOjSA/PDIQV8SIv35wcs8A=;
        b=t/2RaLqmJqko2M0TssNt+BjiWlYexXekVV6QX7WmPLiWBsjVkrTQ2pAu4b3KWv1y5d
         Z6pjGC0ZgRTQ5S+c1kpegtyixfFR35E/jP6YiWCLGAB/sJUluTy+a9KtiSoOczgnLSB/
         +5dfMRNDiUew5kQVQ/JiG+T+GlIEA0iQSZLISSUl8CVuRVwyx1JbgwV7JdHvH7qZCYFn
         iMHo44iZrVH4dJfr2DETGTy00szWuwCHWvoHNqWUkQKLESIaJsTKnlXPKSFcvXyuHswA
         JAbveYdvi4U7K5tcyy0nnQ9VwGCJLekpL4LOizA4CqYKFSZstphPrEi+TdoIX1r/2Vwe
         3tJA==
X-Gm-Message-State: AOAM530199Olx78vpon+LaLW/lpTV5BdU7IO7JSf8iVritdmB8wEMoJu
        YZ8/i4vimGi2ZC7G/pfdcI5uN/RsIfoR
X-Google-Smtp-Source: ABdhPJyQh0cpfhcq39A4la7k4keyo7dVFdF0fGkivbfV/iyl7s5g/kW3RQ8CmP/A+Tpauwan61zOFPISJtTf
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:902:b097:b0:154:2bda:bd38 with SMTP id
 p23-20020a170902b09700b001542bdabd38mr9344521plr.155.1647822403459; Sun, 20
 Mar 2022 17:26:43 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 21 Mar 2022 00:26:36 +0000
In-Reply-To: <20220321002638.379672-1-mizhang@google.com>
Message-Id: <20220321002638.379672-3-mizhang@google.com>
Mime-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 2/4] selftests: KVM: Test reading a single stat
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Retrieve the value of a single stat by name in the binary stats test to
ensure the kvm_util library functions work.

CC: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 160b9ad8474a..a07964c95941 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -393,6 +393,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void dump_vm_stats(struct kvm_vm *vm);
+uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index afc4701ce8dd..97bde355f105 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -177,6 +177,9 @@ static void vm_stats_test(struct kvm_vm *vm)
 
 	/* Dump VM stats */
 	dump_vm_stats(vm);
+
+	/* Read a single stat. */
+	printf("remote_tlb_flush: %lu\n", vm_get_single_stat(vm, "remote_tlb_flush"));
 }
 
 static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d9c660913403..dad54f5d57e7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2660,3 +2660,56 @@ void dump_vm_stats(struct kvm_vm *vm)
 	close(stats_fd);
 }
 
+static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
+			    uint64_t **data)
+{
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_header *header;
+	struct kvm_stats_desc *desc;
+	size_t size_desc;
+	int stats_fd;
+	int ret = -EINVAL;
+	int i;
+
+	*data = NULL;
+
+	stats_fd = vm_get_stats_fd(vm);
+
+	header = read_vm_stats_header(stats_fd);
+
+	stats_desc = read_vm_stats_desc(stats_fd, header);
+
+	size_desc = stats_desc_size(header);
+
+	/* Read kvm stats data one by one */
+	for (i = 0; i < header->num_desc; ++i) {
+		desc = (void *)stats_desc + (i * size_desc);
+
+		if (strcmp(desc->name, stat_name))
+			continue;
+
+		ret = read_stat_data(stats_fd, header, desc, data);
+	}
+
+	free(stats_desc);
+	free(header);
+
+	close(stats_fd);
+
+	return ret;
+}
+
+uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
+{
+	uint64_t *data;
+	uint64_t value;
+	int ret;
+
+	ret = vm_get_stat_data(vm, stat_name, &data);
+	TEST_ASSERT(ret == 1, "Stat %s expected to have 1 element, but has %d",
+		    stat_name, ret);
+	value = *data;
+	free(data);
+	return value;
+}
+
-- 
2.35.1.894.gb6a874cedc-goog

