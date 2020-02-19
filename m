Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8349716472C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 15:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBSOjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 09:39:16 -0500
Received: from outbound-smtp63.blacknight.com ([46.22.136.252]:47071 "EHLO
        outbound-smtp63.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726518AbgBSOjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 09:39:16 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2020 09:39:14 EST
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp63.blacknight.com (Postfix) with ESMTPS id B6A34FB021
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 14:33:03 +0000 (GMT)
Received: (qmail 26706 invoked from network); 19 Feb 2020 14:33:03 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 19 Feb 2020 14:33:03 -0000
Date:   Wed, 19 Feb 2020 14:33:00 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, konrad.wilk@oracle.com, nitesh@redhat.com,
        riel@surriel.com, willy@infradead.org, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Subject: Re: [PATCH v17 3/9] mm: Add function __putback_isolated_page
Message-ID: <20200219143300.GR3466@techsingularity.net>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
 <20200211224624.29318.89287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20200211224624.29318.89287.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:46:24PM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> There are cases where we would benefit from avoiding having to go through
> the allocation and free cycle to return an isolated page.
> 
> Examples for this might include page poisoning in which we isolate a page
> and then put it back in the free list without ever having actually
> allocated it.
> 
> This will enable us to also avoid notifiers for the future free page
> reporting which will need to avoid retriggering page reporting when
> returning pages that have been reported on.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Ok, the prior code that used post_alloc_hook to make the isolated page seem
like a normally allocated page followed by a free seems strange anyway. As
well as being expensive, isolated pages can end up on the per-cpu lists
which is probably not what is desired. I *think* what you've done is ok so

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
