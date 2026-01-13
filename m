Return-Path: <kvm+bounces-67961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 556B2D1A925
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFFDA304321B
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FC5350D63;
	Tue, 13 Jan 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHVkp9rW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvcC94OG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33CB33CE86
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768324630; cv=none; b=YJsJsaZWEc2JIwzOATopwqU/QntwC1xp0uiMkJtU+v8TQURw6hOi2ra7Ea7zCYU6b8w3EC59rE656iS3f9HLclMzKo1BioLTL9KG4Ze9HLDqmgTsEGYOluElqrToNx15ixNxaRzVebzTBVhqYVbGk77msZVDDqGGlgl4Oi194F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768324630; c=relaxed/simple;
	bh=BOiAlUio2xt6kMFB7Iqg42Lzr5vEiOhyy/79lkkulkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bx1r+B6br9ltHxokf6NwAymKciyyWwiFZlKPI5XqRGwaQ0W4VQ9lywL+mWAoza2aiwWXbPtYnRetWVqEVQgk1/7o8zYLX0NYGwwNUrlXQGW/3KS2fBNgOqqHinCxdpmCvg2uS9c0b1OpxwPQ1KlclQOKBRioi4BKg012pSDGCW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHVkp9rW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvcC94OG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768324625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3UUsl99U+a3n2frGXSYzi136UPXsqcjTTgTorfCP1Ac=;
	b=NHVkp9rWef3cOzZxI5LMGcVajFLYa324YszaVUXnNnW38uvMo6mEjYb11b8CDFgAJTKY8S
	cpnhnDDkUC06Rctsn1nAAzWX6Gm6WI1Mzgc8cv09je4d2c13r4GByJdk5InkroaW3QSM27
	2MjeEjmPB7LYaH6iOlAP4M7vHw5ZYRE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-9xTH1TemO8a9h3orO6yrmQ-1; Tue, 13 Jan 2026 12:17:04 -0500
X-MC-Unique: 9xTH1TemO8a9h3orO6yrmQ-1
X-Mimecast-MFC-AGG-ID: 9xTH1TemO8a9h3orO6yrmQ_1768324623
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47d5c7a2f54so71725e9.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768324623; x=1768929423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3UUsl99U+a3n2frGXSYzi136UPXsqcjTTgTorfCP1Ac=;
        b=SvcC94OGsB4Xo9umWEL7eXkSL+IYl73oOEst/2yYt4/gjx95IV8BbRUNTHACNc8xt8
         TbWNdq8s0Bg1OCIllQ/NuYmJPuPGVZGQtrrlZzx5NJRlDA9pPjHyunSzGOR7TElSl+mX
         1fSmS/khCurnqtRRhSJs3TUApeP178AJ4Zb7kEX5l3LvSFYLp8r0ojVM4kHYIIp168I2
         W7yGwVUo7kiNmQ2ibu1lMREcy/rcZ/UhBHNzU+XXR0lxFJam0VVxlvL5tZhm+upd421g
         RmKYRJJGmU/i/iZqoz90k0WVa9+MrYoC77clj07L4n171UYpUYddw//TMykMKDOrrBNy
         C1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768324623; x=1768929423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3UUsl99U+a3n2frGXSYzi136UPXsqcjTTgTorfCP1Ac=;
        b=lNMRmnYRF0Po2Bc0tfojgqi4XnyuFmhevbVEVY7TnAqejVtmwhXMPbq8CJV5Dh/rTW
         GSENIqFS2vl4h5/UQYtYvwNhssOIrKSY58kMXXbpsKHRMtYElE8RVBmBurjk/IrrG0I0
         TQWakAQJUGi1NxjpHJavDwwbygCdeOidXBulhkrKiQEAm7l6fSyat1A1duWJ5TdWTpam
         cmE6sD6UgiaPB2m7VuRFMekqPWNK7vJXWhQAoAmtEb5nGbdFgBxH1HQsdHPYeRyadQ6y
         myPTzdFU0+AeshsobvKuJ6eAWbMHhvjl1FCUAvX/6jMfKTXkefog7E2sGsb0/YSE12fz
         Vj7g==
