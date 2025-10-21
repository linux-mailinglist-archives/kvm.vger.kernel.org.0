Return-Path: <kvm+bounces-60779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 289AABF9631
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 28E45505099
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7313019B8;
	Tue, 21 Oct 2025 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBqioFts"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB5F2F39C5
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090446; cv=none; b=fUetzLwk8Gs+VgBuYJnpxOahOvqwRneUFr4RLl+Ar7E77OpGI9d8U067wvHPydJyO4fF9TGIo3ATKuCgYKPeC4btVeXPzlGYuQ4tQcsYaXb966pirNKE6IDy+St++ncqhYejPZGAna2Mz+XOesaE2QxUNxU3xqOtkjRYQNuJd50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090446; c=relaxed/simple;
	bh=5WTKWKiUk8Dj2RvkxdNnCT58i8QpYZiL92GnKNlZW6Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SXRgONyr0gWLUWOSEvfmM0NxP+Wzm/qlTb7QHBWRexf2RL5sN1uF2SO3DToCP12H1fgmv2L2oY0TP62dGhmSVLjfy1C7APq4aOpmXCvUAY76JG2XzgeA0+XusO6LyUzpnPwUtPF8RPquiehYVMPOJZK/h74kSyrDHgHHZxGSMSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBqioFts; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b679450ecb6so4605413a12.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090440; x=1761695240; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TV8626iy6qZJteqWMHB3Fb4Ctz0bR6NM9tHbIBJXOjs=;
        b=OBqioFtsCFj4zYM7FWkkTYwuPC1RqG8UQ1/NTlDPRV9FY3WVb7xphwfFlH1BdR+AnV
         GeqoMirbsYDWTmFdtKOXW2nH/pELsHLmD06vKQDdBvvCt/ShuGKcg5IECGJtKQleOv33
         UTRYGFt9iiDQXdazj17uuEN239KbjKe2iyWXOcruZuANVD/p6t8w1wdQimCUuSRv6yUx
         U59AtdQMEyTsb2XxFD8EuNL9oopimrrgmB3wHUi0mZrgZAOF1rjsm6Ojd12tsCH+Tpqh
         QlyWWpNO2ZK6vhA1/mOGO+GxpRLSycvl0Th0Pq3nXUYG9psmpkrLi3VfhU3jbFVJSMyd
         1qWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090440; x=1761695240;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TV8626iy6qZJteqWMHB3Fb4Ctz0bR6NM9tHbIBJXOjs=;
        b=InKzb4pvTQVtg9uACNDJk51hedPewVqTef56Z1UvewJTZqw/L9jBSbReIplkuwZj/p
         b9Kp+L31FTpDDUo7hsR9PFTfRdz9JUrssoGC1bCJ1SPHVV0v4LpCnc4lzQ3y+7YcK80W
         NbT0lQHTEGh4qpHHPB+3Rac8GzuKEdq/ZdPcqG8US7ml95Bo969lAvs7+TKOeQFei6/N
         +8DAM0ZeKZkoincg9XKZsHKX4akCMv3UFLQiQzsTVFlHNDb8zf/A6+N4b2vlXpxN0i1K
         0pHdwgtWLIJQXqF67xq1Wqw7wPENj+y6+diroq8wlho+V2M1cuX4HBy9sZajlGg7q6Tb
         4DHg==
X-Forwarded-Encrypted: i=1; AJvYcCXlW4xcOUJ8oba8dDs7agXuJJ0bpxZtYp+5B8be7SeJ5bZ45SAlJfWCu6Cmbb1WKNg4bXI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+y1QGWYYodkDGbX2IxR4BuNPpQorDkebFYl2z30oC3kxp5HIQ
	6CozgDCrDSc4e/UUpeJ+VoR9V/Xlv/mOmU/vJC5s/C+JtjuvyLWAoO0C
