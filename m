Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13E32412F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfETT2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 15:28:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfETT2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 15:28:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54B65308125C;
        Mon, 20 May 2019 19:28:02 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24A951001E86;
        Mon, 20 May 2019 19:28:02 +0000 (UTC)
Date:   Mon, 20 May 2019 13:28:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     jiangyiwen <jiangyiwen@huawei.com>
Cc:     <kvm@vger.kernel.org>
Subject: Re: [bug report] vfio: Can't find phys by iova in
 vfio_unmap_unpin()
Message-ID: <20190520132801.4e2ab8ab@x1.home>
In-Reply-To: <5CE25C33.2060009@huawei.com>
References: <5CE25C33.2060009@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 20 May 2019 19:28:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 15:50:11 +0800
jiangyiwen <jiangyiwen@huawei.com> wrote:

> Hello alex,
> 
> We test a call trace as follows use ARM64 architecture,
> it prints a WARN_ON() when find not physical address by
> iova in vfio_unmap_unpin(), I can't find the cause of
> problem now, do you have any ideas?

Is it reproducible?  Can you explain how to reproduce it?  The stack
trace indicates a KVM VM is being shutdown and we're trying to clean
out the IOMMU mappings from the domain and find a page that we think
should be mapped that the IOMMU doesn't have mapped.  What device(s) was
assigned to the VM?  This could be an IOMMU driver bug or a
vfio_iommu_type1 bug.  Have you been able to reproduce this on other
platforms?

> In addition, I want to know why there is a WARN_ON() instead
> of BUG_ON()? Does it affect the follow-up process?

We're removing an IOMMU page mapping entry and find that it's not
present, so ultimately the effect at the IOMMU is the same, there's no
mapping at that address, but I can't say without further analysis
whether that means a page remains pinned or if that inconsistency was
resolved previously elsewhere.  We WARN_ON because this is not what we
expect, but potentially leaking a page of memory doesn't seem worthy of
crashing the host, nor would a crash dump at that point necessarily aid
in resolving the missing page as it potentially occurred well in the
past.  Thanks,

Alex
