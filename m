Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198D4AF114
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 20:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfIJSc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 14:32:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:5908 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfIJSc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 14:32:57 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 11:32:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="209416047"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 10 Sep 2019 11:32:55 -0700
Date:   Tue, 10 Sep 2019 11:32:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Harvey <jamespharvey20@gmail.com>
Cc:     kvm@vger.kernel.org, Alex Willamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: 5.2.11+ Regression: > nproc/2 lockups during initramfs
Message-ID: <20190910183255.GB11151@linux.intel.com>
References: <CA+X5Wn4CbU305tDeu4UM=rBEzVyVgf0+YLsx70RtUJMZCFhXXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+X5Wn4CbU305tDeu4UM=rBEzVyVgf0+YLsx70RtUJMZCFhXXw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 08, 2019 at 06:37:43AM -0400, James Harvey wrote:
> Host is up to date Arch Linux, with exception of downgrading linux to
> track this down to 5.2.11 - 5.2.13.  QEMU 4.1.0, but have also
> downgraded to 4.0.0 to confirm no change.
> 
> Host is dual E5-2690 v1 Xeons.  With hyperthreading, 32 logical cores.
> I've always been able to boot qemu with "-smp
> cpus=30,cores=15,threads=1,sockets=2".  I leave 2 free for host
> responsiveness.
> 
> Upgrading from 5.2.10 to 5.2.11 causes the VM to lock up while loading
> the initramfs about 90-95% of the time.  (Probably a slight race
> condition.)  On host, QEMU shows as nVmCPUs*100% CPU usage, so around
> 3000% for 30 cpus.
> 
> If I back down to "cpus=16,cores=8", it always boots.  If I increase
> to "cpus=18,cores=9", it goes back to locking up 90-95% of the time.
> 
> Omitting "-accel=kvm" allows 5.2.11 to work on the host without issue,
> so combined with that the only package needing to be downgraded is
> linux to 5.2.10 to prevent the issue with KVM, I think this must be a
> KVM issue.
> 
> Using version of QEMU with debug symbols gives:
> * gdb backtrace: http://ix.io/1UyO

Fudge.

One of the threads is deleting a memory region, and v5.2.11 reverted a
change related to flushing sptes on memory region deletion.

Can you try reverting the following commit?  Reverting the revert isn't a
viable solution, but it'll at least be helpful to confirm this it's the
source of your troubles.

commit 2ad350fb4c924f611d174e2b0da4edba8a6e430a
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu Aug 15 09:43:32 2019 +0200

    Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
    
    commit d012a06ab1d23178fc6856d8d2161fbcc4dd8ebd upstream.
    
    This reverts commit 4e103134b862314dc2f2f18f2fb0ab972adc3f5f.
    Alex Williamson reported regressions with device assignment with
    this patch.  Even though the bug is probably elsewhere and still
    latent, this is needed to fix the regression.
    
    Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
    Reported-by: Alex Willamson <alex.williamson@redhat.com>
    Cc: stable@vger.kernel.org
    Cc: Sean Christopherson <sean.j.christopherson@intel.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Thread 10 (Thread 0x7ff72fdff700 (LWP 4507)):
#1  0x000055c976c411a4 in kvm_vm_ioctl
#2  0x000055c976c3c6bf in kvm_set_user_memory_region
#3  0x000055c976c3dbb6 in kvm_set_phys_mem
#4  0x000055c976c3dd68 in kvm_region_del
#5  0x000055c976c272c8 in address_space_update_topology_pass
#6  0x000055c976c27897 in address_space_set_flatview
#7  0x000055c976c27a5d in memory_region_transaction_commit
#8  0x000055c976c2b3b5 in memory_region_del_subregion
#9  0x000055c976f267d6 in pci_update_mappings
#10 0x000055c976f26bb6 in pci_default_write_config
#11 0x000055c976fd9baa in virtio_write_config
#12 0x000055c976f30453 in pci_host_config_write_common
#13 0x000055c976f305b0 in pci_data_write
#14 0x000055c976f306dc in pci_host_data_write
#15 0x000055c976c25887 in memory_region_write_accessor
#16 0x000055c976c25aa7 in access_with_adjusted_size
#17 0x000055c976c28ad0 in memory_region_dispatch_write
#18 0x000055c976bc6b30 in flatview_write_continue
#19 0x000055c976bc6c77 in flatview_write
#20 0x000055c976bc6f82 in address_space_write
#21 0x000055c976bc6fd4 in address_space_rw
#22 0x000055c976c4059a in kvm_handle_io
#23 0x000055c976c40d33 in kvm_cpu_exec
#24 0x000055c976c166df in qemu_kvm_cpu_thread_fn
#25 0x000055c9771d3bd8 in qemu_thread_start
#26 0x00007ff73892357f in start_thread
#27 0x00007ff7388510e3 in clone

> * 11 seconds of attaching strace to locked up qemu (167K): http://ix.io/1UyP
> * strace from the beginning of starting a qemu that locks up (8MB):
> https://filebin.ca/4uI15ztGAarw/strace.qemu.from.start
> ** This definitely changed timings, and it became harder to replicate,
> to where I'd guess 20-30% of boots hang
> ** Interestingly, the strace only collected data for 5 seconds, even
> though qemu continued at full CPU usage much longer.  Don't know what
> to make of that, especially because the first strace was attached to
> an already locked up qemu that had gone well past 5 seconds.
> 
> Like how the strace changed timings, I have seen attaching GDB to a
> running qemu which pauses it, then simply running continue, has gotten
> it "unstuck" immediately.
> 
> I've let this go 14 hours, but once it goes into complete CPU usage,
> it never comes out.
> 
> If booting from the September 2019 Arch ISO, it hangs right after the
> ISO's UEFI bootloader selects Arch Linux, then the screen goes black.
> 
> If booting from grub/systemd, it hangs right after "Loading Initial Ramdisk..."
