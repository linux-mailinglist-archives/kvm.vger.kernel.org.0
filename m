Return-Path: <kvm+bounces-44915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DD1AA4D0F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 998143B89D6
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 13:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8553925B1DF;
	Wed, 30 Apr 2025 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZSewjpW+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF331E50B
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746018390; cv=none; b=HJOcPgs+CdV6HDC85jWl696ttF1z6JGnpbgRHbh9d357k77nDV/gBs4ntxq50yScc5LzI7amGo1+AXCg3ZNyKT0jjFanMtcfGEGMVQVQNgBScn6OpCx42u3flO1p72K9XVEcS+oPdSSXsev7sguUALp3Gaic9JYd+BlPtpiYkj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746018390; c=relaxed/simple;
	bh=tKOpGUC7ICWYqzLR0Sa9YobzLH3alk5fppaf96BIteo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKUl3QyygclOrvCLg+HnzGrfKOR70ytElgjfqioYsXsyXvwLyCyU42LTfU3rQXwEAk/yMtUu0Z3EhhiCC1wqrwSLwNtD850rVRsOogWMLk04TkEBjBUuu9S4lVrMc6jicrR7R2QZcXxa3x7Qg/iLLboGj0qDu4i0FJSoINA5Fss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZSewjpW+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746018386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yU7j6MTB7ETLLbsy2XV7Tf/pFyt+c5jKYMEFcLpSFU=;
	b=ZSewjpW+trADu00DcEXGmkcf64SrwtnSKvGEjwsiiCMgfbk57+qS/jyK8ydZLurciRHmeQ
	V/IX/hbALP5vOpPqgRGE2Im2KPZ0L1Wq1Qr43nbOH1bxHSibkyW6CGXaRi2uOMwLauBLU/
	2WkMkQiJpFV6JhlXQXnmtzcUWrlD0FM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-xTHqn-XhOy2XHUo0xY8XTQ-1; Wed, 30 Apr 2025 09:06:24 -0400
X-MC-Unique: xTHqn-XhOy2XHUo0xY8XTQ-1
X-Mimecast-MFC-AGG-ID: xTHqn-XhOy2XHUo0xY8XTQ_1746018383
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e5d9682f53so6243638a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 06:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746018383; x=1746623183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yU7j6MTB7ETLLbsy2XV7Tf/pFyt+c5jKYMEFcLpSFU=;
        b=tiRxdEwG4Ittcdtn1XxhO1bwhVaZpLv0g4d6CdJm1x54hh8KSgwYyt9hNh8oiyiNGy
         fWMRM45/Hkltd5rsen81M4j1+flpEyC6J2vCpcCONlscDeVSeXIW0bJflGL1rHRrA2MT
         yUS3wBkDJ3JMrrSXuljteEkzOz02GW7nfL4NFzknU5geFvzx3T8imjzIFZFBeRCtpbQi
         WOGzNOt+Q08Or/XHnER2gNQm/lEP77uKJLev+CyZb01bL9nWEKbRzD7huv2/oPJY/7gX
         A7H6OC/452adofF7qJy33UY7h+/1lcsxaawuNpd8xRKDup1em36dEy2UACsVQiA1QWkk
         C/uw==
X-Forwarded-Encrypted: i=1; AJvYcCWEjWQLIpH6N03ztrLruFbuyeuSoWritqNvGfnjB620vsN3OyyG9c7QE/8bC96gFVEL5uE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRSfWmMl7xjW2QzCpY4SGAM44j+7zwTEndzxkANf57h78YZ9p2
	6ISQsfbuZ1NIH88haO762fo2atTShSrEf0goMpqCBtXHUzDcWBaVVXbJm71scJWcRk82kd9zfUe
	BHCy6Go/78V4JBYdQjZSUXR1F3kF6YlrND/KgzSx1H10Givt1jQ==
