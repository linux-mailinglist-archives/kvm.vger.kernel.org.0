Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD4D3F1D92
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhHSQRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:17:11 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:25568
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229497AbhHSQRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 12:17:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvA3RKQSKBcQVHQHyVTn26x78hjFR9q1dvN8tt1KZw86GA28pOZAKS90I/PYEczE1DjMiMLjDPmFukVSMfTBvlMBNuwOuk7/TX3n80aUYyFjHEKqRM/wAtp9N1qYCZJD7eq3TVJky6OWGbFNWsqDafHTiXpRAX9gJ/WgHG8BXxlF5rugM7s3syvW12Fh9donp6Ryybklp80aBIK6rJPfI/KQ2FiYtpdoDgwf2gcqzDXvdXrelEbk8c2iLQZS76nJbFnjb+yZr+9UiYgRhzk5qO6brV2PbQFYE2ABdOlQloYcOB+eThoM1nlCZG6ok+G0G1OfVgeTs/p8zXdQXzcwlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddgI+ILEVqD9KiIz02NsfblvcuXDWHLWtAX7iW/jHHo=;
 b=Z1BjTPrg1RiGZNKNtndFcYtjuUibek3w4ZPa14WSipLq1Aj3Yo3P83gWcEdCqYEZUof/Wch7Kydajf/XDA55PLF4lz1+wZ/m99lbRaZG+pPGjo0MXZZKZdsT1m15TDtz5ul/bDiFTHFNBBb5zKRFzRRKLB/PmqJG8qQ5PiqXU/VoEmpLYBd6Gwf8k96slpwBpeLx9Otn2JHicv0P+/Km1vsZmGlRLCc2vmziUN3uXlt0jMx+RxiOFui5wcjsvb5sRA/c8C/DBEKYp81CDIigkOG6P9chaKaqgyrxGswY9OaT5/SHj6o3FTKidkCQOaSuGvEH2z/5gPUG2iFPD/tPCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddgI+ILEVqD9KiIz02NsfblvcuXDWHLWtAX7iW/jHHo=;
 b=UKHx8ai98znPTw24bW4/MyzX17rtIkvHcgB7Rv+0kVhBHI8V+T35R6wK+q7dUn5UA6VRNV9Y7iVUbiZXzo8RGKLAYbufCA12YdIAgUedLxCrxTmHPBvWgJ8z3FGPjTvcqkEDwySGRsNBX+qM0z+NNOnoDMZ9BFIz5AQ81RHy0ydTxvA6vePRN4PdfWvrVZMpwW5JKg+Z4edD+gX3G4iIi5g8t06D5wgmbh6rCwSrmScwKqqTn6n9FCLP1zdFlUrhMgJjk7ZhXhOrh9tc+yTwJ3jj9TCgz1L938ll4mZCHt4udaz1WmZE6WaLFj9CFj2LDlgNJlUrbHmc1E9adoKrmA==
