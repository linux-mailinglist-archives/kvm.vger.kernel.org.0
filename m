Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0353EF1D
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiFFUCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiFFUCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:02:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBB527B23;
        Mon,  6 Jun 2022 13:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1hvMJRYmaf5W7XbaVST47FlDQ1frljVyL5CTKrB+t3KyqiyTWN07Y0c9+Aqe4r2Bpa37Kgg5cMlJoMeqHMM2DQNapJLxJ/bE2ubGDz5VFbRBWSS26RcFZGbgg+1qPpgjOsLPPdQk5PRGW7o2kH/4hRInaGUdOaAnWJEerFi5oqUepk9p/ZR/jddc4jRCngHZlQuNw0NQ9MJN2apZkXgSG/nmLuQvfLTtDctl78XPxcElyCAL/0iCcKGI0vsDEGLSfAnEdfBXNv1QYBQ+HdgxirwLTEQNrX/oTwy3xNaI9qypQD9ginonTLdoxQf9L70iM5eOZ2y88T6PjXqg+uIxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5il7pKDprK0FAXxPbM9rW/pu198cAQD3JO4fYmQbaE=;
 b=ThtLcsOsS8gzoH4xA/LkFCW7CTIIGF86jg38bwcEdqSSaKshAlkMGpuG2Gbsl32J/yRbCyNeCtLVNeEwIHDfcxP+0DxhzARZ3ANK7rVIzNSp6sEk1rF/NfkwPJ0W8tAVGIH2vIqXWhUe5uWX3JvmPp1PAOT0+eLlPHEX2A8p+e10I3ebOwuCmFfb5CtGvLNySGwHxnbxBW8ak50jlazEZHL7N3ig3pog5aeU/WKBcech0q9+hZUJDMJEwmKwdIJ8vANdA7WaWnItAueNHoEmOCvXvctX6CgbwH/g5ZPJ+sTB+9h8zbtC+TC3Wvwu77NmIVppDFH3xwHFNN5wz2B+ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5il7pKDprK0FAXxPbM9rW/pu198cAQD3JO4fYmQbaE=;
 b=Lfd/I/FciNGjpOoMhTFJBODxkTxp0VPOSFMlwf0iL6BH+AFH/QmmX9IjEGGJk5eChAMVfQgE2uDSOrMkZWqGAeIJpnYYp+iea8oYR50T6VLtp6JLj3Vd0k9q84TXbGlDPfwSLOl1SOExMJpTLCCYUwhqOF9KTw2Ba6hI97eVzuyf3AfwB11VzuGzbr63WELgp3Gd9QGiLQYhff65r48+pT/lP4+R3z0XJedjGU+x6Qp3xssuAVhJzaKk83rgN35UcEZUhTVUoyLEioYufFCj7Gt53TxJwJ2bRk2m/8rAy4Ftp+b+d6Mv9wmTexp24RTer7iGwDv7vEhfpm4M65Y9Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by BN8PR12MB3219.namprd12.prod.outlook.com (2603:10b6:408:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Mon, 6 Jun
 2022 20:02:37 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 20:02:37 +0000
Message-ID: <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com>
Date:   Tue, 7 Jun 2022 01:32:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v1 14/18] vfio/mdev: Add mdev available instance checking
 to the core
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-15-farman@linux.ibm.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220602171948.2790690-15-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::21) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c947d8f7-3665-40e3-73f5-08da47f780bb
X-MS-TrafficTypeDiagnostic: BN8PR12MB3219:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3219FA6B921E8F4DE70C3B3ADCA29@BN8PR12MB3219.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yHiWWg4bGMK5jJ4eD5ZFcfdQ3XeyJgXuxNWK6wiMAK6mvjX0OTfH3xBa4RAfjNEe08tLep5geOVA9ghYwJaqP+7rTTHDPzk+c+I+k4uFtTl2kZRNWj/lfDxV2bdof2Ks2pEZKuFzr1Far4bWhAcjeoJWDXVt8s2EsUnuR5Oo3c1EiJ1/r6XWHcLEU6yDSNPoyXgJ6U12Asgr6JY9QtyZW2KxzTXMdyrk2A9QewXAK6kVuFLI4gsseujEM5I/kJq3ITLdLPjT7YHbSfq1Vt1inEanr8DbB8l3Z+vdR7yQqdJCXEVfgpjOMNWSRtaJ1LJW2eO/D9ainmss8QgE8TMKj+6Mae2by3tmIReFKw1R9fXX2x/ArJ4yfXw5cZx+loGQ0cnVyaYTZd2KdZrChCM6E/L9yKpdgM6l424WAxghyKaeVXozi6yD5jx5h86PRVitopmhI4/tlSV+lNdj+dTFyr4zygf9afw0z+KSO2s2wX5dKuLkgSVdS0TvIZYvhLwAV80kXjozK0yn+Q5I+w4vazCdh3dnrLo4pZXW1DmP7Nc9uDuifBQ4OzlF+5zaXfdNHjC1Ju8qsJnx+90/ldQJO4NTM35dNmglGfF1EbWS/87r8EHIpEpbWUXaPhUmS3as8zrB5WT666SFMWABpZSzbBDpI6OW3QDyTLRn3BT8GDuLqrzLAoVEaDdXr1l4rcCRhiBg/V6Qg2CD/oUlFs6HIK3LsoTyQfbcgApFNAC0mady4zm1aDu0dW5qDKQZjc1myiPX1XzK5MJEU/XHBAGuEgdWEb9RSrWwOT4UsNC8db43tp81vTBJ/RG0DPz0SWYx/yur/UH2X6wgAo5a/wYyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(4326008)(8676002)(2616005)(2906002)(316002)(54906003)(36756003)(110136005)(38100700002)(26005)(53546011)(6506007)(55236004)(83380400001)(86362001)(66476007)(31696002)(8936002)(508600001)(5660300002)(66556008)(66946007)(186003)(31686004)(6512007)(107886003)(6486002)(966005)(7416002)(131093003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0pFUEFucllxWkFxWHptR1ptRTQrZG55YVpCWm4vaEdYbW9abTVvSlE4bVlh?=
 =?utf-8?B?cDlkVUx4d0dhNkpWR3JRcy9ramloYlkyQW4wUkJ1Z3RiTjZ4aWQyZ0Nkb3cy?=
 =?utf-8?B?dUJJRHRibC80K1M0OUhlU1pTREswaGZEMlk1WkMvSnBQdVVDaXZObVhDOHNM?=
 =?utf-8?B?L0t5RUZ0Z0Rsb3pudThsTzFDS0wzM3pLQm1qQUNNZmxQcnlWNXo5ZlFQSkF5?=
 =?utf-8?B?QWFPb1ZBR2kweFppQ2UvdGU4M3ZGblNScno0RjR1ZWhBbUdjSC84dE1rRUhr?=
 =?utf-8?B?Q00zdUVGdlVIRXFyY0RTMGxyWmtuc3pEM3NVa2gzSm0wb3Mvc05IQXRzWG5n?=
 =?utf-8?B?aGxYbS9uN1ZSbS9nSWludk1nRU50NFprWnBQRlRZMmFGc01TWGJyOS9ERUo1?=
 =?utf-8?B?ZGF2T00xOUMyZEhlRjlBTG9xRHVJK252ODc3RzZabXVBRlA5cjVMV0JDeDlX?=
 =?utf-8?B?RjVxc3pORmNia2tVZlFnTVFZZXRpcCtyQU12SnVldFdYbEZJVHlaOS9SbzhS?=
 =?utf-8?B?ZlYvRHhzbndPNG14c0p3cjhKQkhmTldWUXpOTy9xMXc1bHIxMW1QbjVmRTV1?=
 =?utf-8?B?eEdQT21xNWNIN2RUYVRpZGZhbHFSWjNnQjYvOTNaNXZtOTBxRGhidWxTVkV4?=
 =?utf-8?B?V2lIMEE0NUdRSjI0bDAyNGtNSWxaTkxncGRUaldhU0ZiQ0pLWEZmY2lzSjBY?=
 =?utf-8?B?ODhQZ3dDM2drc285QXRDOXJIM29kY1owU2JCaUdIbTZ3dTNvUnV5QzhyNWxF?=
 =?utf-8?B?ckJxdC9yT1psTUFNN05NNitxdVgydHZrVkJTdit1ZmxtYndSMW9oaGQ4NGpB?=
 =?utf-8?B?QVdjendpaWQvSHo2d0tzNnBLaWF5U1BlVFJnMlBmR05PdytqR2s1S0FUSVFF?=
 =?utf-8?B?WGRSRzFaMUxOK051VGRQT1BIQ09JcTJldzNpQjByb2kySlFNSkFueGhiMDh5?=
 =?utf-8?B?MkhwWXU1Ri91RVZLSHlZS1c0UGc3eisvZUJYOE95VS84YnpQc05SNHV3c2RM?=
 =?utf-8?B?eHB6RXlDTWI3QWlBRDZQUmhtTGlSai8xTU1rYm04WjhOYThxUkVzaTg0TkJp?=
 =?utf-8?B?TG1yNU9GTjlreGpWZ0t3UGFGaWFOZW1id2FOWVB4NDNqNnhwSWhrSHdDdWtT?=
 =?utf-8?B?VWpCRUdhVDk4bDNXWkk2QmJvNm1od3lZNzFlSWFiOW9Hbyt1NVBDWGVEUkU1?=
 =?utf-8?B?N2ZuY1k3emw2NU94M0k0TWlYSWxyNnZTcURXenMxUmlaYkg4b014Z2ttMHJL?=
 =?utf-8?B?Nm9iTW9PUnZjR1ZFLzRuSXZSK1Y1WlBBaTl6NkhMdFVZcTFVYXFLdWtBdHJU?=
 =?utf-8?B?RFBHdmJuQThnd1VoNGM1YVhlUHRGNXNVQy9kaStZeUs1U3hZb2NoNDlVMm5Y?=
 =?utf-8?B?YUJtdnMrVnFUUkxFQnplQ2dyYS9MTUg0UzhMYUtpMWgyRUJOcE52T3U0TXB0?=
 =?utf-8?B?SUk0V0tPUnBwYUQrMVl1MnBFUTNuaEVDQzBVNVRzUXVqcFBUQkh6OFVGNU45?=
 =?utf-8?B?L29EN2VNUlo3aEpwUitNVmVNOGUrSFE1RFg4UGFxR2dUWHA1VEdsbEFodDNK?=
 =?utf-8?B?OEd6ZTAyM1NwTWZCdVByR2xyYncrY1djbWljQmwwRmJxYVl2QjBrVmIvamV5?=
 =?utf-8?B?dHFYWXZ6ZzJFbTNCdlZjVzV6bFFpYUo4UDB1Yk5Gc1NmckFyNUErV3R0TjNW?=
 =?utf-8?B?eUdmcnRVZDZpSjhDczVQREdMVXZkeG5DM1BpYys0dVVzWXRRb3BYVkpRWE5I?=
 =?utf-8?B?QjZ1OS94M05FaGVwVm9zRE1QdHluYWJERWhFRjNlNzBWcE5yclJqbGhaclZW?=
 =?utf-8?B?RDJhSFhUTHpBYXpNdE9qUHJSRFBjbnNwQzMyNU94NW5jbUk1TkkxanpVMzQ3?=
 =?utf-8?B?MTcxTEcyLzMrZzE5cVhFQnErMDM4aWF5aHFlU21FVlB4OWNveGxqQ3hxZy9i?=
 =?utf-8?B?NjhRRkVRMkV1U1BuYXBEaTQyQ3VvSGdrYVlmSldQaVB5WDlXeXNuUm9FMnN0?=
 =?utf-8?B?S3pJRlgyUXByRWJQS2grMm1PczgrVEZ0Zk15QkQ0eDBNNjJRdUlwVFdmS0FV?=
 =?utf-8?B?L3VIdEgyRDJKbEhzSEtpL2NvTUd2VW0zTG1saTJ5UG9laVdoSkZyaXdTK2pt?=
 =?utf-8?B?Z1RRK3hDOTBLc1VYNUlWTGtLdVhtUkRMcDNYUmRSdTVWVHJHS1IySEFTTXc4?=
 =?utf-8?B?d2daekNySlUwZ3ZwWFhTdW5TTWNVUHZSQk0yeStWL0NTOUpBQ1JpaDJiTHEx?=
 =?utf-8?B?eitFTUJaRWVXMUFic3gvTm9sWnNTTncwZWZMYlRZdjdHUzNZbDV4bmZ4QmpQ?=
 =?utf-8?B?ZEduWVdpSlYzb1gyMFB2bGgyOXgyY2pia3pZdDQ2OVpJQ1Nza2hJcmdiaUp6?=
 =?utf-8?Q?DmeTeJNrATbxl+6k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c947d8f7-3665-40e3-73f5-08da47f780bb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 20:02:37.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2d6VQIjDNP6II5u5gUpJdHAH7Tqxd2PNI1V3QMSXeJ9914fULwnUEHUjpEspq21Dkm8rkVyjHeNwqSjplWIYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3219
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/2/2022 10:49 PM, Eric Farman wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Many of the mdev drivers use a simple counter for keeping track of the
> available instances. Move this code to the core code and store the counter
> in the mdev_type. Implement it using correct locking, fixing mdpy.
> 
> Drivers provide a get_available() callback to set the number of available
> instances for their mtypes which is fixed at registration time. The core
> provides a standard sysfs attribute to return the available_instances.
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/r/7-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
> [farman: added Cc: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  4 +-
>   drivers/s390/cio/vfio_ccw_drv.c               |  1 -
>   drivers/s390/cio/vfio_ccw_ops.c               | 26 ++++---------
>   drivers/s390/cio/vfio_ccw_private.h           |  2 -
>   drivers/s390/crypto/vfio_ap_ops.c             | 32 ++++------------
>   drivers/s390/crypto/vfio_ap_private.h         |  2 -
>   drivers/vfio/mdev/mdev_core.c                 | 11 +++++-
>   drivers/vfio/mdev/mdev_private.h              |  2 +
>   drivers/vfio/mdev/mdev_sysfs.c                | 37 +++++++++++++++++++
>   include/linux/mdev.h                          |  2 +
>   samples/vfio-mdev/mdpy.c                      | 22 +++--------
>   11 files changed, 76 insertions(+), 65 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index f410a1cd98bb..a4f7f1362fa8 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -106,6 +106,7 @@ structure to represent a mediated device's driver::
>   	     int  (*probe)  (struct mdev_device *dev);
>   	     void (*remove) (struct mdev_device *dev);
>   	     struct device_driver    driver;
> +	     unsigned int (*get_available)(struct mdev_type *mtype);
>        };
>

This patch conflicts with Christoph Hellwig's patch. I see 
'supported_type_groups' is not is above structure, I beleive that your 
patch is applied on top of Christoph's patch series.

but then in below part of code, 'add_mdev_supported_type' has also being 
removed in Christoph's patch. So this patch would not get applied cleanly.

Thanks,
Kirti

> +/* mdev_type attribute used by drivers that have an get_available() op */
> +static ssize_t available_instances_show(struct mdev_type *mtype,
> +					struct mdev_type_attribute *attr,
> +					char *buf)
> +{
> +	unsigned int available;
> +
> +	mutex_lock(&mdev_list_lock);
> +	available = mtype->available;
> +	mutex_unlock(&mdev_list_lock);
> +
> +	return sysfs_emit(buf, "%u\n", available);
> +}
> +static MDEV_TYPE_ATTR_RO(available_instances);
> +static umode_t available_instances_is_visible(struct kobject *kobj,
> +					      struct attribute *attr, int n)
> +{
> +	struct mdev_type *type = to_mdev_type(kobj);
> +
> +	if (!type->parent->ops->device_driver->get_available)
> +		return 0;
> +	return attr->mode;
> +}
> +static struct attribute *mdev_types_name_attrs[] = {
> +	&mdev_type_attr_available_instances.attr,
> +	NULL,
> +};
> +static struct attribute_group mdev_type_available_instances_group = {
> +	.attrs = mdev_types_name_attrs,
> +	.is_visible = available_instances_is_visible,
> +};
> +
>   static const struct attribute_group *mdev_type_groups[] = {
>   	&mdev_type_std_group,
> +	&mdev_type_available_instances_group,
>   	NULL,
>   };
>   
> @@ -136,6 +169,10 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   	mdev_get_parent(parent);
>   	type->type_group_id = type_group_id;
>   
> +	if (parent->ops->device_driver->get_available)
> +		type->available =
> +			parent->ops->device_driver->get_available(type);
> +
>   	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>   				   "%s-%s", dev_driver_string(parent->dev),
>   				   group->name);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 14655215417b..0ce1bb3dabd0 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -120,12 +120,14 @@ struct mdev_type_attribute {
>    * @probe: called when new device created
>    * @remove: called when device removed
>    * @driver: device driver structure
> + * @get_available: Return the max number of instances that can be created
>    *
>    **/
>   struct mdev_driver {
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
>   	struct device_driver driver;
> +	unsigned int (*get_available)(struct mdev_type *mtype);
>   };
>   
