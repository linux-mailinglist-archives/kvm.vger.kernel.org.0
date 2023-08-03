Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD3276DF01
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 05:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjHCD3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 23:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjHCD2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 23:28:47 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E9E3AAC
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 20:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691033305; x=1722569305;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M25kOQe2Zu3NonvjBfD85cRZReV7uS8x0eVkMFH5XAU=;
  b=P/8s0OxWKZoKUaHsd5nKg6eKcobAeghOB/D1F+haloXFtFP5Ch6T7Nt+
   h+PRobMWdsROA2gMA6zBWmklTfQRFmaEnqJFdddEzGoZeLph4flfdcC39
   PiDN/Di2uvuR+qlTyXwpIhygjVoJLbnkvKPWz/+Fa6RLRgG9juuZ8Dnjk
   41uVvGMzQ82MelyAT8YkXoCDG8G27PCQdglNkXG9Ir8H1c/DJ61pavn/y
   PJylBmwDPBFZCZJ7hnFl3uVTzWkL+aE64E/IQneh3WDKo46MXkGXIb5xh
   XZegMIASYqIS4almbN/BX52vO+JbAednmbCN2Gofdsp4dZo6a0HgoQ9Hw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="367219088"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="367219088"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 20:28:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="706389454"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="706389454"
Received: from linux.bj.intel.com ([10.238.156.127])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 20:28:23 -0700
Date:   Thu, 3 Aug 2023 11:26:21 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
Message-ID: <ZMseXTL80yxUQxa0@linux.bj.intel.com>
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
 <ZMroatylDm1b5+WJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMroatylDm1b5+WJ@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 04:36:10PM -0700, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Tao Su wrote:
> > Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
> > two instructions to perform matrix multiplication of two tiles containing
> > complex elements and accumulate the results into a packed single precision
> > tile.
> > 
> > AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]
> > 
> > Since there are no new VMX controls or additional host enabling required
> > for guests to use this feature, advertise the CPUID to userspace.
> 
> Nit, I would rather justify this (last paragraph) with something like:
> 
>   Advertise AMX_COMPLEX if it's supported in hardware.  There are no VMX
>   controls for the feature, i.e. the instructions can't be interecepted, and
>   KVM advertises base AMX in CPUID if AMX is supported in hardware, even if
>   KVM doesn't advertise AMX as being supported in XCR0, e.g. because the
>   process didn't opt-in to allocating tile data.
> 
> If the above is accurate and there are no objections, I'll fixup the changelog
> when applying.

Totally agree.

> 
> Side topic, this does make me wonder if advertising AMX when XTILE_DATA isn't
> permitted is a bad idea.  But no one has complained, and chasing down all the
> dependent AMX features would get annoying, so I'm inclined to keep the status quo.

From the description of AMX exception, there is no CPUID checking and #UD will be produced
if XCR0[18:17] != 0b11. Since user applications should check both the XCR0 and CPUIDs
before using related AMX instructions, I don't think there should be bad effects in keeping
the status quo.

Thanks,
Tao
