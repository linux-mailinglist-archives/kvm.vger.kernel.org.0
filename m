Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0056B6908A1
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBIMZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBIMZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:25:50 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDDC3AA2
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 04:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675945549; x=1707481549;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a58JVjX8VBd0NVglAg9VX2VLWe/QHT+KrBUb5IXqMB8=;
  b=V6DICVClPmzMottwYhdI/W1wR65TKv4pysQzdg+SAGhnqxWFMZdVDvv4
   OvIobEbI5vwsRj35qwLBkZh+2nMXc3JmzRTIfzKUhjNiFHCKh/RhUHmGg
   IwJNDDuW+8nTi7LQZdM9tX5Db23jo77nDYlFld5wODW66Vtb3M1ypFknC
   Zs3HMPOTFS04d1MZQHRZp2Lgf/9QiVqEZi4Fke4ImQZGr6q/q2rv+OHfY
   M/wnq2ko7fLHBoDMZ/pR3106y1pCJ+ecNHpCGg3w/ypCf+ptItK+wAKFQ
   xG0kD1akFChYnm2lvIZsYfdujCpUxwsWB5yE9fThj9pvovGgp4dqXFZ4i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309739602"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="309739602"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 04:25:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="913111282"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="913111282"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 09 Feb 2023 04:25:47 -0800
Message-ID: <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Thu, 09 Feb 2023 20:25:46 +0800
In-Reply-To: <Y+SPjkY87zzFqHLj@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <Y+SPjkY87zzFqHLj@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-09 at 14:15 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
> > Intercept CR4.LAM_SUP by KVM, to avoid read VMCS field every time,
> > with
> > expectation that guest won't toggle this bit frequently.
> > 
> > Under EPT mode, CR3 is fully under guest control, guest LAM is thus
> > transparent to
> > KVM. Nothing more need to do.
> 
> I don't think it is correct. You have to strip LAM_U57/U48 from CR3
> when
> walking guest page table and strip metadata from pointers when
> emulating
> instructions.
> 
Yes, has added patch 8 for emulation case. Didn't explicitly note it in
cover letter.
> > 
> > For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48
> > and CR3.LAM_U57
> > toggles.
> > 
> > [1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368
> > (Section 10.6 VMX interaction)
> > [2] Thus currently, Kernel enabling patch only enables LAM_U57. 
> > https://lore.kernel.org/lkml/20230123220500.21077-1-kirill.shutemov@linux.intel.com/
> >  
> 
> Please add a kvm-unit-test or kselftest for LAM, particularly for
> operations (e.g., canonical check for supervisor pointers, toggle
> CR4.LAM_SUP) which aren't covered by the test in Kirill's series.

OK, I can explore for kvm-unit-test in separate patch set.
BTW, this patch set has passed guest running Kirill's kselftests.

