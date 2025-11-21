Return-Path: <kvm+bounces-64066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D2734C77758
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 7B4E72CFDB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE0F308F09;
	Fri, 21 Nov 2025 05:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLVmYKf+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291DA3002BB
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703912; cv=none; b=JJDUzSaPB8OuSGEtgPvNMvhP1K+XoEYDq+d7rOic5T6yzEMAhEQoQSuf86ngGLI1Nh8Siuwsg9zEJcnrPHzNJANXyu7WB7BdeGWTylOPxORal5uTeI0zQ9EhDeFiD60lUiMHwAkQjOUhh3qWx2Gndy3X0pg1FIuLoM0Jq0O280Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703912; c=relaxed/simple;
	bh=ElzwQ/Uk7+6/K3/0sD1a50qGoV8AgNqS88zz/fPpHYU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P70Bxy3hKLJG2OPYbSHJxxb4zjU4K0UufBy7jhbMzOl8PFUAHUxOa/qhJjwFoYm+6yMWvS8apJDV55dxobMVtyuOwPKaDImCKdkzKGAXTu56WXNI0pLp7Rcbg/0dVbtIPu+txOoZqZYdl/OBOhn2nXhoe/RMoKr/dx6WEGmH+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLVmYKf+; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34381ec9197so1505484a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 21:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703903; x=1764308703; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M77mCllcJMbMpVR22bc4qHyCRYKpmXn6ys6/Up60Jxg=;
        b=cLVmYKf+TdzYL3lfoKW7BgJt2h6emqrW+vPZ6cbBWPAVyyhmmLOkM+ZEIlg97cUmPN
         iKQsCBgHfkwjOhNQNGBzhhACxn/FyQJDNe566FaC6w5UtbpCb8A91WOwM8KEwUkCYHY8
         XM9cO8CNTtLCY5xMu3DWVg2cAyZ9WT7DWQDKK27UJsL2eiD1eYRHAtD+USLxyFRoEal7
         Mj4eQzOWIlB2mYp73Yx0sY3zBUKw+xzucCDh8M5Q4cFpwXtRh71KvVoYJwXA7Kzi/5fh
         bGL/2RIQkCd44anRxu5WopnhM3K/CXKU0u5yR872Wwey8jq3Mm+QRSYC2GkVYumHufP5
         9vLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703903; x=1764308703;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M77mCllcJMbMpVR22bc4qHyCRYKpmXn6ys6/Up60Jxg=;
        b=K77bWW9jd/QhF2dxy/t0bICwvSSKOYV7p2a1e2GlXAzA7Op7i2vN0G9gH/ZpFulAy2
         e+EbetXfXDdhI8qv+Zn4gx48y+jIDbaY0cio+NNNEvx9Sz9JSB4Qtvi8ZMBW0DWIlQiY
         yt79fqVctR3TnvBPE3wEKbTwh/c7Wt1cedtHLOXuBmn51DpBut9okZrIenJC9nK8QL/i
         GVIoGnt5gcmS3MF2XOfsxhHU7sTqaAou6PPo2gJzsAIz9QqLtBCZRjVlB31kjgF9rZCq
         jc4OlFFGdE++RI2D6NMyaW8rzfGkNkkkOY+8ZsVMIGUAjwYoRDZaMod3eTpp6feDKtK+
         V5Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWzhzsQv5CNId5reXJ11354UnwWwRB9RbEmPT4NdHbqp32b2EqGEqK+idI0pdyfUu2Lm+0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya7yduNMGsaHkhoar1Rq3iWumFJ4tv1xSR/j8Bz9ZVNvVlkjrz
	POEypMU7H8jGCN+nc030GpL78UqwMPgRAEqtyU6nQtf3QjUjRnoXbXm1
X-Gm-Gg: ASbGncvdaW0PQSwqZOMxfan403KE2VobefZo0Kj+XjJyfkqSju0mM9JJJPDCjpMqRhL
	bSdvXhN5pqU0ArVGeJ9KIIowC5fWmeIGNGfkS59mVie0af1ltywgq+W7QGDi3UQ6LpCMLrqImP9
	uoHhT06ZpRNs5G/H9LB9uMMNGwz7YmIgfimzKbJPHxxHqY4ZG9nNIlLoIIYweoWgpqkUG4/MozD
	364vL+wU74oM2mm+OruYTIXwulStWV7ptxiDlXIHXhrHqgtdkqCg3pRTE7nw5OV14+QycksWBoi
	RNL4KKBvK8qLHrfoQ3hBnliVIRZeoY7DwZ7Xyg2ieB4ZEZr0NX6iXZAaN3vA9+t0PJQlUFwStMy
	chBj0gSXmlnobZT7FKBDYOcZOKcVDkRDmkf639iLpPW8yq6EKDoESovDnBg1vMfw9bYM/7Ny7Vv
	Hc/HQUuiu2BuPx+dCP7Ymt
