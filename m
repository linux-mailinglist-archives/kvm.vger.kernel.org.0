Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A677AFA13
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 07:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjI0F3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 01:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjI0F3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 01:29:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6228895;
        Tue, 26 Sep 2023 22:29:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHf0l+7MGug6lSSmarCDJsXM/14Q7sQmQki5zomdgFWA8gIlJn16YyCkQ8n6St5jTxPLK6ca+fHD9VIPIg4lQxRbxu0kMNuaDDvrraZK+j3SwwxzhkEacbge0enb/LmmqzJ5FnPEtLpemuMx+j4JkUhrcV4dSBBynG4ulRic7+UO5FFSPoDKMcbX+s3j1gAREtSH31jtp7nDQRfZi5ZqsgE7iEmB0oaTRvZlA/KicRe12Tqcl/Gy/4UcAFvNCONZMwb50iY7Ju/lTysp9otXrQe4vFfKsawO72fKS17+2Ktx4zdNnLhNnvm7Ib11fI0bslha8oPkW86cMvExqWkATQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9QXXFI/IR7A0H/qHr/ppVt/dv/3Q4R0YRp8RUp9/lY=;
 b=cngX7rHJMM0p8xrCVllw6+Aga3Ss8G92k4OXJXfdMTJwIbfvAFmMw/LzfpsQaeP0SGW+Cz3/ArrPxJGcGI4Fs5W9GbL8aDZa8JRRxf/Iqvd0uEEXWfceDHvrbM2UUBkmiaDXRksNCNYkaFqBOpT4+F9n/0dp1Xxoyurfx92wx+3CnwOFgZs4+aJAMtd6KCn6UYW8VxaMv23w08mNUqeDWyESg2RRuEwAC1B7jdYqYauoSbl7DOqiiwBxwQQo6cOqv9bzlF3be/kYxIt5m+kSveApvIUI9LWrdF0uU1VdlUPQp1/ZOGRwU37VnZ19JXquC7/5QsHDw6UzV6OBowrWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9QXXFI/IR7A0H/qHr/ppVt/dv/3Q4R0YRp8RUp9/lY=;
 b=NTbyUkjdPeVZGEadGZuxDdni/n88AjmUHYheFS9yKw3Fhzv63M+teDYymppzcXLV7bVTokKZpJ5NRy3nBSIaRtjUYL86oJKbgtoUYjujEMI3JxvnUBQoQvBShxwgy/ZGThAXaJbpS/dxt4b1m7vSoL4e7UrquVlgnQKfi1swazs=
