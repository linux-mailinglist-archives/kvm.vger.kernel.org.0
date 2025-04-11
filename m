Return-Path: <kvm+bounces-43143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 303AFA85699
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 399BA1B84A70
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1102989A7;
	Fri, 11 Apr 2025 08:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUn3PeaB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D92980AC
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 08:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360379; cv=none; b=iuYVVf0EjCn3Mee4e00mAdWZpwxeGdgi+OZmFuMqJ2s4G6MWFBKL0kNQA8q1avYire57hJesi15gYv29KzdkJznQWrDTlexQFe5OJGirui70Udb7zNSavykihnMc9f456VztSV/v2KY4eXLlluIp6v7SXP5ls1/m5IB+sBZpOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360379; c=relaxed/simple;
	bh=lgrNRIFjhj6cjp4P03cOwtb0ckMI+mMDroBzDgh4FQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p40apIiCFqCMOaY7qJOtlZntmEyP+WICCipXNquqoLMe3C2cenBOWdVdpHhBSEHv5CDhpvfZrJ8kROayHyRDlzcuP3DXVL6Pdvi4OtbfZE4IkzcumufAcXzpOVM5uCLamXu2TBqT6uCMdcezAVjsObeFwe/0+stum+SWV4sO130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUn3PeaB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744360376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8ujDQyl7nKAjtDljWHbr44QpF+FLzPUnk9PsDaPq38=;
	b=VUn3PeaBuOZI1WizeegnOUCsmQWhd6jeG9TS/K30M5ynzQOFjaBxHA3149/4jY9DGlrljv
	22Mqrod6gP4bFYxjkPxz6WZqHuQI2IDRNUtpXUhjs8y2KapmfqfZK5ShImnZpoEzOgyIpl
	PjkhCO0lDhvizNZu+Nvh2HIYJlPaHsQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-fvKOgGKrNZSMCxFpd3rHkw-1; Fri, 11 Apr 2025 04:32:55 -0400
X-MC-Unique: fvKOgGKrNZSMCxFpd3rHkw-1
X-Mimecast-MFC-AGG-ID: fvKOgGKrNZSMCxFpd3rHkw_1744360374
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39c1b1c0969so1125750f8f.1
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 01:32:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744360374; x=1744965174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d8ujDQyl7nKAjtDljWHbr44QpF+FLzPUnk9PsDaPq38=;
        b=KfSCjuzhdzlDA37Yx9XvaIedBlX6XX4xdInTHLioMcY2cBfRL9ppL9Ipw4V46jRVvL
         qsjlg6F9Luj1gyzgyJChwFHy5l95g5SrH1nJCcX/DOikQa2lx9VoMKG8Qy8rxuChv5D7
         OERV/bLICLvGd5H1XWEJ2OJ43kAYAVJk3sH0OP/g4iX4cop+7djJonRt/Px41OENTHJ0
         cqxUeDSpcC36+ljCFhhfTNZ6SmoTGW2Gs75rwVQftu2KD4p9eTztkxLJPLY/RbvRYfZ5
         X4arAfUjK3uppeGapkt7xndj00FJD0KDF96mtz8YqSMoMo7pqs3IA3lpBUJf/Jc/DtB9
         W6Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVPFfvmZZIg3T9rXooZBpZFmI5aekrifHbL5h1We43c8d5MQXYVo14LwYN9Y/wZJhkA7VQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWBnhRC7VWo1ItkJb6CASK8uUzosZ7b4HazNOEHuGWloarkMre
	L8Ei7rUAyAGwGX5dQKoF7VADc849ErWLaObuh4Ck8D6IsDwOH72r0tn1FScdhq36ZcdaUVKyv/r
	LvFnwhFfP1fy+V964zSngQ37a9Ogy6WSGe+r6PFNDscoMU1N4bw==
X-Gm-Gg: ASbGncvEQatW9ZCaeQse8A3pmrtqvu5gZtAp9DYEfmT3VxJ7nHfcorI22XeGGksb771
	NFAcP1r0BdHHwKrl/SUsrDuNB2oEQUWhxTL1LJlfkGPrXlDMC48HJbaiRYvTD7DO2feklSy/lWt
	zO+FdaBhite2BmJJRqh0BlwnCVOF5rfvKShW/uTLAqZfNClNKmpja65hlxQS7DoR2H3l83TjihZ
	RmLcsa/YoaLFnt6YuvdLaIdczbqUida0nSloSsC3X3iX3DSFnE6+c/uxXzG6P2nu8lDwJbFOt2W
	LnTQ8Fe5+qmaxlKHzY0AacerRILc+yNKCu4qmeIaVP9kFRpnF3oMJMhOWkkH
