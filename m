Return-Path: <kvm+bounces-63584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB4FC6B2A3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 54C743603C2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478D63612C7;
	Tue, 18 Nov 2025 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwSeHjnT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUx8QKNE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A203727B4E1
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489764; cv=none; b=G3/CB+u52WxAUrZWWrztEPNDF+sVDpEVImxYfj+rWad6tXvJ5er8nSS26Yee5HWF1+X4oj8Q6S48iVicBSF9Gz8fXuHvYdOtT8U7QZlE2IekbeqUZcJdeSD7ruzYss3gJbVCyddmHANkbpNaStLsKnZrBH2wICuqfd6TJrfMfRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489764; c=relaxed/simple;
	bh=z9jngTjYXX2N3hDh12UT7kNeVGRmibW/GBVfuJWh90U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBrbhJHogF9AR25MTCg7o9WWzUpbw5SEZkhB0x/BBA7MCmnV5Z+Y2P6VlMQJyTu61gvpR8oq8G8oMazZ7fFoo5BXO3pmIrAiQLljyIv5StvsoMKX5uf9FR5vCD22SlnIh8whn4m7+1Z/smwzuZZcqP2edNpzj74ozFF2iJD0etc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwSeHjnT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUx8QKNE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763489761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCsmT1+txPJIS2fQNp3IVXkXdkTCnaVV7j7GhmxtV/c=;
	b=HwSeHjnTtxeGL1um019AnZKVXd9Bk8/JAu5iei1k/W/k+mGsV3s0mYtd9ryqY+ceg+28QY
	PmnfAZq6ps6zBfQVN1OWZxYLGxu1xOAIt6flCPKP6XiW9JKKu+NPMrDzh54OD/650sUT4E
	RKFpOq6VRPk7kpmEt33UK6N7y2Zv0vM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-xpcJsMG9OMyEAZYqOmLEKA-1; Tue, 18 Nov 2025 13:16:00 -0500
X-MC-Unique: xpcJsMG9OMyEAZYqOmLEKA-1
X-Mimecast-MFC-AGG-ID: xpcJsMG9OMyEAZYqOmLEKA_1763489759
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-64160e4d78eso5191475a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763489759; x=1764094559; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PCsmT1+txPJIS2fQNp3IVXkXdkTCnaVV7j7GhmxtV/c=;
        b=AUx8QKNErEgQv+mOvNtKSJyIqMXXtm+uHgDK9O1XHiF54XBZ0Spm52tcmMJz1xfwc8
         2RCqBZnEa0rhBRDCbGfIRWI2HBQziQQrGD2MtwZ29AMUpLC5UMjZanNs7NNRhQd0Ogwj
         zjuQXNhqjWiv/LdbN7snWjAN6XvekH1KP4KuFIiBmXHPSADxohoUjy5gf5+aPHBvR13V
         vz98b4x3syXPQ8M+ObY172k2odyTlg9MNDOhmS5tjch2WNMxLw8wAYvDTE6yO1R/1KPc
         dkwNhs56iukswuq+iyKiKqtt36fX0eW4tRwLRCxSoxf6OcKKsFfh+F32Dh6D68Wrs89A
         snMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763489759; x=1764094559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCsmT1+txPJIS2fQNp3IVXkXdkTCnaVV7j7GhmxtV/c=;
        b=ZyoHOqvbIt+mZBOfN8DDZJhmhIEGnRzBqYb3c/tlRJrWTpKc6bwamQLtVKq7vfraqn
         rMiaovnqdLfVdEj6cNGuNR4Jmz0fMH6pKmZupg4aZRhMnSwDJMVS2dAv4ZaXkqmNoES+
         5q173ofNEjDi6EkOsAB+Oz+OhuzonMG1kqEzqhkNrEUXduy4G7hGlSiSQp+NGAsElIPg
         48F3hF+Pe52uLi05MUIssP98DGNlSxv3CEOOBpTDdZgxitfhY8nVoKBV6xyAmZAIyNE1
         uHhnn/3cFUQG0BhWI05l40lwsMltZBl0INLJ5ApvNXYLiM0dWRMzCL8011enp7u1Rkbz
         R37g==
