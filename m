Return-Path: <kvm+bounces-45207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA6DAA6F79
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 12:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34BCB4C1EDB
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 10:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9410623C4F4;
	Fri,  2 May 2025 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cVD1cSQl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB21DB546
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 10:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746181374; cv=none; b=armP2EJvNfRSeJGk4KpydVosW0LKJvJrHXeruyEXIMSYzflk78QyC5m4S4vnrORtVfITDcKNLtsptFLdjQyEGLbkOoc9s2m2iU1dqMIyiUrHvjFaV/Zr8uyiQ+4Ty5j1z/E1PnpScdoTg0yg1zViPuUaMygRbxgFzIBJDW41gIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746181374; c=relaxed/simple;
	bh=i0/o7pVkw7duSUK3m7urAHcNVUQGmAMppqUpi02REMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L85NAg07OSdydcRjshE/TK+2cC9W4DBFL2A731GDd04zoiHUJOl13PuhiN01nxZhbTp6DFPK88V0qT7Qt7VGerHTX31id5alfbF06P8ZbmsilvWhDfiKe0HB9JH1gacPi+LK/2+n1F+nKu2ekwfknid/xdMAQG8mUjL+/mlfF6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cVD1cSQl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746181371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPxLSU1XqT/NXlV7eFy5ZcbBJizdwKiKGPSIW+m2/2o=;
	b=cVD1cSQl9NEJtDyuky8TRWttSz1VuqYPXK2hVDDbFHlY78BBbB7QvyMQD/PR904q/nkygV
	44AZOOd5/Ab0jHJ1E+elu144tMW9GjnFaWJHcXkQczW363GVc9yXzmyQNtr4e3OMD0o1Y6
	mjomuqMIuOwOfj4z/viFqjXqs4dFPnA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-195T2bMPNMy_LJLnqJ2Haw-1; Fri, 02 May 2025 06:22:50 -0400
X-MC-Unique: 195T2bMPNMy_LJLnqJ2Haw-1
X-Mimecast-MFC-AGG-ID: 195T2bMPNMy_LJLnqJ2Haw_1746181369
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39abdadb0f0so587748f8f.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 03:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746181369; x=1746786169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPxLSU1XqT/NXlV7eFy5ZcbBJizdwKiKGPSIW+m2/2o=;
        b=G1I12uTqPx6zcJqFSEPyXSMz9wXe1QsdgVMnS6LZJryURzG1S9zAcm6xnmKvA4JGrq
         j3X66YJged4TbMr2/zbeSptSR6yVfhz7cshfowcbKxt5QjYsZ5R/bSMXRkQUB/d5UK/b
         GAxhUlVSmqvYvJCvuJchnkRlDq9SR6zVqS9hk3UWIZVR1yFnZWv8arwoaCYlH43lczbi
         +MzRo+ctFDN4h5GpRqoDTSt1XGXE5tTmlIxoFRuvcLZD18On6pSvuGjT67IZzMI5NUqL
         uhxTxrw9bU0izwbK9AUgumKDvdozpOC0stlBa3oKiSTEvuGc7/ra7bfxLaTJn1nipOtp
         rAHQ==
X-Gm-Message-State: AOJu0YyAqzAGwn9VpPpUyZww7Dows0o6p8Pp7vJGoc2uHfCv0Uek6/9z
	uczgk2uTDq5MDaxfSxScboRsa8zQQB+wEw10hiDHbxyzwN4NImMZvs5Iiq17wTnvMO4HCYhBEAo
	cZG+G2WSkL0KhDZ2vgNjYfneNC8gsrWJzsjZXecsbVa2DNDqsEw==
X-Gm-Gg: ASbGnctFOFD8+yRTKpkOqcngEzmMTnRf9u3yWsLFUs8vBRV6hB61mnaZmf3mW6nJiM5
	gwwcxAqZjaW37fF994UifQxQ5r25wJordP4wBeW9HN3D6xzPvtJ2X+Vmk+ba+Glz5TikMSCn49E
	U+fFX+hd3p+LBEDDCB6NFejKlZ8sXhrY6vj/BFg3VUJVP+6UPIAlapfWySlW38HY8t4PlGeAQIU
	EArOD3Upv+zlVwwqmb6HHleP9PG0VtK0s5ATjPZMtPmYYufgMQTUE+uYcAx0me6SSxfNVvwrR+L
	GbggF5slqHzf4f/CnAI=
