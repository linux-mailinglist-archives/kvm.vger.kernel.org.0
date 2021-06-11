Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879103A3F4F
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhFKJqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 05:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230356AbhFKJqi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 05:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623404680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMYoozdWQK4JS5PWCOrmwHkHgIFc9V+TLEIJ1okexV8=;
        b=MS2O/HvdalX/1S2wldtHO3fW5y0o3Za5RdccyyvjnH5m2M5O/12/pqbRLLZgKPXz//cpZR
        jnuIWzN46WavVUvui5esVwwuMrBcxQWGpGlTnXyRcu34dhmPqR5I8B7Etg6lA1p/CHeCeU
        Xud8SNraz/qxcIemIkaXJFAdnPbWJDs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-XbMNVEKwMAOY8_EL9oWrCg-1; Fri, 11 Jun 2021 05:44:38 -0400
X-MC-Unique: XbMNVEKwMAOY8_EL9oWrCg-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso4247134wmj.0
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 02:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NMYoozdWQK4JS5PWCOrmwHkHgIFc9V+TLEIJ1okexV8=;
        b=qYSnWdte70yQ+t7pQltBpPW0euHKyqUcVXO9V71WhpSYB8FSJsOJ811TxzqzzdxsZC
         lYxVAZB7y2H1x7DZeNdlxx9He4Yh0x5lX45fj9itzx4RY2O1af3cxOoK4JCgT/udis4n
         Wt8/HoMWjylmufFMTJ645QenL6sF2GcjxvCd49uKtazYmA7kSmzMqlv+UsKKqk+4URN4
         8acJ1joHI/cQmt561j9mnJoEdipvED7gtwtMM/SXutTlE/eiWQyICd8V3Aka1cCKjnvI
         yA9KnPy3oOq1L3V6zsrcO/D49iZkhJNeoo2KXWZaiONj7eXwd+6QBk+RJB4WFgiwdmPz
         m6IA==
X-Gm-Message-State: AOAM531G1lVX+qjwxiK1gM7w3ZONzIdWTRqJuEmWsmE0gSKKvIq8ajXT
        xqCmz1RR5YsVvcnz6m6ogug6NZOts54O0jpsHnDF3PK6UYfORKRcOefDclcBPousZQ8xUThdiUY
        33rSA8XxFDBj0
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr3022541wry.267.1623404677690;
        Fri, 11 Jun 2021 02:44:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF7t6FkjQ+uHMri4EB7+VpKoiqBIYBM/hLoewJameHohV7ZDP+tkBEdZpbP3/QlCLr8Q0qdA==
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr3022530wry.267.1623404677478;
        Fri, 11 Jun 2021 02:44:37 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w13sm7073285wrc.31.2021.06.11.02.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 02:44:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v5 0/7] Hyper-V nested virt enlightenments for SVM
In-Reply-To: <683fa50765b29f203cb4b0953542dc43226a7a2f.camel@redhat.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <5af1ccce-a07d-5a13-107b-fc4c4553dd4d@redhat.com>
 <683fa50765b29f203cb4b0953542dc43226a7a2f.camel@redhat.com>
