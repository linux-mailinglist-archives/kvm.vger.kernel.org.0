Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD8356987
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351068AbhDGKZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:25:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:42386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351008AbhDGKYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 06:24:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 28651B0B6;
        Wed,  7 Apr 2021 10:24:44 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:24:40 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] KVM: SVM: Allocate SEV command structures on
 local stack
Message-ID: <20210407102440.GA25732@zn.tnic>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-9-seanjc@google.com>
 <9df3b755-d71a-bfdf-8bee-f2cd2883ea2f@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9df3b755-d71a-bfdf-8bee-f2cd2883ea2f@csgroup.eu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First of all, I'd strongly suggest you trim your emails when you reply -
that would be much appreciated.

On Wed, Apr 07, 2021 at 07:24:54AM +0200, Christophe Leroy wrote:
> > @@ -258,7 +240,7 @@ static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
> >   static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >   {
> >   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > -	struct sev_data_launch_start *start;
> > +	struct sev_data_launch_start start;
> 
> struct sev_data_launch_start start = {0, 0, 0, 0, 0, 0, 0};

I don't know how this is any better than using memset...

Also, you can do

	... start = { };

which is certainly the only other alternative to memset, AFAIK.

But whatever you do, you need to look at the resulting asm the compiler
generates. So let's do that:

Your version:

# arch/x86/kvm/svm/sev.c:261:   struct sev_data_launch_start _tmp = {0, 0, 0, 0, 0, 0, 0};
        movq    $0, 104(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movq    $0, 112(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movq    $0, 120(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movq    $0, 128(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movl    $0, 136(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]


my version:

# arch/x86/kvm/svm/sev.c:261:   struct sev_data_launch_start _tmp = {};
        movq    $0, 104(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movq    $0, 112(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movq    $0, 120(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movq    $0, 128(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]
        movl    $0, 136(%rsp)   #, MEM[(struct sev_data_launch_start *)_561]


the memset version:

# arch/x86/kvm/svm/sev.c:269: 	memset(&_tmp, 0, sizeof(_tmp));
#NO_APP
	movq	$0, 104(%rsp)	#, MEM <char[1:36]> [(void *)_561]
	movq	$0, 112(%rsp)	#, MEM <char[1:36]> [(void *)_561]
	movq	$0, 120(%rsp)	#, MEM <char[1:36]> [(void *)_561]
	movq	$0, 128(%rsp)	#, MEM <char[1:36]> [(void *)_561]
	movl	$0, 136(%rsp)	#, MEM <char[1:36]> [(void *)_561]

Ok?

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
