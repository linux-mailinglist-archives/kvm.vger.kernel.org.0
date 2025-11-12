Return-Path: <kvm+bounces-62855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B29DC50D57
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4DDD34F750B
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074A52E6CA0;
	Wed, 12 Nov 2025 06:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8FpJ83o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB02EB5C4
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930550; cv=none; b=ZTVdXyOneLfLsd92Ij4fpkAFqeJumvPrXUMoe2uNtWOFwlTP2hSuLwhUIiJ1tFkzVdEVqtr0AlnqPszKVKYV1f/SOeefb5f4MoNusVUtYmW3JJfNxgA92szHUUMsjL+iSrfat8SmUCtk3yR9WYkyrVjFB81qnB87YL1+SqipHXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930550; c=relaxed/simple;
	bh=C74tPtLEcFlxKPQiq+20Ok+iNGw0X0cvYTmDWlPCWgM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R8VIcs8U9Wlfy6K4zDuddEPbhJimOORpyybZ9gZ+NwU5KgDR6STmz3Q8jbz2Z51w4/9+nWECtm/M+nd4c0pjfutpIdaVX9h5JiKGvYqjWYW7p3ty7lVwIgnmUjtHywRFN/s9ezjUdaw1kTClWGQKY6lfjsvK5jhRcbxm5b42uFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8FpJ83o; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so423025b3a.1
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762930543; x=1763535343; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p28zEBQeBUk36AvYw3frZ4faKmOpLSnPo9g0yADkH2g=;
        b=H8FpJ83oCTjDCtUaw+fmE8WHeuhylz2VYw4N4J+VORPN1FDWxMFnFnXyCHGolV7a8W
         mOZKDkqdaOah8gGxs9o8NVGOC+vsmbSKaey7M9tgTC5dysVgwCf3659YCEdQDbngAQkK
         bKgyteTVUrgQzjSFEBUzzwtLhJGKeQ7n6HbHAMhC8uaQJIOK0I968xMA4NOydOBupgZS
         ut4lUAABAZGV6NLXRVL0hsunKhHU/1mZrT6DiNr/wemxD5DusLAJrInrDj5ZPssQ7v0e
         523TMllidl0rBwuMNfAmwIbLch6REZ2vaW+WScAwg+L45PSGfuBwAD07Or9Oq6qc8XoI
         HvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930543; x=1763535343;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p28zEBQeBUk36AvYw3frZ4faKmOpLSnPo9g0yADkH2g=;
        b=meA7tsnMOhNk/VPCGHu7Hlx3FFsm+uVVxgaPf9QV7OrxnJeK/NKTX2Vm02Ozz23u3x
         iLFXnW4W5gqD9RxUgKmDH5c1jgWjxNpejd2i8UQpbMw4Y4PWAEJ5VbectLejVA+6Y7DL
         6iGhV7gGQf/n692YYK2JkLGd0Hr0ztSfdCb+7OCD7dkWsamh8/B7Lr9KdC3Rb3jq3/KZ
         p7cpL4G0PuujCp1gyy8Vtm+8kBGKDiFMDZVO4d/sRg/EbguW9ITemYydVcPOVz4mzKtJ
         9+P0z6yLnLjSwUiT4ZhcoPuBLQ6bobZzTQTMRg0vB6CAlrq++LPw0AqcMhk6fU8kpxXV
         HETQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnO9bdoRT0DXbUaPM653rd2BWvtJFepQwDg22NqouOw68F/Yn4inI2KaB1glKAOPwGVP4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy197fuv5c6Qx+pLkBiKeQ34N/unvL/OmhVe3l5hB/kXGd0JqoJ
	V5QMbx/UIXMye3UX6qsnw3Tfa7o6/9VaOUTiWRTw+09DBXQOxNsLghYb
