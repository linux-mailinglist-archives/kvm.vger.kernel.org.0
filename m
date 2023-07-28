Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF98F766868
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 11:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbjG1JMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 05:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbjG1JMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 05:12:23 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBAA2736;
        Fri, 28 Jul 2023 02:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690535402; x=1722071402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rqk2T5QIInIjCc2H4aYC47SdXPaqVKq+CdMnqIdBEvM=;
  b=aHJLItSn07CMGRfNKE9HLBC4GgOBnPn0V0tXwqWztn6VUQFMqz2ol2p8
   45X5JdtXIVW7GcZnI0ZJ4+dK0Yk3gbMSg3JX2nCeh+tFPSkPNvzIjzLho
   z1IwxcZnWsP2gVrP/KZ4rQopGFej6ftvhbX5J0u2juib6eBd7nozKqwtr
   ovRk0po9IDkpAExySD5cZJHme9sfR8Sl6SgBhC5FPU9tAk0FCmZ4LzE/A
   EBKkRg9wVj6FFx4mT1QHOXDKzOJfc1HDLGXjB+U8Om3jG7G5xcs/v2cAN
   C23tRqBbfHuxTRajATQN3GaOzhO4lsRPGsCgoz5InLFsqmKk1pO4/k1q/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="353454147"
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="353454147"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2023 02:09:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="851120209"
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="851120209"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2023 02:09:56 -0700
Date:   Fri, 28 Jul 2023 17:08:03 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v4 10/19] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
Message-ID: <ZMOFc+RfSuc5I+XB@yilunxu-OptiPlex-7050>
References: <20230721201859.2307736-1-seanjc@google.com>
 <20230721201859.2307736-11-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721201859.2307736-11-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-07-21 at 13:18:50 -0700, Sean Christopherson wrote:
> Now that VMX is disabled in emergencies via the virt callbacks, move the
> VMXOFF helpers into KVM, the only remaining user.

Not sure if it's too early to mention.

Intel TDX Connect could be a future user, it is the TDX extension for
device security. 

TDX uses SEAMCALL to interact with TDX Module, and SEAMCALL execution
requires VMXON. This is also true for TDX Connect. But TDX Connect
covers more controls out of KVM scope, like PCI IDE, SPDM, IOMMU.
IOW, other driver modules may use SEAMCALLs and in turn use VMXON/OFF
for TDX Connect.

I'm wondering if then we should again move VMXON/OFF helpers back to
virtext.h

Or, could we just keep vmxoff unchanged now?

Thanks,
Yilun
