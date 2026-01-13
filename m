Return-Path: <kvm+bounces-67897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A382CD16712
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:15:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0015F30574EF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CB6340A6A;
	Tue, 13 Jan 2026 03:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntE8jSAq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BB130E84E
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 03:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273986; cv=none; b=Vq2cwLvvUN3tnB6RViwz8Gzvs1ID/1VTxUsx+2+YFHk2pzaaqJgeYlZXrGCOl4eLzNAu9GI9C33kukpXmnY6jzmd7MF6nuRlzbvQ9Az1prIOwY8CQZu6mzmnlrpQE1Xbf1y9dxwPBzdVwBlhtv96XXo9NwN6xr4vTkClYPIoP+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273986; c=relaxed/simple;
	bh=1Q26HXpW7TYNGutKg90p+BWQKQP/kUEHf57kmmFmrxY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HOT7WfAVDZD8LBsfk71r7JhkoLX1ALgZflLDtHd7h4lKkr9AEFq3k7BkGNe/4osRU2nu3Ok/qSfja8fK2FTdnClmmj0hC3a7svnIsTA8eK4TTZTeHGFLn2Rhn/CV8XYqYY2k57vG62ld1JnKEW/NXO4TJDu4uwYtW3EUT3UqJfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntE8jSAq; arc=none smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64472121ad5so4851119d50.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768273983; x=1768878783; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lG0BScxKvY/q9QPoykPF18FCgS+okYK88nxhg8/Kgqs=;
        b=ntE8jSAqXpWoEJ/5lAVEyPeWvMw1kNR3mOoxm9WlaResZIQv7h8SLwvvhGSOgAv4AV
         j3mRKmweyevdUNQqtSAWiH3lYGyxm0SCbhghqWcLWa2UPdD00BhqSptUV63VQO8BwM9u
         WsgLTMZamHh1bKEEw1Keq0u9n1xPVfotSofeYOa5sKDjt/ZQ/7EkrzuKk/8oFpX0t4gX
         ki0arvULNrhbVWaJWhAdeHqoolB7G70IV2FBbhiJvGuIXY2IsqDhiTz7rblGydHkNjdy
         GdVkhDWaa9O37ZBsEv0L2QL8eCSMpx58//LZPVpG4X2pLp1kv+zwFW+jBHNAgonZKFgn
         sA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768273983; x=1768878783;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lG0BScxKvY/q9QPoykPF18FCgS+okYK88nxhg8/Kgqs=;
        b=dGGSl+6vKpN9h2TAbiOneu8tp5xCXBig00Nut407cmy2rT0znaLzgXlQVfV8klBPmi
         56iRxkJgkJRPTA6QDLD4lAhmPyvzZoIxCTuJQ8O/ns4qlz5zjhlDxccWvndrXiy4hOgq
         o3/MBYFFCO0qIy7opvY2Ve0Btb73y9U+nV3wAi3/iqohHhi9QPIMw9jjSI3liC/AcLcW
         M2jCQwoFOe5CpK/0NjJXfKDZ+NlZ27nxZ5FK+BIR6YDP10obBOpB7t8Sf+GNEgethiKY
         VTA0KUOnr2GuU+/nlcc055YhYVSEBhNCctS5pgqqXgU2EY5XNLYnDSGYH978P7r1ISUa
         LsfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzu2YfRyI5uk1GiD31tJi69kz6IY/SysHwvbYSap+29GXyQ/hVFpU73kz1qwjZzQco7j0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOFIALILIOhpNZdr16dw6ES13D6yisitwXSoE2VE6ToJ0RQ/RY
	64UnarEu3/ffUd9eeYNs4a3xNYasQwUVyaqeMGDmKt9bdv+2TD8+HYSI
X-Gm-Gg: AY/fxX6h22QS59JbI1TgcLxTSluw3zL/bWGPdYPDPHyHdPVMQYunLbTZHo3CTaDYOgz
	8GKHuoxEQkzUPydu0nIjBOLp3y5UwiEHP+0wl6LvkdTwZVYI7NSQZw1x9EV8lKIvSZ5sgRcOXib
	Q7YetqSEcOi9/QLwhaCYdIG70BG/f4x4L1n44a1FJgYhxHpNo6E8wlBAf+2oHueE8OUD5+yJsqo
	lvFZEaEA4tKULTaFdMCM9O3B9vLjjNL52BhX2vEksMGJEJfLbrcUCSvPX6D5vi1ealmtWhk8dmx
	yV3sMgWVTiot5CSdmw7PHR+T0TKPnyy63Q+0lnzrBpmn+k5bo6UvNb02+qAkD81t+efhkSnfON+
	zYsYBQiDOs4kgF4bWur2ytKzj6HsZuKBefvYtyAx4tnTjTEsdHqErvlVigTb65/HbdUFRyGpDXD
	bkLEcYhEgkvuQ4e877sCg=
