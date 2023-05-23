Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C683D70D435
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 08:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbjEWGpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 02:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjEWGpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 02:45:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C43511F;
        Mon, 22 May 2023 23:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0gea6RehJXx9DE2mUeb9T6tvlF6DNioynOY2MO8ezuc=; b=Ox6CC6l+zWAZhhJfa1q2YddRlq
        2ayM85IfKhwJ7m7JOwrnDLaSuCDKOUjUTefjigDVLII9Gxxj+V8ccY38we9x92Pr5r8dO6iOL+4Ih
        1fdJZzuoNBNQlL7XWpuLlVk1bH0uWrjppmcokLoVbI/+UzoRe5VHZK8pW02pU3wcDIEiXRdwBMV1Y
        Lr8xIHXBdJukeHW7sAll5I0I/wv4bW/xiDLY1YqFSDkNzlIoGAikETRPs/gJ6TPccCHabdLt1aCji
        OOMfKZo6fH6J4HqKV7RZ8LMFKYc0AB7GvZgwDw0MsXGxXo7PMrHR4jfSzflJcCeM0nRL+nJhm9U8U
        HAiIL7WA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q1Llg-0096va-27;
        Tue, 23 May 2023 06:45:12 +0000
Date:   Mon, 22 May 2023 23:45:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Message-ID: <ZGxg+I8FWz3YqBMk@infradead.org>
References: <20230522063725.284686-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522063725.284686-1-apopple@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 04:37:25PM +1000, Alistair Popple wrote:
> This problem was discovered during testing of an ARM SMMU
> implementation that does not support broadcast TLB maintenance
> (BTM). In this case the SMMU driver uses notifiers to issue TLB
> invalidates. For read-only to read-write pte upgrades the SMMU
> continually returned a read-only PTE to the device, even though the
> CPU had a read-write PTE installed.
> 
> Sending a mmu notifier event to the SMMU driver fixes the problem by
> flushing secondary TLB entries. A new notifier event type is added so
> drivers may filter out these invalidations if not required. Note a
> driver should never upgrade or install a PTE in response to this mmu
> notifier event as it is not synchronised against other PTE operations.

I don't see these SMMU driver changes anywhere.  I.e. you're adding dead
code as far as I can tell.
