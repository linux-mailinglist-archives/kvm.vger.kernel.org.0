Return-Path: <kvm+bounces-60769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B80BF959E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B85FE502C65
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7013A2F5305;
	Tue, 21 Oct 2025 23:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/25T2Bd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E3C2E54DB
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090435; cv=none; b=IRMu8rW/fANLIj/pCr0PZDPo7HFCowUsfUz8UJ/LdKYLbz5FbBj5O5Zv8eUk/c/i3PLxx0mkE8b1ZBSt620rRSvnsUFYQiR/dOTG9/r6w4BRTCbgsbbaqM5pXV9VhlFQd38qQlSgIPiCFzS6PFLtHd+XAU97avMlRVqshSVmL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090435; c=relaxed/simple;
	bh=1TJpetkZxtBQiB7nUe4Rc6HDEslWsfWsLeGiK/zQyW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hf7JMUuCnOlrdFIbc+DL/9vFY6Xww7ij1ORIYxCTa12r++kv2WOgehJG3PPGNtlIPDtAVipXc36PCVyKm8KyEV79CRMm14IRP2OrfJ/t440JIWAj8X7EMfY/bfrCEdlfv6sX9W2uUFh+bvBcQmeqGJB/2SBnkm+d7IFQSV9GApc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/25T2Bd; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-781251eec51so4910653b3a.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090429; x=1761695229; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bp4Nw6yXc3Wo3rOJsEv9cE/uO6VvL+09gH92ff2ezzc=;
        b=T/25T2Bdj+e1EgSp8QyZaPBc6GRNHzdwS8hilo/vEDQREmT84YiYUYxl4K9+WjY4rS
         ZsoElTzdHbxvUMcIi+boXwJqGqzpqTaop95hmNc7uSXn9h/QJBw/MnvRqoXiF5rCkXsn
         /hG1Jixn+Axlett/YZcVSVz4+IdktVd7h10FBFEdozP6BlBsnKmrGqmJ1Z4VXO+JH/Os
         hBkKCvN4wOCEM++6PMIy62lhVrRcxdSQ5td3+47692sK4T3lNkmOEisJFK2paNLDuUcr
         me42/3zOs4jwDSe8/pACiPmpS0ZzBYCNJLoCHJbUqe5Bm6FGhVIC3rDXbqbRHjCWrQfv
         Lskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090429; x=1761695229;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bp4Nw6yXc3Wo3rOJsEv9cE/uO6VvL+09gH92ff2ezzc=;
        b=LSgu9WnfHOta4fKcsShZEpNaVjE11WOOAh9M6seft4sLggCE9DjNoJY2rxvtjcf99q
         yeebO+EmY9Ors06tYEn3Cs1HDovmIh7xjMdmOinMFIPttEG2/PPX7nds5Er+RJRDq1of
         7rTwzrFcClN0CTm+G0Uf9ffpCIv6LO8ZO7Ydl3nnk0rMPScAnBAKNbNNt/wR894OKoxQ
         hSeD27t9seSS5j6X58PMcJY3vsOM9pnsji3g8XT5fXtk7j7tqXrTtn7rIgsXN+SJXZRd
         lERuaKSv8zwbBAwyFI8F9YR0ZOBqtMgD89FLAsiP41VaGcKkuyX1WpGwQWSZnVjjxZYN
         /e0g==
X-Forwarded-Encrypted: i=1; AJvYcCW/71rVuht63hMN/g7tH+jDw11WvW6fnhAbamBGJRbyIkuh+WkKrHz9fx/RtE53GZxodBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqFLpg0eC0Baf7sXcL6/J2UG5WwSZ5ZR5LHc0BQM3t+VmPnad0
	JS14pEtGMzCMhgGIJdU+bb7NQlKbMX7mnp6Nu1fT3/bcOH4PmSSzH7nu
X-Gm-Gg: ASbGncuB+t3sdn6xvXyL4OUV+PFUMaTnC8Rq85ZPm2vN0cq+atYK/3hMU+rlik82SKS
	PL1A60ZQ6vmVbhPGalkS2vST0cV2TocedJbNn11paRs8TWxkoOXzWEdSA0YwtZArBsVlKtawjLZ
	5RuXmWg4rIWWXTcvTswOGQJXcTftsNImifRdA88sydxbMwlcGbvW6InjfTrQq5lTOpWcKJq6zi4
	Nq/u6zQ0ekiuoVt9FzGseyePI28E8UlPv7wbxh5/p/PDg2s9AfNlPjOReeMIvxInaP5pAA5y8tJ
	qE3aogal47fbg/ql73XpiErYKdptQIbPDA+DrHlLTVkZsowCauAridGZQWoYedaJqLP3uiVi1d8
	5D4+o9U/JXELBlL2Og6cNlIZY8HHzwCoMWF4lyiZYlebbc6djELXbqVLjWjUCx+K71psthfT77w
	8KKzg+org=
X-Google-Smtp-Source: AGHT+IFtE7kUaxGGBCIPvCA5xq+X+CjTxjkLXDamZJvTdeDWKXgLXL+jJ+B0+JzhKzpp/1MhbmJcug==
X-Received: by 2002:a05:6a21:7e8a:b0:338:614f:aac4 with SMTP id adf61e73a8af0-338614fab5amr6788012637.29.1761090429512;
        Tue, 21 Oct 2025 16:47:09 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:5::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a25f41ad15sm2272286b3a.41.2025.10.21.16.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:09 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:46:54 -0700
Subject: [PATCH net-next v7 11/26] selftests/vsock: avoid multi-VM pidfile
 collisions with QEMU
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-11-0661b7b6f081@meta.com>
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