X-Gm-Gg: ASbGncsdxRs4lTwP/IhNmN7hi0ilTLOY96zc44Uy674cO1YbKukohdejqoYiUIACqn8
	wx6Fbc+CzcJ4qk0QxgpLoprNBobgeJN+Tr424PIIuIP5dvxan1An91/S4TFYoAlo233CcrdzugZ
	QuoeqmfUBo0TUQEtvvkLPIPRPiXLhB0UkIhdWqBYHNjzxE1G0iLMe22z9l6u3bZVm0psEMFOT2r
	s98fGJV57/S8B7wOhIj+TccMf6WD2rSeAxaxbmDiMKHOzpUFMnFiI1yE+AtE+U/IlDrNQScL1xt
	goVg8uDsnGGIXx3WiZlToWxA0zl2Z6pHPgUVEFdNKabsnVfDWhVn3c5OnCS7+ErczNWUy0d6oqm
	FvuJQnnWoc4djcD9Z1/CJPIiXSXTRr3rpmfgFwoMpi+4sM1DLx4InWVsMnKyOuySHtimGOD8E
X-Google-Smtp-Source: AGHT+IFrcYVq4LOZXvV70I3sEePi3UmNsOLwpVBty9xgqUole9nqmJJSBTG6gPimY2LrfYFWsxLRzg==
X-Received: by 2002:a05:6a00:1896:b0:7a2:7cc3:c4f0 with SMTP id d2e1a72fcca58-7b7a2a96c07mr2022312b3a.1.1762930543350;
        Tue, 11 Nov 2025 22:55:43 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b783087c6csm1699020b3a.12.2025.11.11.22.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:43 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 11 Nov 2025 22:54:51 -0800
Subject: [PATCH net-next v9 09/14] selftests/vsock: add namespace helpers
 to vmtest.sh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vsock-vmtest-v9-9-852787a37bed@meta.com>
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

Add functions for initializing namespaces with the different vsock NS
modes. Callers can use add_namespaces() and del_namespaces() to create
namespaces global0, global1, local0, and local1.

The init_namespaces() function initializes global0, local0, etc...  with
their respective vsock NS mode. This function is separate so that tests
that depend on this initialization can use it, while other tests that
want to test the initialization interface itself can start with a clean
slate by omitting this call.

Remove namespaces upon exiting the program in cleanup().  This is
unlikely to be needed for a healthy run, but it is useful for tests that
are manually killed mid-test. In that case, this patch prevents the
subsequent test run from finding stale namespaces with
already-write-once-locked vsock ns modes.

This patch is in preparation for later namespace tests.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 41 +++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index c7b270dd77a9..f78cc574c274 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -49,6 +49,7 @@ readonly TEST_DESCS=(
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly NS_MODES=("local" "global")
 
 VERBOSE=0
 
@@ -103,6 +104,45 @@ check_result() {
 	fi
 }
 
+add_namespaces() {
+	# add namespaces local0, local1, global0, and global1
+	for mode in "${NS_MODES[@]}"; do
+		ip netns add "${mode}0" 2>/dev/null
+		ip netns add "${mode}1" 2>/dev/null
+	done
+}
+
+init_namespaces() {
+	for mode in "${NS_MODES[@]}"; do
+		ns_set_mode "${mode}0" "${mode}"
+		ns_set_mode "${mode}1" "${mode}"
+
+		log_host "set ns ${mode}0 to mode ${mode}"
+		log_host "set ns ${mode}1 to mode ${mode}"
+
+		# we need lo for qemu port forwarding
+		ip netns exec "${mode}0" ip link set dev lo up
+		ip netns exec "${mode}1" ip link set dev lo up
+	done
+}
+
+del_namespaces() {
+	for mode in "${NS_MODES[@]}"; do
+		ip netns del "${mode}0" &>/dev/null
+		ip netns del "${mode}1" &>/dev/null
+		log_host "removed ns ${mode}0"
+		log_host "removed ns ${mode}1"
+	done
+}
+
+ns_set_mode() {
+	local ns=$1
+	local mode=$2
+
+	echo "${mode}" | ip netns exec "${ns}" \
+		tee /proc/sys/net/vsock/ns_mode &>/dev/null
+}
+
 vm_ssh() {
 	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
 	return $?
@@ -110,6 +150,7 @@ vm_ssh() {
 
 cleanup() {
 	terminate_pidfiles "${!PIDFILES[@]}"
+	del_namespaces
 }
 
 check_args() {

-- 
2.47.3


