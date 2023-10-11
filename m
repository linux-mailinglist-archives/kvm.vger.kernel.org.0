Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09597C4C38
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345404AbjJKHpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 03:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345475AbjJKHpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 03:45:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53762AC
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 00:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIvPB8UE4DmUiE+NlU2QSW5t1lJnOCkHEkOTfyo1AewWMmwFJW20HcKgFBAYf725ERuJ1AOWjA8/MsuN7vQVzD4hep07aMml0E5LNBYx95WaS1Cf+ahlZI0BT51eAirSXjqmkldtZf7g0rS2/sRby4EPBmwW/hcPYP3XM/QhH1aWc3WbmJIGo42DTzi9+fWvRni1FtWmwMhEBLhg/Eq/srgh9fp/KJZDhm3vTSwuHDvwbQZPmks3pwYmJOyxjjXzKMmyoSuHKVx67/NFHQl2f+98VL6i7PAlIye0rXtTvnKAclnKO6iP4j3RPVfgmhFSzggj52ntZPjkE3BiVXBFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRet0gxe7aaD75y9OL6DRmiiK4iAlbrGQcNBX4GjUO4=;
 b=FbdC3Bh/euRqKj/z4bVV8QLzfjI7Ib6STKtd3Tt1nwmKTwcIs64Q+w4k7FdUjQj7uiKncJ1sjUCz/gUen6z3QNjP2PwQQaX2XTt0Je2CngGOBliYgXCusPNOq9X6adISGiY2U/JG58IsMyVpdo8WxqatptnyKSO2D0RL68aZa+/1WeoNmd/HmEoJWGyQ1izNMdA+z18CHmfwYY+IVAZGdrFH3huofnAFw7eTAQT7ddOBDkYZU6lOStkCDQ82JsyO5cLyGqYboPh0YVwMOJWYR57GvHWoDLhesw0JL5WCS7NSSCBIOBUCUO1GajkmREq9vInbSDnwqE++/Zd7RJw1iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRet0gxe7aaD75y9OL6DRmiiK4iAlbrGQcNBX4GjUO4=;
 b=TB7WxPFVdh4r5qPItztdHGXn/QJBXGi8aXIMpvdVs16ktEh9w3DY09Im1dsZ1FAMYxyHSJK726+vC5IHlUdBYTAnG94WaJCNTwRZBO7NMoTSTOf8Vz0DpnYuSawzTBM8Z5FDchsqVGVSS6Mfq07vvOFCxHFsXGeMzF22k7K2NiKTZDhl7nY8bo/wozwOzQY62SKMRVPh/Eaao8LewQxz4MTGWskLZS3kGzx8LsdTaUqYN4ycNJcoVQWIn8S7o3udHbtRT9eud4OZrepMSlyZhENR7zX58JoGHc6FWWA7CZRLVgjOFr+nOE59x3O/fkp0jI5MF2SHNmiCj7B0YBwJ3A==
