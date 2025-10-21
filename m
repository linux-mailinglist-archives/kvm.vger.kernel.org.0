Return-Path: <kvm+bounces-60773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8427BBF95F2
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47EEC18808C9
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD202FB0B2;
	Tue, 21 Oct 2025 23:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7Wl0tIy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E41B1EA7DD
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090440; cv=none; b=cRlVcezVk7ePSQb+5oiulMq+ZMfx75/9kNNyj5CzBhyR52wARxAGd4+65sl9NhgGUcPEboe3DctelxyUEvZ3Qq2xHFDU/0As3Fd6+APZDX++Yxipuwsgb5x0pMVWdExYU2rT7lnXP/CBG82wd6hQXn6oyBtke83Ma31yhUbrbL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090440; c=relaxed/simple;
	bh=BO9LQWlKtI1shvhDlqPu16W9qVY6XwRMkI/EUMrjZE0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TSgMjJcXlfJr50wwaB9KEjFI+TpaN9ueRmS+Mu+wU+9MLDdUVvXsKw9bXaSn7TPtKrmmr0kqNHL0gSmiZ5L1uNaoQTYTmnxBIFFUsdEyI3jXyv/BRF2ClGCH0YxikrJlMCCZvXuD9337MdTuYU+EMPRlt32SuIQ6cu4YkX7ZWKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7Wl0tIy; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b62ed9c3e79so4400772a12.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090433; x=1761695233; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uUo2ea9cpuDIObzkB+5zIj/xuLOHXIXFOy7ynypiC8o=;
        b=P7Wl0tIy0xZg5AkLjFTiA3CCE8IS61M2SuZhBvxwtKbZHQbOnRVMfUyHuwICv33eee
         akIrPGh0t4mp0Xes6zl0bKGgR2cpgBhDY6fL7hNd+Voua35NTWu1+S/V2bzljT+FT29E
         FeOliG/2dYsgTJY1yCZ9hO/mdTpJ6X7i1tYTYMIVCMcluI6XFIKPzwXaVUdbztem50qj
         JHxTcLMi/ljpqwovfLP//bjxGHzjx9/V+RlLSeZzOQAWxdYfrs6oDFrqfW5O7LNQDrxP
         Hxwdad5fu+M7FIwd5H6SefRAJpL3AYRY0A+iUeHbOCoV6tUcPA7fhWjD8F4CQQIcX//K
         bVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090433; x=1761695233;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUo2ea9cpuDIObzkB+5zIj/xuLOHXIXFOy7ynypiC8o=;
        b=bum8NsY83o6iW03dMSKqiM/24XHR2EcVuMYQ5IQ/lw1UXaDXW2sukyaVt6Juk/kGo8
         FH36covGA0ILhYN8nyaqae8ZI8aQm5OcWKTfmyCfDXdfp592BT38kewGBcd6Iad7CNiR
         KuytD1HOMmXnmxdQ401EYRrWGfnDzIZsC2KMrdUIDH6gqKOochzri/ztz5JSrty3FIkJ
         Yw1D1Neym1lFwfv03QWbMSIHmxoep2NuJxOtDtN2xzKkg1VWEzl21C8gSVff3zcnPgFc
         qKdAv/f5sFWbytJ8Dx/OVK+CZNRUYykhBZjcV23TBky3+6o/TAxMA548Dwb4HuKKlxVh
         O++w==
X-Forwarded-Encrypted: i=1; AJvYcCXoo8Rb6N/VFSCf8xEAtgxJ+j/8WxMgjGyGzXyEgxNRpwVllPdDI+yUIGEmSiuzKvaGQhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzXQLWvPmf39eyoFEx/R2Cb9mFZkRLPfTh0QJKFCEtFFrFM7K2
	b50IZsf6NgwwfT4jVxZSuXTcZwlIRgkkOzvI7auZT50gmww+KAKccnW/
