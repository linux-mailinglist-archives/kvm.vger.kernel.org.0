Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0566724F70
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 14:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfEUM5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 08:57:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36731 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfEUM5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 08:57:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id a17so20339390qth.3
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 05:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/rCiM/B8HfGH2ohVDNoGZetNTIGm0MPIRR/CHY2PtpA=;
        b=BL/imHa0gGmyV1BVL/yzJUO+GJBoFyZHL/SZ4WvkUhJ54ESduBGNSsPFR998eSrY26
         RUe10cudvVeEt4EwTjvRhL5ZXzPzn3uxq29wQrrz6kcOZF4hhDQxS/vfMbPQBuhjXwRg
         TW+9NpiA5tP+ZRg8mmUm+x4NZlqwiYQUh/E1v0kZ8WnY87krq+9SO9II4o+8FzkO9N+1
         +NfCeFeH8axgkMyhC1F/+eu3JwLUWBnIp7hu55dkFdfJJF0l0AL7fZ0vR+GPtdDxlRFQ
         IzG5xDOJxCKKQvjJfELPegzUKVcGiCr/uc8YHT1Z+AwnEUlUN1SP9+7Rky/K9uMSPjwX
         2AZg==
X-Gm-Message-State: APjAAAULiIDsJpYZnJXYFPyfhzYulb6fGnHzLrp8fXRBMEQDKZ7pJl2U
        Epr/TS5PC927RGDbyIPLoF8cqLAFGL0=
X-Google-Smtp-Source: APXvYqx5XKAivp4pqYhySy/3k0croeVWZQceSjJkVpUXaPc7RmrK3vQSH053MUsNl/8YOvHrCLwlMA==
X-Received: by 2002:a0c:b5ad:: with SMTP id g45mr39767457qve.231.1558443441539;
        Tue, 21 May 2019 05:57:21 -0700 (PDT)
Received: from knox.orion (modemcable053.167-176-173.mc.videotron.ca. [173.176.167.53])
        by smtp.gmail.com with ESMTPSA id 29sm11019287qty.87.2019.05.21.05.57.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 05:57:20 -0700 (PDT)
Subject: Re: [Bug 203543] Starting with kernel 5.1.0-rc6, kvm_intel can no
 longer be loaded in nested kvm/guests
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
References: <bug-203543-28872@https.bugzilla.kernel.org/>
 <bug-203543-28872-mCpNTawwAw@https.bugzilla.kernel.org/>
From:   David Hill <dhill@redhat.com>
Message-ID: <45af4e87-92f9-b876-5700-4202a0837857@redhat.com>
Date:   Tue, 21 May 2019 08:57:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bug-203543-28872-mCpNTawwAw@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi guys,

    I justed tested kernel 5.2.1-rc1 which contains the following commit 
reverting the previously mentionned commit but... the problem is still 
there:


[root@wolfe linux-stable]# su - jenkins -s /bin/bash
[jenkins@wolfe ~]$ ssh root@192.168.122.2
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Tue May 21 08:53:28 2019 from 192.168.122.1
[root@undercloud-0-rhosp15 ~]# modprobe kvm_intel
modprobe: ERROR: could not insert 'kvm_intel': Input/output error
[root@undercloud-0-rhosp15 ~]# logout
Connection to 192.168.122.2 closed.
[jenkins@wolfe ~]$ uname -a
Linux wolfe.orion 5.2.0-20190521081919+ #6 SMP Tue May 21 08:25:14 EDT 
2019 x86_64 x86_64 x86_64 GNU/Linux


I'll try reverting the commit and then reverting only the commit that 
causes issues.

commit f93f7ede087f2edcc18e4b02310df5749a6b5a61
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Wed May 8 09:08:19 2019 -0700

     Revert "KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU"

     The RDPMC-exiting control is dependent on the existence of the RDPMC
     instruction itself, i.e. is not tied to the "Architectural Performance
     Monitoring" feature.  For all intents and purposes, the control exists
     on all CPUs with VMX support since RDPMC also exists on all VCPUs with
     VMX supported.  Per Intel's SDM:

       The RDPMC instruction was introduced into the IA-32 Architecture in
       the Pentium Pro processor and the Pentium processor with MMX 
technology.
       The earlier Pentium processors have performance-monitoring 
counters, but
       they must be read with the RDMSR instruction.

     Because RDPMC-exiting always exists, KVM requires the control and 
refuses
     to load if it's not available.  As a result, hiding the PMU from a 
guest
     breaks nested virtualization if the guest attemts to use KVM.

     While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
     check for RDPMC-exiting follows standard fault vs. VM-Exit 
prioritization
     for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
     checks, but before the counter referenced in ECX is checked for 
validity.

     In other words, the original KVM behavior of injecting a #GP was 
correct,
     and the KVM unit test needs to be adjusted accordingly, e.g. eat 
the #GP
     when the unit test guest (L3 in this case) executes RDPMC without
     RDPMC-exiting set in the unit test host (L2).

     This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.

     Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when 
guest supports PMU")
     Reported-by: David Hill <hilld@binarystorm.net>
     Cc: Saar Amar <saaramar@microsoft.com>
     Cc: Mihai Carabas <mihai.carabas@oracle.com>
     Cc: Jim Mattson <jmattson@google.com>
     Cc: Liran Alon <liran.alon@oracle.com>
     Cc: stable@vger.kernel.org
     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


On 2019-05-08 6:14 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203543
>
> --- Comment #8 from Liran Alon (liran.alon@oracle.com) ---
> +Paolo
>
> What are your thoughts on this?
> What is the reason that KVM relies on CPU_BASED_RDPMC_EXITING to be exposed
> from underlying CPU? How is it critical for it’s functionality?
> If it’s because we want to make sure that we hide host PMCs, we should
> condition this to be a min requirement of kvm_intel only in case underlying CPU
> exposes PMU to begin with.
> Do you agree? If yes, I can create the patch to fix this.
>
> -Liran
>
>> On 8 May 2019, at 16:51, bugzilla-daemon@bugzilla.kernel.org wrote:
>>
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D203543&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=Jk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=7TirfLMNxYI-3Ygxm3kjDUB49Jwmk8bqD7671wy0hi8&s=Z_L1UqH19zon0ohDrCMU91ixA-Wn_vO7d-fO8s2G3PI&e=
>>
>> --- Comment #5 from David Hill (hilld@binarystorm.net) ---
>> I can confirm that reverting that commit solves the problem:
>>
>> e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU”)
>>
>> -- 
>> You are receiving this mail because:
>> You are watching the assignee of the bug.
