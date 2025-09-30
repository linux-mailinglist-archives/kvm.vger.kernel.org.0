Return-Path: <kvm+bounces-59128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3BDBAC154
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:38:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED26320B7E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCCC2F5301;
	Tue, 30 Sep 2025 08:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oqhtu44L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2810B24501B
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759221489; cv=none; b=rDilhCzHQylFwxLfHU3rXFOGSeK+c8diygLrkK8SPsHbdeXeBjhz/ejy3YR3e/V1u9AnLUyhRyeCMuoQ16u27wIXDfpa70/e3bUfauFbyMZfrA3tVxA3tlmL3BfWV9Fp00DBPddsRjOCGr9EuhOCmow8ZNLW+SaODSVoeXUIn5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759221489; c=relaxed/simple;
	bh=xnpiQCURkOhfQrdwgPHiUaP8a9tkI+p9FQwCHjcwcds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsC4Md0SuRnBaEMUEQQkoLW8cT1KGMxI2EO4BOwHMSlbCubafKuPD9s88LOmCYsCaWi1VR3iECJi1zRnHdSZu57ms48BziuYS1A/GXWbHatSWqEzEfQLwG5yBnLB86eG10QlOoNwhbozEORgigxZRIB9lgvVZJezylTqSULn4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oqhtu44L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759221487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VccAC6xB6U34Xf9cLOXrFM7PAx88aOBuUi8cY9wyl/8=;
	b=Oqhtu44LdefZTEtnRlAU86tDGUtvaHPBxDbKCCUJF55zlZVZqkhCZsfwIqGG6y0RqiCrp2
	SMFrIL4DwVtEnrHBR7mKM+EMuutBBTKUFQhqBPT9LmrnTTdYNrOjh/LMjKPY8WrSQQguLB
	cmgd0PvWja0nLTwT3Of2+tYPJJ0GGPc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-Rqwms0FCMoyxpWNEF5lBpw-1; Tue, 30 Sep 2025 04:38:01 -0400
X-MC-Unique: Rqwms0FCMoyxpWNEF5lBpw-1
X-Mimecast-MFC-AGG-ID: Rqwms0FCMoyxpWNEF5lBpw_1759221480
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e4cc8ed76so15056005e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759221480; x=1759826280;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VccAC6xB6U34Xf9cLOXrFM7PAx88aOBuUi8cY9wyl/8=;
        b=TcytoMQ6TxnDloVwJ+ptgOwNTFYPJCgVftvlxYGchrAekxLlXt5OunoGdY4dVt1Mn3
         UqMMj5JO4t3/ns3OH8nWTpQzsfVlkSzsAw02jx3c0R9AJG8/OnIXDqDAd4Vv+2tyCvaL
         noFB/YD3slD5kGJAjs+qUmGCF4i+QOa19rQZEaeo+hMZlNkqOmGudmKS6hdVL9TN6wxa
         sfNgr2iNxoT7FpTxhjqzCE9+Mz86db1tlCz4emzNGnnU4kMEly976/lkS1cqBJR12Go4
         xMFS0Lm4ThHboKuzuPWWrgj5ZTjJKhwbGIroal5ad5r156WJXeKAULXmbWBtHfnVxwvn
         HsEQ==
X-Forwarded-Encrypted: i=1; AJvYcCViA2diQcMn4bLnshEq4PioBnrVDsvS63P0Uz/r4jApG+9z33UPD+/wOhR49CDTRqqsy10=@vger.kernel.org
X-Gm-Message-State: AOJu0YymTXHNpFg43hNz/vP0dlN4KDxN2UF0+1jrUuoik6Ih6OzNmnAr
	Sg5O7/bDy9h9bKVVlUIwS4tz6gXR4+neYfP65gxKV0lyrsB3XgLMrq9k+njLB0tbt+RtCp/5MSW
	xSjLhdoqUDCcNThxZJIpMLgp47hZq2FPr6FmIzezOgFcFyp7GHk6quA==
