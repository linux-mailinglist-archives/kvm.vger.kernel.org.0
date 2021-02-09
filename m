Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471E4314727
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 04:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhBIDnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 22:43:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:44474 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhBIDjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 22:39:51 -0500
IronPort-SDR: FWSkOf6/tfAYd/UC2Nn++DrMOTWgNSeW9p3AigZnZGjav8eF2BYL1zrWEJcr/BouGM4gWHJV36
 D19/Oir7xdPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="169503536"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="169503536"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 19:33:25 -0800
IronPort-SDR: MLXNXSLOs5NonPdltpG54jRdOM0dLYdU7ndPMGyayNWH3GN9UGb1pJ9J/5xTk4hJqIbeDJ6HIG
 o5SfOnkWdeGA==
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="378409896"
Received: from liujiaq1-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.174.87])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 19:33:22 -0800
Date:   Tue, 9 Feb 2021 11:33:19 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH v2] KVM: x86/MMU: Do not check unsync status for root SP.
Message-ID: <20210209033319.w6nfb4s567zuly2c@linux.intel.com>
References: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
 <671ae214-22b9-1d89-75cb-0c6da5230988@redhat.com>
 <20210208134923.smtvzeonvwxzdlwn@linux.intel.com>
 <404bce5c-19ef-e103-7b68-5c81697d2a1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <404bce5c-19ef-e103-7b68-5c81697d2a1f@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 05:47:22PM +0100, Paolo Bonzini wrote:
> On 08/02/21 14:49, Yu Zhang wrote:
> > On Mon, Feb 08, 2021 at 12:36:57PM +0100, Paolo Bonzini wrote:
> > > On 07/02/21 13:22, Yu Zhang wrote:
> > > > In shadow page table, only leaf SPs may be marked as unsync.
> > > > And for non-leaf SPs, we use unsync_children to keep the number
> > > > of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
> > > > shall always be zero for the root SP, , hence no need to check
> > > > it. Instead, a warning inside mmu_sync_children() is added, in
> > > > case someone incorrectly used it.
> > > > 
> > > > Also, clarify the mmu_need_write_protect(), by moving the warning
> > > > into kvm_unsync_page().
> > > > 
> > > > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > This should really be more of a Co-developed-by, and there are a couple
> > > adjustments that could be made in the commit message.  I've queued the patch
> > > and I'll fix it up later.
> > 
> > Indeed. Thanks for the remind, and I'll pay attention in the future. :)
> 
> Also:
> 
> arch/x86/kvm/mmu/mmu.c: In function ‘mmu_sync_children’:
> arch/x86/kvm/mmu/mmu.c:2002:17: error: ‘sp’ is used uninitialized in this
> function [-Werror=uninitialized]
>   WARN_ON_ONCE(sp->unsync);

Oops. This is wrong. Should be WARN_ON_ONCE(parent->unsync);

> 
> so how was this tested?
> 

I ran access test in kvm-unit-test for previous version, which hasn't
this code(also in my local repo "enable_ept" was explicitly set to
0 in order to test the shadow mode). But I did not test this one. I'm
truely sorry for the negligence - even trying to compile should make
this happen!

Should we submit another version? Any suggestions on the test cases?

Thanks
Yu

> Paolo
> 
