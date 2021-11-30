Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCFA463288
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhK3Lmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbhK3Lmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:42:45 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33CCC061574;
        Tue, 30 Nov 2021 03:39:25 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l25so85213600eda.11;
        Tue, 30 Nov 2021 03:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=yGHiGFZ+rE1fvnI8baTnrP2jm+L8strqrdJ5iul7hp0=;
        b=c6P0wlF3uxLM9zmSs2xQkvwdYDteITQrAo0DrsrznSF9sEOH28QP1fFa6xhItTgTpS
         KkU6+3vbY7zvYbaGplUg6NAOHI1i7wZaB3YsPHKiJwSv7fAraYSJOmBsIPcxDa1GRc0A
         PiiJWBQEcwSH6cUNsH7cKZjAdxgXOazBahtafC3Gs9rh9Srzhdp4SMH53zgHkiQE4Got
         FG3pFo/MwoBD/bEwOxiDmocGqSzd1aaMmn3Q9da/d+qNqxzu9ZAjjXwyK04+bd+g1kuu
         faXB8tkRVfsTXc+ZCCEjhbpUn7X9sEvfPMvPv6y6fB24K84rc8fMZl0EoSsfLlnsoaMi
         6+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=yGHiGFZ+rE1fvnI8baTnrP2jm+L8strqrdJ5iul7hp0=;
        b=bJy6NaXQDh8ADM4mg/f3KrhI2h6hI8fQ/SibQuRqj93AqLrM4BFNfoLXnLUt57miJn
         AGSSKlJNdRpR4RS8eZD9wahB07qkNHjSH2bOYoqKcbQ5Wka1ioc+4UFRvx9vWvYM9KEO
         ++BoqJpUVBx/jfbED7RG8m/QYNNNRRJ1jAQnSlXDOwaClnG8BasQomzDAFTfyFRLQebL
         g1I7f8hmW7UbvHdAZq5feMglLAEMk1iTodWuKXL7gbaQdBCapJlxJXlPD+PmP3CHhwjF
         rr8Uo5UObnqyhZmWZmyDtA2BLM0DiXiyL0tMFLmBkrgJQrmuqQk2W+NUo/NHQblB6a8D
         zKsw==
X-Gm-Message-State: AOAM532nuLURkpatoS9eCqvjAQ/Pr9FVpH9VK4vP2Swex00tufDvtNL/
        Z2r1l70J8+0hSAt+0CkJ7iY=
X-Google-Smtp-Source: ABdhPJzBmlKlxbZEZjGdZkld9KClqoQPE65iifbnAftOVfFURI+3gCywK4yL4F/szmL3PzOccPRpRg==
X-Received: by 2002:a17:906:6a1a:: with SMTP id qw26mr67292465ejc.489.1638272364301;
        Tue, 30 Nov 2021 03:39:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m22sm11049796eda.97.2021.11.30.03.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 03:39:23 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3490c50e-50d2-f906-3383-b87e14b14fab@redhat.com>
Date:   Tue, 30 Nov 2021 12:39:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
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
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-11-seanjc@google.com>
 <9236e715-c471-e1c8-6117-6f37b908a6bd@redhat.com>
 <875ytjbxpq.wl-maz@kernel.org>
 <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
In-Reply-To: <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/21 18:12, Paolo Bonzini wrote:
> On 26/10/21 17:41, Marc Zyngier wrote:
>>> This needs a word on why kvm_psci_vcpu_suspend does not need the
>>> hooks.  Or it needs to be changed to also use kvm_vcpu_wfi in the PSCI
>>> code, I don't know.
>>>
>>> Marc, can you review and/or advise?
>> I was looking at that over the weekend, and that's a pre-existing
>> bug. I would have addressed it independently, but it looks like you
>> already have queued the patch.
> 
> I have "queued" it, but that's just my queue - it's not on kernel.org 
> and it's not going to be in 5.16, at least not in the first batch.
> 
> There's plenty of time for me to rebase on top of a fix, if you want to 
> send the fix through your kvm-arm pull request.  Just Cc me so that I 
> understand what's going on.

Since a month has passed and I didn't see anything related in the 
KVM-ARM pull requests, I am going to queue this patch.  Any conflicts 
can be resolved through a kvmarm->kvm merge of either a topic branch or 
a tag that is destined to 5.16.

Paolo

