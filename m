Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5A1310F59
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhBEQTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:19:22 -0500
Received: from verein.lst.de ([213.95.11.211]:32946 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233524AbhBEQRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:17:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1A3F667373; Fri,  5 Feb 2021 18:58:53 +0100 (CET)
Date:   Fri, 5 Feb 2021 18:58:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Martin Radev <martin.b.radev@gmail.com>,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, kirill.shutemov@linux.intel.com,
        thomas.lendacky@amd.com, robert.buhren@sect.tu-berlin.de,
        file@sect.tu-berlin.de, mathias.morbitzer@aisec.fraunhofer.de,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <20210205175852.GA1021@lst.de>
References: <X/27MSbfDGCY9WZu@martin> <20210113113017.GA28106@lst.de> <YAV0uhfkimXn1izW@martin> <20210203124922.GB16923@lst.de> <20210203193638.GA325136@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203193638.GA325136@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 02:36:38PM -0500, Konrad Rzeszutek Wilk wrote:
> > So what?  If you guys want to provide a new capability you'll have to do
> > work.  And designing a new protocol based around the fact that the
> > hardware/hypervisor is not trusted and a copy is always required makes
> > a lot of more sense than throwing in band aids all over the place.
> 
> If you don't trust the hypervisor, what would this capability be in?

Well, they don't trust the hypervisor to not attack the guest somehow,
except through the data read.  I never really understood the concept,
as it leaves too many holes.

But the point is that these schemes want to force bounce buffering
because they think it is more secure.  And if that is what you want
you better have protocol build around the fact that each I/O needs
to use bounce buffers, so you make those buffers the actual shared
memory use for communication, and build the protocol around it.
E.g. you don't force the ridiculous NVMe PRP offset rules on the block
layer, just to make a complicated swiotlb allocation that needs to
preserve the alignment just do I/O.  But instead you have a trivial
ring buffer or whatever because you know I/O will be copied anyway
and none of all the hard work higher layers do to make the I/O suitable
for a normal device apply.
