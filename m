Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC33660F35
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 14:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjAGNgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Jan 2023 08:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjAGNgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Jan 2023 08:36:36 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106A56087F
        for <kvm@vger.kernel.org>; Sat,  7 Jan 2023 05:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673098590; x=1704634590;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KnY6kNzXbYGUzQtnZ3X2N9rQaD5p10qJw8xRCE8j7Jo=;
  b=FC8kLtFPrJ0BwrqjnAprp7iZKsCtpsZflIgEusNIplbq7hoZLWjJZ9Du
   SgQqvy+GAYqzbAmseBNeMbwxQRTcOuczBaSgH8SSfNQN2l5Blsl9ZWSSx
   eWTF7A/3n75JtKYm104NhhxcDhhV9hWfu2SqjEbuJth/z5RwDhAdWAPKI
   43HNJhsamMC2KSWgVzLjRHBefnNOxSEJwX3SsR+oo+HYq61BTn2ickXU7
   oXUQt6gVdpcEUQc1NRme20OV04hgT8FrCs3grDN7iKCKH/7PMrifiLiaT
   xVM7ZCcZxUV4dvENObXRhU+rN1Dh7NPSrTHi9c5dWyX1d/fSr5864lJ9d
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="306155257"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="306155257"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2023 05:36:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="656211717"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="656211717"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 07 Jan 2023 05:36:28 -0800
Message-ID: <408ecbb7a8e844edf08a345d0a366dd8efb08220.camel@linux.intel.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: MMU: Rename get_cr3() --> get_pgd()
 and clear high bits for pgd
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Date:   Sat, 07 Jan 2023 21:36:27 +0800
In-Reply-To: <Y7jAjXcjDXlgAX+0@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-4-robert.hu@linux.intel.com>
         <Y7jAjXcjDXlgAX+0@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 00:45 +0000, Sean Christopherson wrote:
> On Fri, Dec 09, 2022, Robert Hoo wrote:
> > The get_cr3() is the implementation of kvm_mmu::get_guest_pgd(),
> > well, CR3
> > cannot be naturally equivalent to pgd, SDM says CR3 high bits are
> > reserved,
> > must be zero.
> > And now, with LAM feature's introduction, bit 61 ~ 62 are used.
> > So, rename get_cr3() --> get_pgd() to better indicate function
> > purpose and
> > in it, filtered out CR3 high bits.
> 
> Depends on one's interpreation of "PGD".  KVM says it's the full
> thing, e.g. the
> nEPT hook returns the full EPTP, not EP4TA (or EP5TA).  I don't think
> stripping
> bits in get_cr3() is the right approach, e.g. the user might want the
> full thing
> for comparison.  E.g. the PCID bits are left as is.
> 
> Changing get_cr3() but not nested_svm_get_tdp_cr3() and
> nested_ept_get_eptp() is
> also weird.
> 
> I think my preference would be to strip the LAM bits in the few
> places that want
> the physical address and keep get_cr3() as is.

OK, will do as this in next version. Thanks.

