Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF64C78C136
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbjH2JYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 05:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbjH2JYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 05:24:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A7CCC3
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 02:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693301049; x=1724837049;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=k8wmz6gLOLehQl5Tc2Eejiul0oThtEUob0a0/5GkVOs=;
  b=beISe5TN7d0vZtB3p7zTI6/b/CAE2CKF3uQmmzEpdgGZmV0x1nmvTmzc
   qtndFhgcpSLTiGwGqlHzED+EHN4gANfb1cSXe0EbNKsEm483bSM2psmth
   1QuJoJZvc3aYaupEdB7InoB8icO47JNwvxWRq92yt0dAot5NVzf8Qghwx
   2W02c2tzZdq0WiUSN1wLxvYA11ebVhtiL3QqLOs48WM0ZmQUl+/kiQh86
   faNGoj9EjFC7E0X7lFk+wPSzPV6aWBp6t+Ut/UCJj/BsKeiIUn2TgFAva
   cOWFbfKKiTjwG/rsMOkklF7GEksqj5b0MH8oYJgUMP5+0/GOGMJmS6gAs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="441672239"
X-IronPort-AV: E=Sophos;i="6.02,210,1688454000"; 
   d="scan'208";a="441672239"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 02:24:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="741743418"
X-IronPort-AV: E=Sophos;i="6.02,210,1688454000"; 
   d="scan'208";a="741743418"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.80])
  by fmsmga007.fm.intel.com with ESMTP; 29 Aug 2023 02:24:04 -0700
Date:   Tue, 29 Aug 2023 17:12:33 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
Message-ID: <20230829091233.GA72470@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <ZOjpIL0SFH+E3Dj4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOjpIL0SFH+E3Dj4@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 10:47:12AM -0700, Sean Christopherson wrote:
> 
> 
> Filemap vs. xarray
> ------------------
> This is the main item that needs attention.  I don't want to merge guest_memfd()
> without doing this comparison, as not using filemap means we don't need AS_UNMOVABLE.
> Arguably we could merge a filemap implementation without AS_UNMOVABLE and just eat
> the suboptimal behavior, but not waiting a little while longer to do everything we
> can to get this right the first time seems ridiculous after we've been working on
> this for literally years.
> 
> Paolo was going to work on an axarray implementation, but AFAIK he hasn't done
> anything yet.  We (Google) don't have anyone available to work on an xarray
> implementation for several weeks (at best), so if anyone has the bandwidth and
> desire to take stab at an xarray implementation, please speak up.

I can do some experiments in the following weeks on the xarray
direction. I'm not quite confident I understood all what Paolo
originally wanted to do, so questions may have.

Chao