X-Received: by 2002:a05:6000:1867:b0:391:3124:f287 with SMTP id ffacd0b85a97d-39ea52071d9mr1169982f8f.16.1744360373883;
        Fri, 11 Apr 2025 01:32:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYRObXGVdy7Fk5Huz1lKq/zXGFWZpzxM8mzE0+DPpVva9VRqqW0i3itgSpYq9hY1Wb+D8CEg==
X-Received: by 2002:a05:6000:1867:b0:391:3124:f287 with SMTP id ffacd0b85a97d-39ea52071d9mr1169957f8f.16.1744360373377;
        Fri, 11 Apr 2025 01:32:53 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-213.retail.telecomitalia.it. [79.53.30.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eaf43cd17sm1302888f8f.78.2025.04.11.01.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 01:32:52 -0700 (PDT)
Date: Fri, 11 Apr 2025 10:32:45 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next] selftests/vsock: add initial vmtest.sh for vsock
Message-ID: <36wtdlekqx7hii6s7uydxeyrwwj7x5dmx5k5g474eseds6lshk@yrefm7laynyp>
References: <20250410-vsock-vmtest-v1-1-f35a81dab98c@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250410-vsock-vmtest-v1-1-f35a81dab98c@gmail.com>

On Thu, Apr 10, 2025 at 06:07:59PM -0700, Bobby Eshleman wrote:
>This commit introduces a new vmtest.sh runner for vsock.
>
>It uses virtme-ng/qemu to run tests in a VM. The tests are designed to
>validate both G2H and H2G paths. The testing tools from tools from
>tools/testing/vsock/ are reused. Currently, only vsock_test is used.

Coool, thanks for that.
I'll leave some comments, but I'll try this next week since today I'm a 
bit busy.

>
>Only tested on x86.
>
>To run:
>
>  $ tools/testing/selftests/vsock/vmtest.sh
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>---
> MAINTAINERS                                |   1 +
> tools/testing/selftests/vsock/.gitignore   |   1 +
> tools/testing/selftests/vsock/config.vsock |   6 +
> tools/testing/selftests/vsock/vmtest.sh    | 247 +++++++++++++++++++++++++++++
> 4 files changed, 255 insertions(+)
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index c3fce441672349f7850c57d788bc1a29b203fba5..f214cf7c4fb59ec67885ee6c81daa44e17c80f5f 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -25323,6 +25323,7 @@ F:	include/uapi/linux/vm_sockets.h
> F:	include/uapi/linux/vm_sockets_diag.h
> F:	include/uapi/linux/vsockmon.h
> F:	net/vmw_vsock/
>+F:	tools/testing/selftests/vsock/
> F:	tools/testing/vsock/
>
> VMALLOC
>diff --git a/tools/testing/selftests/vsock/.gitignore b/tools/testing/selftests/vsock/.gitignore
>new file mode 100644
>index 0000000000000000000000000000000000000000..1950aa8ac68c0831c12c1aaa429da45bbe41e60f
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/.gitignore
>@@ -0,0 +1 @@
>+vsock_selftests.log
>diff --git a/tools/testing/selftests/vsock/config.vsock b/tools/testing/selftests/vsock/config.vsock
>new file mode 100644
>index 0000000000000000000000000000000000000000..a229c329d44e4a0b650d073b74949b577da3dc64
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/config.vsock
>@@ -0,0 +1,6 @@
>+CONFIG_VSOCKETS=y
>+CONFIG_VSOCKETS_DIAG=y
>+CONFIG_VSOCKETS_LOOPBACK=y
>+CONFIG_VIRTIO_VSOCKETS=y
>+CONFIG_VIRTIO_VSOCKETS_COMMON=y
>+CONFIG_VHOST_VSOCK=y

Should we enabled also other transports?

(I'm not sure since we don't test it)

