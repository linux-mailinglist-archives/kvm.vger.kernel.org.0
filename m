Return-Path: <kvm+bounces-62856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D53DC50D12
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60A2C188B029
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D512FBE02;
	Wed, 12 Nov 2025 06:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+hAUMn3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C20D2F5302
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930552; cv=none; b=MbUOLmZIrL5kETwQ2ynLW6X/Pjx5nJB/E6s8WVviulc2s9ZV00al3Oy3DgSz+eJoxESKEkwdJFuJw6v0N+qFYQfFisNN03+sqozxhSUsLWpsNXFHrJaLJmT+euZCMwfvMvv65fvaVuW1UEGFYFFs3VUTGeR/etisNueI3hU7M8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930552; c=relaxed/simple;
	bh=2x6tXKfLWbVuFVgQa4tz65Vr8N2Tjd8KuOypZPv1PZU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=asD1aJ0TPCvXUwMHHTnLx9RYam+hkTq+49Z+5o9YF3FTdtIC8oZZFAKtF+wC6ERHZIH9LnmiNMMaJ66TKvpAWqc6Fq9pVYOjE/TwrrMf21dZ2kx8cAf1V8tHVVrprrODwRYe7VpjXnN4LJL0Txi4BdmZsVLrD7wu2kJqhfJ5UTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+hAUMn3; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b98a619f020so423505a12.2
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762930548; x=1763535348; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2Aq5H/xV16rV80h2YAfjR+YfGHuS02VHlhxoZgbHhs=;
        b=d+hAUMn3x7tIXqwWshRiRF0WMqe/0gb5PyYRQyYR+LM00dducCz71vZ014Bed2NH7T
         X8UWFAb+cSf1BGaibPxunfQ/Q1Z+KU73VSiIXeimo/KHhByG8b1lYT3m08u7UlqYYW4M
         1ZVTU0hN4PQ5xy8lZmpN7CY+KZctjJ1cIG8eqVjS2FODwOG8WV5l91Dlmp8JPpfDGo9Q
         ACnQEcqCyyYHDj9yE6cPn710DzhELpaVGHA6wBWJHgcdnFFaV8qRtwE3ZMkQTkvHgZ3m
         XUuDOhfbNDg8Rktq41Nve+mzoR47thJc2jdSpUJb1FFR0ber6N4EM4ONcBz7TdryeVBN
         siKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930548; x=1763535348;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z2Aq5H/xV16rV80h2YAfjR+YfGHuS02VHlhxoZgbHhs=;
        b=OKOnE4LvROYHIkDzg7v/vp/w9Q+UXk5+o+4F33tggFjSzPHfeGseifhiHMh4e6qC32
         UoWZwLgCLm3XmJmZ97N38IfOB+UdUKJOfrYN1erg7DN223E64w3jrgzrygR5GC6jkVAh
         Pve9TFasOo6laFtM7AJITkOFROqnzCr11CYzFfGzZxclcltdnidQcRWnU0Dj8mpNo+YJ
         UjeZdYJcxnmlsULkqxLBh+WMPrfZxWLmfnXiaGtNu4zydWGcFGKZT/Macfdx2Aou7bOk
         MyZTfDmzmVmTajphGu4IURsu9qK453vRp04D3G6jbeIHMSmojXxJwIgt13Zj9GtYS0ak
         0PIg==
X-Forwarded-Encrypted: i=1; AJvYcCUbKs0bibQ5Q6PHljK/PVCDV5LTsyC7vq3bu91NcPx8tg+dls+IFUPiBTNNKNBQbBpqNJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8oC8TSqQ9gyEWy61Iw483x6gCIgh/X0CAyD4WlW2K5j41lb6m
	Q2bt9Rv4oWneE75CvZszcW1R2qLnXh0CSGyp8cNPgKyS0GAZoTphwOrt
X-Gm-Gg: ASbGncsesY/Ml0aGtFpAGmD0huOs62A1HbV3Yyneb70Sb9aW9aIwuTYOgVku3LBLl1x
	BypjfxGRqhOET2owSbeWczWBcSL+mXrXnwCEU40pYr1lKr0WZvs+s52P4imXABIvSwkVV9WO2b2
	pTMmo8ogIQJMPAklGo5M+vzrwRFVKeAw+F7fy9ZCdkOd81TK3VCm9oyRra8MXPGLQvhUvlAf/ak
	9/QTn9eDMC2iHgVJOrLRcsGc1SNcc9zf04njaZyX5GQxBjBzTLYSxl92cjUEv4AlxKy/5y2/TY6
	3TajCV4XFty9+yUMyy8etTgbGWw7T1QTLXJ/rWfiXnW5dvMkmEOyg+AhN3RStzfNv/zFXh2Mn9b
	bdgIwFmMyAYvgiCxIw30R5tsylY9e/JMGhSvbUIAUMHUpBuSuX2wnhDJSTxAlHE9lguIORBUM
