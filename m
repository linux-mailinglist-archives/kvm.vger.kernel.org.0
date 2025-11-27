Return-Path: <kvm+bounces-64879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E7908C8ED84
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EEFC2346EFB
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 14:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7017D32E130;
	Thu, 27 Nov 2025 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPcu6uKt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LrZmAw0u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B23288537
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254961; cv=none; b=XgfFGxf7GQruZt1OuOnWKzTdp9H4jVlqMC/2r0n4ETSz1N39EMetzC3+UBhxOzfM/lQl2CPBZu2Aok3JZKrV2p3ZetUH1c3S/ef38LfPV3SOZP43AgmiojkzsupsrIZNavHLEflibwEuGn0jyMfHALK3TEYvHiZilBWM8DEgCRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254961; c=relaxed/simple;
	bh=V+2O4+U9XYiRjqX56rz5HXnNpgerXl93oyFAv7FFemo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNxMVGDFeokPHpWT2z0SstSYuXx2L427U4LJbHCFVH4q28vObemssawbsuFjRL9k13CkwJgg40j/IG5+dDeGOQPondaWQmeEmfwkFLW4tRvyBV8fPpA6hGht/GioPZHZ7qQ3typWGfIQAkSHcMdl7AI51HTjLi2b+x3ook1n2Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPcu6uKt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LrZmAw0u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764254957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gkeusIdRsgymP/rGb7Efa8f39SNOxjOhJFPwPyuvaf4=;
	b=MPcu6uKtCMP4R93P8A56WnQrkzmpBQs2MB1yjrfzXcNrdVbiL0clIbLWCG+PxMIgVeHrZt
	vpe+fAjajD6g0c4Pjd48qOzKRkXCTRAJgfDs7BDlFYzwimp3v+MVPYhvUqT4C5iuaPR0Mn
	mBPnnTwsdAe0QdSyTUvOZvgxiboPR7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-mbcc0oUlOvOq-BlMP5qnOQ-1; Thu, 27 Nov 2025 09:49:15 -0500
X-MC-Unique: mbcc0oUlOvOq-BlMP5qnOQ-1
X-Mimecast-MFC-AGG-ID: mbcc0oUlOvOq-BlMP5qnOQ_1764254954
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so7620335e9.0
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 06:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764254954; x=1764859754; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gkeusIdRsgymP/rGb7Efa8f39SNOxjOhJFPwPyuvaf4=;
        b=LrZmAw0ustAWYnJUUryTF5vwLQbUofFC/XKmA0jyilZe+Azkvr0FeDxffCse2PJQdN
         yWZfmFWFIFYgQUAXOeLwC4PvrQ4nd1YWJgNAUc/UQ7ImjupctpZovHLPQRWWfAE0bR5z
         oTKsZakZSy+gOXBWrrGyiuB9j44bxJjkh0cB/82xWuJy37YllYayJJ7CbKc23meB3EhF
         XYI9gYlRt/H1shRSol8bb0ftJUCCUOYuSq50GTLRcMMQhRbq8AiwZ+qyANZcbBvnnJ9D
         uVFYFuFaShqv9v1/u3/2rx6XIS4ZrgPtdrSAe0eUVWeLt2j2pFudmCiiXupMcGD7bxLf
         GuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764254954; x=1764859754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkeusIdRsgymP/rGb7Efa8f39SNOxjOhJFPwPyuvaf4=;
        b=DadZg4WSHb4EZQi3F/usQjQnMk3VSHANncHDnn/qR+SzmhkytmSGEpeKqwVESrfopH
         aHMO5lYJN7tDyB3LaZzklUcVOMdebkykBvycRlOD8qXqZryuMGscvtHVvCZ7j6SjZtCc
         EzTwnWf7Ox8iFHJKwIUdNrH9D+5JJydqJI5ffdt5Ik+9S+T6y97KaBueIIJkIIWqELpr
         u1tN7r0AJ2vMqXgzi1uCvhms2oNIUrU2xGn1TFLs028f+8WQXiyt2CFt65MUIqxtQxWx
         4cs3x6aIk84mpJv5gNpk3f3Rc0tAd1/knEJxroC2g2+Zw93EvFcLeXNs4E13V6oXlyh2
         6ycg==
