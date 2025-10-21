Return-Path: <kvm+bounces-60783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF18BF962E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECCF819C37C6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E2E28DEE9;
	Tue, 21 Oct 2025 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sc58K/oT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8181B2F6561
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090450; cv=none; b=FvftiqgqBYwPo8DiqxRjK3aAYju+SKIvlEKUrTlygUdIuudCJRphB4TGH+xIZdclyMMXc7enTPYJW2eQzkPw+N6Q9rhv8DHVTee1JK2ZZBb7wgUzX/Iq6P3SVHP/UbjINNEkLw8o3WB+SX/lwYV3QgO6ypnElOOGXg1e03yTyOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090450; c=relaxed/simple;
	bh=iuoFGVXiyma5BjD4qVBCYGN/H+01qwexZAVvYObUk/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j8wtGPdfGG1bZYvkZBovnZJal5SzcwNU9dGUwjIgfkD38RgbzoKaydTGCBK/xZlEDdfWnL4U4qWn/YAeT8Tvj5ayZ4u4w9dI8yWCME/T/11p1uyP1x6qXBrPki2GX8oL/kJ9TVSXUnSx3PH08npDJx2reoKLCSJRbwwVDZN3NQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sc58K/oT; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b5515eaefceso5064356a12.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090442; x=1761695242; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1mW3ek33KlnkdGQnSq6JCzqGkY1/dpZqhI7Q32Dbqk=;
        b=Sc58K/oT1ajqI8x8bqgh3ED3viK1T4F36SaocNpGzZ06GQmwWhEy3kpqzbU0kgY2k7
         JGobMSXi37TLtpt2iQP/LgSUcFb1RwwbjoDugvqIsCf1NKebLYyVGuO+a8q5zwv7cQNT
         9PUL6QGMeljoMSB6vDJYR/thxHSwE9bS7fEJnK2VEI4q7KtTAXzuJ21b8f1nL+lIYeq6
         FShbWzc8RcSR21YIRG99Nzof0bCOM4tYUPY3UtwQ4ANxzdbqJ29yizAYDLFOIhWTKUbL
         GiR1J/RfD9uFpKvXAi7ucI0/i4szU3Ksea2zSo7bW26v2ExxtpAKSSMPxlRXDM+TwawD
         AAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090442; x=1761695242;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1mW3ek33KlnkdGQnSq6JCzqGkY1/dpZqhI7Q32Dbqk=;
        b=KJFMcNbvcVZNF8bM5dGMX0zT7885gMeclpYZ4g/h2+rdtY+0uL4ejGca9VXYx5kydQ
         Ac/MFSbLv5rfXeL1Aqgqfpe5ifVtdW43ZBCwxcO/mPh8+FmHRZ/sAP5TCA//MjP0Zs9g
         kuuOyIWmARlx77iN4SDOw9fUIQk5azW5+9xjR5oJAMh8Y3SKgZtdNkL/hX8KrvM0X5nL
         0E/cFyzuO4PgyleJ8XnIrll4nBpgB0v7XDgj0O2NaBKB8fqhfaifY0tCTi/zXTyc/r/7
         yBkPklJiPRLl+CYL0FLb9w/aP+Hps9xUBRNHJ+MTvPeiceMRitzUj3qs/YLY7BIFHh1+
         DiKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRaUQf2vu4viotAToz4gy6c7QqsmTnqhbxtmh5vfkS34zjXAtp1ZRf1bqCEYFvgB6kbQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYKV8yka4DGvsedpzMcabNaDU65TWKc2j3dapNmNWYUWlu++Mm
	IEl6Nssgq0YnJlL9bx1jjzY5DSbc4V7J9AnCVz9Ujw0A35UOTpaFTLGT
X-Gm-Gg: ASbGncteU4BEzYLmoN39QjNS7dnYqJot+e+l1HomPf/jZbuczxVc4AgfUn5ng+hJFT2
	VA/Z3pUfJJROaTVMAyB/ImCx9xZs0sTZm6GDEHrjIZkRshk3uk2GbKNr/cTlECn5E9DvOroouNB
	PUamHZpdZgDwpRUaFzIeVp1lDb7sXhNDqqaJZ8MHrc/7K12hQaYdVo0M+Llz5d1vIUyvRSzBTFz
	1lSv5W1Wg+t5W2SQDDlj8fN5ckw3eYEU/V+fu/4aDkyACoXQEbq7Aw6A6WxgKDfD9nDn2ZLvcK3
	I9vTbwIG5PMolgEpahL1AZxEi4lvj7eRRcKRlEL/87F0ohFMUDYBWOzv9CJotFqyF5oAkeF07eR
	cOrpUqMmZ5AgYv5w7rdHPhNBYqp1w/j868S865ykD6ip9psoU0QpyiFYIInL0SvIo56YOCCJtOQ
	==
X-Google-Smtp-Source: AGHT+IEnoXliC4DZTHE40VZWQCvx9ip3e2WPqCXD2akJhvJXh22fPmIW6LK7Ka+Qk8/lrzwfhc3o6g==
X-Received: by 2002:a17:902:d58d:b0:269:9719:fffd with SMTP id d9443c01a7336-290c9cf9775mr231885445ad.1.1761090442484;
        Tue, 21 Oct 2025 16:47:22 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:74::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246fd8dfasm120381925ad.43.2025.10.21.16.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:22 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:47:08 -0700
Subject: [PATCH net-next v7 25/26] selftests/vsock: add tests for module
 loading order
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-25-0661b7b6f081@meta.com>
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

