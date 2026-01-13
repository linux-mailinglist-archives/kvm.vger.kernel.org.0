Return-Path: <kvm+bounces-67959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA1ED1A68F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ECC793033DDD
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F09834E745;
	Tue, 13 Jan 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPDsUKYM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBDAb6xN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B061A34DCD6
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768323052; cv=none; b=Jg0B13mKwMax2eBOXJDc1tfRULQVZnxMd6bR/99Ovqlx4wJ5WMLxKK9hZxhtGXFFq+VTdh4oxrdMUpqgoM4IZJgFg8wMrzNGpLKHva9H73dWy6irvTchH33F+W4Mpd/p005t+b3nxUu6ZL9q/cvlHWnQHPTqB8SetDVaYvlhseo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768323052; c=relaxed/simple;
	bh=l/MzUKV5vBhOjr5ZED+tJpwan1YXWA9mauHZNOyldN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bW1Um4mvU/A8+j3YE8xWvdY1n7SYIRpMUenNykTAMDz1QvQl/ORBYnh4sIa62ptnwiJRIoVMTbhJ4c2pW56hbkAccNj/wvAYbun0Ae0ws0o75jv8a3xygAWZRtzdL+OvMQEeDr51qNWjcgu2QCb3oxsBN8pE381z54vB5heI370=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EPDsUKYM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VBDAb6xN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768323049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DG0WRw7YxgTU3+MntFsjdanWVcUUw4Bpd9rGhDr013E=;
	b=EPDsUKYM/iHMyQzeU3SwLfDtsJ1qv5zoEfA83mHcT1a3H2GG7h/rSHDKmvL0cQ8tzzPgqW
	nF3Zyuzl5TALA33M7Hw8+tL71JFsqVEq2sDGbQgBGGwdVqrLeXmYK38zJQD/rwpK5+Pw7z
	DRDpDAoEJufKchehzbgYTkMMmlMs1KI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-Qqecm9AaPOWbZzYXaAQ2sw-1; Tue, 13 Jan 2026 11:50:48 -0500
X-MC-Unique: Qqecm9AaPOWbZzYXaAQ2sw-1
X-Mimecast-MFC-AGG-ID: Qqecm9AaPOWbZzYXaAQ2sw_1768323047
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so54063035e9.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 08:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768323047; x=1768927847; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DG0WRw7YxgTU3+MntFsjdanWVcUUw4Bpd9rGhDr013E=;
        b=VBDAb6xNI58zdYmTI6oRUjQtylcczFbmLkUlF6la5VPMIDA+aYzveCUe2FHTYaZupU
         KPxXOepYzi3KHEAdUFiI20ol+rprv2Av2YZNHdDb5JmxWQGGmsRSLJN1fjCa62xsxB7V
         efWldlZ0/Cayp3bpYradXrr/rWRJoZyLEClXmqP38iw4C1Qc/tZb9nr67regoc0Ff3m/
         kgkpkr+zIRnfbfuLJ+LUmLtG6Bp95vVfRqJpfiyTMmFDCGLzFjRGaE0kGA+Bo/MyOGjy
         TKf79NkD7NNobtE0k72kI1JBXW9iUEYnK5nxjtjp68JkUgO2O7V9yRL7XlD6eeEefTa+
         Y4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768323047; x=1768927847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DG0WRw7YxgTU3+MntFsjdanWVcUUw4Bpd9rGhDr013E=;
        b=H0txYUZHEqcPK1u0vbJ7ueguMXdGWuds0Jp0qdFymhdJmdYk3LnL49AKLlIuRGyFUX
         PvxNQ6ECSnjnGxmV4H+4VtXatNtR/0D75J/tB7xpsgU5A2quCzFT9gH0BB/RmiLWBO2S
         QYHKFX85l4eIF7c1P/WD7A1jvJhyGxvZ0FOKeponUftH2KYhMyMAbGNy2a5IZeZoMnZ/
         NnLto9OlALlZEJE3O7jsHQU4bbTg5pOEBx2CxlmxwW3ECf6wMIA0iRhbgOoRsEQyfxZc
         S+LZ055poAurtJu1CHDekl3hnodGzFDL+Y3IHAR4vHVRzWqTWDKVebLKvB7jAIVFYQh6
         MrCQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/EtgqwoW86+tyTCN/QXA2LaFHkAcEBIlxxq+cQPPaxMwdOVhCyPBPL1X1AG3qUAphdpo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHJ7DNvaoZ28eCwUqnoLb1Vte6ihK3Pd2XDMI77+h4WdsCeiwb
	fl2agemu50VSOEszb+3joBkYtZ0JVi/Gm7YP0sqC5nA/q6tbiPuE3pVK7aUhwIEG3FmnzdtO/rf
	HvpMAQABS/DB/ythmNw6bUevj9CAmihUvtXh2nHqqe41QIAyxj1MceQ==
