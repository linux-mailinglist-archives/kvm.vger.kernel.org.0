Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01D84B132F
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbiBJQko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:40:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244518AbiBJQkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:40:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93139E83
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKM3MG407sDe7fSxFjGv90FiembQtgV4jikyh1VEkmM=;
        b=SszGjEvlirUTiQtPv9I8eDNeTehoJtx2m8hauvqyD9SgaTrO4xNrTOmG+Qsoo2rH0TCqxD
        OM1JMyJgaPeXqsUIXj4I5XDKyRSu/NCFZrYJRFbCqs8NH2PUbci4/pyWdAmKgHw4NBWwrE
        BGS4XqgFuEVbQK30UOu8wLvbYdTSODU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-aYjQpOOAPjaGOzQuksBJyA-1; Thu, 10 Feb 2022 11:40:41 -0500
X-MC-Unique: aYjQpOOAPjaGOzQuksBJyA-1
Received: by mail-ed1-f70.google.com with SMTP id w3-20020a50c443000000b0040696821132so3631611edf.22
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lKM3MG407sDe7fSxFjGv90FiembQtgV4jikyh1VEkmM=;
        b=hp2fKEDb94FyP10E5pPkZ4ekx1hzymw39JUBzDxmNGxF8TT9h5YcIKbErKGEJJbbj6
         htYj9OCS5LX+tln0NL6ie6tL0W9IHaaXxE7FklD4aiVC+++6SulTo0oB9oyvL0yswWhU
         6mliObsMUD0NUNOK+PCNcQaaXtsU2oq+yPWLN/WIz+g8Ji6kkfoQjCEtG7TDEzTfZKog
         hLC8IrbDyl/73XLC00uPbX255grULskLACB2FkErHETU0Z7G8DCa1Myc+MRo6yDjCtul
         a99xn6qk6ukC/fKm4vWlZmj+8xGiQzWZd0x6QUmveq6AxmIHOqzou7mql265wHGd4nOc
         jaQw==
X-Gm-Message-State: AOAM531uGbcYKjcZpgIbcHK3RHRWbCgWEOiWTEcN2sJoMEnHlzMHg0Ls
        K6fw+CdAiRGsE+kCmueblbQYmiGmoaDxY0qYArYLwXhUYfa86bx4lzrqFc+5oVsl60ZAF3z4Rld
        gnLpBGks68jmR
X-Received: by 2002:a17:906:4fc5:: with SMTP id i5mr7086712ejw.729.1644511240548;
        Thu, 10 Feb 2022 08:40:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzV+kkWAkDA+GVbVhDi40TKxNCd+Z8dy6ITJnQdUuE1VbOyNuQ9Fpdu14fPSu5orbUKXw9xqA==
X-Received: by 2002:a17:906:4fc5:: with SMTP id i5mr7086689ejw.729.1644511240351;
        Thu, 10 Feb 2022 08:40:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s8sm7105459ejb.59.2022.02.10.08.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:39 -0800 (PST)
Message-ID: <b0b3d4be-8adb-335c-90cc-fa85637d3f51@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10 2/6] KVM: nVMX: eVMCS: Filter out
 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185714.48936-1-sashal@kernel.org>
 <20220209185714.48936-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185714.48936-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 19:57, Sasha Levin wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit 7a601e2cf61558dfd534a9ecaad09f5853ad8204 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Enlightened VMCS v1 doesn't have VMX_PREEMPTION_TIMER_VALUE field,
> PIN_BASED_VMX_PREEMPTION_TIMER is also filtered out already so it makes
> sense to filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER too.
> 
> Note, none of the currently existing Windows/Hyper-V versions are known
> to enable 'save VMX-preemption timer value' when eVMCS is in use, the
> change is aimed at making the filtering future proof.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220112170134.1904308-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/evmcs.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index bd41d9462355f..011929a638230 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -59,7 +59,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   	 SECONDARY_EXEC_SHADOW_VMCS |					\
>   	 SECONDARY_EXEC_TSC_SCALING |					\
>   	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
> -#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> +#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
> +	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> +	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>   #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>   #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>   

