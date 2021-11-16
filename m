Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20363452EA1
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhKPKGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:06:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233673AbhKPKGo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637057027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYYl6vgvaDE4CzC6E4lkhaBh50OJahnR36Yzvrw/SDw=;
        b=IZq2KL1g/RV/3SoVMqwMId2s4gXHnivxKW5i68pYvHagA+QRVxNCKi/a2OU1OIVW4Wr4IR
        vfTWpYdsosidSG7+rAxW/3SCMT0Wa35lcckLxN+/GculUKDU5fbVHFbEWWNcG+3PMzxoaq
        t2Hx/g6mhv6ZYhbQKwCTfsBnJZko7T8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-UVLan-wwO4ei1Ne2pyX79Q-1; Tue, 16 Nov 2021 05:03:44 -0500
X-MC-Unique: UVLan-wwO4ei1Ne2pyX79Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7827B9F92A;
        Tue, 16 Nov 2021 10:03:41 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7255557CAD;
        Tue, 16 Nov 2021 10:03:31 +0000 (UTC)
Message-ID: <e48b533f-8930-ab48-cbc3-660e2827b031@redhat.com>
Date:   Tue, 16 Nov 2021 11:03:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/2] KVM: nVMX: don't use vcpu->arch.efer when checking
 host state on nested state load
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>
References: <20211115131837.195527-1-mlevitsk@redhat.com>
 <20211115131837.195527-2-mlevitsk@redhat.com> <YZKB3Q1ZMsPD6hHl@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZKB3Q1ZMsPD6hHl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 16:50, Sean Christopherson wrote:
>    When loading nested state, don't use check vcpu->arch.efer to get the
>    L1 host's 64-bit vs. 32-bit state and don't check it for consistency
>    with respect to VM_EXIT_HOST_ADDR_SPACE_SIZE, as register state in vCPU
>    may be stale when KVM_SET_NESTED_STATE is called and conceptually does
>    not exist.  When the CPU is in non-root mode, i.e. when restoring L2
>    state in KVM, there is no snapshot of L1 host state, it is (conditionally)
>    loaded on VM-Exit.  E.g. EFER is either preserved on exit, loaded from the
>    VMCS (vmcs12 in this case), or loaded from the MSR load list.
> 
>    Use vmcs12.VM_EXIT_HOST_ADDR_SPACE_SIZE to determine the target mode of
>    the L1 host, as it is the source of truth in this case.  Perform the EFER
>    vs. vmcs12.VM_EXIT_HOST_ADDR_SPACE_SIZE consistency check only on VM-Enter,
>    as conceptually there's no "current" L1 EFER to check.
> 
>    Note, KVM still checks vmcs12.HOST_EFER for consistency if
>    if vmcs12.VM_EXIT_LOAD_IA32_EFER is set, i.e. this skips only the check
>    against current vCPU state, which does not exist, when loading nested state.

Queued with some further edits and nested_vmx_check_address_state_size 
renamed to nested_vmx_check_address_*space*_size.

I think the "!!" are best left in place though, because "!!(a & b)" is 
idiomatic. Comparing "!(a & b)" would leave the reader wondering about 
the inversion, and "(bool)(a & b)" is just too ugly and magic.  The 
compiler anyway converts the "!!" to "!= 0" very early on, and never 
performs back-to-back logical NOTs.

Paolo

