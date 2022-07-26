Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468735815E1
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbiGZPDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiGZPDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:03:01 -0400
X-Greylist: delayed 307 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Jul 2022 08:03:00 PDT
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B44621802
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:03:00 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 4B7F442C2F;
        Tue, 26 Jul 2022 16:57:51 +0200 (CEST)
Date:   Tue, 26 Jul 2022 16:57:48 +0200
From:   Stoiko Ivanov <s.ivanov@proxmox.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com
Subject: Re: [PATCH] KVM: x86: enable TDP MMU by default
Message-ID: <20220726165748.76db5284@rosa.proxmox.com>
In-Reply-To: <20210726163106.1433600-1-pbonzini@redhat.com>
References: <20210726163106.1433600-1-pbonzini@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Proxmox[0] recently switched to the 5.15 kernel series (based on the one
for Ubuntu 22.04), which includes this commit. 
While it's working well on most installations, we have a few users who
reported that some of their guests shutdown with 
`KVM: entry failed, hardware error 0x80000021` being logged under certain
conditions and environments[1]:
* The issue is not deterministically reproducible, and only happens
  eventually with certain loads (e.g. we have only one system in our
  office which exhibits the issue - and this only by repeatedly installing
  Windows 2k22 ~ one out of 10 installs will cause the guest-crash)
* While most reports are referring to (newer) Windows guests, some users
  run into the issue with Linux VMs as well
* The affected systems are from a quite wide range - our affected machine
  is an old IvyBridge Xeon with outdated BIOS (an equivalent system with
  the latest available BIOS is not affected), but we have
  reports of all kind of Intel CPUs (up to an i5-12400). It seems AMD CPUs
  are not affected.

Disabling tdp_mmu seems to mitigate the issue, but I still thought you
might want to know that in some cases tdp_mmu causes problems, or that you
even might have an idea of how to fix the issue without explicitly
disabling tdp_mmu?

While trying to find the cause, we also included a test with a 5.18 kernel
(still affected).


