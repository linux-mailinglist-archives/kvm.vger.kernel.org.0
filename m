Return-Path: <kvm+bounces-67903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 078D7D16761
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:18:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F3BD43088F96
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A2034EF19;
	Tue, 13 Jan 2026 03:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pc15XxkF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF0343D7D
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 03:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273993; cv=none; b=P9wwFkv38UH04otRymjokxLFkMovSahDFNaCo37hZcS+y6sVOYkjZ6jewVzEw3co5xiY2UQvz2ySnzsiM8d4XaQyi5dJjzLioTQkoUAeqP0n7dGUyvVtH9WmAgjZv7xGaszCMUULHc6my72KDDg+LLYh2lye0ezplGdx/2fq9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273993; c=relaxed/simple;
	bh=ucIpPosqEiSMdZEyChVr+4AmgFcQlUgInXBmbAzH57o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uawb/bX67HqQ4RlIUYAD9ZRnUW3b/ClMduJvc9lFQRHOKeaV+jVSb29OYf5yktGvxGu9smvsDwNzVIUKgLkehMTMd0thxAkQXURXTHPVDTNUf5rLCS7Vde+d6ULn9WxOf8ICRo3N4q/gXKBn9mc0zRd9us80IrhdZg4h84Tcojs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pc15XxkF; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7927416137dso24959057b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768273989; x=1768878789; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sNxNvDBVFHGq590i7LC9o7diq8A3tmTtfQIAa+Qj48w=;
        b=Pc15XxkFuIgmkzJk0nQI03ppxFeebCl1yWWZPREcIWMCrGph7MnJYqnP6PjbEaIRSn
         hDxVt4FL7Lctv0ynFiiAiGUq7VYa1iXNsrAWnaW2jMIDtdcYzB0K/DJBRXNstfHUMP/6
         2NFtG4dD/ONBgee7WeeIPml3pz1UKjJd8SjtFT411cCqQq7yZ3FpN3lP6ve/873JhsAX
         H78fTHysTLPKS+TLyxlmZE5de94Z6Dgq9B6vhv8HLXO0OyzyhUpVrvDq+ussj59q3EL5
         Pe3w8AG771Sj6TC4IA5kPtS0TwDCL8nDgi7Zhamzd76eNtKs9k7FX5nfguseNC/sp7M+
         Z20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768273989; x=1768878789;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sNxNvDBVFHGq590i7LC9o7diq8A3tmTtfQIAa+Qj48w=;
        b=SRgi005JFZT9xFoWvxdjqsHTDNZyrnzShpZbqKA0kEg10BmZNq6BA5kVqyydw7t3SH
         V/DrcMUGdWndNJaOn+plAXSDWpzTe95HAFZET87pSAtKGQwzh6rogse/hunjflWu9QNN
         h6Vi744Gebpc69i8e16jDXdfmVNTZjAMVoW037g7udfm7cfk4U+Fx5mc/D5hA+uxBdC9
         jy7k1jXd7L4x09WyhaOGI422cCUgyZXRM7fUrm6TEuKm7k+JKPQtGNV7PM2OZ+x5703A
         84SlpBPsVJ13aVASDVmbUqbhyIdBoxVY6eRQ1blD1TJrQf5KRMeIiuoLTRJt5z7+lb1u
         Qdaw==
X-Forwarded-Encrypted: i=1; AJvYcCVRhtZRC6zTIS5V05tnUxJ5iUXWgrQAs76Ftwl6BkaDTYBkSsxmHRvpZwzBoiT8GeL8Y0U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj+RgRY4rJiBD84K7gfqruB3YFLE7CvloOoWKH51vJY1nvwB04
	m5N8/P6SkopliTAoAa+g025lYJHAGbQTD0gdtNvv9wdSrgFSQJZpoUnh
X-Gm-Gg: AY/fxX4yUbFBbUiX76+Fzdw06suFlS1Hr2vxS5m2UwlbSndws1+gG3HbkOnyzQsE4HJ
	q6sJMIhN78/+mOOV6OkdrHYFnonLyx3Yjf5aE9rIZEd7N5UtuhD1PsfhvYxPx0Qnr36xNTgrd7G
	p1BPZcBu6nQVFyuA4qJE+r91gjxOQ91KmPhjo45/waAHl2fFMayI+b/3Kqp5/sLETYt7ggv7Vvw
	zVsSOOiImodSQ+xaEKbDqCFm/N7ZNZTS6Yt3250m/FpwhBROSJ3AzjSAZXGNRFbdb0osKPo0xuu
	AkA9mXqhcD1BMLcW5MXxTP8LTZCnmH+mOhnHzFK0A7Hni3FdftNplTqpPx4xyG35tmMvd7P6PBD
	KC5gH1ORwqsvcpX5rwioN8us8z0y5MozgFfu6lgoy8Pha4px3Az4yRGE7FngEl17OwOweNcanKU
	YZFyCoYOE2Aw==
X-Google-Smtp-Source: AGHT+IHajBIIB3lFDpmb/+cpRXnIk1X1l4rqHdpMk0OXknIIotsd4BlSh7ibgscjI2PVi5aqIdrNJw==
X-Received: by 2002:a53:a342:0:b0:635:4ecd:5fcc with SMTP id 956f58d0204a3-64716bd78c2mr12639723d50.41.1768273988637;
        Mon, 12 Jan 2026 19:13:08 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7916d0c3f72sm49160677b3.21.2026.01.12.19.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:13:08 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 12 Jan 2026 19:11:21 -0800
Subject: [PATCH net-next v14 12/12] selftests/vsock: add tests for
 namespace deletion
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-vsock-vmtest-v14-12-a5c332db3e2b@meta.com>
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

Add tests that validate vsock sockets are resilient to deleting
namespaces. The vsock sockets should still function normally.

The function check_ns_delete_doesnt_break_connection() is added to
re-use the step-by-step logic of 1) setup connections, 2) delete ns,
3) check that the connections are still ok.

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


