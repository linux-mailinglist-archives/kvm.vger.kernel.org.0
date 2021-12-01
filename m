Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1383F464404
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 01:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345850AbhLAAs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 19:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbhLAAsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 19:48:54 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AD2C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 16:45:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b13so16334374plg.2
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 16:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Kf3dJY8GPwWYOqVg1yioFOnjPyyMZfmzGUolejFBLo=;
        b=GzJvuVNUymMJaKqE/aSq7hriJHsPGnadqtCpf1KKoPgExneEVay2/MBrqMF7wjsk7d
         erFR8p/UqNDVi0KJI7MdfRNpXcNUDDUacSY8Ua+Exyw28bcRVXlusih+oXsp4whFjouH
         uF2oDSdz8+K87ZcjAFISJQTVWWdWwvPdQY+7zd2M2K5nTqYxCwBxju2TbP4ZKOtjYyMn
         nHWnxjTDH4i7pSC6Oo+8Nil5WPqWQu3hvDaHA3z05yujVLooexMNLlz2O7c8cswq/SK8
         QQ9wdLxCenShujpaTHo1ldqLmTqSeyXAfEbl+rOdpgRfSXz2i3exhJcgzwl6mRPMxuz7
         FUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Kf3dJY8GPwWYOqVg1yioFOnjPyyMZfmzGUolejFBLo=;
        b=CtPorKpTA82xx5NYpcubgPuffdgF2ghfp97U3wnWNM45UKVZiYe0VAKvtbUSEOGvzb
         ZjY0HcZKn0jRo2yRqETNuFNBYeqnIAPVxjFUcey3QyjGyFTQZkHYjdPNX6+uYBu24vz+
         GdWSCI6ucd1IDRokibltA1pNaSPTCRLwKcDB9+sq6E42HGOZuLozLVvu7KBMweef9rgT
         0bsiMsoWZs4t09r2TUMMKcBGX/RlLW1TUEh0GbzQa/eMIrQia7jgr8xC2GT6ExsNzDwV
         muIEplUAJ+Rtt+8oK5vexsPsdNa6CBT6EVxgUGnQ4kLNr9yyvZPBuF54owqJ39+JQbqg
         R8GA==
X-Gm-Message-State: AOAM5339c8b+JIBBFSJkf+lI1KKc2bM105jq+XpRuLOAeUR7Wd3DH9WH
        yRsVC+sWj9eRxWrJBi+7+Sj3/NsTUjY6yw==
X-Google-Smtp-Source: ABdhPJwjxFZzwZRWNLMKO6NzurAnM3It8gcnZiGGIy0vrcm7I/GrEdsQHDgqN+MC7fI/T188GQnUOA==
X-Received: by 2002:a17:90a:28c4:: with SMTP id f62mr3075202pjd.207.1638319533546;
        Tue, 30 Nov 2021 16:45:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f2sm23928821pfe.132.2021.11.30.16.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:45:32 -0800 (PST)
Date:   Wed, 1 Dec 2021 00:45:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
Message-ID: <YabFqf0fZqe9RZii@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-7-dmatlack@google.com>
 <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
 <CALzav=d59jLY6CNL9U8_Lh_pe-BviL_oKZGCAhJcnKxGGAMF6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d59jLY6CNL9U8_Lh_pe-BviL_oKZGCAhJcnKxGGAMF6g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, David Matlack wrote:
> > I have a similar patch for the old MMU, but it was also replacing
> > shadow_root_level with shadow_root_role.  I'll see if I can adapt it to
> > the TDP MMU, since the shadow_root_role is obviously the same for both.
> 
> While I was writing this patch it got me wondering if we can do an
> even more general refactor and replace root_hpa and shadow_root_level
> with a pointer to the root kvm_mmu_page struct. But I didn't get a
> chance to look into it further.

For TDP MUU, yes, as root_hpa == __pa(sp->spt) in all cases.  For the legacy/full
MMU, not without additional refactoring since root_hpa doesn't point at a kvm_mmu_page
when KVM shadows a non-paging guest with PAE paging (uses pae_root), or when KVM
shadows nested NPT and the guest is using fewer paging levels that the host (uses
pml5_root or pml4_root).

	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
		mmu->root_hpa = __pa(mmu->pml5_root);
	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
		mmu->root_hpa = __pa(mmu->pml4_root);
	else
		mmu->root_hpa = __pa(mmu->pae_root);

That's definitely a solvable problem, e.g. it wouldn't be a problem to burn a few
kvm_mmu_page for the special root.  The biggest issue is probably the sheer amount
of code that would need to be updated.  I do think it would be a good change, but
I think we'd want to do it in a release that isn't expected to have many other MMU
changes.

shadow_root_level can also be replaced by mmu_role.base.level.  I've never bothered
to do the replacement because there's zero memory savings and it would undoubtedly
take me some time to retrain my brain :-)