X-Google-Smtp-Source: AGHT+IEaZPpXWBU5yvAAeuuj9Tkp7JSk1UFCUgBMoGGBK6v0KgdeYa3c4wyx7v7WbG4uqOJvA0o3rQ==
X-Received: by 2002:a17:90b:270e:b0:33b:c9b6:1cd with SMTP id 98e67ed59e1d1-343dde8b47fmr2468405a91.19.1762930547964;
        Tue, 11 Nov 2025 22:55:47 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccb5a517sm17168405b3a.57.2025.11.11.22.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:47 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 11 Nov 2025 22:54:56 -0800
Subject: [PATCH net-next v9 14/14] selftests/vsock: add tests for namespace
 deletion and mode changes
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vsock-vmtest-v9-14-852787a37bed@meta.com>
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

Add tests that validate vsock sockets are resilient to deleting
namespaces or changing namespace modes from global to local. The vsock
sockets should still function normally.

The function check_ns_changes_dont_break_connection() is added to re-use
the step-by-step logic of 1) setup connections, 2) do something that
would maybe break the connections, 3) check that the connections are
still ok.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v9:
- more consistent shell style
- clarify -u usage comment for pipefile
---
 tools/testing/selftests/vsock/vmtest.sh | 124 ++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 111059924287..4caa7d47f407 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -66,6 +66,12 @@ readonly TEST_NAMES=(
 	ns_same_local_loopback_ok
 	ns_same_local_host_connect_to_local_vm_ok
 	ns_same_local_vm_connect_to_local_host_ok
+	ns_mode_change_connection_continue_vm_ok
+	ns_mode_change_connection_continue_host_ok
+	ns_mode_change_connection_continue_both_ok
+	ns_delete_vm_ok
+	ns_delete_host_ok
+	ns_delete_both_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -135,6 +141,24 @@ readonly TEST_DESCS=(
 
 	# ns_same_local_vm_connect_to_local_host_ok
 	"Run vsock_test client in VM in a local ns with server in same ns."
+
+	# ns_mode_change_connection_continue_vm_ok
+	"Check that changing NS mode of VM namespace from global to local after a connection is established doesn't break the connection"
+
+	# ns_mode_change_connection_continue_host_ok
+	"Check that changing NS mode of host namespace from global to local after a connection is established doesn't break the connection"
+
+	# ns_mode_change_connection_continue_both_ok
+	"Check that changing NS mode of host and VM namespaces from global to local after a connection is established doesn't break the connection"
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
@@ -1172,6 +1196,106 @@ test_ns_vm_local_mode_rejected() {
 	return "${KSFT_PASS}"
 }
 
+check_ns_changes_dont_break_connection() {
+	local ns0="global0"
+	local ns1="global1"
+	local port=12345
+	local pidfile
+	local outfile
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
+
+	# wait_for_listener() does not work for vsock because vsock does not
+	# export socket state to /proc/net/. Instead, we have no choice but to
+	# sleep for some hardcoded time.
+	sleep "${WAIT_PERIOD}"
+
+	# We use a pipe here so that we can echo into the pipe instead of using
+	# socat and a unix socket file. We just need a name for the pipe (not a
+	# regular file) so use -u.
+	local pipefile=$(mktemp -u /tmp/vmtest_pipe_XXXX)
+	ip netns exec "${ns1}" \
+		socat PIPE:"${pipefile}" VSOCK-CONNECT:"${VSOCK_CID}":"${port}" &
+	pids+=($!)
+
+	timeout "${WAIT_PERIOD}" \
+		bash -c 'while [[ ! -e '"${pipefile}"' ]]; do sleep 1; done; exit 0'
+
+	if [[ $2 == "delete" ]]; then
+		if [[ "$1" == "vm" ]]; then
+			ip netns del "${ns0}"
+		elif [[ "$1" == "host" ]]; then
+			ip netns del "${ns1}"
+		elif [[ "$1" == "both" ]]; then
+			ip netns del "${ns0}"
+			ip netns del "${ns1}"
+		fi
+	elif [[ $2 == "change_mode" ]]; then
+		if [[ "$1" == "vm" ]]; then
+			ns_set_mode "${ns0}" "local"
+		elif [[ "$1" == "host" ]]; then
+			ns_set_mode "${ns1}" "local"
+		elif [[ "$1" == "both" ]]; then
+			ns_set_mode "${ns0}" "local"
+			ns_set_mode "${ns1}" "local"
+		fi
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
+	rm -f "${outfile}"
+
+	return "${rc}"
+}
+
+test_ns_mode_change_connection_continue_vm_ok() {
+	check_ns_changes_dont_break_connection "vm" "change_mode"
+}
+
+test_ns_mode_change_connection_continue_host_ok() {
+	check_ns_changes_dont_break_connection "host" "change_mode"
+}
+
+test_ns_mode_change_connection_continue_both_ok() {
+	check_ns_changes_dont_break_connection "both" "change_mode"
+}
+
+test_ns_delete_vm_ok() {
+	check_ns_changes_dont_break_connection "vm" "delete"
+}
+
+test_ns_delete_host_ok() {
+	check_ns_changes_dont_break_connection "host" "delete"
+}
+
+test_ns_delete_both_ok() {
+	check_ns_changes_dont_break_connection "both" "delete"
+}
+
 shared_vm_test() {
 	local tname
 

-- 
2.47.3


