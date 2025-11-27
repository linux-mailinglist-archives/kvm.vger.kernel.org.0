Return-Path: <kvm+bounces-64844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8A3C8D3BC
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D944B347823
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04DC329E59;
	Thu, 27 Nov 2025 07:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WikHZaK9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6284E324B3E
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229675; cv=none; b=fcw4q1Av/8K6g09DfYUEbPZAetTLh2t2xtRYYFpGAiw9Hl/vdyEHMuKfGd7zOaXQBxQZ9JMCtdEqeLwjEYZvGigBKFE2GaxKo2fFtYt4g1JQvpDrbD0ReOVbVIa3cTEOudiQMPm81ZmqvHy0s+rfcro1GMrliUrmHarNAOTBeHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229675; c=relaxed/simple;
	bh=VXSznUA/qrGw37DlDQ/ITpl+vbnJQhBZAvRQarakHeE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=soFCvqHrgzqeSVOcQ9xg5+tNvey0/GBIgCPsY2SGCzgwCRhVKD8cH80UVvj+MsxFAn5PN85GDytYfj33BKDspCZLKRv7hQ9+oKqIdm6G6OiA7Y5jLTTUwttegY0XaCS1MfYZTyNdZ8o9HTPCBFbZ8XRwxUR7IEWSHRTrguyanLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WikHZaK9; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-343ea89896eso570017a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764229671; x=1764834471; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81Yb0D7xNXy+MdzfxaynPdllQZqiJyMZrUjJeETwoWg=;
        b=WikHZaK9uCb14sc9tWk1a8ahDKOQyP5MPHTQTTvBDi5x3sUPb7U0JOZRLNS5T0fKdv
         7Yl5tInXpO1ZnwaO/cmAkRQ3YIcCRZRfELueqV2YwpDOLKlkSEm/NA1KMa1h026h1PYD
         QrjmMSLDKVFZIyPue1ElrVhA8L6B/3Ax3o+XOfIY3U8GpPI6CHlLlxItXVa6WINpVrmy
         3nu/f/yncbUbXh/iMp+7XAN3CP3/kHXuuHIf6ibWBdFeDqnKuX480DQxAxHZM9zpBn+p
         Z8hdNBq/XGmEBjp9rNP9w3ZoepkYXgmil3X6/0CVnrR5Ve4F8PVl0eQ8OJ1+yH74JIuy
         vmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764229671; x=1764834471;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=81Yb0D7xNXy+MdzfxaynPdllQZqiJyMZrUjJeETwoWg=;
        b=SKkM9sInt5Chf44y5Ts0uSxeFrx9wHqBrAhW19xWS+14FJ+rbzWqMuZTOPDMFlQnKK
         XtNWnfskELYKwt/sTvhNwH+ktaA2Fqxdk0kZyXAsz7vVE9CmpDZw0acz5F+ft+cAm7Ui
         k5lSBP7SF3ILIC8O4NiyVySLXO7dr85gsgL+T1HmMbipSRvk7bcSgDOXNXJZykdaetm8
         +ddwHzVV/0q5VplwiFjMtWj/DNqOb8CzPXzJxOWLJO9EQup2W8cy/rlEYkznjMvHtDf6
         uP6H32CdGqMlTRjrDYlSafr5gilu/1W7FbbiaVBTAvJ6Jm/UCm/fAkV/abV7DnA+Ocnr
         DBTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwnHg7Jpe8wwrBTZrbPMhZ1bfvEMJtI+L+Cai4xc+sKhz21VK7tr66QMTVsQJ6Lg7OUVA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8xr1H8QkpgXGVdblttwslz6vngtZdU0vp2QePQp05C4M1hctp
	UJN3PWPN8+gd9MTVc5CbV5Ccdljhd0Q8UWWMvctVjoGSwpzEffYo65NP
X-Gm-Gg: ASbGnctDwdHbcGi3v8zzIbZef8bPd1zQ/bZppNe07HrUct6Ot6PzwOmenpnbbMC9FBi
	V/+g2PqFfFlWHIpPSvOyKlwBzbraJAutKZlQrWUMNBP1yBUkA66BD/Ib8VtZEOjI9w2XJCokKMk
	dtueHKXxLnpsDvMi3Ga6ugT80DMbAb0Yb6z9QKNcsRpIH0Ad5O3yCt+aZ92IVKwUyBEs6/G5fPk
	xOebuhxLWV9m6bo6eA89ppsRwrYOJ2xjeCXQGA24MXgWuJrJxwn3EJAQ10zIVBHG/yNrWRcCrsg
	UYmdi4cyqSnKV7yexxr9rK3bSMo8hpNeQRZrWtsIJx+ZanWlKsDtnQsjMYWjHsVWdBMS+KvIFqw
	n6dbDRUCAPLe3IcYjWOVcTNeBSt/XiZdRvGD4P2sZv/w4OGe0krQgShQjv6gCzyXPz4x2ajob8j
	kH3GCsjEIX7uDDHmTgeDg=
