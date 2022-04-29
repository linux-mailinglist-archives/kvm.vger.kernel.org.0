Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16EB0514516
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 11:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356286AbiD2JJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 05:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356276AbiD2JJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 05:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22D1C86E3A
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 02:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651223191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CSY6Y/4T7bj919shOHPZmVkZxJI0FlIHDXbOp9cSNBI=;
        b=isrZazxXHGelKTGed6eRxHFj7TTcXRkHYu02E12tTbNMKybOkbe+pOrCAzzwQ6wvRWUSQx
        nia22GHxIMz2X6qy0qExR59yRuA0Tp+Zw9+dXhuX8e3na0V347kZzIsdsrMkjVqxvCKgen
        01lxA1XwbCBw45eotAG4yyOFwUHxNf0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-ZHTgfgtXOBCnOz_HbOtOCQ-1; Fri, 29 Apr 2022 05:06:29 -0400
X-MC-Unique: ZHTgfgtXOBCnOz_HbOtOCQ-1
Received: by mail-pg1-f198.google.com with SMTP id o5-20020a639205000000b003ab492e038dso3579274pgd.12
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 02:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CSY6Y/4T7bj919shOHPZmVkZxJI0FlIHDXbOp9cSNBI=;
        b=ScWvwZawLAjU7024USg4F+1zT6eFJhZlNSYgsCDclW25AY0GgP1s6zGTIYwux9FsU0
         3WTvOQssWirfsBRWm01rKlIwQE7FigbKHmqLVkSbhpKs+/AdsHxz7qPI5grfGSDSFlPY
         lyDMWoSN+gMQDjuYjTkeYPuVbUFi/iWSWlGYQ0parKHmYgyqu9kcRwmqomo/RFx/7oPR
         FNLZIWV3AQH4nT3IEzYyR0LH7YSs2h2L4wHWO5goAWnjnECc9VQEBpe3dXQ9AGyAugmL
         FglWCqneWJTjZcHbMeZmvYUs5cuQNHjPv62f5g563Sc/rA4wi77TlnKPnizWwxTMpK4c
         ICoA==
X-Gm-Message-State: AOAM530TuTpVhqu0IRDZ2sMeHGJg2sBbRdgfeipIXziU/FDDh6cia8pQ
        L+FFG3MLNIuO9EFNznkG/XFEgm7lvmYSFt2kNeDXq5PsueA2/TGVJF4lBYgrTQdP7lMVc2VQPI5
        HVaY5EdO+fXCh
X-Received: by 2002:a17:90b:4b07:b0:1db:c488:7394 with SMTP id lx7-20020a17090b4b0700b001dbc4887394mr2752447pjb.21.1651223188429;
        Fri, 29 Apr 2022 02:06:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxInccOofVf0pMBnkfTHELvYv2tsj7NcfRqjmjun+/PYmdLLstBer0yOapb0B4/7T00673t9w==
X-Received: by 2002:a17:90b:4b07:b0:1db:c488:7394 with SMTP id lx7-20020a17090b4b0700b001dbc4887394mr2752409pjb.21.1651223188050;
        Fri, 29 Apr 2022 02:06:28 -0700 (PDT)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x126-20020a628684000000b0050d3f600ed0sm2331365pfd.40.2022.04.29.02.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 02:06:27 -0700 (PDT)
Date:   Fri, 29 Apr 2022 17:06:17 +0800
From:   Tao Liu <ltao@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        virtualization@lists.linux-foundation.org,
        Arvind Sankar <nivedita@alum.mit.edu>, hpa@zytor.com,
        Jiri Slaby <jslaby@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Martin Radev <martin.b.radev@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Cfir Cohen <cfir@google.com>, linux-coco@lists.linux.dev,
        Andy Lutomirski <luto@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        Erdem Aktas <erdemaktas@google.com>
