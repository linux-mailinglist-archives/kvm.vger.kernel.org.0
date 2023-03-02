Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F616A834E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 14:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCBNQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 08:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCBNQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 08:16:51 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BB0C65D
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 05:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677763008; x=1709299008;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=avQNsoatqzKHp2CeiFsnJJYOVmXZeFmvotesWSNaHK4=;
  b=DVDoEnntZPJdlPya+kmPhXwGKu2FAMLgUYixN5vOlTannJD27lxbkinf
   50cKsp4xUxQz3pyKxMt/iUmnWyxAnCxNqcSo0zJ8wWLOjAT9CepXm9bi3
   f0iMfwoxpwvYVixeFrOZr13tCmVXNg0ZgPKZsi1nk6SXRJX+/Q/FaP60H
   XCKzVZEBKzAqmSHsVZCnWW/zk9wpfosD/j6QZcLt3euhkq1l3twStkmi1
   U5VV9jMwpOKbYfvzUJM+bVhqR65fqItGA11cWziXISgiUcxb96w8khQnr
   kqymqRXxSttnFDNYyY/vNJztPr2niX7aIakUCijuqpVBVNS1tLYKnr/Xn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="318513763"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="318513763"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 05:16:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="674948391"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="674948391"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2023 05:16:45 -0800
Message-ID: <871716083508732b474ae22b381a58be66889707.camel@linux.intel.com>
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when
 emulating data access in 64-bit mode
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, chao.gao@intel.com
Cc:     kvm@vger.kernel.org
Date:   Thu, 02 Mar 2023 21:16:44 +0800
In-Reply-To: <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-5-robert.hu@linux.intel.com>
         <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
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

On Thu, 2023-03-02 at 14:41 +0800, Binbin Wu wrote:
> __linearize is not the only path the modified LAM canonical check 
> needed, also some vmexits path should be taken care of, like VMX,
> SGX 
> ENCLS.
> 
SGX isn't in this version's implementation's scope, like nested LAM.

> Also the instruction INVLPG, INVPCID should have some special
> handling 
> since LAM is not applied to the memory operand of the two
> instruction 
> according to the LAM spec.

The spec's meaning on these 2 is: LAM masking doesn't apply to their
operands (the address), so the behavior is like before LAM feature
introduced. No change.
> 
> 
> > +#ifdef CONFIG_X86_64
> > +/*
> > + * LAM Canonical Rule:
> > + * LAM_U/S48 -- bit 63 == bit 47
> > + * LAM_U/S57 -- bit 63 == bit 56
> 
> The modified LAM canonical check for LAM_U57 + 4-level paging is:
> bit 
> 63, bit 56:47 should be all 0s.
> 
Yes, this case was missed. Chao's suggestion on signed-extend + legacy
canonical check can cover this.

