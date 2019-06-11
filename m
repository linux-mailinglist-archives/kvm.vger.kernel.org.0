Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE6C3C182
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 05:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390896AbfFKDVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 23:21:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54882 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390856AbfFKDVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 23:21:31 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 31151A74AFE345096269;
        Tue, 11 Jun 2019 11:21:29 +0800 (CST)
Received: from [127.0.0.1] (10.177.16.168) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Jun 2019
 11:21:26 +0800
Subject: Re: [bug report] vfio: Can't find phys by iova in vfio_unmap_unpin()
To:     Alex Williamson <alex.williamson@redhat.com>
References: <5CE25C33.2060009@huawei.com> <20190520132801.4e2ab8ab@x1.home>
CC:     <kvm@vger.kernel.org>
From:   jiangyiwen <jiangyiwen@huawei.com>
Message-ID: <5CFF1E35.5010602@huawei.com>
Date:   Tue, 11 Jun 2019 11:21:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20190520132801.4e2ab8ab@x1.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.16.168]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/5/21 3:28, Alex Williamson wrote:
> On Mon, 20 May 2019 15:50:11 +0800
> jiangyiwen <jiangyiwen@huawei.com> wrote:
> 
>> Hello alex,
>>
>> We test a call trace as follows use ARM64 architecture,
>> it prints a WARN_ON() when find not physical address by
>> iova in vfio_unmap_unpin(), I can't find the cause of
>> problem now, do you have any ideas?
> 
> Is it reproducible?  Can you explain how to reproduce it?  The stack
> trace indicates a KVM VM is being shutdown and we're trying to clean
> out the IOMMU mappings from the domain and find a page that we think
> should be mapped that the IOMMU doesn't have mapped.  What device(s) was
> assigned to the VM?  This could be an IOMMU driver bug or a
> vfio_iommu_type1 bug.  Have you been able to reproduce this on other
> platforms?
> 

Hello Alex,

Sorry to reply you so late because of some things,
this problem's reason is in some platform (like ARM64),
the "0" physical address is valid and can be used for
system memory, so in this case it should not print a
WARN_ON() and continue, we should unmap and unpin this
"0" physical address in these platform.

So I want to return FFFFFFFFFFFFFFFFL instead of "0" as invalid
physical address in function iommu_iova_to_phys(). Do you think
it's appropriate?

Thanks,
Yiwen.

>> In addition, I want to know why there is a WARN_ON() instead
>> of BUG_ON()? Does it affect the follow-up process?
> 
> We're removing an IOMMU page mapping entry and find that it's not
> present, so ultimately the effect at the IOMMU is the same, there's no
> mapping at that address, but I can't say without further analysis
> whether that means a page remains pinned or if that inconsistency was
> resolved previously elsewhere.  We WARN_ON because this is not what we
> expect, but potentially leaking a page of memory doesn't seem worthy of
> crashing the host, nor would a crash dump at that point necessarily aid
> in resolving the missing page as it potentially occurred well in the
> past.  Thanks,
> 
> Alex
> 
> .
> 


