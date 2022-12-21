Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9585D652D75
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 08:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiLUHus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 02:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiLUHup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 02:50:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6141EB3E
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 23:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671609043; x=1703145043;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0AnB+hgpDMdzl2ksAPHCogUVHsAxYeV5yXh3+TszIwk=;
  b=mdHJWGFt/f9QK7iy/tSCDsit4nhTWo5hq6BObE5Tqb16HlSW2Q8hPPkR
   0hxp8+KEORkZ89NLd4f/UHuEl2dSBsCr+P4FKwP1KsmCVBJIPi/wbmEqo
   vPPiN1cjTFKJSc+tn5FH5yRtMdtfOKrfe39NEv8lGcazoPsUbAmM0USTI
   PG93GULg0e68X52cvw5iRQFYRZRn6SRQha0GhzlC4rWBtzSpvaGy8Ej3q
   ZSfwF9g/fjEYWEWS0BiDXR5I5auXYjePvlEc0ORIQU7+Ohbj1KpDXA0pk
   UCSyMV9uOZV1fRTpxhMdClFgR/5YoyJzQ3D4VsTEZZtjPwlBqpiLyIgMd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321720708"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321720708"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 23:50:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="825555966"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="825555966"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 23:50:37 -0800
Date:   Wed, 21 Dec 2022 15:50:35 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 5/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
Message-ID: <20221221075034.yx5unrmkkwubvpm2@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-6-robert.hu@linux.intel.com>
 <20221219065347.oojvunwaszvqxhu5@yy-desk-7060>
 <49fd8ecc10bef5a4c6393aa8f313858c69a03ea3.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49fd8ecc10bef5a4c6393aa8f313858c69a03ea3.camel@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> No. CR4.LAM_SUP isn't an enablement switch over CR3.LAM_U{48,57},
> they're parallel relationship, CR4.LAM_SUP controls supervisor mode
> addresses has LAM or not while CR3.LAM_U controls user mode address's
> LAM enablement.

Unfortunately, the spec(the one in your cover letter) has a bug in
"10.1 ENUMERATION, ENABLING, AND CONFIGURATION":

CR4.LAM_SUP enables and configures LAM for supervisor pointers:
• If CR3.LAM_SUP = 0, LAM is not enabled for supervisor pointers.
• If CR3.LAM_SUP = 1, LAM is enabled for supervisor pointers with a width determined by the paging mode:

Based on the context, I think "CR3.LAM_SUP" should be "CR4.LAM_SUP".

I believe it could just be a typo. But it is confusing enough.

B.R.
Yu
