Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17875D602
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjGUUyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGUUyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:54:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDF630CF
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689972852; x=1721508852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eq7PCjRPoXEvAGR9BduBGpSkIHwQsL4MnANg4sr1Vh8=;
  b=PhuhMI+/x51JtrFrUAfXiK/3LpF2bKl0sNdL35Qdo7mZT7TWe7VOsVRq
   6FOBv/cJraYUQDEhhZrb53CknWn8AMEUaU0WwlTSPVVPkco3ClFunYIfU
   vF4mvbw+6EMfIsYQLiNcmmOt2gwHeGV8/DbZf4V/mkwcDvL50ox8PdRgV
   jRDCk+e75Qr5TAo3oD5JlbJSCljYUxMtzoA+vzU4agRL/AJxHsGxIR8ih
   iYesALtlD6fi9zKnwsJ3ferPTDWmViOvWXVzwIxfL3h3bDi9roarXGa8d
   lNfvBxi/bkmrs7oVxe3UFy/0ysZdadXjybVTVdyteefTvHmUuxi1bocks
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10778"; a="433349034"
X-IronPort-AV: E=Sophos;i="6.01,222,1684825200"; 
   d="scan'208";a="433349034"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 13:54:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10778"; a="728227211"
X-IronPort-AV: E=Sophos;i="6.01,222,1684825200"; 
   d="scan'208";a="728227211"
Received: from liyuexin-mobl.amr.corp.intel.com (HELO desk) ([10.255.230.166])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 13:54:11 -0700
Date:   Fri, 21 Jul 2023 13:54:04 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <20230721205404.kqxj3pspexjl6qai@desk>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
 <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email>
 <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
 <ZLn9hgQy77x0hLil@chao-email>
 <20230721190114.xznm7xfnuxciufa3@desk>
 <CALMp9eTNM5VZzpSR6zbkjude6kxgBcOriWDoSkjanMmBtksKYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTNM5VZzpSR6zbkjude6kxgBcOriWDoSkjanMmBtksKYw@mail.gmail.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 12:18:36PM -0700, Jim Mattson wrote:
> > Please note that clearing STIBP bit on one thread does not disable STIBP
> > protection if the sibling has it set:
> >
> >   Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical processor
> >   prevents the predicted targets of indirect branches on any logical
> >   processor of that core from being controlled by software that executes
> >   (or executed previously) on another logical processor of the same core
> >   [1].
> 
> I stand corrected. For completeness, then, is it true now and
> forevermore that passing IA32_SPEC_CTRL through to the guest for write
> can in no way compromise code running on the sibling thread?

As IA32_SPEC_CTRL is a thread-scope MSR, a malicious guest would be able
to turn off the mitigation on its own thread only. Looking at the
current controls in this MSR, I don't see how a malicious guest can
compromise code running on sibling thread.

But, I don't think there is a guarantee that future mitigations would
not allow a malicious guest to compromise code running on sibling. To
avoid this, care must be taken to add such mitigations to other MSRs
that are not exported to guests.
