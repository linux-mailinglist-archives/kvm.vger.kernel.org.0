Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD81124D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 06:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbfEBEbC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 2 May 2019 00:31:02 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50166 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbfEBEbC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 00:31:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B01BD28FCE
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 04:31:00 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id A47C728FF0; Thu,  2 May 2019 04:31:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203477] New: [AMD][KVM] Windows L1 guest becomes extremely slow
 and unusable after enabling Hyper-V
Date:   Thu, 02 May 2019 04:30:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hjc@hjc.im
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203477

            Bug ID: 203477
           Summary: [AMD][KVM] Windows L1 guest becomes extremely slow and
                    unusable after enabling Hyper-V
           Product: Virtualization
           Version: unspecified
    Kernel Version: Debian 4.19.28-2~bpo9+1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hjc@hjc.im
        Regression: No

Created attachment 282583
  --> https://bugzilla.kernel.org/attachment.cgi?id=282583&action=edit
libvirt XML

I'm not sure if it is a supported scenario to run Hyper-V inside KVM, however
this worked for me on Intel platform, and I only have this issue on AMD Ryzen.

After enabling Hyper-V feature in Windows guest, I could successfully boot into
Windows L1 guest desktop, however after that the L1 guest system consumes all
available CPU cores, freezes and becomes unusable. 

Hardware platform:  
CPU: AMD Ryzen Threadripper 2950X
Board: ASUS Prime X399-A (SVM, IOMMU related settings enabled in BIOS)


Linux boot command line: BOOT_IMAGE=/boot/vmlinuz-4.19.0-0.bpo.4-amd64
root=UUID=<guid> ro quiet apparmor=0 amd_iommu=pt nopti noibrs noibpb
nospectre_v2 nospec_store_bypass_disable pcie_aspm=off apparmor=0

KVM module parameters:
options kvm ignore_msrs=1
options kvm report_ignored_msrs=0
options kvm allow_unsafe_assigned_interrupts=1
options vfio_iommu_type1 allow_unsafe_interrupts=1


QEMU: QEMU emulator version 4.0.0 built with ./configure
--target-list=x86_64-softmmu --audio-drv-list=pa,alsa,sdl,oss --enable-attr
--enable-bluez --enable-brlapi --enable-virtfs --enable-cap-ng --enable-curl
--enable-fdt --enable-gnutls --disable-gtk --disable-vte --enable-libiscsi
--enable-libnfs --enable-curses --enable-numa --enable-rbd --enable-glusterfs
--enable-vnc-sasl --enable-sdl --enable-seccomp --enable-spice --enable-libusb
--enable-usb-redir --enable-libssh2 --enable-vde --enable-xfsctl --enable-vnc
--enable-vnc-jpeg --enable-vnc-png --enable-kvm --enable-vhost-net
--enable-opengl --enable-virglrenderer --enable-avx2 --enable-tpm
--enable-vhost-kernel --enable-virtfs

libvirt XML is attached

L1 Guest OS: Windows Server 2016, 2019 and Windows 10
L2 Guest OS: (Not ever had a chance to start one)


`perf kvm stat live` shows unusual numbers of vmrun and msr, comparing to
normal VMs:
             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time    
    Avg time 

               vmrun      71298    47.13%     2.61%      1.07us  46197.83us    
19.09us ( +-   9.11% )
                 msr      71217    47.08%     1.24%      0.61us  31213.68us    
 9.04us ( +-  10.45% )
                 hlt       3465     2.29%    95.58%      0.70us  78318.83us 
14370.28us ( +-   0.93% )
                 npf       2053     1.36%     0.38%      0.64us  15532.20us    
96.25us ( +-  26.48% )
             invlpga       1514     1.00%     0.00%      0.28us     60.25us    
 1.06us ( +-  10.58% )
           interrupt        740     0.49%     0.04%      0.22us  15289.36us    
25.67us ( +-  80.62% )
               vintr        328     0.22%     0.12%      0.37us  31341.32us   
194.65us ( +-  59.60% )
                stgi        134     0.09%     0.00%      0.32us     49.18us    
 1.34us ( +-  31.81% )
                iret        133     0.09%     0.00%      0.28us      1.52us    
 0.58us ( +-   3.36% )
                  io        119     0.08%     0.00%      2.37us     51.02us    
14.38us ( +-   4.98% )
           hypercall        104     0.07%     0.03%      0.77us  15522.73us   
152.12us ( +-  98.10% )
                 nmi         96     0.06%     0.00%      0.67us     40.84us    
 2.89us ( +-  20.49% )
           write_cr8         66     0.04%     0.00%      0.72us      3.09us    
 1.77us ( +-   3.19% )

There are also a few number of errors in kmsg after L1 guest boots:
[755580.533587] svm_set_msr: 2 callbacks suppressed
[755580.533588] SVM: kvm [14227]: vcpu0, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755581.191889] SVM: kvm [14227]: vcpu1, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755581.323561] SVM: kvm [14227]: vcpu2, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755581.482291] SVM: kvm [14227]: vcpu3, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755581.642842] SVM: kvm [14227]: vcpu4, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755581.803020] SVM: kvm [14227]: vcpu5, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755581.963498] SVM: kvm [14227]: vcpu6, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755582.123565] SVM: kvm [14227]: vcpu7, guest rIP: 0xfffff986014dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755616.107080] SVM: kvm [14227]: vcpu0, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755616.778183] SVM: kvm [14227]: vcpu1, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755616.910078] SVM: kvm [14227]: vcpu2, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755617.047056] SVM: kvm [14227]: vcpu3, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755617.180127] SVM: kvm [14227]: vcpu4, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755617.327040] SVM: kvm [14227]: vcpu5, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755617.487152] SVM: kvm [14227]: vcpu6, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0
[755617.626337] SVM: kvm [14227]: vcpu7, guest rIP: 0xfffffb735a8dca0c
unimplemented wrmsr: 0xc0010115 data 0x0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
