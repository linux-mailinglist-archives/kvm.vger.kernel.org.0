Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49695D4AA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGBQtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:49:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36848 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBQtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:49:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so18672741wrs.3
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8PStjvboUT/+LsWfO344ZFdlV2FoYNdqOo4jKO0aLo=;
        b=dRICstsa6taA/9Loxp8BWy2TActeIqDi/xLhe6osK6T+mDiJ2yI/RplG4Q8j2APvai
         zp8liYnmLNV8s6XW8aaMuSA86muixSo/EkLQVoGg7DGAbI0lIhKqDW1sOY2Sm4NUlHtR
         euceMGAkkt9d6RMaGVjrKlqu1rQHS/bXB+gccqiwz8fdveIClLLrHSlCJt1zS/hpk2E8
         hQ+x1P1qyllIazaLguQaBOsDJvu+2KRxRhIP9HdlOY1tJo4Op+PodlNDgrvvss2hb2V9
         YCOVOsaI6rNeCgK/LFiFmxZPLkrXzHTr+yoZ2+Vt9p/e7VhWTY9T71lEim4MeCKRaP6D
         qCdg==
X-Gm-Message-State: APjAAAWUbCaXIzh23aX/pXuSkHW79+TixoojwfOduEP8dOiQX2gc/ezy
        gSGWaWQTvB1bGxKrgM9bpiiE1w==
X-Google-Smtp-Source: APXvYqwr+enPM4CfxjAPQwVlFShYpATWpOcix3c812+nWUEb4JvmVIMVWPpXgyeOAShcBDM5FO2KTw==
X-Received: by 2002:adf:efc8:: with SMTP id i8mr24861513wrp.220.1562086144142;
        Tue, 02 Jul 2019 09:49:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id j189sm3079828wmb.48.2019.07.02.09.49.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:49:01 -0700 (PDT)
Subject: Re: [PATCH v4 0/3] KVM: Yield to IPI target if necessary
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b42a3b4-91eb-4cc8-201a-8da0a944403a@redhat.com>
Date:   Tue, 2 Jul 2019 18:49:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/19 14:23, Wanpeng Li wrote:
> The idea is from Xen, when sending a call-function IPI-many to vCPUs, 
> yield if any of the IPI target vCPUs was preempted. 17% performance 
> increasement of ebizzy benchmark can be observed in an over-subscribe 
> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function 
> IPI-many since call-function is not easy to be trigged by userspace 
> workload).
> 
> v3 -> v4: 
>  * check map->phys_map[dest_id]
>  * more cleaner kvm_sched_yield()
> 
> v2 -> v3:
>  * add bounds-check on dest_id
> 
> v1 -> v2:
>  * check map is not NULL
>  * check map->phys_map[dest_id] is not NULL
>  * make kvm_sched_yield static
>  * change dest_id to unsinged long
> 
> Wanpeng Li (3):
>   KVM: X86: Yield to IPI target if necessary
>   KVM: X86: Implement PV sched yield hypercall
>   KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
> 
>  Documentation/virtual/kvm/cpuid.txt      |  4 ++++
>  Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h     |  1 +
>  arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
>  arch/x86/kvm/cpuid.c                     |  3 ++-
>  arch/x86/kvm/x86.c                       | 21 +++++++++++++++++++++
>  include/uapi/linux/kvm_para.h            |  1 +
>  7 files changed, 61 insertions(+), 1 deletion(-)
> 

Queued, thanks.

Paolo
