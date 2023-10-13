Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110DA7C899D
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjJMQC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjJMQCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:02:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAFEBF
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:02:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLGjjuvyB5TJHfGX51o4TluOjZglbov01TqeTCVoHkwh4umsNR7nDCAINgaWhi0xe2oM+gHauwkYZSk4nCsoxVBrACfl2KuuYDuucn8sy8uftthnmIzY4ejE8oLtOz4v0ZmvljXsgBaHCAhvOmRtFmDC8p+pIfJ4kTA5EOIcLdy5k1YPWuUPcMqzWNDZNaUJYcmvJv+iL7RhvxUQpAlJJXOLPpvWA5ky/XDhJb5/02cb2KmByoXoPHBSLw+dahrdcStPfYe6d2UfhhGYS9bg2JU+fQIh1V3jZnWzWv6wkrz66cfwHCMQCvnaGA9vapvxdcHFz7ve1NR7iSu9c0716g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNzDY7/r6mZOnsmsYtuSmuJjVqHHHTcqOLJiP8GVSXI=;
 b=lMnAOjsQfjaI3r29hj4Nml3YSJSJm8Iv7K3boPzqLkuyCHy9hYqxtrY/QqJ8btzzB/UCG5cIo93dAt7jXnuMtcI6E9hJ0vO2hyGwL2KUNQFAqj4KF8B1StKHWQqbwsIGDRr6lID76uVjXgbLlS0OK+IfRdSfLetmrQaVy2UuUSenjLGTFgMMQ5PR3su+Zw6zykaBMemOw+iPllndZGeT8cthG/Ktx0lmhjSpkKdMTKDLXuhidsLe7jXB/CHidwQZFJ0ujzeE0O9nHEXl0T4fzo4S8IbG7dnIGpA5DCSVxsaypsHO1wGv7jfuEnf6XpbKXoaVJ0/wghZdi16Kc+9zZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNzDY7/r6mZOnsmsYtuSmuJjVqHHHTcqOLJiP8GVSXI=;
 b=GyUeYIqEFVk/D20xik61RHAhefzDE229/Fx6ItkCREoRWkfObYSB08fG1DHyw7e1nzy1/0YF28kGBIEb0TKmZOII7YAjBJ60dJ1Z8F6AeDLhLVwEQzNiVjc9PMOrm+Uf49pzZmyZ9zegwmLiFFpWANKbQ+XtKSpJx1xJ/x1+rUnXAiygrEV98HV5Ob/Oqu0QAipD21fJ1T1E8YGy9Yw4BAOr7D58xHKytqDn5cyow/KdHnKDzJhpQBUcnEH4oo9QK6kkjrn3rpD6hStqGQb+dvlA5lHkP6ji5xu2OJl/0Nblmf1MzB9qvjKTI9oTjND3fQUzM2mpBqYSas/xg7RVsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 16:02:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:02:41 +0000
Date:   Fri, 13 Oct 2023 13:02:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 05/19] iommufd/selftest: Expand mock_domain with
 dev_flags
