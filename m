Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153D74FE938
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 22:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiDLUFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiDLUFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:05:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A373D4EDE1;
        Tue, 12 Apr 2022 12:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649793351; x=1681329351;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qpmveqwO7SyvzvBsb9MExzJEADb5MiyVxp91O/5Gxf8=;
  b=EdFe8w8CoPxH9UAJRPDTU4Q91omFzZ4MNvklV485ddSVOIviahl03nJJ
   HBp0V8JVr9sXaxIb5BxAU+E0sQ9Rb2RuVclttLxboNLPkP9lQ6/qqFhH9
   HhZKtT6feYGIBYSmbmGAZXV7ESoKLQsrjT8UPfsaf5r7iZBqIXEuSwySZ
   gp+R2c91h5rGz1nEO87hYIXfA8JTLEukR9Wnu6YtQ5mUXNyYRBbVKRad6
   qzhdQrf565xLLamjZSVg9B/2cmVfODbw2jZbwpjYXrEEdFc9WuE911rdv
   sVowzl7ieF9LZggDloTpRsxF3LOinaG7/9ufYdNB59CA9xpJa41iPF3KF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="325397924"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="325397924"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 12:55:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="526640026"
Received: from lpfafma-mobl.amr.corp.intel.com (HELO guptapa-desk) ([10.209.17.36])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 12:55:29 -0700
Date:   Tue, 12 Apr 2022 12:55:27 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] x86/tsx: fix KVM guest live migration for tsx=on
Message-ID: <20220412195527.xwpgk4mzyqccpqmo@guptapa-desk>
References: <20220411180131.5054-1-jon@nutanix.com>
 <20220411200703.48654-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220411200703.48654-1-jon@nutanix.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 04:07:01PM -0400, Jon Kohler wrote:
>Move automatic disablement for TSX microcode deprecation from tsx_init() to
>x86_get_tsx_auto_mode(), such that systems with tsx=on will continue to
>see the TSX CPU features (HLE, RTM) even on updated microcode.

This patch needs to be based on recent changes in TSX handling (due to
Feb 2022 microcode update). These patches were recently merged in tip
tree:

   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

Specifically these patches:

   x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits [1]
   x86/tsx: Disable TSX development mode at boot [2]

Thanks,
Pawan

[1] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=258f3b8c3210b03386e4ad92b4bd8652b5c1beb3
[2] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=400331f8ffa3bec5c561417e5eec6848464e9160