X-Gm-Gg: ASbGncsULcKgkX1XuMBCy+eJHSNWbLjZrSKTi/ZB4rBAtlvEqfhXXrx0PsuDteQb7n3
	vSnZQnpZUWgSq0pbXJUihl7zouygQy3dGVQ5BleNclSqwx4T8XdCM9SUYMGeEmToyfwoEZzUBRy
	55geAL7q5WVDCFULA56XqWdz0YjQvBV/S6rbzyaBYw3gwkelkfeTRoBLXoioT21s3rrkKd1oQ8b
	Gq1oCWF279aYMjtAxKnUbv9T3W950olA3TzB/Wibn3xzFCaiSndMgOEZHuhOlpgzC/RssiyvtKQ
	nSDW09dxn5eeXzUeyoWd3HQJKo0jZT8fElZGjY3XnxnBEopvTmdsAGSHr+HjjTZQMct5rW1jKqt
	kakX+LGnISL12OhcO+TchSQ==
X-Received: by 2002:a05:600c:1f86:b0:46e:3d41:5fed with SMTP id 5b1f17b1804b1-46e5da8bd67mr7433005e9.11.1759221479615;
        Tue, 30 Sep 2025 01:37:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGO1GaSyS8oGmkfg/b3GKSfbgVAIueIpwgEMFL2DPKaUi87iq81o8rzQl9AgYDOFKU8/6wPPw==
X-Received: by 2002:a05:600c:1f86:b0:46e:3d41:5fed with SMTP id 5b1f17b1804b1-46e5da8bd67mr7432535e9.11.1759221479106;
        Tue, 30 Sep 2025 01:37:59 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-153.retail.telecomitalia.it. [79.46.200.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b577c87sm10285805e9.0.2025.09.30.01.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 01:37:58 -0700 (PDT)
Date: Tue, 30 Sep 2025 10:37:52 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v6 8/9] selftests/vsock: invoke vsock_test
 through helpers
Message-ID: <2a2qhhyui2by6cw3nqepwgfxxrknyjx5rgaybt4dvqowflom2r@i55r2csxbmb4>
References: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
 <20250916-vsock-vmtest-v6-8-064d2eb0c89d@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250916-vsock-vmtest-v6-8-064d2eb0c89d@meta.com>

