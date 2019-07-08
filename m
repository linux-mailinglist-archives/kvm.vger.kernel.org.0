Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0ED62A9F
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732219AbfGHUxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 16:53:53 -0400
Received: from david.siemens.de ([192.35.17.14]:48056 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbfGHUxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 16:53:53 -0400
X-Greylist: delayed 825 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2019 16:53:51 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id x68KdfAq027480
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 22:39:41 +0200
Received: from [139.22.35.35] ([139.22.35.35])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id x68KdfL7029365;
        Mon, 8 Jul 2019 22:39:41 +0200
X-Mozilla-News-Host: news://news.gmane.org:119
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        kvm <kvm@vger.kernel.org>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Subject: KVM_SET_NESTED_STATE not yet stable
Message-ID: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
Date:   Mon, 8 Jul 2019 22:39:40 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

it seems the "new" KVM_SET_NESTED_STATE interface has some remaining
robustness issues. The most urgent one: With the help of latest QEMU
master that uses this interface, you can easily crash the host. You just
need to start qemu-system-x86 -enable-kvm in L1 and then hard-reset L1.
The host CPU that ran this will stall, the system will freeze soon.

I've also seen a pattern with my Jailhouse test VM where I seems to get
stuck in a loop between L1 and L2:

 qemu-system-x86-6660  [007]   398.691401: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
 qemu-system-x86-6660  [007]   398.691402: kvm_fpu:              unload
 qemu-system-x86-6660  [007]   398.691403: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
 qemu-system-x86-6660  [007]   398.691440: kvm_fpu:              load
 qemu-system-x86-6660  [007]   398.691441: kvm_pio:              pio_read at 0x5658 size 4 count 1 val 0x4 
 qemu-system-x86-6660  [007]   398.691443: kvm_mmu_get_page:     existing sp gfn 3a22e 1/4 q3 direct --x !pge !nxe root 6 sync
 qemu-system-x86-6660  [007]   398.691444: kvm_entry:            vcpu 3
 qemu-system-x86-6660  [007]   398.691475: kvm_exit:             reason IO_INSTRUCTION rip 0x7fa9ee5224e4 info 5658000b 0
 qemu-system-x86-6660  [007]   398.691476: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
 qemu-system-x86-6660  [007]   398.691477: kvm_fpu:              unload
 qemu-system-x86-6660  [007]   398.691478: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
 qemu-system-x86-6660  [007]   398.691526: kvm_fpu:              load
 qemu-system-x86-6660  [007]   398.691527: kvm_pio:              pio_read at 0x5658 size 4 count 1 val 0x4 
 qemu-system-x86-6660  [007]   398.691529: kvm_mmu_get_page:     existing sp gfn 3a22e 1/4 q3 direct --x !pge !nxe root 6 sync
 qemu-system-x86-6660  [007]   398.691530: kvm_entry:            vcpu 3
 qemu-system-x86-6660  [007]   398.691533: kvm_exit:             reason IO_INSTRUCTION rip 0x7fa9ee5224e4 info 5658000b 0
 qemu-system-x86-6660  [007]   398.691534: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0

These issues disappear when going from ebbfef2f back to 6cfd7639 (both
with build fixes) in QEMU. Host kernels tested: 5.1.16 (distro) and 5.2
(vanilla).

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
