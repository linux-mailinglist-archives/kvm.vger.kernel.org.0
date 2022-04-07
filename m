Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB974F8BC2
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiDGX0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 19:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiDGX0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 19:26:06 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A713C14B01F;
        Thu,  7 Apr 2022 16:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649373845; x=1680909845;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O1b7WIeGUo0TmUs3OQt7Z4FLbzIJnxs4mxV2Cjhvoh0=;
  b=c/UiCojz08sBfVgqHXN6V9WkkLAxKpcUzYykqc8WMttrwQ6/zeRfbFm6
   Hos96jsSmJRwS9pURKygrFnectqET6ulqYHn3xM5BX8ms30/s2NTAjZD6
   95agqFUnjKplfj9eFM/wndMQrX2iZA9q/FT01TXjIkasAhqy2SSbhFD+3
   g6c4ushPhPMnbW/j3YyuMPgx60Zt+2TRGVZtiW+loyt5/Dh5UZevV98a5
   wwNbw+R+MKl9f0uUpRWrN8RKHDyE0XqXmtO5TUja5VNgvOO9iHnODq6Zj
   XpcV/Nw/pqdEkCIzlNyGcPYVOPCVp2BoVIiqE490gr2aqnmcAx3MQAPua
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322152346"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="322152346"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 16:24:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="524571247"
Received: from asaini1-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.28.162])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 16:24:02 -0700
Message-ID: <4515f55c1717e963989e3d5e8640636d5ed2f25f.camel@intel.com>
Subject: Re: [RFC PATCH v5 047/104] KVM: x86/mmu: add a private pointer to
 struct kvm_mmu_page
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 08 Apr 2022 11:24:00 +1200
In-Reply-To: <7dabd2a6-bc48-6ada-f2f1-f9e30370be2f@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
         <a439dc1542539340e845d177be911c065a4e8d97.camel@intel.com>
         <ec5ffd8b-acc6-a529-6241-ad96a6cf2f88@redhat.com>
         <05b1d51b69f14bb794024f13ef4703ad1c888717.camel@intel.com>
         <7dabd2a6-bc48-6ada-f2f1-f9e30370be2f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-08 at 01:03 +0200, Paolo Bonzini wrote:
> On 4/8/22 00:53, Kai Huang wrote:
> > > 
> > Do you mean below reply?
> > 
> > "I think use of kvm_gfn_stolen_mask() should be minimized anyway.  I
> > would rename it to to kvm_{gfn,gpa}_private_mask and not return bool."
> > 
> > I also mean we should not use kvm_gfn_stolen_mask().  I don't have opinion on
> > the new name.  Perhaps kvm_is_protected_vm() is my preference though.
> 
> But this is one of the case where it would survive, even with the 
> changed name.
> 
> Paolo
> 

Perhaps I confused you (sorry about that).  Yes we do need the check here.  I
just dislike the function name.

-- 
Thanks,
-Kai


