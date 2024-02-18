Return-Path: <kvm+bounces-8989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9660A8596D8
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 13:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24E49281B4E
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 12:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5077263506;
	Sun, 18 Feb 2024 12:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TV2OeUnf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BF0376EA;
	Sun, 18 Feb 2024 12:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708258068; cv=fail; b=KzoTSHW5WVUmQgURDaMInlzsHe0gK+V5gC++X6fTydkSZxtRWoXHlvohlv9wbx/F4KMRNxG8i6CAaQZSsHG4DY4Yb4SY7gqvJg1TIEmaZU0oUGlXTGpsqPfEKd/u1Exsj3di919TLcckcyQVLr7Bvp7xGIA0U3a+PGstUH/QRRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708258068; c=relaxed/simple;
	bh=4Y0FvQ2bXE4OTPhs/3pOM/snseoTtbaWiWvaxYJpkLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=efnT5LKB7+V4Sw0uOwmGxEV8j5gTZz3gvprNsPSdIjq7p3NuguAX2eupcKKHB3bbXpa/cIWp24Lp1AgdSd/s5nSXEwaZD3JkQwKMp3nvV9QttdFZxOhS1ak5B8zpeauOycbDCGBQ9c45HvZAOfbW+l34rwosVLox6U9LX4xDBl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TV2OeUnf; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR8x4i7tkOAO7gPKmZz+cYmz/9z8qEi7Z1NBh4woVJ/5mohjC54PTgeKknNnRZ2gOQKOInzHTJv4zb5w8L8CSa0D60A7iYVuCbvW6VeGVuLGLNbOD8i3B/L3je7bNl7Mbr9OjSdB8NuxteL2gTEEqUVOrT86cIuDUGkn0n6jZb8iGsiwavP40aYEnfz+A24LU3y/61rrYKB3bmexthXP71MkvVLugSTCmbX/uydz9YfeRp09kBQTjY/UmdaW0AXjuDxHomZllp7Z4yVbcGUlvQoyQ0h5SWps7wgitKE66YeSoQ1CAGhW1WItJ+Wl2U0bJlM7AN86vNBgeV1RAISGAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=il09ZjwUGDJ26Aby8ybvyAEa6E59LWmpjVzarQY8gEM=;
 b=MCJmw7laieqedT3EQajdbCLAhjbdSP47+d9uiJbBTqoB/m+POyrsf5QXubAP/K7Sp+hmI4Fb4J9LcfACnz55BAF9ZvdhOKr1LAIpomfr3FTqQPywRrRTpY/84CnVGwy3dTyibu1ha/hNA9m4Y533zKpYrcWf8pIgHNJDgMIs6SnQJmDLzlU9RG3eMmbh9PT9isOVUaX9lXFcS9Rr/YCIv4W71K79PJUE/Bzwl9jOFzg+i5ZIJDGy4164UgAA9RAJ8yDrkPVf6OWDQZqkk036Iuia8BMFI6ZzzxnheVbVzjZNOlVvRweRxYXV3bx7ubeDQ+9L0SZ77UlCt0gB7nPeqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=il09ZjwUGDJ26Aby8ybvyAEa6E59LWmpjVzarQY8gEM=;
 b=TV2OeUnfoYT1NTAVWruxrGE/VkZPXhKLJv+pX+4yLez/XeUaZDsI3I9rymdANEL51MnBc4pvVMKt6dF0nojbF6tCxLwewo+E4BfkxKVH7lwZB7h8kxUk9W21W4HLii0VOAWaDrWEeioR/XwLFrv4szl/YdyfFIKTkmBP8AcYeKqUwkEIAC/4AH2HZe+lcb14/5rW3KeMglZH+VbjVwEzw9pVdzgamC8BvCuuNH5rulaAvmRKjf2IWb6Exfzb5yfda2zOAYBaTwWrgz0KnXncY8f8axCEgsLUwsT0CmRudCEpoigOqK4FDiw4rVWPQElSKVKAzFFYHUkrIKmtstDy+g==
Received: from DM6PR06CA0040.namprd06.prod.outlook.com (2603:10b6:5:54::17) by
 CY8PR12MB7414.namprd12.prod.outlook.com (2603:10b6:930:5e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.17; Sun, 18 Feb 2024 12:07:43 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::2d) by DM6PR06CA0040.outlook.office365.com
 (2603:10b6:5:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.34 via Frontend
 Transport; Sun, 18 Feb 2024 12:07:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sun, 18 Feb 2024 12:07:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 18 Feb
 2024 04:07:26 -0800
Received: from [172.27.34.193] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sun, 18 Feb
 2024 04:07:18 -0800
Message-ID: <f5328e6f-170c-4984-9a5d-e81761fed8b1@nvidia.com>
Date: Sun, 18 Feb 2024 14:07:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 2/3] vfio/pci: rename and export range_intersect_range
Content-Language: en-US
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<mst@redhat.com>, <eric.auger@redhat.com>, <jgg@ziepe.ca>,
	<oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
