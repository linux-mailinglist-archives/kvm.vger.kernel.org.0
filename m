Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A592F80DF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 21:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKKUNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 15:13:21 -0500
Received: from mga17.intel.com ([192.55.52.151]:64606 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfKKUNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 15:13:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 12:13:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,293,1569308400"; 
   d="scan'208";a="378595734"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 11 Nov 2019 12:13:20 -0800
Date:   Mon, 11 Nov 2019 12:13:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, rafael.j.wysocki@intel.com,
        joao.m.martins@oracle.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 2/4] KVM: ensure grow start value is nonzero
Message-ID: <20191111201320.GA7431@linux.intel.com>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
 <1573041302-4904-3-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573041302-4904-3-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 07:55:00PM +0800, Zhenzhong Duan wrote:
> vcpu->halt_poll_ns could be zeroed in certain cases (e.g. by
> halt_poll_ns = 0). If halt_poll_grow_start is zero,
> vcpu->halt_poll_ns will never be bigger than zero.
> 
> Use param callback to avoid writing zero to halt_poll_grow_start.

This doesn't explain why allowing an admin to disable halt polling by
writing halt_poll_grow_start=0 is a bad thing.  Paolo had the same
question in v1, here[1] and in the guest driver[2].

[1] https://lkml.kernel.org/r/57679389-6e4a-b7ad-559f-3128a608c28a@redhat.com
[2] https://lkml.kernel.org/r/391dd11b-ebbb-28ff-5e57-4a795cd16a1b@redhat.com

> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  virt/kvm/kvm_main.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d6f0696..359516b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -69,6 +69,26 @@
>  MODULE_AUTHOR("Qumranet");
>  MODULE_LICENSE("GPL");
>  
> +static int grow_start_set(const char *val, const struct kernel_param *kp)
> +{
> +	int ret;
> +	unsigned int n;
> +
> +	if (!val)
> +		return -EINVAL;
> +
> +	ret = kstrtouint(val, 0, &n);
> +	if (ret || !n)
> +		return -EINVAL;
> +
> +	return param_set_uint(val, kp);
> +}
> +
> +static const struct kernel_param_ops grow_start_ops = {
> +	.set = grow_start_set,
> +	.get = param_get_uint,
> +};
> +
>  /* Architectures should define their poll value according to the halt latency */
>  unsigned int halt_poll_ns = KVM_HALT_POLL_NS_DEFAULT;
>  module_param(halt_poll_ns, uint, 0644);
> @@ -81,7 +101,7 @@
>  
>  /* The start value to grow halt_poll_ns from */
>  unsigned int halt_poll_ns_grow_start = 10000; /* 10us */
> -module_param(halt_poll_ns_grow_start, uint, 0644);
> +module_param_cb(halt_poll_ns_grow_start, &grow_start_ops, &halt_poll_ns_grow_start, 0644);
>  EXPORT_SYMBOL_GPL(halt_poll_ns_grow_start);
>  
>  /* Default resets per-vcpu halt_poll_ns . */
> -- 
> 1.8.3.1
> 
