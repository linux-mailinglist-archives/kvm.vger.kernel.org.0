Return-Path: <kvm+bounces-62858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C408BC50D6C
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F7AB4EFCD6
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603772F531F;
	Wed, 12 Nov 2025 06:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDjdzEwQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5EB2F363F
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930555; cv=none; b=D7XgMdULOvDRz+zI99ezCUMz+lwlpP4v9P36MlmmCbc/y4fNs/ylSy2/B7m34RALdJ/qwsxV7mrtFahW4F07UPunBEGRtB0g41+9C45hC8p5C6lcwJmfw6pUn98UlJE/ZWjTrKoar6qy3k4R3EHBqmQkfaVqWCPhz8Z5nz922RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930555; c=relaxed/simple;
	bh=Ki9qlCREWAnMqPx9kyWqpx4FSgeaHQLAREjrbRcK7Gg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V/c3lbfhwKzVili/hqOOgpE2BH8d9frKXL2un1K4x8pvKQNyL7kdPbIo8uRGcGI0TH6C7RPTA6/0D5RHVw50cPaGK3TDsAKFA3WUTtJhWObEoKhyu/PHXunvNJzBObusZCR5PY32X4DYSQwcqB+ROkewptxLd2oXUfthHoFrfKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDjdzEwQ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-297dc3e299bso4671705ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762930545; x=1763535345; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZUjpYBbngVUPNF1FY5Eobr7zoaqTHRebHcmUg3ByBw=;
        b=bDjdzEwQu7zfol1Cmze04P6TPl6ABz1aTUw4PIrgoTtjKw1pcd2AGX1/PxCl2AYD/+
         p7PdJcdsQqZfw716PHN9fPwSnq/me7o/G6uhxjQWW1z3VdubwwtO/U7ldjbTWRW3ofJx
         uRqr7oONMHQInPkLmagiK/W3/mJE7SiQTKLEKTt+HiIzr6e6jBhenAs5PMQrCJI5J3l+
         0p6Ons5F19vVIiRHDpByti+b/fffnSacbPDZnPyFuCcZt7yNJlYaQUpofoMYTe4FMZbP
         nozZ7/naVM1srXGLKR7RwyrhVh4a8t9PB96FPM9tg3UUAVuez4Wpy07ba+dtziDbkaHQ
         hNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930545; x=1763535345;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HZUjpYBbngVUPNF1FY5Eobr7zoaqTHRebHcmUg3ByBw=;
        b=vYaIYEYS/3cirbhBYAfqaYutsNuG9HTcESR7XfluwEMPw9nEaGoqZu8ct2XomIWmkY
         wEX1Q07yRGVGMs3134F+zaGP+SkIP4/2zYo2gfqYNQByZjiSMs+NjxWT8sYE62yKU1q4
         UNf+mMyKijAEgdM2OpsLKKJqoAEbA43NgnrM+dnlhIx60wjtJ6o+xTO7J3nHbQFAQ9Hd
         HAx1DSWRMZhkzz5j2/mtRGtq6u5HwGZ9DRZsE6tigiLoGmxz+bvoanGaa4uSxh6nnBt9
         n89+ySv8qXD3FY0ht1Bskt/cBUtomznZOvk+L4/+4NjUPT2LXuGT6ToiagFe1kq///79
         xXSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiwwzn6SJk5CHizOikUICg4W2xULoFBkEiJLXuc6AnpprNhousvp6zcNW83IuWFoanHhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoOmx62nYG0uYPtN55XSukyhuELpzJ9e8dquHo/953S7Ae5uAO
	76iHyyDP3xnx8awKWbURTybL3I7jX1ZJjBoiTuSQ/KLu0acpUiNEPcEl