X-Gm-Gg: ASbGnctwOc462a0mOfaau6SFACUeqyu5L0kp07TGofg42uNedCQvPKArZFaOyYAspsM
	Qqf+HT4AAxtN2YgBr4lxupwddWqr2kl3qjJceXl4mt0uxuGlKFqASnc/eyjRXKAxR6lbFrAGcZh
	D5SeCHw2Hc/OyLvY+j+399qUe7+mK51Iin9enRUer95Y2YwmSoupLjr3fRsSbC3Uol5586X8HFO
	dg5QeUS3yvsViLrGvI+xH1ynDMbBtIDpE7cuDPJGaRl5ovV7y00dynls+/YBy9f4l8D5mEMvzvq
	h4BMrxpBWNNZbuYODA==
X-Received: by 2002:a17:907:2099:b0:ace:d7af:15e1 with SMTP id a640c23a62f3a-acee21ec8b4mr205106466b.28.1746018382513;
        Wed, 30 Apr 2025 06:06:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFYM5fS7I6UHbH7CWPIdKmdFRlBemomh5FZ88zMTxLzOAyKgsE5jQCVcdciPzBDyRXU4COoQ==
X-Received: by 2002:a17:907:2099:b0:ace:d7af:15e1 with SMTP id a640c23a62f3a-acee21ec8b4mr205096466b.28.1746018381215;
        Wed, 30 Apr 2025 06:06:21 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.200.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41cb35sm921922766b.31.2025.04.30.06.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 06:06:20 -0700 (PDT)
Date: Wed, 30 Apr 2025 15:06:11 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3] selftests/vsock: add initial vmtest.sh for
 vsock
Message-ID: <a57wg5kmprrpk2dm3zlzvegb3gzj73ubs5lxeukyinc4edlcsw@itkgfcm44qu2>
References: <20250428-vsock-vmtest-v3-1-181af6163f3e@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250428-vsock-vmtest-v3-1-181af6163f3e@gmail.com>

On Mon, Apr 28, 2025 at 04:48:11PM -0700, Bobby Eshleman wrote:
>This commit introduces a new vmtest.sh runner for vsock.
>
>It uses virtme-ng/qemu to run tests in a VM. The tests validate G2H,
>H2G, and loopback. The testing tools from tools/testing/vsock/ are
>reused. Currently, only vsock_test is used.
>
>VMCI and hyperv support is automatically built, though not used.
>
>Only tested on x86.
>
>To run:
>
>  $ tools/testing/selftests/vsock/vmtest.sh

I tried and it's working, but I have a lot of these messages in the
output:
     dmesg: read kernel buffer failed: Operation not permitted

I'm on Fedora 41:

$ uname -r
6.14.4-200.fc41.x86_64

>
>or
>
>  $ make -C tools/testing/selftests TARGETS=vsock run_tests
>
>Results:
>	# linux/tools/testing/selftests/vsock/vmtest.log
>	setup:  Building kernel and tests
>	setup:  Booting up VM
>	setup:  VM booted up
>	test:vm_server_host_client:guest:       Control socket listening on 0.0.0.0:51000
>	test:vm_server_host_client:guest:       Control socket connection accepted...
>	[...]
>	test:vm_loopback:guest: 30 - SOCK_STREAM retry failed connect()...ok
>	test:vm_loopback:guest: 31 - SOCK_STREAM SO_LINGER null-ptr-deref...ok
>	test:vm_loopback:guest: 31 - SOCK_STREAM SO_LINGER null-ptr-deref...ok
>
>Future work can include vsock_diag_test.
>
>vmtest.sh is loosely based off of tools/testing/selftests/net/pmtu.sh,
>which was picked out of the bag of tests I knew to work with NIPA.
>
>Because vsock requires a VM to test anything other than loopback, this
>patch adds vmtest.sh as a kselftest itself. This is different than other
>systems that have a "vmtest.sh", where it is used as a utility script to
>spin up a VM to run the selftests as a guest (but isn't hooked into
>kselftest). This aspect is worth review, as I'm not aware of all of the
>enviroments where this would run.

Yeah, an opinion from net maintainers on this would be great.

