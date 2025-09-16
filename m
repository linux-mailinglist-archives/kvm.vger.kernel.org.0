Return-Path: <kvm+bounces-57809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1927B7ED45
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7F4A7A57F5
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A7C2FB60A;
	Tue, 16 Sep 2025 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUUdTCKi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7212D46B1
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066247; cv=none; b=HGE1z3dVVQlAjSaBgvPeAR72Ewem/VwgjTTUJUpIQLs9bMMaMXgIpz4emsfmuzzR7vsCFHyPEeh0xOwoI5oO2xMEnwemWgbqkIhPsiQJGGvQ0HgXVoxrwDPPWlvs9TiFc39HX4HNqtRrSNqiendDj4KAw633uMOOaF97fj8zVZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066247; c=relaxed/simple;
	bh=BquwX6HjvEBxZ0NOdjFPMl3JAQrw/BuuZkbNRV5kNDE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kVP6KIxghHx5faePxAHbkRtjMLFZkYmIf7yB+Ret8wQzCJ2Pkkj/y4abzEpDW8+n81uP1t7quK10Wsjps7z5NSL8PrATPT4VEH6cSIHPn4klTeVjzYZLusMJx0IxiMy1j5ji6+qBOtVsiQUqGsZGNJLbo/kQKBH7wHpcuY6hJeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUUdTCKi; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b54a8c2eb5cso4795052a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066244; x=1758671044; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YyzkIGkPcN4s/5n8XbmWu5wXR7Mhh7fBZ/cTvP3v7E=;
        b=LUUdTCKiJEesPFtxzdNKrPM08t1j59Bcax7x4SDqh4xmTZmyGrfbEk1qUoqBRQEJ/1
         7/gDLyv9CMlZm2vtGAwphO758G/U8jiFfcBwqCNn31ovEDG9dcbqFO0LOWppOXyZxPcF
         gJFNaJOJxb9k6gN+pGsZQ49eHDCgQLwDSAHZspxGIxba9iNI67O/gYL0QMeeRu2zPtpu
         1lWKBbzhN04XsC3z/KcMCPTUjy38A2MvV/2UEujcZ3zVhaNtoeDB5GS9ahxmI+gpjjRa
         loGMFHCj/HBz5p1NA60rUdPixe3ujO3iicy3P6nNS3XJ45X3+0dNyacUiSjfCJMurvYR
         RlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066244; x=1758671044;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YyzkIGkPcN4s/5n8XbmWu5wXR7Mhh7fBZ/cTvP3v7E=;
        b=oOasy3++TdUJ5ns/mSDqkzc4SdTvH+YTMpTwvLYODKB8uffvLkkRv/oV+tUknvSUQD
         5fCNz1olOIrnA+4JccOCdU8yNsyN01NTHz2V0QzAe2JMX4sYIucOogE2drRIdue5MqNm
         PDVnhKLt35X+s7YUvHoV+YoyQ3ng8gY/iTgovZHKjeZtPna/DQFU9tR3pe7ekgn6BP+O
         121bIh0lKzxd0rluHmD9+j0yPDN2puUoSAdTzZRKDCrq9UtY1x1jP8+Es6E/mcakW6Ux
         pLN9qsIhsSgeu4vb3HjhgsOyj/o+3wX/8zHoFs0QmdVEBmGoxOc1XQfgmHxThPmbDpVj
         7rNg==
X-Forwarded-Encrypted: i=1; AJvYcCW7suJpJ1MfIziQxdisXq4tvLND4Mjn8KFmHNytTCVzli/kKWUJiYaZiTDix5Hds+FFvbI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuvF9V/mcxPGRInHbP1lKffP+lhWjseTW5emMLFXpRUMIKKMpg
	mVOIcyYOoQpdrmkk9SWWijG8cNbunDkmnvINGg9KdKMySTVrfvBZK6sg
X-Gm-Gg: ASbGncuj6PGu2/lvfZYU68YdTeKMWOJrkX93q2Ef9A3cXfzOc+0KnrfgSP84gyjbd28
	UUkcBnyzTGnn1MkftTwgBWHKnk/VU/lsGTxXL5z8AWXEygzSDh12PXbvk+TCY9EMdd6YrtXh5Ql
	/Pt+ZKGZKNKg4zyU7uNV6TNLNB4JDJhHb9fpkrVFW3gO3csR3vyCAbuYbC2cKTu/9meUopLYSKE
	eFAk5Hs27flfyUkPe3KKTWMipAu7DvA6nhtuBUQJIsEsYez3VmGkc+ixElsE6Dm+/T6EP/Ii6O5
	TE/MZMXib5zKWwbX8g/CDsyL8V3WU2fHsBti1n8r2xUUkwUwDTBMpRmcMn6E6mmF3LYh0xdSRHc
	nkGYxPoLfJbz3mcGR3mJpgnbOns2ZXw==
X-Google-Smtp-Source: AGHT+IGM0BGroUFsWn2Kv6PouQHNw7n3uA2Of13nBuo0577q7Fe2ucFSI7S3Oym5/xCIQAf+ZDsd3g==
X-Received: by 2002:a17:902:ec88:b0:268:10a6:6d72 with SMTP id d9443c01a7336-26812586017mr965905ad.27.1758066243929;
        Tue, 16 Sep 2025 16:44:03 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267e9372e86sm19646765ad.136.2025.09.16.16.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:44:03 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 16 Sep 2025 16:43:52 -0700
Subject: [PATCH net-next v6 8/9] selftests/vsock: invoke vsock_test through
 helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250916-vsock-vmtest-v6-8-064d2eb0c89d@meta.com>
