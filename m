Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B47652F67
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 11:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiLUKZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 05:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiLUKYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 05:24:53 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA2F1AA2F
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 02:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671618173; x=1703154173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZNTpCizHBD214EMEQ0E+gVC2cI1L1EK7yrKlEP2cmcM=;
  b=KzwuzA7iiLkZ0ZbnKD3I974CnnfW1fNgZiQMLLP0+/xgs4iUSGBsP5A6
   n6VhQ3B9gfrflJM5AgGooqZuACcgqbez0bL0tO1six0PRiS18uYc0hgx2
   skza8eNDiJ+oDkmIg8LbvWlFs8hw2YHfJxb/qNzUBG6pAcxhW3nCpUBZU
   /0vssU2TNAJhcu0LxHMjiCzJt+Rs+x65EsQY/KQAD1awFgfg9POfkOZQc
   1iI58SwEqUZbe56QPV5Eqe0KCCavjR4fqN+6E78zIcEmtC/2fiEUJHiBg
   Ub12/aeyY0dg9NOKBgu4GO4/N3YzadC6AxQmbcRebTwFpkIibfFwEYyAW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="384186342"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="384186342"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:22:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="629073510"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="629073510"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:22:47 -0800
Date:   Wed, 21 Dec 2022 18:22:47 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221102247.kvl6tkgd7vqqvztn@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221221025527.jbsordepwfytdwmx@yy-desk-7060>
 <99219ca2f5b0fdb2daa825374235a0b05b74724f.camel@linux.intel.com>
 <20221221093543.hq6lws77hxihgdeo@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221093543.hq6lws77hxihgdeo@yy-desk-7060>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > >
> > > IIUC, LAM_47 userspace canonical checking rule requests "bit 63 ==
> > > bit 47 == 0"
> > > before sign-extened the address.
> > >
> > > if so looks it's guest's fault to not follow the LAM canonical
> > > checking rule,
> > > what's the behavior of such violation on bare metal, #GP ?
> >
> > Spec (ISE 10.2) doesn't mention a #GP for this case. IIUC, those
> > overlap bits are zeroed.
> 
> I mean the behavior of violation of "bit 63 == bit 47 == 0" rule,
> yes no words in ISE 10.2/3 describe the behavior of such violation
> case, but do you know more details of this or had some experiments
> on hardware/SIMIC ?

Yes, the ISE is vague. But I do believe a #GP will be generated for
such violation, and KVM shall inject one if guest does no follow the
requirement, because such check is called(by the spec) as a "modified
canonicality check".

Anyway, we'd better confirm with the spec owner, instead of making
assumptions by ourselves. :)

B.R.
Yu
