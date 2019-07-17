Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819A56BB46
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 13:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfGQLUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 07:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 07:20:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B1D33082133;
        Wed, 17 Jul 2019 11:20:55 +0000 (UTC)
Received: from redhat.com (ovpn-120-247.rdu2.redhat.com [10.10.120.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id EB7D55C232;
        Wed, 17 Jul 2019 11:20:34 +0000 (UTC)
Date:   Wed, 17 Jul 2019 07:20:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     wei.w.wang@intel.com, Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: use of shrinker in virtio balloon free page hinting
Message-ID: <20190717071332-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 17 Jul 2019 11:20:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wei, others,

ATM virtio_balloon_shrinker_scan will only get registered
when deflate on oom feature bit is set.

Not sure whether that's intentional.  Assuming it is:

virtio_balloon_shrinker_scan will try to locate and free
pages that are processed by host.
The above seems broken in several ways:
- count ignores the free page list completely
- if free pages are being reported, pages freed
  by shrinker will just get re-allocated again

I was unable to make this part of code behave in any reasonable
way - was shrinker usage tested? What's a good way to test that?

Thanks!

-- 
MST
