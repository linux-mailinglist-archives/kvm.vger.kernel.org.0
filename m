Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A2C729460
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbjFIJJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 05:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241187AbjFIJHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 05:07:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421ED273A
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 02:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686301568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eyj9qAaMTXhV0BDBMXgw3bkhoC43Djt8OMEq06UECOo=;
        b=J3yT2iwsFwP30bfqSub+tJAIZRGoAZL7Kp7Z4uMIadSRMc8txt1116AM6etWkXt3surRDU
        3zjw8DF7P15WhGQrp4YwWycPYQOjgnym4ms7XxrRA6dAHlu+ngUvqY2rEGxv9fX2+AYkum
        3BEVjhkQ3f5JjYhloNci3xBIa8GaOd4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-D6WUN1w7MX24iXkiFaM-3w-1; Fri, 09 Jun 2023 05:06:06 -0400
X-MC-Unique: D6WUN1w7MX24iXkiFaM-3w-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-514a4c3ff90so1503714a12.2
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 02:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686301565; x=1688893565;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyj9qAaMTXhV0BDBMXgw3bkhoC43Djt8OMEq06UECOo=;
        b=dRRUvkC5YYIySGYkr4tGR9+JGk7vTMri0WIUhsBeTfkZMaXhGtaDSqnUWxotG1ViE0
         bFQdWzd3nYZ2oaeI83qq29sPuSW8O2IxO7MnH5CSALRLMYEKwLXjMPVGxAv3OW55vQXo
         Es22e8laZIwNKNF0+npFXgFO49AV+qNiMJzjAyhXQLrSGnV6K3AtLrPXYXOB0WvdxmRA
         4hrkdseijJcq+sh+NPgYKKvFxWNx5UvH9kk5h7jhuKjd2O0K97i0n67/cDX8n59j1q0d
         UBuALiWfLQEw5tn5UdoG0T5Te5t+NO1SJGbMX09Jhpa6alsM77qBC+6TC/Gv4QsQI5R0
         RajQ==
X-Gm-Message-State: AC+VfDwLQpEqqcPwkuA/dYcnUF04IApLt/KyrapJYEX32Fo9EcGykx/e
        bQG/eswNJK0/lmzLVqINl+Xvre+GJXPXNmuefo8hMObVsySEZK+Hr+UX3rdhnq97EcU9Z/pzxYV
        8vCR99FjBcpY7
X-Received: by 2002:a05:6402:643:b0:510:82b4:844d with SMTP id u3-20020a056402064300b0051082b4844dmr902468edx.2.1686301565420;
        Fri, 09 Jun 2023 02:06:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Eo2fL8sg8ZAFF9ExDb1hoz+RWsXilNiiceAqQ1jh6YF+h+q2Lb+V5P8mQdJn5E/+DPP6p2g==
X-Received: by 2002:a05:6402:643:b0:510:82b4:844d with SMTP id u3-20020a056402064300b0051082b4844dmr902445edx.2.1686301565157;
        Fri, 09 Jun 2023 02:06:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f9-20020a056402068900b0051495ce23absm1517006edy.10.2023.06.09.02.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 02:06:04 -0700 (PDT)
Message-ID: <f0fc6e43-ffe3-dc38-03c1-77b2105cd0fb@redhat.com>
Date:   Fri, 9 Jun 2023 11:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH mm-unstable v2 09/10] kvm/x86: add
 kvm_arch_test_clear_young()
Content-Language: en-US
To:     Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-10-yuzhao@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230526234435.662652-10-yuzhao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/27/23 01:44, Yu Zhao wrote:
> +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> +static inline bool kvm_arch_has_test_clear_young(void)
> +{
> +	return IS_ENABLED(CONFIG_X86_64) &&
> +	       (!IS_REACHABLE(CONFIG_KVM) || (tdp_mmu_enabled && shadow_accessed_mask));
> +}

I don't think you need IS_REACHABLE(CONFIG_KVM) here, it would be a bug 
if this is called from outside KVM code.

Maybe make it a BUILD_BUG_ON?

Paolo

