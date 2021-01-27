Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960AE306353
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhA0S3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 13:29:14 -0500
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:49964 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236548AbhA0S3M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 13:29:12 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 6E10F181D303A;
        Wed, 27 Jan 2021 18:28:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3868:3871:3872:4250:4321:5007:6119:6737:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12048:12296:12297:12438:12740:12895:13069:13161:13229:13311:13357:13439:13894:14659:14721:21080:21433:21451:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: ocean53_4812ee027599
X-Filterd-Recvd-Size: 2375
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Wed, 27 Jan 2021 18:28:27 +0000 (UTC)
Message-ID: <10805faed4d19ce842cef277b74479a883514afe.camel@perches.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add '__func__' in rmap_printk()
From:   Joe Perches <joe@perches.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephen Zhang <stephenzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Jan 2021 10:28:26 -0800
In-Reply-To: <854ee6dc-2299-3897-c4af-3f7058f195af@redhat.com>
References: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
         <244f1c7f-d6ca-bd7c-da5e-8da3bf8b5aee@redhat.com>
         <cfb3699fc03cff1e4c4ffe3c552dba7b7727fa09.camel@perches.com>
         <854ee6dc-2299-3897-c4af-3f7058f195af@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-01-27 at 19:23 +0100, Paolo Bonzini wrote:
> On 27/01/21 18:25, Joe Perches wrote:
> > 
> > -#ifdef MMU_DEBUG
> > -bool dbg = 0;
> > -module_param(dbg, bool, 0644);
> > -#endif
> > -
> >  #define PTE_PREFETCH_NUM		8
> >  
> > 
> >  #define PT32_LEVEL_BITS 10
> > @@ -844,17 +839,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
> >  	int i, count = 0;
> >  
> > 
> >  	if (!rmap_head->val) {
> > -		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
> > +		pr_debug("%p %llx 0->1\n", spte, *spte);
> >  		rmap_head->val = (unsigned long)spte;
> >  	} else if (!(rmap_head->val & 1)) {
> > -		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
> > +		pr_debug("%p %llx 1->many\n", spte, *spte);
> >  		desc = mmu_alloc_pte_list_desc(vcpu);
> 
> This would be extremely slow.  These messages are even too verbose for 
> tracepoints.

There's no real object change.

It's not enabled unless DEBUG is defined (and it's not enabled by default)
or CONFIG_DYNAMIC_DEBUG is enabled and then dynamic_debug jump points are
used when not enabled so I think any slowdown, even when dynamic_debug is
enabled is trivial. 


