Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD92475CAFE
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjGUPJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 11:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjGUPIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 11:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898AA30EC
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689952074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AtcGzkETEnO18qgeRoihrAkrVd5qbbNpgaZO4bjwaRo=;
        b=KhhHt3RGmU8jlcD2z8gBOAktAEUK7DKF0zlKCYJu/dhGwnJRm17f8wnVWDiDYjU9VlRO+t
        FjQhzThQiR5HtrHUNHa2jLLV9VPQ8/TNklnHIzPLGHyvr+XrCM8TTzeWtO+IKGIxZHWC1p
        s2yuL4O7fcD1Q4V+AxfR94odXiUJ85w=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-UVNPcumZOmyZuE24fQmrgw-1; Fri, 21 Jul 2023 11:07:52 -0400
X-MC-Unique: UVNPcumZOmyZuE24fQmrgw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4fb774de2d4so2062877e87.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689952067; x=1690556867;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AtcGzkETEnO18qgeRoihrAkrVd5qbbNpgaZO4bjwaRo=;
        b=fA0ECqSWBFvYj9W9nfK8ph9PyoXD1C1oPhciKZ30m+xIc/zEGXrNL9aycgN/DWF4H7
         iivfXDzhPaQQ+iupLkhe5Y17a3dHZuZLkktuWpFWdl5s4mZVyT64B6VH/ASYckQioiDx
         Fe559lU0AcuAAbjxaldRgwBThwZY4Jh2/KVyrejZaA8G1Cc/TImOMZNLaN7jRlp14bPJ
         Wf12JIM9ZAdwOqN/yh02PLjc7tRFV75UkjceexXRLyPPIyEobi6DFKAY+1MAPl+QPoP0
         6tD7iP52NwUIiV9HH6P0My9zrAxSVS+wZmPMXN5nSwKjo2hzLkRNwNC/WVcplH6ew0ZL
         iKTw==
X-Gm-Message-State: ABy/qLZI4/pUDf6a6w9h6uW903Iexm9sjyVy8AfL7G0iDtZThy8od1R+
        rbdanHVqpM3yVNvg9RFapXDfSdnUzn2wWzIJLMg6jHRZ/qhl3Fi7l9dMQNrut2p3pQgvJ9EWmT1
        Bw8C9zD2n9ibm
X-Received: by 2002:ac2:4191:0:b0:4f8:5ab0:68c4 with SMTP id z17-20020ac24191000000b004f85ab068c4mr1303814lfh.59.1689952067657;
        Fri, 21 Jul 2023 08:07:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGo8Pi+B+7hRHqSy6ClZ4oP94DPqHOZMbTIQ3rRFkaZiIFeWC2//bW1iNqq7vZ0rxNpIdgKag==
X-Received: by 2002:ac2:4191:0:b0:4f8:5ab0:68c4 with SMTP id z17-20020ac24191000000b004f85ab068c4mr1303798lfh.59.1689952067306;
        Fri, 21 Jul 2023 08:07:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p1-20020a056402074100b0051df5eefa20sm2257329edy.76.2023.07.21.08.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:07:46 -0700 (PDT)
Message-ID: <123035a3-9d0d-70be-9894-f89a84c7e8fd@redhat.com>
Date:   Fri, 21 Jul 2023 17:07:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 15/29] KVM: Drop superfluous
 __KVM_VCPU_MULTIPLE_ADDRESS_SPACE macro
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-16-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/23 01:44, Sean Christopherson wrote:
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 -
>   include/linux/kvm_host.h        | 2 +-
>   2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b87ff7b601fa..7a905e033932 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2105,7 +2105,6 @@ enum {
>   #define HF_SMM_MASK		(1 << 1)
>   #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
>   
> -# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
>   # define KVM_ADDRESS_SPACE_NUM 2
>   # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
>   # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0d1e2ee8ae7a..5839ef44e145 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -693,7 +693,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
>   #define KVM_MEM_SLOTS_NUM SHRT_MAX
>   #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
>   
> -#ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
> +#if KVM_ADDRESS_SPACE_NUM == 1
>   static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   {
>   	return 0;

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

