Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D3262EF68
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 09:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbiKRI3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 03:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241510AbiKRI2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 03:28:54 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243456D42;
        Fri, 18 Nov 2022 00:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668760125; x=1700296125;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pj4icQo/3SDwLzMdLGGF/AiqY6uFNaqQhgY/3+LxkaU=;
  b=hPHWrcaldjfcCkTcJX6Om1WYctwbWdBuP4YsK5tcZdjWaPQhGpnPUKPr
   TqfW6zLmUpHThJU4gV+V2cS4za6QfBPk8pUju+qlbitT39jSQHoJzfJYw
   1hwqNvJNhaRbXwyiw2gYesFVnFKkoBBfAAVxSd/4ayh2zqYKRMJ5aYJpe
   pfZFygwNYRLZ4LpL0ZeP+Cm5owDRR32dDbONQR6tmi2xDOrJaRkjyF5pa
   IkVg2tRuRfxhva7dTSyls2bRAPmNLm74YImu81jK3XLQG7i9L6q5RSZ5n
   AeEzwt5cgQOnhVmK7lrtua8pFjGxNrbkld9E+khVrFxku2CQHIyqVuufo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313098984"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="313098984"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 00:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="640133346"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="640133346"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 18 Nov 2022 00:28:42 -0800
Message-ID: <1f3522327e604e05b3e0d109cdbfded29db0244e.camel@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest
 has to retry
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com
Date:   Fri, 18 Nov 2022 16:28:41 +0800
In-Reply-To: <CALzav=dEmxV1wuNjuN2rzKsNunvwbdZWqr5K6KFZruEW=oYZSQ@mail.gmail.com>
References: <20221117161449.114086-1-pbonzini@redhat.com>
         <2b18a49dbe946bcbea29be13f5e0f03eacf75cdc.camel@linux.intel.com>
         <CALzav=dEmxV1wuNjuN2rzKsNunvwbdZWqr5K6KFZruEW=oYZSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-17 at 20:00 -0800, David Matlack wrote:
> On Thu, Nov 17, 2022 at 5:35 PM Robert Hoo <robert.hu@linux.intel.com
> > wrote:
> > 
> > On Thu, 2022-11-17 at 11:14 -0500, Paolo Bonzini wrote:
> > > +
> > >               if (fault->nx_huge_page_workaround_enabled)
> > >                       disallowed_hugepage_adjust(fault,
> > > iter.old_spte, iter.level);
> > > 
> > 
> > And here can also be improved, I think.
> > 
> >         tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1)
> > {
> > -               if (fault->nx_huge_page_workaround_enabled)
> > +               if (fault->huge_page_disallowed)
> > 
> > in the case of !fault->exec && fault-
> > >nx_huge_page_workaround_enabled,
> > huge page should be still allowed, shouldn't it?
> > 
> > If you agree, I can send out a patch for this. I've roughly tested
> > this, with an ordinary guest boot, works normally.
> 
> This check handles the case where a read or write fault occurs within
> a region that has already been split due to an NX huge page. 

By NX huge page split, the sub-sptes are installed, if my understanding
is right. So no fault should happen when next r/w access.

> If we
> recovered the NX Huge Page on such faults, the guest could end up
> continuously faulting on the same huge page (e.g. if writing to one
> page and executing from another within a GPA region backed by a huge
> page). So instead, NX Huge Page recovery is done periodically by a
> background thread.

Do you mean the kvm_nx_huge_page_recovery_worker() kthread? My
understanding is that it recycles SPs that was created by NX huge page
split. This would cause above fault happened, I guess, i.e. the
previously installed spte is zapped by the child SP recycled.

OK, understand you point now, if let r/w access fault of your mentioned
type skip disallowed_hugepage_adjust(), then it will break out and huge
page will be installed. Then next exec access will cause the huge page
split; then next r/w access fault will install a huge page again ... 
> 
> That being said, I'm not surprised you didn't encounter any issues
> when testing. Now that the TDP MMU fully splits NX Huge Pages on
> fault, such faults should be rare at best. Perhaps even impossible?

Possible, and not rare, I added debug info in
disallowed_hugepage_adjust() and showed hits.

> Hm, can we can drop the call to disallowed_hugepage_adjust()
> entirely?

I guess not, keep it as is. Though rare, even impossible, what if
is_nx_huge_page_enabled() changed during the run time? e.g. NX huge
page enabled --> disabled, give it a chance to restore huge page
mapping?

