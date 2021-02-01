Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC830A33D
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhBAIWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:22:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232303AbhBAIWk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 03:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612167673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8dLlKIHmcyEYeE4z+uH1Shq2VDlSKROXEOZtZ+b36I=;
        b=Lj3iCUld8+U9A7xYtk2eeDWywJHgAmP6PJ5WpCmKnzGRFtwxuXFWfrtrnQSMQloqH4u5yH
        Tj70JC3gstZHfxpsHp8jHO/d0ozyWZimMueewK3JRRH61BPv+ShvioVEOdSlH39/PCDb/p
        IBqpCawfXu/Iz2DOPyprYG0dLTEi3Ac=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-UeJwP8ZFPTyxIkb6uacGqg-1; Mon, 01 Feb 2021 03:21:10 -0500
X-MC-Unique: UeJwP8ZFPTyxIkb6uacGqg-1
Received: by mail-wm1-f72.google.com with SMTP id y9so4478278wmi.8
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 00:21:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C8dLlKIHmcyEYeE4z+uH1Shq2VDlSKROXEOZtZ+b36I=;
        b=AiCn0N5NQ3ME/Eatj9rq4OJDBCgXxc9EmfC1uFC405oqgDKzPHx4y+JiBavYFzyHF1
         uzM4VpruR/6L6svvWuHOFzx84uLpWoIRl2don2SJPuUpsCfiEGqBPKh6JH1AWyx8zroZ
         RtYIwl26ABBG7a1McD8q4rxRBnKBryyqcJUycYRxWs+8FFjvtSeHgDNpd9ds660OZH/Z
         Y/FHnj1BcOseWkHwUXU1dyGukUOPGmNQ5PElrJH3xqFzEYuHxpGDd6Vu80tYjayO6i8y
         saroz0+hP26hHYgdwmV5BiwCJpob9vKy6cPjYcIGuUBA2zyw4gGjXBxxkXw5adG8ICne
         Zj3g==
X-Gm-Message-State: AOAM532ovm3eWIwxkaaKkx6FkAZRLtdO/tiHTZLYcW1pghFwYz+f8y5C
        0LQp++gy4QcKIaFQFsG7OUFAfcOXlgUMW42DvcAjJF3fZJuWCcoTC6MhDK2kGBmfyuwqZrgIOZb
        wOn5h4YvbjyQe
X-Received: by 2002:a7b:c395:: with SMTP id s21mr13852624wmj.97.1612167668891;
        Mon, 01 Feb 2021 00:21:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytGcsyTNl68HmEXIM6PvQnYm0YmMX8xNhecqZC1HSaBYG2HVkz7Mm7gcFTiMP9kCbwzfZk5w==
X-Received: by 2002:a7b:c395:: with SMTP id s21mr13852614wmj.97.1612167668736;
        Mon, 01 Feb 2021 00:21:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s23sm19772546wmc.35.2021.02.01.00.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 00:21:07 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Make HVA handler retpoline-friendly
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3f775de-9cb5-5f30-3fbc-a5e80c1654de@redhat.com>
Date:   Mon, 1 Feb 2021 09:21:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 09:13, Maciej S. Szmigiero wrote:
>   static int kvm_handle_hva_range(struct kvm *kvm,
>   				unsigned long start,
>   				unsigned long end,
> @@ -1495,8 +1534,9 @@ static int kvm_handle_hva_range(struct kvm *kvm,


> -static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
> -		unsigned long end, unsigned long data,
> -		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
> -			       struct kvm_mmu_page *root, gfn_t start,
> -			       gfn_t end, unsigned long data))
> -{

Can you look into just marking these functions __always_inline?  This 
should help the compiler change (*handler)(...) into a regular function 
call.

Paolo

