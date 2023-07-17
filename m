Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD97559AE
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjGQCgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjGQCgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:36:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2010.outbound.protection.outlook.com [40.92.20.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8926198E;
        Sun, 16 Jul 2023 19:36:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsityHI1pAGPTlveMkzhp7k4f+UhYD5PUM0tXPdDB37U+P4BE9xk84E/WqR02JxCb7pEp414TvEiLTrDW/q8CvcKeGThcEkhTXDI9NAFocG/XHopwOeQYzwaFOEMwXDXT6RoazAujoYATE0NxDYTLO/m964pf+d1LTdEwWkNzhgqFdEXgWGpUEs4YIy3745My070For1P/+uQoibwyp5mb4a5j2rcTSB6AVcHRrmmPQshrtjqo9HnY0xxcr+ffgpc+WaFFmjOQk033Mjcs+tJxSe1bzAZLfHdRc3F9r/aIDCS5PFF113dMgKuodLmKYZfhyAxGWOZIdYSktCDO+Rfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOuRXqsI1iDGiV2hjUaNQPuq+4Li4dbFOXqz263hthI=;
 b=UqwoLI2aTszhbZ/NmLj9U/KeiEOuT6aTDGN840f3qQFv5vs70nDX9MaHii+vG1d1uum/suIUH96AOxiAy794O8UdghyxhrLLplekgPXA8XzuVkeVcNvDW3gnR1KEaAY9ZZd0tThj5Lxojr+Rhz3mX4qlqKXRTjUFuR1wTb0RYB2deKQAUCIuVxSNAygD9FW0EBqow1GgA/V8HKwlqizDMSG0fkAPO7PLFs9R98CCnjsMm5yEuqBNPsh+nxjHIMQDiBOpkGEn9NmYcONngDu3tTSBJAJriFgVzCEkcPh/dijE/QVBUgMyf1Rsxps64lLZ0o34qdiPzoKRURZFKWJ2Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOuRXqsI1iDGiV2hjUaNQPuq+4Li4dbFOXqz263hthI=;
 b=uM+NlteTMAOCTJ3keMVson6VbME3PVx+4gYa1k0YzK/4ATLs4rgLJ3HH8TOBxW0wgYrv+0H6k7267jDG9wKKnnl7MUcEtZLDJplVmBsgptcohCLwL2sK3GZGTKa4CPZBnMVj620wBfpZVPAJnRxP6SDRd5Ssi+ZE2Y15SBVhqFVdDY8Eo7Y0NCNuzAb2aRpZL1JsXEYZGdICl95KN67vOqQ2YpR8jM/b5JvdkeuXvTlzrAY0e6Ahxq7u2irfmjSFv/ufjeZkCU+Ch92d1ofT4h/maEJtl62zVBL/Y5TtamZCocOL0b4pAZIvCzc/ra439/JVb9J8FoG1QX75tr+aJg==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:36:03 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:36:03 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 6/6] KVM: x86: add debugfs file for lazy tscdeadline per vcpu