Received: from MW2PR16CA0066.namprd16.prod.outlook.com (2603:10b6:907:1::43)
 by DM4PR12MB6208.namprd12.prod.outlook.com (2603:10b6:8:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 27 Sep
 2023 05:29:06 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:907:1:cafe::f7) by MW2PR16CA0066.outlook.office365.com
 (2603:10b6:907:1::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 05:29:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Wed, 27 Sep 2023 05:29:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 00:29:03 -0500
Date:   Wed, 27 Sep 2023 00:28:23 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eperezma@redhat.com>, <jasowang@redhat.com>,
        <shannon.nelson@amd.com>, <yuanyaogoog@chromium.org>,
        <yuehaibing@huawei.com>, Thomas Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [GIT PULL] virtio: features
Message-ID: <20230927052823.d46gc7wjbpfnykpr@amd.com>
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <20230926130451.axgodaa6tvwqs3ut@amd.com>
 <1695779259.7440922-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1695779259.7440922-1-xuanzhuo@linux.alibaba.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0c937f-cdef-40c8-c742-08dbbf1aaad9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJWtBsTLEWT37Zi5s+S2DOMyA18DcL5CNj0RFTXjYokCQgoMPTwtBdhyQBXJ/yuHNlAV1LIIW8hkXhQ/UQ3LkyU796GS3v1lX6c/i5O8Pk3QOKlITrB23t7ZrUzvADcQlO65wRR4hcIoJESYoH/zf1A++m1zkiGJpbGrD21z/ht43HTBenmDEEZ+HU70KyW2IvRyuf94/qjI78Qi5AXnpN2q3jfZ4ACyASFMqCWazxn6hGDNGYyPtcpJaSdXSfw4CXA7NU5qcb8UVCAIfvIharcpyokk80sbj1IlpOqwL1IadgZ3ydvTuhQhNZx+Ej6MiAMiku8a1NhbJ6nhBUqwcNzkkl2FqDhwhrZW04I8KW/5dd4pUTno5H23SMmkxhMnfo3hR5xpWQ7G/Pgmeg5CtZwpbYM77IdULq+EQ1GGD4Z0W7XHGJAAMsbhrIZfbkllHeOVst+vuf3OGI7cFUAUrVJTtnDKRU9I7Sv2b0ZtODc/xepzRlTObF2hLhZ4isC3NoGp3NfdYLwdqSeFmSTwIHOu7H3F45oVvZzOc/H1LgM6hFDJwANShLFh4hbvmUTvDvUeFE8EHBrU0nUbnT11yPXILsjCYsptnt3aW3CdYYBpjKAePHYzNmEjqkxnCA9ghRyNvG7g/pxL/vwXW8SIsgR9Ij7iPXZQYPk6N47TNw8HWPLS11wpynwmDJks5zjSBD6IgZCg7awClY6kfoJ+xLhmuUwzmsyxpeC7lcbSQ6VX9txfznmFVjBKPaWnyIFQ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(82310400011)(46966006)(40470700004)(36840700001)(5660300002)(81166007)(36860700001)(44832011)(47076005)(8676002)(4326008)(8936002)(356005)(82740400003)(83380400001)(41300700001)(54906003)(70206006)(70586007)(7416002)(26005)(316002)(16526019)(1076003)(66574015)(426003)(6916009)(336012)(2906002)(86362001)(40460700003)(66899024)(478600001)(6666004)(36756003)(40480700001)(966005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 05:29:05.7948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0c937f-cdef-40c8-c742-08dbbf1aaad9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 09:47:39AM +0800, Xuan Zhuo wrote:
> On Tue, 26 Sep 2023 08:04:51 -0500, Michael Roth <michael.roth@amd.com> wrote:
> > On Sun, Sep 03, 2023 at 06:13:38PM -0400, Michael S. Tsirkin wrote:
> > > The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:
> > >
> > >   Linux 6.5 (2023-08-27 14:49:51 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > >
> > > for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:
> > >
> > >   virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-03 18:10:24 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: features
> > >
> > > a small pull request this time around, mostly because the
> > > vduse network got postponed to next relase so we can be sure
> > > we got the security store right.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > ----------------------------------------------------------------
> > > Eugenio P閞ez (4):
> > >       vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> > >       vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature
> > >       vdpa: add get_backend_features vdpa operation
> > >       vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> > >
> > > Jason Wang (1):
> > >       virtio_vdpa: build affinity masks conditionally
> > >
> > > Xuan Zhuo (12):
> > >       virtio_ring: check use_dma_api before unmap desc for indirect
> > >       virtio_ring: put mapping error check in vring_map_one_sg
> > >       virtio_ring: introduce virtqueue_set_dma_premapped()
> > >       virtio_ring: support add premapped buf
> > >       virtio_ring: introduce virtqueue_dma_dev()
> > >       virtio_ring: skip unmap for premapped
> > >       virtio_ring: correct the expression of the description of virtqueue_resize()
> > >       virtio_ring: separate the logic of reset/enable from virtqueue_resize
> > >       virtio_ring: introduce virtqueue_reset()
> > >       virtio_ring: introduce dma map api for virtqueue
> > >       virtio_ring: introduce dma sync api for virtqueue
> > >       virtio_net: merge dma operations when filling mergeable buffers
> >
> > This ^ patch (upstream commit 295525e29a) seems to cause a
> > network-related regression when using SWIOTLB in the guest. I noticed
> > this initially testing SEV guests, which use SWIOTLB by default, but
> > it can also be seen with normal guests when forcing SWIOTLB via
> > swiotlb=force kernel cmdline option. I see it with both 6.6-rc1 and
> > 6.6-rc2 (haven't tried rc3 yet, but don't see any related changes
> > there), and reverting 714073495f seems to avoid the issue.
> >
> > Steps to reproduce:
> >
> > 1) Boot QEMU/KVM guest with 6.6-rc2 with swiotlb=force via something like the following cmdline:
> >
> >    qemu-system-x86_64 \
> >    -machine q35 -smp 4,maxcpus=255 -cpu EPYC-Milan-v2 \
> >    -enable-kvm -m 16G,slots=5,maxmem=256G -vga none \
> >    -device virtio-scsi-pci,id=scsi0,disable-legacy=on,iommu_platform=true \
> >    -drive file=/home/mroth/storage/ubuntu-18.04-seves2.qcow2,if=none,id=drive0,snapshot=off \
> >    -device scsi-hd,id=hd0,drive=drive0,bus=scsi0.0 \
> >    -device virtio-net-pci,netdev=netdev0,id=net0,disable-legacy=on,iommu_platform=true,romfile= \
> >    -netdev tap,script=/home/mroth/qemu-ifup,id=netdev0 \
> >    -L /home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/qemu \
> >    -drive if=pflash,format=raw,unit=0,file=/home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/qemu/OVMF_CODE.fd,readonly \
> >    -drive if=pflash,format=raw,unit=1,file=/home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/qemu/OVMF_VARS.fd \
> >    -debugcon file:debug.log -global isa-debugcon.iobase=0x402 -msg timestamp=on \
> >    -kernel /boot/vmlinuz-6.6.0-rc2-vanilla0+ \
> >    -initrd /boot/initrd.img-6.6.0-rc2-vanilla0+ \
> >    -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8 earlyprintk=serial,ttyS0,115200 debug=1 sev=debug page_poison=0 spec_rstack_overflow=off swiotlb=force"
> >
> > 2) scp a small file from the host to the guest IP via its virtio-net device.
> >    Smaller file sizes succeed, but the larger the file the more likely
> >    it will fail. e.g.:
> >
> >    mroth@host:~$ dd if=/dev/zero of=test bs=1K count=19
> >    19+0 records in
> >    19+0 records out
> >    19456 bytes (19 kB, 19 KiB) copied, 0.000940134 s, 20.7 MB/s
> >    mroth@host:~$ scp test vm0:
> >    test                                                                    100%   19KB  10.1MB/s   00:00
> >    mroth@host:~$ dd if=/dev/zero of=test bs=1K count=20
> >    20+0 records in
> >    20+0 records out
> >    20480 bytes (20 kB, 20 KiB) copied, 0.00093774 s, 21.8 MB/s
> >    mroth@host:~$ scp test vm0:
> >    test                                                                      0%    0     0.0KB/s   --:-- ETA
> >    client_loop: send disconnect: Broken pipe
> >    lost connection
> >    mroth@host:~$
> 
> 
> Hi Michael,
> 
> Thanks for the report.
> 
> Cloud you try this fix?  I reproduce this issue, and that works for me.

Hello,

This seems to resolve the issue for me.

Thanks for the quick fix.

-Mike

> Thanks.
> 
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 98dc9b49d56b..9ece27dc5144 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -589,16 +589,16 @@ static void virtnet_rq_unmap(struct receive_queue *rq, void *buf, u32 len)
> 
>         --dma->ref;
> 
> -       if (dma->ref) {
> -               if (dma->need_sync && len) {
> -                       offset = buf - (head + sizeof(*dma));
> +       if (dma->need_sync && len) {
> +               offset = buf - (head + sizeof(*dma));
> 
> -                       virtqueue_dma_sync_single_range_for_cpu(rq->vq, dma->addr, offset,
> -                                                               len, DMA_FROM_DEVICE);
> -               }
> +               virtqueue_dma_sync_single_range_for_cpu(rq->vq, dma->addr,
> +                                                       offset, len,
> +                                                       DMA_FROM_DEVICE);
> +       }
> 
> +       if (dma->ref)
>                 return;
> -       }
> 
>         virtqueue_dma_unmap_single_attrs(rq->vq, dma->addr, dma->len,
>                                          DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> 
> 
> >
> > Thanks,
> >
> > Mike
> >
> > >
> > > Yuan Yao (1):
> > >       virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
> > >
> > > Yue Haibing (1):
> > >       vdpa/mlx5: Remove unused function declarations
> > >
> > >  drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
> > >  drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
> > >  drivers/vhost/vdpa.c               |  15 +-
> > >  drivers/virtio/virtio_ring.c       | 412 ++++++++++++++++++++++++++++++++-----
> > >  drivers/virtio/virtio_vdpa.c       |  17 +-
> > >  include/linux/vdpa.h               |   4 +
> > >  include/linux/virtio.h             |  22 ++
> > >  include/uapi/linux/vhost_types.h   |   4 +
> > >  9 files changed, 625 insertions(+), 90 deletions(-)
> > >