Add tests to check that module loading order does not break
vsock_loopback. Because vsock_loopback has some per-namespace data
structure initialization that affects vsock namespace modes, lets make
sure that namespace modes are respected and loopback sockets are
functional even when the namespaces and modes are set prior to loading
the vsock_loopback module.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 131 ++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index f8fa8b16d6e3..648ae71bf45a 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -68,6 +68,8 @@ readonly TEST_NAMES=(
 	ns_delete_vm_ok
 	ns_delete_host_ok
 	ns_delete_both_ok
+	ns_loopback_global_global_late_module_load_ok
+	ns_loopback_local_local_late_module_load_fails
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -153,6 +155,12 @@ readonly TEST_DESCS=(
 
 	# ns_delete_both_ok
 	"Check that deleting the VM and host's namespaces does not break the socket connection"
+
+	# ns_loopback_global_global_late_module_load_ok
+	"Test that loopback still works in global namespaces initialized prior to loading the vsock_loopback kmod"
+
+	# ns_loopback_local_local_late_module_load_fails
+	"Test that loopback connections still fail between local namespaces initialized prior to loading the vsock_loopback kmod"
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
@@ -912,6 +920,23 @@ test_ns_diff_local_vm_connect_to_local_host_fails() {
 	return "${KSFT_FAIL}"
 }
 
+unload_module() {
+	local module=$1
+	local i
+
+	for ((i = 0; i < 5; i++)); do
+		modprobe -r "${module}" 2>/dev/null || :
+
+		if [[ "$(lsmod | grep -c ${module})" -eq 0 ]]; then
+			return 0
+		fi
+
+		sleep 1
+	done
+
+	return 1
+}
+
 __test_loopback_two_netns() {
 	local ns0=$1
 	local ns1=$2
@@ -1264,6 +1289,112 @@ test_ns_delete_both_ok() {
 	check_ns_changes_dont_break_connection "both" "delete"
 }
 
+test_ns_loopback_global_global_late_module_load_ok() {
+	declare -a pids
+	local unixfile
+	local ns0 ns1
+	local pids
+	local port
+
+	if ! unload_module vsock_loopback; then
+		log_host "Unable to unload vsock_loopback, skipping..."
+		return "${KSFT_SKIP}"
+	fi
+
+	ns0=loopback_ns0
+	ns1=loopback_ns1
+
+	ip netns del "${ns0}" &>/dev/null || :
+	ip netns del "${ns1}" &>/dev/null || :
+	ip netns add "${ns0}"
+	ip netns add "${ns1}"
+	ns_set_mode "${ns0}" global
+	ns_set_mode "${ns1}" global
+	ip netns exec "${ns0}" ip link set dev lo up
+	ip netns exec "${ns1}" ip link set dev lo up
+
+	modprobe vsock_loopback &> /dev/null || :
+
+	unixfile=$(mktemp -u /tmp/XXXX.sock)
+	port=321
+	ip netns exec "${ns1}" \
+		socat TCP-LISTEN:"${port}",fork \
+			UNIX-CONNECT:"${unixfile}" &
+	pids+=($!)
+
+	host_wait_for_listener "${ns1}" "${port}"
+	ip netns exec "${ns0}" socat UNIX-LISTEN:"${unixfile}",fork \
+		TCP-CONNECT:localhost:"${port}" &
+	pids+=($!)
+
+	if ! host_vsock_test "${ns0}" "server" 1 "${port}"; then
+		ip netns del "${ns0}" &>/dev/null || :
+		ip netns del "${ns1}" &>/dev/null || :
+		terminate_pids "${pids[@]}"
+		return "${KSFT_FAIL}"
+	fi
+
+	if ! host_vsock_test "${ns1}" "127.0.0.1" 1 "${port}"; then
+		ip netns del "${ns0}" &>/dev/null || :
+		ip netns del "${ns1}" &>/dev/null || :
+		terminate_pids "${pids[@]}"
+		return "${KSFT_FAIL}"
+	fi
+
+	ip netns del "${ns0}" &>/dev/null || :
+	ip netns del "${ns1}" &>/dev/null || :
+	terminate_pids "${pids[@]}"
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_loopback_local_local_late_module_load_fails() {
+	declare -a pids
+	local ns0 ns1
+	local outfile
+	local pids
+	local rc
+
+	if ! unload_module vsock_loopback; then
+		log_host "Unable to unload vsock_loopback, skipping..."
+		return "${KSFT_SKIP}"
+	fi
+
+	ns0=loopback_ns0
+	ns1=loopback_ns1
+
+	ip netns del "${ns0}" &>/dev/null || :
+	ip netns del "${ns1}" &>/dev/null || :
+	ip netns add "${ns0}"
+	ip netns add "${ns1}"
+	ns_set_mode "${ns0}" local
+	ns_set_mode "${ns1}" local
+
+	modprobe vsock_loopback &> /dev/null || :
+
+	outfile=$(mktemp /tmp/XXXX.vmtest.out)
+	ip netns exec "${ns0}" socat VSOCK-LISTEN:${port} STDOUT \
+		> "${outfile}" 2>/dev/null &
+	pids+=($!)
+
+	echo TEST | \
+		ip netns exec "${ns1}" socat STDIN VSOCK-CONNECT:1:${port} \
+			2>/dev/null
+
+	if grep -q "TEST" "${outfile}" 2>/dev/null; then
+		rc="${KSFT_FAIL}"
+	else
+		rc="${KSFT_PASS}"
+	fi
+
+	ip netns del "${ns0}" &>/dev/null || :
+	ip netns del "${ns1}" &>/dev/null || :
+	terminate_pids "${pids[@]}"
+	rm -f "${outfile}"
+
+	return "${rc}"
+}
+
 shared_vm_test() {
 	local tname
 

-- 
2.47.3