X-Received: by 2002:a05:6000:4387:b0:391:4674:b10f with SMTP id ffacd0b85a97d-3a099ae9774mr1913554f8f.36.1746181369494;
        Fri, 02 May 2025 03:22:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzkS1lKR2T7hyh9gkaUuVs/7+Dq04YWJdFuTxAo1hUYcodL6jGaO9eOC3AbB7PExj+iPODSw==
X-Received: by 2002:a05:6000:4387:b0:391:4674:b10f with SMTP id ffacd0b85a97d-3a099ae9774mr1913529f8f.36.1746181369141;
        Fri, 02 May 2025 03:22:49 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:246d:aa10::f39? ([2a0d:3344:246d:aa10::f39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae0c25sm1762567f8f.17.2025.05.02.03.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 03:22:48 -0700 (PDT)
Message-ID: <3e3eea6b-10a6-4a32-aa12-ef6fdf2eeeb8@redhat.com>
Date: Fri, 2 May 2025 12:22:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3] selftests/vsock: add initial vmtest.sh for
 vsock
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20250428-vsock-vmtest-v3-1-181af6163f3e@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250428-vsock-vmtest-v3-1-181af6163f3e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/29/25 1:48 AM, Bobby Eshleman wrote:
> This commit introduces a new vmtest.sh runner for vsock.
> 
> It uses virtme-ng/qemu to run tests in a VM. The tests validate G2H,
> H2G, and loopback. The testing tools from tools/testing/vsock/ are
> reused. Currently, only vsock_test is used.
> 
> VMCI and hyperv support is automatically built, though not used.
> 
> Only tested on x86.
> 
> To run:
> 
>   $ tools/testing/selftests/vsock/vmtest.sh
> 
> or
> 
>   $ make -C tools/testing/selftests TARGETS=vsock run_tests
> 
> Results:
> 	# linux/tools/testing/selftests/vsock/vmtest.log
> 	setup:  Building kernel and tests
> 	setup:  Booting up VM
> 	setup:  VM booted up
> 	test:vm_server_host_client:guest:       Control socket listening on 0.0.0.0:51000
> 	test:vm_server_host_client:guest:       Control socket connection accepted...
> 	[...]
> 	test:vm_loopback:guest: 30 - SOCK_STREAM retry failed connect()...ok
> 	test:vm_loopback:guest: 31 - SOCK_STREAM SO_LINGER null-ptr-deref...ok
> 	test:vm_loopback:guest: 31 - SOCK_STREAM SO_LINGER null-ptr-deref...ok
> 
> Future work can include vsock_diag_test.
> 
> vmtest.sh is loosely based off of tools/testing/selftests/net/pmtu.sh,
> which was picked out of the bag of tests I knew to work with NIPA.
> 
> Because vsock requires a VM to test anything other than loopback, this
> patch adds vmtest.sh as a kselftest itself. This is different than other
> systems that have a "vmtest.sh", where it is used as a utility script to
> spin up a VM to run the selftests as a guest (but isn't hooked into
> kselftest). This aspect is worth review, as I'm not aware of all of the
> enviroments where this would run.

I think this approach is interesting, but I think it will need some
additional more work, see below...

[...]

> diff --git a/tools/testing/selftests/vsock/settings b/tools/testing/selftests/vsock/settings
> new file mode 100644
> index 0000000000000000000000000000000000000000..e7b9417537fbc4626153b72e8f295ab4594c844b
> --- /dev/null
> +++ b/tools/testing/selftests/vsock/settings
> @@ -0,0 +1 @@
> +timeout=0

We need a reasonable, bounded runtime for nipa integration.

> diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
> new file mode 100755
> index 0000000000000000000000000000000000000000..d70b9446e531d6d20beb24ddeda2cf0a9f7e9a39
> --- /dev/null
> +++ b/tools/testing/selftests/vsock/vmtest.sh
> @@ -0,0 +1,354 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright (c) 2025 Meta Platforms, Inc. and affiliates
> +#
> +# Dependencies:
> +#		* virtme-ng
> +#		* busybox-static (used by virtme-ng)
> +#		* qemu	(used by virtme-ng)

You should probably check for such tools presence and bail out with skip
otherwise.

> +
> +SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
> +KERNEL_CHECKOUT=$(realpath ${SCRIPT_DIR}/../../../..)

This is not going to work if/when the self-tests are installed in their
own directory via `make install` in the tools/testing/selftests/
directory, and that use case is supposed to work.

At very least you should check for the expected layout and skip otherwise.

> +QEMU=$(command -v qemu-system-$(uname -m))
> +VERBOSE=0
> +SKIP_BUILD=0
> +VSOCK_TEST=${KERNEL_CHECKOUT}/tools/testing/vsock/vsock_test
> +
> +TEST_GUEST_PORT=51000
> +TEST_HOST_PORT=50000
> +TEST_HOST_PORT_LISTENER=50001
> +SSH_GUEST_PORT=22
> +SSH_HOST_PORT=2222
> +VSOCK_CID=1234
> +WAIT_PERIOD=3
> +WAIT_PERIOD_MAX=20
> +
> +QEMU_PIDFILE=/tmp/qemu.pid
> +
> +# virtme-ng offers a netdev for ssh when using "--ssh", but we also need a
> +# control port forwarded for vsock_test.  Because virtme-ng doesn't support
> +# adding an additional port to forward to the device created from "--ssh" and
> +# virtme-init mistakenly sets identical IPs to the ssh device and additional
> +# devices, we instead opt out of using --ssh, add the device manually, and also
> +# add the kernel cmdline options that virtme-init uses to setup the interface.
> +QEMU_OPTS=""
> +QEMU_OPTS="${QEMU_OPTS} -netdev user,id=n0,hostfwd=tcp::${TEST_HOST_PORT}-:${TEST_GUEST_PORT}"
> +QEMU_OPTS="${QEMU_OPTS},hostfwd=tcp::${SSH_HOST_PORT}-:${SSH_GUEST_PORT}"
> +QEMU_OPTS="${QEMU_OPTS} -device virtio-net-pci,netdev=n0"
> +QEMU_OPTS="${QEMU_OPTS} -device vhost-vsock-pci,guest-cid=${VSOCK_CID}"
> +QEMU_OPTS="${QEMU_OPTS} --pidfile ${QEMU_PIDFILE}"
> +KERNEL_CMDLINE="virtme.dhcp net.ifnames=0 biosdevname=0 virtme.ssh virtme_ssh_user=$USER"
> +
> +LOG=${SCRIPT_DIR}/vmtest.log
> +
> +#		Name				Description
> +avail_tests="
> +	vm_server_host_client	Run vsock_test in server mode on the VM and in client mode on the host.	
> +	vm_client_host_server	Run vsock_test in client mode on the VM and in server mode on the host.	
> +	vm_loopback		Run vsock_test using the loopback transport in the VM.	
> +"
> +
> +usage() {
> +	echo
> +	echo "$0 [OPTIONS] [TEST]..."
> +	echo "If no TEST argument is given, all tests will be run."
> +	echo
> +	echo "Options"
> +	echo "  -v: verbose output"
> +	echo "  -s: skip build"
> +	echo
> +	echo "Available tests${avail_tests}"
> +	exit 1
> +}
> +
> +die() {
> +	echo "$*" >&2
> +	exit 1
> +}
> +
> +vm_ssh() {
> +	ssh -q -o UserKnownHostsFile=/dev/null -p 2222 localhost $*
> +	return $?
> +}
> +
> +cleanup() {
> +	if [[ -f "${QEMU_PIDFILE}" ]]; then
> +		pkill -SIGTERM -F ${QEMU_PIDFILE} 2>&1 >/dev/null
> +	fi
> +}
> +
> +build() {
> +	log_setup "Building kernel and tests"
> +
> +	pushd ${KERNEL_CHECKOUT} >/dev/null
> +	vng \
> +		--kconfig \
> +		--config ${KERNEL_CHECKOUT}/tools/testing/selftests/vsock/config.vsock
> +	make -j$(nproc)
> +	make -C ${KERNEL_CHECKOUT}/tools/testing/vsock
> +	popd >/dev/null

I think it would be better to avoid the kernel rebuild. A possible
alternative could be including in 'config' the needed knobs for vng's
sake and re-use the running kernel.

Cheers,

Paolo


