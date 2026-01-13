Return-Path: <kvm+bounces-67900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 345DBD16755
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:17:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 41C173075D1E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E48F34D38C;
	Tue, 13 Jan 2026 03:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvKioUeq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB431691A
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 03:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273990; cv=none; b=ivB6tEEsa22FHrStNUqgIXPncuHPLlK3i1GlxgmsNIf/ilF6xyn80+AajCPEu4aFVdiRnClXOIJEmh+l251zBIvJSxDkbH9RVaK2xkk73fS+P+ykrCeG+uc033PeEbtGmQ64Ogl3bR3i/IX9j7nESQy2FX6apnqusOatnAY0jdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273990; c=relaxed/simple;
	bh=43YZlXDQmW65hszyjr5m3UtpfpB8+72+oSXEtxR8B+c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PmDDllgzHUpetFZ+H9iypMQK9lB1qjUY7dl8TsYTaeqyv72nnrvEMJM3iVv1IjDQsy7Knrcwhze29csNS/Hwy/5Fs7jrirwJ7k+2Bu7tTdV49n1PT8V54ZXCdT3qUlHFjgiPTkts6DSunjxJ3w8TnzvitejAqWWtfeON7oPsYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvKioUeq; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7927261a3acso27006487b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768273986; x=1768878786; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3I8QcIsIeOrh9cIrz38ZjjL+G5z3ujRC9KA0ugGud8=;
        b=GvKioUeqJuLgXz0GTYRTnFqU+1pyo22l7fcw4ynkxpj+ey80UuN3tYzpU2kMujz52S
         s+yskllsgQLGjnNi/D8mNh/PzPHuvlr+Cp0oE+5xE4yFopGJgOQgF/Ai01IInbuJhcKf
         Q37/CodOAib/BJmlG+bWstVR3nrbWVQJCX+HKOAQ7NWqkuxMs8ub9FZLVX2w45ONdomL
         /J0qzGvfhsh755mx1poZv2bblgJ/2PEJsM3IpLtsk0N2YaoTvDXcTWrXWrZnvg7Wmn4V
         4MUihvhyyTrKhXGeityiFQOmoxSxSx6XIyg68nj6iQfVvVmAA0UydPmqRcwqTScchCYr
         Lsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768273986; x=1768878786;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y3I8QcIsIeOrh9cIrz38ZjjL+G5z3ujRC9KA0ugGud8=;
        b=wCF0xQyn+SGk8k3DPyti1pVrVwwueMkKt+bxjKQz/WGBk7Ow/J3V6py3/TkTBs+TsI
         1KoIG2NL/PrZL/jJRkbuN17jzjxOQv6ntwrWHskRinijJKWQ7JZMxAy8SYGEXdGJ0Ay0
         Kew1eyd3ctDN1fcl8STZBdxBw7ko75+QyP46A8SqmzoHdOtULbSlu8U8YkWEqaumu+3v
         lcQNefJxtgxjs1omapy7wqIQlmZMNaJ0mAcSFy59ROYoPIvHsKa4nus2N7PNy2kydpLa
         4cPgAVMDqJSKBe27JSDiPDSayrBwbZXcUYi1Tsv1Qt8YqWzsv1MHkhF4WsFteakc8esJ
         Rn1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUqGwWogpyTQGb4DLUpzqW9VluD8YGi38xzeJu4nIy276BAjhHCBhz2vEikBUpxVlQo3Hc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMYaw+xyWGCTAoBJexwLd7bn3SJHKq9JfShBMZY9/tkkQRBxfW
	VGxnTEPWCpZImQjLi3IaqOuWfo1/WPXEAHZcOhh53CuM2L0PjcblyG14
X-Gm-Gg: AY/fxX591ynMj8/rviHGgDkRez2vRksEeDtiWlyE3qVgvOZ4CTEXZAqVHGzxQLQNbjx
	29oRA7Rrf1UFwVyg3TEsn3FZQMedtH+kEgKqANb4l6KG+rIgu14Hqfj0MXtNQuOKMV7rg6woAaX
	/OBM2xAMJW9vnm+mQriqw3n6jwCIermeD8YtRitJp+Tz1jLqLOPWSe7zX4u5lSoZd8pHNbKORnr
	5/K1WLsuV/yipkUdd0gl7HUYlM6NrO0+pXmtbAfKq18p94MOeHJrIVsJt9Se9Apm5IcMQndUATq
	9wNKIsM3m22KYr9zfitHL5YrfuQnniaOxPqIWmvslHEuA+OBCnxGl/Ba+sWrn/fLE/Jha271fY5
	9Ir9v+XPjx657U9xUeuAyQrGKKiKG41kKVCQj0LbcqSF/PvUuTEMN+ogGPwoy6XStDA8Pf73aNn
	HVcLzEbTQ/opM3e4f6LMyt