X-Forwarded-Encrypted: i=1; AJvYcCXlaBVQlvAaOeHbwJF6DfPzGTd3XkgLZ/IR3Ikz8FxdhZILFdfEqfMlnUa4OOHDr4SK89k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2NRfTpvH3Ki2+Ztzs1ccK7BiavoNynRJLZb/doclEJx0vIdQD
	qC+YkqadJ07VjikBC/TW4TDNyr7XbbZUELYu3reIkNdCHLSP/hCWKDJxsdKfcE/gbF3WUFS6faG
	JSKMw8Xf+D/nSqkdDwu+NnjkRFrTCEC6M3NOdq6xuDoLyfs9plBwV/A==
X-Gm-Gg: ASbGncsbub1Z4Y+uEiVFYqBjie68S0l85MsbUWZ4DU3q5ADx3mzOdtPT0YNAIEscXbq
	WRILvPrrmhWN8Xfbw51+oSBLwLCXUscJzxvkM4TbizZMFq5GlHz5+5XGS303pvJbbqhU8Kscgvn
	fyAgIiAQl8XK7C+7xJYaPwU+GZgieCKSLJkJ5uH/wY4gWg3A9lKcoRncIs+DB+jaI1V1u4FSntO
	G62v4bzntIeF8w3D+gcrTrBaL8DOmiyyOtVn0nrK+pXW1vvkV0IvAOv72XzqR9979ldQTanRHGS
	WZz7ViNMjZuo94/XSKx9uEEbUqH8G9MyrF2g+Vg94wO2KiFT/mEYP/bKLKDLAKa0gyZXzLbygUe
	rr6mkRdje+OzcSKiEvj1dh7YuJuhfocKcAs6qbefTE0WJ6Ccumgtk57bNuNPFyw==
X-Received: by 2002:a05:600c:3541:b0:477:7991:5d1e with SMTP id 5b1f17b1804b1-47904b24871mr113306245e9.25.1764254954066;
        Thu, 27 Nov 2025 06:49:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5ic335Ch3Kfx+CSKA0+Lyb+qZ0T71jtixHIqiNZEaMPH4CU9EYXxcYOoHFw96edNJz0/0uQ==
X-Received: by 2002:a05:600c:3541:b0:477:7991:5d1e with SMTP id 5b1f17b1804b1-47904b24871mr113305535e9.25.1764254953495;
        Thu, 27 Nov 2025 06:49:13 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040d81e4sm74068435e9.3.2025.11.27.06.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 06:49:12 -0800 (PST)
Date: Thu, 27 Nov 2025 15:49:03 +0100
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
Subject: Re: [PATCH net-next v12 11/12] selftests/vsock: add tests for host
 <-> vm connectivity with namespaces
Message-ID: <ygvjuud4cbzhpz573ygle7y45zfzwpyaorexfb46f5orzp44o4@2slgqe3xduwd>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-11-257ee21cd5de@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251126-vsock-vmtest-v12-11-257ee21cd5de@meta.com>

On Wed, Nov 26, 2025 at 11:47:40PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add tests to validate namespace correctness using vsock_test and socat.
>The vsock_test tool is used to validate expected success tests, but
>socat is used for expected failure tests. socat is used to ensure that
>connections are rejected outright instead of failing due to some other
>socket behavior (as tested in vsock_test). Additionally, socat is
>already required for tunneling TCP traffic from vsock_test. Using only
>one of the vsock_test tests like 'test_stream_client_close_client' would
>have yielded a similar result, but doing so wouldn't remove the socat
>dependency.
>
>Additionally, check for the dependency socat. socat needs special
>handling beyond just checking if it is on the path because it must be
>compiled with support for both vsock and unix. The function
>check_socat() checks that this support exists.
>
>Add more padding to test name printf strings because the tests added in
>this patch would otherwise overflow.
>
>Add vm_dmesg_* helpers to encapsulate checking dmesg
>for oops and warnings.
>
>Add ability to pass extra args to host-side vsock_test so that tests
>that cause false positives may be skipped with arg --skip.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v12:
>- add test skip (vsock_test test 29) when host_vsock_test() uses client
>  mode in a local namespace. Test 29 causes a false positive to trigger.

