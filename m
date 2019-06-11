Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A257E3D084
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404408AbfFKPN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 11:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388333AbfFKPN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 11:13:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 60FFB307D984;
        Tue, 11 Jun 2019 15:13:51 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E3E660C4C;
        Tue, 11 Jun 2019 15:13:48 +0000 (UTC)
Date:   Tue, 11 Jun 2019 09:13:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jiangyiwen <jiangyiwen@huawei.com>
Cc:     <kvm@vger.kernel.org>,
        "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>
Subject: Re: [bug report] vfio: Can't find phys by iova in
 vfio_unmap_unpin()
Message-ID: <20190611091348.60195fe0@x1.home>
In-Reply-To: <5CFFA149.8070303@huawei.com>
References: <5CE25C33.2060009@huawei.com>
        <20190520132801.4e2ab8ab@x1.home>
        <5CFF1E35.5010602@huawei.com>
        <5CFFA149.8070303@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 11 Jun 2019 15:13:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[cc +iommu]

On Tue, 11 Jun 2019 20:40:41 +0800
Jiangyiwen <jiangyiwen@huawei.com> wrote:

> Hi Alex,
> 
> I found this problem is not very easy to solve, for
> now, in arm64 platform, the "0" physical address
> is a valid system memory address, so in function
> arm_smmu_iova_to_phys() I think it should not use
> "0" as abnormal return value.
> 
> Do you have any idea?

I think you're going to need to redefine iommu_iova_to_phys() and fix
all the IOMMU implementations of it to comply.  Currently AMD and Intel
IOMMU driver return zero if a mapping is not found.  You could make the
function return 0/errno and return the physical address via a pointer
arg.  You could also keep the existing definition, but introduce a test
for a valid result that might use an architecture specific value (akin
to IS_ERR()).  You could also just reserve the zero page from userspace
allocation.  I really don't want #ifdef in the vfio iommu driver trying
to discern the correct invalid value though.  Thanks,

Alex

> On 2019/6/11 11:21, jiangyiwen wrote:
> > On 2019/5/21 3:28, Alex Williamson wrote:  
> >> On Mon, 20 May 2019 15:50:11 +0800
> >> jiangyiwen <jiangyiwen@huawei.com> wrote:
> >>  
> >>> Hello alex,
> >>>
> >>> We test a call trace as follows use ARM64 architecture,
> >>> it prints a WARN_ON() when find not physical address by
> >>> iova in vfio_unmap_unpin(), I can't find the cause of
> >>> problem now, do you have any ideas?  
> >> Is it reproducible?  Can you explain how to reproduce it?  The stack
> >> trace indicates a KVM VM is being shutdown and we're trying to clean
> >> out the IOMMU mappings from the domain and find a page that we think
> >> should be mapped that the IOMMU doesn't have mapped.  What device(s) was
> >> assigned to the VM?  This could be an IOMMU driver bug or a
> >> vfio_iommu_type1 bug.  Have you been able to reproduce this on other
> >> platforms?
> >>  
> > Hello Alex,
> >
> > Sorry to reply you so late because of some things,
> > this problem's reason is in some platform (like ARM64),
> > the "0" physical address is valid and can be used for
> > system memory, so in this case it should not print a
> > WARN_ON() and continue, we should unmap and unpin this
> > "0" physical address in these platform.
> >
> > So I want to return FFFFFFFFFFFFFFFFL instead of "0" as invalid
> > physical address in function iommu_iova_to_phys(). Do you think
> > it's appropriate?
> >
> > Thanks,
> > Yiwen.
> >  
> >>> In addition, I want to know why there is a WARN_ON() instead
> >>> of BUG_ON()? Does it affect the follow-up process?  
> >> We're removing an IOMMU page mapping entry and find that it's not
> >> present, so ultimately the effect at the IOMMU is the same, there's no
> >> mapping at that address, but I can't say without further analysis
> >> whether that means a page remains pinned or if that inconsistency was
> >> resolved previously elsewhere.  We WARN_ON because this is not what we
> >> expect, but potentially leaking a page of memory doesn't seem worthy of
> >> crashing the host, nor would a crash dump at that point necessarily aid
> >> in resolving the missing page as it potentially occurred well in the
> >> past.  Thanks,
> >>
> >> Alex
> >>
> >> .
> >>  
> >
> >
> > .
> >  
> 

