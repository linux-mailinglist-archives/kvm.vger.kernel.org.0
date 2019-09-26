Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF1BF4DE
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 16:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfIZOP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 10:15:26 -0400
Received: from mail.codelabs.ch ([109.202.192.35]:57708 "EHLO mail.codelabs.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbfIZOP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 10:15:26 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2019 10:15:24 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 3E7C9A0166;
        Thu, 26 Sep 2019 16:05:53 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B34XwJeBYrfE; Thu, 26 Sep 2019 16:05:50 +0200 (CEST)
Received: from skyhawk.codelabs.ch (unknown [192.168.10.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.codelabs.ch (Postfix) with ESMTPSA id 2771DA0125;
        Thu, 26 Sep 2019 16:05:50 +0200 (CEST)
From:   Reto Buerki <reet@codelabs.ch>
To:     kvm@vger.kernel.org
Subject: [RFC PATCH 0/1] KVM: VMX: Always sync CR3 to VMCS in nested_vmx_load_cr3
Date:   Thu, 26 Sep 2019 16:05:40 +0200
Message-Id: <20190926140541.15453-1-reet@codelabs.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Muen [1] is an Open Source separation kernel (SK) for x86/64. It is
written in SPARK/Ada and uses VMX non-root mode to isolate both its
'native' (IA32-e paging) and VM guests (EPT).

Native guests are written in SPARK/Ada as well. They run directly on the
vCPU with no surrounding OS, page tables are compile-time static, guest
CR3 is initially setup in the associated VMCS by the SK and never
changes.

We are trying to use nested KVM/QEMU for faster deployment and testing
of Muen-based systems but encountered a problem with how KVM handles L2
guest CR3 in our setup. As soon as guests start to idle executing HLT,
things go sideways (#GP, unexpected page faults in native subjects,
triple faults in VMs).

We assume the failure is related to the "HLT Exiting" control in
Processor-Based VM-Execution Controls, as Muen has this flag disabled
due to the static, round-robin nature of its scheduler. This might be
uncommon.

We instrumented the SK to check if a known CR3 value changes during
runtime, which produced the following output. CR3 of guests 8 and 9 are
initially zero because these are VM guests with EPT.

Booting Muen kernel v0.9.1-262-g71ffcad4b-UNCLEAN (GNAT Community 2019 (20190517-83))
[..snip..]
PML4 address of subject 16#0000#: 16#00000000018c9000#
PML4 address of subject 16#0001#: 16#000000000189f000#
PML4 address of subject 16#0002#: 16#0000000001834000#
PML4 address of subject 16#0003#: 16#000000000183d000#
PML4 address of subject 16#0005#: 16#0000000001630000#
PML4 address of subject 16#0004#: 16#0000000001846000#
PML4 address of subject 16#0007#: 16#000000000186f000#
PML4 address of subject 16#0006#: 16#0000000001818000#
PML4 address of subject 16#0008#: 16#0000000000000000#
PML4 address of subject 16#0009#: 16#0000000000000000#
[..snip..]
ERROR CR3 of subject 1 changed: 16#0000000010ff9000# exit 16#0034#
ERROR Halting CPU

The CR3 value of guest 1 changed from 16#000000000189f000# to
16#0000000010ff9000#, which is the CR3 value of a VM guest.

A second run shows:
ERROR CR3 of subject 1 changed: 16#000000000183d000# exit 16#0034#,
which is the CR3 value of guest 3.

The problem does not only show for native guests, but also CR3 values of
VM guests with EPT get mixed up.

Tested KVM version is fd3edd4a9066.

A Muen system image to reproduce the problem is provided:

$ wget https://www.codelabs.ch/~reet/files/muen.iso.tar.xz
$ tar xfvJ muen.iso.tar.xz
$ qemu-system-x86_64 -cdrom muen.iso \
  -serial file:serial.out \
  -cpu host,+invtsc \
  --enable-kvm \
  -m 5120 \
  -smp cores=2,threads=2,sockets=1

This patch fixes the issue for Muen. I'm aware that this might not be
the proper fix, please advise how to update it if the problem is
reproducible.

[1] - https://muen.sk

Reto Buerki (1):
  KVM: VMX: Always sync CR3 to VMCS in nested_vmx_load_cr3

 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.20.1

