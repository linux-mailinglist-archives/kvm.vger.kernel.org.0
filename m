Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055A26EC21
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387823AbfGSVjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 17:39:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51521 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbfGSVjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 17:39:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so30011952wma.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 14:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vcXUuA84+iXxhogPbUZNrkN9nPoDqv5s4mRiBH5fbBo=;
        b=UarR2UDVeot50NuZTGSCbbW+PvT5psdP6BY5uQuD+EkjxhouWhombK3CgMsVSUxBRq
         sRrQJdtLwP6/cmowdktFjfl6RXvCsapoEg1kqbXq+PuNLjcgvbA8JIy3LAUr3/BtACQg
         YmdqBWje0vSQuiJjomCSdmEoyTy2PZ3KsdHwAvQ0Fst8jukg7/gw6e0J7migglDIKfMo
         BqJfiCsttu8lUuICV78ntzgsc5AaMrTmkXFIV7KGLu1cNRJ4rwe5dJHzIoNsVsp8znwS
         vq8X/WaU113WZcT432FLOMD6/lCf2e4llxEvGyVLa7YjKzQKJKtz3kAzKN9JpAp0Uu5a
         KJHg==
X-Gm-Message-State: APjAAAWW+LSy555SbVBhu22m39ttEagi8hy5FT99olqiBNrp/5B8sdVr
        dU8b+2anlWjyJQOLiAa6vhbaHjjaL+I=
X-Google-Smtp-Source: APXvYqxczDHRIF/87Qgt/TsyiyVejkmUIaSMnN810bvoZvxfDLqgN9MDpP3Ea+9x7uUHxmIUo7+r4w==
X-Received: by 2002:a05:600c:291:: with SMTP id 17mr48600620wmk.32.1563572345611;
        Fri, 19 Jul 2019 14:39:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id f17sm27295784wmf.27.2019.07.19.14.39.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 14:39:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: do not use dangling shadow VMCS after guest
 reset
To:     Liran Alon <liran.alon@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1563554534-46556-3-git-send-email-pbonzini@redhat.com>
 <6D1C57BE-1A1B-4714-B4E5-E0569A60FD1F@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2a84f9d3-f58f-bcf3-56ef-a40fcbbaf8af@redhat.com>
Date:   Fri, 19 Jul 2019 23:39:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6D1C57BE-1A1B-4714-B4E5-E0569A60FD1F@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/19 23:01, Liran Alon wrote:
> 
> 
>> On 19 Jul 2019, at 19:42, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> If a KVM guest is reset while running a nested guest, free_nested will
>> disable the shadow VMCS execution control in the vmcs01.  However,
>> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
>> the VMCS12 to the shadow VMCS which has since been freed.
>>
>> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
>> the host to hang altogether.  Let's see how much this trivial patch fixes.
>>
>> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> First, nested_release_vmcs12() also sets need_vmcs12_to_shadow_sync
> to false explicitly. This can now be removed.
> 
> Second, I suggest putting a WARN_ON_ONCE() on copy_vmcs12_to_shadow()
> in case shadow_vmcs==NULL.
Both good ideas.  Thanks for the quick review!

Paolo

> To assist catching these kind of errors more easily in the future.
> 
> Besides that, the fix seems correct to me.
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> 
> -Liran
> 
>> ---
>> arch/x86/kvm/vmx/nested.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 6e88f459b323..6119b30347c6 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>> {
>> 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
>> 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
>> +	vmx->nested.need_vmcs12_to_shadow_sync = false;
>> }
>>
>> static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>> -- 
>> 1.8.3.1
>>
> 