X-Gm-Gg: ASbGnct8VespdYEaqqd1F4Cwok0efx3wfPbFeNIxLCBQrP3lTCxDHu4cfV3iEvrnpwX
	hJUOss1Ka2gpeaN/2/z8L1AwL62aXPNH3MhX8KOheimrkrZkywYA80lnD5ct/YpajFYNN/CAbNp
	gMWvvgv+WHWZAIMup7BbqjuFG6Yr3LlKqWDrzedQO/fEHFYZzES538BjZqCyxT/AUstnJITMpzu
	uWq7X3JeFK1ypFl1pevgQUPC4SdQIG/xQSBySXVOMXbBOiDygn1BlWypAZc1A1AssUmsynK+QU4
	KXzi1baPWtWmIDojfVksbLEum3BBsAUCae0ScaCZ8lTxt4s/cuVsXvBtfWDTEwRkTy0K64EOTzA
	On+rEdRqZ1nETJPbiVoGWv0ukge1klRDsl4VPDeftoSHdVn/07yf4rnVBsMmNlzDpIVnjVp7SY7
	xGG5lNsYo=
X-Google-Smtp-Source: AGHT+IHe3qSWqSXR4PSHmvZir+y9btYTb4leWAYcTpRQBL7irTe9KF8Y4zGkNjHSZIlDXgrWiAuBTw==
X-Received: by 2002:a17:902:f683:b0:295:6a69:4ad5 with SMTP id d9443c01a7336-2984edec68bmr25849295ad.56.1762930545373;
        Tue, 11 Nov 2025 22:55:45 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:8::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bbf167e28basm1746696a12.24.2025.11.11.22.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:44 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 11 Nov 2025 22:54:53 -0800
Subject: [PATCH net-next v9 11/14] selftests/vsock: add tests for proc sys
 vsock ns_mode
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vsock-vmtest-v9-11-852787a37bed@meta.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
In-Reply-To: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
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
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add tests for the /proc/sys/net/vsock/ns_mode interface.  Namely,
that it accepts "global" and "local" strings and enforces a write-once
policy.

Start a convention of commenting the test name over the test
description. Add test name comments over test descriptions that existed
before this convention.

Add a check_netns() function that checks if the test requires namespaces
and if the current kernel supports namespaces. Skip tests that require
namespaces if the system does not have namespace support.

Add a test to verify that guest VMs with an active G2H transport
(virtio-vsock) cannot set namespace mode to 'local'. This validates
the mutual exclusion between G2H transports and LOCAL mode.

This patch is the first to add tests that do *not* re-use the same
shared VM. For that reason, it adds a run_tests() function to run these
tests and filter out the shared VM tests.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v9:
- add test ns_vm_local_mode_rejected to check that guests cannot use
  local mode
---
 tools/testing/selftests/vsock/vmtest.sh | 130 +++++++++++++++++++++++++++++++-
 1 file changed, 128 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 663be2da4e22..ef5f1d954f8b 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -41,14 +41,40 @@ readonly KERNEL_CMDLINE="\
 	virtme.ssh virtme_ssh_channel=tcp virtme_ssh_user=$USER \
 "
 readonly LOG=$(mktemp /tmp/vsock_vmtest_XXXX.log)
-readonly TEST_NAMES=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly TEST_NAMES=(
+	vm_server_host_client
+	vm_client_host_server
+	vm_loopback
+	ns_host_vsock_ns_mode_ok
+	ns_host_vsock_ns_mode_write_once_ok
+	ns_vm_local_mode_rejected
+)
 readonly TEST_DESCS=(
+	# vm_server_host_client
 	"Run vsock_test in server mode on the VM and in client mode on the host."
+
+	# vm_client_host_server
 	"Run vsock_test in client mode on the VM and in server mode on the host."
+
+	# vm_loopback
 	"Run vsock_test using the loopback transport in the VM."
+
+	# ns_host_vsock_ns_mode_ok
+	"Check /proc/sys/net/vsock/ns_mode strings on the host."
+
+	# ns_host_vsock_ns_mode_write_once_ok
+	"Check /proc/sys/net/vsock/ns_mode is write-once on the host."
+
+	# ns_vm_local_mode_rejected
+	"Test that guest VM with G2H transport cannot set namespace mode to 'local'"
 )
 
-readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly USE_SHARED_VM=(
+	vm_server_host_client
+	vm_client_host_server
+	vm_loopback
+	ns_vm_local_mode_rejected
+)
 readonly NS_MODES=("local" "global")
 
 VERBOSE=0
@@ -205,6 +231,20 @@ check_deps() {
 	fi
 }
 
+check_netns() {
+	local tname=$1
+
+	# If the test requires NS support, check if NS support exists
+	# using /proc/self/ns
+	if [[ "${tname}" =~ ^ns_ ]] &&
+	   [[ ! -e /proc/self/ns ]]; then
+		log_host "No NS support detected for test ${tname}"
+		return 1
+	fi
+
+	return 0
+}
+
 check_vng() {
 	local tested_versions
 	local version
@@ -503,6 +543,43 @@ log_guest() {
 	LOG_PREFIX=guest log "$@"
 }
 
+test_ns_host_vsock_ns_mode_ok() {
+	add_namespaces
+
+	for mode in "${NS_MODES[@]}"; do
+		if ! ns_set_mode "${mode}0" "${mode}"; then
+			del_namespaces
+			return "${KSFT_FAIL}"
+		fi
+	done
+
+	del_namespaces
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_host_vsock_ns_mode_write_once_ok() {
+	add_namespaces
+
+	for mode in "${NS_MODES[@]}"; do
+		local ns="${mode}0"
+		if ! ns_set_mode "${ns}" "${mode}"; then
+			del_namespaces
+			return "${KSFT_FAIL}"
+		fi
+
+		# try writing again and expect failure
+		if ns_set_mode "${ns}" "${mode}"; then
+			del_namespaces
+			return "${KSFT_FAIL}"
+		fi
+	done
+
+	del_namespaces
+
+	return "${KSFT_PASS}"
+}
+
 test_vm_server_host_client() {
 	if ! vm_vsock_test "init_ns" "server" 2 "${TEST_GUEST_PORT}"; then
 		return "${KSFT_FAIL}"
@@ -544,6 +621,26 @@ test_vm_loopback() {
 	return "${KSFT_PASS}"
 }
 
+test_ns_vm_local_mode_rejected() {
+	# Guest VMs have a G2H transport (virtio-vsock) active, so they
+	# should not be able to set namespace mode to 'local'.
+	# This test verifies that the sysctl write fails as expected.
+
+	# Try to set local mode in the guest's init_ns
+	if vm_ssh init_ns "echo local | tee /proc/sys/net/vsock/ns_mode &>/dev/null"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	# Verify mode is still 'global'
+	local mode
+	mode=$(vm_ssh init_ns "cat /proc/sys/net/vsock/ns_mode")
+	if [[ "${mode}" != "global" ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
 shared_vm_test() {
 	local tname
 
@@ -576,6 +673,11 @@ run_shared_vm_tests() {
 			continue
 		fi
 
+		if ! check_netns "${arg}"; then
+			check_result "${KSFT_SKIP}" "${arg}"
+			continue
+		fi
+
 		run_shared_vm_test "${arg}"
 		check_result "$?" "${arg}"
 	done
@@ -629,6 +731,28 @@ run_shared_vm_test() {
 	return "${rc}"
 }
 
+run_tests() {
+	for arg in "${ARGS[@]}"; do
+		if shared_vm_test "${arg}"; then
+			continue
+		fi
+
+		if ! check_netns "${arg}"; then
+			check_result "${KSFT_SKIP}" "${arg}"
+			continue
+		fi
+
+		add_namespaces
+
+		name=$(echo "${arg}" | awk '{ print $1 }')
+		log_host "Executing test_${name}"
+		eval test_"${name}"
+		check_result $? "${name}"
+
+		del_namespaces
+	done
+}
+
 BUILD=0
 QEMU="qemu-system-$(uname -m)"
 
@@ -674,6 +798,8 @@ if shared_vm_tests_requested "${ARGS[@]}"; then
 	terminate_pidfiles "${pidfile}"
 fi
 
+run_tests "${ARGS[@]}"
+
 echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
 echo "Log: ${LOG}"
 

-- 
2.47.3


