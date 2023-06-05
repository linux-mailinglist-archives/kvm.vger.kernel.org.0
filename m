Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7C67226C8
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjFENEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjFENEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:04:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84B8A6
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 06:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685970250; x=1717506250;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rJ/biFGgm7aNA2XvQF6ZXlNI3G3kjo+FHYWhsif1JSk=;
  b=GScMmRizomxSn0BNJdUV54YDoeJ5Nh6xok+veG8Q+P5K3qslND52sa6T
   i2KSGQUnaeG9kRqx/+iz/bYnusoqbhl89sMiJxabFNzr3ry0MxO0ls+0g
   IKGYPTRHpdyyr+UBdDbDGeXkWUOAy1jO/A7rFgOOpdL1n9LCMkhFQQOlq
   hfSrJX4Cscjxh6GnyxEsDa3xnfczMSvqwAIm5p53xq4PYsrAvTHXZQGzM
   s2vDikXUK3OkhKT0Oc7ZspK7x+aziaMj2NQwW63hyPFT7wej4g6yEGhue
   CjRnLvqi7WrC8Spc/EBNqKI2EP6w1hWdAmaIVxm9P0tVuXBvTrAhoFwPD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="335979671"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="335979671"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 06:03:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="798423541"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798423541"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 06:03:34 -0700
Date:   Mon, 5 Jun 2023 21:03:33 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Clean up kvm_vm_ioctl_create_vcpu()
Message-ID: <20230605130333.gzhjx4gbw7nkqbm2@yy-desk-7060>
References: <20230605114852.288964-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605114852.288964-1-mhal@rbox.co>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 01:44:19PM +0200, Michal Luczaj wrote:
> Since c9d601548603 ("KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond")
> 'cond' is internally converted to boolean, so caller's explicit conversion
> from void* is unnecessary.
>
> Remove the double bang.
>
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6a658f30af91..64dd940c549e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3975,7 +3975,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	if (r < 0)
>  		goto kvm_put_xa_release;
>
> -	if (KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> +	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {

Looks the only one place for KVM_BUG_ON().

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

BTW: svm_get_lbr_msr() is using KVM_BUG(false, ...) and
handle_cr() is using KVM_BUG(1, ...), a chance to
change them to same style ?

>  		r = -EINVAL;
>  		goto kvm_put_xa_release;
>  	}
>
> base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
> --
> 2.41.0
>