X-Google-Smtp-Source: AGHT+IERhF9/l61WGAQ1JPbNCa1uy97rBtlOCcNLY+Lr8nEdQsaCK1nAx9XYRA7ZWkcN16bvEB72Wg==
X-Received: by 2002:a05:690c:6f05:b0:792:7721:e072 with SMTP id 00721157ae682-7927721ee43mr68361877b3.11.1768273986386;
        Mon, 12 Jan 2026 19:13:06 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa6a3969sm75907927b3.43.2026.01.12.19.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:13:06 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 12 Jan 2026 19:11:19 -0800
Subject: [PATCH net-next v14 10/12] selftests/vsock: add namespace tests
 for CID collisions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-vsock-vmtest-v14-10-a5c332db3e2b@meta.com>
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

Add tests to verify CID collision rules across different vsock namespace
modes.

1. Two VMs with the same CID cannot start in different global namespaces
   (ns_global_same_cid_fails)
2. Two VMs with the same CID can start in different local namespaces
   (ns_local_same_cid_ok)
3. VMs with the same CID can coexist when one is in a global namespace
   and another is in a local namespace (ns_global_local_same_cid_ok and
   ns_local_global_same_cid_ok)

The tests ns_global_local_same_cid_ok and ns_local_global_same_cid_ok
make sure that ordering does not matter.

The tests use a shared helper function namespaces_can_boot_same_cid()
that attempts to start two VMs with identical CIDs in the specified
namespaces and verifies whether VM initialization failed or succeeded.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- check vm_start() rc in namespaces_can_boot_same_cid() (Stefano)
- fix ns_local_same_cid_ok() to use local0 and local1 instead of reusing
  local0 twice. This check should pass, ensuring local namespaces do not
  collide (Stefano)
---
 tools/testing/selftests/vsock/vmtest.sh | 78 +++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 38785a102236..1bf537410ea6 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -50,6 +50,10 @@ readonly TEST_NAMES=(
 	vm_loopback
 	ns_host_vsock_ns_mode_ok
 	ns_host_vsock_child_ns_mode_ok
+	ns_global_same_cid_fails
+	ns_local_same_cid_ok
+	ns_global_local_same_cid_ok
+	ns_local_global_same_cid_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -66,6 +70,18 @@ readonly TEST_DESCS=(
 
 	# ns_host_vsock_child_ns_mode_ok
 	"Check /proc/sys/net/vsock/ns_mode is read-only and child_ns_mode is writable."
+
+	# ns_global_same_cid_fails
+	"Check QEMU fails to start two VMs with same CID in two different global namespaces."
+
+	# ns_local_same_cid_ok
+	"Check QEMU successfully starts two VMs with same CID in two different local namespaces."
+
+	# ns_global_local_same_cid_ok
+	"Check QEMU successfully starts one VM in a global ns and then another VM in a local ns with the same CID."
+
+	# ns_local_global_same_cid_ok
+	"Check QEMU successfully starts one VM in a local ns and then another VM in a global ns with the same CID."
 )
 
 readonly USE_SHARED_VM=(
@@ -577,6 +593,68 @@ test_ns_host_vsock_ns_mode_ok() {
 	return "${KSFT_PASS}"
 }
 
+namespaces_can_boot_same_cid() {
+	local ns0=$1
+	local ns1=$2
+	local pidfile1 pidfile2
+	local rc
+
+	pidfile1="$(create_pidfile)"
+
+	# The first VM should be able to start. If it can't then we have
+	# problems and need to return non-zero.
+	if ! vm_start "${pidfile1}" "${ns0}"; then
+		return 1
+	fi
+
+	pidfile2="$(create_pidfile)"
+	vm_start "${pidfile2}" "${ns1}"
+	rc=$?
+	terminate_pidfiles "${pidfile1}" "${pidfile2}"
+
+	return "${rc}"
+}
+
+test_ns_global_same_cid_fails() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "global0" "global1"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_local_global_same_cid_ok() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "local0" "global0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_global_local_same_cid_ok() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "global0" "local0"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
+test_ns_local_same_cid_ok() {
+	init_namespaces
+
+	if namespaces_can_boot_same_cid "local0" "local1"; then
+		return "${KSFT_PASS}"
+	fi
+
+	return "${KSFT_FAIL}"
+}
+
 test_ns_host_vsock_child_ns_mode_ok() {
 	local orig_mode
 	local rc

-- 
2.47.3


