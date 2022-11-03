Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D2F61785D
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 09:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKCIHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 04:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiKCIHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 04:07:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9F95FC4
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 01:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667462863; x=1698998863;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I8lsCxdSj2qBG63xWcOuQeSmzJ0+fPV9tYuKCeWIyrQ=;
  b=BAKcSQXG9wo6JzcPgTXtWSArDGAzltiuE5L/ISzZOX1/iY8cE3aUiSW/
   rx8owOPFaB+XZFQsCA4I29m+29JgGuiRcRrYGSzYGsNCXHf3dz2NKmYil
   iiP5ViNmW8eTbIih96iwEm41OUP+gafPf27/AinDLG5ETp5rOZ0ADoQtb
   a7XX9Sf0Sqj9s2fvZM/G1Asw6eZyhVfeKdIvwTf6qkbWD8cX/0HHldAXT
   Oqkw9K9OGkTPalDysjuCAtxP1gVZv9zCc9P/Kgyk7/tnJnxMWGk3JWZmO
   XKcMgTdVfKTgjvEwsHHFlRuAfYyUPA+RAgpWs9al3L2kwP0w0uPEZtBmO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="309611900"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="309611900"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 01:07:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="809580991"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="809580991"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 03 Nov 2022 01:07:42 -0700
Message-ID: <f2866792a3e7ecfbe4b17b7a1a4b8cb7a1c576f1.camel@linux.intel.com>
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Date:   Thu, 03 Nov 2022 16:07:41 +0800
In-Reply-To: <20221103024001.wtrj77ekycleq4vc@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
         <20221017070450.23031-9-robert.hu@linux.intel.com>
         <20221031025930.maz3g5npks7boixl@box.shutemov.name>
         <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
         <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
         <1d6a68dd95e13ce36b9f3ccee0b4e203a3aecf02.camel@linux.intel.com>
         <20221102210512.aadxeb3qiloff7yl@box.shutemov.name>
         <9578f16e8be3dddae2c5571a4a8f033ab4259840.camel@linux.intel.com>
         <20221103024001.wtrj77ekycleq4vc@box.shutemov.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-03 at 05:40 +0300, Kirill A. Shutemov wrote:
> On Thu, Nov 03, 2022 at 09:04:23AM +0800, Robert Hoo wrote:
> > I also notice that skip_tlb_flush is set when pcid_enabled && (CR3
> > & X86_CR3_PCID_NOFLUSH). Under this condition, do you think (0,0)
> > -->
> > (1,0) need to flip it back to false?
> 
> Yes, I think we should. We know it is a safe choice.

If so, then judging the (0,0) --> (1,0) case in the else{} branch is
inevitable, isn't it?

Or totally remove the skip_tlb_flush logic in this function, but this
would break existing logic. You won't like it. 
> 
> It also would be nice to get LAM documentation updated on the
> expected
> behaviour. It is not clear from current documentation if enabling LAM
> causes flush. We can only guess that it should at least for some
> scenarios.
> 
> Phantom TLB entires that resurface after LAM gets disable would be
> fun to
> debug.
> 
Agree, and echo your conservativeness.

