Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5755A5A9E6D
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiIARr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbiIARrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:47:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4447272B41
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662054369; x=1693590369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Ar8lYtLKUf6mfLbsel9ud6h3uucv1PWEAp4c616Z+k=;
  b=fTK/aW59tZtGZAmQHVx/GhrEIQ+xjuMv5WtjpztMQsghYBdFD+USQvRc
   oOH+i5B7dVFXitBmSWLbxMheqxjDoz6IEr/3+vV4QbPfyFP3ggm2FAm+c
   pCWQTIrw1fFpvzVw1u0szuuCDVAM18NJ374/YPYHlzxNnMyBwIxqQUvvj
   cS5WmJ1xCeWnTZfNABCS6CPMe6gS27QNAxLVdS8zzNiqDMTwkUOx6Ny+N
   dQDFbJNeI4sJam9F5yspDGkGmfI0o6Qe8RtfZW21um2x8+r0g50TsHO2O
   HIfmoAwg28A1UXgvXy06GUdZj2/yB3NTgP5g2Zfg5VR/1c7fMb9BQJNPD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296567383"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="296567383"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 10:46:08 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="716206934"
Received: from lelomeli-mobl.amr.corp.intel.com (HELO desk) ([10.212.74.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 10:46:08 -0700
Date:   Thu, 1 Sep 2022 10:46:06 -0700
From:   Pawan Gupta <pawan.kumar.gupta@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, chen.zhang@intel.com,
        kvm list <kvm@vger.kernel.org>
Subject: Re: BHB-clearing on VM-exit
Message-ID: <20220901174606.x2ml5tve266or5ap@desk>
References: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
 <Yw8aK9O2C+38ShCC@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw8aK9O2C+38ShCC@gao-cwp>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 04:22:03PM +0800, Chao Gao wrote:
> On Tue, Aug 30, 2022 at 04:42:19PM -0700, Jim Mattson wrote:
> >Don't we need a software BHB-clearing sequence on VM-exit for Intel
> >parts that don't report IA32_ARCH_CAPABILITIES.BHI_NO? What am I
> >missing?
> 
> I think we need the software mitigation on parts that don't support/enable
> BHI_DIS_S of IA32_SPEC_CTRL MSR and don't enumerate BHI_NO.
> 
> Pawan, any idea?

Intel doesn't recommend any BHI mitigation on VM exit. The guest can't
make risky system calls (e.g. unprivileged eBPF) in the host, so the
previously proposed attacks aren't viable, and in general the exposed
attack surface to a guest is much smaller (with no syscalls). If
defense-in-depth paranoia is desired, the BHB-clearing sequence could be
an alternative in the absence of BHI_DIS_S/BHI_NO.

Thanks,
Pawan
