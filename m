Return-Path: <kvm+bounces-4657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FECA815F9A
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 15:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C629BB22239
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 14:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DAFB446D3;
	Sun, 17 Dec 2023 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oK8oFSAe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3263175F
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jo8Mdfh3xNecIdQecByFif+30sqgJ27zdlRiMNa5ePW88k4DV0LhxOqMDSKkKm1JkQa80BiCRasTPnmFQ/mm8cg7tI9A5+qFS8YfB0zvqSWib9hICHU/TQWxwgbnR0+t0yHfcFKeEwFootsl5we8l2tduu7pq2vRZJsLIiJUBOATY+v6DKw4mbkGZNr/FE75DXsE/0fi/ctAUTyMGG/mnMjGF5z/+m2M9e6tyDZwRwbXUbgQr7690cHjuWnx4vWBiEAvVHXyy1xIBhbtw4Xg6zspq/o9M1gE3WMK1Ugx3wAuRvvMXiMVB8ghyukCaJItvBxoHgLfAKDQHNH3jYyXtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eerdp+DlYX9KQjf/iWSrFqKec47sGUsaniM99f5sKDQ=;
 b=SEwN2r8j8bAefZN99In/EEIj5jVJGjTQli4kDo87GF+oC5IqV83Fkf1SQkowpnaePfs5o9v3xY60rA1f+3t0Us8/kHlYCn0x7G/r+brgOWiWPk3ysX/CS2mWX88VcNFpc+r57Ugb+WKhw5I9XRJgqlYgOte9B1LAOoi6fE1FmuIv1VXEoLbMFcKQlIIAywZHor/Okf6grSIodBtemtbygKqJHN5+P5CsIppPRBC+m7a62PofEsV86NslP9VCm2ruY0SamrCmIS6xMm9y3EiPY0J2bIMmsagGwu8HrdVLZIXnOxnCqy7cHxAybr3LZCiW8xxJLC0V+danH664bsDmQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eerdp+DlYX9KQjf/iWSrFqKec47sGUsaniM99f5sKDQ=;
 b=oK8oFSAedobvHc1bBhWQ3rs4c79mZXrkD402i1P6a8l/2e107CzA8fmBLcpXK0henrQtIZSy1r8RQZGYU3DOxlETIOBybZxqZdtGRKBGphV7SpHMniAhOHXPSivdPyOOj10DHc3MjNbCXHJge77G1SjoIPWNUAKiOUO87sBJPrrkW77jHBXNrX+2zeEAvbawvZYRliCB+28IvyJRbV6yyay0/uvlvcZIAa11w8VaYLAB/JAQe4YZ87z/LsIDVefS4n0/kWnGgpkx/gE/MdGFw4jn4RGx/ce6bS81x9d5+LKtkDhLRtWySw+iuTfGmYtGzM7KQLM/RsdUek24bIXJ4g==
