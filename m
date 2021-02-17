Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5A631DEC9
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 19:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhBQSIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 13:08:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233121AbhBQSIE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 13:08:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613585197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+PafZtTxxRkQ/4iNlBI25yfowv1emoIIbzvsMB2gSE=;
        b=Y/chTFCJ2hixJEiLF88GIhd6CPmu93FcwVns2gkwxSaOn7+mq5vJweNBlZZDP07I73s67u
        1K2s1humEN/USTwgWIGwAAib44kOmtBoUBxQK8OBaBlz27I3zqLm3va94WPETtnkkoHhQc
        xFu5or32tas1vg6jYuSsbRqbtmdXE2M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-eSfdebhSMNqQy1FENNYJyA-1; Wed, 17 Feb 2021 13:06:35 -0500
X-MC-Unique: eSfdebhSMNqQy1FENNYJyA-1
Received: by mail-wm1-f71.google.com with SMTP id z67so2696107wme.3
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 10:06:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+PafZtTxxRkQ/4iNlBI25yfowv1emoIIbzvsMB2gSE=;
        b=NiMxoUt+P613fk5Eq3mV3rJ0GZsO/xNEp6hY41yhxCPPEaRdGDYOeFlfxY2oSLwqrp
         BInMXV1BClM6UoWoryL1b14a4I7QdXHoqBIn+IakIFpDq/YhH69LmSmxj5U4ecU2L1VS
         29QP2yHiAgB1KU1eOPdE1WHsi9yVpOHQOHWkLDPFVurRP2kPkoOy/1wAq+HnEs8K1AWf
         Nw4DKXZpQNKCvLkRGq4kC3kyX56S2LlORuKar6pHC36iI2QjVumqJy4TfACTDwlfCacK
         E3hkaAm1QgiELS4PRinho4D1YYqdew6bxio4I/gTJDAVi9F7Fp1NIeCiDxycsPSfFWqW
         jSsQ==
X-Gm-Message-State: AOAM530NBpxWY6HJHEDvy81glFyJ2l/arf6N8B3hn6gt9NZrrcN3muYS
        1bWtntAI65u/qPGRIImFyiFXZzBs/vYB4O7Fg8sPfBUcXJqEwqLTohkpptbTGSuYvfsWgijV/v+
        tQ5JpbqEPwZpZ
X-Received: by 2002:a7b:c397:: with SMTP id s23mr136719wmj.10.1613585194475;
        Wed, 17 Feb 2021 10:06:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzj3+yONrD5USEwpi0jytCwqxYl0gWMNhs6MJDy1RnaxhN+ylhooyQJKQvSXLrh8MQUjAvhhA==
X-Received: by 2002:a7b:c397:: with SMTP id s23mr136705wmj.10.1613585194201;
        Wed, 17 Feb 2021 10:06:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w8sm5037173wrm.21.2021.02.17.10.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 10:06:33 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-7-mlevitsk@redhat.com> <YC1X2FMdPn32ci1C@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/7] KVM: nVMX: don't load PDPTRS right after nested state
 set
Message-ID: <8660e415-5375-d4cf-54d4-b0b8eb6e1dc3@redhat.com>
Date:   Wed, 17 Feb 2021 19:06:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC1X2FMdPn32ci1C@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/21 18:52, Sean Christopherson wrote:
>>
>> Just move the call to nested_vmx_load_cr3 to nested_get_vmcs12_pages
>> to implement this.
>
> I don't love this approach.  KVM_SET_NESTED_STATE will now succeed with a bad
> vmcs12.GUEST_CR3.  At a minimum, GUEST_CR3 should be checked in
> nested_vmx_check_guest_state().  It also feels like vcpu->arch.cr3 should be set
> immediately, e.g. KVM_SET_NESTED_STATE -> KVM_GET_SREGS should reflect L2's CR3
> even if KVM_RUN hasn't been invoked.

Note that KVM_SET_NESTED_STATE does not remove the need to invoke 
KVM_SET_SREGS.  Calling KVM_SET_NESTED_STATE does not necessarily saying 
anything about the value of KVM_GET_SREGS after it.

In particular on SVM it's a "feature" that KVM_SET_NESTED_STATE does not 
include any guest register state; the nested state only includes the 
VMCB12 control state and the L1 save state.  But thinking more about it, 
loading the PDPTRs for the guest CR3 might not be advisable even upon 
KVM_SET_SREGS, and we might want to extend KVM_REQ_GET_NESTED_PAGES to 
cover non-nested PDPTRs as well.

Paolo

