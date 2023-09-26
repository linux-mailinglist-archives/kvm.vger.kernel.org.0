Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705947AEDA0
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 15:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjIZNFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbjIZNFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 09:05:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCA5124;
        Tue, 26 Sep 2023 06:05:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIihyGC+NLUhXhP1UQnZj1euXWMdGpnpIjh26U+100+i9kQHQqgSz8B8izhSpvdwwpL5Av1zazxvlX+aypshtNUjnpgjyIIgLUMLoKQbigPit52ee1IgLp1XMNw/Ul14NRPombnjsWjgbP2FaSKv4zJJWCWh1g+TMxSYsNHttKZ/v1TVkfyDPz0KgvXQzz6qoPGUW+1lU8cnVqzWNXonlqw6/WOdNfOAcngMfGqXN2Jq9ISXkhl/+kYoh23lgsEXAIAxNSBDAwgKAR24h9X8Eb1ZUER5AExUqF33Lbhma8Ewfxa7FMEAFrLjIZOnIx+tBLkktoRMbwkKx6GTcJoPsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TN7AuBNapyJO3h0gfnrRCH2u6zJHV/pVkUGVyov9Rik=;
 b=kKGJbBijl1RUe2zF8Gv0JgyUhMia9OdL6i8/lYK29h6w1DOSg/N36uBIE15RqasWwBIoE01M6dxMmhGJpkQk6I0dI2npMASzQGTNTE43msZ7Sg5tMb0R+Ffem5iDraxHP+1C27qMtgyh5fjgHdCM22+nnc8g4ab6+sDDrV/WWKa/AJIIZburztbu+bdfbFiz8AraOKODtVhyKzOMW12cmjLKSCRfosy054LNd3tB+LZmMQoFwpnZmNJ4Enbk0XNH9kwTCy6akVet2MFnpkUvX6lh1HzKZfVoiqs4758rescsOABGXDw3ouv0drg8kNlS7pHxfrNqZKlK8V1b+5hbmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN7AuBNapyJO3h0gfnrRCH2u6zJHV/pVkUGVyov9Rik=;
 b=JR9Lox58w2HaM7JRuJXtL9d4yGX7F5UUUZYiuiODCFJuvvAzrGOVxiGb5ZLXxyt+WyiGrnT+8UNndOkkk9tXIpgA/jfygEsysc1XXcj3azvfGOOyhhOTY35loD/2t06VPmWjIgbYUwZZm+ZBHQy/L+OL/1nIMbYe2Eb0YgiTvDM=