References: <20240216030128.29154-1-ankita@nvidia.com>
 <20240216030128.29154-3-ankita@nvidia.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240216030128.29154-3-ankita@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|CY8PR12MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: e217b4ca-c550-4701-10f1-08dc307a365b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xwMHB/HKiMWmZqo7Otpc9Vrg6BdjqXZuFKGdSom3VJRh7vEfE2y7VBYK2mfMn3aiNbC7JyAPihO6JIsHW5pS5R582/lNHdMyf7fAnixZ04eYDZpKmWuKPRNDjAMZarNVYff73dneEQDNk0zbWgHl4KJV+VhAQyfLnKJqvN3fokFnl3k5XtdcgSwxovOnABOLVm0vgBbsODbTtnkR+mkzn+ghkl3zgaBr3OaiaawEC0DpQZI3mey3USh7kRTrG26y9oVjx81jb+VIrVMMBqv0hXeH0ovIsErBXVgXDLYw2nSy9IOgKmxogheyM09rsVrVhJCXu/5CaoBQVzYLKZ0LfXNHygIJ1+Ba0B/HUxQ84vXhuJYEsrccMiKwvpPxkFcKmNpgNFlnfbriWxHf1RttPZBVYhFQtonVwh5P2LpQffauH8nIQS/FUsAs9OYA6dxNIe9MbtVcoRV+tj6kXkmPhjHbVykn+ChCWNCJbB6qfCWlwNhWqLo18mgZsP7IiKJEzKKaP70wUkveZYpa6nE/HeutNM5/eZrekqPjWlgISkQhz/Y8BgAXkz+ynz0KSRRtN43/tS7a++dOXuwf6e6wL+YlK7nxX5v5AFAfQ+yqPlpA2d+pk5AkpQIfB+SQeM8ZxZEKCIupZfsLLLE8NOnCWc8hjeqWyi130mfIPolkbwE=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(36860700004)(40470700004)(46966006)(2906002)(8936002)(4326008)(8676002)(7416002)(5660300002)(426003)(336012)(83380400001)(2616005)(921011)(16526019)(7636003)(356005)(86362001)(36756003)(31696002)(82740400003)(26005)(54906003)(16576012)(110136005)(70586007)(70206006)(53546011)(316002)(478600001)(41300700001)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2024 12:07:43.3661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e217b4ca-c550-4701-10f1-08dc307a365b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7414

