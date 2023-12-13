Return-Path: <kvm+bounces-4318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3745811115
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:25:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58D971F212D0
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E367E28E2D;
	Wed, 13 Dec 2023 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OPieHtLA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96261F5
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:25:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWoNqNlc7V+B/1iQ0u7wzg127UlAYGFFelbMxx7p5SnFR49TUvfd8ON3oFLfa8CciomzH2WxTwGb3FHw0WlcX2G3noJj3kl0x7D9UGC+l9RmXM5Lh7RAUFF8H3AeHnQa2iD1t1fKpbJCVNPoKeHPjjwpRcuxSu9Rqx96eeiBO8FJp2Rw2YjGkHfsZoumj2fND46kHxYM8UVpxFkGbyUyWnVfurkDsadxwuQ0AWZI3lvIMAUHIBI8YGhFiOh0Sd0EUh4TH+xDi9KaBPyl81Vb0PsZlfRNz+maTs1qLVwn0MjexCY/dPxtblVJSfumoNS3m2xvPC4j3Jgl1DEZB0ZMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMS/5rpoOtkalFAhxQdzUkLIzCV4SMvvqxuupk0M7zI=;
 b=mP+EBQhBe1OtQI8+wTi77hvgs1bXzSKWhtJPfP/zQp5GvSZN3Q9xfgm72LnzsXm9REC9n+8kFswFe8otxP75A6uOfdFXcS1jhJrIfNYEwzGl4Hm4oRq1Yynw39gglIS1gmRgi+mwHSvtRIxLugIoyeW0ktzszJXyuw4mek7utmEVHpr+EHOLV53sAcn2ROMOaEB71M47wZ6h4FjHNY8IBOhLcAhkvKQXQ7kkkOYzfSE1bGnJtkKV8tbHSJQwc4SYLxXA2IXNM6I/nawmYhlTPiBIr6z0BANbcWQGuH3Cy3ik5RUuXB1snmhkJP9lArSf5EwopSdnygALjWB7xGtCWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMS/5rpoOtkalFAhxQdzUkLIzCV4SMvvqxuupk0M7zI=;
 b=OPieHtLAIikp65f6MUG1eyqRFGHeIIdjz0CrkB8lgjkL5ml2f4tCr8gMXRjcpZ3Tn7DnS0qVp3mxRJwO2O7ncI+TYQzqvlYDjkKLl1ZxxC6rzXwRQ2IMFpEwHHDYRuP6eDXwiHmRPiL5AHFxvMvwX2vAC4YJbiyRhRfsSQUi31Z/W3KVNaM+HEmlPb+kew3ga/LmCMoqvagGkjO8edGkk2dVYXWaufOI4rp5iRiQLCRikVh+PfyfYzdz0//YT30Ve0XspMXDiJLRwBOHV2CjbV+0XVZfr20bdrJ9sl/22eIXs7IvxJwjqPmMI90smoMxaosSSPvRJSt46E/EHp9zZQ==