X-Gm-Gg: ASbGncuwvE33CE5PTKQYhFV1nMDI9ku4hY2gIBthVhLmihjT/EO8A4FpHo13Zas3i5p
	S07sb8PvalHuaGTpsUnCJcnNh1rqPgYF/WbWvna29ZYT7vcq0Q9jLfiU5bavbOc8Cadndn0BLGG
	1/1A+aL6OPPjVE34JeMHSuqbx5xIAw4lvXZ56/1NH3hTJLtPQUthD1716e2MrUnQrlK745/CplH
	Lv8OrEUVYLOVCZapQKK8NokXoYfvn3xPfJojuWFi854L2IP5SP/SWSvSgx9VmYCwLj390jAFuMI
	BRkOB5u0J3cwD+sOdjoh36FqXZ82MK8Oi0IqGtw5eZJ2aGIMhLiBsjKU7p9W5hXNBpPiLcD05SJ
	XbkTcy/OCMkUG7g6WyA0tyQkndk7iuecbRcmWjIUqkgNwOXcQrnORIRqaNPzjCbRsPk2RtC564A
	==
X-Google-Smtp-Source: AGHT+IG4mF21y9b4ILzi1VUa6/N8UQb6jbaApizlergIx98zJ8IQeCKiZxAt0HtWfKk/EMQPlOy3Uw==
X-Received: by 2002:a17:902:e944:b0:290:b14c:4f36 with SMTP id d9443c01a7336-290cba4edaemr218306105ad.31.1761090433298;
        Tue, 21 Oct 2025 16:47:13 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a813d4766sm9627762a12.5.2025.10.21.16.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:13 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:46:58 -0700
Subject: [PATCH net-next v7 15/26] selftests/vsock: identify and execute
 tests that can re-use VM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-15-0661b7b6f081@meta.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
In-Reply-To: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
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
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

In preparation for future patches that introduce tests that cannot
re-use the same VM, add functions to identify those that *can* re-use a
VM.

By continuing to re-use the same VM for these tests we can save time by
avoiding the delay of booting a VM for every test.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 63 ++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 5368ec7b1895..4ee77e6570e8 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -45,6 +45,8 @@ readonly TEST_DESCS=(
 	"Run vsock_test using the loopback transport in the VM."
 )
 
+readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+
 VERBOSE=0
 
 usage() {
@@ -454,7 +456,44 @@ test_vm_loopback() {
 	return "${KSFT_PASS}"
 }
 
-run_test() {
+shared_vm_test() {
+	local tname
+
+	tname="${1}"
+
+	for testname in "${USE_SHARED_VM[@]}"; do
+		if [[ "${tname}" == "${testname}" ]]; then
+			return 0
+		fi
+	done
+
+	return 1
+}
+
+shared_vm_tests_requested() {
+	for arg in "$@"; do
+		if shared_vm_test "${arg}"; then
+			return 0
+		fi
+	done
+
+	return 1
+}
+
+run_shared_vm_tests() {
+	local arg
+
+	for arg in "$@"; do
+		if ! shared_vm_test "${arg}"; then
+			continue
+		fi
+
+		run_shared_vm_test "${arg}"
+		check_result $?
+	done
+}
+
+run_shared_vm_test() {
 	local host_oops_cnt_before
 	local host_warn_cnt_before
 	local vm_oops_cnt_before
@@ -530,23 +569,21 @@ handle_build
 
 echo "1..${#ARGS[@]}"
 
-log_host "Booting up VM"
-pidfile="$(mktemp -u $PIDFILE_TEMPLATE)"
-vm_start "${pidfile}"
-vm_wait_for_ssh
-log_host "VM booted up"
-
 cnt_pass=0
 cnt_fail=0
 cnt_skip=0
 cnt_total=0
-for arg in "${ARGS[@]}"; do
-	run_test "${arg}"
-	rc=$?
-	check_result ${rc}
-done
 
-terminate_pidfiles "${pidfile}"
+if shared_vm_tests_requested "${ARGS[@]}"; then
+	log_host "Booting up VM"
+	pidfile=$(mktemp $PIDFILE_TEMPLATE)
+	vm_start "${pidfile}"
+	vm_wait_for_ssh
+	log_host "VM booted up"
+
+	run_shared_vm_tests "${ARGS[@]}"
+	terminate_pidfiles "${pidfile}"
+fi
 
 echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
 echo "Log: ${LOG}"

-- 
2.47.3


