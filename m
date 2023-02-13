Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2666954E8
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjBMXnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBMXno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:43:44 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C412049;
        Mon, 13 Feb 2023 15:43:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsyA9qfwqNRO5aIu8zoFYP0LzbDwTr7NLeCUNsvaXGqQH/nE528wMYQGiScDgDcfYeN9LiPDNV+GsP+cvmkmvn5thVNMx3aXwAC+xzX4KE/YzDlqoW+bB2zxbuk6RmPEPTQ+RzsT4syPizdmFsPgc4Nn563uELPAsbHdAYdxqHNxdk+vxzllJC9qEpLrL0hGPIjzSOh11pjozGADNWKW1BqitykA7hMqiPO/3y5miarVbLtvQuTzx0TVcp4Q/HWvCnxUoL+Qxzu5Xpn+hRi9to9vYtnRxzZfIeoN37i9iSfW5nhfIHnd1ev3ZXy4V5enWTuaVZf+SZY2ZTc9lTapkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ge/DQO5aFqrJrH06n6mZWvL04n+zcXkOJT1C79YQEf0=;
 b=F98fnT4b7ThQFqsDWj4uJJC3hqLCuJ1tlIQKK/HyCCxF0QNnCx2DUFwbWO85hevCEJfGpwaZQqBPbmyKeVsnuIdbcsKyUandeFkKy2ujLONVXqB3vrOxjjt37i35yT+brKQSN3DuG/dsiaYWpUi1PgmQvJPnvrD2COlYH0b1wMyXfphnKoi7Cc3I5C1G1rt+r0Pv4hxBtfrWnNTe+xyUX6VIOqt7WLChSdBRVjme0bhh1ORtR8FFD+MNi7rgp1yrcIvVTqc3XUEJWLdSz+4w5RNUTOAtbzGHMob32vG7UqtACwCIYPJP64ENUoXI1f5WnKA+EzBX7YGY/iS9gvdpUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge/DQO5aFqrJrH06n6mZWvL04n+zcXkOJT1C79YQEf0=;
 b=UUe+pDWRPU2dQ65DuaXbaDiYYr213RGANsEiHm5IH236S/gXHx3oGj5z9I3bAExDeP/wcBzlSd9UbQ1EvHVaeXBVZh9i/oxZeosv37UAWXH8xKbMuOS/dQ5MVTiKwHP7PR2n50Q7Yn/65AnmgKFNKKUqdnbeHmnkvapMFMWam9z09RjngWw2ZWURgwFneqDK6VK8CJNSVQ5JOkYBjII0B4Ap8KVcB+NOtPvSRHy6aAGN0KkdpT/CJTo3aRi483LmOOgJIXQniur01ws+2sKwBCd8Rhd4aawIYm3QE5r8ZfL56LuMMMQ6CSvrgyulM1TayDYI+v3LR3JCGgCWMcqVmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6000.namprd12.prod.outlook.com (2603:10b6:510:1dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Mon, 13 Feb
 2023 23:43:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%6]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 23:43:40 +0000