X-Gm-Gg: ASbGncsiEUboZddWOVol+8wn6Ee1ZbkOe0z2406ewChOM3VAXFE0FWk9onRWrAVUqV2
	3VWmAacpZC82yp3UKlvuS1wGOgg4Sg2Jm1Vv1H7oo+dSNOrzrsInR+HYvI/fFcSzZhhljsHqJmr
	fTRajk5rDpy3QAQX79zMlyLedBzxJSdtMFg9MH4WvaKs7VdPkyzHYUXyuuRCe47g2ejN4C9ktMe
	8eqBmTG4Mb/iz2GLClgiVhTaaVnNCXDFrDYTiPma/1vfWRc6ySQFH1x8OEyya08X9rNzKu+75fs
	JpM4Q2UQQEUVrdOVE6TmvBGOVcblSxv89GYmGOMSgqmihqq08YDPr+iaR/1YlN5VpPMzGYP0dEk
	+faj0XQMNP6ddF0wa0br5E7A5ems6bzjUxclqJCgpY2gXqxsH9CNIIy5nvKW6ZvmAh/ZpcMJc6R
	9Y5xqp
X-Google-Smtp-Source: AGHT+IF3YtiPWvZebVNqksLPddW34hdGMs6SWVpzynIffF/Cg3VXxCHnVj5pafWbxKnLw/A6JvakJA==
X-Received: by 2002:a17:903:11cd:b0:290:9a31:26d6 with SMTP id d9443c01a7336-290cba4ec04mr234640025ad.57.1761090439594;
        Tue, 21 Oct 2025 16:47:19 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29247223a3csm120532795ad.112.2025.10.21.16.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:19 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:47:05 -0700
Subject: [PATCH net-next v7 22/26] selftests/vsock: add namespace tests for
 CID collisions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-22-0661b7b6f081@meta.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
In-Reply-To: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add new namespace tests that validate the CID collision namespace rules.
There are tests to ensure that global namespaces collide on the same
CID, while local+local and local+global namespace combinations do not
collide.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 74 +++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 4defadad5701..69ec6ec82b0c 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -44,6 +44,10 @@ readonly TEST_NAMES=(
 	vm_loopback
 	ns_host_vsock_ns_mode_ok
 	ns_host_vsock_ns_mode_write_once_ok
+	ns_global_same_cid_fails
+	ns_local_same_cid_ok
+	ns_global_local_same_cid_ok
+	ns_local_global_same_cid_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -60,6 +64,18 @@ readonly TEST_DESCS=(
 
 	# ns_host_vsock_ns_mode_write_once_ok
 	"Check /proc/sys/net/vsock/ns_mode is write-once on the host."
+
+	# ns_global_same_cid_fails
+	"Check QEMU fails to start two VMs with same CID in two different global namespaces."
+
+	# ns_local_same_cid_ok
+	"Check QEMU successfully starts two VMs with same CID in two different local namespaces."
+
+	# ns_global_local_same_cid_ok
+	"Check QEMU successfully starts one VM in a global ns and then another VM in a local ns with the same CID."
+
+	# ns_local_global_same_cid_ok
+	"Check QEMU successfully starts one VM in a local ns and then another VM in a global ns with the same CID."
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
@@ -546,6 +562,64 @@ test_ns_host_vsock_ns_mode_ok() {
 	return "${KSFT_PASS}"
 }
 
+namespaces_can_boot_same_cid() {
+	local ns0=$1
+	local ns1=$2
+	local pidfile1 pidfile2
+	local rc
+
+	pidfile1=$(mktemp $PIDFILE_TEMPLATE)
+	vm_start "${pidfile1}" "${ns0}"
+
+	pidfile2=$(mktemp $PIDFILE_TEMPLATE)
+	vm_start "${pidfile2}" "${ns1}"
+
+	rc=$?
+	terminate_pidfiles "${pidfile1}" "${pidfile2}"
+
+	return $rc
+}
+
+test_ns_global_same_cid_fails() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "global0" "global1"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_local_global_same_cid_ok() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "local0" "global0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_global_local_same_cid_ok() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "global0" "local0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_local_same_cid_ok() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "local0" "local0"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
 test_ns_host_vsock_ns_mode_write_once_ok() {
 	add_namespaces
 

-- 
2.47.3