On Tue, Sep 16, 2025 at 04:43:52PM -0700, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add helper calls vm_vsock_test() and host_vsock_test() to invoke the
>vsock_test binary. This encapsulates several items of repeat logic, such
>as waiting for the server to reach listening state and
>enabling/disabling the bash option pipefail to avoid pipe-style logging
>from hiding failures.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> tools/testing/selftests/vsock/vmtest.sh | 120 ++++++++++++++++++++++++++++----
> 1 file changed, 108 insertions(+), 12 deletions(-)
>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 183647a86c8a..5e36d1068f6f 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -248,6 +248,7 @@ wait_for_listener()
> 	local port=$1
> 	local interval=$2
> 	local max_intervals=$3
>+	local old_pipefail
> 	local protocol=tcp
> 	local pattern
> 	local i
>@@ -256,6 +257,13 @@ wait_for_listener()
>
> 	# for tcp protocol additionally check the socket state
> 	[ "${protocol}" = "tcp" ] && pattern="${pattern}0A"
>+
>+	# 'grep -q' exits on match, sending SIGPIPE to 'awk', which exits with
>+	# an error, causing the if-condition to fail when pipefail is set.
>+	# Instead, temporarily disable pipefail and restore it later.
>+	old_pipefail=$(set -o | awk '/^pipefail[[:space:]]+(on|off)$/{print $2}')
>+	set +o pipefail
>+
> 	for i in $(seq "${max_intervals}"); do
> 		if awk '{print $2" "$4}' /proc/net/"${protocol}"* | \
> 		   grep -q "${pattern}"; then
>@@ -263,6 +271,10 @@ wait_for_listener()
> 		fi
> 		sleep "${interval}"
> 	done
>+
>+	if [[ "${old_pipefail}" == on ]]; then
>+		set -o pipefail
>+	fi
> }
>
> vm_wait_for_listener() {
>@@ -314,28 +326,112 @@ log_guest() {
> 	LOG_PREFIX=guest log $@
> }
>
>+vm_vsock_test() {
>+	local ns=$1
>+	local mode=$2
>+	local rc
>+
>+	set -o pipefail
>+	if [[ "${mode}" == client ]]; then
>+		local host=$3

I don't really like having the number and type of parameters of a 
function depend on others, maintaining it could become a mess.

Can we avoid “mode” altogether and use “host” to discriminate between 
server and client?

e.g. if “host” == server then we launch the server, otherwise we 
interpret it as IP, or something else.

>+		local cid=$4
>+		local port=$5
>+
>+		# log output and use pipefail to respect vsock_test errors
>+		vm_ssh "${ns}" -- "${VSOCK_TEST}" \
>+			--mode=client \
>+			--control-host="${host}" \
>+			--peer-cid="${cid}" \
>+			--control-port="${port}" \
>+			2>&1 | log_guest
>+		rc=$?
>+	else
>+		local cid=$3
>+		local port=$4
>+
>+		# log output and use pipefail to respect vsock_test errors
>+		vm_ssh "${ns}" -- "${VSOCK_TEST}" \
>+			--mode=server \
>+			--peer-cid="${cid}" \
>+			--control-port="${port}" \
>+			2>&1 | log_guest &
>+		rc=$?
>+
>+		if [[ $rc -ne 0 ]]; then
>+			set +o pipefail
>+			return $rc
>+		fi
>+
>+		vm_wait_for_listener "${ns}" "${port}"
>+		rc=$?
>+	fi
>+	set +o pipefail
>+
>+	return $rc
> }
>
>+host_vsock_test() {
>+	local ns=$1
>+	local mode=$2
>+	local cmd
>+
>+	if [[ "${ns}" == none ]]; then
>+		cmd="${VSOCK_TEST}"
>+	else
>+		cmd="ip netns exec ${ns} ${VSOCK_TEST}"
>+	fi
>+
>+	# log output and use pipefail to respect vsock_test errors
>+	set -o pipefail
>+	if [[ "${mode}" == client ]]; then
>+		local host=$3

Ditto.

The rest LGTM.

Thanks,
Stefano

>+		local cid=$4
>+		local port=$5
>+
>+		${cmd} \
>+			--mode="${mode}" \
>+			--peer-cid="${cid}" \
>+			--control-host="${host}" \
>+			--control-port="${port}" 2>&1 | log_host
>+		rc=$?
>+	else
>+		local cid=$3
>+		local port=$4
>+
>+		${cmd} \
>+			--mode="${mode}" \
>+			--peer-cid="${cid}" \
>+			--control-port="${port}" 2>&1 | log_host &
>+		rc=$?
>+
>+		if [[ $rc -ne 0 ]]; then
>+			return $rc
>+		fi
>+
>+		host_wait_for_listener "${ns}" "${port}" "${WAIT_PERIOD}" "${WAIT_PERIOD_MAX}"
>+		rc=$?
>+	fi
>+	set +o pipefail
>
>+	return $rc
> }
>
> test_vm_server_host_client() {
>+	vm_vsock_test "none" "server" 2 "${TEST_GUEST_PORT}"
>+	host_vsock_test "none" "client" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"
>+}
>
>-	vm_ssh -- "${VSOCK_TEST}" \
>-		--mode=server \
>-		--control-port="${TEST_GUEST_PORT}" \
>-		--peer-cid=2 \
>-		2>&1 | log_guest &
>+test_vm_client_host_server() {
>+	host_vsock_test "none" "server" "${VSOCK_CID}" "${TEST_HOST_PORT_LISTENER}"
>+	vm_vsock_test "none" "client" "10.0.2.2" 2 "${TEST_HOST_PORT_LISTENER}"
>+}
>
>-	vm_wait_for_listener "${TEST_GUEST_PORT}"
>+test_vm_loopback() {
>+	vm_vsock_test "none" "server" 1 "${TEST_HOST_PORT_LISTENER}"
>+	vm_vsock_test "none" "client" "127.0.0.1" 1 "${TEST_HOST_PORT_LISTENER}"
>+}
>
>-	${VSOCK_TEST} \
>-		--mode=client \
>-		--control-host=127.0.0.1 \
>-		--peer-cid="${VSOCK_CID}" \
>-		--control-port="${TEST_HOST_PORT}" 2>&1 | log_host
>
>-	return $?
> }
>
> test_vm_client_host_server() {
>
>-- 
>2.47.3
>


