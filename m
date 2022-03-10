Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306244D4FA9
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbiCJQqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243089AbiCJQqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:46:53 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05315FC99
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:51 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c70-20020a624e49000000b004f69bac03d0so3596737pfb.13
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gPwG39gBAUjKtpb2sx5C4T1tsCVeZ7jn+l4C/lt8u+0=;
        b=FOOfmLQ0SfEB+1d0/7eVQI9GNQ5Hpb5D1dfnEUhLlO3eyswC3yFNrbrfft+TSB/TVt
         FyFTD1TNgHH9i5vsdNzHCRSMkbE+ei471JEthPSYWqAF2VkVCabSEovcvUROpLDTan26
         DCX97C2bipVAcqij0csXVdincPZZBfnqraghTHlQihBrSGQzaHUH1S3vNV/H0PmbsvYQ
         xPUY3FF4bf4ot+CPRBZGa6lmzuswtyGehDx/AR0/Lfb3iIndJ7XWGYbvOuG55/tk8Sm1
         /hfb3OrXQ62TYF3GUBCySrFYOSHtyxvJSgacZOFNM1XoGnvB0pcmxmEa7+mD5VsvCU6v
         +I0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gPwG39gBAUjKtpb2sx5C4T1tsCVeZ7jn+l4C/lt8u+0=;
        b=a4WhgctK8ZuwqZ+6bTmAggXLS9jkfHDUkcuHTllxHkQhfYSLr+vmrY+s11SiLG9GLE
         E1A+AqqXEXfLHlboybG96oVFtGF/bnHmYx0rMgmp1uIVe9CpyPepHAdQ+Ob4tNIiNGhl
         tcd8iY2NVo2zKYAWPlo0tf3SQy/qyTwmEDrEP/UdjhkxtgKbMzBYNdNO5gOYVzvgQILH
         JrJf0WHONKTBRI0vvjMNVXs482TSiADdhw0Z64JX4hW7oYvOsb0S22N/Nur+fwU6Fr7D
         NlYVLBp4cxQZaICEpmyK0MOFTPDLqkpPP+Uh8qjuMvcszZdn96+/wBpsqgYIerbWFssx
         D+Lw==
X-Gm-Message-State: AOAM530v5dn0GpGjQ4FF2tIEKY53d61/U1iCELsuUJr1S57nnkXd6FTE
        jE0hv4uPDEp7UoPGqDoZe1X4/nD3Ax5C
X-Google-Smtp-Source: ABdhPJx6a8q9Ai2mHAEaGDFBiensazfZswsy8JXOUdfo0t0jMG1kX20JChNmNj18Ut0VCu/2kGaktOVhfApp
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a17:90a:2b0f:b0:1bf:37d6:a49d with SMTP id
 x15-20020a17090a2b0f00b001bf37d6a49dmr6032803pjc.30.1646930750607; Thu, 10
 Mar 2022 08:45:50 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:21 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 02/13] selftests: KVM: Test reading a single stat
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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
index c5f4a67772cb..09ee70c0df26 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
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
index 4d21c3b46780..1d3493d7fd55 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2699,3 +2699,56 @@ void dump_vm_stats(struct kvm_vm *vm)
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
2.35.1.616.g0bdcbb4464-goog

