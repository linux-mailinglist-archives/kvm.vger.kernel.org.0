Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7E268FDBC
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 04:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjBIDKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 22:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjBIDJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 22:09:15 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DE84480;
        Wed,  8 Feb 2023 19:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675911978; x=1707447978;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=LChFhSwZctvjbXkbtwC+BkRg1S5d1LpCaibD0Vvio9k=;
  b=FXifKQV5Kv9qchiARj0sOtQZRykWU/8LQEoyPq1/RabVKKOHaVqncqvP
   +Z+51FzeUx1qqkFeTOBpQzIg1PuQsxl5frk4/UmvHKhhF7lTad5mAOxLf
   x/SfMpYjmznBjL67B7o60Ay3lAVeW2Rt+SqYBhQZFXUDnr89Y+1VMoDZu
   5rrDTufO7hsEE/HFEvlZx3W/N1g+JKopGWapaOCiMP4+9D0fwRkxhoj+a
   tYMNbbgwHCz+TSxDhwBDKeAPBPLsY+lsAMwurt2gPfuS6SlDgXXlPDoAE
   N9do0to7dwl9P/iAaAdPHTMvYBY3XiU/9TQoMlfD/BmRvkrJb1INyoYQ1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="331285339"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="331285339"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 19:06:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645098622"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645098622"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 19:06:11 -0800
Date:   Thu, 9 Feb 2023 11:06:10 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v7 5/9] x86/smpboot: Split up native_cpu_up into separate
 phases and document them
Message-ID: <20230209030610.mpnkr23hlvi2m37d@yy-desk-7060>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230207230436.2690891-6-usama.arif@bytedance.com>
 <20230208100336.mdnrvpsssa2sjodu@yy-desk-7060>
 <d0eeb5d0026ed0ecc12ea75b1e6cf03ee2ce068f.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0eeb5d0026ed0ecc12ea75b1e6cf03ee2ce068f.camel@infradead.org>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08, 2023 at 12:02:55PM +0000, David Woodhouse wrote:
> On Wed, 2023-02-08 at 18:03 +0800, Yuan Yao wrote:
> >
> > >   #endif
> > > +       /*
> > > +        * Sync point with do_wait_cpu_initialized(). On boot, all secondary
> > > +        * CPUs reach this stage after receiving INIT/SIPI from do_cpu_up()
> > > +        * in the x86/cpu:kick cpuhp stage. At the start of cpu_init() they
> > > +        * will wait for do_wait_cpu_initialized() to set their bit in
> > > +        * smp_callout_mask to release them.
> >
> > The last sentence of the comment looks confused. The fact is:
> >
> > For serial case, The BSP waits AP to set cpu_initialized_mask from
> > wait_for_master_cpu() after fired INIT/SIPI, then AP starts to wait
> > cpu_callout_mask set by BSP from do_boot_cpu().
> >
> > Or the comments below "Bringup step two:..." which also looks clear
> > enough then above.
>
>
> 	/*
> 	 * Sync point with do_wait_cpu_initialized(). Before proceeding through
> 	 * cpu_init(), the AP will call wait_for_master_cpu() which sets its
> 	 * bit in cpu_initialized_mask and then waits for the BSP to set its
> 	 * bit in cpu_callout_mask to release it.
> 	 */
> 	cpu_init_secondary();
>
>
> Better?

Yes, it's better to me, thanks.