X-Forwarded-Encrypted: i=1; AJvYcCXNyL47Qb+f7dSVTbESgNIBTR/C/DDAs9XETqx/YcDyclF5H86UN0OIvM7/FuEevCL/Q58=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyasbBaZyD6NBjNjw5AA8Lp6fC7om+HDUYfU4WxZl5BNpFpi80
	Bmvw+MzpSOo01HBOgYsuCnTX4lfErgPM9lQqiEkBZ3iGelsrDLt0broH3FKbqHSH7mh8GHr0sAM
	R6qvMQzlAfMmqtOmEERkrU3DhfrjMAWqRW5Q6IjcVKfDONSPlJjr2aA==
X-Gm-Gg: AY/fxX5AqQZKt+D+V14ers2o5MVVOUSjl885QijgQWUR5ZvLycmE6DB1h3M3m5YCnN4
	z0pgkXCvDPe3tfQWoBHqZ9IzijJJBdcOb0L0Y2qhnx88Zd/9ZmEDLlftfqepGmkbYickHPLHFjA
	yjTrsrgCFp0DhkWK9/j6/WtiAZiejRWrpleadMDBaGS2QSuoYj3AhqHab1mieBi9HBT/ZbEJbEO
	5Nn28T9FN1fgVHIC4aFKydp3SBp7SVfUrm2wNPNn/1OpK7t7TGro/V20JrKJp/NEH9lcZPrjiFN
	u1snuKWO3QbpgnLonYVzmHl7bs6UFQURK53ldlUeCMTjGE2VFkIcXzdvIXb8dLNIMcwIXdQdvqm
	q6F24O1bcY+40KznvhuCNh2WgPGwt1f8wY/z3VlGcVJQCdMIKPi/5aT1X3YZopg==
X-Received: by 2002:a05:600c:450a:b0:471:5c0:94fc with SMTP id 5b1f17b1804b1-47ed7c074f8mr51944395e9.6.1768324622961;
        Tue, 13 Jan 2026 09:17:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCSYBYlMR5NUmwo3nUrikwa7NopKszIR4niyQXAQsU/DKal6wX+cyMdumSidxaQyfxjCmWhA==
X-Received: by 2002:a05:600c:450a:b0:471:5c0:94fc with SMTP id 5b1f17b1804b1-47ed7c074f8mr51943825e9.6.1768324622288;
        Tue, 13 Jan 2026 09:17:02 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e17aasm45799146f8f.15.2026.01.13.09.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 09:17:01 -0800 (PST)
Date: Tue, 13 Jan 2026 18:16:41 +0100
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
Subject: Re: [PATCH net-next v14 12/12] selftests/vsock: add tests for
 namespace deletion
Message-ID: <aWZ92zp_zphz7geq@sgarzare-redhat>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
 <20260112-vsock-vmtest-v14-12-a5c332db3e2b@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260112-vsock-vmtest-v14-12-a5c332db3e2b@meta.com>