Received: from SN7P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::28)
 by CH2PR12MB4937.namprd12.prod.outlook.com (2603:10b6:610:64::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 12:25:35 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:806:123:cafe::5e) by SN7P220CA0023.outlook.office365.com
 (2603:10b6:806:123::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Wed, 13 Dec 2023 12:25:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Wed, 13 Dec 2023 12:25:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 13 Dec
 2023 04:25:17 -0800
Received: from [172.27.58.65] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 13 Dec
 2023 04:25:13 -0800
Message-ID: <fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
Date: Wed, 13 Dec 2023 14:25:10 +0200
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
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|CH2PR12MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: c3eab4b8-9d12-4c05-f42f-08dbfbd69b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jGSbsO306gHlC0s3PoLEU/7uVmxG0M1WUUGomf16ML2DdV6+669fC3zvM1rPekPic0GGQjhN6svGXz4B918LU89zKOUPfQSG+BWsV/ZcpTegkgPX2C01xORN20lh9Bbb1npnqaRTMwNO35GmlWFkQwmcQpCDL7uQ25NHIFN1cRLg4ed/ms6i0xQa/uDYiNcc2XITd0p0Unwvv+bmhcHX2Rv+qAwfIx7xFzyWY+axnp+xPdcjcFg4PPI9iI5uneLIEO4bZXgrWe9dWs3/xtaKRp1jR+QqDJfjvUUcTIWt8dZvVhlD9MjvVRgSs5QM7aKH8CjpKZdQvANuaKqW3P/33QNOOIsobOi/ZItmSuvAItFwQj7sLRYZIFiaJhwdmT9XzdgA5eH5NVCLPLhMZBiWLtGf5KL/lJ5ccvajc4GDjoibLZjiTwrOI0U4XJEAdOx1ZlopN9fO9GtOTuf//8MuoYqEjbah6QiG8xMvWvc6QrXWo1KT+XE2aSWCUddwQuOHaDJ1IhMwgJar8B4V4im0rpmMSazaM4gSK7ckF+rPnXmzaI+hOp6KdQhDC/MYLYokuvScC+bXT5eiIbUNtXVZJEVjBTELOefuO1qS5L3aXeiNUhO2ZRQLsd4tIq/5t3ijPJ1U3zZxvyIavAvxUZ4Jf7v9F6znWDefO4/gMfOLa09Ib1X3/F0Z019LpMsqKVQVR/GTLVaWCy5130Je1hqMgJpjMKzYULGckPzBxIpDaJvrY6409ZPNKdjo3XFbnBR9TM9b9ghBbDw405aqcaEBQs/H0ssgS3v5T7scPkskKDumv4hESuO9tF5zFq7L1E7T
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(82310400011)(64100799003)(186009)(36840700001)(40470700004)(46966006)(40460700003)(110136005)(336012)(16526019)(83380400001)(53546011)(2616005)(47076005)(966005)(36860700001)(5660300002)(4326008)(8936002)(426003)(8676002)(41300700001)(2906002)(16576012)(30864003)(478600001)(26005)(316002)(54906003)(70206006)(70586007)(36756003)(86362001)(31696002)(7636003)(82740400003)(356005)(31686004)(40480700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2023 12:25:34.7646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3eab4b8-9d12-4c05-f42f-08dbfbd69b39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4937

On 13/12/2023 10:23, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Thursday, December 7, 2023 6:28 PM
>>
>> Any read/write towards the control parts of the BAR will be captured by
>> the new driver and will be translated into admin commands towards the
>> device.
>>
>> Any data path read/write access (i.e. virtio driver notifications) will
>> be forwarded to the physical BAR which its properties were supplied by
>> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
>> probing/init flow.
> 
> this is still captured by the new driver. Just the difference between
> using admin cmds vs. directly accessing bar when emulating the access.

OK, I can rephrase the above to clarify that.

> 
>> +config VIRTIO_VFIO_PCI
>> +        tristate "VFIO support for VIRTIO NET PCI devices"
>> +        depends on VIRTIO_PCI
>> +        select VFIO_PCI_CORE
>> +        help
>> +          This provides support for exposing VIRTIO NET VF devices which
>> support
>> +          legacy IO access, using the VFIO framework that can work with a
>> legacy
>> +          virtio driver in the guest.
>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>> +          not indicate I/O Space.
> 
> "thus, ..." duplicates with the former part.
> 
>> +          As of that this driver emulated I/O BAR in software to let a VF be
> 
> s/emulated/emulates/

OK
> 
>> +          seen as a transitional device in the guest and let it work with
>> +          a legacy driver.
> 
> VFIO is not specific to the guest. a native application including a legacy
> virtio driver could also benefit. let's not write it in a way specific to virt.
> 

OK, we can rephrase to the below.
" .. to let a VF be seen as a transitional device by its users and .."


>> +
>> +static int
>> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
>> +			    loff_t pos, char __user *buf,
>> +			    size_t count, bool read)
> 
> this name only talks about the behavior for VIRTIO_PCI_QUEUE_NOTIFY.
> 
> for legacy admin cmd it's unclear whether it's actually conveyed to a
> mem bar.
> 
> is it clearer to call it virtiovf_pci_bar0_rw()?

I'm fine with your rename suggestion, will be part of V8.

> 
>> +
>> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>> +					char __user *buf, size_t count,
>> +					loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	size_t register_offset;
>> +	loff_t copy_offset;
>> +	size_t copy_count;
>> +	__le32 val32;
>> +	__le16 val16;
>> +	u8 val8;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
>> +				  &copy_offset, &copy_count,
>> &register_offset)) {
>> +		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 +
>> register_offset, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
>> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
>> +				  &copy_offset, &copy_count,
>> &register_offset)) {
>> +		if (copy_from_user((void *)&val16 + register_offset, buf +
>> copy_offset,
>> +				   copy_count))
>> +			return -EFAULT;
>> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 +
>> register_offset,
>> +				 copy_count))
>> +			return -EFAULT;
>> +	}
> 
> the write handler calls vfio_pci_core_write() for PCI_COMMAND so
> the core vconfig should have the latest copy of the IO bit value which
> is copied to the user buffer by vfio_pci_core_read(). then not necessary
> to update it again.

You assume the the 'vconfig' mechanism/flow is always applicable for 
that specific field, this should be double-checked.
However, as for now the driver doesn't rely / use the vconfig for other 
fields as it doesn't match and need a big refactor, I prefer to not rely 
on it at all and have it here.

> 
> btw the approach in this patch sounds a bit hackish - it modifies the
> result before/after vfio pci core emulation instead of directly injecting
> its specific emulation logic in vfio vconfig. It's probably being that
> vfio vconfig currently has a global permission/handler scheme for
> all pci devices. Extending it to support per-device tweak might need
> lots of change.

