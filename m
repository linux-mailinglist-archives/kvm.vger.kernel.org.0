Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108EB6180B0
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiKCPKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiKCPKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:10:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAD41C90A
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 08:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667488095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLzJVyRQvNMkBYTyqF+CAZ1OHQes3dhnjH8NkXHBEKk=;
        b=CY0XdSUNeD70Vl1nGxs1Lz+fnk0kusmK2S1UsPsNT8dLTmXjInbelY6+e3b5y7Ko5tIVIJ
        GjNatx/L9IwHA5zc6/OiTWykTS/bAEj8ZzaX1UXKPxhZ3sbJ8ZDVRaIEoUtDDguhIUMpHD
        qTYzz17K/R2E4/sKLw6Sj0PqzQp7mp8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-63-XyR1PU33NXa-Wqe14XhhEg-1; Thu, 03 Nov 2022 11:08:14 -0400
X-MC-Unique: XyR1PU33NXa-Wqe14XhhEg-1
Received: by mail-ej1-f69.google.com with SMTP id qb12-20020a1709077e8c00b007a6c5a23a30so1441545ejc.12
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 08:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MLzJVyRQvNMkBYTyqF+CAZ1OHQes3dhnjH8NkXHBEKk=;
        b=wuvW+GK3s+ZUd1ODWmcgx4J2o4a7LhLFP3TEcn/ZsSImza/RZTBP8C7tp0h8KHKtTI
         hMXsu4On/wpZz49gDly9Tw3MwB7PL+4hbLcAWz1rkhaGp2TFAZs1DFPV86Expwn9f6gf
         lmPoEQEQVku3Je7p+oskYqsFKXoUrPgZxNgsTSQs+jNe5PRStqIeMKSJjmYX4jGlN/CI
         hMQ3wcTvpc+HwqMQ0R3jrVwcleDeURyA7W6qbdJNwEODSznDdMyi+6J5alCSln2sVuxT
         Eri3ytHfNvgGv7RTGYgEd4cuISvvlpOW0eXIOLSoR6cgS5O5/iiu8KbVZ3YLemFzcW6n
         s2iA==
X-Gm-Message-State: ACrzQf1CbFiNXcl2mM6JJZJQk77PFDO3ih+ods0P+UT8BBAP6yE+rYw8
        JFWqWGtE9VQn0IiJp+Hs1K8m9zO/QGpQAIB/MInnajcBA5bcB2dI5O6N1plgXoCv9xEd8FZfCGi
        F3r3JyHjhhZSQ
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id fi14-20020a056402550e00b00456f79f2bedmr31117680edb.106.1667488092992;
        Thu, 03 Nov 2022 08:08:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ksX1XHskAylW8hRvHj1WJtzsGVm4o7GE4R3Qlz1mullFc3dI571812AyMzkQixxOznTrmOg==
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id fi14-20020a056402550e00b00456f79f2bedmr31117664edb.106.1667488092781;
        Thu, 03 Nov 2022 08:08:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id s28-20020a056402037c00b0045bccd8ab83sm646641edw.1.2022.11.03.08.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:08:11 -0700 (PDT)
Message-ID: <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
Date:   Thu, 3 Nov 2022 16:08:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
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
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-34-seanjc@google.com>
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

On 11/3/22 00:19, Sean Christopherson wrote:
> +	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> +	    !boot_cpu_has(X86_FEATURE_VMX)) {
> +		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
> +		return false;

I think the reference to the BIOS should remain in these messages and in 
svm.c (even though these days it's much less common for vendors to 
default to disabled virtualization in the system setup).

The check for X86_FEATURE_MSR_IA32_FEAT_CTL is not needed because 
init_ia32_feat_ctl() will clear X86_FEATURE_VMX if the rdmsr fail (and 
not set X86_FEATURE_MSR_IA32_FEAT_CTL).

Paolo