X-Gm-Gg: AY/fxX6IgNDPBVoO8g+/RyjB3Hnx29OjmQLtw7B3SFRXVTxcvMJehoKq+9hiIeGwh4z
	4aDv+MMWGHUnWLg5/t9ZPLtUG6qPPserxVLxOB+EjlPr4W+nxhK2WuvCpxrixYe3iOCFU4AXb7R
	QemO6prvBvjxbgk17I1yxSRLjDWQyUeVledwvvsOF0/Jfw/wnvEkGQfS6sWjySDP1gQpXajmn6O
	5F5ahZYlqU4gkr8t1njZpz+w4vqjBKJWsuOiVSIi1A5f+BQPNsHtc9/3+Gs+lOrZtPYPa8LXzzL
	eKFQZ8uqlB+V0G2eVl3idw2qOzBJFQqLiJtcDd0GMy5k1zRDIe5yX7h4s24vEQDe1fKf77rUWI5
	oMTwspLE9ePo6SkToUS1xTn/QtYX6EhA7KCGtz7ljkd1daWNbek2upnBUNZy9Uw==
X-Received: by 2002:a05:600c:4692:b0:47d:3ead:7439 with SMTP id 5b1f17b1804b1-47d84b5403dmr248979935e9.37.1768323047180;
        Tue, 13 Jan 2026 08:50:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlubu09xauLTgM5vIaUwncOAsAxE5DLD0jbAoR78s6Ju0YY/wLL6jLo1N3GDIcOu7AsHYzxQ==
X-Received: by 2002:a05:600c:4692:b0:47d:3ead:7439 with SMTP id 5b1f17b1804b1-47d84b5403dmr248979725e9.37.1768323046648;
        Tue, 13 Jan 2026 08:50:46 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee134a057sm7988835e9.14.2026.01.13.08.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 08:50:46 -0800 (PST)
Date: Tue, 13 Jan 2026 17:50:35 +0100
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
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v14 09/12] selftests/vsock: add tests for proc
 sys vsock ns_mode
Message-ID: <aWZ3xxGbK0Ccldv9@sgarzare-redhat>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
 <20260112-vsock-vmtest-v14-9-a5c332db3e2b@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260112-vsock-vmtest-v14-9-a5c332db3e2b@meta.com>

