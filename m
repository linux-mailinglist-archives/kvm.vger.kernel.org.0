Return-Path: <kvm+bounces-64850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F3FC8D3C7
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9C19D34C424
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808B332C336;
	Thu, 27 Nov 2025 07:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eYchrPpl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4BC328253
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229682; cv=none; b=GwcE28fgBsJyUNPwZrXA2i7IAtSg68wacXXki9Z/NsPm1IKuerXSB+erj4QG/o9wz71eqq/Sw1fSiF2/3E/XWehEjF1MY4/1Z834xOcleTUPu3gB5OIhUWEd6HLCaqDEt+0h3JwPEZNDBsFHbAinw3yI4FA/TJrXCF4RHcbbfdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229682; c=relaxed/simple;
	bh=/Awk+ZNAUSYj37xQmP8u5lLIpYhs6f3jnk3Fa/B/6hw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GenWWuU0V1XiSu5TEjnAxyv3TC0Y37WWR7p4y/BNFP3NSNzAiL6mfJVA1cZyd7CTMRUnlaSRFsLuwB+uO55wNWTJgFOakOl2iYBHmsxmrEID4+mvlAbacHxgXlqAT9uFUxQEjwH0Xn9Tf0i73Z+OAjHIouaDxCwnWN+skCieWEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eYchrPpl; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297d4a56f97so8825585ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764229674; x=1764834474; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwxY3RrBqHReoCCTc0CExP42GtobWyxbXrcCgf7a+Ec=;
        b=eYchrPplPehlVONV2tShm8syxQbikMDbK31X02qr1WFUKIamsItRPtI1KoJAMlc+WK
         7hhzsked/rE8gwmwya2BNTeLRguSm5P4ImkNaSpJVXSuVVTzC4K83TlhFwtGtAnkcUSu
         KR6GbGGdsG4BTCLNMEXJv6bm3TxC/ll1u7RtDkI0FL3LzOJtJoDs/na1zCutCzGiM7o7
         W4mzH2UoC+esSVmi5JGiCIPtS+krXRcdby0KC/3iG3wdQ8kvcyuFDqdjSFAVJQuPnV/v
         NVk11bWY2PFyMOivvcFx4xKmGJaVMcFDDVQMqd7IYNwgePqkKdngzobjcTWUgH7/OQGw
         Uv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764229674; x=1764834474;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mwxY3RrBqHReoCCTc0CExP42GtobWyxbXrcCgf7a+Ec=;
        b=GM1VlesIWlmf4CGWjld4kijBygu9S2YaQ0+B+X/Gg4PR538E2o4rn4uCF1mTqtFfy7
         l4wRIr5xSTIKqYkbUW3puCpWa3RcQcKvTkwhRg/wcdoisCcF0LS/BI4oOC/jWSnq/3Jh
         +cs+5ltxMo6qlq01tljwmstCm+X4GwLoQetckI3Sou6GMlhIqDVjlfltFc/1huVfbntw
         OUwjqYdGkcfUHxeo6vQHZyZBWt7p5Yn9TwB0MNB4SQWu38BWEGAvqtuXuw0oXoWX8mTd
         6WNt55e1SEJSlRkxAHkKtwThZXDPWLMqYC9L3bNw3dbAow4vq6A/2nQ7N40tJmRs8G5i
         zkww==
X-Forwarded-Encrypted: i=1; AJvYcCWAcTz6w0VwCa4Ah4lErXb2xJ/Q2cejgNDe+6L7k51KHDsZoFLqqjb32nk9ortvJF/c0Hw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3ryIS4AqNa8HX50tHTzNtdursZ1Hm07LlCb4ybWhp6iayAEgT
	/uuuKt+hLvs4qmg5ACoZzVAKP6GjWRZ6CDmaH+1FrxnUNzZ72ezTQBhh
X-Gm-Gg: ASbGncuppnqLN0S4zEW4BF4Tyiu3aXuhEOA3xiIAZxGwgDOxSSKvTT2zJo+nBvrW0Ao
	P3H/3oN5vmyOlfdzqy55qECk13EPp/FrBee7nPWQFgqOgMLUK2LKIGVAVG2lALORzjLT5UF7nZk
	Ax++bGd0813t1pg0J6ju/m20ATNFzBayqxwXlpt1O/pC/uEgUAfPwNFaoYRYvK6GIAFRR/qcWNO
	xfdRVwNMPVlTbyTopMQMHjqrC1uNxbzF8AVi8C9BzHpw8bdTct24Fp/ZOwm2/e1sjgEdw5IsF/4
	Pnis0YJOBXRthRgaQ5j38CBVQUdeLN8eet6LobYnC5mkNjJO2yaC6VqfAWhMeOHgfX5EA9KB0ER
	pv7FoWqhZHgBJ3pgGLAvCL+qSnPaF2lu9yZILrWWzY8zk8ZlVbDGh4BBiUlaqO83Ag44fHZNIHe
	9QfS5Xmmefwwfri0cDVLa9
X-Google-Smtp-Source: AGHT+IHIlqze70ddD15adUvv30WNku5JRlVK0eu6g7d4TW5+OfNZ6dSJWF3hfK+35WHjCJXw8EQ6FQ==
X-Received: by 2002:a17:903:b86:b0:295:4d97:8503 with SMTP id d9443c01a7336-29b6c575180mr257859795ad.30.1764229674412;
        Wed, 26 Nov 2025 23:47:54 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce477e94sm8648415ad.43.2025.11.26.23.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 23:47:54 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 26 Nov 2025 23:47:41 -0800
Subject: [PATCH net-next v12 12/12] selftests/vsock: add tests for
 namespace deletion and mode changes
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-vsock-vmtest-v12-12-257ee21cd5de@meta.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
In-Reply-To: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
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

Add tests that validate vsock sockets are resilient to deleting
namespaces or changing namespace modes from global to local. The vsock
sockets should still function normally.

The function check_ns_changes_dont_break_connection() is added to re-use
the step-by-step logic of 1) setup connections, 2) do something that
would maybe break the connections, 3) check that the connections are
still ok.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- remove pipefile (Stefano)

Changes in v9:
- more consistent shell style
- clarify -u usage comment for pipefile
---
 tools/testing/selftests/vsock/vmtest.sh | 119 ++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index da9198dc8ab5..a903a0bf66c4 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -68,6 +68,12 @@ readonly TEST_NAMES=(
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
@@ -1274,6 +1298,101 @@ test_vm_loopback() {
 	return "${KSFT_PASS}"
 }
 
+check_ns_changes_dont_break_connection() {
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
+	rm -f "${outfile}" "${pipefile}"
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


