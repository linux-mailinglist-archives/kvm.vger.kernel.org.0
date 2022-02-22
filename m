Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDCD4BEE8A
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 02:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbiBVAuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 19:50:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbiBVAuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 19:50:11 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2077.outbound.protection.outlook.com [40.107.95.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBB524083;
        Mon, 21 Feb 2022 16:49:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJTplUxeUk/xG1G5OkI8gsKtnIU4CjMvP93NxB16YS8NwuU4Ptg9SzsWRqva5UIBTXB5F+ijoTYKqyXcEhARhz+dYbwUgCNYB6cjvy/61oD6mJRctFm59AAZtEW2m+b78o8WTvXUImpMHYgjK/TK4/yR+EecCQ8SXvBkGYse40pLPeUm77ng1+waO1vNo2daqZELB4UolqnuyIu09un+DPERvLC+GnJDPfu/zPOLin3Iy/kk6AKYbvdNt8xXiQtoUxS27UEtWeIymbFC3fwA8Hjv6gJTKC7XhZwzyHrYQS5jF0t+N6PVff0Sk6c6Be5/tELa1FOGpEhxT8Yxrd0z0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvbpmsNA66BqnUQngsIbXAmciYL0u+tx4Q69GuqOcIA=;
 b=FyqWpnk+Zp4BouoE0O+xKW5qPTUXw8JMbDhVmLuxetzVbd4YIhPRTQo4Sw1AafJUJhcGtG4VB6iU88jxHrZnYqwlursC0r5Ce1IJoykAd5UpLmdplLGvHh8oUT/bxgAQa6o5d3sFle4VdZasgbHmbxqa8ox7rqa87qPtxipPeb/n6+V68U4XOr5ZuswO0+cKdwCN925Dkn9dj2uIVFCP3wisVqRljKrLdXwV+OMM+ShZJvJbcfPykb6W92NQjrkcp9hEgGpDibeTdpN8VOb2Fd60lPawjWnINFn9HZq1t+JBcd+rj3zyxDemTwdZsIZd2IqOyOWWXHwz/hzzaaPLYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvbpmsNA66BqnUQngsIbXAmciYL0u+tx4Q69GuqOcIA=;
 b=s6bO3dRb7shY+VW17xMDTOEtfjXsZICUd0gneKKLCg7hpLpeMJvVn0IVun/SpoqrL+N/zj256Vt7EnuKaHTHLt4E7JNn/XmA4boPu95WYaaPYgxbM17plBAAoVyvgKLWYKBMzcubhyfBfJ/GMMeSomZ7XG9CsVvp2ikoqyjWm2n9aVl2BGv5+Oy7ZY4OIcwp471RvUJe6cjQWH/6qJPNazFy0ypXqv44xhElUUBYB/KbBMLFGDlUv3q4Ba4fWWhODSArcd8KdgwR99oJJKPPv75n/FV849cgsNQ8EhPgCYPSpk335SJaaaUinhaktI6Ed0EFJBxcQEazUAgC8JShqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB2496.namprd12.prod.outlook.com (2603:10b6:404:a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 00:49:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 00:49:44 +0000
Date:   Mon, 21 Feb 2022 20:49:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 0/8] vfio/hisilicon: add ACC live migration driver
Message-ID: <20220222004943.GF193956@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: BLAP220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51347dab-9b6d-49e2-06c7-08d9f59d37f1
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2496:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB24963F0FCA37D6AE645B381BC23B9@BN6PR1201MB2496.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kARGrXewJhoN5aNe3s8KO5zUZZ+RZD4sTPFFzRuOdYeZLaieAQBL21LdiQ9mCjN6pfT0nUq4JXv6tzQ9ZWu+2fp8ujqprqfuspqwEk5MtdHRhr1HP7dK7gnHN7mujHiM5Ir/J5ZbtjnDRcwen8I40eJu2KTjhbfbJWVyoPc6VJ3p3qkHenVgPL5gaI+7UQ2wjP3/1eyumJ/wJPDifOLJgJKq+V57yRSIUAi8pH6e7eeVR0n1kagmGr0NY7P858nWP41HGtGLz1nLNvp/MZt47bCpZe+84rBkAuZzryAszUfTFRWO3NMxs7ZZjWZwTRc4w2VGloySX7nAHSQ4k/vgWxk33giC8bZKcR03r4FZq43+PvMXKAKnhKa/fpXFC48Szq/LwbF8IiwhA258VUUYlhpc+DqbS/uQwfvWvxlOSuVaW4gE2okBPro2Ld2UM2YIgImgArZQFxpy6f9rZ0yt8rHn2Z1VYHSQfe5FM+kROxXF7TpqoBxvtabxhXHalEqpLW68SxbTNUEHsX3Gsfr/dT2Dtx6t1vqifyuYVbt5BL5LXN7A+qBt4Lcj4X8OKc1Gt7a8C2S31bagGPhQSt/rvGnZ48Rza32PN6+Nxc1SDynGBpS6n0351dWoZ56nAX7WqnajjnXUlcYtNUodhUJxE+u5qy9xPixO1eIdBe9nXigb2NMCCqZJ93jtLIkzBTK6wHmFls+NLbtEdvvarj4+G8SnX9dbqVceTpgY8OuZeOwhI0hu5RUWEI3ob8m2voysx9D7a2z8O0ejothnlMLqL5sQA0DRO7Pxwi+jbjckxGNTmj0/XbPZuahZ9hdr5m+N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(508600001)(6506007)(38100700002)(26005)(186003)(6486002)(966005)(33656002)(7416002)(5660300002)(86362001)(2616005)(1076003)(66946007)(66556008)(66476007)(8676002)(4326008)(2906002)(6916009)(83380400001)(6512007)(316002)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1FyNE5VRi9uRmQzUGpmbWk1UU9BeVcxZDE0cTZhMXVGV2p5Tzg4RXB3RnMr?=
 =?utf-8?B?RTJWUXhUMk95czVMd2JFUURBd2l4OFZZaFdCT3ZjN1NlRU1MYlljRURFSk5T?=
 =?utf-8?B?cmV5SDY1c0pJU3F2VWtEci9haXkraFUxNHdhOXVXRkZqZUZEamJKTXBvZUFN?=
 =?utf-8?B?RVhxMjJnY0tSM1Rsb0ZGS3U1VFI4a1prV0xESUdJOFJWT09KTjRKdEtXZUNR?=
 =?utf-8?B?Vld5UGNCU1E4RDFGL2RtVTFlNVBwTklJdXNCczVnMlVCQkowbWVQQlRocXRs?=
 =?utf-8?B?aHFubGErSUx5bVJmMytQMXlCYTlqUWRPaHVlZlJyalMzNTlqd0FqN0FkSU5K?=
 =?utf-8?B?ZE8rSkxlRkpXR1NrRGJYNU5UNjQydlluRUZtd0R2TWh1WmNObEluWDRMa21j?=
 =?utf-8?B?bCtBUG1icmNSN0NwSk5hYTMwZTE2Vko4QXZJSFlQK1ROT1BKMExvK001WTNj?=
 =?utf-8?B?VmhwbEd5ZGhUQ1hwelB1eDQ1R3R6YmZ4OFJXRlNrdGlRZXpvWXpIak9aSHdG?=
 =?utf-8?B?U29IYm1Od1RQTVZWdGVOYmZNQi94WmlxVkpVT1VoRGZEdEJ4aVNVaFZNZGMr?=
 =?utf-8?B?RGwwR0JyMU9FSmp0cUdZeEFxR2Zuci9ody9uNzdRVXJkQUZPa3p1VFVRM0N3?=
 =?utf-8?B?bU8yWHZRNFZadXl5R1RzclAwTGVyQUFpSlJRd20zY2E2Zzg5ZVhSWVBxVU0z?=
 =?utf-8?B?NTZ5TkkvMTJ4M3VRTExvaWFzVnBxSGZSOC8xdFBMU29tTWxxR1hLL2QxZHh3?=
 =?utf-8?B?bUYvZWpiRjVrMkJnWUVFQnowa2hxQm5ocFA2RzFXd3FmMlZFZjF4TW00ZzNu?=
 =?utf-8?B?aVlXbXJqVUdwVE1ZZjZEandkOStuVzZXM2FKb28zVExFQU5mZ2dqR3dBdzlt?=
 =?utf-8?B?TUxJSnoxNkorTGZjL1ZaR1lpNk1VU2pnUVZndWRVU2V3bVJMQlp5cDZnQndv?=
 =?utf-8?B?b3Q5VTZ3M0dONGxtSkk3N1FvL3NyOFZXd0VjZFMvcWd0ZVhVUmtQbmhQQy82?=
 =?utf-8?B?OVBUais5c0VTTlNXVW5EOFdXOUJ4WkxMYjA5VjVjVldWR2x1aXBid2pVLzhs?=
 =?utf-8?B?SFJLQ3FtcUxmMWEyYVF2STZ0RkYyQU9XYzU5K2J6YjJiVk91cU9mL3FVM2dZ?=
 =?utf-8?B?LysxM0YxNzJUNEx2L1MvVzdtNHRMQ1EwS1BpRGw2L2NpNWRhemxWQUp6SW05?=
 =?utf-8?B?SjFYT2RtSXBVc29lQWQwOXFpcnFocU9RNC93VVlIQnEweW5nQWlDNm56VWFT?=
 =?utf-8?B?OXNpQzZ2MWlaUnZHazNzMFdkRjNIRjlGRklmaSs0ZzJhdXA3UVRYZmZBamZP?=
 =?utf-8?B?SDE5Q0llY1Qxc3lLRERXMTBsWEpyUDhRVkUxc2Z2RDU2L0FkdG45d2FkUDdr?=
 =?utf-8?B?dEVKQk0vWGxKV09jL2xYenI5eHRTbmh1bTJ5MDBSMVRRd0tUaEdCVUY4ck91?=
 =?utf-8?B?YnFVNVdEQ0tPMnVlWDlkRXpDd09HbkpNU3VGV1IwaDU5OEM0ZXFaOGtzc1hU?=
 =?utf-8?B?U3R3VXpEc2tEZ1lhc0NKRnRpcWlBZmd2em9RWjdNUUZVdGlNbnlDQk14WDh5?=
 =?utf-8?B?YW4zSU9FSFg2Q3BWMTRnU01sY0VWNm5nU3RTbzhYYU1RVnBHNUdQMk1mQTE0?=
 =?utf-8?B?RmY1YXVTbHlFdWhyK3I5Y0tFdHBaeWZPYzNBKzNlbWIzRk9sZmtLaW9FQmpo?=
 =?utf-8?B?UkZIQTVLRmp6aGlZdVBTYnltczNpN01KQzhHd05QZkJISHY1ejhPOVZrUlpw?=
 =?utf-8?B?RzNJR2JGelBSWnAzTzhYSXhJQzNTNjZwSjk0MmZNMDdrOHA0dG5tVnB2YzBI?=
 =?utf-8?B?RUVJMVVWMk1lays3MVVSTlBtM0grd1ZNTmhpaTJ1SHkzbUJXM0VNSTB0T3c0?=
 =?utf-8?B?emlRUFlaWlFjQWd4RW85djR3aTdlSzFsQnFGQksvZnZFNkpua1RZa2pOUjZG?=
 =?utf-8?B?b0FGWVZyczM4aktrMFRXLzlHS25XdlpVSFluT0h2WTVQWVNWbTRyQVl1RVBx?=
 =?utf-8?B?aHZLM2tOdUNmUGVtQkVKMldieFVnQWFNNDJ4aFJWdEUrT0gzS2tOVG9NYzEr?=
 =?utf-8?B?YXB6U1VnT3F0SDdTOUhFYWt2NmF6TjZLYXRLWk0rNlppeGZ6V0ZQQlBVWkFt?=
 =?utf-8?Q?ZxTI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51347dab-9b6d-49e2-06c7-08d9f59d37f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 00:49:44.8411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: stf7ngBP+Qczp+BPBTDYfgGHFMDuG8iEINae/mg3pacHNU7uyvEyaKXZbGGUib5h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2496
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022 at 11:40:35AM +0000, Shameer Kolothum wrote:
> 
> Hi,
> 
> This series attempts to add vfio live migration support for
> HiSilicon ACC VF devices based on the new v2 migration protocol
> definition and mlx5 v8 series discussed here[0].
> 
> RFCv4 --> v5
>   - Dropped RFC tag as v2 migration APIs are more stable now.
>   - Addressed review comments from Jason and Alex (Thanks!).
> 
> This is sanity tested on a HiSilicon platform using the Qemu branch
> provided here[1].
> 
> Please take a look and let me know your feedback.
> 
> Thanks,
> Shameer
> [0] https://lore.kernel.org/kvm/20220220095716.153757-1-yishaih@nvidia.com/
> [1] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
> 
> 
> v3 --> RFCv4
> -Based on migration v2 protocol and mlx5 v7 series.
> -Added RFC tag again as migration v2 protocol is still under discussion.
> -Added new patch #6 to retrieve the PF QM data.
> -PRE_COPY compatibility check is now done after the migration data
>  transfer. This is not ideal and needs discussion.

Alex, do you want to keep the PRE_COPY in just for acc for now? Or do
you think this is not a good temporary use for it?

We have some work toward doing the compatability more generally, but I
think it will be a while before that is all settled.

Jason
