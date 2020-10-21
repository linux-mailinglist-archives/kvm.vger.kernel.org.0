Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56E294A5B
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437864AbgJUJSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:18:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437714AbgJUJSc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 05:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603271910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BuwkUAjLlfFrMB6xaXRKIQfvGDBRzOXmT/8rwImt4Tc=;
        b=XGDROQ2b9LP9Auj2eouSrz4DmFP7lvxWAc+sQybxzUzXLsry73PzfpnsUX1m26f43VwqgJ
        AnQ06kPP1Yc6sKmNQeDRo3JPTFcujNgY+HLm+jtKuTjQR322AS/2JRSEhy6cANeV2mJjEH
        80jkP5cJLyKuVSIG0EzUmcGbxMvz5y4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-LP2fBE9LNASSG_OoPYnzMQ-1; Wed, 21 Oct 2020 05:18:28 -0400
X-MC-Unique: LP2fBE9LNASSG_OoPYnzMQ-1
Received: by mail-ej1-f72.google.com with SMTP id x12so1507898eju.22
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 02:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BuwkUAjLlfFrMB6xaXRKIQfvGDBRzOXmT/8rwImt4Tc=;
        b=Np6FD8wrszC39WZTSavQD6Hzv58qnNsJmXZZDnGeJEhAxrA+SOW3R0KHx/4GdD2XRZ
         9Y7NEof2dvTEoSI7OjyIEKVipsmYc41Y0OPvsfoi+6TCTsyjjg/x+e1SPJN00mDHGeM+
         ePw9PgtB3yW1QvI/thrDSCFk4a41tGAHxX3Q2CZO7Wvqk3U/j8uOrqqG6UZ5EKb/uTsn
         R0KiSpJS+rqiLb/tkSR3/ZbenpUbHo7+Bo6W3VQvydIt/xQsKZMmW1RZGh8vpTT7cnV/
         cn3pSog8Flth10g+HiQ+IjaslYlKo68FYhiV3ZJUnGaX6jQSDxqjNHVUqzBZBmcwB/Up
         OkKQ==
X-Gm-Message-State: AOAM531pUKFofMQ1gXLe+rTIBtZOWwXd1P+OU1OOOjRsq09WmUrB6H4f
        Nba7WVo5Tp1tGDrLvgX5YYxILFbMjotO54BGtCysVYgmZoKvCkmXEGR+1IzjWcm+j6I8yOThkB9
        GIo7xmj7ZHJez
X-Received: by 2002:a17:906:395a:: with SMTP id g26mr2442209eje.147.1603271907185;
        Wed, 21 Oct 2020 02:18:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1RxSS64rCEGcYTuA52gSqVnQYMuyREEUaL2hSk8fLqQi1kllGDBnahWJqHS7C19HXqY1pOg==
X-Received: by 2002:a17:906:395a:: with SMTP id g26mr2442191eje.147.1603271906947;
        Wed, 21 Oct 2020 02:18:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e17sm1886517ejh.64.2020.10.21.02.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 02:18:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/10] KVM: VMX: Clean up Hyper-V PV TLB flush
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 11:18:25 +0200
Message-ID: <87d01c544e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
> a nested VMM.  

The terminology we use is a bit confusing and I'd like to use the
opportunity to enlighten myself on how to call "PV TLB flushing"
properly :-)

Hyper-V supports two types of 'PV TLB flushing':

HvFlushVirtualAddressSpace/HvFlushVirtualAddressList[,Ex] which is
described in TLFS as ".. hypercall invalidates ... virtual TLB entries
that belong to a specified address space."

HvFlushGuestPhysicalAddressSpace/HvFlushGuestPhysicalAddressList which
in TLFS is referred to as "... hypercall invalidates cached L2 GPA to
GPA mappings within a second level address space... hypercall is like
the execution of an INVEPT instruction with type “single-context” on all
processors" and INVEPT is defined in SDM as "Invalidates mappings in the
translation lookaside buffers (TLBs) and paging-structure caches that
were derived from extended page tables (EPT)." (and that's what this
series is about)

and every time I see e.g. 'hv_remote_flush_tlb.*' it takes me some time
to recall which flushing is this related to. Do you by any chance have
any suggestions on how things can be improved?

> No real goal in mind other than the sole patch in v1, which
> is a minor change to avoid a future mixup when TDX also wants to define
> .remote_flush_tlb.  Everything else is opportunistic clean up.
>

Looks like a nice cleanup, thanks!

> Ran Hyper-V KVM unit tests (if those are even relevant?)

No, they aren't. KVM doesn't currently implement
HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST so we can't test this feature
outside of a real Hyper-V environment. We also don't yet test KVM-on-KVM
with Enlightened VMCS ...

> but haven't actually tested on top of Hyper-V.

Just in case you are interested in doing so and there's no Hyper-V
server around, you can either search for a Win10 desktop around or just
spin an Azure VM where modern instance types (e.g. Dv3/v4, Ev3/v4
families, Intel only - so no Ea/Da/...) have VMX and PV Hyper-V features
exposed.

I'm going to give this a try today and I will also try to review
individual patches, thanks again!

>
> v2: Rewrite everything.
>
> Sean Christopherson (10):
>   KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
>   KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB
>     flush
>   KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
>   KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
>   KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
>   KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
>   KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
>   KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is
>     enabled
>   KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
>   KVM: VMX: Track PGD instead of EPTP for paravirt Hyper-V TLB flush
>
>  arch/x86/kvm/vmx/vmx.c | 102 ++++++++++++++++++++---------------------
>  arch/x86/kvm/vmx/vmx.h |  16 +++----
>  2 files changed, 57 insertions(+), 61 deletions(-)

-- 
Vitaly

