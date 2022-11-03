Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00112618259
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiKCPSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiKCPSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:18:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B630B5FA2
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 08:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667488671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ayp5B1FtOoX/awXyyNk+Et491AUBiGcW44dxue5Nqxo=;
        b=NnzsIPyupvATdyaF9IEyPRNfTJLATkhDP2B009ncg6UCY08qtTWlpXJeoFkOAH2OhMsFrO
        f5Qa8W4pAQ6KD2czUXlrlYfNu/Ed3wgoncSyORnKOnbUlMBv9jnvhYBTM6J5v60te/XCD/
        eHgVVNjUa9UtkghQXKI4C7jDG3GOERc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-153-tjv91dLUMreuDyBviFOvkw-1; Thu, 03 Nov 2022 11:17:47 -0400
X-MC-Unique: tjv91dLUMreuDyBviFOvkw-1
Received: by mail-ej1-f70.google.com with SMTP id jg27-20020a170907971b00b007ad9892f5f6so1461784ejc.7
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 08:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ayp5B1FtOoX/awXyyNk+Et491AUBiGcW44dxue5Nqxo=;
        b=YvLapHFK0uspuOP7DvxQ4Y954gU5ofye95DjdUydxcfWmGWDGkc06tEoF1K5oBxOvq
         PSMTBWXVv+OxPyXZGo+utDW1ezfKMghWv4p46FDizuzPEH/kABMSJUh0mbtMbIm25ZR8
         X+ZLOPGyJ64CnckisRpvIPiLq3q7z5bcGdWcV+7tQH39uPPNKI1Y0x3AY6GObizQu85q
         eBJAgdAg823FTmfjE82Z6ki5pNzxpy22QhK5JLaxzfJdEnBLlzDKZYYjVIby+y3kjDGM
         X7KDcmwFQoY4Dk6MET5QpBg0Gai5ou4iMtJU26OqvhMmcNwKy8xlQLbvNNOF+94k03sZ
         jkdg==
X-Gm-Message-State: ACrzQf0G3/mMTtqpXtuftIp4vmZJkvSt3kGg0MA14C72GmT8Sbi1Key8
        86acbWt03knrQjuQ8Rku7q9+dNJ8aTGK8nXNzD1R9gdTr9hhjWR8KUlV5frxKNlrj8xNV4TrTe8
        od2iKrRtfCbj6
X-Received: by 2002:a05:6402:204d:b0:463:153d:6790 with SMTP id bc13-20020a056402204d00b00463153d6790mr27934875edb.293.1667488666687;
        Thu, 03 Nov 2022 08:17:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM630sytXvddVtAZaAJHdRqOOceHpoBMlPyO4dZ3HgeOBssiaNPhkaiASNbBs9VIOouVbrocUg==
X-Received: by 2002:a05:6402:204d:b0:463:153d:6790 with SMTP id bc13-20020a056402204d00b00463153d6790mr27934856edb.293.1667488666443;
        Thu, 03 Nov 2022 08:17:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id 1-20020a170906210100b007317f017e64sm595545ejt.134.2022.11.03.08.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:17:45 -0700 (PDT)
Message-ID: <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
Date:   Thu, 3 Nov 2022 16:17:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
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
 <20221102231911.3107438-37-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-37-seanjc@google.com>
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
> From: Chao Gao<chao.gao@intel.com>
> 
> Do compatibility checks when enabling hardware to effectively add
> compatibility checks when onlining a CPU.  Abort enabling, i.e. the
> online process, if the (hotplugged) CPU is incompatible with the known
> good setup.

This paragraph is not true with this patch being before "KVM: Rename and 
move CPUHP_AP_KVM_STARTING to ONLINE section".

Paolo

