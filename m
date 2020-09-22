Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA72737E3
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 03:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgIVBWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 21:22:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:20247 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbgIVBWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 21:22:30 -0400
IronPort-SDR: uUGBau7/ZMSeTS7O3qxfa9JX6Ue2nZSk6pvgib4E3g8c92GffVd+xyZgHC0WFn5YiTUBHlSEKe
 M2fZ98pb8+MQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="139993688"
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="139993688"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 18:22:30 -0700
IronPort-SDR: 3qZtqaB1FrWVP4m9mBYNne7FpZlhfQDqZGwQCRN8K+Sp95kSBXnh21PlPhlxmSWQzGFq6LG2No
 1i+hY7J3yNTQ==
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="485742456"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 18:22:29 -0700
Date:   Mon, 21 Sep 2020 18:22:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dionna Glaze <dionnaglaze@google.com>,
        Erdem Aktas <erdemaktas@google.com>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Message-ID: <20200922012227.GA26483@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922004024.3699923-2-vipinsh@google.com>
 <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 21, 2020 at 06:04:04PM -0700, Randy Dunlap wrote:
> Hi,
> 
> On 9/21/20 5:40 PM, Vipin Sharma wrote:
> > diff --git a/init/Kconfig b/init/Kconfig
> > index d6a0b31b13dc..1a57c362b803 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1101,6 +1101,20 @@ config CGROUP_BPF
> >  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
> >  	  inet sockets.
> >  
> > +config CGROUP_SEV
> > +	bool "SEV ASID controller"
> > +	depends on KVM_AMD_SEV
> > +	default n
> > +	help
> > +	  Provides a controller for AMD SEV ASIDs. This controller limits and
> > +	  shows the total usage of SEV ASIDs used in encrypted VMs on AMD
> > +	  processors. Whenever a new encrypted VM is created using SEV on an
> > +	  AMD processor, this controller will check the current limit in the
> > +	  cgroup to which the task belongs and will deny the SEV ASID if the
> > +	  cgroup has already reached its limit.
> > +
> > +	  Say N if unsure.
> 
> Something here (either in the bool prompt string or the help text) should
> let a reader know w.t.h. SEV means.
> 
> Without having to look in other places...

ASIDs too.  I'd also love to see more info in the docs and/or cover letter
to explain why ASID management on SEV requires a cgroup.  I know what an
ASID is, and have a decent idea of how KVM manages ASIDs for legacy VMs, but
I know nothing about why ASIDs are limited for SEV and not legacy VMs.
