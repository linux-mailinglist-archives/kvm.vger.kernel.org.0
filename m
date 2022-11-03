Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71B7617ECF
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiKCOEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiKCOD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 10:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA3619C36
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 07:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gp3ZE1TCS6qUf/W2wfyFuvz85/MTtwzsFfwWgQFj3ps=;
        b=XRImdzCdtJ7CTGDvtBbsgSVU4vrGEu7X3uPkV5STyu1mpS+Wnk++K2YrmPJZ7iDnmamXUU
        cyT88B+wkS/IjZUU5R+UbAm1K/uwqTiaKP2nS7BMz/3pQ+XpOcsJ2rOw7C+dw1PKDYIR/D
        eQ6HgpVWDinKym8WGH2CwKRq5zbaF4w=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-PYTn9gK-NwC79WVA969gjw-1; Thu, 03 Nov 2022 10:01:34 -0400
X-MC-Unique: PYTn9gK-NwC79WVA969gjw-1
Received: by mail-ej1-f72.google.com with SMTP id qw17-20020a1709066a1100b0078e25b6a52fso1321502ejc.3
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 07:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp3ZE1TCS6qUf/W2wfyFuvz85/MTtwzsFfwWgQFj3ps=;
        b=dwNvBH+q72OFhobsjK/0O01Zr3u9yei9nCQryzolPFzYnT5+ckR6CMa17jgmL8gQMx
         nYyEQaWS1OjL9eiOuhwpaufty1w/0qaknaQ0AIjbnUpMjkn67VRFbftUZrjyeb4KjQcI
         223nDZxfEAEgYUgR7QOGoWIx6OaQ/n8nZe+UiaoUYL1pdNOad2I34TwUUdhsaw9KoLLY
         DkV/uPMXyNkblavj/MVu9JLkQQQ0poKDu5G4m2noqmyGMU1tvWBuJTwmi75xd+4dAEmM
         D5RBeYHfvaOYCjQoiGBCRcHFpqZ/Fgi+6bWqV+b+xswVP5B0Ph1VjWw2n2KcXm8DQcLT
         3seA==
X-Gm-Message-State: ACrzQf3nk3MzPTT0uOj+5lXXTtpLhDiH4iy9XDrbWAMcfrwd8LUldT+q
        Q3vCy1iMtRpX3reYM/5Ehz3SL8uLqwCkLSeAvg+x0VA9cp3O565urYbA3zHvXxGBXA+d078hvml
        E2LftXGvjO+y5
X-Received: by 2002:a17:907:7e9e:b0:7ad:bc80:c003 with SMTP id qb30-20020a1709077e9e00b007adbc80c003mr25375072ejc.198.1667484089707;
        Thu, 03 Nov 2022 07:01:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM573p4EUrag9CU7KGeV5DPwqVdO4hG3cdn9PAejBOFdAvPNF2Pfj2lgSHDnk+0puoAwMgBkew==
X-Received: by 2002:a17:907:7e9e:b0:7ad:bc80:c003 with SMTP id qb30-20020a1709077e9e00b007adbc80c003mr25374580ejc.198.1667484084861;
        Thu, 03 Nov 2022 07:01:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id a7-20020a17090640c700b007305d408b3dsm532188ejk.78.2022.11.03.07.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:01:23 -0700 (PDT)
Message-ID: <d641088f-87d9-da77-7e98-92d1a9de6493@redhat.com>
Date:   Thu, 3 Nov 2022 15:01:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 10/44] KVM: VMX: Clean up eVMCS enabling if KVM
 initialization fails
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
 <20221102231911.3107438-11-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-11-seanjc@google.com>
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

On 11/3/22 00:18, Sean Christopherson wrote:
> +static void hv_cleanup_evmcs(void)

This needs to be __init.

Paolo

