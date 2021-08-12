Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749733EA7C0
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbhHLPly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:41:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232854AbhHLPlx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 11:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628782887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wVAySSNkRIQjjk+QH2YkijF+uGWoxw5I4DLvZClTw1U=;
        b=D134bOSUHTTA0PBGBrfxeua3cjVaITA/aBeygqqG9zTT1sBhyUKi2w0KPInxk3bKwqOzda
        u1EV3dEohJvWbbo8vwT6klqVzAk0hvI/pwYaAxSyJm/zBxIB/ODa88m6P0j4NYOD9d2vrb
        uM+rN2JHSIrzqz2iA+75RisxeW/qbCg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-3VIAAxlDMoOIceqUscI0PA-1; Thu, 12 Aug 2021 11:41:26 -0400
X-MC-Unique: 3VIAAxlDMoOIceqUscI0PA-1
Received: by mail-ej1-f70.google.com with SMTP id v3-20020a1709063383b02905b4d1d1e27cso1970528eja.19
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 08:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wVAySSNkRIQjjk+QH2YkijF+uGWoxw5I4DLvZClTw1U=;
        b=kIHrz3zId3JFt817ySy8lCpZQ2qKKKMw+oHR3ibpKGjIsGfWhgJ+y3xxO9Z4GXUqRK
         me4UOHHW9Zu/Sm2AlFhHmsS+VIUeDTP0jSjWpGmCmoTBejk7C+29h+WzNKWBb3svArM/
         yczntWYzeN+dZq5Iyha0Tl3Hz1CRRFtO1Ih0YF2dIlOoxnB7gHxJpF1Uo+eKmM50VSqs
         XViSM8s8r+mmH25MEt74sSS1xlETTp1O/BdpSlOgpt/p7GIuCF5gkncW1wQR0HmBxl9i
         tmC6plD7/d6Zvtcm9ikgFjVL4H80DsjeD2u0OGbieM9dpRaNrmYNc5O4do7e73Plk6Ak
         IlEQ==
X-Gm-Message-State: AOAM531xt7pTw+dB8W6b94/BFC9HAW+mO7avs7LG6bKZfpGhXHA6fL58
        Sblr9s/tidx8jT3apEN8PMacysw+aUPP3Al/vw/otFf3BVH1BYm43+ZUpEFd4gxk494NVboGOCh
        SDuy20dlVF8ZL
X-Received: by 2002:a50:ef11:: with SMTP id m17mr6095914eds.233.1628782885025;
        Thu, 12 Aug 2021 08:41:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbkauFimraFjcUcxW/s5naeDzEHblJnwTGW5kN8SFMxVNVXXtWI2AkXQ1TgeG7maJbDTkRTw==
X-Received: by 2002:a50:ef11:: with SMTP id m17mr6095860eds.233.1628782884809;
        Thu, 12 Aug 2021 08:41:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s18sm988134ejh.12.2021.08.12.08.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:41:24 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a
 struct page pointer
To:     David Hildenbrand <david@redhat.com>,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org
References: <YRQcZqCWwVH8bCGc@google.com>
 <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
 <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d29447d4-a1b4-7f12-7bbc-8dc24cb38b72@redhat.com>
Date:   Thu, 12 Aug 2021 17:41:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 11:04, David Hildenbrand wrote:
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> But at the same time I wonder if we should just get rid of 
> CONFIG_KVM_S390_UCONTROL and consequently kvm_arch_vcpu_fault().
> 
> In practice CONFIG_KVM_S390_UCONTROL, is never enabled in any reasonable 
> kernel build and consequently it's never tested; further, exposing the 
> sie_block to user space allows user space to generate random SIE 
> validity intercepts.
> 
> CONFIG_KVM_S390_UCONTROL feels like something that should just be 
> maintained out of tree by someone who really needs to hack deep into hw 
> virtualization for testing purposes etc.

I have no preference either way.  It should definitely have selftests, 
but in x86 land there are some features that are not covered by QEMU and 
were nevertheless accepted upstream with selftests.

Paolo

