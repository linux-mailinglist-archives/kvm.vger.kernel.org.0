Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3791760A4A
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 08:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjGYGZS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Jul 2023 02:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjGYGZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 02:25:12 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 138BC1BD7;
        Mon, 24 Jul 2023 23:24:39 -0700 (PDT)
Received: from [IPv6:::1] (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 36P6ImRw024173;
        Tue, 25 Jul 2023 01:18:49 -0500
Message-ID: <0101c83334721e28b603211c427941e8d31ea9d8.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
        naoya.horiguchi@nec.com, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Clint Sbisa <csbisa@amazon.com>, osamaabb@amazon.com
Date:   Tue, 25 Jul 2023 16:18:48 +1000
In-Reply-To: <20230717123524.0cefedd0.alex.williamson@redhat.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
         <20230405180134.16932-2-ankita@nvidia.com> <86r0spl18x.wl-maz@kernel.org>
         <ZDarrZmLWlA+BHQG@nvidia.com> <ZHcxHbCb439I1Uk2@arm.com>
         <67a7374a72053107661ecc2b2f36fdb3ff6cc6ae.camel@kernel.crashing.org>
         <ZLQIDkFysVJ8kzkQ@arm.com> <ZLRvf1M3gk4jjPp0@nvidia.com>
         <20230717123524.0cefedd0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-07-17 at 12:35 -0600, Alex Williamson wrote:
> On Sun, 16 Jul 2023 19:30:23 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Sun, Jul 16, 2023 at 08:09:02AM -0700, Catalin Marinas wrote:
> > 
> > > In terms of security for arm64 at least, Device vs Normal NC (or nc vs
> > > wc in Linux terminology) doesn't make much difference with the former
> > > occasionally being worse. The kernel would probably trust the DPDK code
> > > if it allows direct device access.  
> > 
> > RDMA and DRM already allow device drivers to map WC to userspace on
> > demand, we expect the platform to support this.
> > 
> > > > So the userspace component needs to be responsible for selecting the
> > > > mapping, the same way using the PCI sysfs resource files today allows
> > > > to do that by selecting the _wc variant.  
> > > 
> > > I guess the sysfs interface is just trying to work around the VFIO
> > > limitations.  
> > 
> > I think just nobody has ever asked for VFIO WC support. The main
> > non-VM user is DPDK and none of the NIC drivers have wanted this (DPDK
> > applications areis more of throughput than latency focused typically)
> 
> Yes, QEMU can't know whether the device or driver want a WC BAR
> mapping, so we've left it for KVM manipulation relative to VM use
> cases.  Nobody has followed through with a complete proposal to enable
> it otherwise for direct userspace driver access, but I don't think
> there's opposition to providing such a thing.  Thanks,

Ok, this is really backburner work for me but I'll try to cook up a POC
patch in the near (hopefully) future along the lines of the subregions
I proposed and we can discuss from there.

Cheers,
Ben.
