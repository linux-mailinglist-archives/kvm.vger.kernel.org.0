Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1212825090
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfEUNhp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 May 2019 09:37:45 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54680 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727969AbfEUNhp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 May 2019 09:37:45 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9D80428A20
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 13:37:43 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 9251828A1E; Tue, 21 May 2019 13:37:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Tue, 21 May 2019 13:37:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: moi@davidchill.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203543-28872-iUz9JFoNNJ@https.bugzilla.kernel.org/>
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

--- Comment #10 from moi@davidchill.ca ---
Reverting both commits solves this problem:

f93f7ede087f2edcc18e4b02310df5749a6b5a61
e51bfdb68725dc052d16241ace40ea3140f938aa

On 2019-05-21 8:57 a.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203543
>
> --- Comment #9 from dhill@redhat.com ---
> Hi guys,
>
>      I justed tested kernel 5.2.1-rc1 which contains the following commit
> reverting the previously mentionned commit but... the problem is still
> there:
>
>
> [root@wolfe linux-stable]# su - jenkins -s /bin/bash
> [jenkins@wolfe ~]$ ssh root@192.168.122.2
> Activate the web console with: systemctl enable --now cockpit.socket
>
> Last login: Tue May 21 08:53:28 2019 from 192.168.122.1
> [root@undercloud-0-rhosp15 ~]# modprobe kvm_intel
> modprobe: ERROR: could not insert 'kvm_intel': Input/output error
> [root@undercloud-0-rhosp15 ~]# logout
> Connection to 192.168.122.2 closed.
> [jenkins@wolfe ~]$ uname -a
> Linux wolfe.orion 5.2.0-20190521081919+ #6 SMP Tue May 21 08:25:14 EDT
> 2019 x86_64 x86_64 x86_64 GNU/Linux
>
>
> I'll try reverting the commit and then reverting only the commit that
> causes issues.
>
> commit f93f7ede087f2edcc18e4b02310df5749a6b5a61
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Wed May 8 09:08:19 2019 -0700
>
>       Revert "KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU"
>
>       The RDPMC-exiting control is dependent on the existence of the RDPMC
>       instruction itself, i.e. is not tied to the "Architectural Performance
>       Monitoring" feature.  For all intents and purposes, the control exists
>       on all CPUs with VMX support since RDPMC also exists on all VCPUs with
>       VMX supported.  Per Intel's SDM:
>
>         The RDPMC instruction was introduced into the IA-32 Architecture in
>         the Pentium Pro processor and the Pentium processor with MMX
> technology.
>         The earlier Pentium processors have performance-monitoring
> counters, but
>         they must be read with the RDMSR instruction.
>
>       Because RDPMC-exiting always exists, KVM requires the control and
> refuses
>       to load if it's not available.  As a result, hiding the PMU from a
> guest
>       breaks nested virtualization if the guest attemts to use KVM.
>
>       While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
>       check for RDPMC-exiting follows standard fault vs. VM-Exit
> prioritization
>       for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
>       checks, but before the counter referenced in ECX is checked for
> validity.
>
>       In other words, the original KVM behavior of injecting a #GP was
> correct,
>       and the KVM unit test needs to be adjusted accordingly, e.g. eat
> the #GP
>       when the unit test guest (L3 in this case) executes RDPMC without
>       RDPMC-exiting set in the unit test host (L2).
>
>       This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.
>
>       Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when
> guest supports PMU")
>       Reported-by: David Hill <hilld@binarystorm.net>
>       Cc: Saar Amar <saaramar@microsoft.com>
>       Cc: Mihai Carabas <mihai.carabas@oracle.com>
>       Cc: Jim Mattson <jmattson@google.com>
>       Cc: Liran Alon <liran.alon@oracle.com>
>       Cc: stable@vger.kernel.org
>       Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>       Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
>
> On 2019-05-08 6:14 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=203543
>>
>> --- Comment #8 from Liran Alon (liran.alon@oracle.com) ---
>> +Paolo
>>
>> What are your thoughts on this?
>> What is the reason that KVM relies on CPU_BASED_RDPMC_EXITING to be exposed
>> from underlying CPU? How is it critical for it’s functionality?
>> If it’s because we want to make sure that we hide host PMCs, we should
>> condition this to be a min requirement of kvm_intel only in case underlying
>> CPU
>> exposes PMU to begin with.
>> Do you agree? If yes, I can create the patch to fix this.
>>
>> -Liran
>>
>>> On 8 May 2019, at 16:51, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>
>>>
>>>
>>>
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D203543&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=Jk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=7TirfLMNxYI-3Ygxm3kjDUB49Jwmk8bqD7671wy0hi8&s=Z_L1UqH19zon0ohDrCMU91ixA-Wn_vO7d-fO8s2G3PI&e=
>>>
>>> --- Comment #5 from David Hill (hilld@binarystorm.net) ---
>>> I can confirm that reverting that commit solves the problem:
>>>
>>> e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports
>>> PMU”)
>>>
>>> -- 
>>> You are receiving this mail because:
>>> You are watching the assignee of the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
