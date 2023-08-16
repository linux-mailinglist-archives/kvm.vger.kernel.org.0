Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A5F77EDA0
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 01:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243898AbjHPXEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 19:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347121AbjHPXDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 19:03:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6C626BB;
        Wed, 16 Aug 2023 16:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692226994; x=1723762994;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HwATJyz9dflMduy9fzEYBXYap5gEJS8QjgqdRKD1bnk=;
  b=UERyuVym0XkkKkWN62xW3dFF2usgb9dYD44Wl+hVJRzLlkp6Ron32R81
   AC//KFKIN/eQaHn+33tDTh5JUxSI5At5J6SVJtgGd3lAOmny+p+Eegbxw
   fo/rGxg2ULdfuSL8G6PfPkE7GJVd6f7w9MgxchlrMfR3fLYfVcuhCO/lw
   +pRsg9UpRzT9iV2L9cIKGRx/6ENg4DufnGh46Z9Ef8TRnblwywtH8ZSCD
   sscXcS1IVWxdhP4h1zHD8fAZyUYhDLXALLY/wLET0IjlzLh7ZRRslSwn7
   z20l05AX3u47gdq1mOJ7eu6WsqnqcSbQxcdD4ABt42rD2Vq5gDdFpxbAK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357628427"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="357628427"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 16:03:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="1065017276"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="1065017276"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga005.fm.intel.com with ESMTP; 16 Aug 2023 16:03:11 -0700
Date:   Thu, 17 Aug 2023 07:03:10 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 09/15] KVM: nSVM: Use KVM-governed feature framework
 to track "TSC scaling enabled"
Message-ID: <20230816230310.qfa347ujhkj25vqj@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-10-seanjc@google.com>
 <20230816063531.rq7tyrvceln5q4du@yy-desk-7060>
 <ZNzSymgZqozT7Tno@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNzSymgZqozT7Tno@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023 at 06:44:42AM -0700, Sean Christopherson wrote:
> On Wed, Aug 16, 2023, Yuan Yao wrote:
> > On Tue, Aug 15, 2023 at 01:36:47PM -0700, Sean Christopherson wrote:
> > > @@ -2981,7 +2982,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > >
> > >  		svm->tsc_ratio_msr = data;
> > >
> > > -		if (svm->tsc_scaling_enabled && is_guest_mode(vcpu))
> > > +		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> > > +		    is_guest_mode(vcpu))
> >
> > I prefer (is_guest_mode(vcpu) && ....), so I can skip them more quickly LOL.
> > but anyway depends on you :-)
>
> For this series, I want to do as much of a straight replacement as possible, i.e.
> not change any ordering unless it's "necessary".

Yeah, I'm fine with this.
