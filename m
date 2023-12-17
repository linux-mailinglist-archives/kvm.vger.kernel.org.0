Return-Path: <kvm+bounces-4651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6B1815E90
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 11:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0B091F21FD2
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 10:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7F463B6;
	Sun, 17 Dec 2023 10:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YCsJQjrB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303D0613C
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 10:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDtq8wBjKEGHMfd0+w8TrjNDVqW6pXCktr0MvEHH7YTakA29SZNZJChxCD5oozZvMGszOaoybIVthtUUHbfOYmDGpVkBeNfUY5bYq3tnJ9atgVQ9FaoIETFAaFlSAd+X+yIb8bw3xqEwotQmVxyHCEAZmyte6L6Xmjtmj26awJzEDT7iYaZFsPc/lvsP7UiTUQH6kXnyiqjNiYtkqSkpxLWv/NMfjK9BIr5aeI/8/kE9sWY/kfqPhHyz0FVQ0kkOtLXexTgDE5hsvktweXx6d0gYFTGpj4cMJGXvC+u5zPw6pIwnvA++kXFsSY9nBT9FaI5e/8sG4hbDNcnfmGeBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1z4ZeHC3LDOa2e2/KPZlomJc3oMfwD998yJ6YGAKao=;
 b=f6WQn9lB1xGLaXuDDfutduxw59kf4DhZpBtcfIkdSC129LZ3RZfBxkTHyVQUiXfZvM3j6tf69EnUynRY3GgDTbs4keT+ngCinW0l39idUZyzIvChgcKbxQXbbMsxv3iQEvHNihRhKcafUQ2LIQwzproX/ljnHR0q6HMtJDrble4LMp5cRJpaLwG5R9P/i2r574mDQpRcQqPOwyC2wDh5aZrD3aknTUKYPV/cO696Qhbwd/HA7uGgorisBicGQv2aWHayCaE7Abi3ZuV4v7K+xiMj+pGoB+4eisuzac5BKhLFjbPdBeU8uU1t2YEEeBk0rj1G6lBY7p1njmWVpstjpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1z4ZeHC3LDOa2e2/KPZlomJc3oMfwD998yJ6YGAKao=;
 b=YCsJQjrB1bG2PVK9TGmYsmT1CooFffdEeDyerxIpDa95ugY6zUMNINVG2U/5rWLmXLZT9appA57cSxrkK2imfLe63uju44KHIzPYldtuSoB8fqyFP0KYNKcVLBpRywdeWMdDXdkCET1XmxztGNT03RXbJryKEWnQA2BOfWThBZBQCeqUQJc0X6R9sKbqVVTuvKEBGkAeTuDzWPQUpyka/xcdqht8VAWfyGdcT8vwBdcwTJNvtZKZnP/PZcfWLDsDOLWzK99QIfqeOkPHHnJXEhrf2YTQ3EBT9JudJA6CL9ZIW0+xoudJ0iNgW/ovsSIViaDFmESyK7mqNBF3KdRXYg==
