Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D983F4FF599
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 13:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiDMLXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 07:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiDMLXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 07:23:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D9A255BC;
        Wed, 13 Apr 2022 04:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C758CB82246;
        Wed, 13 Apr 2022 11:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1989EC385A4;
        Wed, 13 Apr 2022 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649848856;
        bh=cSiQfBbF6ZDYpEmvyUxanMOiy8xvxiXwnOUP/vdgTvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VD68iFFr/vvzobOfHHgbsWMJ86VflpLAgBa+/f1R8EvAN9XQhb3sTxLtLQRun6kIS
         t8HoOnpc2HclAL+Dc9f188hF1Lj/AsdwvWZPWeaidMp5TNbcQSsUAtsckur+uxahst
         CMortC/qwEFWvNRcbgvGebezN81LdIK4T7VrBHLE=
Date:   Wed, 13 Apr 2022 13:20:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yao Hongbo <yaohongbo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        alikernel-developer@linux.alibaba.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uio/uio_pci_generic: Introduce refcnt on open/release
Message-ID: <YlayFROf5P294P/P@kroah.com>
References: <1649833302-27299-1-git-send-email-yaohongbo@linux.alibaba.com>
 <YlZ8vZ9RX5i7mWNk@kroah.com>
 <20220413044246-mutt-send-email-mst@kernel.org>
 <ebd1b238-6e48-6561-93ab-f562096b1c05@linux.alibaba.com>
 <YlabT7+Hqc3h62AT@kroah.com>
 <5a80c065-e811-018e-6c35-01c12b194c94@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a80c065-e811-018e-6c35-01c12b194c94@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 07:09:57PM +0800, Yao Hongbo wrote:
> 
> 在 2022/4/13 下午5:43, Greg KH 写道:
> > On Wed, Apr 13, 2022 at 05:25:40PM +0800, Yao Hongbo wrote:
> > > 在 2022/4/13 下午4:51, Michael S. Tsirkin 写道:
> > > > On Wed, Apr 13, 2022 at 09:33:17AM +0200, Greg KH wrote:
> > > > > On Wed, Apr 13, 2022 at 03:01:42PM +0800, Yao Hongbo wrote:
> > > > > > If two userspace programs both open the PCI UIO fd, when one
> > > > > > of the program exits uncleanly, the other will cause IO hang
> > > > > > due to bus-mastering disabled.
> > > > > > 
> > > > > > It's a common usage for spdk/dpdk to use UIO. So, introduce refcnt
> > > > > > to avoid such problems.
> > > > > Why do you have multiple userspace programs opening the same device?
> > > > > Shouldn't they coordinate?
> > > > Or to restate, I think the question is, why not open the device
> > > > once and pass the FD around?
> > > Hmm, it will have the same result, no matter  whether opening the same
> > > device or pass the FD around.
> > How?  You only open once, and close once.  Where is the multiple closes?
> > 
> > > Our expectation is that even if the primary process exits abnormally,  the
> > > second process can still send
> > > 
> > > or receive data.
> > Then use the same file descriptor.
> 
> 
> Yes, we can use the same file descriptor.
> 
> but since the pcie bus-master  has been disabled by the primary process,
> 
> the seconday process cannot continue to operate.

Really?  With the same file descriptor?  Try it and see.  release should
only be called when the file descriptor is closed.

> > > The impact of disabling pci bus-master is relatively large, and we should
> > > make some restrictions on
> > > this behavior.
> > Why?  UIO is "you better really really know what you are doing to use
> > this interface", right?  Just duplicate the fd and pass it around if you
> > must have multiple accesses to the same device.
> > 
> > And again, this will be a functional change.  How can you handle your
> > userspace on older kernels if you make this change?
> 
> Without this change, our userspace cannot work properly on older kernels.

What change broke your userspace?

> Our userspace only use the "multi process mode" feature of the spdk.
> 
> The SPDK links:
> https://spdk.io/doc/app_overview.html
> 
> "Multi process mode
> When --shm-id is specified, the application is started in multi-process
> mode.
> 
> Applications using the same shm-id share their memory and NVMe devices.
> 
> The first app to start with a given id becomes a primary process, with the
> rest,
> 
> called secondary processes, only attaching to it. When the primary process
> exits,
> 
> the secondary ones continue to operate, but no new processes can be attached
> 
> at this point. All processes within the same shm-id group must use the same
> --single-file-segments setting."

Please work with the spdk users, I know nothing about that mess, sorry.

greg k-h