>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>---
>Changes in v3:
>- use common conditional syntax for checking variables
>- use return value instead of global rc
>- fix typo TEST_HOST_LISTENER_PORT -> TEST_HOST_PORT_LISTENER
>- use SIGTERM instead of SIGKILL on cleanup
>- use peer-cid=1 for loopback
>- change sleep delay times into globals
>- fix test_vm_loopback logging
>- add test selection in arguments
>- make QEMU an argument
>- check that vng binary is on path
>- use QEMU variable
>- change <tab><backslash> to <space><backslash>
>- fix hardcoded file paths
>- add comment in commit msg about script that vmtest.sh was based off of
>- Add tools/testing/selftest/vsock/Makefile for kselftest
>- Link to v2: https://lore.kernel.org/r/20250417-vsock-vmtest-v2-1-3901a27331e8@gmail.com
>
>Changes in v2:
>- add kernel oops and warnings checker
>- change testname variable to use FUNCNAME
>- fix spacing in test_vm_server_host_client
>- add -s skip build option to vmtest.sh
>- add test_vm_loopback
>- pass port to vm_wait_for_listener
>- fix indentation in vmtest.sh
>- add vmci and hyperv to config
>- changed whitespace from tabs to spaces in help string
>- Link to v1: https://lore.kernel.org/r/20250410-vsock-vmtest-v1-1-f35a81dab98c@gmail.com
>---
> MAINTAINERS                                |   1 +
> tools/testing/selftests/vsock/.gitignore   |   1 +
> tools/testing/selftests/vsock/Makefile     |   9 +
> tools/testing/selftests/vsock/config.vsock |  10 +
> tools/testing/selftests/vsock/settings     |   1 +
> tools/testing/selftests/vsock/vmtest.sh    | 354 +++++++++++++++++++++++++++++
> 6 files changed, 376 insertions(+)

While applying git warned about trailing spaces, but also checkpatch is 
warning about them, please can you fix at least the errors (and maybe 
the misspelling):

$ ./scripts/checkpatch.pl --strict -g master..HEAD --codespell
WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit 
description?)
#31: 
	test:vm_server_host_client:guest:       Control socket listening on 0.0.0.0:51000

WARNING: 'enviroments' may be misspelled - perhaps 'environments'?
#48: 
enviroments where this would run.
^^^^^^^^^^^

ERROR: trailing whitespace
#174: FILE: tools/testing/selftests/vsock/vmtest.sh:47:
+^Ivm_server_host_client^IRun vsock_test in server mode on the VM and in client mode on the host.^I$

WARNING: line length of 104 exceeds 100 columns
#174: FILE: tools/testing/selftests/vsock/vmtest.sh:47:
+	vm_server_host_client	Run vsock_test in server mode on the VM and in client mode on the host.	

ERROR: trailing whitespace
#175: FILE: tools/testing/selftests/vsock/vmtest.sh:48:
+^Ivm_client_host_server^IRun vsock_test in client mode on the VM and in server mode on the host.^I$

WARNING: line length of 104 exceeds 100 columns
#175: FILE: tools/testing/selftests/vsock/vmtest.sh:48:
+	vm_client_host_server	Run vsock_test in client mode on the VM and in server mode on the host.	

ERROR: trailing whitespace
#176: FILE: tools/testing/selftests/vsock/vmtest.sh:49:
+^Ivm_loopback^I^IRun vsock_test using the loopback transport in the VM.^I$

ERROR: trailing whitespace
#443: FILE: tools/testing/selftests/vsock/vmtest.sh:316:
+IFS="^I$

total: 4 errors, 4 warnings, 0 checks, 382 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
       You may wish to use scripts/cleanpatch or scripts/cleanfile

Commit ffa17d673263 ("selftests/vsock: add initial vmtest.sh for vsock") has style problems, please review.

NOTE: If any of the errors are false positives, please report
       them to the maintainer, see CHECKPATCH in MAINTAINERS.

