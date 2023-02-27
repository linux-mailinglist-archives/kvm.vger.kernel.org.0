Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB606A4A8D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 20:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjB0TGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 14:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjB0TGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 14:06:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE29113F5;
        Mon, 27 Feb 2023 11:06:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrlRyQXIA6z7qlgTbNLEntCoU0fX4c+/C+CXoQ5UdQ485J2TN6li7nQ4esuCyTjkW8JES+aqUR/8kov2bHg7dURzc/nhFbLZdplUxZSeL8ax+kmAuuhv9QnGHz7h7UzK1R8z0GoPYO6fDwQAc4Q1ryrqhlYTYX7DFe4nqp6+AU9NBysXjbp5f5+GtxUeBSejHoIhuEX5/tGfHp//mPg3cIXR/LgOTVbr3Y21IO04FLIj1aAHZoxfF5+QZYyGCpHuOEzhv0+hNiae/nLjbrfsZWj7rfAJ0NcjuRdZ9vfWR1RT55Z6UtStC0oKlbePWGo1ad4V+IouJcnhD+6XWCPACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYshLcQLb9Hg6u051ZyfU7/ilHQO01fyLLyjxaMfCGg=;
 b=hNT5VlwOM5ds7E+KRZDmguDMK0xFbSBUwfprlZ0zVrC2B2Rg6j3BPNyWIUkkPC212gbdXYgDcB76T9ABR98EiqsAtfI11hJ4n0NrYv9CIZE3Y9RMITe+novS+3XjYtjvDLDzcajhk/x/BRHqoEDGp2Iyfy4xl+ZTqdiI9DjhTUOFp363susdEOFGvcAIMD964skgjXKnEM2YymsdM4rIWB34HSjOjnemmaN/z0PYkiMpJExDKBtAO5JPC6CYPKyn3atcdK0J0/VEE7QgHtqZ4p2QhYA4wYHy2pyYPIGEikhjDEPnZegSMocdgCTXAy3i05pyEygVMfnGvy8ZNmFX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYshLcQLb9Hg6u051ZyfU7/ilHQO01fyLLyjxaMfCGg=;
 b=KTUh3f/rKj+jjRDqReffF9o8mZgvumC/VpnaReFzjQK9Qf8N//CMGPMzyvs2QkeTbv29MG0nnq7TkxfFmgzrwEWqmBvNWuzGItMikHXSm4FxrTTcxe9HT4R7qhWUvJwMgzGUFWNBQpwKfX7a4bLlY08dusQKbzPg8fzd3XqKg8OxFUKe73rxvh1jLexRigVS8w8wCKPpSu+1Uzud0d9TRWzNRl4IIgVl1m+HbInqsyRYtDGOTy68Av11mvnZBOattte+kmIqOGQSIz+2flZyfjWUVhUMxCh0dNRL/Jk6Xlf/DXJjn0zB4ITYWTMvyWNrPT8LpwH/s+cnTDDMZ0oQJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7294.namprd12.prod.outlook.com (2603:10b6:806:2b8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 19:06:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 19:06:09 +0000
