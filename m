Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C444D9D93
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349240AbiCOOal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349231AbiCOOae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:30:34 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD6D55226;
        Tue, 15 Mar 2022 07:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647354562; x=1678890562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/mS+54xXu2SFAlGhBp7YqEHtIogY0AEeVDsBdXLfN6M=;
  b=Jm403LWaisBLQzo8W1B1s1Hrsn7AL9bfhJrQdQ7tXSWv8EPu8H03bxbT
   apCGJYina4XuaClmMq3TShuzI7BmRVF21wv8YyozuJ/THYAJPo9wDktHW
   6n8patcuaansppEMLNgjOdzfX+qDUKtgLpEh3BRhYgsR3Y+IHJ91RjW9R
   JiUw8IAuzE0Vaa8Q+rGmMh/ZMypYLF+s84S+Vvll4mebrQeGSEqELq+Bk
   7OwZxFjr9nkU71vTZ9WTbFU5OHNu85S7WHjFzJDsQiftmwXhWQ3sF6OTk
   D4Rl5W+zmlxODOE5XefmSas433LN3rPLaLR6yQQk0mHwb040EfQpGtGIQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="317038755"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="317038755"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 07:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="556951856"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 07:29:19 -0700
Date:   Tue, 15 Mar 2022 22:42:50 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86: Trace all APICv inhibit changes and
 capture overall status
Message-ID: <20220315144249.GA5496@gao-cwp>
References: <20220311043517.17027-1-seanjc@google.com>
 <20220311043517.17027-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311043517.17027-4-seanjc@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 04:35:17AM +0000, Sean Christopherson wrote:
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -9053,15 +9053,29 @@ bool kvm_apicv_activated(struct kvm *kvm)
> }
> EXPORT_SYMBOL_GPL(kvm_apicv_activated);
> 
>+

stray newline.

>+static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
>+				       enum kvm_apicv_inhibit reason, bool set)
>+{
>+	if (set)
>+		__set_bit(reason, inhibits);
>+	else
>+		__clear_bit(reason, inhibits);
>+
>+	trace_kvm_apicv_inhibit_changed(reason, set, *inhibits);

Note that some calls may not toggle any bit. Do you want to log them?
I am afraid that a VM with many vCPUs may get a lot of traces that actually
doesn't change inhibits.

Anyway, this series looks good to me.