Subject: Re: [PATCH v3 00/10] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Message-ID: <YmuqifsJltdh7rpv@localhost.localdomain>
References: <20220127101044.13803-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127101044.13803-1-joro@8bytes.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 11:10:34AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Hi,
> 
> here are changes to enable kexec/kdump in SEV-ES guests. The biggest
> problem for supporting kexec/kdump under SEV-ES is to find a way to
> hand the non-boot CPUs (APs) from one kernel to another.
> 
> Without SEV-ES the first kernel parks the CPUs in a HLT loop until
> they get reset by the kexec'ed kernel via an INIT-SIPI-SIPI sequence.
> For virtual machines the CPU reset is emulated by the hypervisor,
> which sets the vCPU registers back to reset state.
> 
> This does not work under SEV-ES, because the hypervisor has no access
> to the vCPU registers and can't make modifications to them. So an
> SEV-ES guest needs to reset the vCPU itself and park it using the
> AP-reset-hold protocol. Upon wakeup the guest needs to jump to
> real-mode and to the reset-vector configured in the AP-Jump-Table.
> 
> The code to do this is the main part of this patch-set. It works by
> placing code on the AP Jump-Table page itself to park the vCPU and for
> jumping to the reset vector upon wakeup. The code on the AP Jump Table
> runs in 16-bit protected mode with segment base set to the beginning
> of the page. The AP Jump-Table is usually not within the first 1MB of
> memory, so the code can't run in real-mode.
> 
> The AP Jump-Table is the best place to put the parking code, because
> the memory is owned, but read-only by the firmware and writeable by
> the OS. Only the first 4 bytes are used for the reset-vector, leaving
> the rest of the page for code/data/stack to park a vCPU. The code
> can't be in kernel memory because by the time the vCPU wakes up the
> memory will be owned by the new kernel, which might have overwritten it
> already.
> 
> The other patches add initial GHCB Version 2 protocol support, because
> kexec/kdump need the MSR-based (without a GHCB) AP-reset-hold VMGEXIT,
> which is a GHCB protocol version 2 feature.
> 
> The kexec'ed kernel is also entered via the decompressor and needs
> MMIO support there, so this patch-set also adds MMIO #VC support to
> the decompressor and support for handling CLFLUSH instructions.
> 
> Finally there is also code to disable kexec/kdump support at runtime
> when the environment does not support it (e.g. no GHCB protocol
> version 2 support or AP Jump Table over 4GB).
> 
> The diffstat looks big, but most of it is moving code for MMIO #VC
> support around to make it available to the decompressor.
> 
> The previous version of this patch-set can be found here:
> 
> 	https://lore.kernel.org/lkml/20210913155603.28383-1-joro@8bytes.org/
> 
> Please review.
> 
> Thanks,
> 
> 	Joerg
> 
> Changes v2->v3:
> 
> 	- Rebased to v5.17-rc1
> 	- Applied most review comments by Boris
> 	- Use the name 'AP jump table' consistently
> 	- Make kexec-disabling for unsupported guests x86-specific
> 	- Cleanup and consolidate patches to detect GHCB v2 protocol
> 	  support
> 
> Joerg Roedel (10):
>   x86/kexec/64: Disable kexec when SEV-ES is active
>   x86/sev: Save and print negotiated GHCB protocol version
>   x86/sev: Set GHCB data structure version
>   x86/sev: Cache AP Jump Table Address
>   x86/sev: Setup code to park APs in the AP Jump Table
>   x86/sev: Park APs on AP Jump Table with GHCB protocol version 2
>   x86/sev: Use AP Jump Table blob to stop CPU
>   x86/sev: Add MMIO handling support to boot/compressed/ code
>   x86/sev: Handle CLFLUSH MMIO events
>   x86/kexec/64: Support kexec under SEV-ES with AP Jump Table Blob
> 
>  arch/x86/boot/compressed/sev.c          |  45 +-
>  arch/x86/include/asm/insn-eval.h        |   1 +
>  arch/x86/include/asm/realmode.h         |   5 +
>  arch/x86/include/asm/sev-ap-jumptable.h |  29 +
>  arch/x86/include/asm/sev.h              |  11 +-
>  arch/x86/kernel/machine_kexec_64.c      |  12 +
>  arch/x86/kernel/process.c               |   8 +
>  arch/x86/kernel/sev-shared.c            | 233 +++++-
>  arch/x86/kernel/sev.c                   | 404 +++++------
>  arch/x86/lib/insn-eval-shared.c         | 913 ++++++++++++++++++++++++
>  arch/x86/lib/insn-eval.c                | 909 +----------------------
>  arch/x86/realmode/Makefile              |   9 +-
>  arch/x86/realmode/rm/Makefile           |  11 +-
>  arch/x86/realmode/rm/header.S           |   3 +
>  arch/x86/realmode/rm/sev.S              |  85 +++
>  arch/x86/realmode/rmpiggy.S             |   6 +
>  arch/x86/realmode/sev/Makefile          |  33 +
>  arch/x86/realmode/sev/ap_jump_table.S   | 131 ++++
>  arch/x86/realmode/sev/ap_jump_table.lds |  24 +
>  19 files changed, 1730 insertions(+), 1142 deletions(-)
>  create mode 100644 arch/x86/include/asm/sev-ap-jumptable.h
>  create mode 100644 arch/x86/lib/insn-eval-shared.c
>  create mode 100644 arch/x86/realmode/rm/sev.S
>  create mode 100644 arch/x86/realmode/sev/Makefile
>  create mode 100644 arch/x86/realmode/sev/ap_jump_table.S
>  create mode 100644 arch/x86/realmode/sev/ap_jump_table.lds
> 
> 
> base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
> -- 
> 2.34.1
>

