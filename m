Return-Path: <kvm+bounces-64847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BF695C8D3C1
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 231E84E718A
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB43832B989;
	Thu, 27 Nov 2025 07:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kju2PZAu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52DD3254A2
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229679; cv=none; b=o9JtoXIABai0eLsQ/XlhLFCqXzMSTma3/Z+CJIzDJgoDo+m5JQjDnR19GCQYXF0K/JTutgf+UZ4UFLr/NirX1ducd7vOTOWt7zhISJSBlvXbbOodppyn60/T1lXvv9A+mrtcytF4YRdvWnW84UM/ddQsAly26ZpjW/qipb18BcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229679; c=relaxed/simple;
	bh=+2R3w3S681rnHvviIO0MgWHpMBdTB9OzqHRpjlN2cZg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KzRa2Lf4VOcOtKX6cw6J2P6xfqbBsc/+1E+Cog3jCTBl5f4CGTiqO3t4v3nuDeFxQ+5npoWcPJvi/OeEsOVpPyd4sZ++UY7xnhFfK52YadznBjbcn91iqeSg8qj9eDU5/WoM32hlzH9xVOddEufgG7VXKorhMWEgf9OAml1Mibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kju2PZAu; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7ade456b6abso441338b3a.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764229672; x=1764834472; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njNVZdo2YcwUcrU7+c1XfJBjEkwYcrP/2uy6YKalASA=;
        b=kju2PZAuBZ7TglrcObJGqKgNmPOLsUAuiERbEPlkouTrZSOA65gONVkVaPzHTPV0P7
         X+ydosXFwx/SyxuFlE6N1uPzPuYmCANqVMp3CZlhZLDeT2/i0CHYuW0JjdcFeUCbQXry
         iyTyRxEQjj4tMq6Aq4+FOZhBesXyrpcxDpHaJLZZvF/E1VlUjVx1aMnzTsC8w8M7K5fg
         wl3M3kbSN1ItVix3PgPNZ6MtzHlVubTV0PYodx+9h0rrzgkfdvk0VGUpP96QwxrsSGWV
         imsqo3ZgifhpksjuRVnNU7HFdiNrRDd8HVY5BTWV2EazOK2SHCMY5wDj90sRVYie1DAL
         Cu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764229672; x=1764834472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=njNVZdo2YcwUcrU7+c1XfJBjEkwYcrP/2uy6YKalASA=;
        b=T0d/MALo8icF/ManB0lq+e0GagGqJKNr0nwkm57r/gLwj4p5Y6IvKPYQhRj7Ra0lGI
         eMxargc3DBh0jFCHUkoyp4HLJKBDEuPCpeuqJuR8sy1UnrGJueKazV7PUibbouWfzQmR
         HsbTrbDk+oIPq8luc/tlsJQh3mk6sowBbkDJEcodlqhGm0dhhmM4px7qe1XUNR1EkV+d
         y3PhEUAVT+PcK1e/bNBNXzHduEm/RRjuALlQMtB9GOu33hJdi/XfWps6fDD6X7Wufygk
         6yeaTKsm9jyp3/YZfgOP+coaFMTSXZqRC2OJbknESMv3lvbPmFiylE3bCs49WHhyB1n+
         XPvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBuwu9l2mfLEzttqVEAOrVSs9JVnjWJgDJcdBtC2wCloUd5YLbj+VaZu/R570xEV3K4ng=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrf7ro9qjtLMvG9i3P84UphyX8qAeHJ53a8Nga9F7rJbnFtG3l
	mj+6q38aU/P6WUwVCX9oJYjmPsMMb2XPjca60iyMx7/eWxWJWxj+qV3d
X-Gm-Gg: ASbGncsx3PBCd7oDGfTuaO14Za2OLjOVA9joP+3J3vtua0bHK9wFMSWMRaYEp1Wieib
	Qf0Pw/1Rekrz+BtrlniO4s8dpxuXHCpQFsRMvYobp71Lbfd0TMKyQ6nPW/EA34H32VKt29Vljva
	/WpLt/12yN/VY0x40M2RDVfZCpXYVWJ6wA/3WG0lEQtX9M7QdeoMmH79eHSFk/PV1ra2QGKAGjb
	TRwbbsvSpbGcq5egZaAFQMe/djwY/nTNKEUNOSH7hhFj51WU9C6u/x9VWOJNwqOpepth5yqu4sf
	0aITX/F3iNI+2WVpzFv7OzLushsczdyOZ9vRb26RmXt2U+i5WSmu4o8zD/FJX9YO0OffWl2uyQS
	lSRxlxKB1DIjyhKE050kkmqYECT+gFelYGlUGOLcCRfCR/jpueTqMMCzx9C2ltLYs1Xt1cpm7jH
	zgz3oxK+fU9Ubyg22zYds=
X-Google-Smtp-Source: AGHT+IEQLozRTu5+aaYZLmpX43UDWknuXMdbfEtxDJQmwd+GQgMyCjfBlGTu04L/oX1PAGiOiTHt+g==
X-Received: by 2002:a05:6a00:1383:b0:7b9:7349:4f0f with SMTP id d2e1a72fcca58-7c58988f7camr22478072b3a.0.1764229672558;
        Wed, 26 Nov 2025 23:47:52 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15fcfd0cfsm913324b3a.65.2025.11.26.23.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 23:47:52 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 26 Nov 2025 23:47:39 -0800
Subject: [PATCH net-next v12 10/12] selftests/vsock: add namespace tests
 for CID collisions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-vsock-vmtest-v12-10-257ee21cd5de@meta.com>
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
index 28b91b906cdc..ec18eb5b4ccd 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -50,6 +50,10 @@ readonly TEST_NAMES=(
 	vm_loopback
 	ns_host_vsock_ns_mode_ok
 	ns_host_vsock_ns_mode_write_once_ok
+	ns_global_same_cid_fails
+	ns_local_same_cid_ok
+	ns_global_local_same_cid_ok
+	ns_local_global_same_cid_ok
 )
 readonly TEST_DESCS=(
 	# vm_server_host_client
@@ -66,6 +70,18 @@ readonly TEST_DESCS=(
 
 	# ns_host_vsock_ns_mode_write_once_ok
 	"Check /proc/sys/net/vsock/ns_mode is write-once on the host."
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
@@ -576,6 +592,68 @@ test_ns_host_vsock_ns_mode_ok() {
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
 test_ns_host_vsock_ns_mode_write_once_ok() {
 	for mode in "${NS_MODES[@]}"; do
 		local ns="${mode}0"

-- 
2.47.3


