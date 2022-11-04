Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD90761925A
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 09:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiKDIDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 04:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiKDIDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 04:03:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326626558
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 01:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667548958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJu1Z+r/Jj1Q22H/Z28kMZfifRbtSqoNatlqDbaYr8M=;
        b=Ht881+Jlk5g+JMhSSLNDUJyiPl1UFMFDxFF9LzjwLU9xxQgu9oKJvvXsOJj+Pzlzgrs21E
        J6OWFWTWg6jrvcXwWk8vnmUSA/DI3Gv4bwgJ5W2BUCe0SyMptQeSs7A7RaSLTJfhITqF2S
        C16Sm+gvNoncb4hATdNLsdRfOpIH/fg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-255-uG2Rb4l9PBOcCFO3kq5gpA-1; Fri, 04 Nov 2022 04:02:37 -0400
X-MC-Unique: uG2Rb4l9PBOcCFO3kq5gpA-1
Received: by mail-ed1-f72.google.com with SMTP id i17-20020a05640242d100b0044f18a5379aso2999166edc.21
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 01:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJu1Z+r/Jj1Q22H/Z28kMZfifRbtSqoNatlqDbaYr8M=;
        b=QL7K7oNtin2QQ/0hATwY2X+V9W31Dhb8UkIXlaRTqTr5xNV/ciPIvxoHkhKDQ67vqd
         Q7ffpaUbLHBhBntZVRQkz69aAggx/nNvnlfg1pCnrHw2SGvXThcjEVCubaQDcTrEEJn/
         w88sb8atHIRw0jbjUH9aHIcXPCROTCblONLHOXjmz8muFj5ZI+8IRuJvcnRZa0twoxN6
         bYmc2ysR2QBRUdc7cON4r6enKuyAZfuQ/iAyWAo4nwUG6fs9MUbfdy2Sk7YkTAbNuDlC
         mh+PA1GBwZntjRA87x/JvwoOsycGvqvH1LiLT/Z+FuBIqkBlA6JoZdTpxlIq8D44rVBp
         ZadA==
X-Gm-Message-State: ACrzQf0HQ+yQAgk3wWuQpJTzkPml04bSxC1dRqBJtgbjolroCjI21D0i
        BKT6waoM0n5QzxrFXNkqJnDl2VNcHvGUkMt5e/B2lA6nJtR2kFA3xC6f0bm/3gXMqzcrF/wjGtY
        TE0QhDiHBg4Ti
X-Received: by 2002:a17:907:1dda:b0:7a6:8ffc:7dc with SMTP id og26-20020a1709071dda00b007a68ffc07dcmr33677013ejc.163.1667548955855;
        Fri, 04 Nov 2022 01:02:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ZNqKb/aQP9ibAQb8G5uHFxFpKasjpH84kkwoGMwJiLbxjg9Lh2wolUrwViafofx0ss1frxA==
X-Received: by 2002:a17:907:1dda:b0:7a6:8ffc:7dc with SMTP id og26-20020a1709071dda00b007a68ffc07dcmr33676971ejc.163.1667548955613;
        Fri, 04 Nov 2022 01:02:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id tz14-20020a170907c78e00b0078ddb518a90sm1433630ejc.223.2022.11.04.01.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 01:02:34 -0700 (PDT)
Message-ID: <6c71fcca-c17f-5979-e15e-afcf08899064@redhat.com>
Date:   Fri, 4 Nov 2022 09:02:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
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
 <20221102231911.3107438-34-seanjc@google.com>
 <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
 <Y2QJ2TuyZImbFFvi@google.com>
 <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
 <Y2QPSK1/6esl61wQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2QPSK1/6esl61wQ@google.com>
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

On 11/3/22 19:58, Sean Christopherson wrote:
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 3e508f239098..ebe617ab0b37 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -191,6 +191,8 @@ static void default_init(struct cpuinfo_x86 *c)
>                          strcpy(c->x86_model_id, "386");
>          }
>   #endif
> +
> +       clear_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
>   }
>   
>   static const struct cpu_dev default_cpu = {

Not needed I think?  default_init does not call init_ia32_feat_ctl.

> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index c881bcafba7d..3a7ae67f5a5e 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -72,6 +72,8 @@ static const struct cpuid_dep cpuid_deps[] = {
>          { X86_FEATURE_AVX512_FP16,              X86_FEATURE_AVX512BW  },
>          { X86_FEATURE_ENQCMD,                   X86_FEATURE_XSAVES    },
>          { X86_FEATURE_PER_THREAD_MBA,           X86_FEATURE_MBA       },
> +       { X86_FEATURE_VMX,                      X86_FEATURE_MSR_IA32_FEAT_CTL         },
> +       { X86_FEATURE_SGX,                      X86_FEATURE_MSR_IA32_FEAT_CTL         },
>          { X86_FEATURE_SGX_LC,                   X86_FEATURE_SGX       },
>          { X86_FEATURE_SGX1,                     X86_FEATURE_SGX       },
>          { X86_FEATURE_SGX2,                     X86_FEATURE_SGX1      },
> 

Yes, good idea.

Paolo