I see, LGTM and thanks for adding a comment with the reason!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Changes in v11:
>- add 'sleep "${WAIT_PERIOD}"' after any non-TCP socat LISTEN cmd
>  (Stefano)
>- add host_wait_for_listener() after any socat TCP-LISTEN (Stefano)
>- reuse vm_dmesg_{oops,warn}_count() inside vm_dmesg_check()
>- fix copy-paste in test_ns_same_local_vm_connect_to_local_host_ok()
>  (Stefano)
>
>Changes in v10:
>- add vm_dmesg_start() and vm_dmesg_check()
>
>Changes in v9:
>- consistent variable quoting
>---
> tools/testing/selftests/vsock/vmtest.sh | 572 +++++++++++++++++++++++++++++++-
> 1 file changed, 568 insertions(+), 4 deletions(-)
>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index ec18eb5b4ccd..da9198dc8ab5 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -7,6 +7,7 @@
> #		* virtme-ng
> #		* busybox-static (used by virtme-ng)
> #		* qemu	(used by virtme-ng)
>+#		* socat
> #
> # shellcheck disable=SC2317,SC2119
>
>@@ -54,6 +55,19 @@ readonly TEST_NAMES=(
> 	ns_local_same_cid_ok
> 	ns_global_local_same_cid_ok
> 	ns_local_global_same_cid_ok
>+	ns_diff_global_host_connect_to_global_vm_ok
>+	ns_diff_global_host_connect_to_local_vm_fails
>+	ns_diff_global_vm_connect_to_global_host_ok
>+	ns_diff_global_vm_connect_to_local_host_fails
>+	ns_diff_local_host_connect_to_local_vm_fails
>+	ns_diff_local_vm_connect_to_local_host_fails
>+	ns_diff_global_to_local_loopback_local_fails
>+	ns_diff_local_to_global_loopback_fails
>+	ns_diff_local_to_local_loopback_fails
>+	ns_diff_global_to_global_loopback_ok
>+	ns_same_local_loopback_ok
>+	ns_same_local_host_connect_to_local_vm_ok
>+	ns_same_local_vm_connect_to_local_host_ok
> )
> readonly TEST_DESCS=(
> 	# vm_server_host_client
>@@ -82,6 +96,45 @@ readonly TEST_DESCS=(
>
> 	# ns_local_global_same_cid_ok
> 	"Check QEMU successfully starts one VM in a local ns and then another VM in a global ns with the same CID."
>+
>+	# ns_diff_global_host_connect_to_global_vm_ok
>+	"Run vsock_test client in global ns with server in VM in another global ns."
>+
>+	# ns_diff_global_host_connect_to_local_vm_fails
>+	"Run socat to test a process in a global ns fails to connect to a VM in a local ns."
>+
>+	# ns_diff_global_vm_connect_to_global_host_ok
>+	"Run vsock_test client in VM in a global ns with server in another global ns."
>+
>+	# ns_diff_global_vm_connect_to_local_host_fails
>+	"Run socat to test a VM in a global ns fails to connect to a host process in a local ns."
>+
>+	# ns_diff_local_host_connect_to_local_vm_fails
>+	"Run socat to test a host process in a local ns fails to connect to a VM in another local ns."
>+
>+	# ns_diff_local_vm_connect_to_local_host_fails
>+	"Run socat to test a VM in a local ns fails to connect to a host process in another local ns."
>+
>+	# ns_diff_global_to_local_loopback_local_fails
>+	"Run socat to test a loopback vsock in a global ns fails to connect to a vsock in a local ns."
>+
>+	# ns_diff_local_to_global_loopback_fails
>+	"Run socat to test a loopback vsock in a local ns fails to connect to a vsock in a global ns."
>+
>+	# ns_diff_local_to_local_loopback_fails
>+	"Run socat to test a loopback vsock in a local ns fails to connect to a vsock in another local ns."
>+
>+	# ns_diff_global_to_global_loopback_ok
>+	"Run socat to test a loopback vsock in a global ns successfully connects to a vsock in another global ns."
>+
>+	# ns_same_local_loopback_ok
>+	"Run socat to test a loopback vsock in a local ns successfully connects to a vsock in the same ns."
>+
>+	# ns_same_local_host_connect_to_local_vm_ok
>+	"Run vsock_test client in a local ns with server in VM in same ns."
>+
>+	# ns_same_local_vm_connect_to_local_host_ok
>+	"Run vsock_test client in VM in a local ns with server in same ns."
> )
>
> readonly USE_SHARED_VM=(
>@@ -112,7 +165,7 @@ usage() {
> 	for ((i = 0; i < ${#TEST_NAMES[@]}; i++)); do
> 		name=${TEST_NAMES[${i}]}
> 		desc=${TEST_DESCS[${i}]}
>-		printf "\t%-35s%-35s\n" "${name}" "${desc}"
>+		printf "\t%-55s%-35s\n" "${name}" "${desc}"
> 	done
> 	echo
>
>@@ -231,7 +284,7 @@ check_args() {
> }
>
> check_deps() {
>-	for dep in vng ${QEMU} busybox pkill ssh ss; do
>+	for dep in vng ${QEMU} busybox pkill ssh ss socat; do
> 		if [[ ! -x $(command -v "${dep}") ]]; then
> 			echo -e "skip:    dependency ${dep} not found!\n"
> 			exit "${KSFT_SKIP}"
>@@ -282,6 +335,20 @@ check_vng() {
> 	fi
> }
>
>+check_socat() {
>+	local support_string
>+
>+	support_string="$(socat -V)"
>+
>+	if [[ "${support_string}" != *"WITH_VSOCK 1"* ]]; then
>+		die "err: socat is missing vsock support"
>+	fi
>+
>+	if [[ "${support_string}" != *"WITH_UNIX 1"* ]]; then
>+		die "err: socat is missing unix support"
>+	fi
>+}
>+
> handle_build() {
> 	if [[ ! "${BUILD}" -eq 1 ]]; then
> 		return
>@@ -330,6 +397,14 @@ terminate_pidfiles() {
> 	done
> }
>
>+terminate_pids() {
>+	local pid
>+
>+	for pid in "$@"; do
>+		kill -SIGTERM "${pid}" &>/dev/null || :
>+	done
>+}
>+
> vm_start() {
> 	local pidfile=$1
> 	local ns=$2
>@@ -468,6 +543,28 @@ vm_dmesg_warn_count() {
> 	vm_ssh "${ns}" -- dmesg --level=warn 2>/dev/null | grep -c -i 'vsock'
> }
>
>+vm_dmesg_check() {
>+	local pidfile=$1
>+	local ns=$2
>+	local oops_before=$3
>+	local warn_before=$4
>+	local oops_after warn_after
>+
>+	oops_after=$(vm_dmesg_oops_count "${ns}")
>+	if [[ "${oops_after}" -gt "${oops_before}" ]]; then
>+		echo "FAIL: kernel oops detected on vm in ns ${ns}" | log_host
>+		return 1
>+	fi
>+
>+	warn_after=$(vm_dmesg_warn_count "${ns}")
>+	if [[ "${warn_after}" -gt "${warn_before}" ]]; then
>+		echo "FAIL: kernel warning detected on vm in ns ${ns}" | log_host
>+		return 1
>+	fi
>+
>+	return 0
>+}
>+
> vm_vsock_test() {
> 	local ns=$1
> 	local host=$2
>@@ -511,6 +608,8 @@ host_vsock_test() {
> 	local host=$2
> 	local cid=$3
> 	local port=$4
>+	shift 4
>+	local extra_args=("$@")
> 	local rc
>
> 	local cmd="${VSOCK_TEST}"
>@@ -525,13 +624,15 @@ host_vsock_test() {
> 			--mode=client \
> 			--peer-cid="${cid}" \
> 			--control-host="${host}" \
>-			--control-port="${port}" 2>&1 | log_host
>+			--control-port="${port}" \
>+			"${extra_args[@]}" 2>&1 | log_host
> 		rc=$?
> 	else
> 		${cmd} \
> 			--mode=server \
> 			--peer-cid="${cid}" \
>-			--control-port="${port}" 2>&1 | log_host &
>+			--control-port="${port}" \
>+			"${extra_args[@]}" 2>&1 | log_host &
> 		rc=$?
>
> 		if [[ $rc -ne 0 ]]; then
>@@ -592,6 +693,468 @@ test_ns_host_vsock_ns_mode_ok() {
> 	return "${KSFT_PASS}"
> }
>
>+test_ns_diff_global_host_connect_to_global_vm_ok() {
>+	local oops_before warn_before
>+	local pids pid pidfile
>+	local ns0 ns1 port
>+	declare -a pids
>+	local unixfile
>+	ns0="global0"
>+	ns1="global1"
>+	port=1234
>+	local rc
>+
>+	init_namespaces
>+
>+	pidfile="$(create_pidfile)"
>+
>+	if ! vm_start "${pidfile}" "${ns0}"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns0}"
>+	oops_before=$(vm_dmesg_oops_count "${ns0}")
>+	warn_before=$(vm_dmesg_warn_count "${ns0}")
>+
>+	unixfile=$(mktemp -u /tmp/XXXX.sock)
>+	ip netns exec "${ns1}" \
>+		socat TCP-LISTEN:"${TEST_HOST_PORT}",fork \
>+			UNIX-CONNECT:"${unixfile}" &
>+	pids+=($!)
>+	host_wait_for_listener "${ns1}" "${TEST_HOST_PORT}" "tcp"
>+
>+	ip netns exec "${ns0}" socat UNIX-LISTEN:"${unixfile}",fork \
>+		TCP-CONNECT:localhost:"${TEST_HOST_PORT}" &
>+	pids+=($!)
>+	host_wait_for_listener "${ns0}" "${unixfile}" "unix"
>+
>+	vm_vsock_test "${ns0}" "server" 2 "${TEST_GUEST_PORT}"
>+	vm_wait_for_listener "${ns0}" "${TEST_GUEST_PORT}" "tcp"
>+	host_vsock_test "${ns1}" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}"
>+	rc=$?
>+
>+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pids "${pids[@]}"
>+	terminate_pidfiles "${pidfile}"
>+
>+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
>+test_ns_diff_global_host_connect_to_local_vm_fails() {
>+	local oops_before warn_before
>+	local ns0="global0"
>+	local ns1="local0"
>+	local port=12345
>+	local dmesg_rc
>+	local pidfile
>+	local result
>+	local pid
>+
>+	init_namespaces
>+
>+	outfile=$(mktemp)
>+
>+	pidfile="$(create_pidfile)"
>+	if ! vm_start "${pidfile}" "${ns1}"; then
>+		log_host "failed to start vm (cid=${VSOCK_CID}, ns=${ns0})"
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns1}"
>+	oops_before=$(vm_dmesg_oops_count "${ns1}")
>+	warn_before=$(vm_dmesg_warn_count "${ns1}")
>+
>+	vm_ssh "${ns1}" -- socat VSOCK-LISTEN:"${port}" STDOUT > "${outfile}" &
>+	vm_wait_for_listener "${ns1}" "${port}" "vsock"
>+	echo TEST | ip netns exec "${ns0}" \
>+		socat STDIN VSOCK-CONNECT:"${VSOCK_CID}":"${port}" 2>/dev/null
>+
>+	vm_dmesg_check "${pidfile}" "${ns1}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+	result=$(cat "${outfile}")
>+	rm -f "${outfile}"
>+
>+	if [[ "${result}" == "TEST" ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
>+test_ns_diff_global_vm_connect_to_global_host_ok() {
>+	local oops_before warn_before
>+	local ns0="global0"
>+	local ns1="global1"
>+	local port=12345
>+	local unixfile
>+	local dmesg_rc
>+	local pidfile
>+	local pids
>+	local rc
>+
>+	init_namespaces
>+
>+	declare -a pids
>+
>+	log_host "Setup socat bridge from ns ${ns0} to ns ${ns1} over port ${port}"
>+
>+	unixfile=$(mktemp -u /tmp/XXXX.sock)
>+
>+	ip netns exec "${ns0}" \
>+		socat TCP-LISTEN:"${port}" UNIX-CONNECT:"${unixfile}" &
>+	pids+=($!)
>+	host_wait_for_listener "${ns0}" "${port}" "tcp"
>+
>+	ip netns exec "${ns1}" \
>+		socat UNIX-LISTEN:"${unixfile}" TCP-CONNECT:127.0.0.1:"${port}" &
>+	pids+=($!)
>+	host_wait_for_listener "${ns1}" "${unixfile}" "unix"
>+
>+	log_host "Launching ${VSOCK_TEST} in ns ${ns1}"
>+	host_vsock_test "${ns1}" "server" "${VSOCK_CID}" "${port}"
>+
>+	pidfile="$(create_pidfile)"
>+	if ! vm_start "${pidfile}" "${ns0}"; then
>+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
>+		terminate_pids "${pids[@]}"
>+		rm -f "${unixfile}"
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns0}"
>+
>+	oops_before=$(vm_dmesg_oops_count "${ns0}")
>+	warn_before=$(vm_dmesg_warn_count "${ns0}")
>+
>+	vm_vsock_test "${ns0}" "10.0.2.2" 2 "${port}"
>+	rc=$?
>+
>+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+	terminate_pids "${pids[@]}"
>+	rm -f "${unixfile}"
>+
>+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+
>+}
>+
>+test_ns_diff_global_vm_connect_to_local_host_fails() {
>+	local ns0="global0"
>+	local ns1="local0"
>+	local port=12345
>+	local oops_before warn_before
>+	local dmesg_rc
>+	local pidfile
>+	local result
>+	local pid
>+
>+	init_namespaces
>+
>+	log_host "Launching socat in ns ${ns1}"
>+	outfile=$(mktemp)
>+
>+	ip netns exec "${ns1}" socat VSOCK-LISTEN:"${port}" STDOUT &> "${outfile}" &
>+	pid=$!
>+	host_wait_for_listener "${ns1}" "${port}" "vsock"
>+
>+	pidfile="$(create_pidfile)"
>+	if ! vm_start "${pidfile}" "${ns0}"; then
>+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
>+		terminate_pids "${pid}"
>+		rm -f "${outfile}"
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns0}"
>+
>+	oops_before=$(vm_dmesg_oops_count "${ns0}")
>+	warn_before=$(vm_dmesg_warn_count "${ns0}")
>+
>+	vm_ssh "${ns0}" -- \
>+		bash -c "echo TEST | socat STDIN VSOCK-CONNECT:2:${port}" 2>&1 | log_guest
>+
>+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+	terminate_pids "${pid}"
>+
>+	result=$(cat "${outfile}")
>+	rm -f "${outfile}"
>+
>+	if [[ "${result}" != TEST ]] && [[ "${dmesg_rc}" -eq 0 ]]; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_diff_local_host_connect_to_local_vm_fails() {
>+	local ns0="local0"
>+	local ns1="local1"
>+	local port=12345
>+	local oops_before warn_before
>+	local dmesg_rc
>+	local pidfile
>+	local result
>+	local pid
>+
>+	init_namespaces
>+
>+	outfile=$(mktemp)
>+
>+	pidfile="$(create_pidfile)"
>+	if ! vm_start "${pidfile}" "${ns1}"; then
>+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns1}"
>+	oops_before=$(vm_dmesg_oops_count "${ns1}")
>+	warn_before=$(vm_dmesg_warn_count "${ns1}")
>+
>+	vm_ssh "${ns1}" -- socat VSOCK-LISTEN:"${port}" STDOUT > "${outfile}" &
>+	vm_wait_for_listener "${ns1}" "${port}" "vsock"
>+
>+	echo TEST | ip netns exec "${ns0}" \
>+		socat STDIN VSOCK-CONNECT:"${VSOCK_CID}":"${port}" 2>/dev/null
>+
>+	vm_dmesg_check "${pidfile}" "${ns1}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+
>+	result=$(cat "${outfile}")
>+	rm -f "${outfile}"
>+
>+	if [[ "${result}" != TEST ]] && [[ "${dmesg_rc}" -eq 0 ]]; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_diff_local_vm_connect_to_local_host_fails() {
>+	local oops_before warn_before
>+	local ns0="local0"
>+	local ns1="local1"
>+	local port=12345
>+	local dmesg_rc
>+	local pidfile
>+	local result
>+	local pid
>+
>+	init_namespaces
>+
>+	log_host "Launching socat in ns ${ns1}"
>+	outfile=$(mktemp)
>+	ip netns exec "${ns1}" socat VSOCK-LISTEN:"${port}" STDOUT &> "${outfile}" &
>+	pid=$!
>+	host_wait_for_listener "${ns1}" "${port}" "vsock"
>+
>+	pidfile="$(create_pidfile)"
>+	if ! vm_start "${pidfile}" "${ns0}"; then
>+		log_host "failed to start vm (cid=${cid}, ns=${ns0})"
>+		rm -f "${outfile}"
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns0}"
>+	oops_before=$(vm_dmesg_oops_count "${ns0}")
>+	warn_before=$(vm_dmesg_warn_count "${ns0}")
>+
>+	vm_ssh "${ns0}" -- \
>+		bash -c "echo TEST | socat STDIN VSOCK-CONNECT:2:${port}" 2>&1 | log_guest
>+
>+	vm_dmesg_check "${pidfile}" "${ns0}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+	terminate_pids "${pid}"
>+
>+	result=$(cat "${outfile}")
>+	rm -f "${outfile}"
>+
>+	if [[ "${result}" != TEST ]] && [[ "${dmesg_rc}" -eq 0 ]]; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+__test_loopback_two_netns() {
>+	local ns0=$1
>+	local ns1=$2
>+	local port=12345
>+	local result
>+	local pid
>+
>+	modprobe vsock_loopback &> /dev/null || :
>+
>+	log_host "Launching socat in ns ${ns1}"
>+	outfile=$(mktemp)
>+
>+	ip netns exec "${ns1}" socat VSOCK-LISTEN:"${port}" STDOUT > "${outfile}" 2>/dev/null &
>+	pid=$!
>+	host_wait_for_listener "${ns1}" "${port}" "vsock"
>+
>+	log_host "Launching socat in ns ${ns0}"
>+	echo TEST | ip netns exec "${ns0}" socat STDIN VSOCK-CONNECT:1:"${port}" 2>/dev/null
>+	terminate_pids "${pid}"
>+
>+	result=$(cat "${outfile}")
>+	rm -f "${outfile}"
>+
>+	if [[ "${result}" == TEST ]]; then
>+		return 0
>+	fi
>+
>+	return 1
>+}
>+
>+test_ns_diff_global_to_local_loopback_local_fails() {
>+	init_namespaces
>+
>+	if ! __test_loopback_two_netns "global0" "local0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_diff_local_to_global_loopback_fails() {
>+	init_namespaces
>+
>+	if ! __test_loopback_two_netns "local0" "global0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_diff_local_to_local_loopback_fails() {
>+	init_namespaces
>+
>+	if ! __test_loopback_two_netns "local0" "local1"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_diff_global_to_global_loopback_ok() {
>+	init_namespaces
>+
>+	if __test_loopback_two_netns "global0" "global1"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_same_local_loopback_ok() {
>+	init_namespaces
>+
>+	if __test_loopback_two_netns "local0" "local0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_same_local_host_connect_to_local_vm_ok() {
>+	local oops_before warn_before
>+	local ns="local0"
>+	local port=1234
>+	local dmesg_rc
>+	local pidfile
>+	local rc
>+
>+	init_namespaces
>+
>+	pidfile="$(create_pidfile)"
>+
>+	if ! vm_start "${pidfile}" "${ns}"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns}"
>+	oops_before=$(vm_dmesg_oops_count "${ns}")
>+	warn_before=$(vm_dmesg_warn_count "${ns}")
>+
>+	vm_vsock_test "${ns}" "server" 2 "${TEST_GUEST_PORT}"
>+
>+	# Skip test 29 (transport release use-after-free): This test attempts
>+	# binding both G2H and H2G CIDs. Because virtio-vsock (G2H) doesn't
>+	# support local namespaces the test will fail when
>+	# transport_g2h->stream_allow() returns false. This edge case only
>+	# happens for vsock_test in client mode on the host in a local
>+	# namespace. This is a false positive.
>+	host_vsock_test "${ns}" "127.0.0.1" "${VSOCK_CID}" "${TEST_HOST_PORT}" --skip=29
>+	rc=$?
>+
>+	vm_dmesg_check "${pidfile}" "${ns}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+
>+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
>+test_ns_same_local_vm_connect_to_local_host_ok() {
>+	local oops_before warn_before
>+	local ns="local0"
>+	local port=1234
>+	local dmesg_rc
>+	local pidfile
>+	local rc
>+
>+	init_namespaces
>+
>+	pidfile="$(create_pidfile)"
>+
>+	if ! vm_start "${pidfile}" "${ns}"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	vm_wait_for_ssh "${ns}"
>+	oops_before=$(vm_dmesg_oops_count "${ns}")
>+	warn_before=$(vm_dmesg_warn_count "${ns}")
>+
>+	host_vsock_test "${ns}" "server" "${VSOCK_CID}" "${port}"
>+	vm_vsock_test "${ns}" "10.0.2.2" 2 "${port}"
>+	rc=$?
>+
>+	vm_dmesg_check "${pidfile}" "${ns}" "${oops_before}" "${warn_before}"
>+	dmesg_rc=$?
>+
>+	terminate_pidfiles "${pidfile}"
>+
>+	if [[ "${rc}" -ne 0 ]] || [[ "${dmesg_rc}" -ne 0 ]]; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
> namespaces_can_boot_same_cid() {
> 	local ns0=$1
> 	local ns1=$2
>@@ -869,6 +1432,7 @@ fi
> check_args "${ARGS[@]}"
> check_deps
> check_vng
>+check_socat
> handle_build
>
> echo "1..${#ARGS[@]}"
>
>-- 
>2.47.3
>


