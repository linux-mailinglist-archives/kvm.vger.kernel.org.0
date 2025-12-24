Return-Path: <kvm+bounces-66654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 399DDCDAFF1
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34E653094489
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C18D2874F6;
	Wed, 24 Dec 2025 00:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kp8rGzQl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA2A280A51
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766536153; cv=none; b=icbhU2GQNQvQ9Kza0BrgVSw+uZ4bOmh8Sc6fGPbGRzTZsOCIBt488HPD6Wie7bbN41Zb23ONiKnZd1SjW3swM4nLq8QEzRAnwUZaT+IFVHUv+rYJij2gTjbppshmcqz2yRjB0CgkLr1dzv1iME42S40PiYt0umld/60N8xNc7WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766536153; c=relaxed/simple;
	bh=43YZlXDQmW65hszyjr5m3UtpfpB8+72+oSXEtxR8B+c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pk9G0SLnm387n+SwiCNC1NUIqK1SlV2FND2cOXsOpNOBsUqK/aN8GsDvFR6zn5tRmB628ye6CGy2uAzwtVZuJExs4HgPqVU6nwkHvVYTKxYjgrDFBR8iBVg8y4M6UVr3QzyeYOxRjKrLqcFqSvM78GmaaJEgNM3p9PSG7YQlKGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kp8rGzQl; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c565c3673so2952714a91.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766536148; x=1767140948; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3I8QcIsIeOrh9cIrz38ZjjL+G5z3ujRC9KA0ugGud8=;
        b=kp8rGzQlkjDApcPc6eOyl2nEfXxTUFL781v8rvWP6BiV76Le4Ma81Fl2gr5mdw5Yh7
         p4f3JtAAlgF7W+5xFRVwmoT+/vYLJda8mk3A5Z2pFZdsW4ZOh00R7KPRkVrMVHo6Ofh9
         aaAjFGj5PltU6um+2jSvL9VkVPO7RBrA1NSfD2HmLjT8qbVzO5OUdov3CHmASEosifMK
         WtwxbuX4UYi1axMLhKTOI+2zHdTT9POLsBHMpsT7gevF7Iq69/yz6Ko62vV9HvGQ7fx9
         fFaP5XYROhhOnceYDTkq7J1p1iYGyVHow8N+YR14D9w9kRfxiwwG2tn8KXhXfac0u0RO
         p/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766536148; x=1767140948;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y3I8QcIsIeOrh9cIrz38ZjjL+G5z3ujRC9KA0ugGud8=;
        b=wgw89q2KtVuxxgkI1Iran57el5tQuevi1al2PmYANOMBalv2Sc1N9v75qs4aIBrJGk
         TM2AiyZqXW5v14YGk5enY9L2TYyvI7DjZXIua7CZkq7oAnmv7kFEKEhj/rz99qqQ9PZx
         TMnYKDMLee2MJ0i6b4YGreipmNQSatL7R8WVCgNXZW7iFjS/A2Qmq4LrPUAjNA4vYR4y
         +PV0VVj1KWmTtPJjLoePNbpU2gc1zkyCclyHoxMGdVGzXJjmqXorfr2pxEjO5zipN0i7
         EqghfcI1ViAeJQXEqyC64fncGOIurnHeQhSN3IfeXbLY8pNp7QwGCeW3vC1jBesF1m+c
         7nhA==
X-Forwarded-Encrypted: i=1; AJvYcCVgzATQGuUXBbLRKCevty88d31lusVDLbIV/MXGYhTu4xaMxKXAUyTSox/o3qqO+r4CTwM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOAlQePoVnPknpdTclcC3ZmLRh223WJ8l1KDPeEat3bno6Z9xI
	XLPfrLvy4hE0uUA9FhfURNLEO3KfpV/MLrIajjOQHDZjtGzGSCy5d4d6
