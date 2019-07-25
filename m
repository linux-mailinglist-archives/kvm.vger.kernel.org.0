Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9073575881
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfGYUAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 16:00:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:2147 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfGYUAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 16:00:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 13:00:07 -0700
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="254074357"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 13:00:07 -0700
Message-ID: <6bee80b95885e74a5e46e3bd3e708d092b4a666f.camel@linux.intel.com>
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Thu, 25 Jul 2019 13:00:07 -0700
In-Reply-To: <cc98f7c9-bcf8-79cb-54b7-de7c996f76e1@redhat.com>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
         <20190724171050.7888.62199.stgit@localhost.localdomain>
         <20190724173403-mutt-send-email-mst@kernel.org>
         <ada4e7d932ebd436d00c46e8de699212e72fd989.camel@linux.intel.com>
         <fed474fe-93f4-a9f6-2e01-75e8903edd81@redhat.com>
         <bc162a5eaa58ac074c8ad20cb23d579aa04d0f43.camel@linux.intel.com>
         <20190725111303-mutt-send-email-mst@kernel.org>
         <96b1ac42dccbfbb5dd17210e6767ca2544558390.camel@linux.intel.com>
         <cc98f7c9-bcf8-79cb-54b7-de7c996f76e1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-07-25 at 14:25 -0400, Nitesh Narayan Lal wrote:
> On 7/25/19 12:16 PM, Alexander Duyck wrote:
> > On Thu, 2019-07-25 at 11:16 -0400, Michael S. Tsirkin wrote:
> > > On Thu, Jul 25, 2019 at 08:05:30AM -0700, Alexander Duyck wrote:
> > > > On Thu, 2019-07-25 at 07:35 -0400, Nitesh Narayan Lal wrote:
> > > > > On 7/24/19 6:03 PM, Alexander Duyck wrote:
> > > > > > On Wed, 2019-07-24 at 17:38 -0400, Michael S. Tsirkin wrote:
> > > > > > > On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > > > > > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > > > > > 
> > > > > > > 

<snip>


> > Ideally we should be able
> > to provide the hints and have them feed whatever is supposed to be using
> > them. So for example I could probably look at also clearing the bitmaps
> > when migration is in process.
> > 
> > Also, I am wonder if the free page hints would be redundant with the form
> > of page hinting/reporting that I have since we should be migrating a much
> > smaller footprint anyway if the pages have been madvised away before we
> > even start the migration.
> > 
> > > FWIW Nitesh's RFC does not have this limitation.
> > Yes, but there are also limitations to his approach. For example the fact
> > that the bitmap it maintains is back to being a hint rather then being
> > very exact.
> 
> True.
> 
> 
> >  As a result you could end up walking the bitmap for a while
> > clearing bits without ever finding a free page.
> 
> Are referring to the overhead which will be introduced due to bitmap scanning on
> very large guests?

Yes. One concern I have had is that for large memory footprints the RFC
would end up having a large number of false positives on an highly active
system. I am worried it will result in a feedback loop where having more
false hits slows down your processing speed, and the slower your
processing speed the more likely you are to encounter more false hits.

