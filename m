Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD98B54CACD
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355707AbiFOODm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355862AbiFOODA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E1D6638F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655301754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZS4DJmuD0Oig/XR1uUnL7+FP6te8eTyWXHDcizxyNM=;
        b=TYQmjwI7UK1joN7rQpmA8oZ9/6Us+KZ8RL1vtR785IS2TiylgNQ5Xf3egiTFxgTrD9vUCO
        SZ8aPEn+RwlUv22dgpag43JGOFS6/0WN2cdo24Knr+s9qHWuOaJJojFXt23W7mbkQH2Yc5
        JOu2wVMa5CLBUiseczsQuEaHdIodm9M=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-z2e7KgwSNMqOkXo8BGPckg-1; Wed, 15 Jun 2022 10:02:33 -0400
X-MC-Unique: z2e7KgwSNMqOkXo8BGPckg-1
Received: by mail-io1-f70.google.com with SMTP id l7-20020a6b7007000000b00669b2a0d497so6157425ioc.0
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HZS4DJmuD0Oig/XR1uUnL7+FP6te8eTyWXHDcizxyNM=;
        b=jG0v+G/HVl7pD2Gu2mp8d+8MObiBQJv5/u8Zs3eRQRF0ODcEolBLNIWVjkVPVzW9BD
         CtukHxL1khWtjHhYBQz+uj8WRLFQjC+mPCZQGM9wrdwvYej1vEXafPI9sJZCaRhMxPBn
         NDrRsK8k2yIvUfdu8vjxuiz5X1Ev43b9Tk3gQQvx5ytqH4ZJCcgdLni6Bl5XeyUYCAMM
         97t5RNbvt9jTQNx7y6/3vk3hjnEDASf2o+Fo/V2lapIXidkmC0u1qdaSKRIY6DN/Lh2/
         ZCRceIwxm9cvmYjwLfo0hVYhAwf2ZrbKUDTB6rNut8IaOyecghkMSLyWC4aBqU/ZcuuO
         1sPw==
X-Gm-Message-State: AJIora/KjZWyfTM/zzL8iDSjObz5C2tYahE+ZM45eEcKMNeAivF37s7E
        s4yP9ygEDzcyUVs5b7KKqgh/mwGFNLQvKReVfwjWTZ2EzMrAtVbhonS4P+iac1iFGp5V6tOM8uE
        uW4DG87zcthBW
X-Received: by 2002:a05:6638:3284:b0:335:b861:a6aa with SMTP id f4-20020a056638328400b00335b861a6aamr3241493jav.19.1655301751845;
        Wed, 15 Jun 2022 07:02:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tvO0iOQCgXp+koCGK1WOiWGDNDUEGhXfoma0D3gy7sUXh9ITqvEwnxJ/rKadWbissgPktcpg==
X-Received: by 2002:a05:6638:3284:b0:335:b861:a6aa with SMTP id f4-20020a056638328400b00335b861a6aamr3241471jav.19.1655301751567;
        Wed, 15 Jun 2022 07:02:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d29-20020a023f1d000000b0032e5205f4e7sm3011368jaa.4.2022.06.15.07.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 07:02:30 -0700 (PDT)
Date:   Wed, 15 Jun 2022 08:02:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <akpm@linux-foundation.org>, jason Gunthorpe <jgg@nvidia.com>,
        maor Gottlieb <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <idok@nvidia.com>,
        <linux-mm@kvack.org>
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Message-ID: <20220615080228.7a5e7552.alex.williamson@redhat.com>
In-Reply-To: <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
        <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Jun 2022 13:52:10 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Adding some extra relevant people from the MM area.
>=20
> On 15/06/2022 13:43, Yishai Hadas wrote:
> > Hi All,
> >
> > Any idea what could cause the below break in 5.19 ? we run QEMU and=20
> > immediately the machine is stuck.
> >
> > Once I run, echo l > /proc/sysrq-trigger could see the below task=20
> > which seems to be stuck..
> >
> > This basic flow worked fine in 5.18.

Spent Friday bisecting this and posted this fix:

https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@=
omen/

I expect you're hotting the same.  Thanks,

Alex