X-Google-Smtp-Source: AGHT+IFiczZxqh/SzL68p8yHg4vkV1ClW3o7kQ11kfQfTKx98sbjec/c4UHBvDjgv7YTJ5BYR649kQ==
X-Received: by 2002:a17:90b:580c:b0:341:8491:472a with SMTP id 98e67ed59e1d1-34733e4c8d9mr1458637a91.4.1763703902634;
        Thu, 20 Nov 2025 21:45:02 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:4c::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f174c9dasm4610030b3a.65.2025.11.20.21.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:45:02 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 20 Nov 2025 21:44:44 -0800
Subject: [PATCH net-next v11 12/13] selftests/vsock: add tests for host <->
 vm connectivity with namespaces
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251120-vsock-vmtest-v11-12-55cbc80249a7@meta.com>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
In-Reply-To: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
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
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add tests to validate namespace correctness using vsock_test and socat.
The vsock_test tool is used to validate expected success tests, but
socat is used for expected failure tests. socat is used to ensure that
connections are rejected outright instead of failing due to some other
socket behavior (as tested in vsock_test). Additionally, socat is
already required for tunneling TCP traffic from vsock_test. Using only
one of the vsock_test tests like 'test_stream_client_close_client' would
have yielded a similar result, but doing so wouldn't remove the socat
dependency.

Additionally, check for the dependency socat. socat needs special
handling beyond just checking if it is on the path because it must be
compiled with support for both vsock and unix. The function
check_socat() checks that this support exists.

Add more padding to test name printf strings because the tests added in
this patch would otherwise overflow.

Add vm_dmesg_start() and vm_dmesg_check() to encapsulate checking dmesg
for oops and warnings.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- add 'sleep "${WAIT_PERIOD}"' after any non-TCP socat LISTEN cmd
  (Stefano)
- add host_wait_for_listener() after any socat TCP-LISTEN (Stefano)
- reuse vm_dmesg_{oops,warn}_count() inside vm_dmesg_check()
- fix copy-paste in test_ns_same_local_vm_connect_to_local_host_ok()
  (Stefano)

Changes in v10:
- add vm_dmesg_start() and vm_dmesg_check()

Changes in v9:
- consistent variable quoting
---
 tools/testing/selftests/vsock/vmtest.sh | 557 +++++++++++++++++++++++++++++++-
 1 file changed, 555 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index f84da1e8ad14..dfa895abfc7f 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -7,6 +7,7 @@
 #		* virtme-ng
 #		* busybox-static (used by virtme-ng)
 #		* qemu	(used by virtme-ng)
+#		* socat
 #
 # shellcheck disable=SC2317,SC2119
 