Date:   Mon, 17 Jul 2023 10:35:23 +0800
Message-ID: <BYAPR03MB413368E52C37B516A08A2479CD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
References: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [bD4zOMta72sg8G5Ms06ok+SxGmpTzob0KxZogx58WZc=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-7-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d89242-00ce-4265-4088-08db866e90b7
X-MS-Exchange-SLBlob-MailProps: 9IecXKUgicBAsOHsxkVJ3Zy3WHwqGpfPaSq6aUB4zQsBAqo+OU+fP5odGy30A+nvJUOzyZ6Y3/x5Va+jsZztufnsUQ9inT8k/ULITYxFKsTSem6PCNHXcwi5/NUtMIVw1GmSl2VKUq+JWUIsbUmVo8/lLlkq8AePBzaVkZWq4bfO15ZlONZVPlwy1hBu6h7z+CW1YemE+VrvNYTvt8rZ36cqhYHyMzeblAGO8AOrAHhj8uf5/dZKp3f+Kh6F3TXf3cEnwmBug9ZsOo3DOfZtpMBl4DZAvDtEl0+CqfWh+mtE/JETqB/cBBS2jzr8i1EvU+oEK2Gs69o22wRldm1TkRhb+pfYfhywU3zxcquTAZ1Aj3ZF9ka4tB7Z1FQhuQ9P78eyc9bGW/6dEpVGnTcMkSIKQO+KhR+Ozq5UwKtaUg2bU/glvygHNLftpIOEFXUl7cHbez9G7C/JUgeQwX1siDxqlq0Nj8FLiUkf9VmFAPo+lGaV1vbNX22VC8pUMvmjYwI+ikgS5TUPqW0LcqqFD5haW5/qScbyfZjdl+Gqg/9jir1YHdUMagPn013NL0uG7lKAYJY6al+DOV31JtVUmRu0Xa7vDD51au24ydNf4oywc0GmHuTnjN53XyIpFPj0997Sz4M/bYfRG/8Hhtu7vk0cjZ0rMQKw1DDWWOcbpJhhyhuW6bYqHBsSuEvJAn77oxotXazQcTH036xw/0HqvseBmfhCMgX+uhnbWHmTIECIMham2srsrw==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxq+SoQFQuHEjk9quVnQaLZfMyDbEiz8vm3A+5G+THtlySn4YPcohXYd+1MO6DuQB2YjxSLNhFKfyXiZZFyceYZoi5RKc7uXgc61RvgCgOCSAKhz93xpa26DLkAZNt3kqx7aO4KV+l/NlKFfGxDtd6UyaUf4IAgGNGQ526IJWfWGMAYnAUQ3GUtI64gtlU4snHXeGg1QlUhIARiSi3z00F3oB3SwVxJQfTVAifnSA0z7vF8nlrZO8sgbmhoqvVSHZb/rLRbNRPcbX5LDXpNaX8rmJdiwBo7dblMNkeNAgfRaNtVOnoE4LdQoFyTih/2Sj+gn2DFPd5GDf8DSZhFocpQQsk+o0lU57JKOwTnapMbBz1P//Y+PXww6hBhWFgcs2U1ubgRskx7+Ooo99bdzDL6iLERlIGGpL4Gp3cTTGvRipL5y0yKazJGmRr61gDOmZRT2ioKTz4RkxV7slas+f9jnD+cWZOpDwV1WqSrqyZIi1ia4W0nAuwEEY3Qv/BxWN9TmKstlXWJRr+ZKDFcGKlA0LZ9ugVGYmub72VjvSm8XRFaQIuMpOiXoeVSNsCq+
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D/uybZgWfvXxi5qZOVdB7tVMycx0zVvcr3tZsy14ZqEQj0J4x+YnNjh57Bem?=
 =?us-ascii?Q?xJtzMdjVwfBnrX4L+QxU3cBUlCwdPu6q4PEJeksqx3T+G+e4PaFwh3fWnh6x?=
 =?us-ascii?Q?fo5OTsE+ZNiXUCJuvZoPa1LKMbA3EPxzzDKDU/ZMaBnRVrMFbQEVPlEf7axs?=
 =?us-ascii?Q?MezZPRWhY7zZy/Qiq19MuuMK1hR4stFLcl+5BFv3wo498jFE0yoAeayH3Zeh?=
 =?us-ascii?Q?IRUsucgTN1ZwuY5DV5qOXLJ8QmTfXiiq2WDDPQApOTKeBJxHSDeUu62XapEt?=
 =?us-ascii?Q?jFLBfVdHo9hr6Wm0/ijc0UFShZ6vmDacMl7ITp7z9pKPX4iO2HtbNsSWOcrr?=
 =?us-ascii?Q?Xm03yN2QZSYRCpq3dkaZN5rUSUpedTRHK0wYjG8Kz1GiUv2jk4BVC0X3AaHR?=
 =?us-ascii?Q?RtsqHu5/E8v/J/jboi8JyhxM4nOV98mmRxp6437mmqYlVdgAuAdhtmjvey3F?=
 =?us-ascii?Q?p+jJ/i3fiKold6+VXFlCxNiVs1UphBbxReSkxg6J+bL8Y2cw63cjqOnWt1MD?=
 =?us-ascii?Q?Zr8Drr+0qc8Wqnps8Du2oYxKXO/tpLH5bcdUWt1XbTNrQAEhiXDqT3qv+f5v?=
 =?us-ascii?Q?M5JDAI2n3R/cUpweEdatcqx3StCPT4zVuNRCSUZxOmSM5dEyrmmZ3hGcMb/s?=
 =?us-ascii?Q?h1+xSPO53dCtm5B6n8YBI94NoK8qLhuyHpTpxOn8W74ltNL16r1/Z1DZeI2O?=
 =?us-ascii?Q?qIaF10pVW7KOotk7ZYNecmKIB7R8EeuTh6XgpXv5D5q4UJ9+4U0nuXUKz873?=
 =?us-ascii?Q?n3moCPgLF9CItXr1kMmhzYK1sKkwcXH9hFj8PWYKjGXEN4HNVXtXdbtuUAt7?=
 =?us-ascii?Q?uCOXUWNopJ9k4c7oJw4sdxukZgFIiTZwkhAINBjARvpJLEdGOtgLkM8pJPQq?=
 =?us-ascii?Q?8+0EP+5H/PSEC6Rv7T3VDtl4ecgygFQgg+QQFicaF7FJd7ho0PNaluZ1bh+v?=
 =?us-ascii?Q?/mVggpxFAwaUnIZGlNVeNNCseXVpIICVrje8+qRJ8BOIY/1050/mKjXB9Tat?=
 =?us-ascii?Q?LDGHSENFh4d7jAjd779mpYuwc19ybEi8NPthukklUXOxqCJSHiKkf3NtF/eX?=
 =?us-ascii?Q?j8aIDVMimRaBplEyNDMmFDEiUMOhHHA0t4GKB6LKh5kKKJ97DSg6WCjl1e2c?=
 =?us-ascii?Q?PrSjnSRzwwC/n/uOXOkgx4m7gJO6Rgt1OrfqUVB1kEn4b+drOjUO+03a0bpi?=
 =?us-ascii?Q?2zR59qdnJGUIUOWJKVZPTOK1o/+3cI5kfDxbaBdgTyBtLxWdiY9B46lvQNM?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d89242-00ce-4265-4088-08db866e90b7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:36:03.8790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a file named lazy_tscdeadline, in kvm debugfs vcpu
directory to get the state. And also, if you write to it, it will
trigger a lazy_tscdeadline kick forcily which can rescue the guest
if the feature fall into bug.

Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/kvm/debugfs.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index ee8c4c3..fbd6552 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -56,6 +56,79 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
+static int vcpu_lazy_tscddl_show(struct seq_file *m, void *v)
+{
+	struct kvm_vcpu *vcpu = m->private;
+
+	if (vcpu->arch.pv_cpuid.features & (1UL << KVM_FEATURE_LAZY_TSCDEADLINE)) {
+		struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+		if (!(hlt->msr_val & KVM_MSR_ENABLED) ||
+		    !hlt->guest)
+			seq_printf(m, "not open in guest\n");
+		else
+			seq_printf(m, "pending %llu armed %llu\n",
+					hlt->guest->pending, hlt->guest->armed);
+	} else {
+		seq_printf(m, "not enable in cpuid\n");
+	}
+
+	return 0;
+}
+
+static int vcpu_lazy_tscdeadline_open(struct inode *inode, struct file *file)
+{
+	struct kvm_vcpu *vcpu = inode->i_private;
+	struct kvm *kvm = vcpu->kvm;
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	ret = single_open(file, vcpu_lazy_tscddl_show, vcpu);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+
+	return 0;
+}
+
+static ssize_t vcpu_lazy_tscdeadline_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct seq_file *m = file->private_data;
+	struct kvm_vcpu *vcpu = m->private;
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+
+	if (!(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+		goto out;
+
+	/*
+	 * Force to kick the tscdeadline timer to rescue the vcpu
+	 */
+	kvm_make_request(KVM_REQ_LAZY_TSCDEADLINE, vcpu);
+	kvm_vcpu_kick(vcpu);
+out:
+	return count;
+}
+
+static int vcpu_lazy_tscdeadline_release(struct inode *inode, struct file *file)
+{
+	struct kvm_vcpu *vcpu = inode->i_private;
+	struct kvm *kvm = vcpu->kvm;
+
+	kvm_put_kvm(kvm);
+
+	return 0;
+}
+
+static const struct file_operations vcpu_lazy_tscdeadline_fops = {
+	.open		= vcpu_lazy_tscdeadline_open,
+	.read		= seq_read,
+	.write		= vcpu_lazy_tscdeadline_write,
+	.llseek		= seq_lseek,
+	.release	= vcpu_lazy_tscdeadline_release,
+};
+
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
 	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
@@ -63,11 +136,16 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
 			    &vcpu_tsc_offset_fops);
 
-	if (lapic_in_kernel(vcpu))
+	if (lapic_in_kernel(vcpu)) {
 		debugfs_create_file("lapic_timer_advance_ns", 0444,
 				    debugfs_dentry, vcpu,
 				    &vcpu_timer_advance_ns_fops);
 
+		debugfs_create_file("lazy_tscdeadline", 0644,
+				    debugfs_dentry, vcpu,
+				    &vcpu_lazy_tscdeadline_fops);
+	}
+
 	if (kvm_caps.has_tsc_control) {
 		debugfs_create_file("tsc-scaling-ratio", 0444,
 				    debugfs_dentry, vcpu,
-- 
2.7.4

