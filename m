Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0011A9AB8
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408747AbgDOKfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 06:35:18 -0400
Received: from foss.arm.com ([217.140.110.172]:41906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408738AbgDOKfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 06:35:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A8B11063;
        Wed, 15 Apr 2020 03:35:11 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2C603F68F;
        Wed, 15 Apr 2020 03:35:10 -0700 (PDT)
Subject: Re: [PATCH kvmtool 14/18] virtio: Don't ignore initialization
 failures
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
 <20200414143946.1521-15-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <11851801-10bf-a906-beff-726107794788@arm.com>
Date:   Wed, 15 Apr 2020 11:34:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414143946.1521-15-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/2020 15:39, Alexandru Elisei wrote:
> Don't ignore an error in the bus specific initialization function in
> virtio_init; don't ignore the result of virtio_init; and don't return 0
> in virtio_blk__init and virtio_scsi__init when we encounter an error.
> Hopefully this will save some developer's time debugging faulty virtio
> devices in a guest.
> 
> To take advantage of the cleanup function virtio_blk__exit, move appending
> the new device to the list before the call to virtio_init. Change
> virtio_net__exit to free all allocated net_dev devices on exit, and
> matching what virtio_blk__exit does.
> 
> To safeguard against this in the future, virtio_init has been annoted
> with the compiler attribute warn_unused_result.

Many thanks for doing those changes!

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  hw/vesa.c                |  2 +-
>  include/kvm/kvm.h        |  1 +
>  include/kvm/virtio.h     |  7 ++++---
>  include/linux/compiler.h |  2 +-
>  virtio/9p.c              |  9 +++++---
>  virtio/balloon.c         | 10 ++++++---
>  virtio/blk.c             | 14 ++++++++-----
>  virtio/console.c         | 11 +++++++---
>  virtio/core.c            |  9 ++++----
>  virtio/net.c             | 45 ++++++++++++++++++++++++----------------
>  virtio/scsi.c            | 14 ++++++++-----
>  11 files changed, 78 insertions(+), 46 deletions(-)
> 