Right, the vconfig is not ready for that and might require lots of 
change, for now all is done by the driver layer.

> 
> So I'm not advocating that big change at this point, especially when
> only this driver imposes such requirement now. But in the future when
> more drivers e.g. Ankit's nvgrace-gpu want to do similar tweak we
> may consider such possibility.

This can be some orthogonal future refactoring once we'll have it.

> 
>> +
>> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
>> sizeof(val32),
>> +				  &copy_offset, &copy_count,
>> &register_offset)) {
>> +		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
>> +		u32 pci_base_addr_0 = le32_to_cpu(virtvdev-
>>> pci_base_addr_0);
>> +
>> +		val32 = cpu_to_le32((pci_base_addr_0 & bar_mask) |
>> PCI_BASE_ADDRESS_SPACE_IO);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val32 +
>> register_offset, copy_count))
>> +			return -EFAULT;
>> +	}
> 
> Do we care about the initial value of bar0? this patch leaves it as 0,
> unlike other real bars initialized with the hw value. In reality this
> may not be a problem as software usually writes all 1's to detect
> the size as the first step.

> 
> raise it just in case others may see a potential issue.

We don't see here an issue as you mentioned above.

> 
>> +
>> +static ssize_t
>> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user
>> *buf,
>> +			size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
>> +		size_t register_offset;
>> +		loff_t copy_offset;
>> +		size_t copy_count;
>> +
>> +		if (range_intersect_range(pos, count, PCI_COMMAND,
>> sizeof(virtvdev->pci_cmd),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->pci_cmd +
>> register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +
>> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
>> +					  sizeof(virtvdev->pci_base_addr_0),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev-
>>> pci_base_addr_0 + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +	}
> 
> wrap above into virtiovf_pci_write_config() to be symmetric with
> the read path.

Upon the read path, we do the full flow and return to the user. Here we 
just save some data and continue to call the core, so I'm not sure that 
this worth a dedicated function.

However, this can be done, do you still suggest it for V8 ?

> 
>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_init_dev(core_vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	pdev = virtvdev->core_device.pdev;
>> +	ret = virtiovf_read_notify_info(virtvdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Being ready with a buffer that supports MSIX */
>> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>> +				virtiovf_get_device_config_size(pdev-
>>> device);
> 
> which code is relevant to MSIX?

The buffer size must include the MSIX part to match the virtio-net 
specification.

As part of virtiovf_issue_legacy_rw_cmd() we may use the full buffer 
upon read/write.

> 
> 
>> +
>> +static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
>> +	.name = "virtio-vfio-pci",
>> +	.init = vfio_pci_core_init_dev,
>> +	.release = vfio_pci_core_release_dev,
>> +	.open_device = virtiovf_pci_open_device,
> 
> could be vfio_pci_core_open_device(). Given virtiovf specific init func
> is not called  virtiovf_pci_open_device() is essentially same as the
> core func.

We don't have today vfio_pci_core_open_device() as an exported function.

The virtiovf_pci_open_device() matches both cases so I don't see a real 
reason to export it now.

By the way, it follows other drivers in vfio, see for example here [1].

[1] 
https://elixir.bootlin.com/linux/v6.7-rc5/source/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c#L1383


> 
>> +
>> +static int virtiovf_pci_probe(struct pci_dev *pdev,
>> +			      const struct pci_device_id *id)
>> +{
>> +	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
>> +	struct virtiovf_pci_core_device *virtvdev;
>> +	int ret;
>> +
>> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
>> +	    !virtiovf_bar0_exists(pdev))
>> +		ops = &virtiovf_vfio_pci_tran_ops;
> 
> I have a confusion here.
> 
> why do we want to allow this driver binding to non-matching VF or
> even PF?

The intention is to allow the binding of any virtio-net device (i.e. PF, 
VF which is not transitional capable) to have a single driver over VFIO 
for all virtio-net devices.

This enables any user space application to bind and use any virtio-net 
device without the need to care.

In case the device is not transitional capable, it will simply use the 
generic vfio functionality.

> 
> if that is the intention then the naming/description should be adjusted
> to not specific to vf throughout this patch.
> 
> e.g. don't use "virtiovf_" prefix...

The main functionality is to supply the transitional device to user 
space for the VF, hence the prefix and the description for that driver 
refers to VF.

Let's stay with that.

> 
> the config option is generic:
> 
> +config VIRTIO_VFIO_PCI
> +        tristate "VFIO support for VIRTIO NET PCI devices"
> 
> but the description is specific to vf:
> 
> +          This provides support for exposing VIRTIO NET VF devices which support
> +          legacy IO access, using the VFIO framework that can work with a legacy
> +          virtio driver in the guest.
> 
> then the module description is generic again:
> 
> +MODULE_DESCRIPTION(
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
> 

Yes, as the binding allows that, it looks fine to me.

Thanks,
Yishai