Hi Joerg,

I tried the patch set with 5.17.0-rc1 kernel, and I have a few questions:

1) Is it a bug or should qemu-kvm 6.2.0 be patched with specific patch? Because
   I found it will exit with 0 when I tried to reboot the VM with sev-es enabled.
   However with only sev enabled, the VM can do reboot with no problem:

[root@dell-per7525-03 ~]# virsh start TW-SEV-ES --console
....
Fedora Linux 35 (Server Edition)
Kernel 5.17.0-rc1 on an x86_64 (ttyS0)
....
[root@fedora ~]# reboot
.....
[   48.077682] reboot: Restarting system
[   48.078109] reboot: machine restart
                       ^^^^^^^^^^^^^^^ guest vm reached restart
[root@dell-per7525-03 ~]# echo $?
0
^^^ qemu-kvm exit with 0, no reboot back to normal VM kernel
[root@dell-per7525-03 ~]#

2) With sev-es enabled and the 2 patch sets applied: A) [PATCH v3 00/10] x86/sev:
KEXEC/KDUMP support for SEV-ES guests, and B) [PATCH v6 0/7] KVM: SVM: Add initial
GHCB protocol version 2 support. I can enable kdump and have vmcore generated:

[root@fedora ~]# dmesg|grep -i sev
[    0.030600] SEV: Hypervisor GHCB protocol version support: min=1 max=2
[    0.030602] SEV: Using GHCB protocol version 2
[    0.296144] AMD Memory Encryption Features active: SEV SEV-ES
[    0.450991] SEV: AP jump table Blob successfully set up
[root@fedora ~]# kdumpctl status
kdump: Kdump is operational

However without the 2 patch sets, I can also enable kdump and have vmcore generated:

[root@fedora ~]# dmesg|grep -i sev
[    0.295754] AMD Memory Encryption Features active: SEV SEV-ES
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ patch set A & B 
	       not applied, so only have this string.
[root@fedora ~]# echo c > /proc/sysrq-trigger
...
[    2.759403] kdump[549]: saving vmcore-dmesg.txt to /sysroot/var/crash/127.0.0.1-2022-04-18-05:58:50/
[    2.804355] kdump[555]: saving vmcore-dmesg.txt complete
[    2.806915] kdump[557]: saving vmcore
                           ^^^^^^^^^^^^^ vmcore can still be generated
...
[    7.068981] reboot: Restarting system
[    7.069340] reboot: machine restart

[root@dell-per7525-03 ~]# echo $?
0
^^^ same exit issue as question 1.

I doesn't have a complete technical background of the patch set, but isn't
it the issue which this patch set is trying to solve? Or I missed something?

Thanks,
Tao Liu
 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

