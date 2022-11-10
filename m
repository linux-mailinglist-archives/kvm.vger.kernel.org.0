Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B262434C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiKJNeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiKJNeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:34:16 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F24A29348
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668087255; x=1699623255;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LtPqHvmuWic76sbnvozsbBdlM1v91QAQMFuoC+fVIbg=;
  b=JHLXsT2DTr2EdTidt4txA/9HH/FWfaoqgscrxgquIccwG7PK+fGLEYuX
   EZ3QhjDmO+FTLRPFA+6OOwgPm1QEAo2/PKamQDt+0vbGtbFEbBFAsPdDK
   LEEAD9Iae/SFKp16dB1Ko46TggGfE3G9R1yDT4gIXk2gwOyNKpCt4b+6S
   yPpiNJRg6oeehsht1El38TNGFCFpZZ2AC+q9A6pv++benFdYu8xA1CM7h
   I44QKiXgJKnxx5cHSZj6OPo/p1j3g2S0FyH98KixagZARc4/01MWAOZkP
   vggflg5LWMXsBB086iEQX6zRVpiglxtzJlHbBhJuxqtg9gDBJw+22mJ5o
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="310021251"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="310021251"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:34:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="966409935"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="966409935"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 10 Nov 2022 05:34:14 -0800
Message-ID: <962e4c3181f2018cd139ea8709025ab8771a3a4a.camel@linux.intel.com>
Subject: Re: [PATCH v2 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com
Cc:     kvm@vger.kernel.org
Date:   Thu, 10 Nov 2022 21:34:13 +0800
In-Reply-To: <20221110132848.330793-9-robert.hu@linux.intel.com>
References: <20221110132848.330793-1-robert.hu@linux.intel.com>
         <20221110132848.330793-9-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-10 at 21:28 +0800, Robert Hoo wrote:
> When only changes LAM bits, ask next vcpu run to load mmu pgd, so
> that it
> will build new CR3 with LAM bits updates. No TLB flush needed on this
> case.
> When changes on effective addresses, no matter LAM bits changes or
> not, go
> through normal pgd update process.

Forgot to update commit message here. Should have removed "No TLB flush
needed on this case".

