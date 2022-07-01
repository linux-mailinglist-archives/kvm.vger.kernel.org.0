Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4754563259
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiGALMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiGALMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:12:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ACE4504F;
        Fri,  1 Jul 2022 04:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656673968; x=1688209968;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=o7ju9Q6I6a/+9wnyKZO0Nv5h/bgOz4726PmJJyWflEo=;
  b=N/n3EYcUaWBN6ob40NNKAQEYgxeLoKAqUTFoAYYat7/kgWXqcvDoVTbB
   0vkGk4fnHjyiLhedFPL++XVF9RMTtcdOCx9p0UFtNntCDNt5yOALxMRmU
   exF9a5YVH7ZjBhHPtLnsc4gRrp3pCDc0Q9lkySlGhpdmL2VGnu/XpVNiL
   PjuqQfQ9oG4BNLbz4dnG+LbHKVWRzes4ecsfoshew66LUppCZfbmqAqIw
   c9LNQPvB5pA5xzCLzpgUjj5IThDt6AEtkcTfJHw+GPTNtkoeqcghc5fGU
   L4GqBAZRm2ze1QaQFudSBjUmRFZ0o2Ps7b+olzQ/AK/bGW1EwYHL+E+po
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283728006"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="283728006"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 04:12:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="734023651"
Received: from sanketpa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.86.143])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 04:12:46 -0700
Message-ID: <41fb3e95a9635757a79e73e38ecc3c7b3a37fd8d.camel@intel.com>
Subject: Re: [PATCH v7 044/102] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 01 Jul 2022 23:12:44 +1200
In-Reply-To: <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> For private GPA, CPU refers a private page table whose contents are
> encrypted.  The dedicated APIs to operate on it (e.g. updating/reading it=
s
> PTE entry) are used and their cost is expensive.
>=20
> When KVM resolves KVM page fault, it walks the page tables.  To reuse the
> existing KVM MMU code and mitigate the heavy cost to directly walk
> encrypted private page table, allocate a more page to mirror the existing
> KVM page table. =C2=A0Resolve KVM page fault with the existing code, and =
do
> additional operations necessary for the mirrored private page table.  To
> distinguish such cases, the existing KVM page table is called a shared pa=
ge
> table (i.e. no mirrored private page table), and the KVM page table with
> mirrored private page table is called a private page table.  The
> relationship is depicted below.
>=20
> Add private pointer to struct kvm_mmu_page for mirrored private page tabl=
e
> and add helper functions to allocate/initialize/free a mirrored private
> page table page.  Also, add helper functions to check if a given
> kvm_mmu_page is private.  The later patch introduces hooks to operate on
> the mirrored private page table.
>=20
>               KVM page fault                     |
>                      |                           |
>                      V                           |
>         -------------+----------                 |
>         |                      |                 |
>         V                      V                 |
>      shared GPA           private GPA            |
>         |                      |                 |
>         V                      V                 |
>  CPU/KVM shared PT root  KVM private PT root     |  CPU private PT root
>         |                      |                 |           |
>         V                      V                 |           V
>      shared PT            private PT <----mirror----> mirrored private PT
>         |                      |                 |           |
>         |                      \-----------------+------\    |
>         |                                        |      |    |
>         V                                        |      V    V
>   shared guest page                              |    private guest page
>                                                  |
>                            non-encrypted memory  |    encrypted memory
>                                                  |
> PT: page table
>=20
> Both CPU and KVM refer to CPU/KVM shared page table.  Private page table
> is used only by KVM.  CPU refers to mirrored private page table.

Shouldn't the private page table maintained by KVM be "mirrored private PT"=
?

To me "mirrored" normally implies it is fake, or backup which isn't actuall=
y
used.  But here "mirrored private PT" is actually used by hardware.

And to me, "CPU and KVM" above are confusing.  For instance, "Both CPU and =
KVM
refer to CPU/KVM shared page table" took me at least one minute to understa=
nd,
with the help from the diagram -- otherwise I won't be able to understand.

I guess you can just say somewhere:

1) Shared PT is visible to KVM and it is used by CPU;
1) Private PT is used by CPU but it is invisible to KVM;
2) Mirrored private PT is visible to KVM but not used by CPU.  It is used t=
o
mirror the actual private PT which is used by CPU.


[...]

> +
> +static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp, void=
 *private_sp)
> +{
> +	sp->private_sp =3D private_sp;
> +}
>=20

[...]

> @@ -295,6 +297,7 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, =
tdp_ptep_t sptep,
>  	sp->gfn =3D gfn;
>  	sp->ptep =3D sptep;
>  	sp->tdp_mmu_page =3D true;
> +	kvm_mmu_init_private_sp(sp);

Can this even compile?  Unless I am seeing mistakenly, kvm_mmu_init_private=
_sp()
(see above) has two arguments..

Please make sure each patch can at least compile and doesn't cause warning.=
..

--=20
Thanks,
-Kai


