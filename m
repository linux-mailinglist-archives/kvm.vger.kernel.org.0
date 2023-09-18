Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DA67A41A0
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbjIRG5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240051AbjIRG5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:57:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB4ED2
        for <kvm@vger.kernel.org>; Sun, 17 Sep 2023 23:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695020178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2mcwAczqQrH8FC4T+/52u6VelTTkFaOGAGOTHdcUPg=;
        b=LVFp946NjTAYtfFMFGvgzS+Yd69swf07fQIhh6FWhf6RjXjHBvATrXkB3ZjvN18m5CkNSj
        p+uJ9TKv/NWsby/ifnVURI1O+BCUQUDE3m5f0P1MnGPZYh0EwAk2GzJ96ZlpH5Cmu2EaHg
        kkUx/ORbgHD5mkbKb2OtCZiz8dEjYIw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-bmJZC2HMM-SMAeYSW6VgyA-1; Mon, 18 Sep 2023 02:56:13 -0400
X-MC-Unique: bmJZC2HMM-SMAeYSW6VgyA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-320bf1de0a6so550910f8f.3
        for <kvm@vger.kernel.org>; Sun, 17 Sep 2023 23:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695020172; x=1695624972;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2mcwAczqQrH8FC4T+/52u6VelTTkFaOGAGOTHdcUPg=;
        b=mnVXZIbDksR7P3OHCYJzMPZxTbFnI9n1pxIM+8/zptfPXiT847IvOs0c6z7L7UGRQl
         6nJwENxcjp2Wzp0jhmj9O1lnXh9cg4zcV86FO6sRykS1D9D3VcSPByj83+dwVBDpCMjc
         bm8Qr+ec7DgYXmqEyQhHKsNenLTLpK8jHNNSvYogVsm4pvhBzy/u7soDUgU4W/sWK6ID
         4fHoZqcQWllHgLsK2JUmODnTfq6Sr4r0HSGj9rxpkujKm46VsmqorfJmR2l61pYs3uNB
         aEmBuZScXchHZZMLhZR3ajYmMa8zH9vcJBz98EojQxMuNE/EvFvqw1kbo3SvHj2D84+/
         y7Pw==
X-Gm-Message-State: AOJu0YxulHLBv3D1PjdfEkBrXJO3EsTCqcYlJQaTfaaMMOmz1nH5cdix
        ButsuIrTsreXaYrbdWQJafiD8jwPGiFE/ySyheOvefsmr7Ompynw/mLoKUcZg+wTA8CBsLt+7gM
        Q1wwKoEam34zS
X-Received: by 2002:a5d:4c4a:0:b0:31f:8999:c409 with SMTP id n10-20020a5d4c4a000000b0031f8999c409mr6947622wrt.66.1695020172215;
        Sun, 17 Sep 2023 23:56:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6F/Z9q4tB58E26+mCTcb2TpjD2EEslfwOYb0HqPPBuG0zLaR6K3OsqOUHedxMDM3AqkpDEA==
X-Received: by 2002:a5d:4c4a:0:b0:31f:8999:c409 with SMTP id n10-20020a5d4c4a000000b0031f8999c409mr6947581wrt.66.1695020171900;
        Sun, 17 Sep 2023 23:56:11 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id t3-20020a05600001c300b003143b14848dsm11523936wrx.102.2023.09.17.23.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 23:56:11 -0700 (PDT)
Message-ID: <a6a77718-219f-30f6-b8de-acd7aadf3b0c@redhat.com>
Date:   Mon, 18 Sep 2023 08:56:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 18/26] KVM: s390: Stop adding virt/kvm to the arch include
 path
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-19-seanjc@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230916003118.2540661-19-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/2023 02.31, Sean Christopherson wrote:
> Don't add virt/kvm to KVM s390's include path, the headers in virt/kvm are
> intended to be used only by other code in virt/kvm, i.e. are "private" to
> the core KVM code.  It's not clear that s390 *ever* included a header from
> virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a x86's
> Makefile when s390 support was first added.
> 
> The only headers in virt/kvm at the time were the x86 specific ioapic.h,
> and iodev.h, neither of which shows up as an #include in the diff for the
> commit range 37817f2982d0f..e976a2b997fc4.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/s390/kvm/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index 02217fb4ae10..f17249ab2a72 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -5,7 +5,7 @@
>   
>   include $(srctree)/virt/kvm/Makefile.kvm
>   
> -ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
> +ccflags-y := -Iarch/s390/kvm
>   
>   kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>   kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o

Reviewed-by: Thomas Huth <thuth@redhat.com>