X-Forwarded-Encrypted: i=1; AJvYcCV9mMGvqRqksHqbC8Nrver93XE6yvhni64Xk9goC+SOQ0o1qEGWbIzB0X52WmTnMkDPzJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+nm98Bd6GrABi0MwGZA19F6f3GqCD3gYqwKNYZRZ6gu0fPjhv
	3E/XBQ5FL4CTIBDeT8GZpHAHfAllET1OFaNwGyiWbVU6A8g9xJjRpcqJKeL9v6BsaM6yeecxK+S
	c440H+ppn6/oE2ABW5lSPDTc8NoRgt2Vw9k6CmbZ/yvKGqL+nc8PJyw==
X-Gm-Gg: ASbGnctg1cuKyThpEQCl5v/SQA9Fh0116CbRd78IXj4+NufaPvoBM6qbyQfoG4KWgZF
	vy8J3euZg2L5KQvc1z0ih4aNasT1e2sWYCxNDPKZC7OJWl36KMpdxZ22utrTLIyD76AfOPIDan4
	Yejg/j2aLbyFlf5VDwm0yDw1XQpQbLw6aBWHV+t0kcujvTkwAqgdUftshey+ZARWgZdoLyZOGCg
	QWsi3XHsW7V9LdN1Ch1cj7v2n5e3ZzRKr8Ia9HK8HIjgxWFgVVaUJrBHnl+n8LlydM62Fz6Q5qR
	dyjkHfRFWrDi4TNBr0bcaLuIeX1653Ya8V5xKktVPwBUCeJDa6v5wYO2jon/nqfscFBL5dL2x6g
	bcbhwd17HI1fqTWbtm7P231WBgErwqCZ2+m9abG1BzhRAuEjiS9hJbC59Cgg=
X-Received: by 2002:a05:6402:42c4:b0:643:18c2:124e with SMTP id 4fb4d7f45d1cf-64350e0eedamr16148771a12.7.1763489758958;
        Tue, 18 Nov 2025 10:15:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoN0mxHlnHDgcN+NdZ5LOvg9qXOI9RJny5diigWO606GHOiHMHqYfRilSL5Y7K5784adc2+Q==
X-Received: by 2002:a05:6402:42c4:b0:643:18c2:124e with SMTP id 4fb4d7f45d1cf-64350e0eedamr16148731a12.7.1763489758430;
        Tue, 18 Nov 2025 10:15:58 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-250.retail.telecomitalia.it. [82.57.51.250])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4b28bbsm12919260a12.28.2025.11.18.10.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 10:15:56 -0800 (PST)
Date: Tue, 18 Nov 2025 19:15:50 +0100
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
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v10 11/11] selftests/vsock: add tests for
 namespace deletion and mode changes
Message-ID: <snj3w4fhh2az6wp6kf7ca3bgd6jp2aawvyic7thdnoktdumbx6@zmjqiorc2uda>
References: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
 <20251117-vsock-vmtest-v10-11-df08f165bf3e@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251117-vsock-vmtest-v10-11-df08f165bf3e@meta.com>