Received: from MW4PR04CA0390.namprd04.prod.outlook.com (2603:10b6:303:81::35)
 by SN7PR12MB8435.namprd12.prod.outlook.com (2603:10b6:806:2e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Wed, 11 Oct
 2023 07:45:12 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:303:81:cafe::b0) by MW4PR04CA0390.outlook.office365.com
 (2603:10b6:303:81::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37 via Frontend
 Transport; Wed, 11 Oct 2023 07:45:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 07:45:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 11 Oct
 2023 00:44:57 -0700
Received: from [172.27.15.31] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 11 Oct
 2023 00:44:52 -0700
Message-ID: <f4247e59-19cd-0d6b-7728-dd1175c9d968@nvidia.com>
Date:   Wed, 11 Oct 2023 10:44:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        <alex.williamson@redhat.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>
References: <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
 <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
 <20231010163914-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231010163914-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|SN7PR12MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: f14aac6d-aeb0-4a4a-dcb0-08dbca2e0009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgbbIbSckNEtGXr2etEkxQP7CYHmIWuFEA3xavLYRb1cRNS5Eu7bomWLzxqj5sP6dfNKshFgcAE4LxuumaY50IdPSVdxI4+jmPDPwQJR34+3S73NA/YeHfTCv226YChqT7IlcahTjFwQKnS+f8UoklvZN9lP6WF7AF3T0nDaCJTedlo256oybqC6G/yj8h9/KeG3tg3ZT9vGb2nCMSJmJ3jLn9AXJSgTHBGwrnxob7tsqVeNWhAFGfdAKlergL7G/xMZfY30vTTCJlEpFeC6Wl8mQfq9mQse9CuA0+v08ZOiNg10Cpa8+lezYIK3AN/3aGtNLzf5ZcFAH71xLaauIPAjo338xJBD2+SoxiYVQhGl0XqC9NpAqcEmFk0I4xjIodwnsuzcEua9wyNYMTi3E7PnDY8zmB3fi53UFxyMcHslZignYQW0dfR+SUYjfJUf4RM+1UAyyZPiFBSXjkN05ZHqQr/fvvKt4TC+ku8QrzzN73GNqXUSVnnmVyzKMbLgNM7lRb6UKDkJGOmd/QOwgiIf/MX+0WXYRfsYpiHtRafpf1iit96Q4bQP7asn/+MApZIKyyTVaQwZ9cFQbM2ciC4qBPfxtCU15HrNv4Rg0f8mug0Y7RPf8zJmsYGdeVRl2dKvpZZD0Rxp7BjgLVWyKL2KNFlZz9sarPslKtqeJgzXR+osECMQdRKmTbVxzx/nUB+LeMuBa3U17GSWCs+DLeEnZakyQAPDGWh0mmVfE9Yz9EpkzVQnLvP8osyVUpUNBFEeiIX9AUDSgPynK/GKCA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(82310400011)(46966006)(36840700001)(40470700004)(36860700001)(41300700001)(31686004)(2616005)(26005)(7636003)(16526019)(336012)(53546011)(426003)(40460700003)(31696002)(82740400003)(86362001)(5660300002)(36756003)(40480700001)(356005)(2906002)(4326008)(70586007)(6666004)(83380400001)(107886003)(47076005)(478600001)(8676002)(6916009)(316002)(54906003)(70206006)(16576012)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 07:45:11.9447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f14aac6d-aeb0-4a4a-dcb0-08dbca2e0009
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8435
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 23:42, Michael S. Tsirkin wrote:
> On Tue, Oct 10, 2023 at 07:09:08PM +0300, Yishai Hadas wrote:
>>>> Assuming that we'll put each command inside virtio as the generic layer, we
>>>> won't be able to call/use this API internally to get the PF as of cyclic
>>>> dependencies between the modules, link will fail.
> I just mean:
> virtio_admin_legacy_io_write(sruct pci_device *,  ....)
>
>
> internally it starts from vf gets the pf (or vf itself or whatever
> the transport is) sends command gets status returns.
>
> what is cyclic here?
>
virtio-pci depends on virtio [1].

If we put the commands in the generic layer as we expect it to be (i.e. 
virtio), then trying to call internally call for 
virtio_pci_vf_get_pf_dev() to get the PF from the VF will end-up by a 
linker cyclic error as of below [2].

As of that, someone can suggest to put the commands in virtio-pci, 
however this will fully bypass the generic layer of virtio and future 
clients won't be able to use it.

In addition, passing in the VF PCI pointer instead of the VF group 
member ID + the VIRTIO PF device, will require in the future to 
duplicate each command once we'll use SIOV devices.

Instead, we suggest the below API for the above example.

virtio_admin_legacy_io_write(virtio_device *virtio_dev,  u64 
group_member_id,  ....)

[1]

[yishaih@reg-l-vrt-209 linux]$ modinfo virtio-pci
filename: /lib/modules/6.6.0-rc2+/kernel/drivers/virtio/virtio_pci.ko
version:        1
license:        GPL
description:    virtio-pci
author:         Anthony Liguori <aliguori@us.ibm.com>
srcversion:     7355EAC9408D38891938391
alias:          pci:v00001AF4d*sv*sd*bc*sc*i*
depends: virtio_pci_modern_dev,virtio,virtio_ring,virtio_pci_legacy_dev
retpoline:      Y
intree:         Y
name:           virtio_pci
vermagic:       6.6.0-rc2+ SMP preempt mod_unload modversions
parm:           force_legacy:Force legacy mode for transitional virtio 1 
devices (bool)

[2]

depmod: ERROR: Cycle detected: virtio -> virtio_pci -> virtio
depmod: ERROR: Found 2 modules in dependency cycles!
make[2]: *** [scripts/Makefile.modinst:128: depmod] Error 1
make[1]: *** [/images/yishaih/src/kernel/linux/Makefile:1821: 
modules_install] Error 2

Yishai

