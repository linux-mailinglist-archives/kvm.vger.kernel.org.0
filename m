Return-Path: <kvm+bounces-56439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74514B3E3E2
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B86E480B30
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D3E1A3164;
	Mon,  1 Sep 2025 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JNwjgFQa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3D3188A0C
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756731846; cv=none; b=HQjt6hx1oO5XJIVLggUU3/VI5e9QuerrsN2ipzR7e+6pgyns7ztDQJWwRXPBeKKXK3AFlXm+hMfa3Zvhgz3VwLsz1EYmwvYVxUobi4mDmommYWfp5HKEs0sEBOBycvMOZHrLAoNbpMbwPf7+3D+QzZWLSB8PzCfxU1zx0mBmdys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756731846; c=relaxed/simple;
	bh=3LfG+bJnoK9YUuQcs2syOT3GdEEFMruecSyB7MibbRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=njsauThAuV2yp31yUHyK374POfnAMLgR6P9vibjChQ7nKK/741CgSoK14IIDxJm0tGpXGWw3M9yeeYrdpVaKL6yMbBwiMRAMx2WifiVw5Wk32lRRVySIz++S9wUkWJSG9s/FAhoW7C2ub+bu1C4MVs0r0yIgrBKw0xPLeP9Wvp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JNwjgFQa; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b320c1353dso23775541cf.1
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 06:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756731844; x=1757336644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PL0UKelHCsnsMJ251SfSkVQtRwJSHTcum5pAdzER9Mw=;
        b=JNwjgFQaE4P0bAyirbXHIBWpQ2SAMtmm0wTLe+yCpO/OtKZxM+JwqPvNMHhFlzDu06
         j7a8PMnchIpbFTftW0QXr2nPJR64MjjwYKdK3JIlat88jdUDKwdc+2zrlTas4oj6lAvP
         q45SRNX2+FAN7xgUlHjEI6v983aha3gSM0H6xzoxsguqnE/KXnHiMyJujawL/H4PCs/9
         UeizSmviGC9BDEGdd462Cqt9x79I7qocBmIwXxNzAfj5HvN3O6LP5nZIS6blI5fhHWJC
         HHNLosKeuEVgWmSFwmoDVMEu8Tz7Z37Sg7fM05lzXt9nUw4hBV9wa8lW07/3CbCEfhjc
         585A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756731844; x=1757336644;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PL0UKelHCsnsMJ251SfSkVQtRwJSHTcum5pAdzER9Mw=;
        b=N+AGr2T/65LgeERdIzTNrlF+8A5a5VtQmAVOu17CpMBV8TNxsvcxFlblW4XYScNY79
         ix8vOkPVCjHW0bgBV1V13txnpkrC28N+NRbEVaGUQhqXAJ4xZyOz1l4nKAgBxJZLsltX
         qGx4iVjEfc9ckOlitjXtvQqZe9jm7C6jPyNb8+7xkNBY07vTMskEoGlgGtBHTnEhy2p8
         2bUyYXLl0XaH+pFBxvICqQbc7jTr3YR9kHITCqPUjtoSotSLNspZGaeu86TP2Ls0Wdhg
         CwaBEchZ4AkB2oMtxyGQKe/LS3QsuIcirPx0uRYD2ar9tctr0oYQDbwpNMzZ6BccfShO
         WPTw==
X-Gm-Message-State: AOJu0YyDd0tv5Wsm0sJJGG+swSS+96uFvUXTUXnX4IFxs2Os/dahvV3V
	LNC6SFXNfsDRg+MYZc4JL74B3EGv8XFB5EO1ew9Xn0Unr6QwtZyhHT4=