Date:   Mon, 13 Feb 2023 19:43:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     joro@8bytes.org, alex.williamson@redhat.com, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <Y+rLKvCMivND0izd@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213151348.56451-4-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:208:120::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: b615cd5f-132e-4bc1-3243-08db0e1c2297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 410Sw2fQ8BBfBIYuIWI8O13HUgzDEH5e9AcNQdCJYwUO5ZdQXUlwXGAn0NobrgQJ2WHNPsOy5gvW2FAZRNl91drWg/8vei4JT16s8u9vkLwOd98DZCB3gHwx4pge8QxjKSpZeVlnRw09eLIW3PK8mPzPaisfPufo9OK81pXyhGdq5z7OvsrLAZJMQKohElsEXmcv9IgvKP3tjwiVwyTqFZHaFQ1w/8FH/48m1smY0hn+cCbxOd8WSTKaaZv3ZwdejEdRmavWpLX6ReiYSMudXslvNNrmyNwcM4xwg/RiYmzgFff5XtVBCXQm6xlHZWl3JqQT9TVNKX1Dgdz5sITXjk9Ng2+YamA4Y8IMMkIAexXlfIDJB0LEm0ZHpJr/Qc3uARLmct5GhB24CZ8mwYR8SzAJt6d5iVvB3GEWW5eVDvPpYg9lAcHa91t4s0ECPhgmMTj0uq1wa00UV/IWVpXZhZ3M1//RPMtHfHlGx0ghf1HcXosqK41mPbLYXmrbCkr4qBPDPN7igq+WrsHUdkyJmSrvbRW2OAgsDGt0v3ugcvYm09O6KTOonFuNwuxPwajMLLpXd326jO9CTTXQ0xp5lanHIxlbH5PmZ4VNyeri/ZgjXIAXf0xBWnjZOswhsJRr8HV1aaWP5vlTBBrx5UnaKDJh6ytio2R/LZtVFs3ntBuyBBloY5dTMnuMXmiD+j3T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199018)(38100700002)(2616005)(26005)(6512007)(186003)(316002)(86362001)(8936002)(66946007)(2906002)(4326008)(6916009)(66476007)(36756003)(4744005)(8676002)(41300700001)(6486002)(5660300002)(478600001)(6506007)(7416002)(66556008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AF6DVTzdPK3FEhfxdogVfiHylwZF26iPxzA0T1iYyTXZD5c/h7eJSUgDbUUz?=
 =?us-ascii?Q?wHcTyX8t4qTEXUI1zjsfX1BR35crBvz6qBaCUL3bTVyCEURowah/RVQGadmS?=
 =?us-ascii?Q?HP0/RRDZ881145Or6REYdLChUwdN4e2AcNGh/fcr7bS6i6FPj+TH5+KMy2hV?=
 =?us-ascii?Q?3FMI9IZFnk3sy3it2rPJal2BN1elQ8emcd6ZXFgPpUK3kyfRTn3InJBckqiD?=
 =?us-ascii?Q?AvjEpTAWflYDcrn6GM3YY4s9PS4vq1/pZwCFd+EAFj7dRmtftMZAhO5bG6Zn?=
 =?us-ascii?Q?pAvU2XIxqXWBATCqVzeorFtkuMa/NvSBgV8EJR+hes0vjsiUwZ/KSyOMSm05?=
 =?us-ascii?Q?GNgDvY3yzjbJcia5to2KxPhVB4HbwjHOmy1EHSDWZJloOOBOjgbBrZ8IAYYh?=
 =?us-ascii?Q?bY4P++8eyQcKQwewIqw6VIh4aISbTf3ukkrErcNwHKZ1Dku4wDkka92MV6uc?=
 =?us-ascii?Q?lXpxe+xBNjvvJdzgQKRui9Zl+XXtIopFQQNqg+yEB2uzrsxwXde68vW3qsEP?=
 =?us-ascii?Q?ua2p2IDxQvblyS02kme1sMfk/ratMH6NoeVjRrxsLK3fxFBeJiK5s2oBYVkv?=
 =?us-ascii?Q?cbwBi5PxH+ZHe/VOM+SiKsgQ/uzB432m82uEyH+gYt/cUa8NuKVWPwZxVm/W?=
 =?us-ascii?Q?Z50a37n3NicX9bP9hqQ6M4OPlFbApytIZJZRM6eqOIGGEdwdECpudyeUKUt6?=
 =?us-ascii?Q?XgUw0w56PN65ECkDW86UmYng/qfZEcsyfDi07POGI30w5oh3FE3HXbWnazw8?=
 =?us-ascii?Q?WtRCN3eDPCHd0T6If2h9qoIRpYscI9fB56mQTo4AFpXvaIg3KgMbXap82h3Z?=
 =?us-ascii?Q?RLWBRPhUdUK6Z/uk2F/pmWg+yHvaBP7zsUoWVg7vbqcGur+wnX7Bb6NXyx+y?=
 =?us-ascii?Q?lBk4aDNil9T9pUdjIXKuuZo/0ZZTtv0V6BvbqNYmIxnKVCxP0iePalq+lyX+?=
 =?us-ascii?Q?8sbxWhhPLEdltWw/veVaxY0PSuLbGGPILCXaon/4W42NGRK4ovlAhzzqKIBf?=
 =?us-ascii?Q?a7/ilkLVYRmCPFl+SANtQdW8zI24aqdAl9EsN4uWYIg/LxzpJVPiQ3xoXTFM?=
 =?us-ascii?Q?cxidg5hUlY9eOYu1NdRMBEMbtR9mY9nGcMZ++GIvJIYJbte/npZDk3iz7vRz?=
 =?us-ascii?Q?jsOn/2eiskSGmp+Gm/2yzSBfREYo9I06I15ZDXIj8JBkU3wgacVrDhHqqVSP?=
 =?us-ascii?Q?qzdmFatd8PLV58B2xK+68y8DF67HR2XcZJ6X0d7j1KHttOlIEXg/GQ25dA+H?=
 =?us-ascii?Q?gbIvlToC5RlcALmf76aH/XHNrF2kGD17R9Zcx+ZwacVBQfy6uTrDTO8ge+LL?=
 =?us-ascii?Q?gO3IQ1wPm72C1kdglJHQuzTqIhVB+nLCnCdLm+qNNEy4SuTthOfPs+e9mZun?=
 =?us-ascii?Q?yxARtkQGoHkk4goM43mOlnJaqPb6/Or8zEXNAnloH5GGNo9NeF1/ND4ugcGs?=
 =?us-ascii?Q?Q2BUGPaNZMbMxYZpLzyB/9FPMZbJJQZo/ppYhxN9pyUevGSVYAHInDcWtwvc?=
 =?us-ascii?Q?u4fJcfkLtujbUV86utqV63c0Et5UaHsr1Quzvusgu3hgbsqK4e6cxTm9TYWd?=
 =?us-ascii?Q?jiCNGPtN7OKMp+7+kzgX6fRtZhjtjw47Fp4lA79Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b615cd5f-132e-4bc1-3243-08db0e1c2297
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 23:43:40.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ForOPDIKwCvlhUgqgQDl1eSoCs88j6t2KmqiZVa20aOlXrPIQSVsGfj8WFyudNA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> +static struct vfio_device *vfio_device_from_file(struct file *file)
> +{
> +	struct vfio_device_file *df = file->private_data;
> +
> +	if (file->f_op != &vfio_device_fops)
> +		return NULL;
> +	return df->device;
> +}
> +
>  /**
>   * vfio_file_is_valid - True if the file is usable with VFIO APIS
>   * @file: VFIO group file or VFIO device file
>   */
>  bool vfio_file_is_valid(struct file *file)
>  {
> -	return vfio_group_from_file(file);
> +	return vfio_group_from_file(file) ||
> +	       vfio_device_from_file(file);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_is_valid);

This can only succeed on a device cdev that has been fully opened.

Jason
