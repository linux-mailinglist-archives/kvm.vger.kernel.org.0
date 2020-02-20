Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EADE6166715
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 20:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgBTTXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 14:23:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:13747 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgBTTXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 14:23:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 11:23:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="230218990"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 20 Feb 2020 11:23:50 -0800
Date:   Thu, 20 Feb 2020 11:23:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, wangxinxin.wang@huawei.com,
        weidong.huang@huawei.com, liu.jinsong@huawei.com
Subject: Re: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200220192350.GG3972@linux.intel.com>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220191706.GF2905@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220191706.GF2905@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 02:17:06PM -0500, Peter Xu wrote:
> On Thu, Feb 20, 2020 at 12:28:28PM +0800, Jay Zhou wrote:
> > @@ -3348,7 +3352,14 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> >  	switch (cap->cap) {
> >  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >  	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> > -		if (cap->flags || (cap->args[0] & ~1))
> > +		if (cap->flags ||
> > +		    (cap->args[0] & ~KVM_DIRTY_LOG_MANUAL_CAPS) ||
> > +		    /* The capability of KVM_DIRTY_LOG_INITIALLY_SET depends
> > +		     * on KVM_DIRTY_LOG_MANUAL_PROTECT, it should not be
> > +		     * set individually
> > +		     */
> > +		    ((cap->args[0] & KVM_DIRTY_LOG_MANUAL_CAPS) ==
> > +			KVM_DIRTY_LOG_INITIALLY_SET))
> 
> How about something easier to read? :)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce0e5c1..9dfbab2a9929 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3348,7 +3348,10 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>         switch (cap->cap) {
>  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> -               if (cap->flags || (cap->args[0] & ~1))
> +               if (cap->flags || (cap->args[0] & ~3))
> +                       return -EINVAL;
> +               /* Allow 00, 01, and 11. */
> +               if (cap->args[0] == KVM_DIRTY_LOG_INITIALLY_SET)
>                         return -EINVAL;

Oof, "easier" is subjective :-)  How about this?

	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2: {
		u64 allowed_options = KVM_DIRTY_LOG_MANUAL_PROTECT;

		if (cap->args[0] & KVM_DIRTY_LOG_MANUAL_PROTECT)
			allowed_options = KVM_DIRTY_LOG_INITIALLY_SET;

		if (cap->flags || (cap->args[0] & ~allowed_options))
			return -EINVAL;
		kvm->manual_dirty_log_protect = cap->args[0];
		return 0;
	}

>                 kvm->manual_dirty_log_protect = cap->args[0];
>                 return 0;
> 
> Otherwise it looks good to me!
> 
> Thanks,
> 
> -- 
> Peter Xu
> 