On Mon, Jan 12, 2026 at 07:11:18PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add tests for the /proc/sys/net/vsock/{ns_mode,child_ns_mode}
>interfaces. Namely, that they accept/report "global" and "local" strings
>and enforce their access policies.
>
>Start a convention of commenting the test name over the test
>description. Add test name comments over test descriptions that existed
>before this convention.
>
>Add a check_netns() function that checks if the test requires namespaces
>and if the current kernel supports namespaces. Skip tests that require
>namespaces if the system does not have namespace support.
>
>This patch is the first to add tests that do *not* re-use the same
>shared VM. For that reason, it adds a run_ns_tests() function to run
>these tests and filter out the shared VM tests.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v13:
>- remove write-once test ns_host_vsock_ns_mode_write_once_ok to reflect
>  removing the write-once policy
>- add child_ns_mode test test_ns_host_vsock_child_ns_mode_ok
>- modify test_ns_host_vsock_ns_mode_ok() to check that the correct mode
>  was inherited from child_ns_mode
>
>Changes in v12:
>- remove ns_vm_local_mode_rejected test, due to dropping that constraint
>
>Changes in v11:
>- Document ns_ prefix above TEST_NAMES (Stefano)
>
>Changes in v10:
>- Remove extraneous add_namespaces/del_namespaces calls.
>- Rename run_tests() to run_ns_tests() since it is designed to only
>  run ns tests.
>
>Changes in v9:
>- add test ns_vm_local_mode_rejected to check that guests cannot use
>  local mode
>---
> tools/testing/selftests/vsock/vmtest.sh | 140 +++++++++++++++++++++++++++++++-
> 1 file changed, 138 insertions(+), 2 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 0e681d4c3a15..38785a102236 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -41,14 +41,38 @@ readonly KERNEL_CMDLINE="\
> 	virtme.ssh virtme_ssh_channel=tcp virtme_ssh_user=$USER \
> "
> readonly LOG=$(mktemp /tmp/vsock_vmtest_XXXX.log)
>-readonly TEST_NAMES=(vm_server_host_client vm_client_host_server vm_loopback)
>+
>+# Namespace tests must use the ns_ prefix. This is checked in check_netns() and
>+# is used to determine if a test needs namespace setup before test execution.
>+readonly TEST_NAMES=(
>+	vm_server_host_client
>+	vm_client_host_server
>+	vm_loopback
>+	ns_host_vsock_ns_mode_ok
>+	ns_host_vsock_child_ns_mode_ok
>+)
> readonly TEST_DESCS=(
>+	# vm_server_host_client
> 	"Run vsock_test in server mode on the VM and in client mode on the host."
>+
>+	# vm_client_host_server
> 	"Run vsock_test in client mode on the VM and in server mode on the host."
>+
>+	# vm_loopback
> 	"Run vsock_test using the loopback transport in the VM."
>+
>+	# ns_host_vsock_ns_mode_ok
>+	"Check /proc/sys/net/vsock/ns_mode strings on the host."
>+
>+	# ns_host_vsock_child_ns_mode_ok
>+	"Check /proc/sys/net/vsock/ns_mode is read-only and child_ns_mode is writable."
> )
>
>-readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
>+readonly USE_SHARED_VM=(
>+	vm_server_host_client
>+	vm_client_host_server
>+	vm_loopback
>+)
> readonly NS_MODES=("local" "global")
>
> VERBOSE=0
>@@ -196,6 +220,20 @@ check_deps() {
> 	fi
> }
>
>+check_netns() {
>+	local tname=$1
>+
>+	# If the test requires NS support, check if NS support exists
>+	# using /proc/self/ns
>+	if [[ "${tname}" =~ ^ns_ ]] &&
>+	   [[ ! -e /proc/self/ns ]]; then
>+		log_host "No NS support detected for test ${tname}"
>+		return 1
>+	fi
>+
>+	return 0
>+}
>+
> check_vng() {
> 	local tested_versions
> 	local version
>@@ -519,6 +557,54 @@ log_guest() {
> 	LOG_PREFIX=guest log "$@"
> }
>
>+ns_get_mode() {
>+	local ns=$1
>+
>+	ip netns exec "${ns}" cat /proc/sys/net/vsock/ns_mode 2>/dev/null
>+}
>+
>+test_ns_host_vsock_ns_mode_ok() {
>+	for mode in "${NS_MODES[@]}"; do
>+		local actual
>+
>+		actual=$(ns_get_mode "${mode}0")
>+		if [[ "${actual}" != "${mode}" ]]; then
>+			log_host "expected mode ${mode}, got ${actual}"
>+			return "${KSFT_FAIL}"
>+		fi
>+	done
>+
>+	return "${KSFT_PASS}"
>+}
>+
>+test_ns_host_vsock_child_ns_mode_ok() {
>+	local orig_mode
>+	local rc
>+
>+	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
>+
>+	rc="${KSFT_PASS}"
>+	for mode in "${NS_MODES[@]}"; do
>+		local ns="${mode}0"
>+
>+		if echo "${mode}" 2>/dev/null > /proc/sys/net/vsock/ns_mode; then
>+			log_host "ns_mode should be read-only but write succeeded"
>+			rc="${KSFT_FAIL}"
>+			continue
>+		fi
>+
>+		if ! echo "${mode}" > /proc/sys/net/vsock/child_ns_mode; then
>+			log_host "child_ns_mode should be writable to ${mode}"
>+			rc="${KSFT_FAIL}"
>+			continue
>+		fi
>+	done
>+
>+	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
>+
>+	return "${rc}"
>+}
>+
> test_vm_server_host_client() {
> 	if ! vm_vsock_test "init_ns" "server" 2 "${TEST_GUEST_PORT}"; then
> 		return "${KSFT_FAIL}"
>@@ -592,6 +678,11 @@ run_shared_vm_tests() {
> 			continue
> 		fi
>
>+		if ! check_netns "${arg}"; then
>+			check_result "${KSFT_SKIP}" "${arg}"
>+			continue
>+		fi
>+
> 		run_shared_vm_test "${arg}"
> 		check_result "$?" "${arg}"
> 	done
>@@ -645,6 +736,49 @@ run_shared_vm_test() {
> 	return "${rc}"
> }
>
>+run_ns_tests() {
>+	for arg in "${ARGS[@]}"; do
>+		if shared_vm_test "${arg}"; then
>+			continue
>+		fi
>+
>+		if ! check_netns "${arg}"; then
>+			check_result "${KSFT_SKIP}" "${arg}"
>+			continue
>+		fi
>+
>+		add_namespaces
>+
>+		name=$(echo "${arg}" | awk '{ print $1 }')
>+		log_host "Executing test_${name}"
>+
>+		host_oops_before=$(dmesg 2>/dev/null | grep -c -i 'Oops')
>+		host_warn_before=$(dmesg --level=warn 2>/dev/null | grep -c -i 'vsock')
>+		eval test_"${name}"
>+		rc=$?
>+
>+		host_oops_after=$(dmesg 2>/dev/null | grep -c -i 'Oops')
>+		if [[ "${host_oops_after}" -gt "${host_oops_before}" ]]; then
>+			echo "FAIL: kernel oops detected on host" | log_host
>+			check_result "${KSFT_FAIL}" "${name}"
>+			del_namespaces
>+			continue
>+		fi
>+
>+		host_warn_after=$(dmesg --level=warn 2>/dev/null | grep -c -i 'vsock')
>+		if [[ "${host_warn_after}" -gt "${host_warn_before}" ]]; then
>+			echo "FAIL: kernel warning detected on host" | log_host
>+			check_result "${KSFT_FAIL}" "${name}"
>+			del_namespaces
>+			continue
>+		fi
>+
>+		check_result "${rc}" "${name}"
>+
>+		del_namespaces
>+	done
>+}
>+
> BUILD=0
> QEMU="qemu-system-$(uname -m)"
>
>@@ -690,6 +824,8 @@ if shared_vm_tests_requested "${ARGS[@]}"; then
> 	terminate_pidfiles "${pidfile}"
> fi
>
>+run_ns_tests "${ARGS[@]}"
>+
> echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
> echo "Log: ${LOG}"
>
>
>-- 
>2.47.3
>