Date:   Mon, 27 Feb 2023 15:06:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 15/19] vfio: Add cdev for vfio_device
Message-ID: <Y/z/ICcG9OIBo+Fi@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-16-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-16-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:208:d4::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7294:EE_
X-MS-Office365-Filtering-Correlation-Id: ae86682d-85e7-430e-b0e5-08db18f5afac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hk2ROXvix07/ysF6vI7X7vCnogxPF6LExz2JewI940n9+ttRemtMXVp/45zM8VFM4fILoGbEDtILtnPpbo1E60gqU3BsBU16F8SIoCcAh3P+oLtsahU8mBA44ENg3aGAS9PtmjcZ1a+2/ADtr1ChpebS8f0B/t6nwWO4oMO0P+8pseuoUYrmeixDE5Ef/6hmNpP6TRNBc68NWmnJ3s/BshT67DdAclnCG/zFsMpdKb3sGz5QT4KkUyeqGsnepkuKLpWmawQvleO4kUSMNl41DkEECs/MWwBx9yUcJHX3ZFN4jaKiYh3aHiLdZjR/esqnB2DmCPccup8ULsMYAUUsryqi4C6tuSe0qnS4ydLc3HPPr3UT8KpJQmPPFCeerAORVDpxkMb27twDVxDn7saYjdKv2NbaRlg7gG8m4XkC/HLkfvKf8upxq6KKa8K86F5yg25VqRBJrVTlD3/P+10r6mNvNEQCE19BpieMfmLlHyKlJcj0RYo6pzlX4f2VgJuNRfh8w5YWUr8sVxNDO+wqn+FEvBbHBAitzzilVS82rSMH/cy+wEBZTO5h/QXCI3pzGzwh51uHWUnWojrKDFtYm0147Y3pLkhsb7vJz2OCaiAp2Rz9s5zRUYj9rC+5fiU4UG7x+B9vAtKfkKFJrxjQxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199018)(7416002)(8676002)(6916009)(66946007)(26005)(186003)(66556008)(478600001)(4326008)(66476007)(36756003)(6486002)(86362001)(316002)(6506007)(6512007)(8936002)(5660300002)(38100700002)(4744005)(41300700001)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJNoB2z6R7BW13q6XzX/uHdO1aC70ujLkZN0POsp9SIC1Nc0qpMrLfHiE0w0?=
 =?us-ascii?Q?Rdmnb1S7SglF+3bFR7YfQqNYaoUCsxe9BI0FvTpJGBUMNkbQHagm/swrLWjD?=
 =?us-ascii?Q?a1GKDojNx+7FTA9g55aNUi5k0rm5hI5MDnWFX9ShfBMhPPuArO2LZaKz/oPN?=
 =?us-ascii?Q?fgDiUUxcPkMYeWLTxdpynkflovt1dcWFIWAkThnOqJwsmSbl9Zw6nPt1GRXK?=
 =?us-ascii?Q?mm5pD6AXILbZEw/oDXm+XZqxu6x2lxNvJK8NB5p9xoYZFH8E6+8BLsHOOXpI?=
 =?us-ascii?Q?Tf35Lu/e8zrGC+3ue3rO34vd/k7xoXWCAwBMpHGlHK40Z9Y2Jxi/qmwN2OyB?=
 =?us-ascii?Q?p2CaNVGjbbFy5WXJvJBZbRcFg61yxcl+tbAu+c/w3uEnzCK7dIZ+lGnZtK5O?=
 =?us-ascii?Q?eo23QFaWZbXFLf4ZdlzIsNJ8vtZKnhSPrp9MKmTwSy2mKePF2vWs2KYrPtoI?=
 =?us-ascii?Q?Ug6idQqFx7L/6Meqf9Put6vtj6m9L5LKcDlmR89D+QTDK8RJt7RLs5xkoxeL?=
 =?us-ascii?Q?B0kQ0kAaqqRcWMKI4mmCKghEUbtBp7djbNl8bqu1x20mjcLOg+ALFjH35ycD?=
 =?us-ascii?Q?SaeJOeD/85tsb8oTBByIie2upWYjoczn/z6PmNou02XiMlUpQHmJ7m6Xlq3i?=
 =?us-ascii?Q?GzBepA1u5v1tkqXlBWyQZ1hLTmmww/h+4lE3IEZnTkEsXpeYBCq4njwwuKYQ?=
 =?us-ascii?Q?f3d/GWge139znWRZWWjWPkIVclwvv36HRnhlGMuecFtWZxQ43X9rYhHBwK/c?=
 =?us-ascii?Q?bLhZvnywn4khspEuqBhY+nIxMM5GwF5nndZl23zcbl5uJ1GxKWfw0+27/w0V?=
 =?us-ascii?Q?lcgW1WYvEpDseGsAIJNrAxktVmglU/rGU/qHWGf/eEY0+tTIN0o2xCwSeKP/?=
 =?us-ascii?Q?yK4dn5sVxPHFDADeSps75r50mTVN5ivKxyaVIPr1NaW3+TKJK4f1IuyH/Zgu?=
 =?us-ascii?Q?82I/DUaeUL8rLb4VoC39kysBelf0qBIrNxI49xzb/XOEQloIeG2BQ6NJqE/n?=
 =?us-ascii?Q?8+1PTSC46U/qXe5VuNWC/KiStuJx6FsGwuuZDQQ1mdeFiYtqoGyfvO0fTh4m?=
 =?us-ascii?Q?r2CPr6VG066jFGj/KvykuKKycEs4HG/Pp1eUSyeo93I+R2+0B9PzQ0xe1kcz?=
 =?us-ascii?Q?CvUcSFKNRLDnn+SQWwfXcMGAyNWi00N+7ZY58zX0oogXSVIHgWQAq5Ku6WSw?=
 =?us-ascii?Q?5iIr95R0dISpqzsMcIqZ/hzL311yhfinc5zADUe8Bt8gWm58FEivQ5p5NSXG?=
 =?us-ascii?Q?YEodlDm6kky4Fnrf4+l+ex12iTUeFN5ocCkotpPSssdY1O3euKejNJpjg/Qa?=
 =?us-ascii?Q?4juEyJfdSbtWDVzbUChxJRd92I9vwiG8rCPiw7chqa1zRZ8UHa1fBQMVKP66?=
 =?us-ascii?Q?e6ioh667UO8mwjCIStzWZP9rwyJpRG/8iz9ctqbmQdjooG8Gw1CbxUBsxUsn?=
 =?us-ascii?Q?DIz7pC7tYv9cZe4rQJc7M3KXgmbC2jMeZVUpbPKHg6ebRI6XoCLZsuhLsLXl?=
 =?us-ascii?Q?6tO/Ay5ZXEkqLdKlCSdoFIodM2bACDXkYk3Pub91czPsaCoqK4Y7SRUNWOoA?=
 =?us-ascii?Q?CFZbbAK99ObtIH3yHOwbi2hucbTln91vI8bvCg3C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae86682d-85e7-430e-b0e5-08db18f5afac
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 19:06:09.8159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/oJZWyYhtp41j90N8VczBG6zg7VNIa4hqDA8nfRy1CILHpZ8JbzgIsByK/gqwgf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:31AM -0800, Yi Liu wrote:
> @@ -309,6 +310,13 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  	bool interrupted = false;
>  	long rc;
>  
> +	/*
> +	 * Balances vfio_device_add in register path. Putting it as the
> +	 * first operation in unregister to prevent registration refcount
> +	 * from incrementing per cdev open.
> +	 */
> +	vfio_device_del(device);
> +
>  	vfio_device_put_registration(device);
>  	rc = try_wait_for_completion(&device->comp);
>  	while (rc <= 0) {
> @@ -334,9 +342,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  
>  	vfio_device_group_unregister(device);
>  
> -	/* Balances device_add in register path */
> -	device_del(&device->device);
> -
>  	/* Balances vfio_device_set_group in register path */
>  	vfio_device_remove_group(device);

The same rational applies to vfio_device_group_unregister too, so it
should be moved up as well.

Jason