Change QEMU to use generated pidfile names instead of just a single
globally-defined pidfile. This allows multiple QEMU instances to
co-exist with different pidfiles. This is required for future tests that
use multiple VMs to check for CID collissions.

Additionally, this also places the burden of killing the QEMU process
and cleaning up the pidfile on the caller of vm_start(). To help with
this, a function terminate_pidfiles() is introduced that callers use to
perform the cleanup. The terminate_pidfiles() function supports multiple
pidfile removals because future patches will need to process two
pidfiles at a time.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 51 +++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 29b36b4d301d..9958b3250520 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -23,7 +23,7 @@ readonly VSOCK_CID=1234
 readonly WAIT_PERIOD=3
 readonly WAIT_PERIOD_MAX=60
 readonly WAIT_TOTAL=$(( WAIT_PERIOD * WAIT_PERIOD_MAX ))
-readonly QEMU_PIDFILE=$(mktemp /tmp/qemu_vsock_vmtest_XXXX.pid)
+readonly PIDFILE_TEMPLATE=/tmp/vsock_vmtest_XXXX.pid
 
 # virtme-ng offers a netdev for ssh when using "--ssh", but we also need a
 # control port forwarded for vsock_test.  Because virtme-ng doesn't support
@@ -33,12 +33,6 @@ readonly QEMU_PIDFILE=$(mktemp /tmp/qemu_vsock_vmtest_XXXX.pid)
 # add the kernel cmdline options that virtme-init uses to setup the interface.
 readonly QEMU_TEST_PORT_FWD="hostfwd=tcp::${TEST_HOST_PORT}-:${TEST_GUEST_PORT}"
 readonly QEMU_SSH_PORT_FWD="hostfwd=tcp::${SSH_HOST_PORT}-:${SSH_GUEST_PORT}"
-readonly QEMU_OPTS="\
-	 -netdev user,id=n0,${QEMU_TEST_PORT_FWD},${QEMU_SSH_PORT_FWD} \
-	 -device virtio-net-pci,netdev=n0 \
-	 -device vhost-vsock-pci,guest-cid=${VSOCK_CID} \
-	 --pidfile ${QEMU_PIDFILE} \
-"
 readonly KERNEL_CMDLINE="\
 	virtme.dhcp net.ifnames=0 biosdevname=0 \
 	virtme.ssh virtme_ssh_channel=tcp virtme_ssh_user=$USER \
@@ -89,17 +83,6 @@ vm_ssh() {
 	return $?
 }
 
-cleanup() {
-	if [[ -s "${QEMU_PIDFILE}" ]]; then
-		pkill -SIGTERM -F "${QEMU_PIDFILE}" > /dev/null 2>&1
-	fi
-
-	# If failure occurred during or before qemu start up, then we need
-	# to clean this up ourselves.
-	if [[ -e "${QEMU_PIDFILE}" ]]; then
-		rm "${QEMU_PIDFILE}"
-	fi
-}
 
 check_args() {
 	local found
@@ -188,10 +171,26 @@ handle_build() {
 	popd &>/dev/null
 }
 
+terminate_pidfiles() {
+	local pidfile
+
+	for pidfile in "$@"; do
+		if [[ -s "${pidfile}" ]]; then
+			pkill -SIGTERM -F "${pidfile}" > /dev/null 2>&1
+		fi
+
+		if [[ -e "${pidfile}" ]]; then
+			rm -f "${pidfile}"
+		fi
+	done
+}
+
 vm_start() {
+	local pidfile=$1
 	local logfile=/dev/null
 	local verbose_opt=""
 	local kernel_opt=""
+	local qemu_opts=""
 	local qemu
 
 	qemu=$(command -v "${QEMU}")
@@ -201,6 +200,13 @@ vm_start() {
 		logfile=/dev/stdout
 	fi
 
+	qemu_opts="\
+		 -netdev user,id=n0,${QEMU_TEST_PORT_FWD},${QEMU_SSH_PORT_FWD} \
+		 -device virtio-net-pci,netdev=n0 \
+		 -device vhost-vsock-pci,guest-cid=${VSOCK_CID} \
+		--pidfile ${pidfile}
+	"
+
 	if [[ "${BUILD}" -eq 1 ]]; then
 		kernel_opt="${KERNEL_CHECKOUT}"
 	fi
@@ -209,14 +215,14 @@ vm_start() {
 		--run \
 		${kernel_opt} \
 		${verbose_opt} \
-		--qemu-opts="${QEMU_OPTS}" \
+		--qemu-opts="${qemu_opts}" \
 		--qemu="${qemu}" \
 		--user root \
 		--append "${KERNEL_CMDLINE}" \
 		--rw  &> ${logfile} &
 
 	if ! timeout ${WAIT_TOTAL} \
-		bash -c 'while [[ ! -s '"${QEMU_PIDFILE}"' ]]; do sleep 1; done; exit 0'; then
+		bash -c 'while [[ ! -s '"${pidfile}"' ]]; do sleep 1; done; exit 0'; then
 		die "failed to boot VM"
 	fi
 }
@@ -507,7 +513,8 @@ handle_build
 echo "1..${#ARGS[@]}"
 
 log_host "Booting up VM"
-vm_start
+pidfile="$(mktemp -u $PIDFILE_TEMPLATE)"
+vm_start "${pidfile}"
 vm_wait_for_ssh
 log_host "VM booted up"
 
@@ -531,6 +538,8 @@ for arg in "${ARGS[@]}"; do
 	cnt_total=$(( cnt_total + 1 ))
 done
 
+terminate_pidfiles "${pidfile}"
+
 echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
 echo "Log: ${LOG}"
 

-- 
2.47.3


