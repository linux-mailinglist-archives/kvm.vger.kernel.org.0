Return-Path: <kvm+bounces-60916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E240C03016
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 20:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38765542829
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 18:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B713570AF;
	Thu, 23 Oct 2025 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQWhhgZy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0477D34E763
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244109; cv=none; b=gCkdv+6rs9jGFoiDJKxrGcXBuQq0I59buDPhBiLWL3oiCw4TjASNTEOPDYBUjOqKxFQpVI2R3cfL81rBaqdFnjiSYv+EAxSb8MHU/0U6vkQ6VjjYKOZodk4i0HnFHU9TC7xJfLcdmJvXu5qEBli/TvDSS/CLGi+KI6F5LwkGpmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244109; c=relaxed/simple;
	bh=nCwFeZ8diIl+Vmg31T+GDQCeQIxohZr7CtqwP+S/5mU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XGHxSWg6dn2WxoouR0EZ/Q/zW1rIEULY+hSwXsv0Gwt6wlPnz2yxeshKg7sCPC8c8SPqtzON0pqHchhnBvMP5U/2irh5Cqftv7N7R3U5ZsDgZYvjiOHON7gXAGRPKj09W4fwUHXj9LSn/l+r1CP+woSxHsa+bqh59N4JfuDrang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQWhhgZy; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b593def09e3so725103a12.2
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 11:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761244097; x=1761848897; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTSoHMa1ECvViVefFGUUb5Kl2E+j9pc5hHuWE2XXc6Y=;
        b=MQWhhgZynm0v+4efubT77xG/483p6T6H6EOO+0nw5WSVSbZrfADAiTFmdTlwEUqE2h
         gsagKmxvns59AZI2jhEZJJ1/nNT3cw+Dpo1hZRLCUwQCVeYivjTnsQOZOhC4xIHUvPtK
         yf7r/rlPFu4sA71Ww2qCeQPxQzC5owyRD166c6pTsM6u++xx+dc1YhMobKz2WN2egRBL
         gK/UInaF6f9TpQ//h/NYxyjhj8bu9QC691lZcidDCWWig13cYMcGIXGVMdSIxMVqB/E/
         6GPjL1XAJylML2z7SS58QEM0yTL8MUtR8dqg9OHC17R7UdJPbJjFpFpft5Ilh9/VQxza
         1b8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244097; x=1761848897;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTSoHMa1ECvViVefFGUUb5Kl2E+j9pc5hHuWE2XXc6Y=;
        b=YmrxaIkXJLwl6cYKlgomzqLX3gdE9gQlI7vXwRDPP2vflgOwwh9TovtcU6MGCk4yYA
         NuMyJFaHj9FxRG/7ZX12HfHtNzJz1N68AgnOLRq1o0k2xa4yQ/1uYw4kYQ9xpHV4QjqF
         x+2j+2yUvSOfIDRskuXFf0p0xwJ+v/9YryfdoNCYjSWWQiBKUs9ee0ohj07nTKOjSwDo
         G1+OI/VEqIYGPvix4xNuxukZnDY9Z1SEYxZFmrRJmowdqTIsgO4YUDBbMMqb3PX4loy/
         q5eg9w2hvTaYAPi4LoDqBY5GsJGMJ3MdJwv9xyDNYMrG/oRg/3qBDv+Zme1ixvkXncYV
         lJ/A==
X-Forwarded-Encrypted: i=1; AJvYcCW3ZNGVb/+h52KUGfr18QlGbMPPF1OA3WZN2ZLQEdQa/nm6jMUw//IJy5QpTZVQ5kHUo6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj4DzFCFFLXNEGxYWxdJN07Z8Ccdb7ZEgAaRhO/EJM3u0gOOOo
	KqcuVtudDAA/cpqesm0MmM5U777TmnaFhQ5pWys5HYvnbfDPeITWFYwz
X-Gm-Gg: ASbGnctPb++TDcawj4KYW1tzZpRU1Km0TyueD1O4sHDP2b0i/JtyKjrWVXf7z9gom+M
	BFP7HBj5MNpDHUtHLSuU2lT4K+U6a6Qimzg4AacPZ7kP+2kYW8pMSaI1qbzixhTpZ/hogky1zWE
	92vyEJl5gDxmEXn21mn3vanC79exykrCfLtGFZsBcSnUP9ge16qOuw8wLGDA5DXSRQSOJt+qJT2
	4LGfMRgon0z/6raLCYJjZ+9j5detm0ZXg/gnQe2NL9VI/yqmVPr5iQl1fE8mnAZBt/nf+CW+zmy
	v2rSjNOngJutInTiqJ83XqYo7z4IP5r2H0jkRE6bgbjaDQlRI+XC6NvrRw6s/z3+5MDyIblLhhS
	DxSA7KYqljtnkKYfsF/WwCX+qKzkQBNtywUwGjWSf9p9n/O8p/xgWQjhDnUSloz8nH1F8emwhx3
	ZWo20ZZ6M=
X-Google-Smtp-Source: AGHT+IEfA/bSltyjOG9wZ+WmbSBtdgfkQrMpjZ6PQb1xglAEmOrL+4zgNNCU9qQD5oAa9hkC0DmEfg==
X-Received: by 2002:a17:903:2884:b0:266:3098:666 with SMTP id d9443c01a7336-290ca121a21mr213942785ad.32.1761244096855;
        Thu, 23 Oct 2025 11:28:16 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946dde9880sm30458105ad.26.2025.10.23.11.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:28:16 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 23 Oct 2025 11:27:52 -0700
Subject: [PATCH net-next v8 13/14] selftests/vsock: add tests for namespace
 deletion and mode changes
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-vsock-vmtest-v8-13-dea984d02bb0@meta.com>
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

Add tests that validate vsock sockets are resilient to deleting
namespaces or changing namespace modes from global to local. The vsock
sockets should still function normally.

The function check_ns_changes_dont_break_connection() is added to re-use
the step-by-step logic of 1) setup connections, 2) do something that
would maybe break the connections, 3) check that the connections are
still ok.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 123 ++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 60d349c80153..014cecd93858 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -62,6 +62,12 @@ readonly TEST_NAMES=(
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
@@ -129,6 +135,24 @@ readonly TEST_DESCS=(
 
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
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
@@ -1143,6 +1167,105 @@ test_vm_loopback() {
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
+	pidfile=$(mktemp $PIDFILE_TEMPLATE)
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
+	sleep ${WAIT_PERIOD}
+
+	# We use a pipe here so that we can echo into the pipe instead of
+	# using socat and a unix socket file.
+	local pipefile=$(mktemp -u /tmp/vmtest_pipe_XXXX)
+	ip netns exec "${ns1}" \
+		socat PIPE:"${pipefile}" VSOCK-CONNECT:"${VSOCK_CID}":"${port}" &
+	pids+=($!)
+
+	timeout ${WAIT_PERIOD} \
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
+	timeout ${WAIT_PERIOD} \
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