Date:   Fri, 11 Jun 2021 11:44:35 +0200
Message-ID: <878s3gybuk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2021-06-10 at 17:17 +0200, Paolo Bonzini wrote:
>> On 03/06/21 17:14, Vineeth Pillai wrote:
>> > This patch series enables the nested virtualization enlightenments for
>> > SVM. This is very similar to the enlightenments for VMX except for the
>> > fact that there is no enlightened VMCS. For SVM, VMCB is already an
>> > architectural in-memory data structure.
>> >=20
>> > Note: v5 is just a rebase on hyperv-next(5.13-rc1) and needed a rework
>> > based on the patch series: (KVM: VMX: Clean up Hyper-V PV TLB flush)
>> > https://lore.kernel.org/lkml/20210305183123.3978098-1-seanjc@google.co=
m/
>> >=20
>> > The supported enlightenments are:
>> >=20
>> > Enlightened TLB Flush: If this is enabled, ASID invalidations invalida=
te
>> > only gva -> hpa entries. To flush entries derived from NPT, hyper-v
>> > provided hypercalls (HvFlushGuestPhysicalAddressSpace or
>> > HvFlushGuestPhysicalAddressList) should be used.
>> >=20
>> > Enlightened MSR bitmap(TLFS 16.5.3): "When enabled, L0 hypervisor does
>> > not monitor the MSR bitmaps for changes. Instead, the L1 hypervisor mu=
st
>> > invalidate the corresponding clean field after making changes to one of
>> > the MSR bitmaps."
>> >=20
>> > Direct Virtual Flush(TLFS 16.8): The hypervisor exposes hypercalls
>> > (HvFlushVirtualAddressSpace, HvFlushVirtualAddressSpaceEx,
>> > HvFlushVirtualAddressList, and HvFlushVirtualAddressListEx) that allow
>> > operating systems to more efficiently manage the virtual TLB. The L1
>> > hypervisor can choose to allow its guest to use those hypercalls and
>> > delegate the responsibility to handle them to the L0 hypervisor. This
>> > requires the use of a partition assist page."
>> >=20
>> > L2 Windows boot time was measured with and without the patch. Time was
>> > measured from power on to the login screen and was averaged over a
>> > consecutive 5 trials:
>> >    Without the patch: 42 seconds
>> >    With the patch: 29 seconds
>> > --
>> >=20
>> > Changes from v4
>> > - Rebased on top of 5.13-rc1 and reworked based on the changes in the
>> >    patch series: (KVM: VMX: Clean up Hyper-V PV TLB flush)
>> >=20=20=20=20
>> > Changes from v3
>> > - Included definitions for software/hypervisor reserved fields in SVM
>> >    architectural data structures.
>> > - Consolidated Hyper-V specific code into svm_onhyperv.[ch] to reduce
>> >    the "ifdefs". This change applies only to SVM, VMX is not touched a=
nd
>> >    is not in the scope of this patch series.
>> >=20
>> > Changes from v2:
>> > - Refactored the Remote TLB Flush logic into separate hyperv specific
>> >    source files (kvm_onhyperv.[ch]).
>> > - Reverted the VMCB Clean bits macro changes as it is no longer needed.
>> >=20
>> > Changes from v1:
>> > - Move the remote TLB flush related fields from kvm_vcpu_hv and kvm_hv
>> >    to kvm_vcpu_arch and kvm_arch.
>> > - Modify the VMCB clean mask runtime based on whether L1 hypervisor
>> >    is running on Hyper-V or not.
>> > - Detect Hyper-V nested enlightenments based on
>> >    HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS.
>> > - Address other minor review comments.
>> > ---
>> >=20
>> > Vineeth Pillai (7):
>> >    hyperv: Detect Nested virtualization support for SVM
>> >    hyperv: SVM enlightened TLB flush support flag
>> >    KVM: x86: hyper-v: Move the remote TLB flush logic out of vmx
>> >    KVM: SVM: Software reserved fields
>> >    KVM: SVM: hyper-v: Remote TLB flush for SVM
>> >    KVM: SVM: hyper-v: Enlightened MSR-Bitmap support
>> >    KVM: SVM: hyper-v: Direct Virtual Flush support
>> >=20
>> >   arch/x86/include/asm/hyperv-tlfs.h |   9 ++
>> >   arch/x86/include/asm/kvm_host.h    |   9 ++
>> >   arch/x86/include/asm/svm.h         |   9 +-
>> >   arch/x86/include/uapi/asm/svm.h    |   3 +
>> >   arch/x86/kernel/cpu/mshyperv.c     |  10 ++-
>> >   arch/x86/kvm/Makefile              |   9 ++
>> >   arch/x86/kvm/kvm_onhyperv.c        |  93 +++++++++++++++++++++
>> >   arch/x86/kvm/kvm_onhyperv.h        |  32 +++++++
>> >   arch/x86/kvm/svm/svm.c             |  14 ++++
>> >   arch/x86/kvm/svm/svm.h             |  22 ++++-
>> >   arch/x86/kvm/svm/svm_onhyperv.c    |  41 +++++++++
>> >   arch/x86/kvm/svm/svm_onhyperv.h    | 129 +++++++++++++++++++++++++++=
++
>> >   arch/x86/kvm/vmx/vmx.c             | 105 +----------------------
>> >   arch/x86/kvm/vmx/vmx.h             |   9 --
>> >   arch/x86/kvm/x86.c                 |   9 ++
>> >   15 files changed, 384 insertions(+), 119 deletions(-)
>> >   create mode 100644 arch/x86/kvm/kvm_onhyperv.c
>> >   create mode 100644 arch/x86/kvm/kvm_onhyperv.h
>> >   create mode 100644 arch/x86/kvm/svm/svm_onhyperv.c
>> >   create mode 100644 arch/x86/kvm/svm/svm_onhyperv.h
>> >=20
>>=20
>> Queued, thanks.
>>=20
>> Paolo
>>=20
>
> Hi!
>
> This patch series causes a build failure here:
>
> arch/x86/kvm/vmx/vmx.c: In function =E2=80=98hardware_setup=E2=80=99:
> arch/x86/kvm/vmx/vmx.c:7752:34: error: =E2=80=98hv_remote_flush_tlb=E2=80=
=99 undeclared (first use in this function)
>  7752 |   vmx_x86_ops.tlb_remote_flush =3D hv_remote_flush_tlb;
>       |                                  ^~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/vmx/vmx.c:7752:34: note: each undeclared identifier is repor=
ted only once for each function it appears in
> arch/x86/kvm/vmx/vmx.c:7754:5: error: =E2=80=98hv_remote_flush_tlb_with_r=
ange=E2=80=99 undeclared (first use in this function)
>  7754 |     hv_remote_flush_tlb_with_range;
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
>
> Also this:
>
> arch/x86/kvm/vmx/vmx.c: In function =E2=80=98hardware_setup=E2=80=99:
> arch/x86/kvm/vmx/vmx.c:7752:34: error: =E2=80=98hv_remote_flush_tlb=E2=80=
=99 undeclared (first use in this function)
>  7752 |   vmx_x86_ops.tlb_remote_flush =3D hv_remote_flush_tlb;
>       |                                  ^~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/vmx/vmx.c:7752:34: note: each undeclared identifier is repor=
ted only once for each function it appears in
> arch/x86/kvm/vmx/vmx.c:7754:5: error: =E2=80=98hv_remote_flush_tlb_with_r=
ange=E2=80=99 undeclared (first use in this function)
>  7754 |     hv_remote_flush_tlb_with_range;
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20=20

Yea, reported already:

https://lore.kernel.org/kvm/683fa50765b29f203cb4b0953542dc43226a7a2f.camel@=
redhat.com/T/#mf732ba9567923d800329f896761e4ee104475894

>
> Best regards,
> 	Maxim Levitsky
>

--=20
Vitaly

