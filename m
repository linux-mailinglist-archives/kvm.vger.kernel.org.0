Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CDF3F5ED6
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 15:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbhHXNSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 09:18:47 -0400
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:56044
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237450AbhHXNSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 09:18:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5qzwkTjncAZI4/COFw5cI37Mju3NOBDbKnA9514cX+FFZuX/wqfhq0wtCUE0Q1d+2Uq3pbsisBFvH2A6MKjsdasukLucjazP/QiJmuyF5wXGS9itF+06MJSzQOJO3ZwhrO1VnHZKQ2dVDGoYqU1FJa536ZpCuGoDFP5DH9jSSUgai94YFoWuQuOg3ju1b0Vp73rQKV4Os4Lmi3p72oL94QXzFU7vTTAf3tyoKvERjJo5X87LO36v7V6ZWDZfaUYu/4Ju8azWlowMEfvxchSoKwMfTU2Sg/qa5OCYYaH45ggXdyP1cCjh7dh6hlm6CuvbnzSXef82c0fkTXcczFkrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J424FvV4RZKqDFRzaz+UpYP4rOXZsGlQoBpfVfpuKnM=;
 b=S+2UduSzyb7O4I7jNzyDPxVkTSbGIPy3YnFnsWoXsn/KFfBDFNoBl+j4aY+myH9i779JpuGTUAPCzqyIxzGNVs7+naCWHfpszaP+q81N3E6ZEERDx8UV70bcORMkF53S+B1pMga97AorLWFxXkTeFdjKVRPDVnclWf7eQDEdMOPabS6iA97S022av6aHvLYoIANMTKDeYlQYBS5KR02JcgIyeO901uJBQ+LHeRUVD35XsztYuvX1UJ7i3Li2tNf59cSFJ0unZlJJQuZx+0QJ38dmZHZ6e/0FltfdkTPx32bJkLFj5rBUc2PWL2Vm5ocIoEzt1vefvt/ZQIz7Ei48OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J424FvV4RZKqDFRzaz+UpYP4rOXZsGlQoBpfVfpuKnM=;
 b=BtGVdRXA16I2knL115S9X6lb+sx/hdZxOn8BlifVOjc1UZWolYgbNeXwMP3ykdfnCN6cOpaFeaUuVQER2X/VQeTT9cExNq0vetiP2iyMQU50A1mLoifEQHIdbaTc4X0csbWYbYb3cTSmjhhSBUMJsoccenrNDhqExVzj1Ae3f5CYeV8SsoCHpYzWWbEqg0Qyn9PrYc8aolPJLBNVaH6/0RA27EQ9bRIxRK4LUSeHCnVuc71Eie6aBhGtjx+IEZvhf+kjmDaROVMI3CY78SGvlCYJ8yrObcCu2evxFLmUJ8L3x5SwDAxKKqT9rpy7OCKO/Fmg8HTmByVk2IJTWFNswg==
