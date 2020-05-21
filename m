Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3855D1DC68D
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 07:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgEUFSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 01:18:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:38134 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgEUFSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 01:18:44 -0400
IronPort-SDR: AsLTI3hlQGQIDwEO9jAlpGrMVnah4NOyTSz/YKjh6VrwyL4JYJSpvntss6LI/1x5iZZOcxCUP7
 DZ9+OfpY1Ing==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 22:18:44 -0700
IronPort-SDR: PyQBc6QrQH5MeOG4YoWWgZ978estFyoBDusDoj0/YZC+l3Zbsyu4OyOR9nmeImA20dGsWtPGwx
 uVuVpYeusRiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,416,1583222400"; 
   d="scan'208";a="264929876"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga003.jf.intel.com with ESMTP; 20 May 2020 22:18:37 -0700
Date:   Thu, 21 May 2020 01:08:46 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dgilbert@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@Alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200521050846.GC10369@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home>
 <20200520025500.GA10369@joy-OptiPlex-7040>
 <97977ede-3c5b-c5a5-7858-7eecd7dd531c@nvidia.com>
 <20200520104612.03a32977@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520104612.03a32977@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 10:46:12AM -0600, Alex Williamson wrote:
> On Wed, 20 May 2020 19:10:07 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 5/20/2020 8:25 AM, Yan Zhao wrote:
> > > On Tue, May 19, 2020 at 10:58:04AM -0600, Alex Williamson wrote:  
> > >> Hi folks,
> > >>
> > >> My impression is that we're getting pretty close to a workable
> > >> implementation here with v22 plus respins of patches 5, 6, and 8.  We
> > >> also have a matching QEMU series and a proposal for a new i40e
> > >> consumer, as well as I assume GVT-g updates happening internally at
> > >> Intel.  I expect all of the latter needs further review and discussion,
> > >> but we should be at the point where we can validate these proposed
> > >> kernel interfaces.  Therefore I'd like to make a call for reviews so
> > >> that we can get this wrapped up for the v5.8 merge window.  I know
> > >> Connie has some outstanding documentation comments and I'd like to make
> > >> sure everyone has an opportunity to check that their comments have been
> > >> addressed and we don't discover any new blocking issues.  Please send
> > >> your Acked-by/Reviewed-by/Tested-by tags if you're satisfied with this
> > >> interface and implementation.  Thanks!
> > >>  
> > > hi Alex and Kirti,
> > > after porting to qemu v22 and kernel v22, it is found out that
> > > it can not even pass basic live migration test with error like
> > > 
> > > "Failed to get dirty bitmap for iova: 0xca000 size: 0x3000 err: 22"
> > >   
> > 
> > Thanks for testing Yan.
> > I think last moment change in below cause this failure
> > 
> > https://lore.kernel.org/kvm/1589871178-8282-1-git-send-email-kwankhede@nvidia.com/
> > 
> >  > 	if (dma->iova > iova + size)
> >  > 		break;  
> > 
> > Surprisingly with my basic testing with 2G sys mem QEMU didn't raise 
> > abort on g_free, but I do hit this with large sys mem.
> > With above change, that function iterated through next vfio_dma as well. 
> > Check should be as below:
> > 
> > -               if (dma->iova > iova + size)
> > +               if (dma->iova > iova + size -1)
> 
> 
> Or just:
> 
> 	if (dma->iova >= iova + size)
> 
> Thanks,
> Alex
> 
> 
> >                          break;
> > 
> > Another fix is in QEMU.
> > https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg04751.html
> > 
> >  > > +        range->bitmap.size = ROUND_UP(pages, 64) / 8;  
> >  >
> >  > ROUND_UP(npages/8, sizeof(u64))?
> >  >  
> > 
> > If npages < 8, npages/8 is 0 and ROUND_UP(0, 8) returns 0.
> > 
> > Changing it as below
> > 
> > -        range->bitmap.size = ROUND_UP(pages / 8, sizeof(uint64_t));
> > +        range->bitmap.size = ROUND_UP(pages, sizeof(__u64) * 
> > BITS_PER_BYTE) /
> > +                             BITS_PER_BYTE;
> > 
> > I'm updating patches with these fixes and Cornelia's suggestion soon.
> > 
> > Due to short of time I may not be able to address all the concerns 
> > raised on previous versions of QEMU, I'm trying make QEMU side code 
> > available for testing for others with latest kernel changes. Don't 
> > worry, I will revisit comments on QEMU patches. Right now first priority 
> > is to test kernel UAPI and prepare kernel patches for 5.8
> > 
>
hi Kirti
by updating kernel/qemu to v23, still met below two types of errors.
just basic migration test.
(the guest VM size is 2G for all reported bugs).

"Failed to get dirty bitmap for iova: 0xfe011000 size: 0x3fb0 err: 22"

or 

"qemu-system-x86_64-lm: vfio_load_state: Error allocating buffer
qemu-system-x86_64-lm: error while loading state section id 49(vfio)
qemu-system-x86_64-lm: load of migration failed: Cannot allocate memory"


Thanks
Yan
