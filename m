Return-Path: <kvm+bounces-9605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38081862BC8
	for <lists+kvm@lfdr.de>; Sun, 25 Feb 2024 17:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6AFE1F21115
	for <lists+kvm@lfdr.de>; Sun, 25 Feb 2024 16:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A3317BB3;
	Sun, 25 Feb 2024 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="i7u0GFCT"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-251-72.mail.qq.com (out203-205-251-72.mail.qq.com [203.205.251.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58392175A6
	for <kvm@vger.kernel.org>; Sun, 25 Feb 2024 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.251.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708878798; cv=none; b=uiPJ6S0Uf3mw0weS7Xcp8xdGNX+S/ZHX4aviLbRyHzWzxW45/KFOo9V3lt2Wq1fSO6yMXN4NcFV0dmORMT+t89OuBzbkUY1KINYVP5zquHPKHclJ5McyM5M+YVYxSavPRQkYv2EtyLp4RpoGSOou0losKVskGiM1aDIKB95J3dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708878798; c=relaxed/simple;
	bh=gJnt34/lXP8J/oeMdK2sYL9L6NDPBxObA4JQVUSIDds=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=TX6tYv6C8F8qZrG+7rpKJamnz5DvIk4xklhW/YF/lDx8lNYGqo8aijQ5QyvGB8rhCKeSkXqbjhgM5aEJbWqxfkl+5BVq0rhfIFnhJ1wY31LWBTwlRN+98AT1caeuMLPIbj2/zAyMW4UEVTshh4mGqDH0gpRjJ/PNi+ca9yzjtrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=i7u0GFCT; arc=none smtp.client-ip=203.205.251.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1708878786; bh=rh83XwhsXcuZNlMm+O4IbDpEurLHaWAV6Z0L8+N9SRs=;
	h=From:To:Cc:Subject:Date;
	b=i7u0GFCTnZ5FdTMdgTswuhmKrQEsxGuunHA0qmsdAQzsni+wbo9bn8CG03ZeVwlKt
	 NM5U612kH1vpegrDS8v684giU6hqNCa9wNFTJcqtLVdzviRbdiuCY82hDs7YSW3kOQ
	 sq7aOgyCRJtC8+cy52K2Ur/Oa/mtQxBBk/Ze5XJI=
Received: from localhost.localdomain ([123.139.251.251])
	by newxmesmtplogicsvrszc5-2.qq.com (NewEsmtp) with SMTP
	id 7F820E2B; Mon, 26 Feb 2024 00:31:56 +0800
X-QQ-mid: xmsmtpt1708878716tfw901i9k
Message-ID: <tencent_3FBF289C57BD1C8C31601110D5726C3E380A@qq.com>
X-QQ-XMAILINFO: MZChPk4K8ikNSJ18Q6WEHv3ZGFVC3d57rD6bXpCH2Apd+k1WAWZACE2ypUo4Je
	 1pgOhr5SdEcTn1L0Im/eQOrTSR4Dwb/3mNYwWktdzsYvdslAPzMcjPaFQfY2caTyyjY+fgiZOshP
	 hR8OVY8+ckG4D5ULRt5A8ZPClAFbZOfB98kQ3CebojoXvhMYM2l1gKlC6gX9WirFDAL+O227hvaU
	 ebMstLVgmqwFzqZJVfft9YQL67NdEpyBvGw8Nr6YCjs5YpAnnfObpRdPab0nVhAnhW9SJL6V1qLX
	 F2bWTrPTVdlAGja7+ePUklYb3jaUOJS5m31g+GQvlZuFPKqRPhKwAkbN40KGhkrWH7Y2uz64pWN5
	 XOLPR6URtlUbbJDnJ+JTCG/24OF+wrydWnHtDOki8uXa1uAJkATFgGO9jAvHxexvASj+IuxmQY3A
	 8DpA62miui2w9JO654gFeFuzlBmIgkK6V37x54uaHThZD/bNzE0EmeNsl6Mxvn4f/s+6u6nv73EF
	 lCZ4AOwJS6/rJEH3IZ/OkUQj34dZS5UXzdTb+J7mV8zF1OZUYKPW8MqNQmGKVuxmcqxrKoQPH+M3
	 MRysNWJFO9XN2l140/ELthLiPnf0getbrnyp/5YcTxBXGXP3jpO6TmYxIz4bF/JOBZ0jFKAzkqUv
	 jh5O+DVhrKIJzkESQKkT3eZfzKcWjoZ5lYeW6VQmiXSMy6RYYN2M7Gf5CJRl4wvvRZAEtZfnEooh
	 2TPLmLGATeOE4CBVe45KhU5B4qOypw8gM+vQI4u8YPyO8AhDon+F3bvoNfZPb3kPsNI626Q2An6p
	 uFrtRmLMJMiJDxRK5yaA7t8eCL4c1FY+/AXBiap0z1LBgKWmRQzAa2LVzMVPrE6SXRl/kBtCRWf+
	 qUjo23MeXi3xGg/9wHhrMJon6KniT7s0+hC1MNFhJ0c2VIZZ2+W0JUOKlBkYRCCrAaOla0XJdVLy
	 h7074VwN6MjaM+A/98XHcDHEspdB5gWMOcbGKa3IDeLR6ggtDRP64c9pWMU6ZZRF2it2+RJG/CxY
	 dRhxeLeNUOenLE8wZN
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Mr-Mr-key <2087905531@qq.com>
To: kvm@vger.kernel.org
Cc: Mr-Mr-key <2087905531@qq.com>
Subject: [PATCH kvmtool] Fix 9pfs open device file security flaw
Date: Mon, 26 Feb 2024 00:31:55 +0800
X-OQ-MSGID: <20240225163155.43380-1-2087905531@qq.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

---
Hi,

Our team found that a public QEMU's 9pfs security issue[1] also exists in upstream kvmtool's 9pfs device. A privileged guest user can create and access the special device file(e.g., block files) in the shared folder, allowing the malicious user to access the host device and acheive privileged escalation. And I have sent the reproduction steps to Will.
[1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-2861

Root cause && fix suggestions：
The virtio_p9_open function code on the 9p.c only checks file directory attributes, but does not check special files.
Special device files can be filtered on the device through the S_IFREG and S_IFDIR flag bits. A possible patch is as follows, and I have verified that it does make a difference.

 ...n-kernel-irqchip-before-creating-PIT.patch | 45 +++++++++++++++++++
 virtio/9p.c                                   | 15 ++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 0001-x86-Enable-in-kernel-irqchip-before-creating-PIT.patch

diff --git a/0001-x86-Enable-in-kernel-irqchip-before-creating-PIT.patch b/0001-x86-Enable-in-kernel-irqchip-before-creating-PIT.patch
new file mode 100644
index 0000000..54005b4
--- /dev/null
+++ b/0001-x86-Enable-in-kernel-irqchip-before-creating-PIT.patch
@@ -0,0 +1,45 @@
+From e73a6b29f1ebf30c44f59a0a228ebed70aa76586 Mon Sep 17 00:00:00 2001
+From: Tengfei Yu <moehanabichan@gmail.com>
+Date: Mon, 29 Jan 2024 20:33:10 +0800
+Subject: [PATCH] x86: Enable in-kernel irqchip before creating PIT
+
+As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
+KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
+support via KVM_CREATE_IRQCHIP.
+
+Signed-off-by: Tengfei Yu <moehanabichan@gmail.com>
+Link: https://lore.kernel.org/r/20240129123310.28118-1-moehanabichan@gmail.com
+Signed-off-by: Will Deacon <will@kernel.org>
+---
+ x86/kvm.c | 8 ++++----
+ 1 file changed, 4 insertions(+), 4 deletions(-)
+
+diff --git a/x86/kvm.c b/x86/kvm.c
+index 328fa75..71ebb1e 100644
+--- a/x86/kvm.c
++++ b/x86/kvm.c
+@@ -150,10 +150,6 @@ void kvm__arch_init(struct kvm *kvm)
+ 	if (ret < 0)
+ 		die_perror("KVM_SET_TSS_ADDR ioctl");
+ 
+-	ret = ioctl(kvm->vm_fd, KVM_CREATE_PIT2, &pit_config);
+-	if (ret < 0)
+-		die_perror("KVM_CREATE_PIT2 ioctl");
+-
+ 	if (ram_size < KVM_32BIT_GAP_START) {
+ 		kvm->ram_size = ram_size;
+ 		kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, ram_size);
+@@ -175,6 +171,10 @@ void kvm__arch_init(struct kvm *kvm)
+ 	ret = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
+ 	if (ret < 0)
+ 		die_perror("KVM_CREATE_IRQCHIP ioctl");
++
++	ret = ioctl(kvm->vm_fd, KVM_CREATE_PIT2, &pit_config);
++	if (ret < 0)
++		die_perror("KVM_CREATE_PIT2 ioctl");
+ }
+ 
+ void kvm__arch_delete_ram(struct kvm *kvm)
+-- 
+2.25.1
+
diff --git a/virtio/9p.c b/virtio/9p.c
index 2fa6f28..902da90 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -221,6 +221,15 @@ static bool is_dir(struct p9_fid *fid)
 	return S_ISDIR(st.st_mode);
 }
 
+static bool is_reg(struct p9_fid *fid)
+{
+	struct stat st;
+
+	stat(fid->abs_path, &st);
+
+	return S_ISREG(st.st_mode);
+}
+
 /* path is always absolute */
 static bool path_is_illegal(const char *path)
 {
@@ -290,7 +299,11 @@ static void virtio_p9_open(struct p9_dev *p9dev,
 		goto err_out;
 
 	stat2qid(&st, &qid);
-
+	
+	if (!is_dir(new_fid) && !is_reg(new_fid)){
+		goto err_out;
+	}
+	
 	if (is_dir(new_fid)) {
 		new_fid->dir = opendir(new_fid->abs_path);
 		if (!new_fid->dir)
-- 
2.25.1


