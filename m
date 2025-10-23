Return-Path: <kvm+bounces-60912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82118C02FD4
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 20:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73B2F1A07093
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 18:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FC93563D9;
	Thu, 23 Oct 2025 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tge3NCLR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A7234C155
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 18:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244101; cv=none; b=gMJ34eC/C9rHsNCzJJb8IGuVYwi9wrOvRAVXkflAbLxd8kWw5tejjdLhoRWvLEZGxDyv0Ap3FB6BcBkhMJVUNmsid4h9atH0K71wiv5uNK26jRGjnHHMFaOPHnO6dWYtnNgVogMHqtKaKkjRWr2kNuRvSBdHynDPhmNnQIER+Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244101; c=relaxed/simple;
	bh=kQBee9DoWSc6883yGLsxi//tyX5HHzjIliVS8SZbc0w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KInOSo6ParJU2OUjEa+Y/rnxIff15cAbM4pg68NbPK8WSDg4Drl+kIlva5djeFxudf95ZuphqLeDxAZBQeKo5/Ul94W0UdIv0y9l6m6W8DCmF07LAe3T1yiSezyUL3P0WAZ1uHGxwARsXiW6AgttZsQ6XjY38HZWoOPQtj9wAu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tge3NCLR; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso796737a12.3
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 11:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761244094; x=1761848894; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ukvtIuA2GTbBdDn1KeFlCInIvIk5c30LHz1pGa2sbYQ=;
        b=Tge3NCLRtkzCQ+jCqUZQOyaNp+loo8/G+rXlppiyrkJsyLa3KmOjBPaeOVTE777T3w
         Ian3aCFII+IIdvkwSFHutd5pRjp1idCDfDfM6a669EwCOjisrLkfjMJnih0JtyyhYSAN
         lR8i/fsQ+b0FPhI+GvEjS8GI919qut77AfSO8u/i/XAzmJ6EPIbc9nALDhziOD02CV6E
         Fv7Sda1NjdbCmCxeRMqY2QHOfteR8llI6n9lOrPdABjyto52cQskLHLEkt0QcBG732DR
         GujtI/ZrAn2yfqc2wJ7XIxspzgXDfJmu8nsUw4AYd6eTqZbSfNwEDYWKPASxs0ttuWPu
         S8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244094; x=1761848894;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukvtIuA2GTbBdDn1KeFlCInIvIk5c30LHz1pGa2sbYQ=;
        b=LJ/fCnGuOlXnv9moo+wZVj42uF45esVJtt4j1cLBVwMAlcWHNAYvUIYQ8+BagDYbOT
         B9D/y3B0TIj4I0R5w+FSwrKW0HfbtuW8rIwU8IxT+hZjF7+IV6V/qNl3S9bsbJhtuLnQ
         CE5ce9/K0q6+9jg02jxdJEtkBJvjNR9WmLPNpIBPovdVvc16MMSLkoKUFv+BBpzuC4mg
         G+i3F26jPdpKlerSLoT+RqGUzpOx+HggpuHA5k/LEfi6IEtctRoUmRALcSJJCgNRZRxa
         hHxq8KDA5ZzliSge9VG//K5S8I7QOiKfuBDhctjZcsKyUbhbc2JeDEEsj0Yd0fCr2dIs
         YRhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrtg0RW29zH0iE5BaP+P32M2GdmvswAlBoPr5X3HTXCt3CUhnvp0MNboYC+85/OtPV28c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7F/CbWzx3uAPeM4DqwBvHMUsSTPmvh2auD0mypGsn5U2k0FkR
	9MawyacTRbidwXZDISBzc6JrtlucMO6s6Iad9wqYTFanmryQNvHBpDH3
X-Gm-Gg: ASbGnct//a9uqmmGAdVXqlqsxNSzSr2gg4fI3gkOHmvu07qT4q9ieQurEjOOBvmbhgc
	+d61Tx2QgyM+o2gq4FKQLV4MO43IhRP2tLbu8rKRdqHiz5JGuRu2m+4es7cImxowvY0Hubzwp/D
	uijS58/Nuf9BmfPxrmEiWamXa7T2y/1ci/eMPF6VPEnbphzIBucCzqt1hTmKq+WkK/nLkRr2sa3
	/u3CXwBmwvlA1SRMajQx1PRlV/ZBGQivkI3vXoyNglZia+q2V6m12ZrgGQsenBwoo8mrqvtFcVf
	0sNOwG/eNxgzkDY6jHkKWhifiSaAamr5FBXwIj35ZaA9Nf+kPLlqqanuZBsxhsFcq2EieQLeeMp
	ZpA8KjWCYycx3fwyfHHBFlD/DfTbG/VO3K3hamiesAadAuHyDQkoM/NgVlHWw2OFE/pURdYkYDt
	WHm+pJd3/OBB5KTXxxyKc=
X-Google-Smtp-Source: AGHT+IGZ1uFbSH3kISIMtcXAT6m/nUhLcNZeEGyE8hNSy9KW4xwjRKfbKytlo0lhRW4rLAUXnaGm1g==
X-Received: by 2002:a17:902:f605:b0:26e:62c9:1cc4 with SMTP id d9443c01a7336-290c9c89da2mr279808105ad.4.1761244093791;
        Thu, 23 Oct 2025 11:28:13 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:40::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946de03081sm30876635ad.43.2025.10.23.11.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:28:13 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 23 Oct 2025 11:27:49 -0700
Subject: [PATCH net-next v8 10/14] selftests/vsock: add tests for proc sys
 vsock ns_mode
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-vsock-vmtest-v8-10-dea984d02bb0@meta.com>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
In-Reply-To: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
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

This patch is the first to add tests that do *not* re-use the same
shared VM. For that reason, it adds a run_tests() function to run these
tests and filter out the shared VM tests.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 99 ++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index d047f6d27df4..b775fb0cd4ed 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -38,11 +38,28 @@ readonly KERNEL_CMDLINE="\
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
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
@@ -203,6 +220,20 @@ check_deps() {
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
@@ -502,6 +533,43 @@ log_guest() {
 	LOG_PREFIX=guest log $@
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
@@ -575,6 +643,11 @@ run_shared_vm_tests() {
 			continue
 		fi
 
+		if ! check_netns "${arg}"; then
+			check_result "${KSFT_SKIP}"
+			continue
+		fi
+
 		run_shared_vm_test "${arg}"
 		check_result $?
 	done
@@ -628,6 +701,28 @@ run_shared_vm_test() {
 	return "${rc}"
 }
 
+run_tests() {
+	for arg in "${ARGS[@]}"; do
+		if shared_vm_test "${arg}"; then
+			continue
+		fi
+
+		if ! check_netns "${arg}"; then
+			check_result "${KSFT_SKIP}"
+			continue
+		fi
+
+		add_namespaces
+
+		name=$(echo "${arg}" | awk '{ print $1 }')
+		log_host "Executing test_${name}"
+		eval test_"${name}"
+		check_result $?
+
+		del_namespaces
+	done
+}
+
 BUILD=0
 QEMU="qemu-system-$(uname -m)"
 
@@ -671,6 +766,8 @@ if shared_vm_tests_requested "${ARGS[@]}"; then
 	terminate_pidfiles "${pidfile}"
 fi
 
+run_tests "${ARGS[@]}"
+
 echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
 echo "Log: ${LOG}"
 

-- 
2.47.3


