Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED66652E1F
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLUIzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUIzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:55:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108C2E0D
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671612930; x=1703148930;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PuptfAf2rn3BWO22v7ygJHB2gB/MrYeWiEyFV2Jolqk=;
  b=RPhUe8zelUrkHlKkZBC6VWP8ApFuto0rDgWETJuY9oFCeEckqQTIWDuj
   wLAF8crB8QBZ1bCPU8GjFG8TmJX9FcOPRiTFmaKS9yz/Bikn4f9VEd9To
   S8E7zN7+BydGycuoSF6+JaNvipmY842yamrRQ/2VnZf8NMc2GgZtPdYyb
   YioTKBLYgkqaxNBgOCOJfig2EGQUVYPc4t7NnIhfo2IfnNpIoruOmHvi0
   xql2+Y0MG0ncdS9VRGmYRNQSVDiegQ06yUlZkZx5sFF6IVcfTavbwWAWO
   IyYqananLfO7EOLOcVpYISpbFMWkH9ioFiJ8n+zRSZTWZlPvlxh9x0S+D
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="406062164"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="406062164"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:55:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="653435149"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="653435149"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 21 Dec 2022 00:55:27 -0800
Message-ID: <f233bea01059908d3305e77818e2f3f3f158be55.camel@linux.intel.com>
Subject: Re: [PATCH v3 5/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Date:   Wed, 21 Dec 2022 16:55:27 +0800
In-Reply-To: <20221221075034.yx5unrmkkwubvpm2@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-6-robert.hu@linux.intel.com>
         <20221219065347.oojvunwaszvqxhu5@yy-desk-7060>
         <49fd8ecc10bef5a4c6393aa8f313858c69a03ea3.camel@linux.intel.com>
         <20221221075034.yx5unrmkkwubvpm2@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-21 at 15:50 +0800, Yu Zhang wrote:
> > No. CR4.LAM_SUP isn't an enablement switch over CR3.LAM_U{48,57},
> > they're parallel relationship, CR4.LAM_SUP controls supervisor mode
> > addresses has LAM or not while CR3.LAM_U controls user mode
> > address's
> > LAM enablement.
> 
> Unfortunately, the spec(the one in your cover letter) has a bug in
> "10.1 ENUMERATION, ENABLING, AND CONFIGURATION":
> 
> CR4.LAM_SUP enables and configures LAM for supervisor pointers:
> • If CR3.LAM_SUP = 0, LAM is not enabled for supervisor pointers.
> • If CR3.LAM_SUP = 1, LAM is enabled for supervisor pointers with a
> width determined by the paging mode:
> 
> Based on the context, I think "CR3.LAM_SUP" should be "CR4.LAM_SUP".
> 
> I believe it could just be a typo. 

Ah, right, I hold the same belief with you. We can report it to ISE
author;-)

> But it is confusing enough.
> 
> B.R.
> Yu

