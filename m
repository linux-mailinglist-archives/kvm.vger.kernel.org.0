Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DD162D57
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBRRrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:47:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44348 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgBRRrr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 12:47:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582048066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5kjKBIhoTTidU+FupA78S2evj3eCjsBh8yUTE4Js91o=;
        b=WqXUopJ9Vi8CyaRgJWzMnDI4RWdzK7n/pk40EsSv92+dgEgK7lD4q3Rp0hraQRL/eUoRWR
        cvpYZtf+C20Fnfw+TnsTPHyNoLRBW0cIGNOQ/2cbCx7M+g11AfupdKMNxCJZSj5tNcnyP7
        BMOYd2JO4dJQvcnuMWGNbeoGfPYtf04=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-yqk_4ob0N9SJHq9Tmza9Tw-1; Tue, 18 Feb 2020 12:47:44 -0500
X-MC-Unique: yqk_4ob0N9SJHq9Tmza9Tw-1
Received: by mail-wr1-f70.google.com with SMTP id o9so11239160wrw.14
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5kjKBIhoTTidU+FupA78S2evj3eCjsBh8yUTE4Js91o=;
        b=Of6tS/NnKXR02aHNLMg4epUsxds7N5OylFeA++d1L1RrAZrg+w+HX6+4Mp628EOHkW
         eYR7yP2ZYqAKj7zBFMmYhFYPi3eHUmVKw3UFBwyqQd10Yq43GRv+etfxI3+0vmv76xXc
         lWLsWKtGsqn24DzvuKCeEB10AYFb3QUFeG1paf84OlNM7XqCG1kZmMyRKjnEvQ2F74nX
         EHIvrSBTBCeAFgtYDqNA2kHYzU4ilfI1F4mi/x/evWyRyCvWoSyXvf8748WCQFHd/1WU
         ppTzTPtvgXuO41MGIN7NFGQwMtCsZ07F4ZOHgA0sJy2SG0839lFHUEMxcWqIU5zIx/qr
         A0+w==
X-Gm-Message-State: APjAAAU8fYTp/ens6dNb29CqsmAM5GaV9H/eJ2Wewm2k3avsjAI89iHO
        zbQqzVAoIraivcFZSEbiG0Iy8zcjrNXuoR5lb59HMkK4x7TztvrULgXBmqDPU0ZXrSZdmrQbDRG
        g88xZRfEMgU8Q
X-Received: by 2002:a05:600c:2104:: with SMTP id u4mr4367472wml.93.1582048063265;
        Tue, 18 Feb 2020 09:47:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgPoCPNWqdRWxxxlv5m5qb2kca+QONzuSaxHOJTlTzKHB2ZOY2ORJdnCv42m80J8gLowgW1Q==
X-Received: by 2002:a05:600c:2104:: with SMTP id u4mr4367454wml.93.1582048063019;
        Tue, 18 Feb 2020 09:47:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id t128sm4511467wmf.28.2020.02.18.09.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 09:47:42 -0800 (PST)
Subject: Re: [PATCH RFC] target/i386: filter out VMX_PIN_BASED_POSTED_INTR
 when enabling SynIC
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>, kvm@vger.kernel.org
References: <20200218144415.94722-1-vkuznets@redhat.com>
 <9b4b46c2-e2cf-a3d5-70e4-c8772bf6734f@redhat.com>
 <87k14j962l.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d5a3159d-4cab-ef94-bbfc-e9120324cd3e@redhat.com>
Date:   Tue, 18 Feb 2020 18:47:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87k14j962l.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 18:08, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 18/02/20 15:44, Vitaly Kuznetsov wrote:
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>> RFC: This is somewhat similar to eVMCS breakage and it is likely possible
>>> to fix this in KVM. I decided to try QEMU first as this is a single
>>> control and unlike eVMCS we don't need to keep a list of things to disable.
>>
>> I think you should disable "virtual-interrupt delivery" instead (which
>> in turn requires "process posted interrupts" to be zero).  That is the
>> one that is incompatible with AutoEOI interrupts.
> 
> I'm fighting the symptoms, not the cause :-) My understanding is that
> when SynIC is enabled for CPU0 KVM does
> 
> kvm_vcpu_update_apicv()
> 	vmx_refresh_apicv_exec_ctrl()
> 		pin_controls_set()
> 
> for *all* vCPUs (KVM_REQ_APICV_UPDATE). I'm not sure why
> SECONDARY_EXEC_APIC_REGISTER_VIRT/SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
> are not causing problems and only PIN_BASED_POSTED_INTR does as we clear
> them all (not very important atm).

Let's take a step back, what is the symptom, i.e. how does it fail?
Because thinking more about it, since we have separate VMCS we can set
PIN_BASED_POSTED_INTR and SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY just fine
in the vmcs02.  The important part is to unconditionally call
vmx_deliver_nested_posted_interrupt.

Something like

	if (kvm_x86_ops->deliver_posted_interrupt(vcpu, vector)) {
                kvm_lapic_set_irr(vector, apic);
                kvm_make_request(KVM_REQ_EVENT, vcpu);
                kvm_vcpu_kick(vcpu);
        }

and in vmx_deliver_posted_interrupt

        r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
        if (!r)
                return 0;

	if (!vcpu->arch.apicv_active)
                return -1;
        ...
        return 0;

Paolo

