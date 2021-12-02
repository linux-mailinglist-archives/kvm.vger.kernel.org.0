Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A028146617F
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357014AbhLBKfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345364AbhLBKfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 05:35:03 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52202C06174A;
        Thu,  2 Dec 2021 02:31:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o20so113322176eds.10;
        Thu, 02 Dec 2021 02:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N6k1dm8k+AuxT/kkINJ2uWzQD41QhKsh8yex3G7gZCI=;
        b=G/KcWY4NdiSiLbGwFVbMpplGKklwuLS8kzHzGur5jlThpat8rYTmvJEuvKnby0ikS5
         iMXoT3JaN8/6uGdTfqTV64IRpBhuVbTwgoqPRIuAnlOPg4YXFHbD8LSvudKuqUlIFuXo
         1B6vYQLwbiH5PukJHZ2d+B/hG4wyhNqTRUH+WJYFxX/aAnWG5ofBg3HiNT96ZFyJ9nM8
         RMfYqLt3L+O6eWXJQeNtUQxDFA97RXOHZgU97mHvKCkbWJ/oRSQWohVhbpxKbOUFzh4K
         /WIYiCEYMqmZsjs0IaWV39/CdP/UEiDeWQkZevioyJUXTo+ileWjeLZdsdLPjDzl5ytc
         MDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N6k1dm8k+AuxT/kkINJ2uWzQD41QhKsh8yex3G7gZCI=;
        b=twvXtUdIwkILd2xrQxPd9DPruPJA0dpSSN3tSW2MwuSx3QBRkxX97vOLq1Ha28eEKm
         L78MWX0ObGBoo9H6MI0Sq2PSTITgP0BV0pUG9cHn24+MKTIXAqGV4Ke6O2amqRS2Z2nY
         IWSB6QBDmdOske8WwHnXmCKcMAQucr8t7h7a3DJUIl9LWcg8WjX8p41YjmCt/VXgLnt4
         MI5ARoPGw769IZgKyxQExoqEPA8IO8/kKwkkvSu/OPI0d75rDv8YyMwmPISwNE8aDENT
         LCiUXOJkDKNA/62eI6t0mcG0iE4XfcnLf/hwY4xLz70eCYPfI6Rlyx7fdow/bsA402Kx
         NjXw==
X-Gm-Message-State: AOAM530SX4EYKO9elhcLLD0QD7ZMWoUpEUyN0SzbJjbx0PJn/QGEH0jf
        d0ThYDvbcA+4l1KbZ/UR8Gg=
X-Google-Smtp-Source: ABdhPJwhpBxx1yFRODBtJrFnn3nCW7H/sTu+w+jLDDEQAemKg7xUPHKBK5f7DJw2WZKCGsUGKU9xRg==
X-Received: by 2002:a17:906:ce2a:: with SMTP id sd10mr14431289ejb.154.1638441099804;
        Thu, 02 Dec 2021 02:31:39 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id w5sm1912110edc.58.2021.12.02.02.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:31:39 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6200f141-8e6f-fe68-9539-22aa68559cb7@redhat.com>
Date:   Thu, 2 Dec 2021 11:31:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Wei Huang <wei.huang2@amd.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
 <YaUiEquKYi5eqWC0@google.com>
 <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
 <458c0819a578ba854f00089bc312c8faa177a81a.camel@redhat.com>
 <32eabe7d270e5a466ba2d9345b4270b8fe27700c.camel@redhat.com>
 <Yagoo7R8P5xVilsj@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yagoo7R8P5xVilsj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/21 03:00, Sean Christopherson wrote:
> Hmm, that suggests the bug/erratum is due to the CPU consuming stale data from #4
> for the IsRunning check in #5, or retiring uops for the IsRunning check before
> retiring the vIRR update.

Yes, this seems to be an error in the implementation of step 5.  In 
assembly, atomic operations have implicit memory barriers, but who knows 
what's going on in microcode.  So either it's the former, or something 
is going on that's specific to the microcode sequencer, or it's a more 
mundane implementation bug.

In any case, AVIC is disabled for now and will need a list of model 
where it works, so I'll go on and queue the first part of this series.

Paolo

> It would be helpful if the erratum actually provided
> info on the "highly specific and detailed set of internal timing conditions". :-/
> 
>    4. Lookup the vAPIC backing page address in the Physical APIC table using the
>       guest physical APIC ID as an index into the table.
>    5. For every valid destination:
>       - Atomically set the appropriate IRR bit in each of the destinations’ vAPIC
>         backing page.
>       - Check the IsRunning status of each destination.

