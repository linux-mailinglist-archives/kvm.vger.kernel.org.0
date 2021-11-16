Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86700453507
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237835AbhKPPIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:08:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237762AbhKPPHA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637075043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbwhlYSET4WxARKb5uDjrAIi8kWP88Xedd5ECAgSeaU=;
        b=aLZ6t/3embtTHzHJQDdWRvnCoxMHcPmUUaeXNW3v6aya07a2QPVnpsPov5rLNUrDhLjZHt
        WMVmLYAgxi11ICSxAxKCY1J03FPAG/3P/teIeyAjCVR3mAG1DawIZIXxxM+rUEOThzz3S1
        +amTfxTnHQc1BnTohlBEbjlxVSVYvOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-24-8NqL3LsANZit7G29sdqVjg-1; Tue, 16 Nov 2021 10:04:00 -0500
X-MC-Unique: 8NqL3LsANZit7G29sdqVjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E6A192376D;
        Tue, 16 Nov 2021 15:03:57 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C63895DEFB;
        Tue, 16 Nov 2021 15:03:41 +0000 (UTC)
Message-ID: <dd5292e5-7387-9797-2d74-6a3350cbe4f5@redhat.com>
Date:   Tue, 16 Nov 2021 16:03:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Turn the vcpu array into an xarray
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linuxppc-dev@lists.ozlabs.org
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211105192101.3862492-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211105192101.3862492-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/21 20:20, Marc Zyngier wrote:
> The kvm structure is pretty large. A large portion of it is the vcpu
> array, which is 4kB on x86_64 and arm64 as they deal with 512 vcpu
> VMs. Of course, hardly anyone runs VMs this big, so this is often a
> net waste of memory and cache locality.
> 
> A possible approach is to turn the fixed-size array into an xarray,
> which results in a net code deletion after a bit of cleanup.
> 
> This series is on top of the current linux/master as it touches the
> RISC-V implementation. Only tested on arm64.

Queued, only locally until I get a review for my replacement of patch 4 
(see 
https://lore.kernel.org/kvm/20211116142205.719375-1-pbonzini@redhat.com/T/).

Paolo

> Marc Zyngier (5):
>    KVM: Move wiping of the kvm->vcpus array to common code
>    KVM: mips: Use kvm_get_vcpu() instead of open-coded access
>    KVM: s390: Use kvm_get_vcpu() instead of open-coded access
>    KVM: x86: Use kvm_get_vcpu() instead of open-coded access
>    KVM: Convert the kvm->vcpus array to a xarray
> 
>   arch/arm64/kvm/arm.c           | 10 +---------
>   arch/mips/kvm/loongson_ipi.c   |  4 ++--
>   arch/mips/kvm/mips.c           | 23 ++---------------------
>   arch/powerpc/kvm/powerpc.c     | 10 +---------
>   arch/riscv/kvm/vm.c            | 10 +---------
>   arch/s390/kvm/kvm-s390.c       | 26 ++++++--------------------
>   arch/x86/kvm/vmx/posted_intr.c |  2 +-
>   arch/x86/kvm/x86.c             |  9 +--------
>   include/linux/kvm_host.h       |  7 ++++---
>   virt/kvm/kvm_main.c            | 33 ++++++++++++++++++++++++++-------
>   10 files changed, 45 insertions(+), 89 deletions(-)
> 

