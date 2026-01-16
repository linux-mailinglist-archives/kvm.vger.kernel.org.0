Return-Path: <kvm+bounces-68405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E70D3889C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4FF8C30474A6
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2393A782D;
	Fri, 16 Jan 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+J7wDKz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECA6314D1B
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768598957; cv=none; b=LIR8BXpNGx8g22p1rOgzrvNQStwNRFv8vk9yiDI+/vzmsh9VQ5c+YBSr6/OVY2dhJBKLOZmT3ICGN4WNJTtw3SzRtn6kchYmV3QUD8S0gnEkOai6LzPT1rNwyCcIxbhrkgP5IB5XM+/dcuUi11nuv2+mjMHTbSg2ur/AjcAKc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768598957; c=relaxed/simple;
	bh=43YZlXDQmW65hszyjr5m3UtpfpB8+72+oSXEtxR8B+c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O+S73Faot+x3hrICyBWZm/4Ni5ONmlzMYf26DJPEQ7KUtlkZghJe+2bphi97ZmwJiDfduEenc83HnQ+YZg+7gH5NspVS78j984B/Z75nTq3gW/SMvmW2Ce93ULwdKpCQAlRP9yO/97AxVzT01wuUd+RPg69tXrhV6hzwQx8KuWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+J7wDKz; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78f99901ed5so23485587b3.3
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768598952; x=1769203752; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3I8QcIsIeOrh9cIrz38ZjjL+G5z3ujRC9KA0ugGud8=;
        b=a+J7wDKzdI1mlppUc/PLN0epC9FKHMylZ9qQ7pjLvDrF2NQ816/qpleabYhKpysNn5
         WCsm3sBt7ZIuz8NMJBOJzIcE38lAGLol06hqMZF7wzF9RnvgKQwW8dP0mYpSFWFwKmtB
         MpV/pVvgsa417gDMCpjvE66PucWD5ES9Zce2IRL+ZcGk1KFZc1calnP2piQ8DQ/GvX0r
         SwdOX9mw3/++2/Dk6ue2ibRSC9sb5KyKo+5Sy1kpqSlJ3+dX4mSIpVLgnsGS82l+2lsy
         K193RTcJBZ66ErcbCrrwE5GS1m/oeR87fx1bPfm5BA3caHxrjvwRLYq1SAjnyESQiBGe
         suqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768598952; x=1769203752;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y3I8QcIsIeOrh9cIrz38ZjjL+G5z3ujRC9KA0ugGud8=;
        b=un5T1WmVMGMcl7+yLcQDpc/WaCYUCMwmuHlVcaiQUt7vfLzNyzwATiWCZoSuxal/0z
         t/3AWSeziLZvf2SHB4aGOL542Tp5N+csBBjStPC/E3tXxOLxUlpuXsAf7ajT9CF2O9+B
         1UstJgwpPLbt658JyAzuK3uyQ9DnpdIyO66wKwCG58IU93WyI5plf9+eUCLe/1e8wRbL
         QeRXvZJMl3jlgc+kdRhp3o8DGRLMhkHbIIhWLMqiv+G8rnJslKwZhcBxX1uQBAsy5Tai
         iozK3LFgKrR11ISVjKj2d1xHEVd1LPVHPigRQYtUkkEhXtGlDNsVqpDTvDZlDTOq796z
         t8UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOgyWOleeqDpLc7O/4PfUD7Oyn6T3bCWaew7Aq+PeoPdo4CwDG2JAWACcaVHWmfIhHnAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLR7wYx+HdeZHP+ePYpt/jZLQesEqdzH7rsp7lPdLZw3PDpjtM
	q/XLLhN7rG7lrUVCDeICuLbhDVQDvNN1Wh2qNtXg9hfa9GyTTPfNmry6q/tIlQ==
X-Gm-Gg: AY/fxX5t43AwKS7xreKsHDCTNqSKnGqb875KdXv0q1dUAh+xKXGslHfNb09opx6TuhF
	1lQAVBBRHHKPnfPDVh5uyGC8DjRNAY9SiECvh+ocjgvalDxOCxjl8LbnFwZY2mxi53hlJ7w/gt+
	whANr669qKrP8OxbgzXRox+BpKH+Khbcy1nqbsX2rR3jsEwr25IYkVh7HM1W5o46ka0sNxrBkgM
	FKtF8C/3EatHGUVnaq6dRP1WOHy6TWjsimnn/KTF1l/ZRdD7Ure76b0cz7wfQVeL4MCgSUuePVC
	6Hm3xw6O08wHJfSA092o60yuZ2hPBLDHSk4z0AlpKJtV3hSZtytjJh2hNXyCBNziBIy7SX9CJqv
	9ZXvCTbUTu2LVDxv1rVARAJjOesbj/7LQKdgfk1GyfwF9SKcbYdYrSYKimn2/5FIaPoP0k+ffhC
	OAhdD76Yr5/CjTY5zKCK0=
X-Received: by 2002:a05:690c:883:b0:78d:6657:fd1a with SMTP id 00721157ae682-793c5393f96mr32809527b3.37.1768598951767;
        Fri, 16 Jan 2026 13:29:11 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66ed7a1sm13166067b3.14.2026.01.16.13.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 13:29:11 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Fri, 16 Jan 2026 13:28:50 -0800
Subject: [PATCH net-next v15 10/12] selftests/vsock: add namespace tests
 for CID collisions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-vsock-vmtest-v15-10-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
In-Reply-To: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, 
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


