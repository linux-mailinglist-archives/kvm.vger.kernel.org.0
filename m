Return-Path: <kvm+bounces-60910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC8DC02FE6
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 20:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D833D4E9DE7
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 18:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7758E351FA1;
	Thu, 23 Oct 2025 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CgTxk4Pt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8E834D4D4
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244101; cv=none; b=ZElEsJK76JYYegxSOBYEaa8rBc3RazBcC8MCzfXAyqNNCb0WYRv/tXEdD97VKFpOdNzA0/gOFGC1bbyfbwEpz23FmIkWVCHxveJQU1RCCcAu3eSoaKZlmgmW6K39yZPZpfmd7HOwM9LsB0HCaNkhgB6BpNHKKdQRrAnZLpWYRF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244101; c=relaxed/simple;
	bh=qsdEM4mUEx6lc62dcdEXc4nlTIYZClzkDbVeOSxLeZc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TLZEdzpQ8TfflaiffUkLjF0qJuB/roRyjd8mEr47xk5YL0AD3u1G/Eq76edS2rDqjwRss35tlFGxRbM5wg8qUQz+JJBQOfmSrwA5W3v2AW6BGoILrnrAFCmUn6Qxmp1OwyM5Q62EtHzhis61SCJouZcAGVhEHtXvf3jQ2pr/1M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CgTxk4Pt; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso796713a12.3
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 11:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761244092; x=1761848892; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v1bBkEHiFKeL/UsD+j471vNGh5kKPPSFbcwNUOh3PyM=;
        b=CgTxk4PtZgzYqEwUrxug9GUWlwAOlSb/4GiXga3xzuC8xsVvOkqAma2VKwORIOW7I2
         QMtsirQZM2E1Ydb3QkqIDrIat2ivOrUPcH43MbFS3SzsqWOvw9mubCVxWOVb3OIi/10r
         bQ1TOQpfyqn6DH8rO77mXUM/KV1CQliLqiWXhtntOTPaX6qXkLKW78hU6LgRcrx44Vkc
         PXKSbbmfxzqf0VlcNs2JqBsFzvvnpKzJVvgaETgKKK678wAseoGKpKLxF7VwbnerjfEK
         y2jJcLl3c6P0e+QoGkFum2l3IMdhkLDyJToz841o9imnGUzY6QwFJHMIBVzeo3urdrtN
         gcsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244092; x=1761848892;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1bBkEHiFKeL/UsD+j471vNGh5kKPPSFbcwNUOh3PyM=;
        b=WufxFZo3CGFGcnAK3t8cOUS71W3vJWzS7vDjbHRjsjVAkqamxBV5fjPeCK5Zxr+0rz
         fKZR1wmdeuDwnxGYcEx152h3cK6kboJg1cL+bQ1ensYWpwJ9rTpzLls2+PURRmJKD8v3
         B57LFuuXPLr/juKmr5CR/YJ5GrAW+Z+gbqUzw73TMlaXIZlxs/w+uHl/+wmz85aQU6Vh
         9TDo65c+zHX7zbUITEbhrZPdMGa9nwGWYmRa11BoRQpdq25ZzYmVjUo1/HfbDxykAdss
         ouIMJ5hvYcIX2oA/s9mOQDQWLFEgFZrltepHlnzoCKaQkhHntRIh4kKqgrTBdVeFuXaF
         obcw==
X-Forwarded-Encrypted: i=1; AJvYcCX62Ys9X/Kv/gJNbmm2jlSmVDub4wYVAytafXQDDYVVLE4PHocSYtRCxLsXyenddR1mV3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKBHDt7yAUwcoUDZ6HpG/8YIAHzO8Ex3Gub9Oeg0lkkFlfIgvy
	oSUxr9CsPKlPTqE6c4q8fyVpujMpwXXka8WvHNIEHpcLNCuoegyxN0M4
X-Gm-Gg: ASbGnctk0ottFfcngyaKBilYJBDmQ4BjFkl8Q5Y7xlc/S2ZDS+1UfJUxw/O9vwUB4p3
	kFG8LvuxW9jZ3lWjdbYmB09kb69CB5qYrsoEY1IaKZRHvaaYff/xE6YUwDxZmx6vfP88y2FbnHf
	cWu0kHhq1zzSGkBUC835CLEAstfv/raL/WORbgQfkf4l2zGyuyrhm6CKcme6wrE0aMbdJQmBzHC
	94q3/QW/cjq61tponO8wz/BkBatMttnTigftaf+ftl/phOSC0ZS1/u8cBplcDTnWLSnOxNmBa+Z
	dj7G/KeI7DafrkYKOgQilPQgxOggaawXZb7HXSDeEoVEBYG+/0/IyELUDrg1WawPZiq74eG6kHW
	kiwmzXTe2cwvZJpjf/iOj842Jwe6dH3cKSjXwj/r6tlN6RT3XJ12pB+9eMrYtmYazZwRrO9mS
X-Google-Smtp-Source: AGHT+IE/dwExmoLUemuWd0Z4IzWtCnVPvukg5v4cVC/ETItw8BzfPltzLRhLMffJHMVaO6fvdpyktg==
X-Received: by 2002:a17:903:24f:b0:267:a95d:7164 with SMTP id d9443c01a7336-290cba42a8bmr268233595ad.60.1761244091859;
        Thu, 23 Oct 2025 11:28:11 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946ddec8d8sm30411195ad.36.2025.10.23.11.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:28:11 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 23 Oct 2025 11:27:47 -0700
Subject: [PATCH net-next v8 08/14] selftests/vsock: add namespace helpers
 to vmtest.sh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-vsock-vmtest-v8-8-dea984d02bb0@meta.com>
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
 tools/testing/selftests/vsock/vmtest.sh | 45 +++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 62b4f5ede9f6..5f4bae952e13 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -46,6 +46,7 @@ readonly TEST_DESCS=(
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly NS_MODES=("local" "global")
 
 VERBOSE=0
 
@@ -100,11 +101,55 @@ check_result() {
 	cnt_total=$(( cnt_total + 1 ))
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
 }
 
+cleanup() {
+	del_namespaces
+}
+
+trap cleanup EXIT
 
 check_args() {
 	local found

-- 
2.47.3


