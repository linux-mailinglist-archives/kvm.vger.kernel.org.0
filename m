Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03462100B3
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 22:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfD3UVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 16:21:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40486 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfD3UVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 16:21:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so22477301wre.7
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 13:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ceeJHtBSX1MGFU9AqEWWLclIY/g0BpWdLn7l5cHsF8k=;
        b=YzcPW/KPKYSOeNbw+Fvz8644+JslkkAZJw0BIht0bYTOSDaGq9I3brdEM2FvL4PxA5
         xT533nXRRneF4lEvRbt24ugeCepNe8n+ugt+pUmQh1dutJ/ne2+tJ1x3MhUZIZYEIs2G
         1Emzsdt5ssJRwciLO6avMbxLrb9+/jazgBaqF7zYNaUE/qRx/PRBexCpsaOm9diLLHDS
         KlKCcUv1XNj4GzvyQOK2p1tYsGE7M0EERVPqoy0vPoE7dYMeXRDhuYx1RCYG1BAnApZc
         RMNqAXv9li98/J478kaKHsvJyCaUgOa86uI5DGg9CktPeljoMocEbO1uoQqxwNa+PyL7
         XIFg==
X-Gm-Message-State: APjAAAVDRLiNWngynOWGhZBB7Z6JCj39i11Kz3EywRIvfXwSg5+X3hxc
        KCOMIv5sTw8FXGxPXiRYCJDqrA==
X-Google-Smtp-Source: APXvYqwTxAXUn7QjPin6Lc7zF8EdF/QJVAvEi0DbtZhFyzvdDKU9RPyk7JSRSnFlUTAz0oSe4AWr2Q==
X-Received: by 2002:adf:dc08:: with SMTP id t8mr43540656wri.220.1556655658538;
        Tue, 30 Apr 2019 13:20:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-62-245-115-84.net.upcbroadband.cz. [62.245.115.84])
        by smtp.gmail.com with ESMTPSA id r6sm3403663wmc.11.2019.04.30.13.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 13:20:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] x86/kvm/mmu: reset MMU context when 32-bit guest switches PAE
In-Reply-To: <20190430184229.GE32170@linux.intel.com>
References: <20190430173326.1956-1-vkuznets@redhat.com> <20190430184229.GE32170@linux.intel.com>
Date:   Tue, 30 Apr 2019 22:20:56 +0200
Message-ID: <87v9yv8ct3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Apr 30, 2019 at 07:33:26PM +0200, Vitaly Kuznetsov wrote:
>> Commit 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it
>> to 'gpte_size'") introduced a regression: 32-bit PAE guests stopped
>
> "gpte_is_8_bytes" is really confusing in this case. :-(  Unfortunately I
> can't think I can't think of a better name that isn't ridiculously verbose.
>
>> working. The issue appears to be: when guest switches (enables) PAE we need
>> to re-initialize MMU context (set context->root_level, do
>> reset_rsvds_bits_mask(), ...) but init_kvm_tdp_mmu() doesn't do that
>> because we threw away is_pae(vcpu) flag from mmu role. Restore it to
>> kvm_mmu_extended_role (as we now don't need it in base role) to fix
>> the issue.
>
> The change makes sense, but I'm amazed that there's a kernel that can
> actually trigger the bug.  The extended role tracks CR0.PG, so I'm pretty
> sure hitting this bug requires toggling CR4.PAE *while paging is enabled*.
> Which is legal, but crazy.  E.g. my 32-bit Linux VM runs fine with and
> without PAE enabled.

Once upon a time the was an operating system called "RHEL5". Some people
think it's long gone but you know, "no one's ever really gone" :-)

>
>> Fixes: 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it to 'gpte_size'")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks!

>
>> ---
>> - RFC: it was proven multiple times that mmu code is more complex than it
>>   appears (at least to me) :-)
>
> LOL, maybe you're just more optimistic than most people.  Every time I
> look at the code I say something along the lines of "holy $&*#".
>

:-)

>> ---
>>  arch/x86/include/asm/kvm_host.h | 1 +
>>  arch/x86/kvm/mmu.c              | 1 +
>>  2 files changed, 2 insertions(+)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index a9d03af34030..c79abe7ca093 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -295,6 +295,7 @@ union kvm_mmu_extended_role {
>>  		unsigned int valid:1;
>>  		unsigned int execonly:1;
>>  		unsigned int cr0_pg:1;
>> +		unsigned int cr4_pae:1;
>>  		unsigned int cr4_pse:1;
>>  		unsigned int cr4_pke:1;
>>  		unsigned int cr4_smap:1;
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index e10962dfc203..d9c7b45d231f 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4781,6 +4781,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
>>  	union kvm_mmu_extended_role ext = {0};
>>  
>>  	ext.cr0_pg = !!is_paging(vcpu);
>> +	ext.cr4_pae = !!is_pae(vcpu);
>
> This got me thinking, I wonder if we can/should leave the CR4 bits clear
> if !is_paging().  Technically I think we're unnecessarily purging the MMU
> when the guest is toggling CR4 bits with CR0.PG==0.

Yes, probably. Not sure I know any performance critical use-cases with
CR0.PG==0 but who knows, maybe running hundreds of 8086 emulators IS a
thing :-)

> And I think we can
> also git rid of the oddball nx flag in struct kvm_mmu.  I'll play around
> with the code and hopefully send a patch or two.
>
>>  	ext.cr4_smep = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
>>  	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
>>  	ext.cr4_pse = !!is_pse(vcpu);
>> -- 
>> 2.20.1
>> 

-- 
Vitaly
