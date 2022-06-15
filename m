Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4BF54D2C3
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbiFOUiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiFOUiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:38:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F129C10CE;
        Wed, 15 Jun 2022 13:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXQOy+EGOBeV/afIYq0Eca4L4LufbvCyTgptkXGCuCYZux71+Kv1GSTIR+pWz2xw0kPYuRhRviajBqQgqF9owAqOmcP7d4krqSW5/sVornwcRq1JhwjVkFzDkmzmb0+Ds6VWADhqQb2IXZlTxorVGdsPMX8Txb9iMKVo/6kgKUmqx0YmgC/O+0HUavAAO1/4WEEbBI9/Jb2lhmqO5JUoQrVWhGpfqGxtcd6FHHlT2RzBGg/I0FjvwRPtcJ3sWTMr5BCms/m4MQnH9TOAkrC2lO6PHo5puZZ6Tg4vmd/IbkaudvX+oNalOGzKne5p30/XyU+O73WxpumOgNAp50aR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcqS4/TeUseE6sPfFpoWH8zs5lrAIW9DyBEREwM4EOE=;
 b=IXPTOEZsSHPvYjCAckhO2lyxsHEllyOmeIfNoWgWl+J7QzU7fixgRYymFqzcfoTmOxDK3V2RCQoVIZRR+5CoWtb4T+noM1LKG7DfrYDk2dflLXHgsDJKf0RgTvGKPiQFBHkRkIdXLZ0eeNds1JZ8mjY7bloCOdzVX+ZbzST32A3kC+x0QiuQbDdOe5z9mOuPc6vLo+44/ya/iz8R8f8y6l/+oTj255+QEA8lu6tqvZ+yg2xeR79IcqXkrf1Rhtx970g0t/M8Tae5Tgo+tyFnqc2xzoWpGnDv39KzRf+YIx91+OAjQdxCDDYmXxWQy8ulyJGqYOGhvJvcyD6FlO4xOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcqS4/TeUseE6sPfFpoWH8zs5lrAIW9DyBEREwM4EOE=;
 b=lluNuZGHGGzxGX7jEDtsF9nZNbr3OJmZ8PtEucP4eHL+M5uXFY5x6VGPWbsUwb/fMrq+iPgesPrqf2I1ozpOSwXlFJbuuiF+BbMIEqQyysqJaT5A/BuDlx63AWfARQ7XWjcpHDEeGdZKRH/5bzhjS4ETbTc/hlrwujQKqDAyIcffS/0PHAeCyCoBfgKa12tQA+8qTZ11OKA6MZ+jH7Buv42MBOjPZZ1u2N4rcs0sMiWjk9YngA6Jc+2pM+feOk5Tjmat5KM5x/an0sd8MpE4UT9PA1Fel2cSWxkMswYNWKC/Wx6u+PexXSI6ZrNav6NUi6rTx89OtuwAzjlEZPtv3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM6PR12MB2841.namprd12.prod.outlook.com (2603:10b6:5:49::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Wed, 15 Jun
 2022 20:38:04 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:38:04 +0000
Message-ID: <da987b5b-c9a0-a142-eb12-1537ea21e209@nvidia.com>
Date:   Thu, 16 Jun 2022 02:07:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 11/13] vfio/mdev: consolidate all the available_instance
 sysfs into the core code
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-12-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::30) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a53b64d6-32ce-4c62-f473-08da4f0ef290
X-MS-TrafficTypeDiagnostic: DM6PR12MB2841:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB28414F7258DE2CDA76C57FFDDCAD9@DM6PR12MB2841.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ne4Obswn9vOLdUriWSXoF2ywsEtdLRbOw7psXQDQYBncHWuOfxtDeLAGIQEvg31GtYduWdf9IktBlqrp0EfrCgJG+UnBMic71PB6oVl6VesPHYQZsDUlps+ivl7j3aF+N2n4NYczLkX5taCoaEzp1Mw8a74mIDEi6QjuDQJ1mofW8NF12qYxSBZbECCDfUEKHmouxIPrbVoBRBBOP1R/mUuPor0NJquPlEZRlhQhSZAtVUpREis2X6RJ94M6X/OqALgr+hWkrttNt8c17bdNWXomLPtGKuz7AXSh34Z3gIfUx18aWLXcw0ym2I+psMGVhfgMz2ob6LMKj5x8k++tCBZBn+DKxweY8RQr7mD3za6il+aCSkgOMcdkXjA8G/sUzptrct9wLF4kfT3E31x/t1zeRW5RJSUE1vfOUBR3sUA7Vfe+mrG6YT8xLhP3MNOQSmQ8EXOTcM8dKKcp8vgQs3gPLsUxLroJwKn+GkIru1hksigkWRy5AiSwgQV9+VufnUoLyfXTZ5jqQ4dQXAAfrbjmLw9lhr9CRdWBTLZFGcMKsqTbARQ3xSWlu5OBlFvlbqW4Rg2NvpyO0j02Dj3V2QWyr+X5J4n09pYXax0yvoouA/JtTR+/TrkOl3hNi/yK0m6CjGWdHG6pHdDgGrNHRAfLgcHVKeSSKnWmecKhMXrv/r1L1OvLmXBoOHbikWEwp7NcaHvDrnV+yL7F+S1XHh/cj3WjOSa4+F/PYr/oIWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(55236004)(6486002)(508600001)(53546011)(110136005)(36756003)(6512007)(2616005)(26005)(66476007)(5660300002)(31696002)(54906003)(8936002)(4326008)(2906002)(66556008)(8676002)(7416002)(31686004)(107886003)(66946007)(186003)(558084003)(6666004)(6506007)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dllJOTlNUWZEQWVxTERSK21nQlZEQUlrbFVCaFpZSzZTOW1qaXVTMDNGVlFj?=
 =?utf-8?B?WDN4eGJISWtxREdoYTR5NWhGQVdibVpaRDhzZnQxVGZDeldiOU5zNllscXhp?=
 =?utf-8?B?RkVhbWdvR1ZrTEJWSWUzbGVISzZCWDB0WWlySjhpdERBL3BRWE5XQnNMaFJy?=
 =?utf-8?B?czdlM0I0eTIxMEtSVFNXaGFnWFB5OERqRmNpMzhWVzNhQy9PNElyb0VRMGNo?=
 =?utf-8?B?WlpPQWRUeUI4WjJVczl1Q3lXSjcwWWNQZmZEWm5jUWR5U21UOEdPQXdJUW12?=
 =?utf-8?B?NjRTTVprQ1A0T0prdkZQdXBJUURRaC9XYzMwdklGc01qVXNsK1d5MlEwQmJI?=
 =?utf-8?B?RTQzYzk5R09DaGlaNWdlY1dYRTA0OHREVWpJSDNHZjhPYXhZT29TWGsvSUtY?=
 =?utf-8?B?UXJMUmFvKytHU1hZelFKczlkM2dGRlhJRC9VZTdyb0hST2I3bDFPOW9UaGp3?=
 =?utf-8?B?WnhEVzI1SFc0MDlzKzhEdmdWV2gvTDZvSk1FODRlMi9CMmh5VzRBMEdkSmd1?=
 =?utf-8?B?OWlieXAyL24zOUNtZW4ySFJFWktFOW9qYVlnQnc1dXFjcEFEN2hON3lXYUFs?=
 =?utf-8?B?aktLazU1UjFTU0tKT1FWUElFR2xyRzRRY2VXWjFJaFJRUEYrTlF0OGpoaUVh?=
 =?utf-8?B?SjdHTGlCMkpUTVliYnRjYjdUVE05a2tVdXNMRFdjcElKRTFnTjlUdDQ1ZzBw?=
 =?utf-8?B?Q0pMbS9RdmtCVktlSkxyS2FqOTdCN2ZHZGZOMzZvR3E2ZXZTOHpFVmFYbisy?=
 =?utf-8?B?S0t3OVY5ZFFnTG1NeWkrMnEwWDhaZEsweFhwYUgvZ05hc1Y3RmN0RzU3VjI4?=
 =?utf-8?B?cXNrMjhuSnlVc3lHWFV1cHJTK2oycFhwb1c2czhPS1BrOExWMmlaY3JIZklP?=
 =?utf-8?B?bFVVamVMNzlQajkvZXhzT2ZvMG4zYWI1SkFoYjk5RnJ6UzFBTHJzV3FwN0I2?=
 =?utf-8?B?THl0WXFLSTZLSzJTMUZaci9wNEN6NDFLSFVVUzluNkpTVTJZWlYzRDRUcXNZ?=
 =?utf-8?B?NDNvYU9hSUdkOGZkMUVsd0ZmTUU2blc2ZExJM3dDQUhGbzZSZnZVVXpNcnVj?=
 =?utf-8?B?TUoycXlZallLZ25QU1FwM0V6d0dZRmJrZGhBUnFHNmY5N2NJbE5uUzBpQ0VD?=
 =?utf-8?B?QVFHLy80OWlSYkZlcUw3NGFRa0xSMXhhNDZWaHJONmE5bG1vdXcwSlNwL1Iz?=
 =?utf-8?B?aTRnNEdCTStKWVRwRWZveVNzbFdHS3JvS3BDcWFNWk9FbkxLR0c5M3NRU0NM?=
 =?utf-8?B?c0U4UGFzWUdhMzcvWmZqdnpkTkQwY2UyM2dOcDdpY0hVVHJ0OTlhSnlZRy9G?=
 =?utf-8?B?WWpYZ3MxbXNPNEZRMyttUDZhN0pJOFBrZjRrN0thL0tvNlJWeUZ5dDVGZExE?=
 =?utf-8?B?blRMdkpGWXFIWkorekw1K0RPMlFYbkhLd2k2S09oOTdpaW5mYlY1M0ZjT2lK?=
 =?utf-8?B?M2hRYXEvZVk1VDJjNE5UczAyczZHRUd5U2psTnl0cjdKNTl3ck5EdFErYnJn?=
 =?utf-8?B?U2Uxc3lnYVZCVlR4M1ExeVBzRG5xL3EvWWFkMEtYOE9FdGw1cWx1WjFqYlBT?=
 =?utf-8?B?MFU5bnpEaTNrVy91S0NYaSt2UFFFN2ZQdG12eFB4WEJIanNyZXhFcjBoNkdl?=
 =?utf-8?B?QlVCUEdyTnR1ckZhY2pCcFVycHcwc3dSN0NEb3FDS2pnTVNKY3pOTDhoMW1p?=
 =?utf-8?B?Z21USERZS1ZXZGIzelVhR1prMUF5S1ZoOStHWW53emtRamNwd1AveFAwUk92?=
 =?utf-8?B?WHNraWU5akxFL1h2QnRVNk40RnZYaFNBYzZpOFFqUDI2S2dsekhKd05mQUQy?=
 =?utf-8?B?aWlZWjJxOTVBbHBBV2UyOEpHMlF0dWtDaXlSTU9wWnlZT2dmWVRucG5HMVUx?=
 =?utf-8?B?ZTZ0ajhTdHJRb0VNVjhNaUpYTFM2Z3JLTmIzc3oxZjhtL2JPRlh0YXBzRm05?=
 =?utf-8?B?THRSTUZpWUdTMWwwL0JqeWtKcjdvWVlBSktNT1Ird0FrUC9ONStlOXNHblJ6?=
 =?utf-8?B?dHovK1dReG9Bd1BkZnp2cEExeHFlQi91Z3NlYUdueWt4N002SStJWllLZ2JF?=
 =?utf-8?B?cjJhVHBYRE4zTUV4U2tMVjhMRk5GSWJ2ZzZaandvVDU0c2R5SnlwREh0ekpL?=
 =?utf-8?B?ejNkcjlkTXZLUDJLNkJYa3dmcHZ3QmQzeGU3RW92NnRRakRROEdrVTlWTzM0?=
 =?utf-8?B?QUZVK3IxaXdUalRHb2VlUHppNmVmNlZKSE1GcW43WWRTSG5KdGFrTnM4QjJP?=
 =?utf-8?B?RFJicW9ObzBNTE1jdkFxb0lndGFPSVFtTUVhR29ZNmFIUUQrSUVjeEEzN1ZE?=
 =?utf-8?B?WU1YMnNLNDFNZnJ1Zk9tWDlsaHJiWUdYVHFSVkVoNlRWVGZWdWNZdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a53b64d6-32ce-4c62-f473-08da4f0ef290
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:38:04.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqF/rND3TQ1TpgTCM6QDPHQaVukBn/HXDUI1MXI4GCZT/RJTz8S4EekEZH5ZBR/HdGpyUXv/stDpQnCy1yYNCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2841
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/2022 10:24 AM, Christoph Hellwig wrote:
> Every driver just print a number, simply add a method to the mdev_driver
> to return it and provide a standard sysfs show function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

