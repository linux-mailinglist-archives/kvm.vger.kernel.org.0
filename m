Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F753BD7C8
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhGFN3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:29:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231535AbhGFN3P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625577997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6GKbKb42lb4IhAfyCCRv2xGL8eyeUScTryxYmNKLo0=;
        b=S0z4/HUUfpMbLDuoHxkcwcDteEFT+G+TQwVYO7ZBrbWmahmnt0r5vqYtR75aD/FBSdby/n
        tcQRPVKyvd60U5p7gliZPcIbNJNofx2N7ftT4VUXXQVZqrs9Pm9JW1kn16rxNV65sm5/m+
        jnYBx/FMFJkCJw2a3Sn3RfH2lOP1tP0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-2s2lHfSKMZKxXWv-DgfV6g-1; Tue, 06 Jul 2021 09:26:35 -0400
X-MC-Unique: 2s2lHfSKMZKxXWv-DgfV6g-1
Received: by mail-ej1-f71.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso5800666ejo.13
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b6GKbKb42lb4IhAfyCCRv2xGL8eyeUScTryxYmNKLo0=;
        b=cMoBcYgUzsesh2hOVvnlS9WRruo72wtTq6TK70OH9eGWgSp29ot2VWY483gYpV7zSX
         MgsMjLr0yELHfYEev1jIpaog0AsiF7eWEmb/GrtlDNwIHasgrnKVwmpHJ1YYYfTfFjhU
         Q/4uutHjZx86wmLjX1EfqqY4lTudTp9+we16LHy65ziy6Y3/OmC8JoeLboseo/x10GEO
         ceeRQBp+Xxl4Q3j8wB0amMueFuGkoDdeU8AiGbPkUGMB2dF8LRvMDW94Wrz8UDGJZxQy
         w2AWfB6TyADE6zzdzQWEVAfMavM7WE/Q9vtlQob2v9yDWXzcLkkfUR1MzkE+4b2PdSYW
         kMYQ==
X-Gm-Message-State: AOAM53139B+n1LlMBNkHpM9h6aJqVaizCDj6y7lcbBxmURMyLZwi7vm1
        szZWvidUHJVY0RLZJ3vr0P9KbAdyqtbmL0Jnv5Vf4uqghuX+BIY0esLh/TwMADcWutHmIp/QxkB
        SIIN37JPw+A3w
X-Received: by 2002:a05:6402:b07:: with SMTP id bm7mr16352210edb.345.1625577994609;
        Tue, 06 Jul 2021 06:26:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFQY7PMIYcptMAm/SaUsNVFb1WM1ttXVf+dTr64wKcBF1o5EeVDoiod8ZHzMLF8N9FelD/EQ==
X-Received: by 2002:a05:6402:b07:: with SMTP id bm7mr16352179edb.345.1625577994479;
        Tue, 06 Jul 2021 06:26:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z17sm5713482ejj.36.2021.07.06.06.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:26:33 -0700 (PDT)
Subject: Re: [RFC PATCH v2 13/69] KVM: Enable hardware before doing arch VM
 initialization
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <66062b64b2b61cd985e280418a7c4318104bc541.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3e9c9907-09ad-7c9f-fc71-df4eaa88bc78@redhat.com>
Date:   Tue, 6 Jul 2021 15:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <66062b64b2b61cd985e280418a7c4318104bc541.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> This also provides consistent ordering between kvm_create_vm() and
> kvm_destroy_vm() with respect to calling kvm_arch_destroy_vm() and
> hardware_disable_all().
> 
> Signed-off-by: Sean Christopherson<sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> ---
>   virt/kvm/kvm_main.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9e52fe999c92..751d1f6890b0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -923,7 +923,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   		struct kvm_memslots *slots = kvm_alloc_memslots();
>   
>   		if (!slots)
> -			goto out_err_no_arch_destroy_vm;
> +			goto out_err_no_disable;
>   		/* Generations must be different for each address space. */
>   		slots->generation = i;
>   		rcu_assign_pointer(kvm->memslots[i], slots);
> @@ -933,19 +933,19 @@ static struct kvm *kvm_create_vm(unsigned long typ

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

