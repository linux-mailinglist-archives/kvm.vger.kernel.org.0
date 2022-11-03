Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6496186C3
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiKCR7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiKCR7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:59:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8631CFC2
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667498290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqxXm7t2WOic9y4ISYxOwK8KmYTr1cBIHzcg/Vydbzs=;
        b=Fv4m4x93ZE/TxDVnoTusl9eGvaizUwcYQsEH3foi0+pOOHIrVnaYeaJeoigXrorOVO1dw1
        iwABt5FNCIPIMuf2lLaJiYMrgPDK7xygP+p7TVMXBSjpn+5Gog1dgjAR3u09PMA7fY5Dyd
        lqWKrnVAUDtThorizMsOm8k5T0thl/Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-WFVpQPZ2OLGTZDcJQxwU1A-1; Thu, 03 Nov 2022 13:58:01 -0400
X-MC-Unique: WFVpQPZ2OLGTZDcJQxwU1A-1
Received: by mail-ed1-f72.google.com with SMTP id t4-20020a056402524400b004620845ba7bso1889853edd.4
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 10:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yqxXm7t2WOic9y4ISYxOwK8KmYTr1cBIHzcg/Vydbzs=;
        b=epqvU+lZZFgCnsaQdIjUyEBl7nORVrSR9tzq9qg/YM/lx/d2rv+5Eg2ABMGO60+rjN
         dul4G7ypfAzoPBqgVOm0eb5kNzxu1Rll3k7wQNIxzYIBbWZN1d4sKghLyFdn52h1TLap
         sdowjhcMpaxXRnpn1ymgKslkkvY1ix11kcvqRXVgFlgOzrm5pS2eQQ2elMkyhpEqmfkW
         WKzRi57yOUvzSDEvPACGVwfga+3H7lG2WMDE45gynaKB/T+TdH8Xe6RYMGNY5OWctVvv
         xlxZJe1K+cqbIjTRPCTwBZ9R598Tp1AgRM3J1FhOoCU0FnE8rjK2RKGn4RBQHFqQqDhH
         VTUw==
X-Gm-Message-State: ACrzQf0sqcGrAaKMWcFPXXogzpOwxijUTaZVtk6o8iHioGLvikzJat8s
        iqz290Kn/boEi33dkS/eIeFs/7Y0HqAb21XwdFtzQqEmgBa45ybqLh5vjsaqxJGCMqkxWlcD/a+
        ql7KpHCBH0mcC
X-Received: by 2002:a17:907:a087:b0:7ad:a2ec:1afa with SMTP id hu7-20020a170907a08700b007ada2ec1afamr30061853ejc.151.1667498280031;
        Thu, 03 Nov 2022 10:58:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6QZmNq5hCph1jlllZl0PdTQdpFjKynjhfU4TqqXsTy2ri356CZrCrEtJkVH+I+gMfL+O9fNA==
X-Received: by 2002:a17:907:a087:b0:7ad:a2ec:1afa with SMTP id hu7-20020a170907a08700b007ada2ec1afamr30061831ejc.151.1667498279805;
        Thu, 03 Nov 2022 10:57:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id l3-20020a170907914300b0078d76ee7543sm734215ejs.222.2022.11.03.10.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 10:57:58 -0700 (PDT)
Message-ID: <1fd2e729-6e46-b0bf-d89e-f5d1b4dbde77@redhat.com>
Date:   Thu, 3 Nov 2022 18:57:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
 <Y2P+E+631c0TNcK7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2P+E+631c0TNcK7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 18:44, Sean Christopherson wrote:
>>> Do compatibility checks when enabling hardware to effectively add
>>> compatibility checks when onlining a CPU.  Abort enabling, i.e. the
>>> online process, if the (hotplugged) CPU is incompatible with the known
>>> good setup.
>>
>> This paragraph is not true with this patch being before "KVM: Rename and
>> move CPUHP_AP_KVM_STARTING to ONLINE section".
>
> Argh, good eyes.  Getting the ordering correct in this series has been quite the
> struggle.  Assuming there are no subtle dependencies between x86 and common KVM,
> the ordering should be something like this:

It's not a problem to keep the ordering in this v1, just fix the commit 
message like "Do compatibility checks when enabling hardware to 
effectively add compatibility checks on CPU hotplug.  For now KVM is 
using a STARTING hook, which makes it impossible to abort the hotplug if 
the new CPU is incompatible with the known good setup; switching to an 
ONLINE hook will fix this."

Paolo

>    KVM: Opt out of generic hardware enabling on s390 and PPC
>    KVM: Register syscore (suspend/resume) ops early in kvm_init()
>    KVM: x86: Do compatibility checks when onlining CPU
>    KVM: SVM: Check for SVM support in CPU compatibility checks
>    KVM: VMX: Shuffle support checks and hardware enabling code around
>    KVM: x86: Do VMX/SVM support checks directly in vendor code
>    KVM: x86: Unify pr_fmt to use module name for all KVM modules
>    KVM: x86: Use KBUILD_MODNAME to specify vendor module name
>    KVM: Make hardware_enable_failed a local variable in the "enable all" path
>    KVM: Use a per-CPU variable to track which CPUs have enabled virtualization
>    KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
>    KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
>    KVM: Disable CPU hotplug during hardware enabling
>    KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
>    KVM: Drop kvm_arch_check_processor_compat() hook
> 

