Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF52646FEBC
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhLJKbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:31:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhLJKbP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 05:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639132059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVG9S7QFXKQmXdxA4E0LVfPojr/jyMhDEBcJlsGRzV4=;
        b=bp1VoEB1XBxHHGpxLUf02bZqjRO2KwRaaqpdS04WTVWum9YbuzSmcQX36fDvrwWR6Z+vSD
        IM86ZklpCckeF5D3UC179PQLXFTnkb+Ka1Tg7Pa8p5GvbBGGubN2wIQMAi74UPdRj/JI3D
        7nI4mJzRLWlZyqabxozHUZGloT7aJtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-334-K3jfAX1sO-W25NkmoL-Vww-1; Fri, 10 Dec 2021 05:27:36 -0500
X-MC-Unique: K3jfAX1sO-W25NkmoL-Vww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784391B2C980;
        Fri, 10 Dec 2021 10:27:35 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7839245D77;
        Fri, 10 Dec 2021 10:27:33 +0000 (UTC)
Message-ID: <e62a3f5f55159bc941360d489d8bffb2b0b716f9.camel@redhat.com>
Subject: Re: [RFC PATCH 0/6] KVM: X86: Add and use shadow page with level
 promoted or acting as pae_root
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 12:27:32 +0200
In-Reply-To: <20211210092508.7185-1-jiangshanlai@gmail.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-12-10 at 17:25 +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> (Request For Help for testing on AMD machine with 32 bit L1 hypervisor,
> see information below)
> 
> KVM handles root pages specially for these cases:
> 
> direct mmu (nonpaping for 32 bit guest):
> 	gCR0_PG=0
> shadow mmu (shadow paping for 32 bit guest):
> 	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0
> 	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1
> direct mmu (NPT for 32bit host):
> 	hEFER_LMA=0
> shadow nested NPT (for 32bit L1 hypervisor):
> 	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
> 	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1,hEFER_LMA=0
> 	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE={0|1},hEFER_LMA=1,hCR4_LA57={0|1}
> Shadow nested NPT for 64bit L1 hypervisor:
> 	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1
> 
> They are either using special roots or matched the condition 
> ((mmu->shadow_root_level > mmu->root_level) && !mm->direct_map)
> (refered as level promotion) or both.
> 
> All the cases are using special roots except the last one.
> Many cases are doing level promotion including the last one.
> 
> When special roots are used, the root page will not be backed by
> kvm_mmu_page.  So they must be treated specially, but not all places
> is considering this problem, and Sean is adding some code to check
> this special roots.
> 
> When level promotion, the kvm treats them silently always.
> 
> These treaments incur problems or complication, see the changelog
> of every patch.
> 
> These patches were made when I reviewed all the usage of shadow_root_level
> and root_level.  Some of them are sent and accepted.  Patch3-6 are too
> complicated so they had been held back.  Patch1 and patch2 were sent.
> Patch1 was rejected, but I think it is good.  Patch2 is said to be
> accepted, but it is not shown in the kvm/queue.  Patch3-6 conflicts
> with patch1,2 so patch1,2 are included here too.
> 
> Other reason that patch 3-6 were held back is that the patch 3-6 are
> not tested with shadow NPT cases listed above.  Because I don't have
> guest images can act as 32 bit L1 hypervisor, nor I can access to
> AMD machine with 5 level paging.  I'm a bit reluctant to ask for the
> resource, so I send the patches and wish someone test them and modify
> them.  At least, it provides some thinking and reveals problems of the
> existing code and of the AMD cases.
> ( *Request For Help* here.)
> 
> These patches have been tested with the all cases except the shadow-NPT
> cases, the code coverage is believed to be more than 95% (hundreds of
> code related to shadow-NPT are shoved, and be replaced with common
> role.pae_root and role.level_promoted code with only 8 line of code is
> added for shadow-NPT, only 2 line of code is not covered in my tests).
> 
> And Sean also found the problem of the last case listed above and asked
> questions in a reply[1] to one of my emails, I hope this patchset can
> be my reply to his questions about such complicated case.
> 
> If special roots are removed and PAE page is write-protected, there
> can be some more cleanups.
> 
> [1]: https://lore.kernel.org/lkml/YbFY533IT3XSIqAK@google.com/
> 
> Lai Jiangshan (6):
>   KVM: X86: Check root_level only in fast_pgd_switch()
>   KVM: X86: Walk shadow page starting with shadow_root_level
>   KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
>   KVM: X86: Introduce role.level_promoted
>   KVM: X86: Alloc pae_root shadow page
>   KVM: X86: Use level_promoted and pae_root shadow page for 32bit guests
> 
>  arch/x86/include/asm/kvm_host.h |   9 +-
>  arch/x86/kvm/mmu/mmu.c          | 440 ++++++++++----------------------
>  arch/x86/kvm/mmu/mmu_audit.c    |  26 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  15 +-
>  arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
>  5 files changed, 164 insertions(+), 333 deletions(-)
> 


I have 32 bit VM which can run an other 32 bit VM, and both it and the nested VM are using the mainline kernel).
I'll test this patch series soon.

I also have seabios hacked to use PAE instead of no paging, which I usually use for my 32 bit guests,
so I can make it switch to SMM+PAE paging mode to test it.

Best regards,
	Maxim Levitsky

