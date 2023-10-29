Return-Path: <kvm+bounces-28-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 958277DAD2E
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFF84B20E54
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1235D2EC;
	Sun, 29 Oct 2023 16:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m/x+sqvl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ABCD2E2
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:13:58 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FBEB6
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khJ0+DaHkXliHZ5U/2NcdggrQnzYYM4s88I2K8XaEh5oM1YfZTiJLVEinLQdXWXifOzCbqRKw/sfqSAlh+l3L3VYFY5tFqz8EUk2Azulkshj8P3YaKqtzbWyyKYhvGROZzymAx7it4F5+eoSHuvzMiWu6m2rAf4ifnxZiNHs1ovK2W3RLvgKICYg7iiZJpSN+bOKV7M6U+U3/vLYD84Tikt3hINnjWnEJTTv47meGIM8xegnIRZmNftvcOzlcU7XxvI67h0ImCA2wmy57v5qjgqyFfANGHUXWV/q2VA3EdHxBZN5+rZdRTyrUjmbfCRHuSMpVBnfu1NYQrPrWB4sUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OkBhi0ml8lucf/2kWOrpvA0yV1qpnF9OE7oxP9tlRI=;
 b=ScaEiZb7K+D6qk65Pt7kROKSlVph+6zfhFnYTSNEE2rFUc0tkpupFucLOz9mMlRvr4gPuwXce/SWs8FnWZfAtVjRRraJLavnxmcD46Swfq7ifIEDQlx2kKqkgbHfFYRKM4DO7m8f9+YfkbiJTMH3GJwMD8oDDY/M+o2io6LmVmfIrqp2O05pAVdOM2f/9bniSkChmJp8A7mt/J43sLnRuy5QWXQN+a25LP8V7zY3HKZsgvDEKOCNBBYoeFZUWo6WtEMkHDpC10sKISQCCtSUHjKsZK2KzcgWglXEZYY4GI/S7HuNla8G4v5bDa4SfHpJmoQFd3ufKns3S7d9o9s2eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OkBhi0ml8lucf/2kWOrpvA0yV1qpnF9OE7oxP9tlRI=;
 b=m/x+sqvl9sHfGa24g9S88jRDSCEBp2zR/hAKcsKJI+C+chsPHwezMBHk+OizGasLY0IQVOkfQO6yo+TZSS3phZPe2CLDOckbsGuwjEXbglNRiJASdGsvyA0bMHgBwhSq5rPSDXnuo7bLOPNjPbknQnTvHwvAlI+1EKk/jGUKOlEJnxTqyse2fH2EMCqq1pBC8PLuBu12HPBqF3ab1qbT8H7MyMUKi50qPsqAItInexCB3jWa3JMNXfB5jFWeZU4mZKNMU+e1jENN1mlT7zdG5WuDdFPm2+m8kjK80/ZrGtcL4NgjM2KjrKW8WILoomKSGsUqau5j56yK0B5QWa2KyA==
