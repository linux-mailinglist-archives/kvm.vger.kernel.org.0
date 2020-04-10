Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58971A438C
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 10:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDJIdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 04:33:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52495 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725858AbgDJIdP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Apr 2020 04:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586507594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tgngn9BuGL/zJPxWxLHGSpP5ErqyA3e9IEzjGvABwSY=;
        b=EZzgjKRDOBnYxDiz7IS59TOE+H3ecyo/Q9J6CqE5vxNwaL3Tt0ynyEJiBuo5CG3v/r6ZeO
        xryTxk6kbO4t0vRtqO+mHAlVxeytcS7806EPSfPF7O4P1Ir17ffsjG06pzmYOFUk1oUsjb
        A6KrKw8jVa9Fzm8CvDbSgnCX76PeAhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-mTxGTSp4NpS6RmU_ltFrAg-1; Fri, 10 Apr 2020 04:33:09 -0400
X-MC-Unique: mTxGTSp4NpS6RmU_ltFrAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1CF2107ACC7;
        Fri, 10 Apr 2020 08:33:07 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B44F5C1BB;
        Fri, 10 Apr 2020 08:33:02 +0000 (UTC)
Subject: Re: vhost: refine vhost and vringh kconfig
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
References: <git-mailbomb-linux-master-20c384f1ea1a0bc7320bc445c72dd02d2970d594@kernel.org>
 <CAMuHMdUkff8XUrbHa90nGxa8Kj3HO9b2CRO57s3YZrSFPM51pg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f7fc96d4-de8e-cdce-bd98-242cdade2843@redhat.com>
Date:   Fri, 10 Apr 2020 16:33:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUkff8XUrbHa90nGxa8Kj3HO9b2CRO57s3YZrSFPM51pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/4/10 =E4=B8=8B=E5=8D=883:53, Geert Uytterhoeven wrote:
> Hi Jason,
>
> On Thu, Apr 9, 2020 at 6:04 AM Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> Commit:     20c384f1ea1a0bc7320bc445c72dd02d2970d594
>> Parent:     5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031
>> Refname:    refs/heads/master
>> Web:        https://git.kernel.org/torvalds/c/20c384f1ea1a0bc7320bc445=
c72dd02d2970d594
>> Author:     Jason Wang <jasowang@redhat.com>
>> AuthorDate: Thu Mar 26 22:01:17 2020 +0800
>> Committer:  Michael S. Tsirkin <mst@redhat.com>
>> CommitDate: Wed Apr 1 12:06:26 2020 -0400
>>
>>      vhost: refine vhost and vringh kconfig
>>
>>      Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vho=
st is
>>      not necessarily for VM since it's a generic userspace and kernel
>>      communication protocol. Such dependency may prevent archs without
>>      virtualization support from using vhost.
>>
>>      To solve this, a dedicated vhost menu is created under drivers so
>>      CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
>>
>>      While at it, also squash Kconfig.vringh into vhost Kconfig file. =
This
>>      avoids the trick of conditional inclusion from VOP or CAIF. Then =
it
>>      will be easier to introduce new vringh users and common dependenc=
y for
>>      both vringh and vhost.
>>
>>      Signed-off-by: Jason Wang <jasowang@redhat.com>
>>      Link: https://lore.kernel.org/r/20200326140125.19794-2-jasowang@r=
edhat.com
>>      Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>   arch/arm/kvm/Kconfig         |  2 --
>>   arch/arm64/kvm/Kconfig       |  2 --
>>   arch/mips/kvm/Kconfig        |  2 --
>>   arch/powerpc/kvm/Kconfig     |  2 --
>>   arch/s390/kvm/Kconfig        |  4 ----
>>   arch/x86/kvm/Kconfig         |  4 ----
>>   drivers/Kconfig              |  2 ++
>>   drivers/misc/mic/Kconfig     |  4 ----
>>   drivers/net/caif/Kconfig     |  4 ----
>>   drivers/vhost/Kconfig        | 28 +++++++++++++++++++++-------
>>   drivers/vhost/Kconfig.vringh |  6 ------
>>   11 files changed, 23 insertions(+), 37 deletions(-)
>> --- a/drivers/vhost/Kconfig
>> +++ b/drivers/vhost/Kconfig
>> @@ -1,4 +1,23 @@
>>   # SPDX-License-Identifier: GPL-2.0-only
>> +config VHOST_RING
>> +       tristate
>> +       help
>> +         This option is selected by any driver which needs to access
>> +         the host side of a virtio ring.
>> +
>> +config VHOST
>> +       tristate
>> +       select VHOST_IOTLB
>> +       help
>> +         This option is selected by any driver which needs to access
>> +         the core of vhost.
>> +
>> +menuconfig VHOST_MENU
>> +       bool "VHOST drivers"
>> +       default y
> Please do not use default y. Your subsystem is not special.


This is because before this patch VHOST depends on VIRTUALIZATION. So=20
the archs whose defconfig that has VIRTUALIZATION can just enable e.g=20
VHOST_NET without caring about VHOST_MENU.

If this is not preferable, we can:

1) modify the defconfig and enable VHOST_MENU there
2) switch to use default y if $(all_archs_that_has_VIRTUALIZATION)


>
>> +
> I think this deserves a help text, so users know if they want to enable=
 this
> option or not.


Will add one.

Thanks


>
> Thanks!
>
>> +if VHOST_MENU
>> +
>>   config VHOST_NET
>>          tristate "Host kernel accelerator for virtio net"
>>          depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> Gr{oetje,eeting}s,
>
>                          Geert
>
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org
>
> In personal conversations with technical people, I call myself a hacker=
. But
> when I'm talking to journalists I just say "programmer" or something li=
ke that.
>                                  -- Linus Torvalds
>

