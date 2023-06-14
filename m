Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D297472FBF1
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 13:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbjFNLJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 07:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjFNLIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 07:08:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66FDDF;
        Wed, 14 Jun 2023 04:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686740930; x=1718276930;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mm79erLzfDU1g9VPH5nKFTr67LEN6rYuyJAuFo/ZDXU=;
  b=eOstIn05Qcbx8d6mDDVtRvz11YWnxoCAuh3K8/HrzpT2f2XnnA0iRS3r
   ImepqkZzd2KuX2nQ5OHb5ck8vO64bEkoUCO0WUBMnrGYIg+T+MOiwwGgw
   JlRb7qhDuPJWCefzqOmGS/VxmtsI5E4fqhbfD3cjlpVXrOi0I3aQQyEi6
   NfFsvYwvY1ZS10Sl2e8Sook+oD7MMObDQdHA4h+E9uZ7oh9LFakD1Q5+5
   2PB3bA7GHx8qolYq0f/nByqxw+B3wp/TpU9DCVi5UjkzpeR6URjB89GIs
   l4NOTBYwwWzeglKrjLZV8Rkt65hZVg6fTUXoSmlH85rPye0tdc6gc3wkt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="386993008"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="386993008"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 04:08:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="741798491"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="741798491"
Received: from wlwpo-8.amr.corp.intel.com (HELO box.shutemov.name) ([10.251.211.89])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 04:08:38 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 7AC2910A069; Wed, 14 Jun 2023 14:08:21 +0300 (+03)
Date:   Wed, 14 Jun 2023 14:08:21 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230614110821.pf35kxd4vcwjjpb5@box>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <d3df3a9fa3075066558dd3bc84ef76ab3747185b.camel@intel.com>
 <20230614100245.3vehux365zou3ze6@box>
 <84dcc5ff896f487c95dc1602b627abef8d48432f.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84dcc5ff896f487c95dc1602b627abef8d48432f.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 10:58:13AM +0000, Huang, Kai wrote:
> > And the platform has to
> > handle erratum in BIOS to reset memory status on reboot anyway.
> 
> So "handle erratum in BIOS" I think you mean "warm reset" doesn't reset TDX
> private pages, and the BIOS needs to disable "warm reset".
> 
> IIUC this means the kernel needs to depend on specific BIOS setting to work
> normally, and IIUC the kernel even cannot be aware of this setting?
> 
> Should the kernel just reset all TDX private pages when erratum is present
> during reboot so the kernel doesn't depend on BIOS?

Kernel cannot really function if we don't trust BIOS to do its job. Kernel
depends on BIOS services anyway. We cannot try to handle everything in
kernel just in case BIOS drops the ball.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
