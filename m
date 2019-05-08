Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5F16FCF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 06:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbfEHEIM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 8 May 2019 00:08:12 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47914 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfEHEIM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 00:08:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E9A5C289FC
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 04:08:10 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id DE01F28A01; Wed,  8 May 2019 04:08:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Wed, 08 May 2019 04:08:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: liran.alon@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203543-28872-IJcrSG5TnW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203543-28872@https.bugzilla.kernel.org/>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203543

--- Comment #2 from Liran Alon (liran.alon@oracle.com) ---
If I would have to guess, I would blame my own commit:
e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU”)

As in kvm_intel’s setup_vmcs_config() it can be seen that
CPU_BASED_RDPMC_EXITING is required in order for KVM to load.
Therefore, I assume the issue is that now L1 guest is not exposed with
CPU_BASED_RDPMC_EXITING.

My patch is suppose to hide CPU_BASED_RDPMC_EXITING from L1 only in case L1
vCPU is not exposed with PMU.

Can you provide more details on the vCPU your setup expose to L1?
Have you explicitly disabled PMU from L1 vCPU?
Can you run “cpuid -r” on shell and post here it’s output?

-Liran

> On 7 May 2019, at 23:45, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
>
> https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D203543&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=Jk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=cB5pEya2zKbSTvVpkeIHKYlQ1F9qW__mnLe0hXnlBCM&s=O2zSR2K1fTcD1Ps40Q_i-ZmS9tVsPYjupbQmw-LCMPk&e=
> 
>            Bug ID: 203543
>           Summary: Starting with kernel 5.1.0-rc6,  kvm_intel can no
>                    longer be loaded in nested kvm/guests
>           Product: Virtualization
>           Version: unspecified
>    Kernel Version: 5.1.0-rc6
>          Hardware: Intel
>                OS: Linux
>              Tree: Mainline
>            Status: NEW
>          Severity: blocking
>          Priority: P1
>         Component: kvm
>          Assignee: virtualization_kvm@kernel-bugs.osdl.org
>          Reporter: hilld@binarystorm.net
>        Regression: No
> 
> 1. Please describe the problem:
> Starting with kernel 5.1.0-rc6,  kvm_intel can no longer be loaded in nested
> kvm/guests
> 
> [root@undercloud-0-rhosp10 ~]# modprobe kvm_intel
> modprobe: ERROR: could not insert 'kvm_intel': Input/output error
> 
> 
> 2. What is the Version-Release number of the kernel:
> 5.1.0-rc7
> 
> 3. Did it work previously in Fedora? If so, what kernel version did the issue
>   *first* appear?  Old kernels are available for download at
>  
>   https://urldefense.proofpoint.com/v2/url?u=https-3A__koji.fedoraproject.org_koji_packageinfo-3FpackageID-3D8&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=Jk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=cB5pEya2zKbSTvVpkeIHKYlQ1F9qW__mnLe0hXnlBCM&s=1wtgL9MEqhN6ZwOZRMKlcW6LYP3zCgz4-1lh8aXyTWo&e=
>   :
> Yes it seems to have appearded between 5.1.0-rc4 (it worked) and 5.1.0-rc6
> (it
> no longer worked)
> 
> 4. Can you reproduce this issue? If so, please provide the steps to reproduce
>   the issue below:
> Yes, update to 5.1.0-rc6 and try to modprobe kvm_intel inside a guest where
> the
> VMX capabilities has been exposted
> 
> 
> 5. Does this problem occur with the latest Rawhide kernel? To install the
>   Rawhide kernel, run ``sudo dnf install fedora-repos-rawhide`` followed by
>   ``sudo dnf update --enablerepo=rawhide kernel``:
> Yes
> 
> 
> 6. Are you running any modules that not shipped with directly Fedora's
> kernel?:
> No
> 
> 7. Please attach the kernel logs. You can get the complete kernel log
>   for a boot with ``journalctl --no-hostname -k > dmesg.txt``. If the
>   issue occurred on a previous boot, use the journalctl ``-b`` flag.
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