>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 657a67f9031ef7798c19ac63e6383d4cb18a9e1f..3fbdd7bbfce7196a3cc7db70203317c6bd0e51fd 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -25751,6 +25751,7 @@ F:	include/uapi/linux/vm_sockets.h
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
>diff --git a/tools/testing/selftests/vsock/Makefile b/tools/testing/selftests/vsock/Makefile
>new file mode 100644
>index 0000000000000000000000000000000000000000..6fded8c4d593541a6f7462147bffcb719def378f
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/Makefile
>@@ -0,0 +1,9 @@
>+# SPDX-License-Identifier: GPL-2.0
>+.PHONY: all
>+all:
>+
>+TEST_PROGS := vmtest.sh
>+EXTRA_CLEAN := vmtest.log
>+
>+include ../lib.mk
>+
>diff --git a/tools/testing/selftests/vsock/config.vsock b/tools/testing/selftests/vsock/config.vsock
>new file mode 100644
>index 0000000000000000000000000000000000000000..9e0fb2270e6a2fc0beb5f0d9f0bc37158d0a9d23
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/config.vsock
>@@ -0,0 +1,10 @@
>+CONFIG_VSOCKETS=y
>+CONFIG_VSOCKETS_DIAG=y
>+CONFIG_VSOCKETS_LOOPBACK=y
>+CONFIG_VMWARE_VMCI_VSOCKETS=y
>+CONFIG_VIRTIO_VSOCKETS=y
>+CONFIG_VIRTIO_VSOCKETS_COMMON=y
>+CONFIG_HYPERV_VSOCKETS=y
>+CONFIG_VMWARE_VMCI=y
>+CONFIG_VHOST_VSOCK=y
>+CONFIG_HYPERV=y
>diff --git a/tools/testing/selftests/vsock/settings b/tools/testing/selftests/vsock/settings
>new file mode 100644
>index 0000000000000000000000000000000000000000..e7b9417537fbc4626153b72e8f295ab4594c844b
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/settings
>@@ -0,0 +1 @@
>+timeout=0
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>new file mode 100755
>index 0000000000000000000000000000000000000000..d70b9446e531d6d20beb24ddeda2cf0a9f7e9a39
>--- /dev/null
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -0,0 +1,354 @@
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
>+QEMU=$(command -v qemu-system-$(uname -m))
>+VERBOSE=0
>+SKIP_BUILD=0
>+VSOCK_TEST=${KERNEL_CHECKOUT}/tools/testing/vsock/vsock_test
>+
>+TEST_GUEST_PORT=51000
>+TEST_HOST_PORT=50000
>+TEST_HOST_PORT_LISTENER=50001
>+SSH_GUEST_PORT=22
>+SSH_HOST_PORT=2222
>+VSOCK_CID=1234
>+WAIT_PERIOD=3
>+WAIT_PERIOD_MAX=20
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

What about:

QEMU_OPTS=" \
     -netdev user,id=n0,hostfwd=tcp::${TEST_HOST_PORT}-:${TEST_GUEST_PORT},hostfwd=tcp::${SSH_HOST_PORT}-:${SSH_GUEST_PORT} \
     -device virtio-net-pci,netdev=n0 \
     -device vhost-vsock-pci,guest-cid=${VSOCK_CID} \
     --pidfile ${QEMU_PIDFILE}
"

Not a strong opinion, just I see too much "QEMU_OPTS="${QEMU_OPTS}" xD
You can leave it in that way if you prefer.