The logs of the hypervisor after a guest crash:
```
Jun 24 17:25:51 testhost kernel: VMCS 000000006afb1754, last attempted VM-entry on CPU 12
Jun 24 17:25:51 testhost kernel: *** Guest State ***
Jun 24 17:25:51 testhost kernel: CR0: actual=0x0000000000050032, shadow=0x0000000000050032, gh_mask=fffffffffffffff7
Jun 24 17:25:51 testhost kernel: CR4: actual=0x0000000000002040, shadow=0x0000000000000000, gh_mask=fffffffffffef871
Jun 24 17:25:51 testhost kernel: CR3 = 0x000000013cbf4002
Jun 24 17:25:51 testhost kernel: PDPTR0 = 0x0000003300050011  PDPTR1 = 0x0000000000000000
Jun 24 17:25:51 testhost kernel: PDPTR2 = 0x0000000000000000  PDPTR3 = 0x0000010000000000
Jun 24 17:25:51 testhost kernel: RSP = 0xffff898cacda2c90  RIP = 0x0000000000008000
Jun 24 17:25:51 testhost kernel: RFLAGS=0x00000002         DR7 = 0x0000000000000400
Jun 24 17:25:51 testhost kernel: Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
Jun 24 17:25:51 testhost kernel: CS:   sel=0xc200, attr=0x08093, limit=0xffffffff, base=0x000000007ffc2000
Jun 24 17:25:51 testhost kernel: DS:   sel=0x0000, attr=0x08093, limit=0xffffffff, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: SS:   sel=0x0000, attr=0x08093, limit=0xffffffff, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: ES:   sel=0x0000, attr=0x08093, limit=0xffffffff, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: FS:   sel=0x0000, attr=0x08093, limit=0xffffffff, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: GS:   sel=0x0000, attr=0x08093, limit=0xffffffff, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: GDTR:                           limit=0x00000057, base=0xfffff8024e652fb0
Jun 24 17:25:51 testhost kernel: LDTR: sel=0x0000, attr=0x10000, limit=0x000fffff, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: IDTR:                           limit=0x00000000, base=0x0000000000000000
Jun 24 17:25:51 testhost kernel: TR:   sel=0x0040, attr=0x0008b, limit=0x00000067, base=0xfffff8024e651000
Jun 24 17:25:51 testhost kernel: EFER= 0x0000000000000000
Jun 24 17:25:51 testhost kernel: PAT = 0x0007010600070106
Jun 24 17:25:51 testhost kernel: DebugCtl = 0x0000000000000000  DebugExceptions = 0x0000000000000000
Jun 24 17:25:51 testhost kernel: Interruptibility = 00000009  ActivityState = 00000000
Jun 24 17:25:51 testhost kernel: InterruptStatus = 002f
Jun 24 17:25:51 testhost kernel: *** Host State ***
Jun 24 17:25:51 testhost kernel: RIP = 0xffffffffc119a0a0  RSP = 0xffffa6a24a52bc20
Jun 24 17:25:51 testhost kernel: CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
Jun 24 17:25:51 testhost kernel: FSBase=00007f1bf7fff700 GSBase=ffff97df5ed80000 TRBase=fffffe00002c7000
Jun 24 17:25:51 testhost kernel: GDTBase=fffffe00002c5000 IDTBase=fffffe0000000000
Jun 24 17:25:51 testhost kernel: CR0=0000000080050033 CR3=00000001226c8004 CR4=00000000001726e0
Jun 24 17:25:51 testhost kernel: Sysenter RSP=fffffe00002c7000 CS:RIP=0010:ffffffffbd201d90
Jun 24 17:25:51 testhost kernel: EFER= 0x0000000000000d01
Jun 24 17:25:51 testhost kernel: PAT = 0x0407050600070106
Jun 24 17:25:51 testhost kernel: *** Control State ***
Jun 24 17:25:51 testhost kernel: PinBased=000000ff CPUBased=b5a06dfa SecondaryExec=000007eb
Jun 24 17:25:51 testhost kernel: EntryControls=0000d1ff ExitControls=002befff
Jun 24 17:25:51 testhost kernel: ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
Jun 24 17:25:51 testhost kernel: VMEntry: intr_info=00000000 errcode=00000004 ilen=00000000
Jun 24 17:25:51 testhost kernel: VMExit: intr_info=00000000 errcode=00000000 ilen=00000001
Jun 24 17:25:51 testhost kernel:         reason=80000021 qualification=0000000000000000
Jun 24 17:25:51 testhost kernel: IDTVectoring: info=00000000 errcode=00000000
Jun 24 17:25:51 testhost kernel: TSC Offset = 0xff96fad07396b5f8
Jun 24 17:25:51 testhost kernel: SVI|RVI = 00|2f TPR Threshold = 0x00
Jun 24 17:25:51 testhost kernel: APIC-access addr = 0x000000014516c000 virt-APIC addr = 0x000000014afe7000
Jun 24 17:25:51 testhost kernel: PostedIntrVec = 0xf2
Jun 24 17:25:51 testhost kernel: EPT pointer = 0x000000011aa2d01e
Jun 24 17:25:51 testhost kernel: PLE Gap=00000080 Window=00020000
Jun 24 17:25:51 testhost kernel: Virtual processor ID = 0x0003
Jun 24 17:25:51 testhost QEMU[2997]: KVM: entry failed, hardware error 0x80000021
Jun 24 17:25:51 testhost QEMU[2997]: If you're running a guest on an Intel machine without unrestricted mode
Jun 24 17:25:51 testhost QEMU[2997]: support, the failure can be most likely due to the guest entering an invalid
Jun 24 17:25:51 testhost QEMU[2997]: state for Intel VT. For example, the guest maybe running in big real mode
Jun 24 17:25:51 testhost QEMU[2997]: which is not supported on less recent Intel processors.
Jun 24 17:25:51 testhost QEMU[2997]: EAX=00001e30 EBX=4e364180 ECX=00000001 EDX=00000000
Jun 24 17:25:51 testhost QEMU[2997]: ESI=df291040 EDI=e0d82080 EBP=acda2ea0 ESP=acda2c90
Jun 24 17:25:51 testhost QEMU[2997]: EIP=00008000 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=1 HLT=0
Jun 24 17:25:51 testhost QEMU[2997]: ES =0000 00000000 ffffffff 00809300
Jun 24 17:25:51 testhost QEMU[2997]: CS =c200 7ffc2000 ffffffff 00809300
Jun 24 17:25:51 testhost QEMU[2997]: SS =0000 00000000 ffffffff 00809300
Jun 24 17:25:51 testhost QEMU[2997]: DS =0000 00000000 ffffffff 00809300
Jun 24 17:25:51 testhost QEMU[2997]: FS =0000 00000000 ffffffff 00809300
Jun 24 17:25:51 testhost QEMU[2997]: GS =0000 00000000 ffffffff 00809300
Jun 24 17:25:51 testhost QEMU[2997]: LDT=0000 00000000 000fffff 00000000
Jun 24 17:25:51 testhost QEMU[2997]: TR =0040 4e651000 00000067 00008b00
Jun 24 17:25:51 testhost QEMU[2997]: GDT=     4e652fb0 00000057
Jun 24 17:25:51 testhost QEMU[2997]: IDT=     00000000 00000000
Jun 24 17:25:51 testhost QEMU[2997]: CR0=00050032 CR2=826c6000 CR3=3cbf4002 CR4=00000000
Jun 24 17:25:51 testhost QEMU[2997]: DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
Jun 24 17:25:51 testhost QEMU[2997]: DR6=00000000ffff0ff0 DR7=0000000000000400
Jun 24 17:25:51 testhost QEMU[2997]: EFER=0000000000000000
Jun 24 17:25:51 testhost QEMU[2997]: Code=kvm: ../hw/core/cpu-sysemu.c:77: cpu_asidx_from_attrs: Assertion `ret < cpu->num_ases && ret >= 0' failed.

```

Should you need any further information from my side or want me to test
some potential fix - please don't hesitate to ask!

Kind Regards,
stoiko


[0] https://www.proxmox.com/
[1] https://forum.proxmox.com/threads/.109410

On Mon, 26 Jul 2021 12:31:06 -0400
Paolo Bonzini <pbonzini@redhat.com> wrote:

> With the addition of fast page fault support, the TDP-specific MMU has reached
> feature parity with the original MMU.  All my testing in the last few months
> has been done with the TDP MMU; switch the default on 64-bit machines.


> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ..snip..

