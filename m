Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF527E0DF
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgI3GKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:10:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:62796 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3GKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 02:10:49 -0400
IronPort-SDR: y7EZcNz/i3iqDRrc3wQwT34Y//32CCB6Rth6iqAr68tSUIYafL8AY+WIpWdkK0sljconsArvpy
 MiuZQvtASDvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="142378976"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="142378976"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:10:49 -0700
IronPort-SDR: htIiZbeEJYeOClBSu8UNGbIhYy6kNFlK9nB0/jx+MBLivArZlXU555Vb7kVr6GcXV2v62qcCBJ
 DMEKzHF27pbw==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="350561475"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:10:48 -0700
Date:   Tue, 29 Sep 2020 23:10:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 06/22] kvm: mmu: Make address space ID a property of
 memslots
Message-ID: <20200930061047.GB29659@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-7-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:46PM -0700, Ben Gardon wrote:
> Save address space ID as a field in each memslot so that functions that
> do not use rmaps (which implicitly encode the id) can handle multiple
> address spaces correctly.
> 
> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> machine. This series introduced no new failures.
> 
> This series can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 05e3c2fb3ef78..a460bc712a81c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -345,6 +345,7 @@ struct kvm_memory_slot {
>  	struct kvm_arch_memory_slot arch;
>  	unsigned long userspace_addr;
>  	u32 flags;
> +	int as_id;

Ha!  Peter Xu's dirtly ring also added this.  This should be a u16, it'll
save 8 bytes per memslot (oooooooh).  Any chance you want to include Peter's
patch[*]?  It has some nitpicking from Peter and I regarding what to do
with as_id on deletion.  That would also avoid silent merge conflicts on
Peter's end.

[*] https://lkml.kernel.org/r/20200708193408.242909-2-peterx@redhat.com

>  	short id;
>  };
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf88233b819a0..f9c80351c9efd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1318,6 +1318,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	new.npages = mem->memory_size >> PAGE_SHIFT;
>  	new.flags = mem->flags;
>  	new.userspace_addr = mem->userspace_addr;
> +	new.as_id = as_id;
>  
>  	if (new.npages > KVM_MEM_MAX_NR_PAGES)
>  		return -EINVAL;
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