X-Google-Smtp-Source: AGHT+IHm9n1hN/MXgqh8Fst0OOiMbfzgNDndic/dBuz4wSklQZaHZ2bC0MkEgH2q8ls+YwLmQfHTOg==
X-Received: by 2002:a17:90b:4c48:b0:32e:5d87:8abc with SMTP id 98e67ed59e1d1-34733f3f6d5mr19204188a91.36.1764229670667;
        Wed, 26 Nov 2025 23:47:50 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be5095a0e65sm989665a12.27.2025.11.26.23.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 23:47:50 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 26 Nov 2025 23:47:37 -0800
Subject: [PATCH net-next v12 08/12] selftests/vsock: use ss to wait for
 listeners instead of /proc/net
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-vsock-vmtest-v12-8-257ee21cd5de@meta.com>
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

Replace /proc/net parsing with ss(8) for detecting listening sockets in
wait_for_listener() functions and add support for TCP, VSOCK, and Unix
socket protocols.

The previous implementation parsed /proc/net/tcp using awk to detect
listening sockets, but this approach could not support vsock because
vsock does not export socket information to /proc/net/.

Instead, use ss so that we can detect listeners on tcp, vsock, and unix.

The protocol parameter is now required for all wait_for_listener family
functions (wait_for_listener, vm_wait_for_listener,
host_wait_for_listener) to explicitly specify which socket type to wait
for.

ss is added to the dependency check in check_deps().

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 47 +++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 1623e4da15e2..e32997db322d 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -191,7 +191,7 @@ check_args() {
 }
 
 check_deps() {
-	for dep in vng ${QEMU} busybox pkill ssh; do
+	for dep in vng ${QEMU} busybox pkill ssh ss; do
 		if [[ ! -x $(command -v "${dep}") ]]; then
 			echo -e "skip:    dependency ${dep} not found!\n"
 			exit "${KSFT_SKIP}"
@@ -346,21 +346,32 @@ wait_for_listener()
 	local port=$1
 	local interval=$2
 	local max_intervals=$3
-	local protocol=tcp
-	local pattern
+	local protocol=$4
 	local i
 
-	pattern=":$(printf "%04X" "${port}") "
-
-	# for tcp protocol additionally check the socket state
-	[ "${protocol}" = "tcp" ] && pattern="${pattern}0A"
-
 	for i in $(seq "${max_intervals}"); do
-		if awk -v pattern="${pattern}" \
-			'BEGIN {rc=1} $2" "$4 ~ pattern {rc=0} END {exit rc}' \
-			/proc/net/"${protocol}"*; then
+		case "${protocol}" in
+		tcp)
+			if ss --listening --tcp --numeric | grep -q ":${port} "; then
+				break
+			fi
+			;;
+		vsock)
+			if ss --listening --vsock --numeric | grep -q ":${port} "; then
+				break
+			fi
+			;;
+		unix)
+			# For unix sockets, port is actually the socket path
+			if ss --listening --unix | grep -q "${port}"; then
+				break
+			fi
+			;;
+		*)
+			echo "Unknown protocol: ${protocol}" >&2
 			break
-		fi
+			;;
+		esac
 		sleep "${interval}"
 	done
 }
@@ -368,23 +379,25 @@ wait_for_listener()
 vm_wait_for_listener() {
 	local ns=$1
 	local port=$2
+	local protocol=$3
 
 	vm_ssh "${ns}" <<EOF
 $(declare -f wait_for_listener)
-wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX}
+wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX} ${protocol}
 EOF
 }
 
 host_wait_for_listener() {
 	local ns=$1
 	local port=$2
+	local protocol=$3
 
 	if [[ "${ns}" == "init_ns" ]]; then
-		wait_for_listener "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}"
+		wait_for_listener "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}" "${protocol}"
 	else
 		ip netns exec "${ns}" bash <<-EOF
 			$(declare -f wait_for_listener)
-			wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX}
+			wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX} ${protocol}
 		EOF
 	fi
 }
@@ -431,7 +444,7 @@ vm_vsock_test() {
 			return $rc
 		fi
 
-		vm_wait_for_listener "${ns}" "${port}"
+		vm_wait_for_listener "${ns}" "${port}" "tcp"
 		rc=$?
 	fi
 	set +o pipefail
@@ -472,7 +485,7 @@ host_vsock_test() {
 			return $rc
 		fi
 
-		host_wait_for_listener "${ns}" "${port}"
+		host_wait_for_listener "${ns}" "${port}" "tcp"
 		rc=$?
 	fi
 	set +o pipefail

-- 
2.47.3


