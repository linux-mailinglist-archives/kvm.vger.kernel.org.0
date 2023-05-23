Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8320970E613
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 21:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbjEWTzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 15:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbjEWTzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 15:55:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EEA130
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 12:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684871694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zNmXH+90JUJ7ZzD9zSZr+aTZro/+2dtu4Fp8oSsNfvs=;
        b=BSOyJRD/zwXd2VX9CnBo/WC47P3Z38+VocoHNrQyrXFPlKJFhdvg4YqL6xCyXKzf1PdxMy
        KGTTIA4/sw/XqszD54XGU7NCihKgJ+2zRajX30259OlV4iDjAN/YS+OqunMlKGFUsJcELe
        WKI8AlY66RsxsdBJjLYuFShy/+ZsKQE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-PRxfwqV2MESvbc8Age1qzg-1; Tue, 23 May 2023 15:54:50 -0400
X-MC-Unique: PRxfwqV2MESvbc8Age1qzg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34D10185A78B;
        Tue, 23 May 2023 19:54:50 +0000 (UTC)
Received: from work.redhat.com (unknown [10.39.193.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA612492B00;
        Tue, 23 May 2023 19:54:48 +0000 (UTC)
From:   Tim Wiederhake <twiederh@redhat.com>
To:     "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Tim Wiederhake <twiederh@redhat.com>
Subject: [PATCH 2/2] x86/msr: Allow unprivileged read access to some MSRs
Date:   Tue, 23 May 2023 21:49:49 +0200
Message-Id: <20230523194949.96149-2-twiederh@redhat.com>
In-Reply-To: <20230523194949.96149-1-twiederh@redhat.com>
References: <20230523194949.96149-1-twiederh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delaying access control allows unprivileged processes to
read specific MSRs, such as IA32_CORE_CAPABILITIES and
IA32_ARCH_CAPABILITIES. This is helpful for e.g. qemu and
libvirt who require the raw MSR content to calculate host
CPU capabilities. Other programs might be interested in
IA32_EFER for x86-64-v1 detection.

Signed-off-by: Tim Wiederhake <twiederh@redhat.com>
---
 arch/x86/kernel/msr.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 058f2b67d0c7..9485aa7f8161 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -50,6 +50,23 @@ enum allow_write_msrs {
 
 static enum allow_write_msrs allow_writes = MSR_WRITES_DEFAULT;
 
+static int filter_read(struct file *file, u32 reg)
+{
+	if (file->private_data)
+		return 0;
+
+	switch (reg) {
+	case MSR_IA32_CORE_CAPS:
+	case MSR_IA32_ARCH_CAPABILITIES:
+	case MSR_EFER:
+		return 0;
+	default:
+		break;
+	}
+
+	return -EPERM;
+}
+
 static ssize_t msr_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
@@ -59,6 +76,10 @@ static ssize_t msr_read(struct file *file, char __user *buf,
 	int cpu = iminor(file_inode(file));
 	int err = 0;
 
+	err = filter_read(file, reg);
+	if (err)
+		return err;
+
 	if (count < 8)
 		return -EINVAL;	/* Invalid chunk size */
 
@@ -71,7 +92,7 @@ static ssize_t msr_read(struct file *file, char __user *buf,
 	return 8;
 }
 
-static int filter_write(u32 reg)
+static int filter_write(struct file *file, u32 reg)
 {
 	/*
 	 * MSRs writes usually happen all at once, and can easily saturate kmsg.
@@ -83,6 +104,9 @@ static int filter_write(u32 reg)
 	 */
 	static DEFINE_RATELIMIT_STATE(fw_rs, 30 * HZ, 1);
 
+	if (!file->private_data)
+		return -EPERM;
+
 	switch (allow_writes) {
 	case MSR_WRITES_ON:  return 0;
 	case MSR_WRITES_OFF: return -EPERM;
@@ -113,7 +137,7 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	if (err)
 		return err;
 
-	err = filter_write(reg);
+	err = filter_write(file, reg);
 	if (err)
 		return err;
 
@@ -156,6 +180,9 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
+		err = filter_read(file, regs[1]);
+		if (err)
+			return err;
 		err = rdmsr_safe_regs_on_cpu(cpu, regs);
 		if (err)
 			break;
@@ -176,7 +203,7 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 		if (err)
 			break;
 
-		err = filter_write(regs[1]);
+		err = filter_write(file, regs[1]);
 		if (err)
 			return err;
 
@@ -202,8 +229,7 @@ static int msr_open(struct inode *inode, struct file *file)
 	unsigned int cpu = iminor(file_inode(file));
 	struct cpuinfo_x86 *c;
 
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
+	file->private_data = (void *)(capable(CAP_SYS_RAWIO));
 
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 		return -ENXIO;	/* No such CPU */
@@ -245,6 +271,8 @@ static int msr_device_destroy(unsigned int cpu)
 
 static char *msr_devnode(const struct device *dev, umode_t *mode)
 {
+	if (mode)
+		*mode = 0644;
 	return kasprintf(GFP_KERNEL, "cpu/%u/msr", MINOR(dev->devt));
 }
 
-- 
2.39.2

