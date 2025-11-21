Return-Path: <kvm+bounces-64150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 048CFC7A3D8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 064DC2D7DD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24F2305040;
	Fri, 21 Nov 2025 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USc0mjoL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQp6Xp74"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C28E34678D
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763736201; cv=none; b=QRSTj7UsPKto3OJyf5NiWRHRjyP4CNaOr0XDpNDUE1wWt60WJpMo8aA9KAUO2d403hrtKks1qN+N3YGiwbXh3/2pCtJ75En71fQB1Nu5NnH/bpyOwuoS4YvjIcklGw0xLPnOSUf+EM2DIPyq81a7oFmwByI6SO0PhwaE3UPhFhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763736201; c=relaxed/simple;
	bh=PszHgCmhtccWSqI0eShhC4jyc/2aRHcMziGgYPJttHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9VILB1KR80Zx8j1fYh3R0g7LDd+4BYiAW6vViCW1JZbU/a8gDLv+0nroB7jUvGH9P9lUN1Rei/cJ3KlchUiRnJbQ+egsEcWrJF2hisEgKf/dL/pEF9/sPqxeg0A2hmetycljj6KE7p7qc8Z5+ztwnHxbt/Xw3MWqRYg8V/CS3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USc0mjoL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQp6Xp74; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763736198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OBmGxeL2mYyQ8HpRUGAyaocZQhEEGSfR+zrR8FYGGGs=;
	b=USc0mjoLY9qk7Rh3onM2fAJj20mL/dIfx6f/5YKI0cvY+b7XXsAsBV2VaoN42/oCSHOs1F
	5+3j7Po3mj5fEqYNtDudne1tz2TONvyE9HI4Fr37pP0tmdLvRl8MzEV99hSfCtFRYta08F
	dufFkEI4TbTLw1zDXrydHHWINicT610=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-2YeSjTNFPLeIjM9MvV1p_Q-1; Fri, 21 Nov 2025 09:43:16 -0500
X-MC-Unique: 2YeSjTNFPLeIjM9MvV1p_Q-1
X-Mimecast-MFC-AGG-ID: 2YeSjTNFPLeIjM9MvV1p_Q_1763736196
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429c5c8ae3bso1819365f8f.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763736195; x=1764340995; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBmGxeL2mYyQ8HpRUGAyaocZQhEEGSfR+zrR8FYGGGs=;
        b=hQp6Xp74WlF7NTyKiVv9DY394jegvfQxtadP4eAr9jkbWRLSwNm5gUPcLYeKK0t7MF
         7fmB5GUH2cb8VNhFAm8iEhXMwnEgGdTX19CgGyU7EH6fE5/ZBwaJ87BjqJORaxg2wVeW
         Ee2YfcBXwDmyUqM8biVpHKJpQwxjwvj2zeCv6q0xzs80eO2/GovXzRLkZ4aiuCdq3i87
         URIJMy7ezcseSnF+ohmkXjGKAjlUQ9EAGhRCjfd7+53uRsQfJqR1uIa37e8mvO/y9+4p
         MzRsIl65a57lKdg5ZNaqcz+SGK8nYAZ41AWYVWkTd/R83VfKu+0XI+R297u78WlN9Bvc
         YoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763736195; x=1764340995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OBmGxeL2mYyQ8HpRUGAyaocZQhEEGSfR+zrR8FYGGGs=;
        b=NuIMs6WXNKhpjPY4naopRtQzDjp6LLLdikKbxRUaUp+LiL58738cdZkmBgRB+HI02s
         IhuXKkt/vhknyMq6u666neYPRVpBliB/WY+xhHjtEYCIB5tOV83aDxSC+HRnSvu7tQe+
         QWwrbmXkCELOggLe0ymm9Ia7pHuSkWVPj5xbDNZSvlmdHanz0r//6V3S9s9eA2IzPtVe
         5h56ctjJBftu5M/7710XPDMkYrkAZFQKMBqij4B1a1tmCI+dE0H07TvcBmjV3XEc9dao
         wZDsxrWPzaopL9bvzcalYmKwE80+iM5vudzxNHxNW1WT3sFo6chut3xlgZPyabhf6kp2
         hWLw==
X-Forwarded-Encrypted: i=1; AJvYcCUTvn10jY0CmddWU2nRIgO2cUyIbLmPJHr84LInAXa19qcRnxp9TcmUb/MoGICgtniyHnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM3XuQOC0kx1YmTunrB7D/YD2PsRB3u/TsSRs/5DU2nisFoLQY
	g/1Z5GMPk27wXVZcMZ4jfYNfusDpFf/ppISM/357wHoFScrOOcsAal/LuD5mIceLLurNkY+lz3i
	fggHyJkIYumrm8M03wK0x/BlYiEGthRvEjGnPOcOph6E/J90sVOG0pQ==
X-Gm-Gg: ASbGncs2ncPDXpWa/GIh0RYWT7lkY522dL0RqQ1Ze8kBU+CqxYnsCo8wayBrM/2rDS0
	AqEPKCl0YYFhstWAS4VJ2P43j8a6iYxdH5qwaTZqqrcoxmD1G7cX4XYRwCeShSaERKyaeID4AbC
	St4eGlEcazko4UJsfoV/3i190H3/3LEOvKQe32J5PmG9lWvBy4bnXLeibBt2w1PPLHuzpOO8IfG
	PifVLd3bYrWMjNlw24koBChxz1HjQXm37yyKGr7lHA7nGADWPrzIpkcKGrYBkbajAcKtVYCecEI
	zCltD+JbKVSUXct2R7I632cP610IR1S31A9Fr+iQkx0ij4WrAmGdd4Av6klj0vB3IAm9I5RBfAL
	YzoG1PXtcJXcav3GhjhWRrsMtO5q6szlnwIiTv26mCSrhYlJOFbmN+yIxZ4sp1Q==
