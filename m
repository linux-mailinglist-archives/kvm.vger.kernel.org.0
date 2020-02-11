Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83686159502
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgBKQdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:33:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:18514 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgBKQdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 11:33:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 08:33:18 -0800
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="237443521"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 08:33:18 -0800
Message-ID: <3a8d9e1a3a5528c3a0889448f2ffd02c186399b7.camel@linux.intel.com>
Subject: Re: [PATCH v16.1 6/9] virtio-balloon: Add support for providing
 free page reports to host
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Tue, 11 Feb 2020 08:33:18 -0800
In-Reply-To: <314cb54e-8dfc-7606-7135-c21dbf416505@redhat.com>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
         <20200122174347.6142.92803.stgit@localhost.localdomain>
         <b8cbf72d-55a7-4a58-6d08-b0ac5fa86e82@redhat.com>
         <20200211063441-mutt-send-email-mst@kernel.org>
         <ada0ec83-8e7d-abb3-7053-0ec2bf2a9aa5@redhat.com>
         <20200211090052-mutt-send-email-mst@kernel.org>
         <d6b481fb-6c72-455d-f8e4-600a8677c7a8@redhat.com>
         <20200211094357-mutt-send-email-mst@kernel.org>
         <314cb54e-8dfc-7606-7135-c21dbf416505@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-11 at 16:13 +0100, David Hildenbrand wrote:
>  >> AFAIKs, the guest could inflate/deflate (esp. temporarily) and
> > > communicate via "actual" the actual balloon size as he sees it.
> > 
> > OK so you want hinted but unused pages counted, and reported
> > in "actual"? That's a vmexit before each page use ...
> 
> No, not at all. I rather meant, that it is unclear how
> inflation/deflation requests and "actual" *could* interact. Especially
> if we would consider free page reporting as some way of inflation
> (+immediate deflation) triggered by the guest. IMHO, we would not touch
> "actual" in that case.
> 
> But as I said, I am totally fine with keeping it as is in this patch.
> IOW not glue free page reporting to inflation/deflation but let it act
> like something different with its own semantics (and document these
> properly).
> 

Okay, so before I post v17 am I leaving the virtio-balloon changes as they
were then?

For what it is worth I agree with Michael that there is more to this than
just a scatter-gather queue. For now I am trying to keep the overall
impact on QEMU on the smaller side, and if we do end up supporting the
MADV_FREE instead of MADV_DONTNEED that would also have an impact on
things as it would be yet another difference between ballooning and
hinting.

Thanks.

- Alex

