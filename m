Return-Path: <kvm+bounces-68407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2004D38868
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8838F302CC6B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B910314D21;
	Fri, 16 Jan 2026 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CN+ICmwO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960713933FE
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768598959; cv=none; b=HlCHVbIVc7nwtuVWdXVWOlUBuZeDnNMb+FpLmVzsqziUd7c5z8gGlpJ9Iv84wrzv9f3eWcITIoVJdp+J7m99C5r22rnEiYqYgHKmblLIYvX8AOqFWgydCWQFan7Kuu+UcLNpHGAPSRw5zHWLCr28K3aCYzjweWOszk+gkXHeN7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768598959; c=relaxed/simple;
	bh=JAQQN7P77tr97fU7vyuVMrvCiNP4sSFAq43cZhTlmi0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XFGqz7B5FjkavF5I/UciCvgBWMxs7mBX/HUxFPim/0MemiXVfU73iUZom/i41lpDyOg8oUJcXQvYVJECVaLyrm+U6k5cenOfbeaP+5iPKlipEh4hPhuWogb06egDySBWpMe+WASVjyQEHV7wGXevNu1/MOwyGOpAozz3UyWKSiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CN+ICmwO; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7927261a3acso24617117b3.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768598954; x=1769203754; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mpdsMRuLW1cRrssyJH9GNY+tfbuaJ3H6voxC/Fdtqg=;
        b=CN+ICmwOOFDAWqLFXVe+ehEYsYDe98ZwRORTNMXXMYcxmuarAT0xWcWw/OCPblOyMw
         taj9HLX0kv/8r2lXtWWsZhjtOvMnUTzlj05hcIi3AqK3dt7Iyb2xvgUY7f4Iw1yym/DL
         AqIDdsUH0+04vM6xp9JE36eCT7E5yHMIYOSFHs9XJnXNj//5v/rgy33OheR2In9uPe2j
         d5vZpszV0S+3xe5EiATdWudw3TyvoVc0N+OkL8UABr4wKc5lv43fCnk4wbgTGIDp5dNu
         QKs6xhR5DFyz3VIPILYqjKKqJ1q0KoK9YcxlM0Ym/cnveXwEWugCcmDBtzEyl5UzkELw
         Vppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768598954; x=1769203754;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2mpdsMRuLW1cRrssyJH9GNY+tfbuaJ3H6voxC/Fdtqg=;
        b=g43JxqKYYWQ27DxCZ2xsgXdKdyjHOvLubrK2Ei8YSissa4CGQ1pHZduNgmxoRN+YHH
         Ocqh1EEm3VhzxKewzeyq5mAAEDBnkQWMuvZtUw9ZtKf2fghFmZ4LZXMC3cLcYckTAIh5
         t56VJMwnf+sGqKVdcAof+NMjnE48mO6aKxozFE/H2jhXoSx5dHXL9UoU4hWf9/18oySg
         hXSpaGtjCxLpIJitbL3smoMaFxiuoc1oiOl81jtLjdD2eKiWhVd7Hwc03cmJK0YIZpC0
         shPXxCEWSu+WNuJMtcL+CuSkkqXS/dDuURekR7Mh/AeGqJFfKatopYgWhwW811W4TR/V
         rGwg==
X-Forwarded-Encrypted: i=1; AJvYcCW6p7Vjj6OV7iOzA2hWnjZ1P5s5J5Xmf9BDZAFnbz7KxGMBR627AMozHXkacU2wKSxJKQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKcd8wMMRgHiV16wFkHz/zlvFiYQWAzyriJnZjHybe8W5CxmhT
	aKXhr7VDf8bVrDUTrjDO2vm+l4kqMqlyKi/AIJwFLKthC8OrvEOzyWqCDWoE2Q==
X-Gm-Gg: AY/fxX5hnleWZo0J6n8fkA82pOhuZG/KJ393ZaD941ayIO4dgMeW3EUw3Mm4/yDQYD9
	h5NQPIRELgdvaWKihcBd5CuEAVo1M5I96Cag/Voy//eEuu7jOTQ8HIi+tueLq4W/bHj5/wO/RUI
	2QoHigQMjklSaeW1Qo69YGeB9D6kDdPNtd0q/OHrFVBI4ipFgihLxLdW9aLi+0eW3k3AbGpZA7S
	1x5QXwwOKCsehlAB4DVd4ZATdC7KHSEw1OLxgBtCi539GYYyIDwdhL14IIjSHXvv19eb+g8hpeq
	PU+K9HDFqNu3Ves03R7Qg+8QVHgTCNq3mwOv9ooTDDYun/GJrWuR7lC0JnK9HwoLdve+zN7CBDq
	acHCJaFc1h+0U8Nz6lQxJHMFxWG1P4/lCGIaaJIZTTTYZ5bv6O/EuriAcx3bMMYwUr5qzOCKdFe
	EWGhPxdBRu6fD1WCmJU3S6