Received: from CH5PR02CA0004.namprd02.prod.outlook.com (2603:10b6:610:1ed::21)
 by SJ2PR12MB7799.namprd12.prod.outlook.com (2603:10b6:a03:4d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.36; Sun, 17 Dec
 2023 14:18:51 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::93) by CH5PR02CA0004.outlook.office365.com
 (2603:10b6:610:1ed::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37 via Frontend
 Transport; Sun, 17 Dec 2023 14:18:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Sun, 17 Dec 2023 14:18:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 17 Dec
 2023 06:18:41 -0800
Received: from [172.27.34.165] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 17 Dec
 2023 06:18:37 -0800
Message-ID: <2265f58c-f143-4765-af14-08d57e30161f@nvidia.com>
Date: Sun, 17 Dec 2023 16:18:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
	<maorg@nvidia.com>
References: <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
 <20231214075905.59a4a3ba.alex.williamson@redhat.com>
 <20231214100403-mutt-send-email-mst@kernel.org>
 <5b596e34-aac9-4786-8f13-4d85986803f0@nvidia.com>
 <20231214091501.4f843335.alex.williamson@redhat.com>
 <c838ad5a-e6ba-4b8e-a9a2-5d43da0ba5a4@nvidia.com>
 <20231214113649-mutt-send-email-mst@kernel.org>
 <efeff6cc-0df0-4572-8f05-2f16f4ac4b07@nvidia.com>
 <20231217071404-mutt-send-email-mst@kernel.org>
 <eac38d11-0dd3-4f56-95a3-75a1aea65d3b@nvidia.com>
 <20231217083750-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231217083750-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|SJ2PR12MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: f01cc588-f5ef-4311-d811-08dbff0b1795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lVOb0xFHvu6kj8i4WvyUORtbjf/CbjCdJOAhRVwRdpQF4hZjU7ci2X9O5nDeYT4WmA0y2wENWKgbgYip2DnbFq0asIKk8LuMYCF2VrC9hq3u4rKM/OzGVNY3ZI+WV16rUJ463nZs6uSxR5K7wBfVriD5smwJZsezz3osaqwpbw0RsM07oQymzHhA7tViPj5ncV328O6MK68dlgg3gJBJzjWk6eELpw3sW4s6EgAoqo7ePTEEtkngRQ2lQn7mzkhqfSkpKTJqOPyRcXFJ4ElgdGcx8hD9sWn8k495RF8NvoO/InRXlXMWSYemw4dsirGt+rMBimS7GzrypuFgpKpV+wsZlY9zJd4gZETO4hi5G1Qd0D/ylhcZPOj/gU1ZTC/UW7EqqS/dNmRbl6gIXQ63ctPqag778faphA/j5RqzZVMHwdURd+dICBvc2V5+G1cnlI/PKe6X90ORhFfVRj4wL5TDhMkKip8jkAHG+dJCF3xUn4F4pUkJ9tllPBxHLvNXeje0l+xkFkkpgfrZaukFVYJi1tmohafaolEjoXJk1yc9lrUuFPikTaRw1VSfUc7vXAf65ruIWw1dQJRU2Y2daAU3xQDO/Xw3KWCA0KVOU7Js4AH8Cpe8E5rgv6Fs0w3GwLckiRo93gWIxf73/5cNCyL1hL+2hx2iQVtISmmcTXO0iNfYz1ZW2MaqMDRopHQFK1pqVugYZ36k0P+sTVh9O125qFPZVuygY3e3rai7y4tX9qTG8M59ERDIaLo37x6q5j1bS4E+CDGBl0Ly8BoZQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(82310400011)(186009)(1800799012)(40470700004)(46966006)(36840700001)(2906002)(36860700001)(5660300002)(66899024)(31696002)(41300700001)(36756003)(86362001)(356005)(82740400003)(7636003)(70586007)(426003)(336012)(16526019)(26005)(40480700001)(107886003)(2616005)(83380400001)(16576012)(6916009)(478600001)(316002)(54906003)(70206006)(53546011)(31686004)(6666004)(40460700003)(4326008)(8676002)(8936002)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2023 14:18:50.7226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f01cc588-f5ef-4311-d811-08dbff0b1795
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7799

On 17/12/2023 15:42, Michael S. Tsirkin wrote:
> On Sun, Dec 17, 2023 at 03:20:30PM +0200, Yishai Hadas wrote:
>> On 17/12/2023 14:20, Michael S. Tsirkin wrote:
>>> On Sun, Dec 17, 2023 at 12:39:48PM +0200, Yishai Hadas wrote:
>>>> On 14/12/2023 18:40, Michael S. Tsirkin wrote:
>>>>> On Thu, Dec 14, 2023 at 06:25:25PM +0200, Yishai Hadas wrote:
>>>>>> On 14/12/2023 18:15, Alex Williamson wrote:
>>>>>>> On Thu, 14 Dec 2023 18:03:30 +0200
>>>>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>>>>>
>>>>>>>> On 14/12/2023 17:05, Michael S. Tsirkin wrote:
>>>>>>>>> On Thu, Dec 14, 2023 at 07:59:05AM -0700, Alex Williamson wrote:
>>>>>>>>>> On Thu, 14 Dec 2023 11:37:10 +0200
>>>>>>>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>>>>>>>>>>> OK, if so, we can come with the below extra code.
>>>>>>>>>>>>> Makes sense ?
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'll squash it as part of V8 to the relevant patch.
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>>>>> index 37a0035f8381..b652e91b9df4 100644
>>>>>>>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>>>>> @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>>>>>>>>>> *pdev)
>>>>>>>>>>>>>               struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>>>>>>>>>>               struct virtio_pci_device *vp_dev;
>>>>>>>>>>>>>
>>>>>>>>>>>>> +#ifndef CONFIG_X86
>>>>>>>>>>>>> +       return false;
>>>>>>>>>>>>> +#endif
>>>>>>>>>>>>>               if (!virtio_dev)
>>>>>>>>>>>>>                       return false;
>>>>>>>>>>>>>
>>>>>>>>>>>>> Yishai
>>>>>>>>>>>>
>>>>>>>>>>>> Isn't there going to be a bunch more dead code that compiler won't be
>>>>>>>>>>>> able to elide?
>>>>>>>>>>>
>>>>>>>>>>> On my setup the compiler didn't complain about dead-code (I simulated it
>>>>>>>>>>> by using ifdef CONFIG_X86 return false).
>>>>>>>>>>>
>>>>>>>>>>> However, if we suspect that some compiler might complain, we can come
>>>>>>>>>>> with the below instead.
>>>>>>>>>>>
>>>>>>>>>>> Do you prefer that ?
>>>>>>>>>>>
>>>>>>>>>>> index 37a0035f8381..53e29824d404 100644
>>>>>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>>>> @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct
>>>>>>>>>>> virtio_device *vdev)
>>>>>>>>>>>                BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>>>>>>>>>>>                BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>>>>>>>>>>>
>>>>>>>>>>> +#ifdef CONFIG_X86
>>>>>>>>>>>        /*
>>>>>>>>>>>         * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
>>>>>>>>>>>         * commands are supported
>>>>>>>>>>> @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>>>>>>>> *pdev)
>>>>>>>>>>>                       return true;
>>>>>>>>>>>               return false;
>>>>>>>>>>>        }
>>>>>>>>>>> +#else
>>>>>>>>>>> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
>>>>>>>>>>> +{
>>>>>>>>>>> +       return false;
>>>>>>>>>>> +}
>>>>>>>>>>> +#endif
>>>>>>>>>>>        EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
>>>>>>>>>>
>>>>>>>>>> Doesn't this also raise the question of the purpose of virtio-vfio-pci
>>>>>>>>>> on non-x86?  Without any other features it offers nothing over vfio-pci
>>>>>>>>>> and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
>>>>>>>>>> Thanks,
>>>>>>>>>>
>>>>>>>>>> Alex
>>>>>>>>>
>>>>>>>>> Kconfig dependency is what I had in mind, yes. The X86 specific code in
>>>>>>>>> virtio_pci_modern.c can be moved to a separate file then use makefile
>>>>>>>>> tricks to skip it on other platforms.
>>>>>>>>
>>>>>>>> The next feature for that driver will be the live migration support over
>>>>>>>> virtio, once the specification which is WIP those day will be accepted.
>>>>>>>>
>>>>>>>> The migration functionality is not X86 dependent and doesn't have the
>>>>>>>> legacy virtio driver limitations that enforced us to run only on X86.
>>>>>>>>
>>>>>>>> So, by that time we may need to enable in VFIO the loading of
>>>>>>>> virtio-vfio-pci driver and put back the ifdef X86 inside VIRTIO, only on
>>>>>>>> the legacy IO API, as I did already in V8.
>>>>>>>>
>>>>>>>> So using a KCONFIG solution in VFIO is a short term one, which will be
>>>>>>>> reverted just later on.
>>>>>>>
>>>>>>> I understand the intent, but I don't think that justifies building a
>>>>>>> driver that serves no purpose in the interim.  IF and when migration
>>>>>>> support becomes a reality, it's trivial to update the depends line.
>>>>>>>
>>>>>>
>>>>>> OK, so I'll add a KCONFIG dependency on X86 as you suggested as part of V9
>>>>>> inside VFIO.
>>>>>>
>>>>>>>> In addition, the virtio_pci_admin_has_legacy_io() API can be used in the
>>>>>>>> future not only by VFIO, this was one of the reasons to put it inside
>>>>>>>> VIRTIO.
>>>>>>>
>>>>>>> Maybe this should be governed by a new Kconfig option which would be
>>>>>>> selected by drivers like this.  Thanks,
>>>>>>>
>>>>>>
>>>>>> We can still keep the simple ifdef X86 inside VIRTIO for future users/usage
>>>>>> which is not only VFIO.
>>>>>>
>>>>>> Michael,
>>>>>> Can that work for you ?
>>>>>>
>>>>>> Yishai
>>>>>>
>>>>>>> Alex
>>>>>>>
>>>>>
>>>>> I am not sure what is proposed exactly. General admin q infrastructure
>>>>> can be kept as is. The legacy things however can never work outside X86.
>>>>> Best way to limit it to x86 is to move it to a separate file and
>>>>> only build that on X86. This way the only ifdef we need is where
>>>>> we set the flags to enable legacy commands.
>>>>>
>>>>>
>>>>
>>>> In VFIO we already agreed to add a dependency on X86 [1] as Alex asked.
>>>>
>>>> As VIRTIO should be ready for other clients and be self contained, I thought
>>>> to keep things simple and just return false from
>>>> virtio_pci_admin_has_legacy_io() in non X86 systems as was sent in V8.
>>>>
>>>> However, we can go with your approach as well and compile out all the legacy
>>>> IO stuff in non X86 systems by moving its code to a separate file (i.e.
>>>> virtio_pci_admin_legacy_io.c) and control this file upon the Makefile. In
>>>> addition, you suggested to control the 'supported_cmds' by an ifdef. This
>>>> will let the device know that we don't support legacy IO as well on non X86
>>>> systems.
>>>>
>>>> Please be aware that the above approach requires another ifdef on the H file
>>>> which exposes the 6 exported symbols and some further changes inside virtio
>>>> as of making vp_modern_admin_cmd_exec() non static as now we move the legacy
>>>> IO stuff to another C file, etc.
>>>>
>>>> Please see below how [2] it will look like.
>>>>
>>>> If you prefer that, so OK, it will be part of V9.
>>>> Please let me know.
>>>>
>>>>
>>>> [1] diff --git a/drivers/vfio/pci/virtio/Kconfig
>>>> b/drivers/vfio/pci/virtio/Kconfig
>>>> index 050473b0e5df..a3e5d8ea22a0 100644
>>>> --- a/drivers/vfio/pci/virtio/Kconfig
>>>> +++ b/drivers/vfio/pci/virtio/Kconfig
>>>> @@ -1,7 +1,7 @@
>>>>    # SPDX-License-Identifier: GPL-2.0-only
>>>>    config VIRTIO_VFIO_PCI
>>>>            tristate "VFIO support for VIRTIO NET PCI devices"
>>>> -        depends on VIRTIO_PCI
>>>> +        depends on X86 && VIRTIO_PCI
>>>>            select VFIO_PCI_CORE
>>>>            help
>>>>              This provides support for exposing VIRTIO NET VF devices which
>>>> support
>>>>
>>>> [2] diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
>>>> index 8e98d24917cc..a73358bb4ebb 100644
>>>> --- a/drivers/virtio/Makefile
>>>> +++ b/drivers/virtio/Makefile
>>>> @@ -7,6 +7,7 @@ obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
>>>>    obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
>>>>    virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
>>>>    virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
>>>> +virtio_pci-$(CONFIG_X86) += virtio_pci_admin_legacy_io.o
>>>>    obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
>>>>    obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
>>>>    obj-$(CONFIG_VIRTIO_VDPA) += virtio_vdpa.o
>>>> diff --git a/drivers/virtio/virtio_pci_common.h
>>>> b/drivers/virtio/virtio_pci_common.h
>>>> index af676b3b9907..9963e5d0e881 100644
>>>> --- a/drivers/virtio/virtio_pci_common.h
>>>> +++ b/drivers/virtio/virtio_pci_common.h
>>>> @@ -158,4 +158,14 @@ void virtio_pci_modern_remove(struct virtio_pci_device
>>>> *);
>>>>
>>>>    struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
>>>>
>>>> +#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
>>>> +       (BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
>>>> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
>>>> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
>>>> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>>>> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>>>> +
>>>
>>>
>>> I'd add something like:
>>>
>>> #ifdef CONFIG_X86
>>> #define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_LEGACY_ADMIN_CMD_BITMAP
>>> #else
>>> #define VIRTIO_ADMIN_CMD_BITMAP 0
>>> #endif
>>>
>>
>> This new macro (i.e. VIRTIO_ADMIN_CMD_BITMAP) will hold in the future
>> another sets of supported bits (e.g. Live migration), right ?
> 
> 
> That's my idea, yes.
> 
>>> Add a comment explaining why, please.
>>
>> OK
>>
>> How about the below ?
>>
>> "As of some limitations in the legacy driver (e.g. lack of memory
>> barriers in ARM, endian-ness is broken in PPC) the supported legacy IO
>> commands are masked out on non x86 systems."
> 
> Some grammar corrections and clarifications:
> 
> Unlike modern drivers which support hardware virtio devices, legacy
> drivers assume software-based devices: e.g. they don't use proper memory
> barriers on ARM, use big endian on PPC, etc. X86 drivers are mostly ok
> though, more or less by chance. For now, only support legacy IO on x86.

OK, thanks, I'll use the above.

Note:
I may use it also as part of the commit log (next patch) where we'll 
introduce the legacy IO APIs only on X86 systems, to let it be claer why 
it was done.

Yishai