Received: from BN6PR1101CA0006.namprd11.prod.outlook.com
 (2603:10b6:405:4a::16) by MWHPR12MB1422.namprd12.prod.outlook.com
 (2603:10b6:300:10::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 16:16:31 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::99) by BN6PR1101CA0006.outlook.office365.com
 (2603:10b6:405:4a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Thu, 19 Aug 2021 16:16:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:16:30 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Aug
 2021 16:16:29 +0000
Received: from [172.27.13.188] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Aug
 2021 16:16:23 +0000
Subject: Re: [PATCH V2 09/12] PCI: Add 'override_only' bitmap to struct
 pci_device_id
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210819151549.GA3128368@bjorn-Precision-5520>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <41539eec-b6fc-084b-0417-ac39d324189e@nvidia.com>
Date:   Thu, 19 Aug 2021 19:16:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819151549.GA3128368@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9528879-2d72-49e9-76f2-08d9632cb469
X-MS-TrafficTypeDiagnostic: MWHPR12MB1422:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1422EB09854090965C1C7B9AC3C09@MWHPR12MB1422.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhG41L14AD9wrpcOpBj7JtLrcMSqYQf9GrcYCLt1taQBdJgbc2x/4RhGmWNu6XjGeGKjkX/PWDMZ1Aq/wQZ6mrWcZHP/Yn63ZrTOiJBcC3xPX3MIkyDEACFPOhlo6FUm3B3DoZ7AflGAkAQ8AONB8zBr2vEiyk7t5pYJFWuMtXzWxAjpRngbkiOh/sIWZi7T6N2lfCdnvaeq1GJi/8LDU876jywC+zDjqCD2rD8jk+17RpRp+cQW8ezRh8PE4pRrR33FDA8s87vyYhx804TiTiHHy/MhaBY3QL/Rj4FI4Sgix9O8c/o8pDpz2+Q8WRreUgd6Yz4zXMUqXIr57Ij6wVpMM6UJ/rCiB8mX/xHyDshJ+kz2pfXCLCCwyjZ7iJWHH8uxvbXFolRto4wadpv+n3LsLm2AgvH6qbEs1TERCcZ7sJEVA96sTKiGFdCa6bAeDlPHO9SlK8lp/H61tfzBPql11a2sudELtH4yiCVHnfaM3hFBZ6e2g495cZZrX75hrrdtx9BD/s80B84miG3NCxHLhKmup2v8so9+3ELZviSKxPuSF+jLN0St9Edu+X0978JlKubbidACEtUqYGGJFF6W0mqBmoN71GDw24C0g9gAlN9uLxiUKI4tg0pqpRNAdKR1VQYR0me7jRYIqA5zC6gjsakn9Vrq0p5tks6shs23mcwg8iGWiscwLI1jiEDq2riidGZNs5CxKYHOkffqfyLgyqdxZ91ddoWmn2vtw1M=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(7416002)(336012)(36756003)(36860700001)(70586007)(5660300002)(16576012)(70206006)(426003)(2906002)(316002)(8936002)(82740400003)(186003)(16526019)(30864003)(83380400001)(8676002)(4326008)(31686004)(7636003)(86362001)(478600001)(356005)(26005)(82310400003)(47076005)(6916009)(53546011)(107886003)(2616005)(54906003)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:16:30.3868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9528879-2d72-49e9-76f2-08d9632cb469
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1422
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/2021 6:15 PM, Bjorn Helgaas wrote:
> On Wed, Aug 18, 2021 at 06:16:03PM +0300, Yishai Hadas wrote:
>> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>
>> Allow device drivers to include match entries in the modules.alias file
>> produced by kbuild that are not used for normal driver autoprobing and
>> module autoloading. Drivers using these match entries can be connected
>> to the PCI device manually, by userspace, using the existing
>> driver_override sysfs.
>>
>> To achieve it, we add the 'override_only' bitmap to struct pci_device_id
>> and a helper macro named 'PCI_DEVICE_DRIVER_OVERRIDE' to enable setting
>> specific bits on it.
>>
>> The first bit (i.e. 'PCI_ID_F_VFIO_DRIVER_OVERRIDE') indicates that the
>> match entry is for the VFIO subsystem, it can be set by another helper
>> macro named 'PCI_DRIVER_OVERRIDE_DEVICE_VFIO'.
>>
>> These match entries are prefixed with "vfio_" in the modules.alias.
>>
>> For example the resulting modules.alias may have:
>>
>>    alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
>>    alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>>    alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
>>
>> In this example mlx5_core and mlx5_vfio_pci match to the same PCI
>> device. The kernel will autoload and autobind to mlx5_core but the kernel
>> and udev mechanisms will ignore mlx5_vfio_pci.
>>
>> When userspace wants to change a device to the VFIO subsystem userspace
>> can implement a generic algorithm:
>>
>>     1) Identify the sysfs path to the device:
>>      /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
>>
>>     2) Get the modalias string from the kernel:
>>      $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
>>      pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
>>
>>     3) Prefix it with vfio_:
>>      vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
>>
>>     4) Search modules.alias for the above string and select the entry that
>>        has the fewest *'s:
>>      alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>>
>>     5) modprobe the matched module name:
>>      $ modprobe mlx5_vfio_pci
>>
>>     6) cat the matched module name to driver_override:
>>      echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
>>
>>     7) unbind device from original module
>>      echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
>>
>>     8) probe PCI drivers (or explicitly bind to mlx5_vfio_pci)
>>      echo 0000:01:00.0 > /sys/bus/pci/drivers_probe
>>
>> The algorithm is independent of bus type. In future the other buses's with
> s/buses's/buses/


OK

