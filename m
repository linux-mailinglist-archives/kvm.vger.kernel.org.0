Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254CA6958DD
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjBNGLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjBNGLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:11:23 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C046C650
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676355080; x=1707891080;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i3nj95eSBe0fSiwOLsG9mFhyezO8GJ6KSJpk/5TY91w=;
  b=I1Eb1lJ+2oXOBMQNx+4qIuqBbhk18TiqKlRfJ7gv0WtppcQCYP3xVg97
   5JhaFX3aZfD7ym38Bd1ZVMETOLC8od+PABoqNgOvdmJTadkpMaJBWl3Rb
   g1dDkE/+YHqyEUotHFHUW2Ykv7IKyHYk9lIpll4TwhU5MYAFJ24nVqbQt
   lY61igYubbirCedDPNbyXZ+0ybIAyOMM26zNiKl992kAFDcphwNBd8nmf
   64MrgneJfXrR0lh5P5AFZdGspVAD9A48QefpEZpGA1dttir7knpT+1IjX
   yx/PrqgraYboxu176vqx6r4bk/YRKLjS1nzx4hhvM/1mANYsfF6JFfrfn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="332401046"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="332401046"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:11:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="778184739"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="778184739"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 13 Feb 2023 22:11:16 -0800
Message-ID: <90d0f1ffec67e015e3f0f1ce9d8d719634469a82.camel@linux.intel.com>
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Tue, 14 Feb 2023 14:11:15 +0800
In-Reply-To: <814481b6-c316-22bd-2193-6aa700db47b5@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-2-robert.hu@linux.intel.com>
         <814481b6-c316-22bd-2193-6aa700db47b5@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-02-14 at 09:27 +0800, Binbin Wu wrote:
> This patch removes CR4.LAM_SUP from cr4_reserved_bits to allows the 
> setting of X86_CR4_LAM_SUP by guest 

Yes

> if the hardware platform supports 
> the feature.

More precisely, if guest_cpuid_has() LAM feature. QEMU could turn
feature off even if underlying host/KVM tells supporting it.
> 
> The interception of CR4 is decided by CR4 guest/host mask and CR4
> read 
> shadow.
> 
My interpretation is that "intercept CR4.x bit" is the opposite of
"guest own CR4.x bit".
Both of them are implemented via CR4 guest/host mask and CR4 shadow,
whose combination decides corresponding CR4.x bit access causes VM exit
or not.
When we changes some bits in CR4_RESERVED_BITS and
__cr4_reserved_bits(), we changes vcpu->arch.cr4_guest_owned_bits which
eventually forms the effective vmcs_writel(CR4_GUEST_HOST_MASK).