On Mon, Jan 12, 2026 at 07:11:21PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add tests that validate vsock sockets are resilient to deleting
>namespaces. The vsock sockets should still function normally.
>
>The function check_ns_delete_doesnt_break_connection() is added to
>re-use the step-by-step logic of 1) setup connections, 2) delete ns,
>3) check that the connections are still ok.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v13:
>- remove tests that change the mode after socket creation (this is not
>  supported behavior now and the immutability property is tested in other
>  tests)
>- remove "change_mode" behavior of
>  check_ns_changes_dont_break_connection() and rename to
>  check_ns_delete_doesnt_break_connection() because we only need to test
>  namespace deletion (other tests confirm that the mode cannot change)
>
>Changes in v11:
>- remove pipefile (Stefano)
>
>Changes in v9:
>- more consistent shell style
>- clarify -u usage comment for pipefile
>---
> tools/testing/selftests/vsock/vmtest.sh | 84 +++++++++++++++++++++++++++++++++
> 1 file changed, 84 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index a9eaf37bc31b..dc8dbe74a6d0 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -68,6 +68,9 @@ readonly TEST_NAMES=(
> 	ns_same_local_loopback_ok
> 	ns_same_local_host_connect_to_local_vm_ok
> 	ns_same_local_vm_connect_to_local_host_ok
>+	ns_delete_vm_ok
>+	ns_delete_host_ok
>+	ns_delete_both_ok
> )
> readonly TEST_DESCS=(
> 	# vm_server_host_client
>@@ -135,6 +138,15 @@ readonly TEST_DESCS=(
>
> 	# ns_same_local_vm_connect_to_local_host_ok
> 	"Run vsock_test client in VM in a local ns with server in same ns."
>+
>+	# ns_delete_vm_ok
>+	"Check that deleting the VM's namespace does not break the socket connection"
>+
>+	# ns_delete_host_ok
>+	"Check that deleting the host's namespace does not break the socket connection"
>+
>+	# ns_delete_both_ok
>+	"Check that deleting the VM and host's namespaces does not break the socket connection"
> )
>
> readonly USE_SHARED_VM=(
>@@ -1287,6 +1299,78 @@ test_vm_loopback() {
> 	return "${KSFT_PASS}"
> }
>
>+check_ns_delete_doesnt_break_connection() {
>+	local pipefile pidfile outfile
>+	local ns0="global0"
>+	local ns1="global1"
>+	local port=12345
>+	local pids=()
>+	local rc=0
>+
>+	init_namespaces
>+
>+	pidfile="$(create_pidfile)"
>+	if ! vm_start "${pidfile}" "${ns0}"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+	vm_wait_for_ssh "${ns0}"
>+
>+	outfile=$(mktemp)
>+	vm_ssh "${ns0}" -- \
>+		socat VSOCK-LISTEN:"${port}",fork STDOUT > "${outfile}" 2>/dev/null &
>+	pids+=($!)
>+	vm_wait_for_listener "${ns0}" "${port}" "vsock"
>+
>+	# We use a pipe here so that we can echo into the pipe instead of using
>+	# socat and a unix socket file. We just need a name for the pipe (not a
>+	# regular file) so use -u.
>+	pipefile=$(mktemp -u /tmp/vmtest_pipe_XXXX)
>+	ip netns exec "${ns1}" \
>+		socat PIPE:"${pipefile}" VSOCK-CONNECT:"${VSOCK_CID}":"${port}" &
>+	pids+=($!)
>+
>+	timeout "${WAIT_PERIOD}" \
>+		bash -c 'while [[ ! -e '"${pipefile}"' ]]; do sleep 1; done; exit 0'
>+
>+	if [[ "$1" == "vm" ]]; then
>+		ip netns del "${ns0}"
>+	elif [[ "$1" == "host" ]]; then
>+		ip netns del "${ns1}"
>+	elif [[ "$1" == "both" ]]; then
>+		ip netns del "${ns0}"
>+		ip netns del "${ns1}"
>+	fi
>+
>+	echo "TEST" > "${pipefile}"
>+
>+	timeout "${WAIT_PERIOD}" \
>+		bash -c 'while [[ ! -s '"${outfile}"' ]]; do sleep 1; done; exit 0'
>+
>+	if grep -q "TEST" "${outfile}"; then
>+		rc="${KSFT_PASS}"
>+	else
>+		rc="${KSFT_FAIL}"
>+	fi
>+
>+	terminate_pidfiles "${pidfile}"
>+	terminate_pids "${pids[@]}"
>+	rm -f "${outfile}" "${pipefile}"
>+
>+	return "${rc}"
>+}
>+
>+test_ns_delete_vm_ok() {
>+	check_ns_delete_doesnt_break_connection "vm"
>+}
>+
>+test_ns_delete_host_ok() {
>+	check_ns_delete_doesnt_break_connection "host"
>+}
>+
>+test_ns_delete_both_ok() {
>+	check_ns_delete_doesnt_break_connection "both"
>+}
>+
> shared_vm_test() {
> 	local tname
>
>
>-- 
>2.47.3
>


