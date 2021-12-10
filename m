Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1409E47032A
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 15:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbhLJO4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 09:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242413AbhLJO4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 09:56:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED71C061746;
        Fri, 10 Dec 2021 06:53:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z5so31395087edd.3;
        Fri, 10 Dec 2021 06:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZPopxfZRkg4NTOl+klIySl5FTmEnEGA7/rHJVRlm4p0=;
        b=axcBhrYY5F+b/7Id5o19CVMf16DlNK++Iv+QQkzI9Mnf7ZTRnJCaH9XidNQOFsOBwc
         KF/wXTKGrFlcXFR9QcXh0tmfQaqluH4DlsgXOrJpdK/LJQrYRJUCa1eRc6to96/IwV2B
         BlyqvjvgggseyLJ8qtFA8u7nkulUxlTbfdET3/IxAhjbM4n3l7+In1S5EkRZyqGZl5Ck
         wKgANnRzx+uuEJWvWG98rzsSbQ650jB+d4dvhyUIs42e58MDzXi1cDPbfAvmMlzdfpM0
         BOcEFYO9Tm6j84wjCz2oTA6sCdsavxKcq1hTPn1dIX2c8ATBFG3sdm+KRLTm8NvOgy5R
         pgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZPopxfZRkg4NTOl+klIySl5FTmEnEGA7/rHJVRlm4p0=;
        b=SbxbHLE3uYdfXgeU8fjzSZqDkoew4I0tD2KWedzOwfiakQkapGMne4tm6hA0MTOYvv
         kHmbpHmk7GnFZRIXrEQk5+ZL0t6QCdXtaOsvpCLr20ArT/DyxjWfGsjlKSFZ1m+iTRG2
         FPqrPidPdaGF5mkc826mIsyhKD8ceR7nMT95eqeg+t7uC7B0jt5qfXOc73XYSQhK/VdB
         j78KJoVixzSsYir9wrdm11MFRYQcRFkUqOFQJ/Qh5JnOHRa0UqbIuo6RugcO+CHIH/Dx
         gITPtL3rV4eG3CC8MTi/8u1BqhoDbdkI6u4C1QTQk0412mK5cewLMNoZZ2Z8GSndTT4Q
         M7NA==
X-Gm-Message-State: AOAM533xwC6h9LPQ3qFH6oifdsyvT17H9EwyBn5CVwY5BaoWDk/J+2Fl
        uw/h+mbtGUF2R/SGUhtVPQ8=
X-Google-Smtp-Source: ABdhPJzHeROj3HC5Sukl5Uto4GX2p0nJsKAKZ5t4nooil+qkn+wpDmJamxHHNUoZnQ1//006tmFgjQ==
X-Received: by 2002:a50:e003:: with SMTP id e3mr38840536edl.374.1639147986203;
        Fri, 10 Dec 2021 06:53:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id yc24sm1573561ejb.104.2021.12.10.06.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 06:53:05 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2d864e94-1bae-4cc2-7242-676ef102398f@redhat.com>
Date:   Fri, 10 Dec 2021 15:53:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 08/12] KVM: Reinstate gfn_to_pfn_cache with
 invalidation support
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-9-dwmw2@infradead.org>
 <b1bacc6f-be56-4108-6e52-4315a021184b@redhat.com>
 <b614d9ae0fe7910cfa72eee0b4077776f8012e5f.camel@infradead.org>
 <6cb2cd57-16f3-d0ec-adf6-cb8fdcbae035@redhat.com>
 <5d0a68cd0d06884a2a58338aace811144990f8f5.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5d0a68cd0d06884a2a58338aace811144990f8f5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 13:25, David Woodhouse wrote:
> On Thu, 2021-12-09 at 23:34 +0100, Paolo Bonzini wrote:
>>
>> Compared to the review it's missing this hunk:
>>
>> @@ -265,7 +265,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
>>
>>          gpc->valid = false;
>>
>> -       old_khva = gpc->khva;
>> +       old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
>>          old_dirty = gpc->dirty;
> 
> Do you know what? I couldn't bring myself to add that a second time. I
> managed it once, but it made me sad.
> 
> Did it like this instead:
> 
> -       old_khva = gpc->khva;
> +       old_khva = gpc->khva - offset_in_page(gpc->khva);

Very nice, and it would have deserved a macro in include/linux if there 
wasn't a decent way to write it.

> I checked that for me at least, GCC is clever enough to just do the
> mask.
> 
>          old_khva = gpc->khva - offset_in_page(gpc->khva);
>   131:   48 8b 43 78             mov    0x78(%rbx),%rax
>   135:   48 25 00 f0 ff ff       and    $0xfffffffffffff000,%rax
> 
> 
> I still don't see the previous patches in kvm/next — is that an
> automatic push after testing has passed, or is the kernel.org
> infrastructure just *really* slow?

No, it's me really wanting to send out the -rc5 pull request before the 
weekend.  Just wait five more minutes.

Paolo

> I've pushed based on the currently-visible kvm/next to
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xen-evtchn
> and can resend when the tree finally surfaces.
> 

