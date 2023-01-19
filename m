Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AF3673B65
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 15:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjASOM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 09:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjASOLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 09:11:53 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C6E8298E
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 06:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APyjq5/CZxKwz4RC3CeqUDEhdHcXH97UUgYTM+X/yoRrizotbvS5p1MCtAjdOjD9bgBQuZFyY8/upeA4BoG/t+vlGMioc+VVvHvcOpgh3cxYzkmBruiok+q7n1W3FXICyIrG0G7WSiwVs3nzCK3/FsZpPTu/mcwVr9HY8aW1QOydqkAeFP+mcwOt6JBm4eiYY8T18BTFGHvf0jyepkF1DtnBf4N5cDPwsiWdRT5xnvuvANgUqss6lcEH/cihH/Skb4QOqYx1mzLaDj5oPPWwJeN7DmpXa6Ddlyk1cm6xy63V3vASPOykvUhXp2NW/12f8HADaxGlPbwU8qKfibPdpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=to0RjQQ75p/pFEQcJpB6sfm808KhZnQvJsYyC/9eDwY=;
 b=LaYSh+D2vB8wTCJqOu40TH9iuVxZ7N8G8w++p2y2IZvjdipqpFUXOcyiCOuV9Cb+A0xIGMi2PHeFLOv535GQuElVU99ekmWft97nLGnMsgU+9qPJ/aZ4JCFfPw/wNUtLpVFfmv46Uc3Sfn/ebwsRfa6dh9b5SZf17ukrzzpgaU64d92AQj0Rzzj437VJPjoxcoLGoh4D3J9PALLKduQwxV4Ue4Dmv+mkSN/mb8S7U+BVh06Rm69ecah/yhAhYt7jjqV3P9Qz6iXpA5GjUULEEx/Qp85Y1bwH+y4okigqwAiEYvhnp4xIsWNMJEYhbaYZh/zq+9kBpzCNOJKMnZDTKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=to0RjQQ75p/pFEQcJpB6sfm808KhZnQvJsYyC/9eDwY=;
 b=qIaBHAp0zXQ6EE8d+juCnjVvMUAmsrSt3P7y1yCXs6hZEaG90Q5S4EjAkTjK5Zd3h0Lm1KRVC1spNPG0Y+qdiykSIXq91LSmGuEV7qF8uVoXxFh826DDEzDxAt5KqIpxUVrYrmCOFcLiBd2yaNQnG6m3JxcGdWCo4Ug1U7+kBWuHXZFmkvI/xlfJmvvY3w25WBgTGdGyibRakOdzmS89kp9CFJosTTfr7KCAWd1yfioAu/WJBLE+N2zm5m6bGlJXsRpfnDpXLbbeV0/6xTI6cAfa71LqVvP5LzRakWaTFFxgxbs+m0B6Nwxz3cD7q1dzQqITEsMC7hkM7dLTf8M4TA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6215.namprd12.prod.outlook.com (2603:10b6:8:95::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Thu, 19 Jan 2023 14:10:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 14:10:35 +0000
Date:   Thu, 19 Jan 2023 10:10:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y8lPWoRPUrDjLCNn@nvidia.com>
References: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
 <20230118115831.3e76742d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118115831.3e76742d.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ca145e-e8c3-4828-6fa5-08dafa26ef5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09/0b2Bnx+pd+8ryxeC5YuekLeAAOPhC1jxez0nx8Rvu/BiiMMoVvWGVXJsEnt+mX+M/JpFL1rysq/wRC7Y3u2w1Bf1PsKT2YJ6gaIAhMGKdEkqvIMX5Y4jj62iFouCNvypQq31UECGnwJkewJ4M7+3DH/TWhXpBWPXmM2Pq4sdKvRIXtW8jCKJTkii/a9pmDeUYZjVYKlo8jVZM4FrdA9rFrwHzCsO2bNtJ/qr4rx+RmZPnh+MzxkbNUUm6K+QEgVJBWUuCHNl0JuxcuZWqYhBaZskSAPhf6L6+m8ICaOAso+ks6Y471rpHIH4LT8SLNxCDvB2eFdxm81BWle6nswxz7GiojYt1SanOETIkWzFjZY8fLb1pVGY4Cb4xKVQdsU5wGLqq3cTjPXR3hlPOXOkEhSq4HbnNjbopn3QVgPCa5+7e28HkU78GQKeueieIRJ1dHrFtqNuJuGuKbvUAnvP4fp63YCSPTvueUJoPcGzfcIcaynBdQcaWumPG4KegLmI/aWu1KmYjSRIP5aSuriYO5X47Xnwg2ON2bMN9iXf1jUT8L+Hp/x3kzFrJ80+cN3mkcwUI/J4qRPRZUm94PxV+Pt7ZbN4viVaCFU/uvj73mBWV+jScuC6sh21y0HEtrSmUGCDjTMq2ExE5iVRQuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(8936002)(36756003)(86362001)(2616005)(4326008)(66476007)(66946007)(6512007)(41300700001)(66556008)(6916009)(26005)(8676002)(186003)(2906002)(316002)(6506007)(478600001)(54906003)(6486002)(38100700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BhMuHMJh/Drpzg4HNSCyHPqsmI+LFeQliuAx4APMAfPnojyGoV/GzYZ/hNM0?=
 =?us-ascii?Q?UgLdUoZENZRMegzqlDGzTC8iqaUa/rr4KZnkXV/rgwupAT4Op37mlKlDnLzN?=
 =?us-ascii?Q?/F90FtBHuNjBxqp7nttSO6/IMn6bv6F6ootRjAqmIqh/vnvRZ+tYXkEwzNfR?=
 =?us-ascii?Q?Ob7yUD0BYoWOlUB/tLOeQnp2knbWUK3QjkxDTAklvWyCPiiDkNh6NZVLyYHr?=
 =?us-ascii?Q?nb7HMgFciXu8zC5kSyi7MiMIm935wzffgJyD2T+W3P6zbBpVFA51yHJKiPs1?=
 =?us-ascii?Q?qgU7v4F1OR8IGlw0C47c1Jt0LLfr0tdyqiz1JUrR9Gzk4g2+OQCxkRKTpXyF?=
 =?us-ascii?Q?MvWSGYO4puDnQQp6rje8QBRQ3N/pDcUBmjMcPT/GBtqkQzsAZdHbntjBR5f9?=
 =?us-ascii?Q?cq5mESGVcNDAk/4N1EyWyjC6m3yrj8zBINq2HJ71h3Y4IDAGzVPaZUr6Se3s?=
 =?us-ascii?Q?pRlwNKs8KBBr6EiTtIsF9ssJyXSDzKIy8/fRm52eBGYHIbGLrR3QjE8XYwLp?=
 =?us-ascii?Q?QNtY++WD4ZhxlujJToIbNeQFlMMrYO56xhtXC+rnEvZqIfhFlWKSW9CwzzUO?=
 =?us-ascii?Q?NWXu/roJYhocjPe5NFV52utpexABE2QSQIj6l6WQAY/fwEpNmonOnHaFPYAs?=
 =?us-ascii?Q?Kiw+tNHPb121z1h0zueNoUxF2BmLzfch4V5Ub64TT5CHWM/R8R32C7p+4OAD?=
 =?us-ascii?Q?JmmjGweFUBHqDElgMhaaiv9VEWuD8Mll3VTvckqHOHm+qJflus/rT9xj7Z4n?=
 =?us-ascii?Q?mqgdGgYSBxA18UuODehTCejdovVnfH9XEaptD5oBltdv7ERarq8/d9T2+68b?=
 =?us-ascii?Q?U8z/aaKgM5JJMIH2pJZ3DXOrh/Hfl1tuEexTHJmBfWQkl+236EneHr+GCFRq?=
 =?us-ascii?Q?ivBIyI1mlzSj/pryXs8T6O5jzI8lUc3jIS/EtoA++TYCYUSUp9I5pRVwuPm8?=
 =?us-ascii?Q?mwHAk+tVAY2+gszvW5jL42kLCEnIOfpHzznEsa4484oQMYuEHDEfsZTTpJOv?=
 =?us-ascii?Q?DvZTwq36k1sUnIzh0vzpzH8rPqz+ZeRmpuZnU+4Fuz7I2xRHSWH/5+UW55bI?=
 =?us-ascii?Q?ls4qfWzqkPCZKGorzueAbiR+LZcmRrNhAKfUKjK/W09+/m4CnmFWwAUmIea2?=
 =?us-ascii?Q?X2FM6sP8OaNc/4qloXgRveK+UI3PnWVjkB1IeF53m/crSxE1jZkGx3T4+Mun?=
 =?us-ascii?Q?HeZoByZbA1TuXveaCBSXdlY9sPMAfpu4lZRG2zf7HPgqU2nTpxl1UyZg8Hhn?=
 =?us-ascii?Q?LHqjn5ArYSuOyEQS9/mFb3srgv7zgGzcaIUmR0GxaFVwyOJHE1TsrqzwxnjO?=
 =?us-ascii?Q?zudgfhLxQzQvYxX+ZQhAHqmzarVvJ7LrzWnharLUcXl4HdfJgX3i2CA93aZi?=
 =?us-ascii?Q?UccaiJRdMTMOwws4ne6OABAZO2EhU62tfqwZN/vZ+Mmu4+PAR9rNrjP63kZo?=
 =?us-ascii?Q?rjfrjhYnos9WwPIdUASlLPl9mJHdObNlJW0Clk34USiCFVd/TcDiJGuXbHlL?=
 =?us-ascii?Q?cUA8eX8jTQIc0Dga2YVDu3lm5sLrsj6Do9rTamcmPiirBU+L+v5V2VPsfjrB?=
 =?us-ascii?Q?cDfhyQ4K7GUN+q6jmdkJ5lxYcyN/zrjetpmZ2QwB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ca145e-e8c3-4828-6fa5-08dafa26ef5e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 14:10:35.9254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBcP8z3cMOfv/VMjmCMto5OWuRLamneKNcdG+Ci2E5IP8YDWS2fxjVx8pH0PCgIS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6215
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 11:58:31AM -0700, Alex Williamson wrote:
> On Wed, 18 Jan 2023 13:50:28 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index f8219a438bfbf5..9e94abcf8ee1a8 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -10,10 +10,10 @@
> >  #include <linux/device.h>
> >  #include <linux/cdev.h>
> >  #include <linux/module.h>
> > +#include <linux/vfio.h>
> >  
> >  struct iommufd_ctx;
> >  struct iommu_group;
> > -struct vfio_device;
> >  struct vfio_container;
> >  
> >  void vfio_device_put_registration(struct vfio_device *device);
> > @@ -88,6 +88,12 @@ bool vfio_device_has_container(struct vfio_device *device);
> >  int __init vfio_group_init(void);
> >  void vfio_group_cleanup(void);
> >  
> > +static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > +{
> > +	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > +	       vdev->group->type == VFIO_NO_IOMMU;
> > +}
> 
> 
> What about:
> 
> static inline bool vfio_group_type_is_noiommu(struct vfio_group *group)

For Yi's series to work we can't refer to device->group outside
group.c - it should be compiled out entirely in some kconfigs.

So this function is the right signature for the call sites I added

> which would allow us to pickup the group.c use with only extending the
> callers here as s/vdev/vdev->group/?  

I think this would an OK mini-cleanup for group.c..

Are you OK with it as is?

Jason