Message-ID: <20231013160241.GZ3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-6-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-6-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:2d::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 56218e2a-64e5-43ca-d149-08dbcc05d4ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTTMQ744jA/A+x56pRgdl151AIHS6/Akfphd+S6444iAsVMGIzwZOOaZaGLU+xvaJGmv3oiJT3LA/T4tSQcH0YiPFnZAnaBTbNm9aCPbgMSZR3iCKXY8hBdvpG3K5oaiZLIemuyQ9jqEEC6noHef7pXT0xgJMHW+QKfROpZF5MPK5TFNE8njA1QzY2SO6jmx7MEDVs4aOviaAohveoV74KDk7UYblnI4tV2c/vqRXSvNfLd6wVyl2sVqe6Matyx8ValzUP2r8VBJeT0G/tMyDj1r6joeEs0P6Ue0MxAkJQLyONs/8k45FW8amnsNy/gc8vBPKg+wAEFgKXkymBv0Rx2omGYZH6Phrf6/4BLGRSMFEP7IeAAxUVDeY0wKtSrNYjuafe99owBDaCTaDwtcNoJBSFMyofXicef4ci1QbjgJHNsnXizNzIHaaQKKNmUTofQjt1NGhDfD6NC4bDdrzkl+KBItI5AVarjkTZCaFP1mESPYdU2JWOGLJMW9RUmrQ+LcGRTFF6b1mWAuuhOWODsCR2GnfjJ7FLTNnpXctgu9yAwQgwRvm8hPytu0yzSr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6512007)(6506007)(1076003)(33656002)(26005)(2616005)(36756003)(86362001)(478600001)(8676002)(4326008)(8936002)(5660300002)(316002)(66476007)(66556008)(66946007)(6916009)(54906003)(41300700001)(6486002)(38100700002)(2906002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SislG8+1WuWBuvczb0GD0c78x3hJtOV44WhJl/LIPGJ4vcGVitNCvKV/iArx?=
 =?us-ascii?Q?N20jpdw1cGHOjhHeSltEITRiEhy8w6XrmVP5eBuO5h+udZHiiSWpRlYf9znr?=
 =?us-ascii?Q?+xsya+h/6HY0WZeD/9LpF9lT1n5EFnNHneATuY6mBm6tCis4pASL2T3zoMyr?=
 =?us-ascii?Q?Mp/na4RM6xdgSRtX1XVlXRttt73tqFKmOnZCrPAg8iq6cp5+dU/Q597OmtJh?=
 =?us-ascii?Q?3N2dqUL07YUkfoH5oU5aMlOvmnozasQrALK0YKEahqKy/7eMVdEmypa3Fz17?=
 =?us-ascii?Q?hQIMDALyl2IJRHgGcQqnGU67yr9y4R2DiVw8khpbEiu5aCP1I3sHWptn++Zl?=
 =?us-ascii?Q?AJhCoeQm9BU1rQRMxCKJIgcPvEeaMu9Num7hUsnfr5PpzQgsQhBZBYYW3qh+?=
 =?us-ascii?Q?qDoVbiwiQRidZqloyOipy1yv9NaUkda8/5te4YE284+h8+C1PIv2qif0puCx?=
 =?us-ascii?Q?AZPgfwp7cdWEDWabBN/hApGG3LSe0uR71ymzEDfRVLyTJxuBFJi3X+EQryRx?=
 =?us-ascii?Q?e2SEC1dsqY0wh2RSEdPLyNKqsCrhm+8LtGPjtVa3a1cCdCmmnwrc3RvMtb/b?=
 =?us-ascii?Q?2cELd8lsY8MFPlvIyudOOONOBqkO6zD5b1K93AdQFYTd95Q8z26Mq81MtNVS?=
 =?us-ascii?Q?gMCr0+ZSGD0BPmvvfswCVFMDu3q9beAl1GCl7ZlHxU38MyJnq2d2aICuIk2D?=
 =?us-ascii?Q?1LlbV6prz1UkG1YueTLzEdGmpGpv2o+mvflGZ4BBBrKummolIvj8gc/s3A3Z?=
 =?us-ascii?Q?+lH2lBlc0lXcoRRCWelNuiC59e9jxtTuSfMw9M5IIYvgOA0nCgWIJwnYn5Es?=
 =?us-ascii?Q?r730xp+PmW/NLB+lzt308WXgT2qjJa+aq+/m3Wht12/5Qld4rARFaFdsz2YU?=
 =?us-ascii?Q?htOYkIau1hTWZ2tUq83es2i49angumKOUz2V53HyetL5cZ6F7PT3cE5ZPRLV?=
 =?us-ascii?Q?eE8mcByDRJ+3dKYGxFZY3aGwdy1NWX8dnfIXWZzWhrK35b4I1GFRtyGPtZTx?=
 =?us-ascii?Q?8+w92LOy3oLvMRR2fkDtsYaIGmePEcKh788r0AaNZkgonMal04hEvDyX8L/W?=
 =?us-ascii?Q?BlPxYKHAAJW2dfUQnKvHu5LTLwBOw/tB+E+VIZnYKuODFsi+5YQl+y7aX0F/?=
 =?us-ascii?Q?aGAqIv0Muf3rSMi/zD/QV8w4xMeA5POcir2LEiJnYrIbVGz/ZZWuzNtdJ9HB?=
 =?us-ascii?Q?VJXTEpQ68TfPHsd+cSnjSCUbIFEveoyVIH1Ize7fa1IPIiWNJlIYsmQSwSJ5?=
 =?us-ascii?Q?+Uxsd4p+B87rRjMYYKv3A6FeGNHI8HOWPDlYDtsiDKwEVnaRv2BlDup8vR4h?=
 =?us-ascii?Q?6ZN87paFLqNYLsbVTnWqZyg39fSEJFjFuTxfJoVWT8Vin24heC3ZvchPW2eP?=
 =?us-ascii?Q?cefQyYwyoBeSar8V3zEgdDkl16/melIMzARuqM8q65xWX81Q7AmIhm6MOCrP?=
 =?us-ascii?Q?ZlyG1q3Xl0pLhGjjH25e7Q2m9DGLLh+CvLFbj2f3QtbNyl0FL74X0j9ZCavu?=
 =?us-ascii?Q?xgVTdUX26Y+aUUxAXs704zY8gXGtt+2PZ1vc04WVBNQHYqIYVc7Kg17ZWYZZ?=
 =?us-ascii?Q?tvlEOk4tGW855ZbFR25J/EpxM3Q3g5sP4GjNauvu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56218e2a-64e5-43ca-d149-08dbcc05d4ac
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:02:41.9166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCHmX/NLiUiwvXdbyR9xRrq9Q/ARBUA/wcMtFbV7CECoB4HgHZTeprTD41ruYlyN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:24:57AM +0100, Joao Martins wrote:

> @@ -56,6 +61,13 @@ struct iommu_test_cmd {
>  			/* out_idev_id is the standard iommufd_bind object */
>  			__u32 out_idev_id;
>  		} mock_domain;
> +		struct {
> +			__u32 out_stdev_id;
> +			__u32 out_hwpt_id;
> +			__u32 out_idev_id;
> +			/* Expand mock_domain to set mock device flags */
> +			__u32 dev_flags;
> +		} mock_domain_flags;

I wonder if this is really needed? Did this change make the struct
bigger?

Jason