X-Google-Smtp-Source: AGHT+IH87jmxPaRSAq2EVgGLmPyh2NiseD4EQw9Mxc2LqJKsZ80wHV+7ZKSjM+OAS1QsEBzlpSNPpw==
X-Received: by 2002:a05:690e:14c8:b0:645:541a:4f11 with SMTP id 956f58d0204a3-64716c66416mr15549542d50.49.1768273982699;
        Mon, 12 Jan 2026 19:13:02 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa57a73csm75319457b3.19.2026.01.12.19.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:13:02 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 12 Jan 2026 19:11:15 -0800
Subject: [PATCH net-next v14 06/12] selftests/vsock: prepare vm management
 helpers for namespaces
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-vsock-vmtest-v14-6-a5c332db3e2b@meta.com>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
In-Reply-To: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
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

Add namespace support to vm management, ssh helpers, and vsock_test
wrapper functions. This enables running VMs and test helpers in specific
namespaces, which is required for upcoming namespace isolation tests.

The functions still work correctly within the init ns, though the caller
must now pass "init_ns" explicitly.

No functional changes for existing tests. All have been updated to pass
"init_ns" explicitly.

Affected functions (such as vm_start() and vm_ssh()) now wrap their
commands with 'ip netns exec' when executing commands in non-init
namespaces.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 93 +++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index c2bdc293b94c..1d03acb62347 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -135,7 +135,18 @@ del_namespaces() {
 }
 
 vm_ssh() {
-	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
+	local ns_exec
+
+	if [[ "${1}" == init_ns ]]; then
+		ns_exec=""
+	else
+		ns_exec="ip netns exec ${1}"
+	fi
+
+	shift
+
+	${ns_exec} ssh -q -o UserKnownHostsFile=/dev/null -p "${SSH_HOST_PORT}" localhost "$@"
+
 	return $?
 }
 
