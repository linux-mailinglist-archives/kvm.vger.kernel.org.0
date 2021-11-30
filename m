Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39155463B3A
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 17:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbhK3QLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 11:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243677AbhK3QLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 11:11:25 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61182C061757;
        Tue, 30 Nov 2021 08:07:49 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso19937380wms.3;
        Tue, 30 Nov 2021 08:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3a/iKsjufsiAbrGQuBxVCPIZkwax7Upszpd7LsuYfCk=;
        b=ZI1KOydZ+qECl1hqlo+ZNsiRXNRPZ13T8K4/YJ6MoYcN5dN+LuRV3/IQ1KEUDcU0Vw
         Vjwuujw+ZbUsGVxN5Eebh9Z/n26MQhlQ8ehFqn4X/Hvewkjsw0COQl31001ZyKeNY6Mz
         nuTJWwgKAs8576y3o//cH27vL1awmnJNNBybZbxu9KQow1/gfFg/9iui3rvWtw7fesoJ
         uB58hek4VV+WXZz0jg3T4XAAPkiLiwUG82CWXZnawo+wiwrKp8M/XU1sqUquvCA81ibB
         cUgcgGRDa/rJerB9C4tYdPDW2u0xS9fOOZeboK+o+lFF3SNVDw/1NfjIHFtj7/tD9ggY
         AZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3a/iKsjufsiAbrGQuBxVCPIZkwax7Upszpd7LsuYfCk=;
        b=iGKGBL2bKj0s0qj+KzC1NpusPpvVp+EHB+cA1KEchyQMPLH7OHCYwwDc8VPUDoLZ2a
         8ngwre1MCAYxB6OkOHgxOzkQREba1F4WVDJ9arvG/N0nEJxigfM9JD7K3RSsA18bWOk3
         tzzVzIcvWxPSHlBOFTu9EnNHTuTzv7WZ2d8YPWzb5vUlQOpcqK61dIC7VUd/NFfVo07e
         oCiJLIunN1ZUOugMQ4AVkku+Mj1QuiaBcSyifBTKo00ciIzoPznbxdTDrdDrXcFtnx19
         sO4WsVE6j+Z9oN61k84LGzpsc60tP49jDm0uuihQBYeZw6vv10ByHJDE/GBRLewZhCWg
         zeMg==
X-Gm-Message-State: AOAM5320CuEJNaoLdDl4AssCgYNASqKactXgSa6CzY0NiorueH9y6CSM
        QsqWPrqMM+cs/T5Y+xdDa+k=
X-Google-Smtp-Source: ABdhPJx5Dhy4cMIe37LwwIVlRqxg9qfG8bQ1tYjpplU8k4zyM3CqmxKNVQMvmem1SJ3HAhFFd8xyTQ==
X-Received: by 2002:a05:600c:3489:: with SMTP id a9mr411960wmq.120.1638288467956;
        Tue, 30 Nov 2021 08:07:47 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id m36sm3269698wms.25.2021.11.30.08.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 08:07:47 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3f5adff7-f321-0688-c817-84975ebd3d14@redhat.com>
Date:   Tue, 30 Nov 2021 17:07:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
Content-Language: en-US
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
 <3490c50e-50d2-f906-3383-b87e14b14fab@redhat.com>
 <4826a7e2dbecc5d57323d18d725d6d69@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4826a7e2dbecc5d57323d18d725d6d69@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 13:04, Marc Zyngier wrote:
>>>
>>> I have "queued" it, but that's just my queue - it's not on kernel.org 
>>> and it's not going to be in 5.16, at least not in the first batch.
>>>
>>> There's plenty of time for me to rebase on top of a fix, if you want 
>>> to send the fix through your kvm-arm pull request.  Just Cc me so 
>>> that I understand what's going on.
>>
>> Since a month has passed and I didn't see anything related in the
>> KVM-ARM pull requests, I am going to queue this patch.  Any conflicts
>> can be resolved through a kvmarm->kvm merge of either a topic branch
>> or a tag that is destined to 5.16.
> 
> Can you at least spell out *when* this will land?

It will be in kvm/next as soon as I finish running tests on it, which 
may take a couple more days because I'm updating my machines to newer 
operating systems.

> There is, in general, a certain lack of clarity about what you are queuing,
> where you are queuing it, and what release it targets.

Ok, thanks for the suggestion.  Generally speaking:

- kvm/master is stuff that is merged and will be in the next -rc, right 
now 5.16-rc4.  It shouldn't ever rewind (though it may happen, it is rare)

- kvm/next is stuff that is merged and will be in the next merge window, 
right now 5.17.  It also shouldn't rewind.

- kvm/queue is stuff that the submitter shouldn't care about, and that 
other people should only care about to check for conflicts.  When I say 
I "queued" a patch it goes in kvm/queue, and there's time to remove it 
if something breaks.

Regarding this series:

- I am queuing it up to this patch

- I am queuing it to kvm/next, meaning it targets 5.17

- it looks like the next one (11/43) triggers a known AMD errata, so I'm 
holding on the rest until we understand if it actually does, and if so 
if AMD AVIC is doomed.  For the time being, it will stay in kvm/queue.

Paolo
