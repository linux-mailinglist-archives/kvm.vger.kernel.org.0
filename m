Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5083336BA
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhCJH5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhCJH4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:56:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8B6C06174A;
        Tue,  9 Mar 2021 23:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8yDNi4Cu7JaX2t8j5a1pH+xv/sVGeWdMdEUl6pT4Ks0=; b=DMrk3dBOuhklCt4yj8SS0dgfR4
        +1PbC4jpBhZCLTLvddt8tZDJoxaoW6ICKxqclcUI+u12CQhc7x91rDb0NNszOXkJSa15d+94Ek8Ri
        myp2LwbQR9xow+bF02kIENvcti+ctlnLgdpilVo1/z64HTSZ+Lvn0PeIO9DsJgWUvrs2z2H+aHoIA
        M5MATDVvPDQM797+9scQSd0xpzlz+d95SBedfNXbHImZi9+eTUyNsJd2CEtR2UAj3w0JU6cVPF8/a
        0cxIX9Qq26wbejO5uKM59JAVZAoGQUTtGAa975CyqxnvkTqLJ9YwCdNkNO6EXIo/7BUi9MIJzBDAX
        NrJ3GZSg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJthv-002nUx-HH; Wed, 10 Mar 2021 07:56:43 +0000
Date:   Wed, 10 Mar 2021 07:56:39 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH v1 07/14] vfio: Add a device notifier interface
Message-ID: <20210310075639.GB662265@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524010999.3480.14282676267275402685.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524010999.3480.14282676267275402685.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:48:30PM -0700, Alex Williamson wrote:
> Using a vfio device, a notifier block can be registered to receive
> select device events.  Notifiers can only be registered for contained
> devices, ie. they are available through a user context.  Registration
> of a notifier increments the reference to that container context
> therefore notifiers must minimally respond to the release event by
> asynchronously removing notifiers.

Notifiers generally are a horrible multiplexed API.  Can't we just
add a proper method table for the intended communication channel?