Received: from BLAPR03CA0172.namprd03.prod.outlook.com (2603:10b6:208:32f::12)
 by DM4PR12MB7694.namprd12.prod.outlook.com (2603:10b6:8:102::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.36; Sun, 17 Dec
 2023 10:40:05 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::d0) by BLAPR03CA0172.outlook.office365.com
 (2603:10b6:208:32f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.36 via Frontend
 Transport; Sun, 17 Dec 2023 10:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Sun, 17 Dec 2023 10:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 17 Dec
 2023 02:39:54 -0800
Received: from [172.27.34.165] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 17 Dec
 2023 02:39:50 -0800
Message-ID: <efeff6cc-0df0-4572-8f05-2f16f4ac4b07@nvidia.com>
Date: Sun, 17 Dec 2023 12:39:48 +0200
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
References: <20231207102820.74820-10-yishaih@nvidia.com>
 <20231214013642-mutt-send-email-mst@kernel.org>
 <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
 <20231214041515-mutt-send-email-mst@kernel.org>
 <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
 <20231214075905.59a4a3ba.alex.williamson@redhat.com>
 <20231214100403-mutt-send-email-mst@kernel.org>
 <5b596e34-aac9-4786-8f13-4d85986803f0@nvidia.com>
 <20231214091501.4f843335.alex.williamson@redhat.com>
 <c838ad5a-e6ba-4b8e-a9a2-5d43da0ba5a4@nvidia.com>
 <20231214113649-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231214113649-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|DM4PR12MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: 39571fbe-39d3-4af7-6dcc-08dbfeec87c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aylbzMoN1f3jU5GKlr0lUk25rMv9Ou5tLDo88BLDWRiqIhjQmDHrZrENfspHVft5d0BdR4oRm0GBgOJ383hGcNp8Znn2ADCt2cI33v7bEmEc/ceCGzxcCXBdhsGuSQsewiBA17VWdT0BnjJehEEDDBanrgmKHDy3yJiDi/OpQX6e8KqmRQV3CLRYZP0lb2/IROrfIXCN98e8D3SJClVNpGp6NGzpnm7aKPv20p5+XAeF1uZrYMn5ypYpnOwQzTPbb/DXF54x3AldFi0GA6aq/kqZQTNiIj1JNVUJlMV74JbBKxZdUunRR9TGg5AAsoAcN0MgOJQLHceIzQYuGmhV09UrabvV7i90LeBPZnRs/9tNhrk9AsZLg98Sx/Y6AWEDRLnsvzvtcILt0PK4C4lftsfhkyRNUYsRPmjTMy5PzPVjLOE+f5iPMPTOSmjmDrftD+CeexR1k5tH5+kY2EQIQKZAspFALSQ8OLTl0cKSkjx/4AFxWOhQkDp59XbJW5cSSeCiJagBj4RmEUCsbz6pSn0/xNucb0SLYzbvCFc5Bilu3+Te6jC7X5lfdlQEc47GshnvlZdGELcgc/XGkQlQn3cwqRC6Ux+7inmtMPZSZVfKzCtuf/XQo81i5AeAiBl2jny4uTDFTxJAhyoEIDyN71T4Ipy/Pza0aFqjVfedlGUDEN47RCRP5A/MxmSliyOfaWfTdQCaQFqYMTYCGZqnaqQmeHhCWaeOrSXayeyWiQR4MK72POyfUIJiInT78Xd7q8G8jsjPURNNa0AnfxO1hQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(136003)(346002)(230922051799003)(82310400011)(1800799012)(186009)(451199024)(64100799003)(36840700001)(46966006)(40470700004)(83380400001)(107886003)(2616005)(16576012)(6916009)(478600001)(316002)(54906003)(26005)(40480700001)(70586007)(70206006)(336012)(426003)(16526019)(4326008)(47076005)(8936002)(8676002)(53546011)(40460700003)(31686004)(36860700001)(66899024)(5660300002)(30864003)(2906002)(86362001)(7636003)(82740400003)(356005)(36756003)(41300700001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2023 10:40:04.4585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39571fbe-39d3-4af7-6dcc-08dbfeec87c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7694

On 14/12/2023 18:40, Michael S. Tsirkin wrote:
> On Thu, Dec 14, 2023 at 06:25:25PM +0200, Yishai Hadas wrote:
>> On 14/12/2023 18:15, Alex Williamson wrote:
>>> On Thu, 14 Dec 2023 18:03:30 +0200
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>
>>>> On 14/12/2023 17:05, Michael S. Tsirkin wrote:
>>>>> On Thu, Dec 14, 2023 at 07:59:05AM -0700, Alex Williamson wrote:
>>>>>> On Thu, 14 Dec 2023 11:37:10 +0200
>>>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>>>>>>> OK, if so, we can come with the below extra code.
>>>>>>>>> Makes sense ?
>>>>>>>>>
>>>>>>>>> I'll squash it as part of V8 to the relevant patch.
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>> index 37a0035f8381..b652e91b9df4 100644
>>>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>>>> @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>>>>>> *pdev)
>>>>>>>>>             struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>>>>>>             struct virtio_pci_device *vp_dev;
>>>>>>>>>
>>>>>>>>> +#ifndef CONFIG_X86
>>>>>>>>> +       return false;
>>>>>>>>> +#endif
>>>>>>>>>             if (!virtio_dev)
>>>>>>>>>                     return false;
>>>>>>>>>
>>>>>>>>> Yishai
>>>>>>>>
>>>>>>>> Isn't there going to be a bunch more dead code that compiler won't be
>>>>>>>> able to elide?
>>>>>>>
>>>>>>> On my setup the compiler didn't complain about dead-code (I simulated it
>>>>>>> by using ifdef CONFIG_X86 return false).
>>>>>>>
>>>>>>> However, if we suspect that some compiler might complain, we can come
>>>>>>> with the below instead.
>>>>>>>
>>>>>>> Do you prefer that ?
>>>>>>>
>>>>>>> index 37a0035f8381..53e29824d404 100644
>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>> @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct
>>>>>>> virtio_device *vdev)
>>>>>>>              BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>>>>>>>              BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>>>>>>>
>>>>>>> +#ifdef CONFIG_X86
>>>>>>>      /*
>>>>>>>       * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
>>>>>>>       * commands are supported
>>>>>>> @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>>>> *pdev)
>>>>>>>                     return true;
>>>>>>>             return false;
>>>>>>>      }
>>>>>>> +#else
>>>>>>> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
>>>>>>> +{
>>>>>>> +       return false;
>>>>>>> +}
>>>>>>> +#endif
>>>>>>>      EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
>>>>>>
>>>>>> Doesn't this also raise the question of the purpose of virtio-vfio-pci
>>>>>> on non-x86?  Without any other features it offers nothing over vfio-pci
>>>>>> and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
>>>>>> Thanks,
>>>>>>
>>>>>> Alex
>>>>>
>>>>> Kconfig dependency is what I had in mind, yes. The X86 specific code in
>>>>> virtio_pci_modern.c can be moved to a separate file then use makefile
>>>>> tricks to skip it on other platforms.
>>>>
>>>> The next feature for that driver will be the live migration support over
>>>> virtio, once the specification which is WIP those day will be accepted.
>>>>
>>>> The migration functionality is not X86 dependent and doesn't have the
>>>> legacy virtio driver limitations that enforced us to run only on X86.
>>>>
>>>> So, by that time we may need to enable in VFIO the loading of
>>>> virtio-vfio-pci driver and put back the ifdef X86 inside VIRTIO, only on
>>>> the legacy IO API, as I did already in V8.
>>>>
>>>> So using a KCONFIG solution in VFIO is a short term one, which will be
>>>> reverted just later on.
>>>
>>> I understand the intent, but I don't think that justifies building a
>>> driver that serves no purpose in the interim.  IF and when migration
>>> support becomes a reality, it's trivial to update the depends line.
>>>
>>
>> OK, so I'll add a KCONFIG dependency on X86 as you suggested as part of V9
>> inside VFIO.
>>
>>>> In addition, the virtio_pci_admin_has_legacy_io() API can be used in the
>>>> future not only by VFIO, this was one of the reasons to put it inside
>>>> VIRTIO.
>>>
>>> Maybe this should be governed by a new Kconfig option which would be
>>> selected by drivers like this.  Thanks,
>>>
>>
>> We can still keep the simple ifdef X86 inside VIRTIO for future users/usage
>> which is not only VFIO.
>>
>> Michael,
>> Can that work for you ?
>>
>> Yishai
>>
>>> Alex
>>>
> 
> I am not sure what is proposed exactly. General admin q infrastructure
> can be kept as is. The legacy things however can never work outside X86.
> Best way to limit it to x86 is to move it to a separate file and
> only build that on X86. This way the only ifdef we need is where
> we set the flags to enable legacy commands.
> 
> 

In VFIO we already agreed to add a dependency on X86 [1] as Alex asked.

As VIRTIO should be ready for other clients and be self contained, I 
thought to keep things simple and just return false from 
virtio_pci_admin_has_legacy_io() in non X86 systems as was sent in V8.

However, we can go with your approach as well and compile out all the 
legacy IO stuff in non X86 systems by moving its code to a separate file 
(i.e. virtio_pci_admin_legacy_io.c) and control this file upon the 
Makefile. In addition, you suggested to control the 'supported_cmds' by 
an ifdef. This will let the device know that we don't support legacy IO 
as well on non X86 systems.

Please be aware that the above approach requires another ifdef on the H 
file which exposes the 6 exported symbols and some further changes 
inside virtio as of making vp_modern_admin_cmd_exec() non static as now 
we move the legacy IO stuff to another C file, etc.

Please see below how [2] it will look like.

If you prefer that, so OK, it will be part of V9.
Please let me know.


[1] diff --git a/drivers/vfio/pci/virtio/Kconfig 
b/drivers/vfio/pci/virtio/Kconfig
index 050473b0e5df..a3e5d8ea22a0 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,7 +1,7 @@
  # SPDX-License-Identifier: GPL-2.0-only
  config VIRTIO_VFIO_PCI
          tristate "VFIO support for VIRTIO NET PCI devices"
-        depends on VIRTIO_PCI
+        depends on X86 && VIRTIO_PCI
          select VFIO_PCI_CORE
          help
            This provides support for exposing VIRTIO NET VF devices 
which support

[2] diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 8e98d24917cc..a73358bb4ebb 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
  obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
  virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
+virtio_pci-$(CONFIG_X86) += virtio_pci_admin_legacy_io.o
  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
  obj-$(CONFIG_VIRTIO_VDPA) += virtio_vdpa.o
diff --git a/drivers/virtio/virtio_pci_common.h 
b/drivers/virtio/virtio_pci_common.h
index af676b3b9907..9963e5d0e881 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -158,4 +158,14 @@ void virtio_pci_modern_remove(struct 
virtio_pci_device *);

  struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);

+#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
+       (BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
+        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
+        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
+        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
+        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
+
+int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+                            struct virtio_admin_cmd *cmd);
+
  #endif
diff --git a/drivers/virtio/virtio_pci_modern.c 
b/drivers/virtio/virtio_pci_modern.c
index 53e29824d404..defb6282e1d7 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -75,8 +75,8 @@ static int virtqueue_exec_admin_cmd(struct 
virtio_pci_admin_vq *admin_vq,
         return 0;
  }

-static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
-                                   struct virtio_admin_cmd *cmd)
+int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+                            struct virtio_admin_cmd *cmd)
  {
         struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -172,6 +172,9 @@ static void virtio_pci_admin_cmd_list_init(struct 
virtio_device *virtio_dev)
         if (ret)
                 goto end;

+#ifndef CONFIG_X86
+       *data &= ~(cpu_to_le64(VIRTIO_LEGACY_ADMIN_CMD_BITMAP));
+#endif
         sg_init_one(&data_sg, data, sizeof(*data));
         cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
         cmd.data_sg = &data_sg;
@@ -775,257 +778,6 @@ static void vp_modern_destroy_avq(struct 
virtio_device *vdev)
         vp_dev->del_vq(&vp_dev->admin_vq.info);
  }

-#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
-       (BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
-        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
-        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
-        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
-        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
-
-#ifdef CONFIG_X86
-/*
- * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
- * commands are supported
- * @dev: VF pci_dev
- *
- * Returns true on success.
- */
-bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
-{
-       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
-       struct virtio_pci_device *vp_dev;
-
-       if (!virtio_dev)
-               return false;
-
-       if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
-               return false;


<other deletion to the new file>
<other deletion to the new file>
..
..

diff --git a/drivers/virtio/virtio_pci_admin_legacy_io.c 
b/drivers/virtio/virtio_pci_admin_legacy_io.c
new file mode 100644
index 000000000000..c48eaaa7c086
--- /dev/null
+++ b/drivers/virtio/virtio_pci_admin_legacy_io.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include "virtio_pci_common.h"
+
+/*
+ * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
+ * commands are supported
+ * @dev: VF pci_dev
+ *
+ * Returns true on success.
+ */
+bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
+{
+       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+       struct virtio_pci_device *vp_dev;
+
+       if (!virtio_dev)
+               return false;
+
+       if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
+               return false;
+
+       vp_dev = to_vp_device(virtio_dev);
+
+       if ((vp_dev->admin_vq.supported_cmds & 
VIRTIO_LEGACY_ADMIN_CMD_BITMAP) ==
+               VIRTIO_LEGACY_ADMIN_CMD_BITMAP)
+               return true;
+       return false;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);


<other legacy IO code>
<other legacy IO code>
...
...


diff --git a/include/linux/virtio_pci_admin.h 
b/include/linux/virtio_pci_admin.h
index 446ced8cb050..0c9c1f336d3f 100644
--- a/include/linux/virtio_pci_admin.h
+++ b/include/linux/virtio_pci_admin.h
@@ -5,6 +5,7 @@
  #include <linux/types.h>
  #include <linux/pci.h>

+#ifdef CONFIG_X86
  bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev);
  int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 
offset,
                                             u8 size, u8 *buf);
@@ -17,5 +18,6 @@ int virtio_pci_admin_legacy_device_io_read(struct 
pci_dev *pdev, u8 offset,
  int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
                                            u8 req_bar_flags, u8 *bar,
                                            u64 *bar_offset);
+#endif

Yishai

