Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0115643D1C
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 07:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiLFG0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 01:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLFG0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 01:26:10 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AAC275D2;
        Mon,  5 Dec 2022 22:26:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC88E68B05; Tue,  6 Dec 2022 07:26:04 +0100 (CET)
Date:   Tue, 6 Dec 2022 07:26:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lei Rao <lei.rao@intel.com>
Cc:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221206062604.GB6595@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-6-lei.rao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221206055816.292304-6-lei.rao@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:58:16PM +0800, Lei Rao wrote:
> The documentation describes the details of the NVMe hardware
> extension to support VFIO live migration.

This is not a NVMe hardware extension, this is some really strange
and half-assed intel-specific extension to nvme, which like any other
vendors specific non-standard extensions to nvme we refused to support
in Linux.

There is a TPAR for live migration building blocks under discussion in
the NVMe technical working group.  It will still require mediatation
of access to the admin queue to deal with the huge amout of state nvme
has that needs to be migrated (and which doesn't seem to be covered at
all here).  In Linux the equivalent would be to implement a mdev driver
that allows passing through the I/O qeues to a guest, but it might
be a better idea to handle the device model emulation entirely in
Qemu (or other userspace device models) and just find a way to expose
enough of the I/O queues to userspace.

The current TPAR seems to be very complicated for that, as in many
cases we'd only need a way to tіe certain namespaces to certain I/O
queues and not waste a lot of resources on the rest of the controller.
