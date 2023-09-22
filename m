Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8E07ABA2A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjIVTki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 15:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjIVTkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 15:40:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0885BAF;
        Fri, 22 Sep 2023 12:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695411631; x=1726947631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4EqY69+zYdrxR47KayTtNyOORFAQpVGTPA/TjOrQ2N0=;
  b=nQcW24qb72AvI/AvwrYMRIPmC08aGMocxcwi2tiCEK7FlJE24S+zpmcA
   kYJAXEre7pC1q0UbJY4XTtmMvYIoVNMKaxG2K1PUV4Kkx9xA27GL/jh3G
   CMjRuaDeCIn68mLuDtMM03aekobYpnivmUzPx5jaOwKZ93c4nENpG5D1F
   mqmBq7w6fft49AOAMDTUVLtvMcc7+euLHDXZvklhbuWW4rMYiJnoGtguk
   qJO089BRPZB1PW5QmToUd9c8Y5aR1zT0NToddLW5UrGqe17J0uzE5hhgK
   /w+7GBJqd5rzg8e/Kz96E80bssbUBXjn+bOJaQiPeety4dTtmul7uFl45
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="445023199"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="445023199"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 12:40:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="863072777"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="863072777"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 12:40:30 -0700
Date:   Fri, 22 Sep 2023 12:40:29 -0700
From:   Isaku Yamahata <isaku.yamahata@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>, isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH v2 0/6] KVM: gmem: Implement test cases for
 error_remove_page
Message-ID: <20230922194029.GA1206715@ls.amr.corp.intel.com>
References: <cover.1695327124.git.isaku.yamahata@intel.com>
 <ZQynx5DyP56/HAxV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZQynx5DyP56/HAxV@google.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:29:59PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > This patch series is to implement test cases for the KVM gmem error_remove_page
> > method.
> > - Update punch hole method to truncate pages
> > - Add a new ioctl KVM_GUEST_MEMORY_FAILURE to inject memory failure on
> >   offset of gmem
> 
> Doh.  Please try to communicate what you're working on.  I was just about to hit
> SEND on a series to fix the truncation bug, and to add a similar test.  I would
> have happily punted that in your direction, but I had no idea that you were aware
> of the bug[*], let alone working on a fix.  I could have explicitly stated that
> I was going to fix the bug, but I thought that it was implied that I needed to
> clean up my own mess.

Oops sorry.  Now I'm considering about machine check injection.
i.e. somehow trigger kvm_machine_check() and its own test cases.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
