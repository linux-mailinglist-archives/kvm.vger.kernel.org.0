Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DAF3B22C5
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWVw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:52:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWVw6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624485039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R4zcuNwgz4KDrOo9Q0BHyGWq9Ll+WkMuuZOaSxMnp9Y=;
        b=MhmoV1QiZlDcVAVh8z2+Lyn4OYg/aXbmFpElEwnohqzyVQ9XUkmy7Teb+vPcvGBuzo/IPO
        YbWMTRswVYfuFl49T1voe/DHDcbm8krpT31sPDgQDrdwzLKstG03R+ive6bgXxK2w5s2nb
        Z9VJ70PstLoImX6zJ7VOxKC/I+VsD4c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-ZKAtiGeWNya2QkFL0oblZw-1; Wed, 23 Jun 2021 17:50:38 -0400
X-MC-Unique: ZKAtiGeWNya2QkFL0oblZw-1
Received: by mail-ed1-f69.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so2096474edv.8
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R4zcuNwgz4KDrOo9Q0BHyGWq9Ll+WkMuuZOaSxMnp9Y=;
        b=t516HoPnWktatQ2XtyCll4Ceqd5a0H0BoOifroOTKooWW4D53WKUyzAYTGFvzSWw06
         HiHihkEUlEJc+IS1Zf45fFCIxIc8NTSNdlXzMraAI83RhgYcoSaBp7lT48OnBg0cZJvN
         RQowCrunbGzneoaUCKyfOS+OLYXElRJr4uYk1FDHxTzqPJY9mtsOh2+X3gD7+5uDw5K5
         ueDKloNbraDC3jkBz/avrQMRRwff95Uc21JAUQNunBa5V7AcDuOXjbiBf1te/CeFPp0Q
         PC9t29swOvVVKgRGsfMtIgHleKn9q/Q9oWm/VQx0YaZcJ/vJqUKWrnhZzE26cCrFXUF2
         VGYg==
X-Gm-Message-State: AOAM532FUDJwy8Avo3n7CaEn7utkwpNdicYIg2MlMx/HJX//V2KVVRP1
        QAO16/y4951gpQ+nqFTNF0B17x3AZB6GGFkxFON40foCSH8idYGn6JzE3HgyvYUZvq6an9Pz5Ww
        7jsQfPFi5iMv+
X-Received: by 2002:aa7:c38f:: with SMTP id k15mr2512638edq.156.1624485037381;
        Wed, 23 Jun 2021 14:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAy2ZTGWYTco9kBILNpamIVqWTNuitJVBYCZHdqJItKemQc+pZb1AfQc4HTI9INxckEwCrZA==
X-Received: by 2002:aa7:c38f:: with SMTP id k15mr2512620edq.156.1624485037238;
        Wed, 23 Jun 2021 14:50:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r23sm720630edy.13.2021.06.23.14.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:50:36 -0700 (PDT)
Subject: Re: [PATCH 02/10] KVM: x86: APICv: fix race in
 kvm_request_apicv_update on SVM
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
 <20210623113002.111448-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c4a69ce-595e-d5a1-7b4e-e6ce1afe1252@redhat.com>
Date:   Wed, 23 Jun 2021 23:50:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623113002.111448-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 13:29, Maxim Levitsky wrote:
> +	kvm_block_guest_entries(kvm);
> +
>   	trace_kvm_apicv_update_request(activate, bit);
>   	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
>   		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
> @@ -9243,6 +9245,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>   	except = kvm_get_running_vcpu();
>   	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
>   					 except);
> +
> +	kvm_allow_guest_entries(kvm);

Doesn't this cause a busy loop during synchronize_rcu?  It should be 
possible to request the vmexit of other CPUs from 
avic_update_access_page, and do a lock/unlock of kvm->slots_lock to wait 
for the memslot to be updated.

(As an aside, I'd like to get rid of KVM_REQ_MCLOCK_IN_PROGRESS in 5.15...).

Paolo

