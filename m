Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E139267620B
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjAUART (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAUARQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:17:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9EEE0507
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:16:42 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n203-20020a2572d4000000b0078f09db9888so7425905ybc.18
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KI3lc8Qa4odfGOnk3uFPbmARvL0LzJJulpfkNFBemzE=;
        b=j/DoN5zQelvEIRLCNJ8mAtnltfQSsXNmZd7BctX5fFtP93iKxLb9ixSdg2WNzWXI78
         Ymx4YT8j6gfC4S6iRGU2Mv9y37Y4oNY9lD65dIbpSdOS6kCagdOWk3kCH9NHdtlMKpBK
         zrab/5Y4g5ZpSDO89l27WlSh7FWKZvCBoO+ngfQJqga0zg0Xv6OOuKB+CskX3EQBKUDL
         4NMMkETMJiH0CE9dHx6V7b+dTQ8/fNKEXvzF9sKarkFVYUTEIV3xV6y7vlWErO+ikPCX
         S1PKylJo4o8pamn+0IEOijoaChvstVTTV/6yT2yRWDAIWakbcRSApbdS84IF+dz5R0DS
         ZAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KI3lc8Qa4odfGOnk3uFPbmARvL0LzJJulpfkNFBemzE=;
        b=5+MuqV04WFpDK0sbH2GNILni7ejCdTkr65SpMZPUs5fgmNB/KYOQCAEdculqcR+Rxh
         nrcj4KZKGfFkWMfBSv3hfgGSYkeEE3MJ8iJPeLUCmnU1Z0riSJB4RZDhbiPFXb3RWGpw
         dFMJzXecJbY7Gw6N8Lq1Rj8fCCm85n3jOd/21v5FXt9JKaakhMBEz3A7okJbnKiZeslp
         0jvAc0I9DSVFUq79fdQ8hxqQszHxVA2vkTR1aK9RLmNwT6cIQS8ztmTUJUfjbriIZwGF
         lTCbBcAMFKmx5yfBy2T/h2ReNogkK31YuJAWtrG9CC0Cgj0hjwRKtJ7o4vS3H5VG1d+i
         prbg==
X-Gm-Message-State: AFqh2kobYEruOYZsVEjMVi6MTKwq3NUiHv61guKzmHfYSSo76AcftbRk
        +YjWQeO/AY2C2b/84Fhp4HY96xzw3FB0DY8ytA==
X-Google-Smtp-Source: AMrXdXtydJEIawtxpXOqiqaHbL6Dx7DCG8iZopOtBwRlFXexLweXPTHCILvbivdlZGIN05ch6GxDlBjxhQwV/oNYRg==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a81:9257:0:b0:3df:ba1d:f51a with SMTP
 id j84-20020a819257000000b003dfba1df51amr2347624ywg.64.1674260201622; Fri, 20
 Jan 2023 16:16:41 -0800 (PST)
Date:   Sat, 21 Jan 2023 00:15:18 +0000
In-Reply-To: <20230121001542.2472357-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230121001542.2472357-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230121001542.2472357-8-ackerleytng@google.com>
Subject: [RFC PATCH v3 07/31] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
 validate TDs' attribute configuration
From:   Ackerley Tng <ackerleytng@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
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

This also exercises the KVM_TDX_CAPABILITIES ioctl.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/lib/x86_64/tdx/tdx_util.c   | 75 ++++++++++++++++++-
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
index 3564059c0b89b..2e9679d24a843 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
@@ -27,10 +27,9 @@ static char *tdx_cmd_str[] = {
 };
 #define TDX_MAX_CMD_STR (ARRAY_SIZE(tdx_cmd_str))
 
-static void tdx_ioctl(int fd, int ioctl_no, uint32_t flags, void *data)
+static int _tdx_ioctl(int fd, int ioctl_no, uint32_t flags, void *data)
 {
 	struct kvm_tdx_cmd tdx_cmd;
-	int r;
 
 	TEST_ASSERT(ioctl_no < TDX_MAX_CMD_STR, "Unknown TDX CMD : %d\n",
 		    ioctl_no);
@@ -40,11 +39,63 @@ static void tdx_ioctl(int fd, int ioctl_no, uint32_t flags, void *data)
 	tdx_cmd.flags = flags;
 	tdx_cmd.data = (uint64_t)data;
 
-	r = ioctl(fd, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+	return ioctl(fd, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+}
+
+static void tdx_ioctl(int fd, int ioctl_no, uint32_t flags, void *data)
+{
+	int r;
+
+	r = _tdx_ioctl(fd, ioctl_no, flags, data);
 	TEST_ASSERT(r == 0, "%s failed: %d  %d", tdx_cmd_str[ioctl_no], r,
 		    errno);
 }
 
+static struct kvm_tdx_capabilities *tdx_read_capabilities(void)
+{
+	int i;
+	int rc = -1;
+	int nr_cpuid_configs = 4;
+	struct kvm_tdx_capabilities *tdx_cap = NULL;
+	int kvm_fd;
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+
+	do {
+		nr_cpuid_configs *= 2;
+
+		tdx_cap = realloc(
+			tdx_cap, sizeof(*tdx_cap) +
+			nr_cpuid_configs * sizeof(*tdx_cap->cpuid_configs));
+		TEST_ASSERT(tdx_cap != NULL,
+			    "Could not allocate memory for tdx capability nr_cpuid_configs %d\n",
+			    nr_cpuid_configs);
+
+		tdx_cap->nr_cpuid_configs = nr_cpuid_configs;
+		rc = _tdx_ioctl(kvm_fd, KVM_TDX_CAPABILITIES, 0, tdx_cap);
+	} while (rc < 0 && errno == E2BIG);
+
+	TEST_ASSERT(rc == 0, "KVM_TDX_CAPABILITIES failed: %d %d",
+		    rc, errno);
+
+	pr_debug("tdx_cap: attrs: fixed0 0x%016llx fixed1 0x%016llx\n"
+		 "tdx_cap: xfam fixed0 0x%016llx fixed1 0x%016llx\n",
+		 tdx_cap->attrs_fixed0, tdx_cap->attrs_fixed1,
+		 tdx_cap->xfam_fixed0, tdx_cap->xfam_fixed1);
+
+	for (i = 0; i < tdx_cap->nr_cpuid_configs; i++) {
+		const struct kvm_tdx_cpuid_config *config =
+			&tdx_cap->cpuid_configs[i];
+		pr_debug("cpuid config[%d]: leaf 0x%x sub_leaf 0x%x eax 0x%08x ebx 0x%08x ecx 0x%08x edx 0x%08x\n",
+			 i, config->leaf, config->sub_leaf,
+			 config->eax, config->ebx, config->ecx, config->edx);
+	}
+
+	close(kvm_fd);
+
+	return tdx_cap;
+}
+
 #define XFEATURE_LBR 15
 #define XFEATURE_XTILECFG 17
 #define XFEATURE_XTILEDATA 18
@@ -90,6 +141,21 @@ static void tdx_apply_cpuid_restrictions(struct kvm_cpuid2 *cpuid_data)
 	}
 }
 
+static void tdx_check_attributes(uint64_t attributes)
+{
+	struct kvm_tdx_capabilities *tdx_cap;
+
+	tdx_cap = tdx_read_capabilities();
+
+	/* TDX spec: any bits 0 in attrs_fixed0 must be 0 in attributes */
+	ASSERT_EQ(attributes & ~tdx_cap->attrs_fixed0, 0);
+
+	/* TDX spec: any bits 1 in attrs_fixed1 must be 1 in attributes */
+	ASSERT_EQ(attributes & tdx_cap->attrs_fixed1, tdx_cap->attrs_fixed1);
+
+	free(tdx_cap);
+}
+
 static void tdx_td_init(struct kvm_vm *vm, uint64_t attributes)
 {
 	const struct kvm_cpuid2 *cpuid;
@@ -100,6 +166,9 @@ static void tdx_td_init(struct kvm_vm *vm, uint64_t attributes)
 	cpuid = kvm_get_supported_cpuid();
 
 	memcpy(&init_vm.cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
+
+	tdx_check_attributes(attributes);
+
 	init_vm.attributes = attributes;
 
 	tdx_apply_cpuid_restrictions(&init_vm.cpuid);
-- 
2.39.0.246.g2a6d74b583-goog

