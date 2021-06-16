Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469313AA3AF
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhFPTCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 15:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbhFPTCV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 15:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623870014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+UP7OXvbFZ/sTV1fkRUmNAJIdvluY4AVuWJDrajb3uU=;
        b=FB1kh0zjMql3WImhLh+RMbD+yK99gGP/lZyDuclqgUTsSyq55pWWvcXgw1WAaMSdKxh5LL
        cYysflV+xyRMCnz78rs6JJ8ATD3YFbZUqaVNJLXu7dTmsTKlxpqly8gBugvzTvzsiqggRz
        Uilva98LGbmBx4OYPnuIKFBKxHRbpxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-GHAxmnqiNgifXzBvmXSZBg-1; Wed, 16 Jun 2021 15:00:01 -0400
X-MC-Unique: GHAxmnqiNgifXzBvmXSZBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BE07100CA8B;
        Wed, 16 Jun 2021 18:59:59 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4477560CC9;
        Wed, 16 Jun 2021 18:59:51 +0000 (UTC)
Message-ID: <1a6d4cc2152eebb5a0656e3718fc96645ee2e785.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix 32 bit build
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 16 Jun 2021 21:59:50 +0300
In-Reply-To: <YMof22ameZYUHNdi@google.com>
References: <20210616155032.1117176-1-mlevitsk@redhat.com>
         <YMof22ameZYUHNdi@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-16 at 15:59 +0000, Sean Christopherson wrote:
> On Wed, Jun 16, 2021, Maxim Levitsky wrote:
> > Now that kvm->stat.nx_lpage_splits is 64 bit, use DIV_ROUND_UP_ULL
> > when doing division.
> 
> I went the "cast to an unsigned long" route.  I prefer the cast approach because
> to_zap is also an unsigned long, i.e. using DIV_ROUND_UP_ULL() could look like a
> truncation bug.  In practice, nx_lpage_splits can't be more than an unsigned long
> so it's largely a moot point, I just like the more explicit "this is doing
> something odd".
> 
> https://lkml.kernel.org/r/20210615162905.2132937-1-seanjc@google.com
> 
> > Fixes: 7ee093d4f3f5 ("KVM: switch per-VM stats to u64")
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 720ceb0a1f5c..97372225f183 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6054,7 +6054,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
> >  	write_lock(&kvm->mmu_lock);
> >  
> >  	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> > -	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
> > +	to_zap = ratio ? DIV_ROUND_UP_ULL(kvm->stat.nx_lpage_splits, ratio) : 0;
> >  	for ( ; to_zap; --to_zap) {
> >  		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
> >  			break;
> > -- 
> > 2.26.3
> > 
Cool, makes sense.

I didn't notice your patch (I did look at the list but
since the subject didn't mention the build breakage I didn't notice).

I just wanted to send this patch to avoid someone else
spending time figuring it out.

Thanks,
Best regards,
	Maxim Levitsky