>> VFIO device drivers, like platform and ACPI, can use this algorithm as
>> well.
>>
>> This patch is the infrastructure to provide the information in the
>> modules.alias to userspace. Convert the only VFIO pci_driver which results
>> in one new line in the modules.alias:
>>
>>    alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
>>
>> Later series introduce additional HW specific VFIO PCI drivers, such as
>> mlx5_vfio_pci.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   Documentation/PCI/pci.rst         |  1 +
>>   drivers/pci/pci-driver.c          | 27 ++++++++++++++++++++-------
>>   drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
>>   include/linux/mod_devicetable.h   |  6 ++++++
>>   include/linux/pci.h               | 28 ++++++++++++++++++++++++++++
>>   scripts/mod/devicetable-offsets.c |  1 +
>>   scripts/mod/file2alias.c          |  8 ++++++--
>>   7 files changed, 70 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
>> index fa651e25d98c..87c6f4a6ca32 100644
>> --- a/Documentation/PCI/pci.rst
>> +++ b/Documentation/PCI/pci.rst
>> @@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
>>     - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
>>     - class and classmask fields default to 0
>>     - driver_data defaults to 0UL.
>> +  - override_only field defaults to 0.
>>   
>>   Note that driver_data must match the value used by any of the pci_device_id
>>   entries defined in the driver. This makes the driver_data field mandatory
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 3a72352aa5cf..8a6bd3364127 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -136,7 +136,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>>   						    struct pci_dev *dev)
>>   {
>>   	struct pci_dynid *dynid;
>> -	const struct pci_device_id *found_id = NULL;
>> +	const struct pci_device_id *found_id = NULL, *ids;
>>   
>>   	/* When driver_override is set, only bind to the matching driver */
>>   	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
>> @@ -152,14 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>>   	}
>>   	spin_unlock(&drv->dynids.lock);
>>   
>> -	if (!found_id)
>> -		found_id = pci_match_id(drv->id_table, dev);
>> +	if (found_id)
>> +		return found_id;
>>   
>> -	/* driver_override will always match, send a dummy id */
>> -	if (!found_id && dev->driver_override)
>> -		found_id = &pci_device_id_any;
>> +	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
>> +	     ids = found_id + 1) {
>> +		/*
>> +		 * The match table is split based on driver_override. Check the
>> +		 * override_only as well so that any matching entry is
>> +		 * returned.
>> +		 */
>> +		if (!found_id->override_only || dev->driver_override)
>> +			return found_id;
> The negation makes this short, but IMO, makes this harder to read.
> I'd rather test for the special case directly instead of testing for
> the *absence* of the special case, e.g.,
>
>    if (found_id->override_only) {
>      if (dev->driver_override)
>        return found_id;
>    } else
>      return found_id;


This can be fine as well.

>> +	}
>>   
>> -	return found_id;
>> +	/*
>> +	 * if no static match, driver_override will always match, send a dummy
>> +	 * id.
> I think the original comment was better.  This comment implies that we
> only checked for static matches above, but we actually checked for
> *both* dynamic IDs and static IDs.


OK

>> +	 */
>> +	if (dev->driver_override)
>> +		return &pci_device_id_any;
>> +	return NULL;
>>   }
>>   
>>   /**
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 07edddf7e6ca..c52620ac5e70 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -180,9 +180,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>>   	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
>>   }
>>   
>> +static const struct pci_device_id vfio_pci_table[] = {
>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
>> +	{}
>> +};
>> +
>> +MODULE_DEVICE_TABLE(pci, vfio_pci_table);
>> +
>>   static struct pci_driver vfio_pci_driver = {
>>   	.name			= "vfio-pci",
>> -	.id_table		= NULL, /* only dynamic ids */
>> +	.id_table		= vfio_pci_table,
>>   	.probe			= vfio_pci_probe,
>>   	.remove			= vfio_pci_remove,
>>   	.sriov_configure	= vfio_pci_sriov_configure,
>> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
>> index 8e291cfdaf06..39c229a7ab8c 100644
>> --- a/include/linux/mod_devicetable.h
>> +++ b/include/linux/mod_devicetable.h
>> @@ -16,6 +16,10 @@ typedef unsigned long kernel_ulong_t;
>>   
>>   #define PCI_ANY_ID (~0)
>>   
>> +enum {
>> +	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
>> +};
>> +
>>   /**
>>    * struct pci_device_id - PCI device ID structure
>>    * @vendor:		Vendor ID to match (or PCI_ANY_ID)
>> @@ -34,12 +38,14 @@ typedef unsigned long kernel_ulong_t;
>>    *			Best practice is to use driver_data as an index
>>    *			into a static list of equivalent device types,
>>    *			instead of using it as a pointer.
>> + * @override_only:	Bitmap for override_only PCI drivers.
> "Match only when dev->driver_override is this driver"?


Just to be aligned here,

This field will stay __u32 and may hold at the most 1 bit value set to 
represent the actual subsystem/driver.

This is required to later on set the correct prefix in the modules.alias 
file, and you just suggested to change the comment as of above, right ?

> As far as PCI core is concerned there's no need for this to be a
> bitmap.
>
> I think this would make more sense if split into two patches.  The
> first would add override_only and change pci_match_device().  Then
> there's no confusion about whether this is specific to VFIO.


Splitting may end-up the first patch with a dead-code on below, as 
found_id->override_only will be always 0.

If you still believe that this is better we can do it.

if (found_id->override_only) {
     if (dev->driver_override)
       return found_id;
   } else
     return found_id;

> The second can add PCI_ID_F_VFIO_DRIVER_OVERRIDE and make the
> file2alias.c changes.  Most of the commit log applies to this part.
>
>>    */
>>   struct pci_device_id {
>>   	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
>>   	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
>>   	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
>>   	kernel_ulong_t driver_data;	/* Data private to the driver */
>> +	__u32 override_only;
>>   };
>>   
>>   
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 540b377ca8f6..57f9aa60f3b4 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -901,6 +901,34 @@ struct pci_driver {
>>   	.vendor = (vend), .device = (dev), \
>>   	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>>   
>> +/**
>> + * PCI_DEVICE_DRIVER_OVERRIDE - macro used to describe a PCI device with
>> + *                              override_only flags.
>> + * @vend: the 16 bit PCI Vendor ID
>> + * @dev: the 16 bit PCI Device ID
>> + * @driver_override: PCI Device override_only bitmap
>> + *
>> + * This macro is used to create a struct pci_device_id that matches a
>> + * specific device. The subvendor and subdevice fields will be set to
>> + * PCI_ANY_ID.
>> + */
>> +#define PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, driver_override) \
>> +	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
>> +	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
>> +
>> +/**
>> + * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
>> + *                                   "driver_override" PCI device.
>> + * @vend: the 16 bit PCI Vendor ID
>> + * @dev: the 16 bit PCI Device ID
>> + *
>> + * This macro is used to create a struct pci_device_id that matches a
>> + * specific device. The subvendor and subdevice fields will be set to
>> + * PCI_ANY_ID and the flags will be set to PCI_ID_F_VFIO_DRIVER_OVERRIDE.
>> + */
>> +#define PCI_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
>> +	PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>> +
>>   /**
>>    * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
>>    * @vend: the 16 bit PCI Vendor ID
>> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
>> index 9bb6c7edccc4..cc3625617a0e 100644
>> --- a/scripts/mod/devicetable-offsets.c
>> +++ b/scripts/mod/devicetable-offsets.c
>> @@ -42,6 +42,7 @@ int main(void)
>>   	DEVID_FIELD(pci_device_id, subdevice);
>>   	DEVID_FIELD(pci_device_id, class);
>>   	DEVID_FIELD(pci_device_id, class_mask);
>> +	DEVID_FIELD(pci_device_id, override_only);
>>   
>>   	DEVID(ccw_device_id);
>>   	DEVID_FIELD(ccw_device_id, match_flags);
>> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
>> index 7c97fa8e36bc..c3edbf73157e 100644
>> --- a/scripts/mod/file2alias.c
>> +++ b/scripts/mod/file2alias.c
>> @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
>>   	return 1;
>>   }
>>   
>> -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
>> +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
>>   static int do_pci_entry(const char *filename,
>>   			void *symval, char *alias)
>>   {
>> @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
>>   	DEF_FIELD(symval, pci_device_id, subdevice);
>>   	DEF_FIELD(symval, pci_device_id, class);
>>   	DEF_FIELD(symval, pci_device_id, class_mask);
>> +	DEF_FIELD(symval, pci_device_id, override_only);
>>   
>> -	strcpy(alias, "pci:");
>> +	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>> +		strcpy(alias, "vfio_pci:");
>> +	else
>> +		strcpy(alias, "pci:");
>>   	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
>>   	ADD(alias, "d", device != PCI_ANY_ID, device);
>>   	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
>> -- 
>> 2.18.1
>>

