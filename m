Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38E74C12B0
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbiBWMZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiBWMZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:25:24 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE7F9E57A;
        Wed, 23 Feb 2022 04:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645619097; x=1677155097;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zk0Q5i+bK10PCCeKqTaU8DiX28bSdfCtroqlbdMjIsw=;
  b=VzF59Pdw9GCOhByXXwRYpHoq2zlGY7fUAzbJJ9uDYQslGDcd5ZfVkTLa
   LK336AgK54bZjV4VedRmwWTjfAi8WfD1FBh336AdGAIk4UyH+1I1Bbxnj
   O5WzNC5pTSvTeQao3oUbtlqQInWlA81OoTPocUWCyRKPl1/L/uolRl9t9
   HJVBJYMvLzWwh6Lbr2oTPpn9gajLplY63YspJwQBa+TWx6MJnCtgxQ0kP
   zU+USK9A6zmP9FEdb+3ibx/7CTo09bQJFatKu4VZa0fqT2WP1va7b5RWW
   nO5HqVdAp1haNrQr7AGJ6NcRC3Phray8me+EuLc9Jl2ItlZHWiUshdBYU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="251686667"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="251686667"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 04:24:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="781813629"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 23 Feb 2022 04:24:51 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 1BB0B143; Wed, 23 Feb 2022 14:25:08 +0200 (EET)
Date:   Wed, 23 Feb 2022 15:25:08 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()
Message-ID: <20220223122508.3nvvz4b7fj2fsr2a@black.fi.intel.com>
References: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
 <20220223043528.2093214-1-brijesh.singh@amd.com>
 <YhYbLDTFLIksB/qp@zn.tnic>
 <20220223115539.pqk7624xku2qwhlu@black.fi.intel.com>
 <YhYkz7wMON1o64Ba@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhYkz7wMON1o64Ba@zn.tnic>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 01:13:03PM +0100, Borislav Petkov wrote:
> On Wed, Feb 23, 2022 at 02:55:39PM +0300, Kirill A. Shutemov wrote:
> > This operation can fail for TDX. We need to be able to return error code
> > here:
> > 	/* Notify hypervisor that we have successfully set/clr encryption attribute. */
> > 	if (!ret)
> > 		ret = x86_platform.guest.enc_status_change_finish(addr, numpages, enc);
> 
> bool to state failure/success or you need to return a specific value?

So far it is only success or failure. I used int and -EIO as failure.
bool is enough, but I don't see a reason not to use int.

-- 
 Kirill A. Shutemov
