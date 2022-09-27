Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403185EC3E3
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 15:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiI0NNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 09:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiI0NM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 09:12:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04BB1876AA
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 06:12:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLOtItKu/mvEMuzmGDwe/MO3IrfphINAD4xJeOa430V7CuUEh+a4/DlX90lsETwBNaPIvdcThfqmUtWOfxFaYRchoChVpkIGoSFHahEGQvGH28qMpuaow5tl20bUk2Km+jc54FF4NzVnj55ip/MY3RZ/H/GZm/9GePApMhzNdrD5Ueg3xNM3eC7lQukgkKK6wRz8nA1KUZ9ZD5u/u+63z0pLwx/MKv0lKvVPTTZgeBTqLeKF1qL+JtBua8jNjXupitnSqaMIKnnpPIuknUHKka4P6Nv41JoCvMX2qmnjE6VdiXW80ZThIabZPF/TiTQ5KzoJun9zn+j8ryRqYR5+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8jhozoZl4Pvb4BNx/B/ZoiBIvPLoZK+DMnvsxstOTg=;
 b=WrC/AkByRzpe47ZpIbKkavEy9qJS1p5LGTL2prQH09nF3lpexbM64o16qvMOzhxurcGda7OP2eI5iF45LzXnR3UPZ0CdIHFYeSiWJvJ1ePc0jXCLWCR99lIv5B+Y10wB+lAKNqg81TyTIU7G/CFqoFRGWWBke58V2NRgSmpiTrF7N8MIxUr05scOZMg+k79haF1juPTmXdp4sYJOI5TknQoaLG/YxLol8QUYHzYPqCVIeAzsuioL3VQ8ZdlkD+Zwks5F5YCKxQtE68T6tKGnXnPG6WJToTzQakW0SiqjKKHUr9f4UqkJGLYkDqlUtsDN/jDx/0fuJG/jOKms7qz1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8jhozoZl4Pvb4BNx/B/ZoiBIvPLoZK+DMnvsxstOTg=;
 b=UdDVNNU9wwmnCQ7OcPYcprVpUewQAbtcIR3cLAvg6uVL/AFCjdBukb5eqmxr6vDsVqLlCamWFudHNZojdhmNgPtOy+B36MslqHN+aJGF+FghSzOuajbt8a6ufs0kUqWLpNkRapo4jGhYzNUEeP45Cl/Fzcu1GVLxltN96Bsh3zfkn7OVL6fhuvOHk4NiEpxkpzLsOuUz9+UwXEFI/N8n5vjXIqpKO67Dg7ctEhQK2NXMwP20RDXZqzUHi0P/AvCwrixei+5t+fhhjHop1eyx1pjaT+dI6HwcIM7IYA5vR3gPc5z88WcyqZ3nGyRtASqi9hvV1ETNGfe6MrzkxzztDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6319.namprd12.prod.outlook.com (2603:10b6:208:3c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Tue, 27 Sep
 2022 13:12:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 13:12:13 +0000
Date:   Tue, 27 Sep 2022 10:12:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <YzL2rM+I4SAiVEXv@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <152f5880-04c9-48de-f9b2-e86a8577efca@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152f5880-04c9-48de-f9b2-e86a8577efca@intel.com>
X-ClientProxiedBy: BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|MN0PR12MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e2b1cb-2e54-4b01-27be-08daa089e4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A1Cy+fbUu5C903l7+Nlp9o7oql7ND1PYyxg3gX4tx/GjJt3YTQiICbR0HQHz/Josh6zzJcmQoIWtYB5dnQfqE2WXb4TsP62V9LO2I7IrwjQwtQIgirdlz/mvkKD+agvxuMfebr8xgcFGb7DfTY4v8kgsXETa5k3MV9XEf5YfQkB/AkRD/E5LVe2YP/5LMq+B0aIZau8xpb0RUfPsTdXYlWNuFxcXSRX6nGCv27Px4Zv/MvJPF7SsQs0Pv9Aoythg384MJ1LLBCMGREsZRAnch2Bi1Dm7SIXM2RRgCNK5Ge8wlm7osALsoohU83Y6zINYBLJnIxURoQ2kwAefIjdn110uC0Wak7u2BS3yN1N2ISbYmWyRxLddFQmRHGcaomnaDdeUnGVHlxDcntQ5llND3mLH6OONTdU5w9LEx37/DkZ1AOe1fBQmlvQ8L1Al+OLHtg4fxFk/NLXderDi+AEJvbqsczHTesVQFdDlFc4tR+wokCDVKb3hWFdV9C737GC+VtciHBzyWLm+ZVACJUXBHulaeU/af84RmYq79yZpucsrAJ8yMvnbBJgzC8SOBbXDgPF0xg5N7BWt8Rv2H1BlfNzKDuIgmXaA1/VSFbQITrsFXa0x3tXQtWZqPFjI7yBn8aHLmBmFwOXMhSRVkqpWHF0wqRhNwvYT0RrJasTjL8H8dqPBVvIiqgy91Bn6ixgx+Xm+RPfGkeNZ0h4jaVZHaogkABKWbIsrM5R7QGZUn3QnyYABHQQ0NYhJHSLj/npYbmdgnG/tEJyGNjXnRq/JTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199015)(36756003)(86362001)(2906002)(26005)(6506007)(6512007)(6486002)(478600001)(6916009)(66946007)(41300700001)(54906003)(66476007)(66556008)(38100700002)(186003)(5660300002)(2616005)(8936002)(4744005)(4326008)(316002)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SOHEKwHYaGxE+bAa21s7KEOWqH273EfwIsyc4mpCS1V8J8V0n0jOHE3N+fiI?=
 =?us-ascii?Q?N4Nt12zfg7pX48nF7cytGCv2AUKNi5gG38lHobKGQ8pgOwXu9/5sA/kYZ0K7?=
 =?us-ascii?Q?m3xvi4KHI+wbH/3O5hMnjdKFMks5FAyTXuHSWXfhgycrwkVNvndThDD8CVFw?=
 =?us-ascii?Q?ZUvMfEzjvQC3NREsRq1oQzYFRGhU2e+nLnukG8nGrSYTQdqqn6aOX4g1MLCM?=
 =?us-ascii?Q?176C4cgkjCi2Qase9XH2QCyKfzDDMSmwVY1DNjuUwm4gUxywcslP202aq+tS?=
 =?us-ascii?Q?kew0ojuWZOewUr28jtznbKbRR43AlO62Gro3jHeaOUbwbmXudE8rH6CRvDrK?=
 =?us-ascii?Q?JHGF9qQXLVi6hXtDsspCCsLQrJidctgaahqXfU/YxtihJfpHW0SV5mugZxmN?=
 =?us-ascii?Q?iILsI+9cnk/g9GOTW63UUw5KKMnjJoGyRpvTjsVVy5/40gPtWfzKow2oYKKJ?=
 =?us-ascii?Q?6USHzZb++iMSB/pJFH2yW/xR88GhZIZIvHS3STfXVOIiFUxRBRpeVsZILPBT?=
 =?us-ascii?Q?OP46K+D0M/eC1Aqr1bcDjMnn/rJZJhQsPD9Vb8SacGPGvxpilFAdC435NFLt?=
 =?us-ascii?Q?Nwi1btwn8Qyp40e+M0T9cdYC/63NG706zc7gXlY37RLi7oRzOOUxDmR/JbIO?=
 =?us-ascii?Q?/kypR/99wl1iHbPzS9bWgQbnUgHGyhOlFNfunBuFyujsmgujmQcGMEVhpeHQ?=
 =?us-ascii?Q?tQKNqPxDo3I8YUG9KKEHOGWjjZ5Pcp4QnPEBH/gYqjyB2l2V8J3C9cIO5RAv?=
 =?us-ascii?Q?S2UHIWShBpX0EBGEjj6tfLbXB+98Laaq98Rq5o50pw1GG5X/SWy51iaZ4kC6?=
 =?us-ascii?Q?ei3Mclv1n26VtUllewx8M3N0mzmeB2xX3ILZ4o71S8EsRfDX0Z4G8q+j5RXI?=
 =?us-ascii?Q?phjKqVrIPCin4i4xelvXr9fYWGUByBRqaMcWSYhU8I9OCRYrbZlY2zM6Kigu?=
 =?us-ascii?Q?j1e/onX1B4ClPv+3MjgGzaNM4QPBgG/OjQUjbXSba5b2mAADT40jioQ9jtjD?=
 =?us-ascii?Q?Nksc1y0ru9150n7m2PTxaGTDC4AnLrEU7YjdsnWnIg4PovFGoFUB8ttuJBE0?=
 =?us-ascii?Q?MQROG3DuyRKxXwOeH0uWbdYE7qezWJWdDTL4tCEzNp+0652twj2YL+TOqzg4?=
 =?us-ascii?Q?GtghgyTzLdiUak1vTkIdkaqiy2VaBgZelH/nAAGyc7YqqZa+lUv8xEFb3/ui?=
 =?us-ascii?Q?3eLI1zgiP80q2ymyXSjSp+Cd3ra3q5ZSSMtD+QR9u2wrzBUv+56FJjUQfIOT?=
 =?us-ascii?Q?v16duu+InzaqFhIXapfuCyMMNtj+5zsdTRit8+2tE4vt6chCJYJA0foYfWzO?=
 =?us-ascii?Q?tPecD9Aopd7Dyo3I6lEXACc6C2HEzxWfjnRTDjpNaskBDtv4Qaw+VNpYjn9P?=
 =?us-ascii?Q?erZTrLWQErU7k8Jj7sdgeF4gr28qOF8s2HpOxc9/DiuXuI8/RO6Yt5GvYC3h?=
 =?us-ascii?Q?e4ZNWyFOA7lkA+UtafdDsPgBotJIbPcy0lvLeWOs9hJOa6uthSru1RYeReHr?=
 =?us-ascii?Q?/f8ASQ6sfGoOEU7tno2GAyIMlk6q00SzOcZ9f07sviGCqFjw57Rdd0m26vwR?=
 =?us-ascii?Q?vaw0hMvhEssAnfDqfKXGmeBx9TX1EyNa7lM3G4uN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e2b1cb-2e54-4b01-27be-08daa089e4a6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 13:12:13.4810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZhn8sX6Ucs21p352r+dkfhkki3OGUjn7yP9fxe7HkDOWBSXm5vrtuvYvf/kHkXl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6319
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 02:34:43PM +0800, Yi Liu wrote:
> > @@ -137,7 +135,7 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> >   	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> >   		if (group->iommu_group == iommu_group) {
> > -			vfio_group_get(group);
> > +			refcount_inc(&group->drivers);
> 
> so the __vfio_group_get_from_iommu() can only be used in the vfio device
> registration path. right? If used by other path, then group->drivers cnt
> is not correct.

Yes, thats right - more specifically vfio_device_remove_group() has to
pair with the two allocation functions.

Jason
