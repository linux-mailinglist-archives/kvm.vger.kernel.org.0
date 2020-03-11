Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E6181ED0
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgCKRJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:09:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:16911 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbgCKRJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 13:09:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 10:09:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,541,1574150400"; 
   d="scan'208";a="415637047"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2020 10:09:40 -0700
Date:   Wed, 11 Mar 2020 10:09:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200311170940.GH21852@linux.intel.com>
References: <20200309214424.330363-4-peterx@redhat.com>
 <202003110908.UE6SBwLU%lkp@intel.com>
 <20200311163906.GG479302@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311163906.GG479302@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 12:39:06PM -0400, Peter Xu wrote:
> On Wed, Mar 11, 2020 at 09:10:04AM +0800, kbuild test robot wrote:
> > Hi Peter,
> > 
> > Thank you for the patch! Perhaps something to improve:
> > 
> > [auto build test WARNING on tip/auto-latest]
> > [also build test WARNING on vhost/linux-next linus/master v5.6-rc5 next-20200310]
> > [cannot apply to kvm/linux-next linux/master]
> > [if your patch is applied to the wrong git tree, please drop us a note to help
> > improve the system. BTW, we also suggest to use '--base' option to specify the
> > base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200310-070637
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 12481c76713078054f2d043b3ce946e4814ac29f
> > reproduce:
> >         # apt-get install sparse
> >         # sparse version: v0.6.1-174-g094d5a94-dirty
> >         make ARCH=x86_64 allmodconfig
> >         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> >    arch/x86/kvm/x86.c:2599:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const [noderef] <asn:1> * @@    got  const [noderef] <asn:1> * @@
> >    arch/x86/kvm/x86.c:2599:38: sparse:    expected void const [noderef] <asn:1> *
> >    arch/x86/kvm/x86.c:2599:38: sparse:    got unsigned char [usertype] *
> >    arch/x86/kvm/x86.c:7501:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
> >    arch/x86/kvm/x86.c:7501:15: sparse:    struct kvm_apic_map [noderef] <asn:4> *
> >    arch/x86/kvm/x86.c:7501:15: sparse:    struct kvm_apic_map *
> > >> arch/x86/kvm/x86.c:9794:31: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected void [noderef] <asn:1> * @@    got n:1> * @@
> 
> I'm not sure on how I can reproduce this locally, and also I'm not
> very sure I understand this warning.  I'd be glad to know if anyone
> knows...
> 
> If without further hints, I'll try to remove the __user for
> __x86_set_memory_region() and use a cast on the callers next.

Ah, it's complaining that the ERR_PTR() returns in __x86_set_memory_region()
aren't explicitly casting to a __user pointer.

Part of me wonders if something along the lines of your original approach
of keeping the "int" return and passing a "void __user **p_hva" would be
cleaner overall, as opposed to having to cast everywhere.  The diff would
certainly be smaller.  E.g.

int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
			    void __user **p_hva)
{
	...

	if (p_hva)
		*p_hva = (void __user *)hva;

        return 0;
}