Received: from DM5PR05CA0020.namprd05.prod.outlook.com (2603:10b6:3:d4::30) by
 CY4PR1201MB0054.namprd12.prod.outlook.com (2603:10b6:910:1a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 13:17:55 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::dd) by DM5PR05CA0020.outlook.office365.com
 (2603:10b6:3:d4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.8 via Frontend
 Transport; Tue, 24 Aug 2021 13:17:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 13:17:54 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 06:17:54 -0700
Received: from [172.27.13.92] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 13:17:49 +0000
Subject: Re: [PATCH V3 10/13] PCI / VFIO: Add 'override_only' support for VFIO
 PCI sub system
To:     Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <corbet@lwn.net>, <alex.williamson@redhat.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <jgg@nvidia.com>,
        <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
 <20210822143602.153816-11-yishaih@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <4369c82f-ef8c-1041-269b-b51bd246cde0@nvidia.com>
Date:   Tue, 24 Aug 2021 16:17:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210822143602.153816-11-yishaih@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6372efa3-9a6f-49b9-ba0a-08d967019587
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0054:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB005458F2EDEF2BB269F42C86DEC59@CY4PR1201MB0054.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6aiOYet6tmkjCwtE/HGIpd4XI/iTS1NnMBek1FIyuq+93jXdRvxpoxB2yJIR6XEKKFKqhz4ki4SsuPJEMMIekkJXGNo53UpIheaFZEWCB2cjo8X023OGNDVtoMSZeHCDzRWQLkBJoxIi8Byn8uH27ylwcZx3Zv5Uc+fy0NRGEh7drLUo8cQF40vQXivIOt2Yf3dLzwSun3miHeyoNKK96cZtBBUECp0w7MnV2miTAgXG05EJHg5hHV5BTF3CB//boA/K0pV/rQPMezDTyg/oqhUXDvc20Klmv9ZxFNP9YiEiGpCszBCzUVI0DBTKllI2fY/zzF0tji8Re6xxt2y6MrHoFFUhkxvUntFrO7jbPLIOS66F7y93szRxg97kY4JnS3CpNnxjun7M6ovbbLzIHynYLg7LbHCuHIZhgrT+llNaILok/TBf0z/Hxkv+Tjx7DTzaXf/WQnJBkmpIvWGOeHD2tevk9z/qIsbnSVdtwokGs07X2+x+YtObyf4zbp+d5RADlAFeLfGvzdiw651CkAK6RcjFdEG+T6aZ5RBYLtII0Wv4DpkpydcR2Fe7JPM1qXCpVashbzWh7YPUgBrn1i7aIh77elXndjw+yMBSGdErZG77jUGW5kEn/wda8L9nZHgMdE+pOnWMkTwDN4QAwvldql3BKzwnEfmcoTDbFp68+P22LXUTA1M6IBS2pYvvFJ9Bxqy5INpZ/5f/+GPuvzX2zFMFV2dFqBNxm5+Crix5MWbbcQ8sutIhGBv1fqpT
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(86362001)(356005)(16526019)(53546011)(36756003)(82740400003)(47076005)(7636003)(316002)(26005)(336012)(426003)(107886003)(36860700001)(2616005)(8936002)(31696002)(4326008)(478600001)(70206006)(7416002)(5660300002)(8676002)(54906003)(186003)(16576012)(83380400001)(110136005)(70586007)(2906002)(31686004)(82310400003)(2101003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 13:17:54.9894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6372efa3-9a6f-49b9-ba0a-08d967019587
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael and Yamada-san,

Can you please ack regarding the small change in scripts/mod/ ?

We would like to merge this series for 5.15.

Thanks,

-Max.

On 8/22/2021 5:35 PM, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>
> Expose an 'override_only' helper macro (i.e.
> PCI_DRIVER_OVERRIDE_DEVICE_VFIO) for VFIO PCI sub system and add the
> required code to prefix its matching entries with "vfio_" in
> modules.alias file.
>
> It allows VFIO device drivers to include match entries in the
> modules.alias file produced by kbuild that are not used for normal
> driver autoprobing and module autoloading. Drivers using these match
> entries can be connected to the PCI device manually, by userspace, using
> the existing driver_override sysfs.
>
> For example the resulting modules.alias may have:
>
>    alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
>    alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>    alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
>
> In this example mlx5_core and mlx5_vfio_pci match to the same PCI
> device. The kernel will autoload and autobind to mlx5_core but the
> kernel and udev mechanisms will ignore mlx5_vfio_pci.
>
> When userspace wants to change a device to the VFIO subsystem it can
> implement a generic algorithm:
>
>     1) Identify the sysfs path to the device:
>      /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
>
>     2) Get the modalias string from the kernel:
>      $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
>      pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
>
>     3) Prefix it with vfio_:
>      vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
>
>     4) Search modules.alias for the above string and select the entry that
>        has the fewest *'s:
>      alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>
>     5) modprobe the matched module name:
>      $ modprobe mlx5_vfio_pci
>
>     6) cat the matched module name to driver_override:
>      echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
>
>     7) unbind device from original module
>      echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
>
>     8) probe PCI drivers (or explicitly bind to mlx5_vfio_pci)
>      echo 0000:01:00.0 > /sys/bus/pci/drivers_probe
>
> The algorithm is independent of bus type. In future the other buses with
> VFIO device drivers, like platform and ACPI, can use this algorithm as
> well.
>
> This patch is the infrastructure to provide the information in the
> modules.alias to userspace. Convert the only VFIO pci_driver which results
> in one new line in the modules.alias:
>
>    alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
>
> Later series introduce additional HW specific VFIO PCI drivers, such as
> mlx5_vfio_pci.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
>   include/linux/mod_devicetable.h   |  4 ++++
>   include/linux/pci.h               | 14 ++++++++++++++
>   scripts/mod/devicetable-offsets.c |  1 +
>   scripts/mod/file2alias.c          |  8 ++++++--
>   5 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 07edddf7e6ca..c52620ac5e70 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -180,9 +180,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>   	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
>   }
>   
> +static const struct pci_device_id vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, vfio_pci_table);
> +
>   static struct pci_driver vfio_pci_driver = {
>   	.name			= "vfio-pci",
> -	.id_table		= NULL, /* only dynamic ids */
> +	.id_table		= vfio_pci_table,
>   	.probe			= vfio_pci_probe,
>   	.remove			= vfio_pci_remove,
>   	.sriov_configure	= vfio_pci_sriov_configure,
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 2e3ba6d9ece0..f0325a172f87 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -16,6 +16,10 @@ typedef unsigned long kernel_ulong_t;
>   
>   #define PCI_ANY_ID (~0)
>   
> +enum {
> +	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
> +};
> +
>   /**
>    * struct pci_device_id - PCI device ID structure
>    * @vendor:		Vendor ID to match (or PCI_ANY_ID)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0506b1a8c921..527a1dfd1d06 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -916,6 +916,20 @@ struct pci_driver {
>   	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
>   	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
>   
> +/**
> + * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
> + *                                   "driver_override" PCI device.
> + * @vend: the 16 bit PCI Vendor ID
> + * @dev: the 16 bit PCI Device ID
> + *
> + * This macro is used to create a struct pci_device_id that matches a
> + * specific device. The subvendor and subdevice fields will be set to
> + * PCI_ANY_ID and the driver_override will be set to
> + * PCI_ID_F_VFIO_DRIVER_OVERRIDE.
> + */
> +#define PCI_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
> +	PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> +
>   /**
>    * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
>    * @vend: the 16 bit PCI Vendor ID
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
> index 9bb6c7edccc4..cc3625617a0e 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -42,6 +42,7 @@ int main(void)
>   	DEVID_FIELD(pci_device_id, subdevice);
>   	DEVID_FIELD(pci_device_id, class);
>   	DEVID_FIELD(pci_device_id, class_mask);
> +	DEVID_FIELD(pci_device_id, override_only);
>   
>   	DEVID(ccw_device_id);
>   	DEVID_FIELD(ccw_device_id, match_flags);
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 7c97fa8e36bc..c3edbf73157e 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
>   	return 1;
>   }
>   
> -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
> +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
>   static int do_pci_entry(const char *filename,
>   			void *symval, char *alias)
>   {
> @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
>   	DEF_FIELD(symval, pci_device_id, subdevice);
>   	DEF_FIELD(symval, pci_device_id, class);
>   	DEF_FIELD(symval, pci_device_id, class_mask);
> +	DEF_FIELD(symval, pci_device_id, override_only);
>   
> -	strcpy(alias, "pci:");
> +	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> +		strcpy(alias, "vfio_pci:");
> +	else
> +		strcpy(alias, "pci:");
>   	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
>   	ADD(alias, "d", device != PCI_ANY_ID, device);
>   	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