Received: from MN2PR01CA0005.prod.exchangelabs.com (2603:10b6:208:10c::18) by
 MN2PR12MB4501.namprd12.prod.outlook.com (2603:10b6:208:269::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Tue, 26 Sep
 2023 13:05:09 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:10c:cafe::9e) by MN2PR01CA0005.outlook.office365.com
 (2603:10b6:208:10c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Tue, 26 Sep 2023 13:05:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Tue, 26 Sep 2023 13:05:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 26 Sep
 2023 08:05:08 -0500
Date:   Tue, 26 Sep 2023 08:04:51 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eperezma@redhat.com>, <jasowang@redhat.com>,
        <shannon.nelson@amd.com>, <xuanzhuo@linux.alibaba.com>,
        <yuanyaogoog@chromium.org>, <yuehaibing@huawei.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>
Subject: Re: [GIT PULL] virtio: features
Message-ID: <20230926130451.axgodaa6tvwqs3ut@amd.com>
References: <20230903181338-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230903181338-mutt-send-email-mst@kernel.org>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|MN2PR12MB4501:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e4241d6-d3c5-48e8-ae4f-08dbbe91368d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FXK6tr7wr34euCInB0fojF3jAro3kWrAOYbfb4vnC3AZtcUoKNwhv5ob9am5JtPwB6F4TNMv0x/D4Ht8N5/3DxFaW+9qNhMDCkPzhdS60hp+dPUCqYjuJQbmSO2SRcXp+KMV5/57eU3gqh/fcw4w/ckVlEclSBP9hgSLAeFGWXvtD0TVrOOhaT1izJ61sX+1eyxdTQlx2I3tLxLPyJ317sxPgSiNz7mMvFXegS9rrbDjXp+CpdgoHMgkM0EXPtrDVbJBOr0aCKdNLZMG/gD+nD6wOIcHHJCRjTc3bCxejYKJ0bOJI/2hcEQ69jN2bnL8ZwHHt6WpwRQ2MTGJGVKKa5MM8OahR6wiYgg6mZ0nRlNOdGx6ci4iNN6IZ5C8r3cHaMx7qHE0orGGM8on//6EQaM69tjX10t1pZ/tcPfx7hIEZTaNJ2lPNnjUKHPO+661rhFGYpSxtqcmLCE2+9ru/W+KCxnI1Llam7smTD458RF4wD7RkdDSKIHJ5qyHevc/McKA6uESFAWh+Wix29aPJq5UpDPNtHmsxIy7gTbK8QqIDE9iNu+9VgfcRY3vkaDKYydN55GthKDNN3UJvbAcjtEXeGeFvousT8fPkylNX+pc6X+W6cKoE4HmQX018/CkhY+kWW3ju0wJoMcYibA77xNyK7v9uLAi1Z7x9FwfxDBuuY6es3hWN5vUHS0uto2Nfclu3P4RNxVDj8gbZt1oFT5Q4fuBoUrMS1/IssNDuV2q6ACTi/Qdy3uO/BeZYRqy
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(346002)(39860400002)(230922051799003)(186009)(451199024)(82310400011)(1800799009)(36840700001)(46966006)(40470700004)(40480700001)(83380400001)(66899024)(40460700003)(86362001)(47076005)(36860700001)(6666004)(966005)(478600001)(4326008)(36756003)(7416002)(82740400003)(356005)(2906002)(81166007)(5660300002)(44832011)(8676002)(41300700001)(54906003)(70206006)(6916009)(316002)(8936002)(70586007)(336012)(66574015)(2616005)(426003)(1076003)(26005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 13:05:09.6128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4241d6-d3c5-48e8-ae4f-08dbbe91368d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4501
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 03, 2023 at 06:13:38PM -0400, Michael S. Tsirkin wrote:
> The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:
> 
>   Linux 6.5 (2023-08-27 14:49:51 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:
> 
>   virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-03 18:10:24 -0400)
> 
> ----------------------------------------------------------------
> virtio: features
> 
> a small pull request this time around, mostly because the
> vduse network got postponed to next relase so we can be sure
> we got the security store right.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Eugenio Pérez (4):
>       vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
>       vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature
>       vdpa: add get_backend_features vdpa operation
>       vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> 
> Jason Wang (1):
>       virtio_vdpa: build affinity masks conditionally
> 
> Xuan Zhuo (12):
>       virtio_ring: check use_dma_api before unmap desc for indirect
>       virtio_ring: put mapping error check in vring_map_one_sg
>       virtio_ring: introduce virtqueue_set_dma_premapped()
>       virtio_ring: support add premapped buf
>       virtio_ring: introduce virtqueue_dma_dev()
>       virtio_ring: skip unmap for premapped
>       virtio_ring: correct the expression of the description of virtqueue_resize()
>       virtio_ring: separate the logic of reset/enable from virtqueue_resize
>       virtio_ring: introduce virtqueue_reset()
>       virtio_ring: introduce dma map api for virtqueue
>       virtio_ring: introduce dma sync api for virtqueue
>       virtio_net: merge dma operations when filling mergeable buffers

This ^ patch (upstream commit 295525e29a) seems to cause a
network-related regression when using SWIOTLB in the guest. I noticed
this initially testing SEV guests, which use SWIOTLB by default, but
it can also be seen with normal guests when forcing SWIOTLB via
swiotlb=force kernel cmdline option. I see it with both 6.6-rc1 and
6.6-rc2 (haven't tried rc3 yet, but don't see any related changes
there), and reverting 714073495f seems to avoid the issue.

Steps to reproduce:

1) Boot QEMU/KVM guest with 6.6-rc2 with swiotlb=force via something like the following cmdline:

   qemu-system-x86_64 \
   -machine q35 -smp 4,maxcpus=255 -cpu EPYC-Milan-v2 \
   -enable-kvm -m 16G,slots=5,maxmem=256G -vga none \
   -device virtio-scsi-pci,id=scsi0,disable-legacy=on,iommu_platform=true \
   -drive file=/home/mroth/storage/ubuntu-18.04-seves2.qcow2,if=none,id=drive0,snapshot=off \
   -device scsi-hd,id=hd0,drive=drive0,bus=scsi0.0 \
   -device virtio-net-pci,netdev=netdev0,id=net0,disable-legacy=on,iommu_platform=true,romfile= \
   -netdev tap,script=/home/mroth/qemu-ifup,id=netdev0 \
   -L /home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/qemu \
   -drive if=pflash,format=raw,unit=0,file=/home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/qemu/OVMF_CODE.fd,readonly \
   -drive if=pflash,format=raw,unit=1,file=/home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/qemu/OVMF_VARS.fd \
   -debugcon file:debug.log -global isa-debugcon.iobase=0x402 -msg timestamp=on \
   -kernel /boot/vmlinuz-6.6.0-rc2-vanilla0+ \
   -initrd /boot/initrd.img-6.6.0-rc2-vanilla0+ \
   -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8 earlyprintk=serial,ttyS0,115200 debug=1 sev=debug page_poison=0 spec_rstack_overflow=off swiotlb=force"

2) scp a small file from the host to the guest IP via its virtio-net device.
   Smaller file sizes succeed, but the larger the file the more likely
   it will fail. e.g.:

   mroth@host:~$ dd if=/dev/zero of=test bs=1K count=19
   19+0 records in
   19+0 records out
   19456 bytes (19 kB, 19 KiB) copied, 0.000940134 s, 20.7 MB/s
   mroth@host:~$ scp test vm0:
   test                                                                    100%   19KB  10.1MB/s   00:00
   mroth@host:~$ dd if=/dev/zero of=test bs=1K count=20
   20+0 records in
   20+0 records out
   20480 bytes (20 kB, 20 KiB) copied, 0.00093774 s, 21.8 MB/s
   mroth@host:~$ scp test vm0:
   test                                                                      0%    0     0.0KB/s   --:-- ETA
   client_loop: send disconnect: Broken pipe
   lost connection
   mroth@host:~$

Thanks,

Mike

> 
> Yuan Yao (1):
>       virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
> 
> Yue Haibing (1):
>       vdpa/mlx5: Remove unused function declarations
> 
>  drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
>  drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
>  drivers/vhost/vdpa.c               |  15 +-
>  drivers/virtio/virtio_ring.c       | 412 ++++++++++++++++++++++++++++++++-----
>  drivers/virtio/virtio_vdpa.c       |  17 +-
>  include/linux/vdpa.h               |   4 +
>  include/linux/virtio.h             |  22 ++
>  include/uapi/linux/vhost_types.h   |   4 +
>  9 files changed, 625 insertions(+), 90 deletions(-)
> 
