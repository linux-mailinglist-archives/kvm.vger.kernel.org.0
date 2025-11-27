Return-Path: <kvm+bounces-64843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 52380C8D376
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:50:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 620BB4E57FB
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C84329364;
	Thu, 27 Nov 2025 07:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h5wwDv9G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EFE3242C3
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229674; cv=none; b=hGYBCCSEbNwVFnXgv4VXBpDhl4wVa/XyDgOlD6eU5ik8q844E0ry1cgjWDJghlTSSy2OiAnx5mKtF95sawF2rgHHoQpYVtc8boNXl0+ci1USgu+IsgSkexH76u016Z2iKuRANcwHIyczBYlQn5ypfOKwe40qdyq4ONS+OQUuFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229674; c=relaxed/simple;
	bh=uK+7wonqeqIE2+4J4eSHlB1BJW2sPOHiw05XtJHZdQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G+bng9xkUI0HVLTY7Pm5xHlLIm8dpjHyYp8+/5qj7niaESQwW37z5eCFSREgrsgcSbQTAwbFrPXZcsJT9TYa3FXS7mEexv8HqzJZU6VtW5rahDTmFNOEHzE7ltFu+zYg+D5mRa8Pv/V/oiocb2Hh/qIc6/Dor84DkUIgmE0oWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h5wwDv9G; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2958db8ae4fso6254145ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764229668; x=1764834468; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSkbmakY8QtibtOCdba8TmlxElnFph3vUeoyjgD6/iw=;
        b=h5wwDv9GKeXtfqyy8uBcGE7Ny11mbGGZ9/tkoTL22Yv2lk5ihy2PWjDMi2/R5Uk029
         LsQh9kqzWrZnGJv28ZYSAMBVeYsYn4co2W95iBeaAobYgcf3kbX84bMM3HxRfWJhrd1c
         BgR+gFCX8iPOGiw0WFcoVJMVGHC/Si1j/7B/LSRnX/nZ/8y5bb5jmhWrhruHVH4V+Nd0
         BX2+lvi84KNYBD0yQ5m9jvhJALLEcj9N0Sg4kYnhqNIYxFnQ87172zAM//Bukgdh45pO
         n9Zc1iGiFoSR1RlkFaoYl/R+ZgrI52EyDzj/Kq80FzYqFQbXu6PvGvxKxF0uhnK5Djsr
         Y1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764229668; x=1764834468;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fSkbmakY8QtibtOCdba8TmlxElnFph3vUeoyjgD6/iw=;
        b=sHZ94Ra81LqnF2kyGjgFywNXWLhFjdq3y2DJbeMJ557kA3hH5ZZYJgms4FmpKxzwTq
         a23iL0+gHNOXJLp90qURa4OSvP6Sbp/FosO6+5cJzyf/NPAgUNiR8+z4SanGSUN0Gq5T
         P/0wNuburf2+4qiB9D6tTp7quKgy8Il2I8YxiWALaqLZL/gEU4egnoxiW31VXOf6XBMj
         te1EszTe3DvJCPl7UqitPxILHr/4vDqNA8y9ZcAv4qHml6K/hDZv0naBZs1aYwP42V0V
         piv83zv1skIIUmZHPdsHSHvdi0Va7YSgp76AX3vIFL+Gb+fpNkfDoOH3414NOo4KYXmt
         lSAA==
X-Forwarded-Encrypted: i=1; AJvYcCXktRdahPDN67wgsr951cwA3J9aGLfZwkrjfwIYkIt3XZJ+oDpeBhPXkifPszmIiIhGysA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyWQVNVCh7GXXX3AwaJs13wHkXgBqgzxwtEdjkisPvUzMnspXh
	AWdnugq6tV7t5oyruDZyTuM80oZzQ7sQ+pJRd5Mz7ytatyPcNBJtToUp
X-Gm-Gg: ASbGnctXRc8W8R9zvsOtFI4PSA4AB/zLafAZ49YBjHUxvmZ2lhSdM1s05uuxvhSenTI
	uobO7IKyknAruOsD9+K3KkbUatKF8i9fyxoZ1RSxcDwy04FR8CteMKfLlEBAqThKB1lk1WOzl5i
	H3u4KvHvF+txFpTCz6BwxxHxqE7eNYot6xGYsyD0yeyWwJwX5zKtT4fSq1A5vFAMCP/xgyuzM4/
	PP+V/uZFW0BPRtxzD04VbIk0uGz4TN1KdBtvo9XAD2Sz2gpLHkG3YO3Vpv6ufLvfoDmaH5kIUrp
	DDsyOyYtr9qyxrOm56WAyOx1vUKhBKajmyo3L7KAlhiZ3L09p+qQv/Dhesc+gOj5q9Q2Y9347oB
	SsFdvr5tZ8iFVhGl3MqBFa2gzu6aHYQM888RZ3dQF5dtC7rfOg5SH+ruy23cJchqNmTCa5gGiZF
	rU7JFIUGc3wHnNHtC5iiEnGSUdLFNmib0=
X-Google-Smtp-Source: AGHT+IFtPh0V9McunNowJrC+9Bd7rTHnkxHi303D7KFa0Z7tGOf0IgXX81NinSQPf6KKOfBJpQFrOg==
X-Received: by 2002:a17:902:cec1:b0:295:5da6:6014 with SMTP id d9443c01a7336-29b6c504483mr275220555ad.22.1764229667840;
        Wed, 26 Nov 2025 23:47:47 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:73::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be5093b5b79sm1006270a12.25.2025.11.26.23.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 23:47:47 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 26 Nov 2025 23:47:34 -0800
Subject: [PATCH net-next v12 05/12] selftests/vsock: add namespace helpers
 to vmtest.sh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-vsock-vmtest-v12-5-257ee21cd5de@meta.com>
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

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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


