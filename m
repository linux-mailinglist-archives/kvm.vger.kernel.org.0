Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2311964DA34
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLOLYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLOLYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:24:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5D325C40;
        Thu, 15 Dec 2022 03:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671103481; x=1702639481;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sk05TJBYxeFVoRCCPj2x5WWLJ5Jlr2hqAJRQ0ac1xeE=;
  b=ZNsuF1tUdHRJ/IabaJ7HJI27N7N/JwPUxP8Bcmp8bJnHjBLGatm/puSk
   CEEVV5OldkU1GFAk/qCHFmlPqttqfJzWyDt8nT1g8BWAH3gD4sahGieGr
   cyC3hiE+TKB284S2tYPXjlrrVWWsg+XKulp36vCnP+Sys2ovE6ZRJmkin
   tZd6RLsUFgiqKoJOsj7tjZGnuk/R+K2wQdGtbOzMRL5mgsQGjKyHJ3FgV
   GQSyLFTKlCdlIZkN81AD9YT1ntvns5XLKLMky++sFEANvlbcGgRfkZvYS
   p18pXiYBuwoxspbxEIKuiReMm6FG9cRNlXSWULNYvqgCjdKogM62GvNl9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="317364870"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="317364870"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 03:24:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="756302337"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="756302337"
Received: from nye-mobl1.ccr.corp.intel.com (HELO localhost) ([10.255.28.30])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 03:24:39 -0800
Date:   Thu, 15 Dec 2022 19:24:36 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 0/4] KVM: nVMX: Fix 2nd exec controls override goofs
Message-ID: <20221215112436.2iqizpso5loeficn@linux.intel.com>
References: <20221213062306.667649-1-seanjc@google.com>
 <20221214030037.4qz6v6fvfx6of32n@linux.intel.com>
 <Y5pn2fYf5eHu8yCb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5pn2fYf5eHu8yCb@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 12:18:33AM +0000, Sean Christopherson wrote:
> > 
> > BTW, we may need another patch to remove the obsolete comments in
> > nested_vmx_setup_ctls_msrs():
> 
> Ouch, indeed.  Want to send a proper patch?  Or provide your SoB and I'll write
> a changelog?
> 
> The comment was added by commit 80154d77c922 ("KVM: VMX: cache secondary exec controls"),
> but arguably the below is the appropriate Fixes, as it's the commit that fixed the
> existing cases where KVM didn't enumerate supported-but-conditional controls.
> 
> Fixes: 6defc591846d ("KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS")
> 

Thanks a lot, Sean, especially for sharing the commit history.

And I just sent out a patch to fix it.

One question is about the process of small cleanup patches like
this: would it be better off to include the cleanup patches as
part of a larger submission, or is it OK to be sent seperately?

Previously I submitted some small patches(e.g. [1] & [2]) but
have not received any reply. So I am just wondering, maybe those
patches are too trivial and sometimes time-wasting for the reviewers?

Any suggestion? Thanks!

B.R.
Yu

[1]: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct mode
https://www.spinics.net/lists/kvm/msg297583.html
[2]: [PATCH v2 0/2] Cleanup VMFUNC handling in KVM. 
https://www.spinics.net/lists/kernel/msg4582139.html
