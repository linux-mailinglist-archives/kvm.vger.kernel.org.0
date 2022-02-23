Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823CF4C1343
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240632AbiBWMyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiBWMyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:54:40 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CE091AE3;
        Wed, 23 Feb 2022 04:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645620853; x=1677156853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hh7zR6Pvu7wP8j5WrsKvOxqv9nPHKiPowFIoGx++A9Y=;
  b=fj+sO2ldKqKwX4UAl8Q2O10LXLjOV6M4dnZe4CkmeGLDuV9jFjg4MdDx
   ylGJo2FVxR6c5hT5N3mI+1VCE+QHZKNkSA7CFshCFgV2Zwb0qiwhY3LiB
   wY4JUksVYfA7vRbd5i4TlWB4QjzIxzzTYAaze3uz2DdH5Mvg50FFVyNtI
   tKv6qxoS6vytCQai662kcg7f/s/s7Vgoa5eUWafiqKYgHjCJ/Q/dDE93e
   fQkw6/2yUYFFGSYnqQ6+6ZJst20X5JkDwlcZ7SV0TMxbPaW4HltVTS2iq
   XUu2F3c7T+0+WwRj78TEvEsfRyZoegKQ/CU/M7NWhU8evx4/C+S0lxe4a
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="251690720"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="251690720"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 04:54:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="781871281"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 23 Feb 2022 04:54:08 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id D99DA143; Wed, 23 Feb 2022 14:54:24 +0200 (EET)
Date:   Wed, 23 Feb 2022 15:54:24 +0300
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
Message-ID: <20220223125424.ynwfqjejnzx3cdbw@black.fi.intel.com>
References: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
 <20220223043528.2093214-1-brijesh.singh@amd.com>
 <YhYbLDTFLIksB/qp@zn.tnic>
 <20220223115539.pqk7624xku2qwhlu@black.fi.intel.com>
 <YhYkz7wMON1o64Ba@zn.tnic>
 <20220223122508.3nvvz4b7fj2fsr2a@black.fi.intel.com>
 <YhYqqxaI08sOSPwP@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhYqqxaI08sOSPwP@zn.tnic>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 01:38:03PM +0100, Borislav Petkov wrote:
> On Wed, Feb 23, 2022 at 03:25:08PM +0300, Kirill A. Shutemov wrote:
> > So far it is only success or failure. I used int and -EIO as failure.
> > bool is enough, but I don't see a reason not to use int.
> 
> bool it is.
> 
> ---
> From 8855bca859d8768ac04bfcf5b4aeb9cf3c69295a Mon Sep 17 00:00:00 2001
> From: Brijesh Singh <brijesh.singh@amd.com>
> Date: Tue, 22 Feb 2022 22:35:28 -0600
> Subject: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()
> 
> The kernel provides infrastructure to set or clear the encryption mask
> from the pages for AMD SEV, but TDX requires few tweaks.
> 
> - TDX and SEV have different requirements to the cache and TLB
>   flushing.
> 
> - TDX has own routine to notify VMM about page encryption status change.
> 
> Modify __set_memory_enc_pgtable() and make it flexible enough to cover
> both AMD SEV and Intel TDX. The AMD-specific behavior is isolated in
> callback under x86_platform_cc. TDX will provide own version of the

"under x86_platform.guest"

> callbacks.
> 
>   [ bp: Beat into submission. ]
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://lore.kernel.org/r/20220223043528.2093214-1-brijesh.singh@amd.com

Otherwise, LGTM:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


-- 
 Kirill A. Shutemov
