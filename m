Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4E74625D4
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhK2Wn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhK2WnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:43:18 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFFCC203968;
        Mon, 29 Nov 2021 11:18:55 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id l25so76130772eda.11;
        Mon, 29 Nov 2021 11:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b6e11+CJLAryPIw/7DDSWmANxwHaOEFVgPmI0eD1ehw=;
        b=Yv9EDK6h14i2Dbj+iAIYK0HlvK2JERVyMLo4AC4eEaaM5uGAacc8HtxG8w/Y/N1eKa
         zoqVyYrJgoymLJ79VszdPFvZOcROHF7XsZML04k5ATYUCAQQQYdmRFM1zliBw5sA+fUR
         rGCOh7Dkwc25orqYcXeHYn5++zj+NoIkUF+txgA7cbkgTIdSaLJPMhb1GiDwryyn0Wfc
         MU5Gbh+ysqRcMgmq6XO0rBfKo/INnGwUPA9nBrqjSM7nJ1s+plFGQd3Vr5vlky9IMZdn
         wkdyjWJAJzkiJ+6yukZdQ5xwMk5wTjTGyWuy1lXhP9nJ6WRZVyGbloAAqLRFAE+sHa2m
         tnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b6e11+CJLAryPIw/7DDSWmANxwHaOEFVgPmI0eD1ehw=;
        b=SLP5O1d7fkwxL+83NBeKa4ZhuHfdQtripEi5FgV/ql2UwS7HJCKA9BbyMMptW9HGAA
         k98Iu139eSUf0Gq3C+ffm5HQC63D/r3zLxCvfL5R9VnQw8zBTYKXUGh0pcToYJek2qDn
         GUcn+BWDEqjHYboiuqLSr92RGt78Iz+/0UKGyToa6sUWaUzvhntT6NjAIKOD8Fp4De0D
         gyXp7Wxx/f3PUPMH1JFIXXstY4KMRYmE9qrxocj52Q0JOrzsnDqWspXlvPzdTMeDnHxD
         EH9qVyJITsyn54CyUBoFki1XjuQHkxvNbyfTfmOouFSZyTDqVvcmVayq2F1qyOXJ4kgL
         qTyA==
X-Gm-Message-State: AOAM5338hzw0w5OtfifO4qWh0FzeyQ5HPjltl/I633k8EQb3NTyC+5Ik
        KOFKWMIR6NPdAsbzMOellLE=
X-Google-Smtp-Source: ABdhPJx2YJ0juUfs4Yk6vuSEcojrZsOKQtVYCvzwUVoRUJT0twH/9lzRN0MjKMCkmooXwTOepr8KsQ==
X-Received: by 2002:a17:906:c9d2:: with SMTP id hk18mr4315253ejb.523.1638213533689;
        Mon, 29 Nov 2021 11:18:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id ch28sm9615535edb.72.2021.11.29.11.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 11:18:53 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
Date:   Mon, 29 Nov 2021 20:18:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
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
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
 <YaUiEquKYi5eqWC0@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUiEquKYi5eqWC0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 19:55, Sean Christopherson wrote:
>> Still it does seem to be a race that happens when IS_RUNNING=true but
>> vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to
>> trigger because it moves IS_RUNNING=false later.
> 
> Oh!  Any chance the bug only repros with preemption enabled?  That would explain
> why I don't see problems, I'm pretty sure I've only run AVIC with a PREEMPT=n.

Me too.

> svm_vcpu_{un}blocking() are called with preemption enabled, and avic_set_running()
> passes in vcpu->cpu.  If the vCPU is preempted and scheduled in on a different CPU,
> avic_vcpu_load() will overwrite the vCPU's entry with the wrong CPU info.

That would make a lot of sense.  avic_vcpu_load() can handle 
svm->avic_is_running = false, but avic_set_running still needs its body 
wrapped by preempt_disable/preempt_enable.

Fedora's kernel is CONFIG_PREEMPT_VOLUNTARY, but I know Maxim uses his 
own build so it would not surprise me if he used CONFIG_PREEMPT=y.

Paolo
