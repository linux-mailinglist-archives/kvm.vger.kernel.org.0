Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87455167A
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 13:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbiFTLA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 07:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240411AbiFTLAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 07:00:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3331C55AE;
        Mon, 20 Jun 2022 04:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655722822; x=1687258822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5kEN8LEeudPIKeDQ20lyx4aW7nBMG8/Yp54OnqCaljs=;
  b=Mo1UGGShxIdhLR/5PXFaiZ5T4YOS7UFIqLlOPzPhqJOAbgpFE4gudmnG
   h4LEeijUb3fif4jZfJUHPMHxT08kG8wr+HSCvmPUHIk3QG60s7QqpTt1p
   8YpILD9uZhaW+b3AZsXoiutNr1A4COuNtQtLtoYp4rRaeZBAibqLZv+QN
   XPpQfUYH4ZS1GWcKCistBJOpGl7wownbei32xmffEjFT4FdtIS74aAK7z
   3YfUaMIwa6GQPaZxyrn7ZZsPuhHh4Wmfl6IUFIYio5TToZgh69agZhSi1
   ooafz6SgFCRXJuSwGbhKAUkIrjkzG3y1IOC/9XGDEF06FGOXnQvRZjbxd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="341547247"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="341547247"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 04:00:21 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="591125969"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 04:00:16 -0700
Date:   Mon, 20 Jun 2022 19:00:02 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Shenming Lu <lushenming@bytedance.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        zhouyibo@bytedance.com
Subject: Re: [External] [PATCH v9 9/9] KVM: VMX: enable IPI virtualization
Message-ID: <20220620105957.GA9496@gao-cwp>
References: <20220419154510.11938-1-guang.zeng@intel.com>
 <cdead652-cbd6-90e4-dab8-9cb18f71a624@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdead652-cbd6-90e4-dab8-9cb18f71a624@bytedance.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 06:02:32PM +0800, Shenming Lu wrote:
>> +		if (enable_ipiv)
>> +			tertiary_exec_controls_clearbit(vmx, TERTIARY_EXEC_IPI_VIRT);
>> +	}
>>   	vmx_update_msr_bitmap_x2apic(vcpu);
>>   }
>
>Hi, just a small question here:
>
>It seems that we clear the TERTIARY_EXEC_IPI_VIRT bit before enabling
>interception for APIC_ICR when deactivating APICv on some reason.
>Is there any problem with this sequence?

Both are done before the next vCPU entry. As long as no guest code can
run between them (APICv setting takes effect in guest), this sequence
shouldn't have any problem.