References: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
In-Reply-To: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
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
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add helper calls vm_vsock_test() and host_vsock_test() to invoke the
vsock_test binary. This encapsulates several items of repeat logic, such
as waiting for the server to reach listening state and
enabling/disabling the bash option pipefail to avoid pipe-style logging
from hiding failures.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 120 ++++++++++++++++++++++++++++----
 1 file changed, 108 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 183647a86c8a..5e36d1068f6f 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -248,6 +248,7 @@ wait_for_listener()
 	local port=$1
 	local interval=$2
 	local max_intervals=$3
+	local old_pipefail
 	local protocol=tcp
 	local pattern
 	local i
@@ -256,6 +257,13 @@ wait_for_listener()
 
 	# for tcp protocol additionally check the socket state
 	[ "${protocol}" = "tcp" ] && pattern="${pattern}0A"
+
+	# 'grep -q' exits on match, sending SIGPIPE to 'awk', which exits with
+	# an error, causing the if-condition to fail when pipefail is set.
+	# Instead, temporarily disable pipefail and restore it later.
+	old_pipefail=$(set -o | awk '/^pipefail[[:space:]]+(on|off)$/{print $2}')
+	set +o pipefail
+
 	for i in $(seq "${max_intervals}"); do
 		if awk '{print $2" "$4}' /proc/net/"${protocol}"* | \
 		   grep -q "${pattern}"; then
@@ -263,6 +271,10 @@ wait_for_listener()
 		fi
 		sleep "${interval}"
 	done
+
+	if [[ "${old_pipefail}" == on ]]; then
+		set -o pipefail
+	fi
 }
 
 vm_wait_for_listener() {
@@ -314,28 +326,112 @@ log_guest() {
 	LOG_PREFIX=guest log $@
 }
 
+vm_vsock_test() {
+	local ns=$1
+	local mode=$2
+	local rc
+
+	set -o pipefail
+	if [[ "${mode}" == client ]]; then
+		local host=$3
+		local cid=$4
+		local port=$5
+
+		# log output and use pipefail to respect vsock_test errors
+		vm_ssh "${ns}" -- "${VSOCK_TEST}" \
+			--mode=client \
+			--control-host="${host}" \
+			--peer-cid="${cid}" \
+			--control-port="${port}" \
+			2>&1 | log_guest
+		rc=$?
+	else
+		local cid=$3
+		local port=$4
+
+		# log output and use pipefail to respect vsock_test errors
+		vm_ssh "${ns}" -- "${VSOCK_TEST}" \
+			--mode=server \
+			--peer-cid="${cid}" \
+			--control-port="${port}" \
+			2>&1 | log_guest &
+		rc=$?
+
+		if [[ $rc -ne 0 ]]; then
+			set +o pipefail
+			return $rc
+		fi
+
+		vm_wait_for_listener "${ns}" "${port}"
+		rc=$?
+	fi
+	set +o pipefail
+
+	return $rc
 }
 
+host_vsock_test() {
+	local ns=$1
+	local mode=$2
+	local cmd
+
+	if [[ "${ns}" == none ]]; then
+		cmd="${VSOCK_TEST}"
+	else
+		cmd="ip netns exec ${ns} ${VSOCK_TEST}"
+	fi
+
+	# log output and use pipefail to respect vsock_test errors
+	set -o pipefail
+	if [[ "${mode}" == client ]]; then
+		local host=$3
+		local cid=$4
+		local port=$5
+
+		${cmd} \
+			--mode="${mode}" \
+			--peer-cid="${cid}" \
+			--control-host="${host}" \
+			--control-port="${port}" 2>&1 | log_host
+		rc=$?
+	else
+		local cid=$3
+		local port=$4
+
+		${cmd} \
+			--mode="${mode}" \
+			--peer-cid="${cid}" \
+			--control-port="${port}" 2>&1 | log_host &
+		rc=$?
+
+		if [[ $rc -ne 0 ]]; then
+			return $rc
+		fi
+
+		host_wait_for_listener "${ns}" "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}"
+		rc=$?
+	fi
+	set +o pipefail
 
+	return $rc
 }
 
 test_vm_server_host_client() {
+	vm_vsock_test "none" "server" 2 "${TEST_GUEST_PORT}"
+	host_vsock_test "none" "client" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"
+}
 
-	vm_ssh -- "${VSOCK_TEST}" \
-		--mode=server \
-		--control-port="${TEST_GUEST_PORT}" \
-		--peer-cid=2 \
-		2>&1 | log_guest &
+test_vm_client_host_server() {
+	host_vsock_test "none" "server" "${VSOCK_CID}" "${TEST_HOST_PORT_LISTENER}"
+	vm_vsock_test "none" "client" "10.0.2.2" 2 "${TEST_HOST_PORT_LISTENER}"
+}
 
-	vm_wait_for_listener "${TEST_GUEST_PORT}"
+test_vm_loopback() {
+	vm_vsock_test "none" "server" 1 "${TEST_HOST_PORT_LISTENER}"
+	vm_vsock_test "none" "client" "127.0.0.1" 1 "${TEST_HOST_PORT_LISTENER}"
+}
 
-	${VSOCK_TEST} \
-		--mode=client \
-		--control-host=127.0.0.1 \
-		--peer-cid="${VSOCK_CID}" \
-		--control-port="${TEST_HOST_PORT}" 2>&1 | log_host
 
-	return $?
 }
 
 test_vm_client_host_server() {

-- 
2.47.3


