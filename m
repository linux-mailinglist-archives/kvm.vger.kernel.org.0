Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD07983E4
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 10:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbjIHITH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 04:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjIHITG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 04:19:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399BF1FD0;
        Fri,  8 Sep 2023 01:18:52 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7A9E268B05; Fri,  8 Sep 2023 10:18:48 +0200 (CEST)
Date:   Fri, 8 Sep 2023 10:18:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Message-ID: <20230908081848.GD8240@lst.de>
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com> <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com> <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com> <ZPd6Y9KJ0FfbCa0Q@google.com> <5ff1591c-d41c-331f-84a6-ac690c48ff5d@arm.com> <ZPiQQ0OANuaOYdIS@google.com> <5d81a9cd-f96d-bcdb-7878-74c2ead26cfb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d81a9cd-f96d-bcdb-7878-74c2ead26cfb@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 05:18:51PM +0100, Robin Murphy wrote:
> Indeed a bunch of work has gone into SWIOTLB recently trying to make it a 
> bit more efficient for such cases where it can't be avoided, so it is 
> definitely still interesting to learn about impacts at other levels like 
> this. Maybe there's a bit of a get-out for confidential VMs though, since 
> presumably there's not much point COW-ing encrypted private memory, so 
> perhaps KVM might end up wanting to optimise that out and thus happen to 
> end up less sensitive to unavoidable SWIOTLB behaviour anyway?

Well, the fix for bounce buffering is to trust the device, and there is
a lot of work going into device authentication and attesttion right now
so that will happen.

On the swiotlb side a new version of the dma_sync_*_device APIs that
specifies the mapping len and the data length transfer would avoid
some of the overhead here.  We've decided that it is a good idea last
time, but so far no one has volunteers to implement it.

