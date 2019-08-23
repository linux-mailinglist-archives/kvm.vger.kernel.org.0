Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466039A72B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 07:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391955AbfHWFcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 01:32:50 -0400
Received: from ozlabs.org ([203.11.71.1]:53547 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391107AbfHWFcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 01:32:50 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46F95q6CgFz9sDQ; Fri, 23 Aug 2019 15:32:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566538367; bh=/vm4RWX8jxrnP7cIg16ozDOrP8OuPgLDgomlE32zxpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P8HigVevzTu+3Tb//Q1o3LAWFtPM7klSM61MKFFh8zFR70YFK0za4auOtyoPWaErv
         TTRMNU3BgsKp8kzMvE+09FLNs6cgbqcoy+3MbP6fz3epmKSub/oBfZE+3y9xGxL8z3
         HUifoYQSKeLourEy4BOtd1iIWvPzGbYf4W24ZHMCOeNr3EDs7YMRaNF16ekT9RQfGF
         +UphyLJafV6Q+sQWMNUZL+kkggVV2Iy1Ey54S1nDR+MpAh1qaOPGwduDtof0SeLHz9
         bl1d+Mx9pKp6VS4mH0VZSV5HXOIpcRQxeLO+v/1TpTthBNlSRb+/VniheK9AyXaYzi
         5k5d8XDbyGDZg==
Date:   Fri, 23 Aug 2019 15:32:41 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH kernel] vfio/spapr_tce: Fix incorrect tce_iommu_group
 memory free
Message-ID: <20190823053241.hogc44em2ccwdwq4@oak.ozlabs.ibm.com>
References: <20190819015117.94878-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819015117.94878-1-aik@ozlabs.ru>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 11:51:17AM +1000, Alexey Kardashevskiy wrote:
> The @tcegrp variable is used in 1) a loop over attached groups
> 2) it stores a pointer to a newly allocated tce_iommu_group if 1) found
> nothing. However the error handler does not distinguish how we got there
> and incorrectly releases memory for a found+incompatible group.
> 
> This fixes it by adding another error handling case.
> 
> Fixes: 0bd971676e68 ("powerpc/powernv/npu: Add compound IOMMU groups")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Good catch.  This is potentially nasty since it is a double free.
Alex, are you going to take this, or would you prefer it goes via
Michael Ellerman's tree?

Reviewed-by: Paul Mackerras <paulus@ozlabs.org>
