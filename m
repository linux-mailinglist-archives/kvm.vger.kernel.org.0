Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3A7D7B29
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 05:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjJZDJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 23:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjJZDJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 23:09:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F28018B
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 20:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698289755; x=1729825755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yWQDhRurLOH/L8IKsfUYl5qFYKHRqCxDZQmP6sNWFTk=;
  b=Kcm1ivrnVzXUT9JBq18kO3/XA3e9YbIcOCucJzpL50Iy+a0/nvGicgAU
   5krsj38j374f3gVTteozX9RVd9YdulIo/jaGNyPhI8R+Ff7y9W37VqChQ
   nLKl5odj4LaLx5C0APvCFM3+89sFHcKYPI2OZw2NCVdzBEhonr2EYPGi1
   LhYLh/1GBXVestX66Kto5ap1uBuWADtNZz2pYsuKduZiSm98+m1aTBff0
   EhHQOxrrMDOJyqui+0h1Aj313fF/h6/ordXNtZkwDzJdZi4ecdnBZe5IK
   z61VP3/G+IjHzfStxv5ZFDADqxCD91y4LblLRxw9o7xJ/s+YmcJHSpbA8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="366797527"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="366797527"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 20:09:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="794043153"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="794043153"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 25 Oct 2023 20:09:12 -0700
Date:   Thu, 26 Oct 2023 11:20:52 +0800
From:   Zhao Liu <zhao1.liu@intel.com>
To:     EwanHai <ewanhai-oc@zhaoxin.com>
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
Message-ID: <ZTnbFJrHeKhoUA6F@intel.com>
References: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 03:14:53AM -0400, EwanHai wrote:
> Date: Mon, 25 Sep 2023 03:14:53 -0400
> From: EwanHai <ewanhai-oc@zhaoxin.com>
> Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for backward
>  compatibility
> X-Mailer: git-send-email 2.34.1
> 
> Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> execution controls") implemented a workaround for hosts that have
> specific CPUID features but do not support the corresponding VMX
> controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
> 
> In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
> If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> use KVM's settings, avoiding any modifications to this MSR.
> 
> However, this commit (4a910e1) didn’t account for cases in older Linux

s/didn’t/didn't/

> kernels(e.g., linux-4.19.90) where `MSR_IA32_VMX_PROCBASED_CTLS2` is

For this old kernel, it's better to add the brief lifecycle note (e.g.,
lts, EOL) to illustrate the value of considering such compatibility
fixes.

> in `kvm_feature_msrs`—obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),

s/—obtained/-obtained/

> but not in `kvm_msr_list`—obtained by ioctl(KVM_GET_MSR_INDEX_LIST).

s/—obtained/-obtained/

> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.
> 
> This patch supplements the above logic, ensuring that
> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> lists, thus maintaining compatibility with older kernels.
> 
> Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
> ---
>  target/i386/kvm/kvm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index af101fcdf6..6299284de4 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>  static int kvm_get_supported_feature_msrs(KVMState *s)
>  {
>      int ret = 0;
> +    int i;
>  
>      if (kvm_feature_msrs != NULL) {
>          return 0;
> @@ -2377,6 +2378,11 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
>          return ret;
>      }

It's worth adding a comment here to indicate that this is a
compatibility fix.

-Zhao

>  
> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> +            has_msr_vmx_procbased_ctls2 = true;
> +        }
> +    }
>      return 0;
>  }
>  
> -- 
> 2.34.1
> 
