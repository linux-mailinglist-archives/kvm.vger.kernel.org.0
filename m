Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2485307662
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 13:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhA1MuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:50:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhA1Mt7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 07:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611838112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUPoogxEubiZKmDpms6g+giQK6dPAk2ieocombt6yus=;
        b=dtxfkYI5ybRJci2P8TEZ4ELSeOp/xVuPxbcerdHd5sL5IpkGQue33B5AsgJOWWUXjO4Md6
        Srl3fEmb6rSkYb2kVg4zXdvkSfmG3qC1PebcQ/CKxIeKMdzr8wLHwa7J5j9XqtO0pq8eRB
        zPWF/1ioUbSfw0cf1Zx1/rOYrRyE/l4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-ZgnV6iAgOVGWmelTyzYUjA-1; Thu, 28 Jan 2021 07:48:30 -0500
X-MC-Unique: ZgnV6iAgOVGWmelTyzYUjA-1
Received: by mail-ed1-f69.google.com with SMTP id a24so3101586eda.14
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 04:48:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EUPoogxEubiZKmDpms6g+giQK6dPAk2ieocombt6yus=;
        b=nC7xauXGz6MqMJmEoFT0WiGz1IawnKu++Abm2puXJvaXMZUMg/f0m5+yH3sMnwdJ7x
         ihSjjdYqIYkBAPTZKDsfEHXGIZYnj/J5VfiqcqhOyrzHkNJqQ4T+dy1OzRWwhVyIGLkT
         uaN695a/c/vld/pcIlu7MDLD2rX3cP8jYcbBISv0uZURF0eARMHS5zOMD9Dtl/drWQjQ
         /iMaJo0/BopbofWDb5Y2WH2SDauHRhV0x2MbLKxCqfYnctiub5/XJqFraOHIU++mfR7k
         Ifax468xOMhOFMMdZpblI1Wz2R9tbdJTZbrBcXevwvi4jcclqGQgRYDlV2k7wHBResqX
         dyLw==
X-Gm-Message-State: AOAM533tA7IJwpXVEQVXydYm/VnSguL9DLbFFzON8M4SIJ40dAXSAkp+
        OoJORPcpgdt9eNO8I/tVeq6PI3VZ54ZiUulrA+AhBqfYddjmwJkgqd6ssGrteeKVKob3Zal8JMP
        i5/oc19zkNNk9
X-Received: by 2002:a17:906:1741:: with SMTP id d1mr11214338eje.182.1611838109706;
        Thu, 28 Jan 2021 04:48:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/JAyUJF7PPPKqjMCwpTENChv61cKhvZqdnrTgL4rLTXUDksn14ITZ3hGVKqvIogwfrKLeYA==
X-Received: by 2002:a17:906:1741:: with SMTP id d1mr11214320eje.182.1611838109554;
        Thu, 28 Jan 2021 04:48:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x9sm2247425ejd.99.2021.01.28.04.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 04:48:28 -0800 (PST)
Subject: Re: [PATCH v3 0/2] KVM: x86/mmu: Skip mmu_notifier changes when
 possible
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Stevens <stevensd@google.com>
References: <20210128060515.1732758-1-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c01b01dc-c636-1d1b-fb42-df718e23d20a@redhat.com>
Date:   Thu, 28 Jan 2021 13:48:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210128060515.1732758-1-stevensd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 07:05, David Stevens wrote:
> These patches reduce how often mmu_notifier updates block guest page
> faults. The primary benefit of this is the reduction in the likelihood
> of extreme latency when handling a page fault due to another thread
> having been preempted while modifying host virtual addresses.
> 
> v2 -> v3:
>   - Added patch to skip check for MMIO page faults
>   - Style changes
> 
> David Stevens (1):
>    KVM: x86/mmu: Consider the hva in mmu_notifier retry
> 
> Sean Christopherson (1):
>    KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
> 
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>   arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
>   arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
>   include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
>   virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
>   6 files changed, 65 insertions(+), 16 deletions(-)
> 

Queued, thanks.

Paolo

