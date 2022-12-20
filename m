Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A5B651C39
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 09:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiLTIRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 03:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLTIRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 03:17:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46EA17068
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 00:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671524234; x=1703060234;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f3Xo1bGrtzBbfotAXMRgi5cATnO0M4VNLyVarWWUQdw=;
  b=ME8bf7O1y7+D0KxitHYf4wuWFq9MV68Fi+JWba3SM58IPKev5wxIWEfF
   Tb6QTGT4E+l8pIt12YGVYHQpsNrIh0Ro+ZH96MFnofeMzCX1ZtYp4+lAI
   FGKEy5B5lenn5FGvZQqPMYqDJt36GNwYCepJTZgLwv1oacCCnW9Mh0Xce
   mPQQsYTpNv48/hI9MNAYjqWgK7G1e8RprrnetW5QHOiIidqk5YuQuSV1y
   VouddU3QGOhQ17M92x1jAuxAA7KmP1AzVA1v79ohNeEL4vxBJZzQNyuKd
   ttbCRWOVhatkg55XgWqo63vgil9dmZ/k6M0MM99QEvoCnbT+E6K/KY+Zx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="381781775"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="381781775"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 00:17:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="600991591"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="600991591"
Received: from zguangxi-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.197.157])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 00:16:56 -0800
Date:   Tue, 20 Dec 2022 16:16:42 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
Message-ID: <20221220081642.2bgq7xoeswtkeuym@linux.intel.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
 <Y5yeKucYYfYOMXqp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5yeKucYYfYOMXqp@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022 at 04:34:50PM +0000, Sean Christopherson wrote:
> On Fri, Dec 16, 2022, Yu Zhang wrote:
> > Currently, KVM xen and its shared info selftest code uses
> > 'GPA_INVALID' for GFN values, but actually it is more accurate
> > to use the name 'INVALID_GFN'. So just add a new definition
> > and use it.
> > 
> > No functional changes intended.
> > 
> > Suggested-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > ---
> >  arch/x86/kvm/xen.c                                   | 4 ++--
> >  include/linux/kvm_types.h                            | 1 +
> >  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 4 ++--
> >  3 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index d7af40240248..6908a74ab303 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
> >  	int ret = 0;
> >  	int idx = srcu_read_lock(&kvm->srcu);
> >  
> > -	if (gfn == GPA_INVALID) {
> > +	if (gfn == INVALID_GFN) {
> 
> Grrr!  This magic value is ABI, as "gfn == -1" yields different behavior than a
> random, garbage gfn.

Thanks Sean. But I do not get it.
May I ask why ABI usages are different?  Or is there any documentation
describing the requirement? Thanks!

>                                                                                 
> So, sadly, we can't simply introduce INVALID_GFN here, and instead need to do
> something like:
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 20522d4ba1e0..2d31caaf812c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1766,6 +1766,7 @@ struct kvm_xen_hvm_attr {
>                 __u8 vector;
>                 __u8 runstate_update_flag;
>                 struct {
> +#define KVM_XEN_INVALID_GFN    (~0ull)
>                         __u64 gfn;
>                 } shared_info;

I guess above policy shall also be applied for the gpa inside struct
kvm_xen_vcpu_attr. Instead of using INVALID_GPA (in patch 2), should
be like:

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 61c052d51a64..c06ef8ed9680 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1823,6 +1823,7 @@ struct kvm_xen_vcpu_attr {
        __u16 type;
        __u16 pad[3];
        union {
+#define KVM_XEN_INVALID_GPA            (~0ull)
                __u64 gpa;
                __u64 pad[8];
                struct {

Also, xen.c should use KVM_XEN_INVALID_GPA for GPA values...

B.R.
Yu
