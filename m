Return-Path: <kvm+bounces-66649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A70CDAFB8
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 078D53004613
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF1027EFEE;
	Wed, 24 Dec 2025 00:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LI7djxw2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F0B23372C
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766536145; cv=none; b=Lqa3sVgJN23a8lVnj9Ed+KMjT0qlXX9n4f+rO5iIBAA803SnHFcmbAzjaYpPAptnp7+Xy9gQtFRzGyATPuIt5ZUdI0no5xxDhuHmngqO5i3EI3c8jdn0pEeq7HtN0GJ5EWxZHMzlHIzfoEuwz4XAAcVpqNIkCHR1fn2Fr/wfArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766536145; c=relaxed/simple;
	bh=A/Re4uBOGGe0FAXjhpo7AUAS6ISO6mznmR48rNydg0I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G10OTnlkBWeVdVc3WFHooX3Vo1/HvjaEA86pcXm6clvNrFm8jBoFbu3hZCSROIf5+qg1HBtUqxwD12lfO2r7iEiL4/4/MrxxzX87qES9kHZ7E7MJlP5F10p6rmTsr8082Lo7WtCFRAy1GXvn4O9A775f0K6M5YMdjVR6Hrob3aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LI7djxw2; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d67f1877so68970335ad.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766536142; x=1767140942; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMAS5pTBRt+D+YQ3hZNF0StDlF0aWH+C/CFg55tOZdw=;
        b=LI7djxw2SmbC7GAb2AzCJnlQBmGO0eXeEqgStf9bN+I4jrDTU/oE6tWx6YTV2FkGbL
         Em5CwYkq7sYmK9K29/5Miz663ffMPAQI/byO13LCStjUkK8B9uF+fV5QyK2CHoOKYSzt
         lGXu5R9UCkmUTfwgFy4i7pZeovHIx1Uffih+LouEpY4Iu/PdXOZQTcONUyr2Mzda5OVz
         V+D3v9pmsLkDSrUfYNOpBGGWh4XMvXEwIJJTw6q/XK7erS5N0Dtdo9DAQ/C5QqvekCBt
         9fE1wK5BfE7iLk8xzodLITz/PgHNqHDq/m48oayuoXCt2XP+pj7WOqO6rgkt7umZ/uJZ
         6/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766536142; x=1767140942;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bMAS5pTBRt+D+YQ3hZNF0StDlF0aWH+C/CFg55tOZdw=;
        b=pWhs+c88zCD/Uy5p/XKfao50F5af6QBWAmhzoKt88nSDrCbljoFdPMbX6DUCZo4OsP
         h2F1+L5l/pNfL2Hm35FBQYaEvc3x2+KsG9LlmgKOis0OriBUzku/n6eMs8jOrKXdk6JQ
         uu+Wl8qRxRrPNcDAICCnxQ//YeKp8ZMoHcBKGpqz8/dbI6QxQBrHKRGcZiexrqpKYwBH
         svsxb6T/wQy6Ug21hk5YzyNPgHrlKsBap8+1jfR0P8Csef8WRW+u2S2UlY7gPcJ14Z5t
         vcu5dDjZu/6F1SCY285kY9U9kM+7VcMdWJfMQshixws4SJybgNrrfTGfepV+9F2Wtbpx
         13Jg==
X-Forwarded-Encrypted: i=1; AJvYcCV/MUphXGEjJQocMDrhtanMYzamCJlsKGEaBLLg4fQOZQ/DAKcDd32fVB1ynHCkPpPWLtM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNcAKTAxpXwHe7qovQSriMHFKETu+hy1+Oyv5HgJGTdGfyY69E
	ciWpZWsUyK6sHZEVcHzqzw+s+CEt2BAtQmKEfJ+1WXwoLw4vSk8Yy0XP
X-Gm-Gg: AY/fxX7CS6KizpCs2+ER9Vl/l2FuoiOlcNKsa9iNfRz1s5cElchC+/0OJiWJr423Lqo
	uIPx/KIlZFd4KwK9W4nyvXAMOaRg4TYgXoMkcU1A9DDsJ1gLW06URIyKsLqCmxyMMfSdQ1DBuXg
	ecqNMUM/1LTBvp8PLWfRehcMcykZwhJ5spO3YftwxvcT7DmgJ7CBwsiUwYSwrkXGDZYEPgS+odo
	33nAksg1SME8jLaugs4LmTWTQZRBRwuHbjNkQo/YZh8zQ3iDgkT3VGrbZPWsRlcwHPrC8W80rGG
	wznkuKbmxYRYApzgEe14yP5+11b6uNqSCajH5kUCz28+7u497fFEip4y59VGUjZ2MW0oxIGwMFd
	TtZqMej8/9Vu9aLsHH+Ryn5AVJw8MGuKD/CTOQ5CkTLc2Fxeu+ER78LE8uVVh18b9Cf0QAgSqMD
	fmL80ie/cwljrI+zzTszZM
X-Google-Smtp-Source: AGHT+IGk5LVdk+TERc/fw8l5nIc94qgaWAolimWSUPj2FUxbokwJ6dSPaiM4BcignHXWPYwD+sNmTw==
X-Received: by 2002:a17:903:b8b:b0:297:df4e:fdd5 with SMTP id d9443c01a7336-2a2f2327264mr159417125ad.23.1766536141803;
        Tue, 23 Dec 2025 16:29:01 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c828dbsm135979755ad.22.2025.12.23.16.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:29:01 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 23 Dec 2025 16:28:40 -0800
Subject: [PATCH RFC net-next v13 06/13] selftests/vsock: add namespace
 helpers to vmtest.sh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-vsock-vmtest-v13-6-9d6db8e7c80b@meta.com>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
In-Reply-To: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
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

Add functions for initializing namespaces with the different vsock NS
modes. Callers can use add_namespaces() and del_namespaces() to create
namespaces global0, global1, local0, and local1.

The add_namespaces() function initializes global0, local0, etc... with
their respective vsock NS mode by toggling child_ns_mode before creating
the namespace.

Remove namespaces upon exiting the program in cleanup(). This is
unlikely to be needed for a healthy run, but it is useful for tests that
are manually killed mid-test.

This patch is in preparation for later namespace tests.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v13:
- intialize namespaces to use the child_ns_mode mechanism
- remove setting modes from init_namespaces() function (this function
  only sets up the lo device now)
- remove ns_set_mode(ns) because ns_mode is no longer mutable
---
 tools/testing/selftests/vsock/vmtest.sh | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index c7b270dd77a9..c2bdc293b94c 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -49,6 +49,7 @@ readonly TEST_DESCS=(
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly NS_MODES=("local" "global")
 
 VERBOSE=0
 
@@ -103,6 +104,36 @@ check_result() {
 	fi
 }
 
+add_namespaces() {
+	local orig_mode
+	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
+
+	for mode in "${NS_MODES[@]}"; do
+		echo "${mode}" > /proc/sys/net/vsock/child_ns_mode
+		ip netns add "${mode}0" 2>/dev/null
+		ip netns add "${mode}1" 2>/dev/null
+	done
+
+	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
+}
+
+init_namespaces() {
+	for mode in "${NS_MODES[@]}"; do
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
 vm_ssh() {
 	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
 	return $?
@@ -110,6 +141,7 @@ vm_ssh() {
 
 cleanup() {
 	terminate_pidfiles "${!PIDFILES[@]}"
+	del_namespaces
 }
 
 check_args() {

-- 
2.47.3


