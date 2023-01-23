Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09176784EC
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 19:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjAWSba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 13:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjAWSbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 13:31:15 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC833448
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 10:30:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljmLUb7S505r7H7GnkVqfoNHhEMeYMmn2Akt23uIECW1/0t1MnHhUhWRudt9g07lbR0uApo/O2+LnzvutLN7MNjihLfWm6VDN8xIZ47mMwipgFUgYwUXAJMMLrSfoWUnEnA+sKNSZeVlKBXMLBAEa+8X06HMP2cDoECQAfk0AuRdhlz1w5aaJ/N0RUewS7rI7R6RLAjq60KUTEA0znuD3yY0tqjK3bHmb4W1/XT5WabiEvtlNt8cvsSzTWVIv75DhrOmOJXSv4/VSMTNFjkrhD4JvVSWnsxpsKq6dNp5UvnuIbk9Us+eizf0ZwblaGAT/Yi74ClCIO/oVas/M4TrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWe/c6eYYjegg2mlLjAGr7qYCbMn7v9WxVeiaC6wltc=;
 b=Vijlghnzy/mmrB+GWD17RAiDkkMZfAFZ6HoglRAZUmVgSnaW0S0i+YjbjdLt+bsPsyFwihe5H2RbeF7tfhgA2dn53ldXXReJ0iotIwDhd/db7CGY1Ry/BqQIPT+UlAlqoN6Suk09gjaSMzU4trZpz0uL6UEd2gcHBwFfdeaK/yqbdug7Kf42F6A5gR95zQQH+I1WN1vQLa1hPxe232b77nwnAdBsflc9hG5TZqSdrm6m1+CyzJVPtpXhRBK5U56AVoGBamKMQndkGMHHm02UNUWwue8Jj65ZAfAY2IBqKr6rytScE8+i9yj6onMgq7iR+9OAJKjrNZJs0xXtaz35gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWe/c6eYYjegg2mlLjAGr7qYCbMn7v9WxVeiaC6wltc=;
 b=HVZZHBYrQdYDYR2/DsKJJhin19xn7k15J1UwNCxslyXZ6XRvkOStwXLxdL6+0AKKZephow3Z0X9LmPIDZpkfyBt2aQtLBRYhBlRe+N1dBPQ/DcKCrTG4Kc1qAfGsFnSSsqtRA68tNs0E3PtKxaJADNkKRFJ5GLef8rVQgmkJlR9XMt5jiBsGrUFBYSZHQnsifDWQZY7TaLR1UfAccqcE9VDF9Q2E7qj/9F6I+nwmfP6vClfUEgtG2CDVs7hAwCWJ4MDFMkysXwDxjNe6lokH9Hw9kGgHQKvflIKhx4H1rIyqmkSU0Y5/0FmgTi4qirFTm7WfUsoWhu3lwyiPpHg1Zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5937.namprd12.prod.outlook.com (2603:10b6:8:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 18:30:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:30:35 +0000
Date:   Mon, 23 Jan 2023 14:30:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     kevin.tian@intel.com, kvm@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [PATCH v2] iommufd: Add three missing structures in ucmd_buffer
Message-ID: <Y87SShqUIA5mYBVB@nvidia.com>
References: <20230120122040.280219-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120122040.280219-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0165.namprd03.prod.outlook.com
 (2603:10b6:208:32f::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: db2d39a9-e274-477d-d08e-08dafd6feb05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQxmX92PfJ3if4wfeUo2vvY7gSm6hRe4Fu/QP/SD8Ojm8WpQYfMKP56KbSMg7kyqtIThppQhOB4S3vO+rTdrUBvTlzWsqfqSwkL/gMoTDs6/MwuKUIDElpEiGoWVwxDwjVR74SS7BeSkO0DKDpe/ej+lfgtJT12jEFgInquCFW1GnU23/myz5CmGN5lXaHw2HQTy2byLE/cS8fOenwFl2zqWgVudmL2gJBgW6ERH8fNI7mWkcqYAJvC9zhQ2FG+/zZVn+SaawICloqxn0nYHrsFHVeBPnwBJid5G7EXThUfxAwdICH6UcHgTUULMYL7igCGCZf8cUjrw340BjKFf0gVERJeltsx/WR+H97OVB1Bon7w6ke1qIICirajyFXxcT3cWAeV73LRDsBwxaHHmd4V70l/tCqPgdmaVhWg75bRZKmVt+k/0wX7jHG+8Z5BRj2FPOPqe1H4SoIqqsPyg9Rh5KO18XqtBq3fHiR3B7GVpfN/djnEiSsp8Z7MIgK0FJnYnj64n6jtKkRB61HMl+ywqfqr93weZc/14xIrTMzoxNU9lNLVcdUFYkItEw4gW1SV4yy40zsfM/WyEKsatVkWvIR5ZVWPF2RozQCYFJzrzo+vWh+s69F0pBT1IBD1dUYkM0pP/OTKEZ+WvY0AWy2Sz3XLJWCqmMBLq08XEECXVXed3b/tH330g86PsfnW3d2awLCnXS0qPxAQ+QUXjf9TNTw6/c+NNoF3ZPl7kkJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(38100700002)(36756003)(86362001)(478600001)(316002)(966005)(66946007)(6486002)(8676002)(66556008)(6916009)(4326008)(66476007)(2616005)(2906002)(6506007)(26005)(5660300002)(6512007)(41300700001)(4744005)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4FtV4idSZMkWooMtkYdRP2Zn3ilTcPLSDThDk+fzEgtzt4xZ0LeNeBQIk1Xe?=
 =?us-ascii?Q?GaC1BKn1kmpr3RzKfYoWOV1Xe1IYdH6EiXdyqI/jBoVft+62oemNA8UU77DD?=
 =?us-ascii?Q?aY8ZdEaoaI+Q3MlGqsgHGPASQW2c+EFI/SppeOjHd7nL2LWxsmHCDFkbxY/A?=
 =?us-ascii?Q?8iAzyi+fqHhQ/1Pi2dz024HGY36+0M1gNesuysazvb4RhK1sQ6aMlXidxORp?=
 =?us-ascii?Q?garoCPTJ/tH+D6If/DI29Qebv8fGE9DV3589KKpZx8C2l6YU68QTfHWWx8Z7?=
 =?us-ascii?Q?MK8ShwFkw5si4gjPIk23/D8aQfZTFqcTZtBfnIwtAnZDZh3/pfrZWme0gEgT?=
 =?us-ascii?Q?yy9NJ+t9Z0X4MxugvbYOKg6d+epcc9Y5ckfQ9bNee9QvqhipwJ7S2rvJX/Ja?=
 =?us-ascii?Q?JNC6A9XW+qnRzC+Q5M5+iURKSMTbCg32gSwxvB1QYqtib/fgD3hOaP3NYVnm?=
 =?us-ascii?Q?IRLwUnFQhMS+zwjfXC7OpUaClKmtsh9Wh4Thua3l6Ufv86Tk8hLtwizdKea/?=
 =?us-ascii?Q?qFxSymS8cCdz0EeCSLs5BXQxwKL+7iDmystpiSwgWCf6sX2xnpbav0z+P2Q2?=
 =?us-ascii?Q?FbXoYQioim4Hx9JP7k81wfmVEPKTGjWH3cz9IxAZOkziq/6OkxHkzNzOPHpN?=
 =?us-ascii?Q?Gmwsz4R7jM9+4Ph4G+MlmpTJzHXGeOYlBheFJS6xNWw8LjotrSxTInnyXZkE?=
 =?us-ascii?Q?L1+jHoMtU1/7e9z9xMeJ+1j+aYyD840VwYJzH2EdJgsHNLZXKo1yvm9YpvS6?=
 =?us-ascii?Q?wzjMlf5+1+43gd5gWEN28uutG7NRpPLZaBwbiJUfl/m0x3cjP910fR//by5R?=
 =?us-ascii?Q?lajubQjWSisnpFbjOup+SrB3CM921htNyf1eeKyqYdGjRLfHrZeJ4iaMY97A?=
 =?us-ascii?Q?8Y3b1PHdo5FsLLlK4GtPV/qxp3O65Bw/DHuYsnqgow93BABlYs179PVnqiSO?=
 =?us-ascii?Q?sszxzmhFlQf2RvvoJDAtWwX8BifSb5EBTkJwQdO3K7DOsoiDDAFNK9gNiNEq?=
 =?us-ascii?Q?KSEu3Cza9iWkyFxJ+D+1as5PtA5TVRub/uq7fb4izBbNQOMT8IyEPKrmocdB?=
 =?us-ascii?Q?KHFd85Ts9xCsgf3gS6pGcwJ7pwFMHAU32eJZg6osSnjt/7jCKth+ki/Awsf6?=
 =?us-ascii?Q?6oa6WNC3T6qtqTuGaYuKAB95wx+YBRuemJkmAxq866LDOeOrocgG1210TkS5?=
 =?us-ascii?Q?VmJbhg7eg/4YD1lQBHslGbOSkhO3mndg9jSbt7UXalBmCIrM8/oBdF7Ujc8q?=
 =?us-ascii?Q?w0oLHCrlzE/9kp9XfcdCDGFNhuBPDR2zwMD2NcpTdijRzcNt+DjRbPD443dn?=
 =?us-ascii?Q?/9UmGPs+4l1/Jkx5JZqU6DJvU8C/mhPLOQKcP/78ALGHIiXneIZJxuUzrROp?=
 =?us-ascii?Q?fkHYNt9xwb4EpmLJzj6+kE3jreTtpt24cQkz9nWPGdM7avOdtwSnn78ujOJQ?=
 =?us-ascii?Q?fq7TJ3HS6lUJ1pu8k5B4sZYvDTfK6hnlYGLru4rIVy9mvQJhzTVx7HK3xXMH?=
 =?us-ascii?Q?N3XkX6pY2bx7fdnG25g7dqbqA9uQlkUzuaeSiL49FdiWH362LRkLUVjy/wk0?=
 =?us-ascii?Q?wb/rda7tOfiXyTgMdkXBkjh86o+h/Sag0hWv55cj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db2d39a9-e274-477d-d08e-08dafd6feb05
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:30:35.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRNbr4qrAX7FY0/g2tuZyPTKya0p5kcHRxPvCZtpf+uVVDchx9ELMP0hQls+24kA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5937
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 04:20:40AM -0800, Yi Liu wrote:
> struct iommu_ioas_copy, struct iommu_option and struct iommu_vfio_ioas
> are missed in ucmd_buffer. Although they are smaller than the size of
> ucmd_buffer, it is safer to list them in ucmd_buffer explicitly.
> 
> Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
> Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
> v2:
>   - add iommu_ioas_copy as KevinT pointed
> 
> v1: https://lore.kernel.org/kvm/20230120055757.67879-1-yi.l.liu@intel.com/

Applied thanks

Jason