Received: from MN2PR20CA0038.namprd20.prod.outlook.com (2603:10b6:208:235::7)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Sun, 29 Oct
 2023 16:13:53 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::a6) by MN2PR20CA0038.outlook.office365.com
 (2603:10b6:208:235::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27 via Frontend
 Transport; Sun, 29 Oct 2023 16:13:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:13:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:13:40 -0700
Received: from [172.27.13.126] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:13:36 -0700
Message-ID: <144f8eaa-635b-4791-b64d-5c3a4681806e@nvidia.com>
Date: Sun, 29 Oct 2023 18:13:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026115539.72c01af9.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231026115539.72c01af9.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|SJ2PR12MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d5e4043-b3a4-4682-ea00-08dbd89a0b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	760C82Y8IwDN8t/Xc/HcpLUYWQeloLV60yeLxSiGX5mlSRuK8UOxpAL1Etis5aWg57a5g/zWIyd/wMYUVXQ0GHwE8UsMyx/5mxTO9AIaCs018U2YVuu5a05mtD0fsi82vLv0jzbggMMDRzKH1QZVA7Y8OKzfYQpzdQ0KWJwGkNr3AFWfRQssk0UesYJ+RI3AFf7b4lgjqi9VK6uX51g+kzx4962VnCsCcypr/PSeOsCALmKfnVbHPxdBi8TVabrdm/s81sTOlkr2ZC0O4oHTbE34Je1rlyJ7dILvduU1HUHPlF64d7TFcX03fpTYgX2a/vgM6OYwSucgOahKU1B/Xja9vU5OY27vKGbC6AXdkWo9SWAiJtdymXKk3BISn/MQgiEKLNGnTt7n0soc9FXGoCZgPnJUUSRmtUH/uSYoAtPZ9q3kWSlIOpsd4BZfsQF3UiAeZJbi4rfwg8qhDHVuueSUBesVOpHkKfsDul98YD6YqXGmhtAB8PeMHQR/PjSXsKolA+pm94QPL1yjCCz6SbqNZonG7TGnHpCZUczn5q0QowLWSIM7BJZaEjg6iMXJhXnBfqWE7c6O/1rJCYXPkzIKZ1066IAtzaTBGkdSeLl5M5xHhTNW/10CTQP4kbtydNL9hWFeVBz31BAmUWSep8ywujFQduAizKNvJxt92qwtCIkzZy3FXapuFu8l2rwPaaAlF9PMFKPbKBbkIMYya7UTdbG4gL1jYRVUs6qKrBWz6CLLTjJAl6HD7LC8MolJjijYqbOzOqoVTgYdhLLtAQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(376002)(39860400002)(136003)(230922051799003)(1800799009)(451199024)(82310400011)(186009)(64100799003)(40470700004)(36840700001)(46966006)(2616005)(26005)(16526019)(107886003)(53546011)(40460700003)(7636003)(356005)(82740400003)(36756003)(31696002)(86362001)(47076005)(36860700001)(426003)(336012)(40480700001)(83380400001)(5660300002)(316002)(41300700001)(70206006)(70586007)(16576012)(6916009)(54906003)(8936002)(8676002)(4326008)(31686004)(2906002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:13:53.0823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5e4043-b3a4-4682-ea00-08dbd89a0b86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867

On 26/10/2023 20:55, Alex Williamson wrote:
> On Thu, 26 Oct 2023 15:08:12 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> On 25/10/2023 22:13, Alex Williamson wrote:
>>> On Wed, 25 Oct 2023 17:35:51 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>   
>>>> On 24/10/2023 22:57, Alex Williamson wrote:
>>>>> On Tue, 17 Oct 2023 16:42:17 +0300
>>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>     
>>>>>> +		if (copy_to_user(buf + copy_offset, &val32, copy_count))
>>>>>> +			return -EFAULT;
>>>>>> +	}
>>>>>> +
>>>>>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
>>>>>> +				  &copy_offset, &copy_count, NULL)) {
>>>>>> +		/*
>>>>>> +		 * Transitional devices use the PCI subsystem device id as
>>>>>> +		 * virtio device id, same as legacy driver always did.
>>>>> Where did we require the subsystem vendor ID to be 0x1af4?  This
>>>>> subsystem device ID really only makes since given that subsystem
>>>>> vendor ID, right?  Otherwise I don't see that non-transitional devices,
>>>>> such as the VF, have a hard requirement per the spec for the subsystem
>>>>> vendor ID.
>>>>>
>>>>> Do we want to make this only probe the correct subsystem vendor ID or do
>>>>> we want to emulate the subsystem vendor ID as well?  I don't see this is
>>>>> correct without one of those options.
>>>> Looking in the 1.x spec we can see the below.
>>>>
>>>> Legacy Interfaces: A Note on PCI Device Discovery
>>>>
>>>> "Transitional devices MUST have the PCI Subsystem
>>>> Device ID matching the Virtio Device ID, as indicated in section 5 ...
>>>> This is to match legacy drivers."
>>>>
>>>> However, there is no need to enforce Subsystem Vendor ID.
>>>>
>>>> This is what we followed here.
>>>>
>>>> Makes sense ?
>>> So do I understand correctly that virtio dictates the subsystem device
>>> ID for all subsystem vendor IDs that implement a legacy virtio
>>> interface?  Ok, but this device didn't actually implement a legacy
>>> virtio interface.  The device itself is not tranistional, we're imposing
>>> an emulated transitional interface onto it.  So did the subsystem vendor
>>> agree to have their subsystem device ID managed by the virtio committee
>>> or might we create conflicts?  I imagine we know we don't have a
>>> conflict if we also virtualize the subsystem vendor ID.
>>>   
>> The non transitional net device in the virtio spec defined as the below
>> tuple.
>> T_A: VID=0x1AF4, DID=0x1040, Subsys_VID=FOO, Subsys_DID=0x40.
>>
>> And transitional net device in the virtio spec for a vendor FOO is
>> defined as:
>> T_B: VID=0x1AF4,DID=0x1000,Subsys_VID=FOO, subsys_DID=0x1
>>
>> This driver is converting T_A to T_B, which both are defined by the
>> virtio spec.
>> Hence, it does not conflict for the subsystem vendor, it is fine.
> Surprising to me that the virtio spec dictates subsystem device ID in
> all cases.  The further discussion in this thread seems to indicate we
> need to virtualize subsystem vendor ID for broader driver compatibility
> anyway.
>
>>> BTW, it would be a lot easier for all of the config space emulation here
>>> if we could make use of the existing field virtualization in
>>> vfio-pci-core.  In fact you'll see in vfio_config_init() that
>>> PCI_DEVICE_ID is already virtualized for VFs, so it would be enough to
>>> simply do the following to report the desired device ID:
>>>
>>> 	*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(0x1000);
>> I would prefer keeping things simple and have one place/flow that
>> handles all the fields as we have now as part of the driver.
> That's the same argument I'd make for re-using the core code, we don't
> need multiple implementations handling merging physical and virtual
> bits within config space.
>
>> In any case, I'll further look at that option for managing the DEVICE_ID
>> towards V2.
>>
>>> It appears everything in this function could be handled similarly by
>>> vfio-pci-core if the right fields in the perm_bits.virt and .write
>>> bits could be manipulated and vconfig modified appropriately.  I'd look
>>> for a way that a variant driver could provide an alternate set of
>>> permissions structures for various capabilities.  Thanks,
>> OK
>>
>> However, let's not block V2 and the series acceptance as of that.
>>
>> It can always be some future refactoring as part of other series that
>> will bring the infra-structure that is needed for that.
> We're already on the verge of the v6.7 merge window, so this looks like
> v6.8 material anyway.  We have time.  Thanks,

OK

I sent V2 having all the other notes handled to share and get feedback 
from both you and Michael.

Let's continue from there to see what is needed towards v6.8.

Thanks,
Yishai

>
> Alex
>