@@ -55,6 +56,19 @@ readonly TEST_NAMES=(
 	ns_local_same_cid_ok
 	ns_global_local_same_cid_ok
 	ns_local_global_same_cid_ok
+	ns_diff_global_host_connect_to_global_vm_ok
+	ns_diff_global_host_connect_to_local_vm_fails
+	ns_diff_global_vm_connect_to_global_host_ok
+	ns_diff_global_vm_connect_to_local_host_fails
+	ns_diff_local_host_connect_to_local_vm_fails
+	ns_diff_local_vm_connect_to_local_host_fails
+	ns_diff_global_to_local_loopback_local_fails
+	ns_diff_local_to_global_loopback_fails
+	ns_diff_local_to_local_loopback_fails
+	ns_diff_global_to_global_loopback_ok
+	ns_same_local_loopback_ok
+	ns_same_local_host_connect_to_local_vm_ok
+	ns_same_local_vm_connect_to_local_host_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -86,6 +100,45 @@ readonly TEST_DESCS=(
 
 	# ns_local_global_same_cid_ok
 	"Check QEMU successfully starts one VM in a local ns and then another VM in a global ns with the same CID."
+
+	# ns_diff_global_host_connect_to_global_vm_ok
+	"Run vsock_test client in global ns with server in VM in another global ns."
+
+	# ns_diff_global_host_connect_to_local_vm_fails
+	"Run socat to test a process in a global ns fails to connect to a VM in a local ns."
+
+	# ns_diff_global_vm_connect_to_global_host_ok
+	"Run vsock_test client in VM in a global ns with server in another global ns."
+
+	# ns_diff_global_vm_connect_to_local_host_fails
+	"Run socat to test a VM in a global ns fails to connect to a host process in a local ns."
+
+	# ns_diff_local_host_connect_to_local_vm_fails
+	"Run socat to test a host process in a local ns fails to connect to a VM in another local ns."
+
+	# ns_diff_local_vm_connect_to_local_host_fails
+	"Run socat to test a VM in a local ns fails to connect to a host process in another local ns."
+
+	# ns_diff_global_to_local_loopback_local_fails
+	"Run socat to test a loopback vsock in a global ns fails to connect to a vsock in a local ns."
+
+	# ns_diff_local_to_global_loopback_fails
+	"Run socat to test a loopback vsock in a local ns fails to connect to a vsock in a global ns."
+
+	# ns_diff_local_to_local_loopback_fails
+	"Run socat to test a loopback vsock in a local ns fails to connect to a vsock in another local ns."
+
+	# ns_diff_global_to_global_loopback_ok
+	"Run socat to test a loopback vsock in a global ns successfully connects to a vsock in another global ns."
+
+	# ns_same_local_loopback_ok
+	"Run socat to test a loopback vsock in a local ns successfully connects to a vsock in the same ns."
+
+	# ns_same_local_host_connect_to_local_vm_ok
+	"Run vsock_test client in a local ns with server in VM in same ns."
+
+	# ns_same_local_vm_connect_to_local_host_ok
+	"Run vsock_test client in VM in a local ns with server in same ns."
 )
 
 readonly USE_SHARED_VM=(
@@ -117,7 +170,7 @@ usage() {
 	for ((i = 0; i < ${#TEST_NAMES[@]}; i++)); do
 		name=${TEST_NAMES[${i}]}
 		desc=${TEST_DESCS[${i}]}
-		printf "\t%-35s%-35s\n" "${name}" "${desc}"
+		printf "\t%-55s%-35s\n" "${name}" "${desc}"
 	done
 	echo
 
@@ -236,7 +289,7 @@ check_args() {
 }
 
 check_deps() {
-	for dep in vng ${QEMU} busybox pkill ssh ss; do
+	for dep in vng ${QEMU} busybox pkill ssh ss socat; do
 		if [[ ! -x $(command -v "${dep}") ]]; then
 			echo -e "skip:    dependency ${dep} not found!\n"
 			exit "${KSFT_SKIP}"
@@ -287,6 +340,20 @@ check_vng() {
 	fi
 }
 
+check_socat() {
+	local support_string
+
+	support_string="$(socat -V)"
+
+	if [[ "${support_string}" != *"WITH_VSOCK 1"* ]]; then
+		die "err: socat is missing vsock support"
+	fi
+
+	if [[ "${support_string}" != *"WITH_UNIX 1"* ]]; then
+		die "err: socat is missing unix support"
+	fi
+}
+
 handle_build() {
 	if [[ ! "${BUILD}" -eq 1 ]]; then
 		return
@@ -335,6 +402,14 @@ terminate_pidfiles() {
 	done
 }
 
+terminate_pids() {
+	local pid
+
+	for pid in "$@"; do
+		kill -SIGTERM "${pid}" &>/dev/null || :
+	done
+}
+
 vm_start() {
 	local pidfile=$1
 	local ns=$2
@@ -473,6 +548,28 @@ vm_dmesg_warn_count() {
 	vm_ssh "${ns}" -- dmesg --level=warn 2>/dev/null | grep -c -i 'vsock'
 }
 
+vm_dmesg_check() {
+	local pidfile=$1
+	local ns=$2
+	local oops_before=$3
+	local warn_before=$4
+	local oops_after warn_after
+
+	oops_after=$(vm_dmesg_oops_count "${ns}")
+	if [[ "${oops_after}" -gt "${oops_before}" ]]; then
+		echo "FAIL: kernel oops detected on vm in ns ${ns}" | log_host
+		return 1
+	fi
+
+	warn_after=$(vm_dmesg_warn_count "${ns}")
+	if [[ "${warn_after}" -gt "${warn_before}" ]]; then
+		echo "FAIL: kernel warning detected on vm in ns ${ns}" | log_host
+		return 1
+	fi
+
+	return 0
+}
+
 vm_vsock_test() {
 	local ns=$1
 	local host=$2
@@ -597,6 +694,461 @@ test_ns_host_vsock_ns_mode_ok() {
 	return "${KSFT_PASS}"
 }
 
+test_ns_diff_global_host_connect_to_global_vm_ok() {
+	local oops_before warn_before
+	local pids pid pidfile
+	local ns0 ns1 port
+	declare -a pids
+	local unixfile
+	ns0="global0"
+	ns1="global1"
+	port=1234
+	local rc
+
+	init_namespaces
+
+	pidfile="$(create_pidfile)"
+
+	if ! vm_start "${pidfile}" "${ns0}"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns0}"
+	oops_before=$(vm_dmesg_oops_count "${ns0}")
+	warn_before=$(vm_dmesg_warn_count "${ns0}")
+
+	unixfile=$(mktemp -u /tmp/XXXX.sock)
+	ip netns exec "${ns1}" \
+		socat TCP-LISTEN:"${TEST_HOST_PORT}",fork \
+			UNIX-CONNECT:"${unixfile}" &
+	pids+=($!)
+	host_wait_for_listener "${ns1}" "${TEST_HOST_PORT}" "tcp"
+
+	ip netns exec "${ns0}" socat UNIX-LISTEN:"${unixfile}",fork \
+		TCP-CONNECT:localhost:"${TEST_HOST_PORT}" &
+	pids+=($!)
+	host_wait_for_listener "${ns0}" "${unixfile}" "unix"
+
+	vm_vsock_test "${ns0}" "server" 2 "${TEST_GUEST_PORT}"
+	vm_wait_for_listener "${ns0}" "${TEST_GUEST_PORT}" "tcp"
+	host_vsock_test "${ns1}" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"
+	rc=$?
+
+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pids "${pids[@]}"
+	terminate_pidfiles "${pidfile}"
+
+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_diff_global_host_connect_to_local_vm_fails() {
+	local oops_before warn_before
+	local ns0="global0"
+	local ns1="local0"
+	local port=12345
+	local dmesg_rc
+	local pidfile
+	local result
+	local pid
+
+	init_namespaces
+
+	outfile=$(mktemp)
+
+	pidfile="$(create_pidfile)"
+	if ! vm_start "${pidfile}" "${ns1}"; then
+		log_host "failed to start vm (cid=${VSOCK_CID}, ns=${ns0})"
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns1}"
+	oops_before=$(vm_dmesg_oops_count "${ns1}")
+	warn_before=$(vm_dmesg_warn_count "${ns1}")
+
+	vm_ssh "${ns1}" -- socat VSOCK-LISTEN:"${port}" STDOUT > "${outfile}" &
+	vm_wait_for_listener "${ns1}" "${port}" "vsock"
+	echo TEST | ip netns exec "${ns0}" \
+		socat STDIN VSOCK-CONNECT:"${VSOCK_CID}":"${port}" 2>/dev/null
+
+	vm_dmesg_check "${pidfile}" "${ns1}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+	result=$(cat "${outfile}")
+	rm -f "${outfile}"
+
+	if [[ "${result}" == "TEST" ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_diff_global_vm_connect_to_global_host_ok() {
+	local oops_before warn_before
+	local ns0="global0"
+	local ns1="global1"
+	local port=12345
+	local unixfile
+	local dmesg_rc
+	local pidfile
+	local pids
+	local rc
+
+	init_namespaces
+
+	declare -a pids
+
+	log_host "Setup socat bridge from ns ${ns0} to ns ${ns1} over port ${port}"
+
+	unixfile=$(mktemp -u /tmp/XXXX.sock)
+
+	ip netns exec "${ns0}" \
+		socat TCP-LISTEN:"${port}" UNIX-CONNECT:"${unixfile}" &
+	pids+=($!)
+	host_wait_for_listener "${ns0}" "${port}" "tcp"
+
+	ip netns exec "${ns1}" \
+		socat UNIX-LISTEN:"${unixfile}" TCP-CONNECT:127.0.0.1:"${port}" &
+	pids+=($!)
+	host_wait_for_listener "${ns1}" "${unixfile}" "unix"
+
+	log_host "Launching ${VSOCK_TEST} in ns ${ns1}"
+	host_vsock_test "${ns1}" "server" "${VSOCK_CID}" "${port}"
+
+	pidfile="$(create_pidfile)"
+	if ! vm_start "${pidfile}" "${ns0}"; then
+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
+		terminate_pids "${pids[@]}"
+		rm -f "${unixfile}"
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns0}"
+
+	oops_before=$(vm_dmesg_oops_count "${ns0}")
+	warn_before=$(vm_dmesg_warn_count "${ns0}")
+
+	vm_vsock_test "${ns0}" "10.0.2.2" 2 "${port}"
+	rc=$?
+
+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+	terminate_pids "${pids[@]}"
+	rm -f "${unixfile}"
+
+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+
+}
+
+test_ns_diff_global_vm_connect_to_local_host_fails() {
+	local ns0="global0"
+	local ns1="local0"
+	local port=12345
+	local oops_before warn_before
+	local dmesg_rc
+	local pidfile
+	local result
+	local pid
+
+	init_namespaces
+
+	log_host "Launching socat in ns ${ns1}"
+	outfile=$(mktemp)
+
+	ip netns exec "${ns1}" socat VSOCK-LISTEN:"${port}" STDOUT &> "${outfile}" &
+	pid=$!
+	host_wait_for_listener "${ns1}" "${port}" "vsock"
+
+	pidfile="$(create_pidfile)"
+	if ! vm_start "${pidfile}" "${ns0}"; then
+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
+		terminate_pids "${pid}"
+		rm -f "${outfile}"
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns0}"
+
+	oops_before=$(vm_dmesg_oops_count "${ns0}")
+	warn_before=$(vm_dmesg_warn_count "${ns0}")
+
+	vm_ssh "${ns0}" -- \
+		bash -c "echo TEST | socat STDIN VSOCK-CONNECT:2:${port}" 2>&1 | log_guest
+
+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+	terminate_pids "${pid}"
+
+	result=$(cat "${outfile}")
+	rm -f "${outfile}"
+
+	if [[ "${result}" != TEST ]] && [[ "${dmesg_rc}" -eq 0 ]]; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_diff_local_host_connect_to_local_vm_fails() {
+	local ns0="local0"
+	local ns1="local1"
+	local port=12345
+	local oops_before warn_before
+	local dmesg_rc
+	local pidfile
+	local result
+	local pid
+
+	init_namespaces
+
+	outfile=$(mktemp)
+
+	pidfile="$(create_pidfile)"
+	if ! vm_start "${pidfile}" "${ns1}"; then
+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns1}"
+	oops_before=$(vm_dmesg_oops_count "${ns1}")
+	warn_before=$(vm_dmesg_warn_count "${ns1}")
+
+	vm_ssh "${ns1}" -- socat VSOCK-LISTEN:"${port}" STDOUT > "${outfile}" &
+	vm_wait_for_listener "${ns1}" "${port}" "vsock"
+
+	echo TEST | ip netns exec "${ns0}" \
+		socat STDIN VSOCK-CONNECT:"${VSOCK_CID}":"${port}" 2>/dev/null
+
+	vm_dmesg_check "${pidfile}" "${ns1}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+
+	result=$(cat "${outfile}")
+	rm -f "${outfile}"
+
+	if [[ "${result}" != TEST ]] && [[ "${dmesg_rc}" -eq 0 ]]; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_diff_local_vm_connect_to_local_host_fails() {
+	local oops_before warn_before
+	local ns0="local0"
+	local ns1="local1"
+	local port=12345
+	local dmesg_rc
+	local pidfile
+	local result
+	local pid
+
+	init_namespaces
+
+	log_host "Launching socat in ns ${ns1}"
+	outfile=$(mktemp)
+	ip netns exec "${ns1}" socat VSOCK-LISTEN:"${port}" STDOUT &> "${outfile}" &
+	pid=$!
+	host_wait_for_listener "${ns1}" "${port}" "vsock"
+
+	pidfile="$(create_pidfile)"
+	if ! vm_start "${pidfile}" "${ns0}"; then
+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
+		rm -f "${outfile}"
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns0}"
+	oops_before=$(vm_dmesg_oops_count "${ns0}")
+	warn_before=$(vm_dmesg_warn_count "${ns0}")
+
+	vm_ssh "${ns0}" -- \
+		bash -c "echo TEST | socat STDIN VSOCK-CONNECT:2:${port}" 2>&1 | log_guest
+
+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+	terminate_pids "${pid}"
+
+	result=$(cat "${outfile}")
+	rm -f "${outfile}"
+
+	if [[ "${result}" != TEST ]] && [[ "${dmesg_rc}" -eq 0 ]]; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+__test_loopback_two_netns() {
+	local ns0=$1
+	local ns1=$2
+	local port=12345
+	local result
+	local pid
+
+	modprobe vsock_loopback &> /dev/null || :
+
+	log_host "Launching socat in ns ${ns1}"
+	outfile=$(mktemp)
+
+	ip netns exec "${ns1}" socat VSOCK-LISTEN:"${port}" STDOUT > "${outfile}" 2>/dev/null &
+	pid=$!
+	host_wait_for_listener "${ns1}" "${port}" "vsock"
+
+	log_host "Launching socat in ns ${ns0}"
+	echo TEST | ip netns exec "${ns0}" socat STDIN VSOCK-CONNECT:1:"${port}" 2>/dev/null
+	terminate_pids "${pid}"
+
+	result=$(cat "${outfile}")
+	rm -f "${outfile}"
+
+	if [[ "${result}" == TEST ]]; then
+		return 0
+	fi
+
+	return 1
+}
+
+test_ns_diff_global_to_local_loopback_local_fails() {
+	init_namespaces
+
+	if ! __test_loopback_two_netns "global0" "local0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_diff_local_to_global_loopback_fails() {
+	init_namespaces
+
+	if ! __test_loopback_two_netns "local0" "global0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_diff_local_to_local_loopback_fails() {
+	init_namespaces
+
+	if ! __test_loopback_two_netns "local0" "local1"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_diff_global_to_global_loopback_ok() {
+	init_namespaces
+
+	if __test_loopback_two_netns "global0" "global1"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_same_local_loopback_ok() {
+	init_namespaces
+
+	if __test_loopback_two_netns "local0" "local0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_same_local_host_connect_to_local_vm_ok() {
+	local oops_before warn_before
+	local ns="local0"
+	local port=1234
+	local dmesg_rc
+	local pidfile
+	local rc
+
+	init_namespaces
+
+	pidfile="$(create_pidfile)"
+
+	if ! vm_start "${pidfile}" "${ns}"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns}"
+	oops_before=$(vm_dmesg_oops_count "${ns}")
+	warn_before=$(vm_dmesg_warn_count "${ns}")
+
+	vm_vsock_test "${ns}" "server" 2 "${TEST_GUEST_PORT}"
+	host_vsock_test "${ns}" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"
+	rc=$?
+
+	vm_dmesg_check "${pidfile}" "${ns}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+
+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_same_local_vm_connect_to_local_host_ok() {
+	local oops_before warn_before
+	local ns="local0"
+	local port=1234
+	local dmesg_rc
+	local pidfile
+	local rc
+
+	init_namespaces
+
+	pidfile="$(create_pidfile)"
+
+	if ! vm_start "${pidfile}" "${ns}"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	vm_wait_for_ssh "${ns}"
+	oops_before=$(vm_dmesg_oops_count "${ns}")
+	warn_before=$(vm_dmesg_warn_count "${ns}")
+
+	host_vsock_test "${ns}" "server" "${VSOCK_CID}" "${port}"
+	vm_vsock_test "${ns}" "10.0.2.2" 2 "${port}"
+	rc=$?
+
+	vm_dmesg_check "${pidfile}" "${ns}" "${oops_before}" "${warn_before}"
+	dmesg_rc=$?
+
+	terminate_pidfiles "${pidfile}"
+
+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
 namespaces_can_boot_same_cid() {
 	local ns0=$1
 	local ns1=$2
@@ -894,6 +1446,7 @@ fi
 check_args "${ARGS[@]}"
 check_deps
 check_vng
+check_socat
 handle_build
 
 echo "1..${#ARGS[@]}"

-- 
2.47.3