X-Received: by 2002:a05:6000:2309:b0:429:b525:6df5 with SMTP id ffacd0b85a97d-42cc1ac93f4mr2817363f8f.3.1763736195485;
        Fri, 21 Nov 2025 06:43:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVXLVg+JpBLsM02kGG0z5u+UchXN/0lwnkDZob5QhAzEG71T30I0VsCqdgircvn6smhqXRBQ==
X-Received: by 2002:a05:6000:2309:b0:429:b525:6df5 with SMTP id ffacd0b85a97d-42cc1ac93f4mr2817326f8f.3.1763736194935;
        Fri, 21 Nov 2025 06:43:14 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f34fe8sm11445022f8f.15.2025.11.21.06.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 06:43:14 -0800 (PST)
Date: Fri, 21 Nov 2025 15:43:04 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, berrange@redhat.com, 
	Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v11 09/13] selftests/vsock: use ss to wait for
 listeners instead of /proc/net
Message-ID: <cmi23sbmgpmphjldjgsrronysce3r7zyptcrsqwqa6j5i26m4u@s5wscydfdgpo>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-9-55cbc80249a7@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251120-vsock-vmtest-v11-9-55cbc80249a7@meta.com>

On Thu, Nov 20, 2025 at 09:44:41PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Replace /proc/net parsing with ss(8) for detecting listening sockets in
>wait_for_listener() functions and add support for TCP, VSOCK, and Unix
>socket protocols.
>
>The previous implementation parsed /proc/net/tcp using awk to detect
>listening sockets, but this approach could not support vsock because
>vsock does not export socket information to /proc/net/.
>
>Instead, use ss so that we can detect listeners on tcp, vsock, and unix.
>
>The protocol parameter is now required for all wait_for_listener family
>functions (wait_for_listener, vm_wait_for_listener,
>host_wait_for_listener) to explicitly specify which socket type to wait
>for.
>
>ss is added to the dependency check in check_deps().
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> tools/testing/selftests/vsock/vmtest.sh | 47 +++++++++++++++++++++------------
> 1 file changed, 30 insertions(+), 17 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 1623e4da15e2..e32997db322d 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -191,7 +191,7 @@ check_args() {
> }
>
> check_deps() {
>-	for dep in vng ${QEMU} busybox pkill ssh; do
>+	for dep in vng ${QEMU} busybox pkill ssh ss; do
> 		if [[ ! -x $(command -v "${dep}") ]]; then
> 			echo -e "skip:    dependency ${dep} not found!\n"
> 			exit "${KSFT_SKIP}"
>@@ -346,21 +346,32 @@ wait_for_listener()
> 	local port=$1
> 	local interval=$2
> 	local max_intervals=$3
>-	local protocol=tcp
>-	local pattern
>+	local protocol=$4
> 	local i
>
>-	pattern=":$(printf "%04X" "${port}") "
>-
>-	# for tcp protocol additionally check the socket state
>-	[ "${protocol}" = "tcp" ] && pattern="${pattern}0A"
>-
> 	for i in $(seq "${max_intervals}"); do
>-		if awk -v pattern="${pattern}" \
>-			'BEGIN {rc=1} $2" "$4 ~ pattern {rc=0} END {exit rc}' \
>-			/proc/net/"${protocol}"*; then
>+		case "${protocol}" in
>+		tcp)
>+			if ss --listening --tcp --numeric | grep -q ":${port} "; then
>+				break
>+			fi
>+			;;
>+		vsock)
>+			if ss --listening --vsock --numeric | grep -q ":${port} "; then
>+				break
>+			fi
>+			;;
>+		unix)
>+			# For unix sockets, port is actually the socket path
>+			if ss --listening --unix | grep -q "${port}"; then
>+				break
>+			fi
>+			;;
>+		*)
>+			echo "Unknown protocol: ${protocol}" >&2
> 			break
>-		fi
>+			;;
>+		esac
> 		sleep "${interval}"
> 	done
> }
>@@ -368,23 +379,25 @@ wait_for_listener()
> vm_wait_for_listener() {
> 	local ns=$1
> 	local port=$2
>+	local protocol=$3
>
> 	vm_ssh "${ns}" <<EOF
> $(declare -f wait_for_listener)
>-wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX}
>+wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX} ${protocol}
> EOF
> }
>
> host_wait_for_listener() {
> 	local ns=$1
> 	local port=$2
>+	local protocol=$3
>
> 	if [[ "${ns}" == "init_ns" ]]; then
>-		wait_for_listener "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}"
>+		wait_for_listener "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}" "${protocol}"
> 	else
> 		ip netns exec "${ns}" bash <<-EOF
> 			$(declare -f wait_for_listener)
>-			wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX}
>+			wait_for_listener ${port} ${WAIT_PERIOD} ${WAIT_PERIOD_MAX} ${protocol}
> 		EOF
> 	fi
> }
>@@ -431,7 +444,7 @@ vm_vsock_test() {
> 			return $rc
> 		fi
>
>-		vm_wait_for_listener "${ns}" "${port}"
>+		vm_wait_for_listener "${ns}" "${port}" "tcp"
> 		rc=$?
> 	fi
> 	set +o pipefail
>@@ -472,7 +485,7 @@ host_vsock_test() {
> 			return $rc
> 		fi
>
>-		host_wait_for_listener "${ns}" "${port}"
>+		host_wait_for_listener "${ns}" "${port}" "tcp"
> 		rc=$?
> 	fi
> 	set +o pipefail
>
>-- 
>2.47.3
>


