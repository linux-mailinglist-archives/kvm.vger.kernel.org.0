Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9569E424FA8
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbhJGJFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhJGJFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 05:05:53 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12835C061746;
        Thu,  7 Oct 2021 02:04:00 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id t4so6265102oie.5;
        Thu, 07 Oct 2021 02:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PAvueer9aMZMZvA0DKMfvJRj/glamcb5kqpTYRoRQhY=;
        b=lKlD+hr2jcOq+xfOQL+fH4N6Vj8osuEH96ZjBU2A2Kp7fJ7UZ3v8O/r2eeUhQkbxuW
         L0rg32EiIiAjO4rVIxjlpqlt6GKkq1d+szlwe5+cAEqI2w/zczgy9JzsCkXeBOlowsr7
         +8ypz2VNgviy+g/rz8kH8GrRf3eiuxkYnVi+pgEFh+TupL7v0jfwoIpcFWgy0MZYKRN9
         UA/GgRT/lE8se0E429zsIz1I+SAMp8ibWIOltL4tRg5hcBSZvohZK3o1XzuHQC0RogRQ
         CMo6T6um/QxBRpaWkNetoxN6mTxbGdeEn/dyAJ+vsowiYg1FmAdgf7Vykvifx92JjKwY
         Jruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PAvueer9aMZMZvA0DKMfvJRj/glamcb5kqpTYRoRQhY=;
        b=to7NV04iVabcbFoR89ngPcxdLpcOS1rJDYnFFzFJzJ9BF+l0WvmPEnHgDjQZXaOk4Z
         7xm/N9wij8KwHXM9l1ZKuh0WrdxUnIdI96pLbmUAm91UYWsuh6X80PnCF0IwzNg2dkNU
         J+XQUVJZBslYaJzCnz67PYcGZ7MIC18eKkNBrqE0f8z0Z87KmE/IKwb132xyN8ziLXQ6
         61EU8X8lcBlZ6pLMRVChbc8BSYPcotV+pH1frsrZIjavSu0F2binNHkT6qA+1/gX47wn
         0YDKcLLD85KHnivkWyRaf3U9+jnko8JyoTWsI4Koroev+ZOpRexoBTv6X9xw36fIhngU
         cIpQ==
X-Gm-Message-State: AOAM530TTbwczQYWZ0lHO3/2dGgnWMSsFXFD+MPDGlQXXj4ONe7u7A3k
        kImJacW0SGEVkRTuiXnc7U4rZSPZGW5rOd1Ulek=
X-Google-Smtp-Source: ABdhPJy2GrEsiJAKuVqIdJoO4A3ktMZrrc6cWXQ/zErXZkYIiF2eZA4ONUe7M1MJoqWmNIU8yzCFCf3lCmZX5W+8RvA=
X-Received: by 2002:a05:6808:1211:: with SMTP id a17mr2142069oil.91.1633597439475;
 Thu, 07 Oct 2021 02:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
 <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com> <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
 <20211004163146.6b34936b.alex.williamson@redhat.com>
In-Reply-To: <20211004163146.6b34936b.alex.williamson@redhat.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Thu, 7 Oct 2021 14:33:47 +0530
Message-ID: <CAHP4M8UeGRSqHBV+wDPZ=TMYzio0wYzHPzq2Y+JCY0uzZgBkmA@mail.gmail.com>
Subject: Re: [PATCH] iommu: intel: remove flooding of non-error logs, when
 new-DMA-PTE is the same as old-DMA-PTE.
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Alex for the reply.


Lu, Alex :

I got my diagnosis regarding the host-driver wrong, my apologies.
There is no issue with the pci-device's host-driver (confirmed by
preventing the loading of host-driver at host-bootup). Thus, nothing
to be fixed at the host-driver side.

Rather seems some dma mapping/unmapping inconsistency is happening,
when kvm/qemu boots up with the pci-device attached to the guest.

I put up debug-logs in "vfio_iommu_type1_ioctl" method in
"vfio_iommu_type1.c" (on the host-machine).
When the guest boots up, repeated DMA-mappings are observed for the
same address as per the host-machine's logs (without a corresponding
DMA-unmapping first) :

##########################################################################################
ajay@ajay-Latitude-E6320:~$ tail -f /var/log/syslog | grep "ajay: "
Oct  7 14:12:32 ajay-Latitude-E6320 kernel: [  146.202297] ajay:
_MAP_DMA for [0x7ffe724a8670] status [0]
Oct  7 14:12:32 ajay-Latitude-E6320 kernel: [  146.583179] ajay:
_MAP_DMA for [0x7ffe724a8670] status [0]
Oct  7 14:12:32 ajay-Latitude-E6320 kernel: [  146.583253] ajay:
_MAP_DMA for [0x7ffe724a8670] status [0]
Oct  7 14:12:36 ajay-Latitude-E6320 kernel: [  150.105584] ajay:
_MAP_DMA for [0x7ffe724a8670] status [0]
Oct  7 14:13:07 ajay-Latitude-E6320 kernel: [  180.986499] ajay:
_UNMAP_DMA for [0x7ffe724a9840] status [0]
Oct  7 14:13:07 ajay-Latitude-E6320 kernel: [  180.986559] ajay:
_MAP_DMA for [0x7ffe724a97d0] status [0]
Oct  7 14:13:07 ajay-Latitude-E6320 kernel: [  180.986638] ajay:
_MAP_DMA for [0x7ffe724a97d0] status [0]
Oct  7 14:13:07 ajay-Latitude-E6320 kernel: [  181.087359] ajay:
_MAP_DMA for [0x7ffe724a97d0] status [0]
Oct  7 14:13:13 ajay-Latitude-E6320 kernel: [  187.271232] ajay:
_UNMAP_DMA for [0x7fde7b7fcfa0] status [0]
Oct  7 14:13:13 ajay-Latitude-E6320 kernel: [  187.271320] ajay:
_UNMAP_DMA for [0x7fde7b7fcfa0] status [0]
....
##########################################################################################


I'll try and backtrack to the userspace process that is sending these ioctls.


Thanks and Regards,
Ajay






On Tue, Oct 5, 2021 at 4:01 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Sat, 2 Oct 2021 22:48:24 +0530
> Ajay Garg <ajaygargnsit@gmail.com> wrote:
>
> > Thanks Lu for the reply.
> >
> > >
> > > Isn't the domain should be switched from a default domain to an
> > > unmanaged domain when the device is assigned to the guest?
> > >
> > > Even you want to r-setup the same mappings, you need to un-map all
> > > existing mappings, right?
> > >
> >
> > Hmm, I guess that's a (design) decision the KVM/QEMU/VFIO communities
> > need to take.
> > May be the patch could suppress the flooding till then?
>
> No, this is wrong.  The pte values should not exist, it doesn't matter
> that they're the same.  Is the host driver failing to remove mappings
> and somehow they persist in the new vfio owned domain?  There's
> definitely a bug beyond logging going on here.  Thanks,
>
> Alex
>