>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>new file mode 100755
>index 0000000000000000000000000000000000000000..f2dafcb893232f95ebb22104a62ce1e0312f4e89
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -0,0 +1,247 @@
>+#!/bin/bash
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# Copyright (c) 2025 Meta Platforms, Inc. and affiliates
>+#
>+# Dependencies:
>+#		* virtme-ng
>+#		* busybox-static (used by virtme-ng)
>+#		* qemu	(used by virtme-ng)
>+
>+SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
>+KERNEL_CHECKOUT=$(realpath ${SCRIPT_DIR}/../../../..)
>+PLATFORM=${PLATFORM:-$(uname -m)}
>+
>+if [[ -z "${QEMU:-}" ]]; then
>+	QEMU=$(which qemu-system-${PLATFORM})
>+fi
>+
>+VSOCK_TEST=${KERNEL_CHECKOUT}/tools/testing/vsock/vsock_test
>+
>+TEST_GUEST_PORT=51000
>+TEST_HOST_PORT=50000
>+TEST_HOST_PORT_LISTENER=50001
>+SSH_GUEST_PORT=22
>+SSH_HOST_PORT=2222
>+VSOCK_CID=1234
>+
>+QEMU_PIDFILE=/tmp/qemu.pid
>+
>+# virtme-ng offers a netdev for ssh when using "--ssh", but we also need a
>+# control port forwarded for vsock_test.  Because virtme-ng doesn't support
>+# adding an additional port to forward to the device created from "--ssh" and
>+# virtme-init mistakenly sets identical IPs to the ssh device and additional
>+# devices, we instead opt out of using --ssh, add the device manually, and also
>+# add the kernel cmdline options that virtme-init uses to setup the interface.
>+QEMU_OPTS=""
>+QEMU_OPTS="${QEMU_OPTS} -netdev user,id=n0,hostfwd=tcp::${TEST_HOST_PORT}-:${TEST_GUEST_PORT}"
>+QEMU_OPTS="${QEMU_OPTS},hostfwd=tcp::${SSH_HOST_PORT}-:${SSH_GUEST_PORT}"
>+QEMU_OPTS="${QEMU_OPTS} -device virtio-net-pci,netdev=n0"
>+QEMU_OPTS="${QEMU_OPTS} -device vhost-vsock-pci,guest-cid=${VSOCK_CID}"
>+QEMU_OPTS="${QEMU_OPTS} --pidfile ${QEMU_PIDFILE}"
>+KERNEL_CMDLINE="virtme.dhcp net.ifnames=0 biosdevname=0 virtme.ssh virtme_ssh_user=$USER"
>+
>+LOG=${SCRIPT_DIR}/vsock_selftests.log
>+
>+#		Name				Description
>+tests="
>+	vm_server_host_client			Run vsock_test in server mode on the VM and in client mode on the host.
>+	vm_client_host_server			Run vsock_test in client mode on the VM and in server mode on the host.

What about adding tests also with loopback in the VM?