On 16/02/2024 5:01, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> range_intersect_range determines an overlap between two ranges. If an
> overlap, the helper function returns the overlapping offset and size.
> 
> The VFIO PCI variant driver emulates the PCI config space BAR offset
> registers. These offset may be accessed for read/write with a variety
> of lengths including sub-word sizes from sub-word offsets. The driver
> makes use of this helper function to read/write the targeted part of
> the emulated register.
> 
> Make this a vfio_pci_core function, rename and export as GPL. Also
> update references in virtio driver.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci_config.c | 42 +++++++++++++++++
>   drivers/vfio/pci/virtio/main.c     | 72 +++++++++++-------------------
>   include/linux/vfio_pci_core.h      |  5 +++
>   3 files changed, 73 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 672a1804af6a..e2e6173a3375 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1966,3 +1966,45 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   
>   	return done;
>   }
> +
> +/**
> + * vfio_pci_core_range_intersect_range() - Determine overlap between a buffer
> + *					   and register offset ranges.
> + * @buf_start:		start offset of the buffer
> + * @buf_cnt:		number of buffer bytes.

You could drop the '.' at the end to be consistent with the other.

> + * @reg_start:		start register offset
> + * @reg_cnt:		number of register bytes
> + * @buf_offset:	start offset of overlap in the buffer
> + * @intersect_count:	number of overlapping bytes
> + * @register_offset:	start offset of overlap in register
> + *
> + * Returns: true if there is overlap, false if not.
> + * The overlap start and size is returned through function args.
> + */
> +bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
> +					 loff_t reg_start, size_t reg_cnt,
> +					 loff_t *buf_offset,
> +					 size_t *intersect_count,
> +					 size_t *register_offset)
> +{
> +	if (buf_start <= reg_start &&
> +	    buf_start + buf_cnt > reg_start) {
> +		*buf_offset = reg_start - buf_start;
> +		*intersect_count = min_t(size_t, reg_cnt,
> +					 buf_start + buf_cnt - reg_start);
> +		*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (buf_start > reg_start &&
> +	    buf_start < reg_start + reg_cnt) {
> +		*buf_offset = 0;
> +		*intersect_count = min_t(size_t, buf_cnt,
> +					 reg_start + reg_cnt - buf_start);
> +		*register_offset = buf_start - reg_start;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_core_range_intersect_range);
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> index d5af683837d3..b5d3a8c5bbc9 100644
> --- a/drivers/vfio/pci/virtio/main.c
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -132,33 +132,6 @@ virtiovf_pci_bar0_rw(struct virtiovf_pci_core_device *virtvdev,
>   	return ret ? ret : count;
>   }
>   
> -static bool range_intersect_range(loff_t range1_start, size_t count1,
> -				  loff_t range2_start, size_t count2,
> -				  loff_t *start_offset,
> -				  size_t *intersect_count,
> -				  size_t *register_offset)
> -{
> -	if (range1_start <= range2_start &&
> -	    range1_start + count1 > range2_start) {
> -		*start_offset = range2_start - range1_start;
> -		*intersect_count = min_t(size_t, count2,
> -					 range1_start + count1 - range2_start);
> -		*register_offset = 0;
> -		return true;
> -	}
> -
> -	if (range1_start > range2_start &&
> -	    range1_start < range2_start + count2) {
> -		*start_offset = 0;
> -		*intersect_count = min_t(size_t, count1,
> -					 range2_start + count2 - range1_start);
> -		*register_offset = range1_start - range2_start;
> -		return true;
> -	}
> -
> -	return false;
> -}
> -
>   static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>   					char __user *buf, size_t count,
>   					loff_t *ppos)
> @@ -178,16 +151,18 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>   	if (ret < 0)
>   		return ret;
>   
> -	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
> -				  &copy_offset, &copy_count, &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_DEVICE_ID,
> +						sizeof(val16), &copy_offset,
> +						&copy_count, &register_offset)) {
>   		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
>   		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
>   			return -EFAULT;
>   	}
>   
>   	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
> -	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
> -				  &copy_offset, &copy_count, &register_offset)) {
> +	    vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
> +						sizeof(val16), &copy_offset,
> +						&copy_count, &register_offset)) {
>   		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
>   				   copy_count))
>   			return -EFAULT;
> @@ -197,16 +172,18 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>   			return -EFAULT;
>   	}
>   
> -	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
> -				  &copy_offset, &copy_count, &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_REVISION_ID,
> +						sizeof(val8), &copy_offset,
> +						&copy_count, &register_offset)) {
>   		/* Transional needs to have revision 0 */
>   		val8 = 0;
>   		if (copy_to_user(buf + copy_offset, &val8, copy_count))
>   			return -EFAULT;
>   	}
>   
> -	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
> -				  &copy_offset, &copy_count, &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> +						sizeof(val32), &copy_offset,
> +						&copy_count, &register_offset)) {
>   		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
>   		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
>   
> @@ -215,8 +192,9 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>   			return -EFAULT;
>   	}
>   
> -	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> -				  &copy_offset, &copy_count, &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_ID,
> +						sizeof(val16), &copy_offset,
> +						&copy_count, &register_offset)) {
>   		/*
>   		 * Transitional devices use the PCI subsystem device id as
>   		 * virtio device id, same as legacy driver always did.
> @@ -227,8 +205,9 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>   			return -EFAULT;
>   	}
>   
> -	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
> -				  &copy_offset, &copy_count, &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID,
> +						sizeof(val16), &copy_offset,
> +						&copy_count, &register_offset)) {
>   		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
>   		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
>   				 copy_count))
> @@ -270,19 +249,20 @@ static ssize_t virtiovf_pci_write_config(struct vfio_device *core_vdev,
>   	loff_t copy_offset;
>   	size_t copy_count;
>   
> -	if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
> -				  &copy_offset, &copy_count,
> -				  &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
> +						sizeof(virtvdev->pci_cmd),
> +						&copy_offset, &copy_count,
> +						&register_offset)) {
>   		if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
>   				   buf + copy_offset,
>   				   copy_count))
>   			return -EFAULT;
>   	}
>   
> -	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> -				  sizeof(virtvdev->pci_base_addr_0),
> -				  &copy_offset, &copy_count,
> -				  &register_offset)) {
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> +						sizeof(virtvdev->pci_base_addr_0),
> +						&copy_offset, &copy_count,
> +						&register_offset)) {
>   		if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
>   				   buf + copy_offset,
>   				   copy_count))
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index cf9480a31f3e..a2c8b8bba711 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -134,6 +134,11 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   			       void __iomem *io, char __user *buf,
>   			       loff_t off, size_t count, size_t x_start,
>   			       size_t x_end, bool iswrite);
> +bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
> +					 loff_t reg_start, size_t reg_cnt,
> +					 loff_t *buf_offset,
> +					 size_t *intersect_count,
> +					 size_t *register_offset);
>   #define VFIO_IOWRITE_DECLATION(size) \
>   int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
>   			bool test_mem, u##size val, void __iomem *io);

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

