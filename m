Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5487A8BC2
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjITSbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjITSbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:31:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D3EAB
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:31:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjG6qVebAf2NuyoytUPWwyjHXUcbOSJIYP8JHnsxQm3Q6LikXgifNYna63EzL8uXJyc+bYo/Mqa05HubcKWc9O05QrGVX+1dcD5K7bHbQ9Cm2z3+mvgCnCgFNFpI6WO7sqdeqdGJZGHodPeKSOCx17L7dBT7jn/rGs6H1DUMKPrkbdQOPsFC0Xys0nkVGCdOQZpIxnUSYv/Bw+g01/y6QwBWDy+K6Eexjwo2f2ZgTMNeWPGTqOVxJBHKsN1NJYvQoyzVA2P6DswnYeN/y5W1rB1x0GO+Bq2lqJGMcyQ42PfygpjqFTZCoGsSZAgE59CJyHJpyLR4OIP9oJrlH55bSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wctnVedr2+K8znRrUQmXrSPvkI4a1WWRYZjbdRAhxE=;
 b=Ox8r2dT1OkAgu7v+O8flAFZMr1gVgtdFyUpF4/KB41WvVrfrC/bJU8tn5+znPMVadab12JV/nWtv9w6fO8h5ZUc35kzcA3y7YTE2IMD6R0QC93WeZrq1MUmbtfzcJbYCOU0b/t/nz7i3iZ6HZGH81iHQi/EImp2JxpXM9YTb5DpjMXr49Yuhgqd8v4VEd2t+emhWmC9+VWVlt+XEnhhRfRENUOOH7bJ6g+x/HXqzWsidlvQyr3xJ2qvCFVAmc43V0DOFDFDCnr72QyJzZV0RP30JuhrxDps/5txT/LNdfBslWWcbRpSOeqKQCEi5tTHhqFVJcW1o6yBSnEVmFC5bNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wctnVedr2+K8znRrUQmXrSPvkI4a1WWRYZjbdRAhxE=;
 b=FbSmBQ6klwTBhb6BhVvc1T+gfVDyLJrme6Cfz/W5J2zzeLbYsOhKMiYMczBwZRBejJ6HdK8VCl6JgipL4NPV0H6WcW6gZA34PEUkydx77uXTCHwGpeaaJiVUTZutBNNj7eEqaAd2IzoMlRwZBmkqmB71d2G1R1dfAPSXzpAXSk2NOYaLmc6h6OxScYG7wdFCsPXakim6GMiUR3pOAUmRVOJigNjXkc/VR7eCFKvgDv+D6JVFesux3boiTB3MxtJBCtX4WS3gEERLXn/Jb7oA65FldtiJ04d50dO65Thfy1uXmpDuW7NdPQGMVL4vZFLjtHzfavPdYLiflcRRafAcqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5461.namprd12.prod.outlook.com (2603:10b6:8:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Wed, 20 Sep
 2023 18:31:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 18:31:25 +0000
Date:   Wed, 20 Sep 2023 15:31:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-ID: <20230920183123.GJ13733@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
X-ClientProxiedBy: CH0PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:610:77::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5461:EE_
X-MS-Office365-Filtering-Correlation-Id: beed3f80-9636-4083-9251-08dbba07cc16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsb1acbSS959wQKej3bOVL81XTdZNSyDyn+VGFYt1tbCEKATo2EKppt0cYf/ALBVkpx351omDQy1U2zDyWCuUePy0Hwjtv7ujOZ1hbBtO6tVbempydDd2kzEl3qbv1K/9hXNrrmwnuC3qa855nooHclAcGFU3Yj0DViSbPocK0oTS8FSAyQ4ryaY2GnlRpiGORVzzPOwePJzE7mdCDUrphkVEuq6+2VfQU6jfW86xl8pNOjOK7X83Eh2NEZ3vkOz4IDAUNztQdY90ucSSrZaoBnL9rQCRFHnjt+Y8EbA5JqT9Vpd9DXZspV1mmGHEUU/emUkyNm1OtzzGzg1wdL+C0z+JgLi/owVhxggqE4qC4OttMicospRsXXdycgu1QaJUPoe4HW2ZSPhJ5nauD6extJBhcxg+3CHYnduRrXRzDxO2RXK7m+wMTslgBruc2KnjxCcnd3MSgDFRg2dr2fMm0jbiNveuSl/maapnpsfjjLTfkG/IOxxkdSlmk46+iwIYPcB3lls88AkniUB1gz6uHsu+MxesdvZK+wbVkq5VI36VrJbz3BwVXvWZdSdNFKN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(136003)(366004)(39860400002)(1800799009)(186009)(451199024)(5660300002)(2906002)(6862004)(8676002)(41300700001)(4326008)(8936002)(316002)(26005)(37006003)(66476007)(66556008)(66946007)(6636002)(478600001)(6506007)(6486002)(6512007)(2616005)(83380400001)(1076003)(36756003)(38100700002)(33656002)(107886003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8crQfw1wGcuy9u9SkwGO9slNzkZiomK8XXNrUv4DBVJSlpBTRLvYUq+YYPw?=
 =?us-ascii?Q?GJJQfjRS/8xyPVl9xDAyWxxJ6tRChEqHJv58vFYUL0X6MlnwdDRWMfmtWLFQ?=
 =?us-ascii?Q?Rr9tg5j+7bsjAhiv3RHvqOOxHSQAovWw5XwVhrTRGwW0HSXhwm8084qE8q8Z?=
 =?us-ascii?Q?53jb8K9cpvLB2OQZRnvgFhs/n50Y9xV2uZbZQDI6dep/6lMRbLo5IcwIL+Re?=
 =?us-ascii?Q?fOLTfcxKDweXbvf4ZtLFqnyX8fKSfV9k6iuEk5jOIp0Phut+O6T8WZx4upsz?=
 =?us-ascii?Q?Vov6yti1jTSGQR6SluOULZLViCS5VTLW0ZP+z98BFcYTshlwHbvjlnYA77T5?=
 =?us-ascii?Q?0BXTuUCLKijW9HCYguOzA3ZLR5pJPSzRlexTbK6sOhIofqJJ8kHBhCgKJhHg?=
 =?us-ascii?Q?S5yZwU8Kg6gGiAXahz8vOui87AmkoTW8VDXHQJ8jHImGapqrnL+yL+6RMsIr?=
 =?us-ascii?Q?5C5Ai3iO1wAuk85CrzH+pSNHRlSk4lCLhplPzTCl/06FT0gRKiuMujpZRIGH?=
 =?us-ascii?Q?tDUum7W6EyOEVeh3R0Tm/qplt8tdaF970SX6T6j76r0HY+dDQ7qVsW4kZ80O?=
 =?us-ascii?Q?/Irz4BaBeq5yrMQpoVWK1ynW+FRDlWH8KXonOw0gx6b9Hr7i2piH/yGETAhr?=
 =?us-ascii?Q?SX7iM6P5U/+I0MDOpx1mTR0uUYId/d4DRlawvzo/TitzTw7oaEXN5csAE77Q?=
 =?us-ascii?Q?Ce4UJhFI3nuGhmeiZxLSdk/HWSLk/i5DgklrsuWG2zLmAvzSM1Sp4zc+Aq9l?=
 =?us-ascii?Q?zx8u0eWf025tGNvO7f6BGSKkfmqo/MJME9oYTnvGSISZCAHljx/68nRsMBpV?=
 =?us-ascii?Q?iPe7dpCtEEl5iTuQGEA52BnFKlOkT57tVXWhiiQIgL7Y4B4bjalxcdRx5uzF?=
 =?us-ascii?Q?Fso9hFgSFDP7/HBfMnP+iGBjzvAoWDWDMbsu//gF5isVHZxncggvHxSM08Rg?=
 =?us-ascii?Q?AxuU+2dWecZxnpMPmUYBWsuYTSGdolzV2IRVpu3xkQiD/He/CfG0iqrVs+nF?=
 =?us-ascii?Q?RRlcwyqRhr68QcO58DV0zMbuaCBPbFtKTbeS5jsAso1mmc55KfISUBa8SbdW?=
 =?us-ascii?Q?ZyVPmY6+Kti7gJfEnDsx8477xBgzB0brPwi9u2R4wC1F7NnJ++VDOSY/8XDl?=
 =?us-ascii?Q?R9ntRbj+936//VEI7P+lw8ghV70Jrctst9I/84YQUHLcjMWWEJZMVHjWZW6w?=
 =?us-ascii?Q?M4r7ltZrbLhCqy0Z1QzW25ve8tQhUZ76kGWEJXH82wEs9k9dTfWhE5KWbZ/8?=
 =?us-ascii?Q?y0ibzjOHzGM4Rkd5BgoEY1ERV8kWAP5gm24mnKUG2zKBF6se0lk3WOloIkNS?=
 =?us-ascii?Q?FIN8gQQFf7W3FL4B6fwYu7pmV4SMGRePyeCsnhL+DPwNQG4X2U3Q5MgUKPUI?=
 =?us-ascii?Q?oJUZBkh81D83fsH2iBh8zc7BgKpTdo/1jYqzyS1tu7iWPKWB5M6Z7e2TZHah?=
 =?us-ascii?Q?AhLkwy/m2TfZxwNWk7Ngh/cv9r/ETeU55dEvJ+oUQwVnvaAzHp+B8vB8YxxF?=
 =?us-ascii?Q?ffoimZA2k1YxjnpLn8LWqVHozagF8zOOiRvY7oFwMRUfX6/32r34wK3MSwSJ?=
 =?us-ascii?Q?p6CEVVTwHvpeNhXwaPzmXEdHQ858bQKr2+wBV/cn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beed3f80-9636-4083-9251-08dbba07cc16
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 18:31:25.5898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SrT53M85CGXJaa0XEMcgRWneBlZuInn/EwMffBLitXrbb44tJqWcJGUuGj74N4xX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5461
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:
> This series adds 'chunk mode' support for mlx5 driver upon the migration
> flow.
> 
> Before this series, we were limited to 4GB state size, as of the 4 bytes
> max value based on the device specification for the query/save/load
> commands.
> 
> Once the device supports 'chunk mode' the driver can support state size
> which is larger than 4GB.
> 
> In that case, the device has the capability to split a single image to
> multiple chunks as long as the software provides a buffer in the minimum
> size reported by the device.
> 
> The driver should query for the minimum buffer size required using
> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
> input, in that case, the output will include both the minimum buffer
> size and also the remaining total size to be reported/used where it will
> be applicable.
> 
> Upon chunk mode, there may be multiple images that will be read from the
> device upon STOP_COPY. The driver will read ahead from the firmware the
> full state in small/optimized chunks while letting QEMU/user space read
> in parallel the available data.
> 
> The chunk buffer size is picked up based on the minimum size that
> firmware requires, the total full size and some max value in the driver
> code which was set to 8MB to achieve some optimized downtime in the
> general case.
> 
> With that series in place, we could migrate successfully a device state
> with a larger size than 4GB, while even improving the downtime in some
> scenarios.
> 
> Note:
> As the first patch should go to net/mlx5 we may need to send it as a
> pull request format to VFIO to avoid conflicts before acceptance.
> 
> Yishai
> 
> Yishai Hadas (9):
>   net/mlx5: Introduce ifc bits for migration in a chunk mode
>   vfio/mlx5: Wake up the reader post of disabling the SAVING migration
>     file
>   vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
>     error
>   vfio/mlx5: Enable querying state size which is > 4GB
>   vfio/mlx5: Rename some stuff to match chunk mode
>   vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
>   vfio/mlx5: Add support for SAVING in chunk mode
>   vfio/mlx5: Add support for READING in chunk mode
>   vfio/mlx5: Activate the chunk mode functionality

I didn't check in great depth but this looks OK to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I think this is a good design to start motivating more qmeu
improvements, eg using io_uring as we could go further in the driver
to optimize with that kind of support.

Jason