X-Gm-Gg: AY/fxX4VzN/wed2ehPlFx4YE8sBXVYDMpmETm4w5hCWamQcsrEZBMyMjgyQdYRSR0Mn
	pJanInnUHnGini/JQcjd1Hl3kuoCtZpP9GvBKKM6RWPD0/y0354Ceqthy/+y/QUy3vMb4/hOGPm
	sMjchSMRCgSd5RBS5JUFstdfkrb7OuxBbbRXmvq2GxGaxBkPNkfhzpm5L7fAgVdTPsdWA71nAqj
	tiD1SKpIKKThLq7Xq5Ph5pJO4nwuieYWdIrTal4cNHGlpn8gZ42z8Rfa8AWJFuHUyeiNfb9ok6s
	UQ9N5mobFUTduVZjj7QmoUwu82qD5ZNuu5qGxagbS4tz4j/Wt0U1rwmEq3WFJkETGfRfBY3eGeZ
	BVDNy1nA2VWwMv1bR5tIiI+mvTahdL9IgSfUCNGnMEMugvZvevMSMijrYlVyz8eaLBLwJ5U0CCA
	L89C0hczanfGpSrCjg
X-Google-Smtp-Source: AGHT+IEnt5MFD2z92xcaaC0B2FD3jHvTV/CdQSmrEfTkHhvBEkCeNRbln24shg4R5xbEeUrAsqetcw==
X-Received: by 2002:a17:90b:1d0d:b0:32e:23c9:6f41 with SMTP id 98e67ed59e1d1-34e90d6980bmr13148402a91.5.1766536147584;
        Tue, 23 Dec 2025 16:29:07 -0800 (PST)
Received: from localhost ([2a03:2880:2ff::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7bc69728sm13429268a12.19.2025.12.23.16.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:29:07 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 23 Dec 2025 16:28:45 -0800
Subject: [PATCH RFC net-next v13 11/13] selftests/vsock: add namespace
 tests for CID collisions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-vsock-vmtest-v13-11-9d6db8e7c80b@meta.com>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
In-Reply-To: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add tests to verify CID collision rules across different vsock namespace
modes.

1. Two VMs with the same CID cannot start in different global namespaces
   (ns_global_same_cid_fails)
2. Two VMs with the same CID can start in different local namespaces
   (ns_local_same_cid_ok)
3. VMs with the same CID can coexist when one is in a global namespace
   and another is in a local namespace (ns_global_local_same_cid_ok and
   ns_local_global_same_cid_ok)

The tests ns_global_local_same_cid_ok and ns_local_global_same_cid_ok
make sure that ordering does not matter.

The tests use a shared helper function namespaces_can_boot_same_cid()
that attempts to start two VMs with identical CIDs in the specified
namespaces and verifies whether VM initialization failed or succeeded.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- check vm_start() rc in namespaces_can_boot_same_cid() (Stefano)
- fix ns_local_same_cid_ok() to use local0 and local1 instead of reusing
  local0 twice. This check should pass, ensuring local namespaces do not
  collide (Stefano)
---
 tools/testing/selftests/vsock/vmtest.sh | 78 +++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 38785a102236..1bf537410ea6 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -50,6 +50,10 @@ readonly TEST_NAMES=(
 	vm_loopback
 	ns_host_vsock_ns_mode_ok
 	ns_host_vsock_child_ns_mode_ok
+	ns_global_same_cid_fails
+	ns_local_same_cid_ok
+	ns_global_local_same_cid_ok
+	ns_local_global_same_cid_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -66,6 +70,18 @@ readonly TEST_DESCS=(
 
 	# ns_host_vsock_child_ns_mode_ok
 	"Check /proc/sys/net/vsock/ns_mode is read-only and child_ns_mode is writable."
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
 
 readonly USE_SHARED_VM=(
@@ -577,6 +593,68 @@ test_ns_host_vsock_ns_mode_ok() {
 	return "${KSFT_PASS}"
 }
 
+namespaces_can_boot_same_cid() {
+	local ns0=$1
+	local ns1=$2
+	local pidfile1 pidfile2
+	local rc
+
+	pidfile1="$(create_pidfile)"
+
+	# The first VM should be able to start. If it can't then we have
+	# problems and need to return non-zero.
+	if ! vm_start "${pidfile1}" "${ns0}"; then
+		return 1
+	fi
+
+	pidfile2="$(create_pidfile)"
+	vm_start "${pidfile2}" "${ns1}"
+	rc=$?
+	terminate_pidfiles "${pidfile1}" "${pidfile2}"
+
+	return "${rc}"
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
+	if namespaces_can_boot_same_cid "local0" "local1"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
 test_ns_host_vsock_child_ns_mode_ok() {
 	local orig_mode
 	local rc

-- 
2.47.3


