Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59018715BB6
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 12:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjE3K2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 06:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjE3K1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 06:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBB3118
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 03:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685442283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsvjGa+MnzAcT7Atgh+LbY2eQJDEHuopXF1gXnP8V0E=;
        b=BIJ449tz3ayEoMKixLbHrmiYvZmPbjTvKX/+hd+BicbLXKpzRRq/+1dmdnu5o8jyxbkDn3
        PPckbcL1doOUlmlhsA9fG8uCHeyYQpjbruVURjd+L7NFIBCASdwdmC5wqu3SH+823DLL17
        Z7GFviB9fogfcAL50G+adjBUh68F3sI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-NOWmwAIAPHuFk00q8Sb5YQ-1; Tue, 30 May 2023 06:24:40 -0400
X-MC-Unique: NOWmwAIAPHuFk00q8Sb5YQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE0EB85A5BD;
        Tue, 30 May 2023 10:24:39 +0000 (UTC)
Received: from work.fritz.box (unknown [10.39.193.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 493C2420AA;
        Tue, 30 May 2023 10:24:38 +0000 (UTC)
From:   Tim Wiederhake <twiederh@redhat.com>
To:     "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Tim Wiederhake <twiederh@redhat.com>
Subject: [PATCH v2] x86/msr: Allow unprivileged read access to some MSRs
Date:   Tue, 30 May 2023 12:23:58 +0200
Message-Id: <20230530102358.16430-1-twiederh@redhat.com>
In-Reply-To: <20230523194949.96149-1-twiederh@redhat.com>
References: <20230523194949.96149-1-twiederh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Software such as qemu and libvirt require the raw content of some MSRs
to calculate host CPU capabilities. This is currently done through
/dev/cpu/*/msr which is locked behind both CAP_SYS_RAWIO and file mode
0600, allowing only root to read and write MSRs.

Expose some non-security sensitive MSRs through sysfs to allow access
for unprivileged processes. This also helps other programs that are
interested in IA32_EFER for x86-64-v1 detection.

Signed-off-by: Tim Wiederhake <twiederh@redhat.com>
---
Changes to v1 (https://lkml.org/lkml/2023/5/23/1230):
* removed patch to limit reads to /dev/cpu/*/msr to 8 bytes per read
* removed CAP_SYS_RAWIO-less access to /dev/cpu/*/msr
* introduced sysfs interface to msrs

With this sysfs-based, unrestricted read access to some select msrs in
place, a later patch could introduce checks for CAP_SYS_RAWIO for every
access to /dev/cpu/*/msr as mentioned in the feedback to v1.
---
 arch/x86/kernel/msr.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7bb17d37db01..3c8354f3c2bd 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -50,6 +50,31 @@ enum allow_write_msrs {
 
 static enum allow_write_msrs allow_writes = MSR_WRITES_DEFAULT;
 
+struct allow_read_msrs {
+	const char *procname;
+	u32 index;
+	u32 value[2];
+};
+
+static struct allow_read_msrs allow_reads[] = {
+	{
+		.procname = "ia32_core_caps",
+		.index = MSR_IA32_CORE_CAPS,
+	},
+	{
+		.procname = "ia32_arch_capabilities",
+		.index = MSR_IA32_ARCH_CAPABILITIES,
+	},
+	{
+		.procname = "efer",
+		.index = MSR_EFER,
+	},
+};
+
+static struct ctl_table msr_files[ARRAY_SIZE(allow_reads) + 1];
+
+static struct ctl_table_header *msr_files_header;
+
 static ssize_t msr_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
@@ -258,6 +283,25 @@ static char *msr_devnode(const struct device *dev, umode_t *mode)
 static int __init msr_init(void)
 {
 	int err;
+	int i, j;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(allow_reads); ++i) {
+		err = rdmsr_safe_on_cpu(0, allow_reads[i].index,
+					&allow_reads[i].value[0],
+					&allow_reads[i].value[1]);
+		if (err)
+			continue;
+		msr_files[j].procname = allow_reads[i].procname;
+		msr_files[j].data = &allow_reads[i].value;
+		msr_files[j].maxlen = 2 * sizeof(u32);
+		msr_files[j].mode = 0444;
+		msr_files[j].proc_handler = proc_doulongvec_minmax;
+		++j;
+	}
+
+	msr_files_header = register_sysctl("vm/msr", msr_files);
+	if (!msr_files_header)
+		return -ENOMEM;
 
 	if (__register_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr", &msr_fops)) {
 		pr_err("unable to get major %d for msr\n", MSR_MAJOR);
@@ -287,6 +331,7 @@ module_init(msr_init);
 
 static void __exit msr_exit(void)
 {
+	unregister_sysctl_table(msr_files_header);
 	cpuhp_remove_state(cpuhp_msr_state);
 	class_destroy(msr_class);
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
-- 
2.39.2

