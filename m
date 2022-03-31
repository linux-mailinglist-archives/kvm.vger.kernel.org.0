Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B534ED127
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 03:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352214AbiCaBEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 21:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346065AbiCaBEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 21:04:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885E165D31;
        Wed, 30 Mar 2022 18:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648688536; x=1680224536;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1dlEDgQKh23w/zXDxJY2KzGHeDnj9hNUwJGYdrUoU24=;
  b=O9FR3XY9HKZUsnbRXtOpPvfWryXx/4HX5AR2rz1o/xXol8pkRjIEM9pE
   eHkU4k2PiMCLERjW4shTRiIVMul79BU3DQZS92zs+iBnUe9/IDtzv7h6S
   6NogvLY2Fh6C5N+06s6H/Iq18rvotBRWyEhH+BOURjOWeWwisLHevRrYJ
   rXJRefy1Sd2tiiDv8aVKkQuuX+/UpZlfmSwvLdJglnJtlY62g1YpxUu3h
   N+CXEH8JP6oxCWKvNW8Ew1yq/J1ysyvhYuM09mNJFP1UF/D0IMl5CQnr+
   vWWomJXAIosUuNrZsrmhaBAbgeKG8AZ6sVOtSqotfkI3hpyYYfDfK/kPN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259656694"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="259656694"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 18:02:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="554867541"
Received: from dhathawa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.226])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 18:02:13 -0700
Message-ID: <b2a1b80f9f7779ddcfcda50ca3ce08df000b2f1b.camel@intel.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Date:   Thu, 31 Mar 2022 14:02:11 +1300
In-Reply-To: <YkTvw5OXTTFf7j4y@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
         <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
         <20220314194513.GD1964605@ls.amr.corp.intel.com>
         <YkTvw5OXTTFf7j4y@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > 
> > - VMXON on all pCPUs: The TDX module initialization requires to enable VMX
> > (VMXON) on all present pCPUs.  vmx_hardware_enable() which is called on creating
> > guest does it.  It naturally fits with the TDX module initialization at creating
> > first TD.  I wanted to avoid code to enable VMXON on loading the kvm_intel.ko.
> 
> That's a solvable problem, though making it work without exporting hardware_enable_all()
> could get messy.

Could you elaborate a little bit on how to resolve?

-- 
Thanks,
-Kai