>+KERNEL_CMDLINE="virtme.dhcp net.ifnames=0 biosdevname=0 virtme.ssh virtme_ssh_user=$USER"
>+
>+LOG=${SCRIPT_DIR}/vmtest.log
>+
>+#		Name				Description
>+avail_tests="
>+	vm_server_host_client	Run vsock_test in server mode on the VM and in client mode on the host.	
>+	vm_client_host_server	Run vsock_test in client mode on the VM and in server mode on the host.	
>+	vm_loopback		Run vsock_test using the loopback transport in the VM.	
>+"
>+
>+usage() {
>+	echo
>+	echo "$0 [OPTIONS] [TEST]..."
>+	echo "If no TEST argument is given, all tests will be run."
>+	echo
>+	echo "Options"
>+	echo "  -v: verbose output"
>+	echo "  -s: skip build"
>+	echo
>+	echo "Available tests${avail_tests}"
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

${SSH_HOST_PORT} instead of 2222, right?

The rest LGTM!

Thanks,
Stefano

>+	return $?
>+}
>+
>+cleanup() {
>+	if [[ -f "${QEMU_PIDFILE}" ]]; then
>+		pkill -SIGTERM -F ${QEMU_PIDFILE} 2>&1 >/dev/null
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
>+		$VNG_OPTS \
>+		--run ${KERNEL_CHECKOUT} \
>+		--qemu-opts="${QEMU_OPTS}" \
>+		--qemu="${QEMU}" \
>+		--user root \
>+		--append "${KERNEL_CMDLINE}" \
>+		--rw  2>&1 >/dev/null &
>+}
>+
>+vm_wait_for_ssh() {
>+	i=0
>+	while [[ true ]]; do
>+		if [[ ${i} > ${WAIT_PERIOD_MAX} ]]; then
>+			die "Timed out waiting for guest ssh"
>+		fi
>+		vm_ssh -- true
>+		if [[ $? -eq 0 ]]; then
>+			break
>+		fi
>+		i=$(( i + 1 ))
>+		sleep ${WAIT_PERIOD}
>+	done
>+}
>+
>+wait_for_listener() {
>+	local PORT=$1
>+	local i=0
>+	while ! ss -ltn | grep -q ":${PORT}"; do
>+		if [[ ${i} > ${WAIT_PERIOD_MAX} ]]; then
>+			die "Timed out waiting for listener on port ${PORT}"
>+		fi
>+		i=$(( i + 1 ))
>+		sleep ${WAIT_PERIOD}
>+	done
>+}
>+
>+vm_wait_for_listener() {
>+	local port=$1
>+	vm_ssh -- "$(declare -f wait_for_listener); wait_for_listener ${port}"
>+}
>+
>+host_wait_for_listener() {
>+	wait_for_listener ${TEST_HOST_PORT_LISTENER}
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
>+	local testname="${FUNCNAME[0]#test_}"
>+
>+	vm_ssh -- "${VSOCK_TEST}" \
>+		--mode=server \
>+		--control-port="${TEST_GUEST_PORT}" \
>+		--peer-cid=2 \
>+		2>&1 | log_guest "${testname}" &
>+
>+	vm_wait_for_listener ${TEST_GUEST_PORT}
>+
>+	${VSOCK_TEST} \
>+		--mode=client \
>+		--control-host=127.0.0.1 \
>+		--peer-cid="${VSOCK_CID}" \
>+		--control-port="${TEST_HOST_PORT}" 2>&1 | log_host "${testname}"
>+
>+	return $?
>+}
>+
>+test_vm_client_host_server() {
>+	local testname="${FUNCNAME[0]#test_}"
>+
>+	${VSOCK_TEST} \
>+		--mode "server" \
>+		--control-port "${TEST_HOST_PORT_LISTENER}" \
>+		--peer-cid "${VSOCK_CID}" 2>&1 | log_host "${testname}" &
>+
>+	host_wait_for_listener
>+
>+	vm_ssh -- "${VSOCK_TEST}" \
>+		--mode=client \
>+		--control-host=10.0.2.2 \
>+		--peer-cid=2 \
>+		--control-port="${TEST_HOST_PORT_LISTENER}" 2>&1 | log_guest "${testname}"
>+
>+	return $?
>+}
>+
>+test_vm_loopback() {
>+	local testname="${FUNCNAME[0]#test_}"
>+	local port=60000 # non-forwarded local port
>+
>+	vm_ssh -- ${VSOCK_TEST} \
>+		--mode=server \
>+		--control-port="${port}" \
>+		--peer-cid=1 2>&1 | log_guest "${testname}" &
>+
>+	vm_wait_for_listener ${port}
>+
>+	vm_ssh -- ${VSOCK_TEST} \
>+		--mode=client \
>+		--control-host="127.0.0.1" \
>+		--control-port="${port}" \
>+		--peer-cid=1 2>&1 | log_guest "${testname}"
>+
>+	return $?
>+}
>+
>+run_test() {
>+	unset IFS
>+	local host_oops_cnt_before
>+	local host_warn_cnt_before
>+	local vm_oops_cnt_before
>+	local vm_warn_cnt_before
>+	local host_oops_cnt_after
>+	local host_warn_cnt_after
>+	local vm_oops_cnt_after
>+	local vm_warn_cnt_after
>+	local name
>+	local rc
>+
>+	host_oops_cnt_before=$(dmesg | grep -c -i 'Oops')
>+	host_warn_cnt_before=$(dmesg --level=warn | wc -l)
>+	vm_oops_cnt_before=$(vm_ssh -- dmesg | grep -c -i 'Oops')
>+	vm_warn_cnt_before=$(vm_ssh -- dmesg --level=warn | wc -l)
>+
>+	name=$(echo "${1}" | awk '{ print $1 }')
>+	eval test_"${name}"
>+
>+	host_oops_cnt_after=$(dmesg | grep -i 'Oops' | wc -l)
>+	if [[ ${host_oops_cnt_after} > ${host_oops_cnt_before} ]]; then
>+		echo "${name}: kernel oops detected on host" | log_host ${name}
>+		rc=1
>+	fi
>+
>+	host_warn_cnt_after=$(dmesg --level=warn | wc -l)
>+	if [[ ${host_warn_cnt_after} > ${host_warn_cnt_before} ]]; then
>+		echo "${name}: kernel warning detected on host" | log_host ${name}
>+		rc=1
>+	fi
>+
>+	vm_oops_cnt_after=$(vm_ssh -- dmesg | grep -i 'Oops' | wc -l)
>+	if [[ ${vm_oops_cnt_after} > ${vm_oops_cnt_before} ]]; then
>+		echo "${name}: kernel oops detected on vm" | log_host ${name}
>+		rc=1
>+	fi
>+
>+	vm_warn_cnt_after=$(vm_ssh -- dmesg --level=warn | wc -l)
>+	if [[ ${vm_warn_cnt_after} > ${vm_warn_cnt_before} ]]; then
>+		echo "${name}: kernel warning detected on vm" | log_host ${name}
>+		rc=1
>+	fi
>+
>+	return ${rc}
>+}
>+
>+while getopts :hvsq: o
>+do
>+	case $o in
>+	v) VERBOSE=1;;
>+	s) SKIP_BUILD=1;;
>+	q) QEMU=$OPTARG;;
>+	h|*) usage;;
>+	esac
>+done
>+shift $((OPTIND-1))
>+
>+trap cleanup EXIT
>+
>+if [[ ! -x "$(command -v vng)" ]]; then
>+	die "vng not found."
>+fi
>+
>+if [[ ! -x "${QEMU}" ]]; then
>+	die "${QEMU} not found."
>+fi
>+
>+rm -f "${LOG}"
>+if [[ "${SKIP_BUILD}" != 1 ]]; then
>+	build
>+fi
>+log_setup "Booting up VM"
>+vm_setup
>+vm_wait_for_ssh
>+log_setup "VM booted up"
>+
>+for arg in "$@"; do
>+	if ! command -v > /dev/null "test_${arg}"; then
>+		echo "Test ${arg} not found"
>+		die "${usage}"
>+	fi
>+done
>+
>+IFS="	
>+"
>+cnt=0
>+name=""
>+desc=""
>+for t in ${avail_tests}; do
>+	[ "${name}" = "" ] && name="${t}" && continue
>+	# desc is unused, but we need to eat it.
>+	[ "${desc}" = "" ] && desc="${t}"
>+
>+	run_this=0
>+	if [[ "${#}" -eq 0 ]]; then
>+		run_this=1
>+	else
>+		for arg in "$@"; do
>+			if [[ "${arg}" = "${name}" ]]; then
>+				run_this=1
>+			fi
>+		done
>+	fi
>+
>+	if [[ "${run_this}" = 1 ]]; then
>+		run_test "${name}"
>+		rc=$?
>+		if [[ ${rc} != 0 ]]; then
>+			cnt=$(( cnt + 1 ))
>+		fi
>+	fi
>+	name=""
>+	desc=""
>+done
>+
>+if [[ ${cnt} = 0 ]]; then
>+	echo OK
>+else
>+	echo FAILED: ${cnt}
>+fi
>+echo "Log: ${LOG}"
>+exit ${cnt}
>
>---
>base-commit: 8066e388be48f1ad62b0449dc1d31a25489fa12a
>change-id: 20250325-vsock-vmtest-b3a21d2102c2
>
>Best regards,
>-- 
>Bobby Eshleman <bobbyeshleman@gmail.com>
>


