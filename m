Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E233B07F0
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhFVOyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 10:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhFVOyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 10:54:22 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39E9C061574;
        Tue, 22 Jun 2021 07:52:05 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G8TrK4rByz9sRf;
        Wed, 23 Jun 2021 00:52:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1624373522;
        bh=SVtmLGZR9lhjmGlAVYs+m0Yd4tc3JZtrT8YuTPZ2oug=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ic+xiL7PNffQ36MhT6Lr8b/XgkLIRK9sXhatVB2LOw6PL7QxwFiVCXXRDLsbtQWdj
         q7iu0HUGdMtXDmTHCRgtPC5kv357aqsqhsKmgYXk9u7JGci4w8hX1x0Bef6GB67R2p
         fwkeUi8TMPN0+nj+vbsaQetK7FnaV7oADCrES01nowucP9yMgHjazZw5O4x52doq+m
         bsgMRSYkyuTWpAJPDnGZFAgECe2K+aILH4UW+rwKOIqLLBS/TQxxRXDqwXbf8Y97MG
         OqxvPil8LEWM6m+FguQdNnsQIO041ZfkHDPbZUXcT5PSgPVl9/Dhyifwno5nyLzq3e
         IMVhPgGBU/nHQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        KVM <kvm@vger.kernel.org>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: linux-next: manual merge of the kvm tree with the powerpc tree
In-Reply-To: <9c2dbe56-4c64-0032-0acb-2e2925c7a2ab@redhat.com>
References: <20210622152544.74e01567@canb.auug.org.au>
 <9c2dbe56-4c64-0032-0acb-2e2925c7a2ab@redhat.com>
Date:   Wed, 23 Jun 2021 00:51:58 +1000
Message-ID: <871r8u2bqp.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 22/06/21 07:25, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Today's linux-next merge of the kvm tree got a conflict in:
>> 
>>    include/uapi/linux/kvm.h
>> 
>> between commit:
>> 
>>    9bb4a6f38fd4 ("KVM: PPC: Book3S HV: Add KVM_CAP_PPC_RPT_INVALIDATE capability")
>> 
>> from the powerpc tree and commits:
>> 
>>    644f706719f0 ("KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID")
>>    6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
>>    0dbb11230437 ("KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall")
>> 
>> from the kvm tree.
>> 
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.
>> 
>
> What are the dependencies of these KVM patches on patches from the bare 
> metal trees,

I don't think there's actually a semantic dependency on my tree, but
there's multiple textual conflicts with my tree. That series has to go
via both trees, or there will be conflicts.

> ... and can you guys *please* start using topic branches?
>
> I've been asking you for literally years, but this is the first time I 
> remember that Linus will have to resolve conflicts in uAPI changes and 
> it is *not* acceptable.

The patches are in a topic branch, which I will ask you to pull before
the merge window, in order to resolve any conflicts.

> Please drop the patches at 
> https://www.spinics.net/lists/kvm-ppc/msg18666.html from the powerpc 
> tree, and merge them through either the kvm-powerpc or kvm trees.

The kvm-ppc tree is not taking patches at the moment.

But it doesn't matter anyway, this series needs to be merged into my
tree and the KVM tree regardless.

The topic branch is here:

  https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/log/?h=topic/ppc-kvm


The commit Stephen mentioned has been rebased since to squash in a fix.
But what is in the topic branch is now final, I won't rebase what's
there.

cheers