@@ -258,10 +269,12 @@ terminate_pidfiles() {
 
 vm_start() {
 	local pidfile=$1
+	local ns=$2
 	local logfile=/dev/null
 	local verbose_opt=""
 	local kernel_opt=""
 	local qemu_opts=""
+	local ns_exec=""
 	local qemu
 
 	qemu=$(command -v "${QEMU}")
@@ -282,7 +295,11 @@ vm_start() {
 		kernel_opt="${KERNEL_CHECKOUT}"
 	fi
 
-	vng \
+	if [[ "${ns}" != "init_ns" ]]; then
+		ns_exec="ip netns exec ${ns}"
+	fi
+
+	${ns_exec} vng \
 		--run \
 		${kernel_opt} \
 		${verbose_opt} \
@@ -297,6 +314,7 @@ vm_start() {
 }
 
 vm_wait_for_ssh() {
+	local ns=$1
 	local i
 
 	i=0
@@ -304,7 +322,8 @@ vm_wait_for_ssh() {
 		if [[ ${i} -gt ${WAIT_PERIOD_MAX} ]]; then
 			die "Timed out waiting for guest ssh"
 		fi
-		if vm_ssh -- true; then
+
+		if vm_ssh "${ns}" -- true; then
 			break
 		fi
 		i=$(( i + 1 ))
@@ -338,30 +357,41 @@ wait_for_listener()
 }
 
 vm_wait_for_listener() {
-	local port=$1
+	local ns=$1
+	local port=$2
 
-	vm_ssh <<EOF
+	vm_ssh "${ns}" <<EOF
 $(declare -f wait_for_listener)
 wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX}
 EOF
 }
 
 host_wait_for_listener() {
-	local port=$1
+	local ns=$1
+	local port=$2
 
-	wait_for_listener "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}"
+	if [[ "${ns}" == "init_ns" ]]; then
+		wait_for_listener "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}"
+	else
+		ip netns exec "${ns}" bash <<-EOF
+			$(declare -f wait_for_listener)
+			wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX}
+		EOF
+	fi
 }
 
+
 vm_vsock_test() {
-	local host=$1
-	local cid=$2
-	local port=$3
+	local ns=$1
+	local host=$2
+	local cid=$3
+	local port=$4
 	local rc
 
 	# log output and use pipefail to respect vsock_test errors
 	set -o pipefail
 	if [[ "${host}" != server ]]; then
-		vm_ssh -- "${VSOCK_TEST}" \
+		vm_ssh "${ns}" -- "${VSOCK_TEST}" \
 			--mode=client \
 			--control-host="${host}" \
 			--peer-cid="${cid}" \
@@ -369,7 +399,7 @@ vm_vsock_test() {
 			2>&1 | log_guest
 		rc=$?
 	else
-		vm_ssh -- "${VSOCK_TEST}" \
+		vm_ssh "${ns}" -- "${VSOCK_TEST}" \
 			--mode=server \
 			--peer-cid="${cid}" \
 			--control-port="${port}" \
@@ -381,7 +411,7 @@ vm_vsock_test() {
 			return $rc
 		fi
 
-		vm_wait_for_listener "${port}"
+		vm_wait_for_listener "${ns}" "${port}"
 		rc=$?
 	fi
 	set +o pipefail
@@ -390,22 +420,28 @@ vm_vsock_test() {
 }
 
 host_vsock_test() {
-	local host=$1
-	local cid=$2
-	local port=$3
+	local ns=$1
+	local host=$2
+	local cid=$3
+	local port=$4
 	local rc
 
+	local cmd="${VSOCK_TEST}"
+	if [[ "${ns}" != "init_ns" ]]; then
+		cmd="ip netns exec ${ns} ${cmd}"
+	fi
+
 	# log output and use pipefail to respect vsock_test errors
 	set -o pipefail
 	if [[ "${host}" != server ]]; then
-		${VSOCK_TEST} \
+		${cmd} \
 			--mode=client \
 			--peer-cid="${cid}" \
 			--control-host="${host}" \
 			--control-port="${port}" 2>&1 | log_host
 		rc=$?
 	else
-		${VSOCK_TEST} \
+		${cmd} \
 			--mode=server \
 			--peer-cid="${cid}" \
 			--control-port="${port}" 2>&1 | log_host &
@@ -416,7 +452,7 @@ host_vsock_test() {
 			return $rc
 		fi
 
-		host_wait_for_listener "${port}"
+		host_wait_for_listener "${ns}" "${port}"
 		rc=$?
 	fi
 	set +o pipefail
@@ -460,11 +496,11 @@ log_guest() {
 }
 
 test_vm_server_host_client() {
-	if ! vm_vsock_test "server" 2 "${TEST_GUEST_PORT}"; then
+	if ! vm_vsock_test "init_ns" "server" 2 "${TEST_GUEST_PORT}"; then
 		return "${KSFT_FAIL}"
 	fi
 
-	if ! host_vsock_test "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"; then
+	if ! host_vsock_test "init_ns" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"; then
 		return "${KSFT_FAIL}"
 	fi
 
@@ -472,11 +508,11 @@ test_vm_server_host_client() {
 }
 
 test_vm_client_host_server() {
-	if ! host_vsock_test "server" "${VSOCK_CID}" "${TEST_HOST_PORT_LISTENER}"; then
+	if ! host_vsock_test "init_ns" "server" "${VSOCK_CID}" "${TEST_HOST_PORT_LISTENER}"; then
 		return "${KSFT_FAIL}"
 	fi
 
-	if ! vm_vsock_test "10.0.2.2" 2 "${TEST_HOST_PORT_LISTENER}"; then
+	if ! vm_vsock_test "init_ns" "10.0.2.2" 2 "${TEST_HOST_PORT_LISTENER}"; then
 		return "${KSFT_FAIL}"
 	fi
 
@@ -486,13 +522,14 @@ test_vm_client_host_server() {
 test_vm_loopback() {
 	local port=60000 # non-forwarded local port
 
-	vm_ssh -- modprobe vsock_loopback &> /dev/null || :
+	vm_ssh "init_ns" -- modprobe vsock_loopback &> /dev/null || :
 
-	if ! vm_vsock_test "server" 1 "${port}"; then
+	if ! vm_vsock_test "init_ns" "server" 1 "${port}"; then
 		return "${KSFT_FAIL}"
 	fi
 
-	if ! vm_vsock_test "127.0.0.1" 1 "${port}"; then
+
+	if ! vm_vsock_test "init_ns" "127.0.0.1" 1 "${port}"; then
 		return "${KSFT_FAIL}"
 	fi
 
@@ -621,8 +658,8 @@ cnt_total=0
 if shared_vm_tests_requested "${ARGS[@]}"; then
 	log_host "Booting up VM"
 	pidfile="$(create_pidfile)"
-	vm_start "${pidfile}"
-	vm_wait_for_ssh
+	vm_start "${pidfile}" "init_ns"
+	vm_wait_for_ssh "init_ns"
 	log_host "VM booted up"
 
 	run_shared_vm_tests "${ARGS[@]}"

-- 
2.47.3