X-Received: by 2002:a05:690c:7010:b0:78c:6ae6:3c7c with SMTP id 00721157ae682-793c6824cf7mr29133577b3.48.1768598953565;
        Fri, 16 Jan 2026 13:29:13 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68ceebfsm13175697b3.56.2026.01.16.13.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 13:29:13 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Fri, 16 Jan 2026 13:28:52 -0800
Subject: [PATCH net-next v15 12/12] selftests/vsock: add tests for
 namespace deletion
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-vsock-vmtest-v15-12-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
In-Reply-To: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add tests that validate vsock sockets are resilient to deleting
namespaces. The vsock sockets should still function normally.

The function check_ns_delete_doesnt_break_connection() is added to
re-use the step-by-step logic of 1) setup connections, 2) delete ns,
3) check that the connections are still ok.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v13:
- remove tests that change the mode after socket creation (this is not
  supported behavior now and the immutability property is tested in other
  tests)
- remove "change_mode" behavior of
  check_ns_changes_dont_break_connection() and rename to
  check_ns_delete_doesnt_break_connection() because we only need to test
  namespace deletion (other tests confirm that the mode cannot change)

Changes in v11:
- remove pipefile (Stefano)

Changes in v9:
- more consistent shell style
- clarify -u usage comment for pipefile
---
 tools/testing/selftests/vsock/vmtest.sh | 84 +++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index a9eaf37bc31b..dc8dbe74a6d0 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -68,6 +68,9 @@ readonly TEST_NAMES=(
 	ns_same_local_loopback_ok
 	ns_same_local_host_connect_to_local_vm_ok
 	ns_same_local_vm_connect_to_local_host_ok
+	ns_delete_vm_ok
+	ns_delete_host_ok
+	ns_delete_both_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -135,6 +138,15 @@ readonly TEST_DESCS=(
 
 	# ns_same_local_vm_connect_to_local_host_ok
 	"Run vsock_test client in VM in a local ns with server in same ns."
+
+	# ns_delete_vm_ok
+	"Check that deleting the VM's namespace does not break the socket connection"
+
+	# ns_delete_host_ok
+	"Check that deleting the host's namespace does not break the socket connection"
+
+	# ns_delete_both_ok
+	"Check that deleting the VM and host's namespaces does not break the socket connection"
 )
 
 readonly USE_SHARED_VM=(
@@ -1287,6 +1299,78 @@ test_vm_loopback() {
 	return "${KSFT_PASS}"
 }
 
+check_ns_delete_doesnt_break_connection() {
+	local pipefile pidfile outfile
+	local ns0="global0"
+	local ns1="global1"
+	local port=12345
+	local pids=()
+	local rc=0
+
+	init_namespaces
+
+	pidfile="$(create_pidfile)"
+	if ! vm_start "${pidfile}" "${ns0}"; then
+		return "${KSFT_FAIL}"
+	fi
+	vm_wait_for_ssh "${ns0}"
+
+	outfile=$(mktemp)
+	vm_ssh "${ns0}" -- \
+		socat VSOCK-LISTEN:"${port}",fork STDOUT > "${outfile}" 2>/dev/null &
+	pids+=($!)
+	vm_wait_for_listener "${ns0}" "${port}" "vsock"
+
+	# We use a pipe here so that we can echo into the pipe instead of using
+	# socat and a unix socket file. We just need a name for the pipe (not a
+	# regular file) so use -u.
+	pipefile=$(mktemp -u /tmp/vmtest_pipe_XXXX)
+	ip netns exec "${ns1}" \
+		socat PIPE:"${pipefile}" VSOCK-CONNECT:"${VSOCK_CID}":"${port}" &
+	pids+=($!)
+
+	timeout "${WAIT_PERIOD}" \
+		bash -c 'while [[ ! -e '"${pipefile}"' ]]; do sleep 1; done; exit 0'
+
+	if [[ "$1" == "vm" ]]; then
+		ip netns del "${ns0}"
+	elif [[ "$1" == "host" ]]; then
+		ip netns del "${ns1}"
+	elif [[ "$1" == "both" ]]; then
+		ip netns del "${ns0}"
+		ip netns del "${ns1}"
+	fi
+
+	echo "TEST" > "${pipefile}"
+
+	timeout "${WAIT_PERIOD}" \
+		bash -c 'while [[ ! -s '"${outfile}"' ]]; do sleep 1; done; exit 0'
+
+	if grep -q "TEST" "${outfile}"; then
+		rc="${KSFT_PASS}"
+	else
+		rc="${KSFT_FAIL}"
+	fi
+
+	terminate_pidfiles "${pidfile}"
+	terminate_pids "${pids[@]}"
+	rm -f "${outfile}" "${pipefile}"
+
+	return "${rc}"
+}
+
+test_ns_delete_vm_ok() {
+	check_ns_delete_doesnt_break_connection "vm"
+}
+
+test_ns_delete_host_ok() {
+	check_ns_delete_doesnt_break_connection "host"
+}
+
+test_ns_delete_both_ok() {
+	check_ns_delete_doesnt_break_connection "both"
+}
+
 shared_vm_test() {
 	local tname
 

-- 
2.47.3