>+"
>+
>+usage() {
>+	echo
>+	echo "$0 [OPTIONS]"
>+	echo
>+	echo "Options"
>+	echo "  -v: verbose output"
>+	echo
>+	echo "Available tests${tests}"
>+	exit 1
>+}
>+
>+die() {
>+	echo "$*" >&2
>+	exit 1
>+}
>+
>+vm_ssh() {
>+	ssh -q -o UserKnownHostsFile=/dev/null -p 2222 localhost $*
>+	return $?
>+}
>+
>+cleanup() {
>+	if [[ -f "${QEMU_PIDFILE}" ]]; then
>+		pkill -9 -F ${QEMU_PIDFILE} 2>&1 >/dev/null
>+	fi
>+}
>+
>+build() {
>+	log_setup "Building kernel and tests"
>+
>+	pushd ${KERNEL_CHECKOUT} >/dev/null
>+	vng \
>+		--kconfig \
>+		--config ${KERNEL_CHECKOUT}/tools/testing/selftests/vsock/config.vsock
>+	make -j$(nproc)
>+	make -C ${KERNEL_CHECKOUT}/tools/testing/vsock
>+	popd >/dev/null
>+	echo
>+}
>+
>+vm_setup() {
>+	local VNG_OPTS=""
>+	if [[ "${VERBOSE}" = 1 ]]; then
>+		VNG_OPTS="--verbose"
>+	fi
>+	vng \
>+		$VNG_OPTS	\
>+		--run ~/local/linux \
>+		--qemu /bin/qemu-system-x86_64 \
>+		--qemu-opts="${QEMU_OPTS}" \
>+		--user root \
>+		--append "${KERNEL_CMDLINE}" \
>+		--rw  2>&1 >/dev/null &
>+}
>+
>+vm_wait_for_ssh() {
>+	i=0
>+	while [[ true ]]; do
>+		if (( i > 20 )); then
>+			die "Timed out waiting for guest ssh"
>+		fi
>+		vm_ssh -- true
>+		if [[ $? -eq 0 ]]; then
>+			break
>+		fi
>+		i=$(( i + 1 ))
>+		sleep 5
>+	done
>+}
>+
>+wait_for_listener() {
>+	local PORT=$1
>+	local i=0
>+	while ! ss -ltn | grep -q ":${PORT}"; do
>+		if (( i > 30 )); then
>+			die "Timed out waiting for listener on port ${PORT}"
>+		fi
>+		sleep 3
>+		i=$(( i + 1 ))
>+	done
>+}
>+
>+vm_wait_for_listener() {
>+	vm_ssh -- "$(declare -f wait)for_listener); wait_for_listener 
>${TEST_GUEST_PORT}"
>+}
>+
>+host_wait_for_listener() {
>+	wait_for_listener ${TEST_HOST_LISTENER_PORT}
>+}
>+
>+log() {
>+	local prefix="$1"
>+	shift
>+
>+	if [[ "$#" -eq 0 ]]; then
>+		cat | awk '{ printf "%s:\t%s\n","'"${prefix}"'", $0 }' | tee -a ${LOG}
>+	else
>+		echo "$*" | awk '{ printf "%s:\t%s\n","'"${prefix}"'", $0 }' | tee -a ${LOG}
>+	fi
>+}
>+
>+log_setup() {
>+	log "setup" "$@"
>+}
>+
>+log_host() {
>+	testname=$1
>+	shift
>+	log "test:${testname}:host" "$@"
>+}
>+
>+log_guest() {
>+	testname=$1
>+	shift
>+	log "test:${testname}:guest" "$@"
>+}
>+
>+test_vm_server_host_client() {
>+	local testname="vm_server_host_client"
>+	vm_ssh -- "${VSOCK_TEST}" \
>+							--mode=server \
>+							--control-port="${TEST_GUEST_PORT}" \
>+							--peer-cid=2 \
>+							2>&1 | log_guest "${testname}" &

Strange indentation here.

>+
>+	vm_wait_for_listener
>+	${VSOCK_TEST}	\
>+		--mode=client	\
>+		--control-host=127.0.0.1	\
>+		--peer-cid="${VSOCK_CID}"	\
>+		--control-port="${TEST_HOST_PORT}" 2>&1 | log_host "${testname}"
>+
>+	rc=$?
>+}
>+
>+test_vm_client_host_server() {
>+	local testname="vm_client_host_server"
>+
>+	${VSOCK_TEST}	\
>+		--mode "server" \
>+		--control-port "${TEST_HOST_PORT_LISTENER}" \
>+		--peer-cid "${VSOCK_CID}" 2>&1 | log_host "${testname}" &
>+
>+	host_wait_for_listener
>+
>+	vm_ssh -- "${VSOCK_TEST}"	\
>+		--mode=client	\
>+		--control-host=10.0.2.2	\
>+		--peer-cid=2	\
>+		--control-port="${TEST_HOST_PORT_LISTENER}" 2>&1 | log_guest "${testname}"
>+
>+	rc=$?
>+}
>+
>+run_test() {
>+	unset IFS
>+	name=$(echo "${1}" | awk '{ print $1 }')
>+	eval test_"${name}"
>+}
>+
>+while getopts :hv o
>+do
>+	case $o in
>+	v) VERBOSE=1;;
>+	h|*) usage;;
>+	esac
>+done
>+shift $((OPTIND-1))
>+
>+trap cleanup EXIT
>+
>+> ${LOG}
>+build
>+log_setup "Booting up VM"
>+vm_setup
>+vm_wait_for_ssh
>+log_setup "VM booted up"
>+
>+IFS="
>+"
>+cnt=0
>+for t in ${tests}; do
>+	rc=0
>+	run_test "${t}"
>+	if [[ ${rc} != 0 ]]; then
>+		cnt=$(( cnt + 1 ))
>+	fi
>+done
>+
>+if [[ ${cnt} = 0 ]]; then
>+	echo OK

In my suite I also check if we have some kernel warnings or oops.
Should we add something similar or does the infrastructure already
handle that?

Thanks,
Stefano

>+else
>+	echo FAILED: ${cnt}
>+fi
>+echo "Log: ${LOG}"
>+exit ${cnt}
>
>---
>base-commit: cc04ed502457412960d215b9cd55f0d966fda255
>change-id: 20250325-vsock-vmtest-b3a21d2102c2
>
>Best regards,
>-- 
>Bobby Eshleman <bobbyeshleman@gmail.com>
>