X-Gm-Gg: ASbGnctthXzGF/AtZib/79SkO88xqfN9U2xaDTYL8Ic9v4kXRHKnyaJQuuWr9HpZvKE
	9yAjx2cxb22YCAIT1GYV0wC6h273EmPk/3xRBkvMczV0o9uQDmhqAkYKzF4ymWCF1OMrTxZI7B8
	BDVt5jWWzs6HFyp6r5hHawuPckRcSD0SiG+k3THrvG3wj2a8B1ZRhvPFL3vCuwXq6pTOoA39ZHJ
	boocuqZhPWkVCg69YAS1PWq4oxUhd+eFp2RmnXSFkeVCI3U95FX7e1Y7xeuhCaF3L1Rd0htBsyX
	IaqEABuDgvNF/4QZ3sMPfKuX07tIN+Ay4+FRC003BO6SQB8tDMH/JLf4nPnGHtR0HimzIDNk0RI
	igtumJ4nvsEdlDcASWAdrQ2Pjt4kyFiEN+jpY41tR6vUi
X-Google-Smtp-Source: AGHT+IHZYDZoprya8W/IoQKk3VFlrkOL5peotAeILFD0w6Bm3/UXob4Y8lEJYahS80iaW5fF7bnrPg==
X-Received: by 2002:a05:622a:99a:b0:4b2:9620:33b3 with SMTP id d75a77b69052e-4b31da1d546mr101750441cf.34.1756731843388;
        Mon, 01 Sep 2025 06:04:03 -0700 (PDT)
Received: from t-chicago-u-2404.. ([2001:19f0:5c00:2be4:5400:5ff:fe7e:238d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b30b6c0112sm61663241cf.40.2025.09.01.06.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 06:04:00 -0700 (PDT)
From: Ted Chen <znscnchen@gmail.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Ted Chen <znscnchen@gmail.com>
Subject: [PATCH] KVM: Avoid debugfs warning caused by repeated vm fd number
Date: Mon,  1 Sep 2025 21:03:36 +0800
Message-ID: <20250901130336.112842-1-znscnchen@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid debugfs warning like "KVM: debugfs: duplicate directory 59904-4"
caused by creating VMs with the same vm fd number in a single process.

As shown in the below test case, two test() are executed sequentially in a
single process, each creating a new VM.

Though the 2nd test() creates a new VM after the 1st test() closes the
vm_fd, KVM prints warnings like "KVM: debugfs: duplicate directory 59904-4"
on creating the 2nd VM.

This is due to the dup() of the vcpu_fd in test(). So, after closing the
1st vm_fd, kvm->users_count of the 1st VM is still > 0 when creating the
2nd VM. So, KVM has not yet invoked kvm_destroy_vm() and
kvm_destroy_vm_debugfs() for the 1st VM after closing the 1st vm_fd. The
2nd test() thus will be able to create a different VM with the same vm fd
number as the 1st VM.

Therefore, besides having "pid" and "fdname" in the dir_name of the
debugfs, add a random number to differentiate different VMs to avoid
printing warning, also allowing the 2nd VM to have a functional debugfs.

Use get_random_u32() to avoid dir_name() taking up too much memory while
greatly reducing the chance of printing warning.

void test(void)
{
        int kvm_fd, vm_fd, vcpu_fd;

        kvm_fd = open("/dev/kvm", O_RDWR);
        if (kvm_fd == -1)
                return;

        vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
        if (vm_fd == -1)
                return;
        vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
        if (vcpu_fd == -1)
                return;

        dup(vcpu_fd);
        close(vcpu_fd);
        close(vm_fd);
        close(kvm_fd);
}

int main()
{
        test();
        test();

        return 0;
}

Signed-off-by: Ted Chen <znscnchen@gmail.com>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..f92a60ed5de8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 {
 	static DEFINE_MUTEX(kvm_debugfs_lock);
 	struct dentry *dent;
-	char dir_name[ITOA_MAX_LEN * 2];
+	char dir_name[ITOA_MAX_LEN * 3];
 	struct kvm_stat_data *stat_data;
 	const struct _kvm_stats_desc *pdesc;
 	int i, ret = -ENOMEM;
@@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	if (!debugfs_initialized())
 		return 0;
 
-	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
+	snprintf(dir_name, sizeof(dir_name), "%d-%s-%u", task_pid_nr(current),
+		 fdname, get_random_u32());
 	mutex_lock(&kvm_debugfs_lock);
 	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
 	if (dent) {
-- 
2.39.2