> >
> > [1162.056583] NMI backtrace for cpu 4
> > [ 1162.056585] CPU: 4 PID: 1979 Comm: qemu-system-x86 Not tainted=20
> > 5.19.0-rc1 #747
> > [ 1162.056587] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),=20
> > BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> > [ 1162.056588] RIP: 0010:pmd_huge+0x0/0x20
> > [ 1162.056592] Code: 49 89 44 24 28 48 8b 47 30 49 89 44 24 30 31 c0=20
> > 41 5c c3 5b b8 01 00 00 00 5d 41 5c c3 cc cc cc cc cc cc cc cc cc cc=20
> > cc cc cc <0f> 1f 44 00 00 31 c0 48 f7 c7 9f ff ff ff 74 0f 81 e7 81 00=
=20
> > 00 00
> > [ 1162.056594] RSP: 0018:ffff888146253b38 EFLAGS: 00000202
> > [ 1162.056596] RAX: ffff888101461980 RBX: ffff888146253bc0 RCX:=20
> > 000ffffffffff000
> > [ 1162.056597] RDX: ffff88814fa22000 RSI: 00007f9f68231000 RDI:=20
> > 000000010a6b6067
> > [ 1162.056598] RBP: ffff888111b90dc0 R08: 000000000002f424 R09:=20
> > 0000000000000001
> > [ 1162.056599] R10: ffffffff825c2a40 R11: 0000000000000a08 R12:=20
> > ffff88814fa22a08
> > [ 1162.056600] R13: 000000010a6b6067 R14: 0000000000052202 R15:=20
> > 00007f9f68231000
> > [ 1162.056602] FS:=C2=A0 00007f9f6c228c40(0000) GS:ffff88885f900000(000=
0)=20
> > knlGS:0000000000000000
> > [ 1162.056605] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1162.056606] CR2: 00005643994fd0ed CR3: 00000001496da005 CR4:=20
> > 0000000000372ea0
> > [ 1162.056607] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
> > 0000000000000000
> > [ 1162.056609] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
> > 0000000000000400
> > [ 1162.056610] Call Trace:
> > [ 1162.056611]=C2=A0 <TASK>
> > [ 1162.056611]=C2=A0 follow_page_mask+0x196/0x5e0
> > [ 1162.056615]=C2=A0 __get_user_pages+0x190/0x5d0
> > [ 1162.056617]=C2=A0 ? flush_workqueue_prep_pwqs+0x110/0x110
> > [ 1162.056620]=C2=A0 __gup_longterm_locked+0xaf/0x470
> > [ 1162.056624]=C2=A0 vaddr_get_pfns+0x8e/0x240 [vfio_iommu_type1]
> > [ 1162.056628]=C2=A0 ? qi_flush_iotlb+0x83/0xa0
> > [ 1162.056631]=C2=A0 vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type=
1]
> > [ 1162.056634]=C2=A0 vfio_iommu_type1_ioctl+0x421/0x14f0 [vfio_iommu_ty=
pe1]
> > [ 1162.056638]=C2=A0 __x64_sys_ioctl+0x3e4/0x8e0
> > [ 1162.056641]=C2=A0 do_syscall_64+0x3d/0x90
> > [ 1162.056644]=C2=A0 entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > [ 1162.056646] RIP: 0033:0x7f9f6d14317b
> > [ 1162.056648] Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00=20
> > 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00=20
> > 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89=
=20
> > 01 48
> > [ 1162.056650] RSP: 002b:00007fff4fca15b8 EFLAGS: 00000246 ORIG_RAX:=20
> > 0000000000000010
> > [ 1162.056652] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:=20
> > 00007f9f6d14317b
> > [ 1162.056653] RDX: 00007fff4fca1620 RSI: 0000000000003b71 RDI:=20
> > 000000000000001c
> > [ 1162.056654] RBP: 00007fff4fca1650 R08: 0000000000000001 R09:=20
> > 0000000000000000
> > [ 1162.056655] R10: 0000000100000000 R11: 0000000000000246 R12:=20
> > 0000000000000000
> > [ 1162.056656] R13: 0000000000000000 R14: 0000000000000000 R15:=20
> > 0000000000000000
> > [ 1162.056657]=C2=A0 </TASK>
> >
> > Yishai
> > =20
>=20

