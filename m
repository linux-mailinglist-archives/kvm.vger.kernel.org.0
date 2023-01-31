Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486A9682FA9
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 15:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjAaOsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 09:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjAaOsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 09:48:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAE3F8;
        Tue, 31 Jan 2023 06:48:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3ED3KNeB40Es8wCuofKM96fQoiT49RR8RsgkejoB35de8l3ZIWpxAH6QVo242XFH7Vx3zvoKpSdXL3cXqXYOnK4rJo0p6yAOEoXfw1u0hREGt8URiBIv51cZOZi8BYWe25eF+DO2uQBHAmuEgnnMWGnEvzzbOfTkXHXn9YuNrf4Ea9+P/xH6q+mnK9YoWHhrcEge74cDWOugnUy2wPXQQBrnbPUGxfNI+HlT10GgEzr8/Y7TFSEjFV3aS2CYiaZAhI4zzch+z26DMBU5sjJAyoa9T9Nq8EbAcYV5mmnVw7tLCY4t0pqH5hElaSvXf3fat0TTp8DRShHgxZKSPx0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RhC3a3INeFkJPQumxDJk7IBU3lip2mEGtDAKTNZ1wo=;
 b=EbkEn1DUz/r67yvmP+mAUnLMzfJ2dbaQGIYs4olV0RiUbWn0pRyrpzL0gZQhS8HLfa/+irMJocZBsZnKYqHHaM1IgtPdnXlczLX11qyTdTrarbLf0JRAGGWhtXvlOXKMvqT9DszYI8BCnFQdWCjnGtZsnsw5S+TcfCRvrFOEQzjBaNwUJWgGZv+lGC8UOcX3+VTkWFHJuhKTtyIxAozAqb7E25zJvf70+QR6Ual/mQCZbt/aDXtHMwDAuKhMz1KVQXJ9AUX6kh273GeiNSmf5ZPujg0LnNMOkgB+hx+auCoeRNrFs/KaT7FQjV+Q+zWapYsJtNbDrtm889xsfI6Wsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RhC3a3INeFkJPQumxDJk7IBU3lip2mEGtDAKTNZ1wo=;
 b=bJZoNc+WLGpAsGzXY6Mz5131HDAGDg5geKjQAyOKGkAa8UW+ipntIMyuW8F4tXnoqwwtT8rkwsxdhmJIA/M5SUyEtzYu65AB1/YS+nUrKptY1QqZkrm1DCwPbPAp2sa+i44jgfKreu0D6cApVP/NRokitZ/pXBx681o927Y/i7N0+stSbvt2kldJMgCO/lXLXIej8J5+j36dsklN8Co8tpb5Wm+PSEGVgFqdb0YSmUmQrsSWQWk/lStU2mbNGcbiIVQy3vs+l8Y3SmJygUxqiCVUasgwYyomqwybHtj4yCgSqNx6P75pYVoh0TKQ/CBanrjTSwogdjmm7QwBb8ogEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5163.namprd12.prod.outlook.com (2603:10b6:408:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 14:48:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 14:48:25 +0000
Date:   Tue, 31 Jan 2023 10:48:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, mjrosato@linux.ibm.com, kevin.tian@intel.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        seanjc@google.com, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Message-ID: <Y9kqNnJ5ayCQSW9z@nvidia.com>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
 <67ec09bf-cb24-34e3-6ec4-1ae87b0738bd@linux.ibm.com>
 <Y9km+xezgD4ovjDX@nvidia.com>
 <b0ed98f6-3586-3151-47e7-9ec86d6c716d@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0ed98f6-3586-3151-47e7-9ec86d6c716d@linux.ibm.com>
X-ClientProxiedBy: BY5PR16CA0019.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: df1f9077-ae53-4a12-9ced-08db039a34ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YM01pDvbUPJ/bBGLEUfmnhicp2CdOwd9FEG9phhAcpuq24qtwW8EVDtkY86rvfMNo0027/GWlHtPIXczePKHSLzxElrQ8LlpGBG4I6m/8w+aP6J9hkWvbeKs6AyUAyL4Iw/h+ErFvCAngvcf5xc17UFXGHfmg2Jt2mctXLB59vQFeKzU3al05QaJ4hhPfWEDrwnBpNmH4/Dig2ry/7qmDoTLrHhj7lNT3o8JrqVFyQZgyuFQ3249GjhFRJEUAl3ju6buS9fhoI9FHTjEROE8hfTBzmB3sp4eWHnK4mEPwtyxsjAdcIPpknjtBvZxlO02WksluRhR3mGPAqS91vJ1LQRXfDGcYNtTA7fzbhTfcWSws6+r+6jh3kEA+2xVIbgBh717XajTyFiggre3dVUI7SViTWzopOm/Ms5T4ecYThG7t0HWx4bxmw6lGrBx4omUxPNz6mJ4D9H5XAdIiYAM26GNAlC43B6lDtfl9mzJoOhS7Khv+st0akXB6f3DrlNlvk+hlOUjqor3DCgUjQWD/Nea/OtYtEL+Fxm1ym07Z0OYg2Yib/wxoPSMI8WnhLki7ZjF54pzoQqEWN0KSO3O0Rkc6NO+OG3wO05KhkHAbmBL2U/si6FXUJAqJaCiV7wHcg4AcXT18TdoO5HzcvyJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199018)(478600001)(6486002)(5660300002)(38100700002)(6666004)(6512007)(86362001)(26005)(186003)(2616005)(316002)(8936002)(36756003)(41300700001)(4744005)(7416002)(6506007)(83380400001)(4326008)(6916009)(66476007)(2906002)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aaJ+yuE7lb2TKu39cnydeyH1VSsYxEp1Ow+PDPbltzcoG+1fJdwtQklTLTLi?=
 =?us-ascii?Q?hj7kTZZDIeSwCqtbwsedbmcUvnCxUDDxRv/CNyLcJOEHXiM/faYy4FbysI1A?=
 =?us-ascii?Q?tTNEv5OGKssvobduBY+c+HDlQSjxJ/jdAKKB6knlGV+lzFqvcpScW72g9fCx?=
 =?us-ascii?Q?9ROLzdXqaFDr3VL0GYGT1sNCSPMre4fIcZsynB+5vxzkEiaVk9xo2edsYX64?=
 =?us-ascii?Q?auRpOXGl5HZqqkuccmfrmk2cEEn0qNSRL6fkmr0lErDYazcSN0cKQYOxiSTx?=
 =?us-ascii?Q?WrP7hpzdNCvJwL1cm+R5P1M8UhTj+7S0bkkXOmnnZzLX0MV++5j+Qu+OwEbt?=
 =?us-ascii?Q?+H7TtlomJ8hBX714d3yoDr/AlpWaMCZXD9I4tvu0zfWoSsWFU8O9Jcw1lJ3n?=
 =?us-ascii?Q?zfpJABL4K4Ts9MEJE4BID6ToAhqIpKxB2k5uv9pwuYotpnKSAb5ZsYYaUkQy?=
 =?us-ascii?Q?tc3pnAQvRLDojy3Qo6pQM4s35yqAJrHqSBEw03Y4W1SMGMWGA3fmR93IrM/a?=
 =?us-ascii?Q?1aHsTwa3/cefPudiGsLDP3KpgRxb88bsNEk1ByaTnZxvdRlgYqyRVIv09XGd?=
 =?us-ascii?Q?h69uooU6EXYwHSikLpcrD7yU0FWHl4+j1SPMg0HD4JGnjA2DYuDSdh9pFZCZ?=
 =?us-ascii?Q?Y08lRMIzGLrGEwZfrrnLZWrZY2lzNCRwlkSsYdvR+s1rPuZjL7w/OXXvj3rJ?=
 =?us-ascii?Q?uaUuoS3W80fh/LXQwmTHTIOSmT/J6gwMYzku9HlAcTZIhLax+eaVxr2L/Bvs?=
 =?us-ascii?Q?CXm3lk6LZBKANAVms/BDKE0YeC0gidDfFMjVXlQbpt/gh0+32sQKBtjJqHW1?=
 =?us-ascii?Q?Iyz3ukLhVEf7O+fEjzvOzP9G4oLFlDQAHdzZ+rVibRlAEhsZENPfmBoyfmh/?=
 =?us-ascii?Q?HyVW9I8noz80ojlEXN5tAdoiNSIkdUYbc8Ly5RNME1yKkB5R0DBEeMDw331K?=
 =?us-ascii?Q?JlYLYRS43x/cTm7gA9Cxa5hyIztveS5+Xc4vIz3JaTKSDuQDAXfIGoZShxZe?=
 =?us-ascii?Q?m4sQDMxNWdk9W/rtOQ7fsVXNdNoHwe2q9sVoT3zxOMRSJyFUvNkujIIzic3I?=
 =?us-ascii?Q?7jinJ9K5xPGcO3Bn0zcZrJBlklG+R3zIsUvwHgZtWsLk2YaeQZHBuICRuTLp?=
 =?us-ascii?Q?KrLLaWzKYZcO1SjYF52Nt+OSpDagNEDUBzE3D91FKJNit52WQ6I0O/J8g2Ym?=
 =?us-ascii?Q?wsaYx6cDxn6+wux97srWb2dgGiNtGt5U2ScPGuADY/ox7PCysLF08vtiboJb?=
 =?us-ascii?Q?Awg1oX0HjpGYGFB0vvuUT1sIzNciQkDHlj3WgAqzGJ0bEX+iztI5feo+8suC?=
 =?us-ascii?Q?zfvQCr2vXoURH7pHTkyKzXU/+gcDPT/kcM2ObczDA9Scpn1494oQHkh+byTS?=
 =?us-ascii?Q?//2LOfL9GcHmx2lMWJQ2NX44667+kuwUyUz11kwoVdqm9iWndmKRa5T9S7Mj?=
 =?us-ascii?Q?jaHNyvfYxVqgJCMRwWY01VDQKa7rIGKa3XlbQzxZ3XB71TyYf56+utTn9j1g?=
 =?us-ascii?Q?HqCBFP8CrRWHtx4faOO8TonDRKuP3eZm2BrgpX+Aeqp4rhs2PZziW5n9Wckh?=
 =?us-ascii?Q?5+R3K3+UuSxPNqgmHYU7Ti8KwGrV72Q6ZQ4m0hGh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1f9077-ae53-4a12-9ced-08db039a34ec
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:48:25.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hj5u4RRp6+j3pwhcXTDVht5SminWHog1xP07sTKODYwtHnJhhcFhBQek+rAwcjZH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:46:18AM -0500, Anthony Krowiak wrote:

> > Maybe you should split that lock and have a dedicated apcb lock?
> 
> I don't think that would suffice for taking the vCPUs out of SIE.

Then I think we have to keep this patch and also do Matthew's patch to
keep kvm refs inside vfio as well.

Jason