On Mon, Nov 17, 2025 at 06:00:34PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add tests that validate vsock sockets are resilient to deleting
>namespaces or changing namespace modes from global to local. The vsock
>sockets should still function normally.
>
>The function check_ns_changes_dont_break_connection() is added to re-use
>the step-by-step logic of 1) setup connections, 2) do something that
>would maybe break the connections, 3) check that the connections are
>still ok.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v9:
>- more consistent shell style
>- clarify -u usage comment for pipefile
>---
> tools/testing/selftests/vsock/vmtest.sh | 123 ++++++++++++++++++++++++++++++++
> 1 file changed, 123 insertions(+)
>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 9c12c1bd1edc..2b6e94aafc19 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -66,6 +66,12 @@ readonly TEST_NAMES=(
> 	ns_same_local_loopback_ok
> 	ns_same_local_host_connect_to_local_vm_ok
> 	ns_same_local_vm_connect_to_local_host_ok
>+	ns_mode_change_connection_continue_vm_ok
>+	ns_mode_change_connection_continue_host_ok
>+	ns_mode_change_connection_continue_both_ok
>+	ns_delete_vm_ok
>+	ns_delete_host_ok
>+	ns_delete_both_ok
> )
> readonly TEST_DESCS=(
> 	# vm_server_host_client
>@@ -135,6 +141,24 @@ readonly TEST_DESCS=(
>
> 	# ns_same_local_vm_connect_to_local_host_ok
> 	"Run vsock_test client in VM in a local ns with server in same ns."
>+
>+	# ns_mode_change_connection_continue_vm_ok
>+	"Check that changing NS mode of VM namespace from global to local after a connection is established doesn't break the connection"
>+
>+	# ns_mode_change_connection_continue_host_ok
>+	"Check that changing NS mode of host namespace from global to 
>local after a connection is established doesn't break the connection"
>+
>+	# ns_mode_change_connection_continue_both_ok
>+	"Check that changing NS mode of host and VM namespaces from global to local after a connection is established doesn't break the connection"
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
>@@ -1256,6 +1280,105 @@ test_ns_vm_local_mode_rejected() {
> 	return "${KSFT_PASS}"
> }
>
>+check_ns_changes_dont_break_connection() {
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
>+
>+	# wait_for_listener() does not work for vsock because vsock does not
>+	# export socket state to /proc/net/. Instead, we have no choice but to
>+	# sleep for some hardcoded time.
>+	sleep "${WAIT_PERIOD}"

can we use `ss --vsock --listening` ?

>+
>+	# We use a pipe here so that we can echo into the pipe instead of using
>+	# socat and a unix socket file. We just need a name for the pipe (not a
>+	# regular file) so use -u.
>+	pipefile=$(mktemp -u /tmp/vmtest_pipe_XXXX)

Should we remove this file at the end of the test?

>+	ip netns exec "${ns1}" \
>+		socat PIPE:"${pipefile}" VSOCK-CONNECT:"${VSOCK_CID}":"${port}" &
>+	pids+=($!)
>+
>+	timeout "${WAIT_PERIOD}" \
>+		bash -c 'while [[ ! -e '"${pipefile}"' ]]; do sleep 1; done; exit 0'
>+
>+	if [[ $2 == "delete" ]]; then
>+		if [[ "$1" == "vm" ]]; then
>+			ip netns del "${ns0}"
>+		elif [[ "$1" == "host" ]]; then
>+			ip netns del "${ns1}"
>+		elif [[ "$1" == "both" ]]; then
>+			ip netns del "${ns0}"
>+			ip netns del "${ns1}"
>+		fi
>+	elif [[ $2 == "change_mode" ]]; then
>+		if [[ "$1" == "vm" ]]; then
>+			ns_set_mode "${ns0}" "local"
>+		elif [[ "$1" == "host" ]]; then
>+			ns_set_mode "${ns1}" "local"
>+		elif [[ "$1" == "both" ]]; then
>+			ns_set_mode "${ns0}" "local"
>+			ns_set_mode "${ns1}" "local"
>+		fi
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
>+	rm -f "${outfile}"
>+
>+	return "${rc}"
>+}
>+
>+test_ns_mode_change_connection_continue_vm_ok() {
>+	check_ns_changes_dont_break_connection "vm" "change_mode"
>+}
>+
>+test_ns_mode_change_connection_continue_host_ok() {
>+	check_ns_changes_dont_break_connection "host" "change_mode"
>+}
>+
>+test_ns_mode_change_connection_continue_both_ok() {
>+	check_ns_changes_dont_break_connection "both" "change_mode"
>+}
>+
>+test_ns_delete_vm_ok() {
>+	check_ns_changes_dont_break_connection "vm" "delete"
>+}
>+
>+test_ns_delete_host_ok() {
>+	check_ns_changes_dont_break_connection "host" "delete"
>+}
>+
>+test_ns_delete_both_ok() {
>+	check_ns_changes_dont_break_connection "both" "delete"
>+}
>+
> shared_vm_test() {
> 	local tname
>
>
>-- 
>2.47.3
>


