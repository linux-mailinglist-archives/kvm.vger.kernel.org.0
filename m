Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B6154D16B
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356282AbiFOTNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349578AbiFOTNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:13:08 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40DBA194;
        Wed, 15 Jun 2022 12:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5T+1ec05CVgbZnNC7PcWd1Ohak1ndZlS+umTxUO8wEHd9WfjeFehBvB6NjD/ZCzJUrT3nrpNVWkD9hTgHC4F06gjZdqB/+mV7x2cpu94/uCwTu1xKMbRUxywZIyNhd8Q3v7AggBeGStMQufXSCFL4zgmU9uThD2Nwlza1QMOixCrvKu4luwm9X5lr2FqLVxMpv1N6mesw2FJPXNDuQ3mxQbP4fkAP9jDvKf6/nABFy0AuH/8RLIjwcn1Yva0yn+bBayvpEjz7N9h58Csub4C1nv2kIbAaolruhnKgi82P1ffNZ9FOh+l4CznRKAfnzACU2RitF8KfMSD9lM8lZrZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V71L7kIieXj79tsGK/D1Z8rvCNVH90EQEeOb8Y0xe5A=;
 b=JhOpX65RGI/kv/Uejf2T2Z5/uZAfmNqfnEdswpeJR2jNt/wp9xUAW2V/5J0cuXbHDwFXsP/r8f0zKuqG2MJ1W0Te8frN4E3VSGqBMh1z3SP/4es2RQS9bsOLr2mSGfPrhiFaPDCX92iELlgJsv7o5XusLvuclILUug+s6tnXu/yhomT49ieXmMVn+ZwAHQG6ldTFdd12MshyG+bpavfjQb/Oqvd9g+lExelpZARDeBrhgKb2Ksa0DrsrDIZ1rlcgkBLqUsy0zIJZ8B7P/IEwm01qz1e5tSWVmPqK0DUzTJ7UuRw1eFIDYcO3nsP0d9TzwK94ysvwb1A16C4UkCcctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V71L7kIieXj79tsGK/D1Z8rvCNVH90EQEeOb8Y0xe5A=;
 b=ssQkJ2EtZ6Sox1M75/S3z1X3ixg5Z6j6pjtLAXdIgG1W9jChKtSNpapuhQ6YA52jl8VcK31p9GkM4NZWS2ivLIE3N/xBYiMWekbFCecvWz6PWWaHj4PtOSzbqu74LyMLpZ5hbsV9e45MLMmv7+0kp42mTYVt37tbA3QTyq1J2Wy9QWBccitpqWj9ME2nYO3Zli1Teqbt1AMrCj62zYDd14I9dkBzp3VerwTsQpRB/WSFU7eJWmNqdbwxwrpgXY+Xx+lfS4HdyWYjdtR07IzldJiK8Dk06lsKWjgikzTL/JlSknBCAOx/mKbA9eYJ3prwMb8Ts9IMN9EmjnDW/mzE1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 19:13:06 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 19:13:05 +0000
Message-ID: <10aadc2e-8e00-9b39-f5e6-f3ef3d9fc779@nvidia.com>
Date:   Thu, 16 Jun 2022 00:42:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 01/13] vfio/mdev: make mdev.h standalone includable
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
 <20220614045428.278494-2-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::8) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3e9ac0b-6db2-4cbe-efe7-08da4f031365
X-MS-TrafficTypeDiagnostic: BY5PR12MB4243:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4243CB29B19DC418335414A7DCAD9@BY5PR12MB4243.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+PhsS5jVYnPigJGpuzAdFV6ec+H+QX0UiamtllJAaZJ6lIeD76UE2YP6qhoZVkbch/yPGams5iGwp8gQ6Ey5z0XFcOlsaLXymE0ntZxT55Ze3Ve2Mkd63r/hd+AkuzxJ0vSvce5bTgzRpY1j/cEVILT+N4cUc91a1BOokh+u3L0bmsZE4rdhLThgyOqreq9mhhJKk8gV53+Mkk64xWaxVjhdmF7BBG16JEX7KQul1jo4RCRhyLzPZ5qIluUURmm9gaHPL6HrQHbc7q0sPnhFkS4EvOSM6pzCb6kKA8GIiQUULxWOeZlfpr+HXN+Zg7zf0L+CkNGJoznan8RD57BCUCQXm8nCLDYvjcsBQVEc0Z/KQdxWPTPAWdNhjM0AyvtsFaukO5slZtNAx5lQuG9hKRm1iVncpxGzORqJlzgRLus2LNqusPYp4aJjSB3r9hNHBYbD7U2wWqWyDcSbxytz/tLAh5YIO2fkvo9ZSn85xn+l4WliewvXN+yoqiFx7FOO/29a8xjDoHtkext320Jt376IA4byG3NL75URNIUv/6tJWUtApkqiEKA4MCHpN8c+suuENP0gwHDhIUgZDIQtsJN9U6Anma4ChiWlAq79WtQTDfHPxGRa7vTgCtNUwER3iWXVBioo2nAOcm+AiEK5gHQdQVlRpidunwXgkvTOptqAlCh7y1wntNvaZLOK9vt57gZovONSjOb3Svct1b6Ef3Fab1YehvK4TpieYHIBDI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6512007)(26005)(86362001)(31696002)(6666004)(6506007)(53546011)(55236004)(107886003)(2616005)(186003)(4744005)(54906003)(31686004)(8936002)(316002)(110136005)(66946007)(66556008)(5660300002)(38100700002)(36756003)(66476007)(4326008)(8676002)(508600001)(6486002)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STFCU2U5T0Z4S1I1T25MSW5YbDlyWmZMb3U4aXpPdHBaLzlNZnRuZlIzOXdQ?=
 =?utf-8?B?NHIyQlo1VGNyekZZRFFteGF4Mi9McEtNdUticjQrZjBrMHFkcDUxNVN5amxD?=
 =?utf-8?B?NnFtOHlnalp2dFVYckN2b1k4cXFrNFJNeFV4NmFiNGpKWnZRc0tCZEVFS1NZ?=
 =?utf-8?B?bGJrVFJXSTVOWGdVK25WWjE5V0lDcm5wYW51d1U1NXBwblZNN2RvSzQ3ZFhz?=
 =?utf-8?B?TWVaUnhFaU9PVkU1SitkS1JBNWh0TE0vOVpiWmNCMW5LekpVUmMzbVhaWVRU?=
 =?utf-8?B?K1NEay9Sbi9XUzRkVkZaWnlwdEVrNVorYjNyOUR4YkxmendiQzNiS2IyU0JB?=
 =?utf-8?B?OHFKL2tEQ3p2VTF0S3VDZEpuZFVIeUFkUWVrRzV1WTZvUm5OL3dUVmlNZTNL?=
 =?utf-8?B?Ny80RitGbDcvUTlJNE4xVjloV3QxWGErM0NGcmdVa1ZQOXo3ekVPWW9iaGhj?=
 =?utf-8?B?Z3IrbFkzQ1QzMDNuR2pDOUZ1SlBLTmdkZ3AvVmJEU0hMNHpyaFh5R3NmeFNP?=
 =?utf-8?B?VjNOMnQ2OHhxeTJ2L1c4MWhlT2E2UU9vK1hMZmUzbjBza2h4eWtMQVBIc1ox?=
 =?utf-8?B?cldUN2NWMTBVaGI0SmFxRGNSVlE1MTE0S28xUm5rQ3VlSVdHMXBNVE9rdEFU?=
 =?utf-8?B?amtwNEJrMy9iNGxWdzF0ZmtINjY2d0ZzTi92U014aVJUT2J2cGo4N3VPaFM2?=
 =?utf-8?B?ZGpsNWNSOTJSTGVoWXVnV2VqSHJBUEV6RnZyWTVMdkdYRjZrNGwxdGwwNzhs?=
 =?utf-8?B?WGVsNk5hUUlsNk12T0tvbllEelRCblFUUjFHSDZ6eVJPWmtLWHUvTlVPbHdJ?=
 =?utf-8?B?SnZUUjFZdzJYd0ovNU92UnJhbDVZMmpNTmdlT3hUOGF5WDZiQVhjbENlQXBL?=
 =?utf-8?B?ZWl4aFg0Z0FLVjVjNTJGbjFOUlVObENFRUlRNHZ6RjlkMUhRUFJLdDRvVXpY?=
 =?utf-8?B?YXZ4VWpMRE50dDJ2K1FxZlRhZkhHWFBVWkNFWDRsejZRMmsySFZZZTI1Qkp5?=
 =?utf-8?B?blkyRm9lNzFKaC92ZG1xTFVreCtEMlZydlNVQ1o0YncramF1NTRsd0oyT2ZG?=
 =?utf-8?B?VUU3ZDY1c3k2d3RkNkFhckdjcGFJSTJMbUJ4QTIzaVN1a25rcFByV0o0bjFU?=
 =?utf-8?B?aUN1QnZjcFI4NFBRSGk4YUxvQzA0Z3hEdkFuRFI1UW9TUWIvNGprNEtjcXBW?=
 =?utf-8?B?K1YvQnNWd0tEMis4SjJrM1FFcmd2bmVIcUg4OWhFM2ZnNmxqb1kzZHg4UExj?=
 =?utf-8?B?eTIva0IzMUJGSkRJY2lHSEZRL0Q2akFHcktYZE5NbEVxdjFHR0YwQklNaDdS?=
 =?utf-8?B?OGNMVXEzT3BjeVVkdGltZVF6TDdFM05mYUVwcnZPWHVFN09NcVBFeGd6S0JI?=
 =?utf-8?B?bWpzU0U2bFBaSDVRU1J5M2F0dGJHRUFhRUsxQ3JERDZCWEZ6cjJXdUNJdzg5?=
 =?utf-8?B?eTVOUzh3bERNOHJrNUZiSFpGTjhhclJDcSt5MFNGZkVnVFlEc0lpaDdhV0dh?=
 =?utf-8?B?V3RwMnM3QVZIZW5LZkRsQjVmNVdjeG1mYk9qeWhIZFhNOHhIaXhnV0tvTEQ1?=
 =?utf-8?B?UUNuNysyS3NFNnNDK1lRbGVzV3UwMTNZK0tDcjYxNzdpTG1CWkFzS2xvaEJP?=
 =?utf-8?B?Y1U3YzE3UnBrOVNQQUMxNUlwVTh3ZGY1S2ZEdi8wemFBYmRGbTBxa1hjWFdV?=
 =?utf-8?B?L0VISWRURW5tRVNyVG5rWWJ2NUpZK1llN3g2OUNUcXpOSjdmT1hIR1pPc1Jt?=
 =?utf-8?B?VkNRcFMvc0dIeUcvNVNUS1BNQS8vYWxNbTRhMUYwblVna09wK1V1dmFLd2RG?=
 =?utf-8?B?WHJlYit1REJPTEYxWk5pL0lHWDNzRTJUNWw2d1JuVmhTNld5Y2lXSEhNZ0Rk?=
 =?utf-8?B?UXNOd1NPOXh6WTgvOHJmWFU1QWhZQS9KeFVIU2k2SStvRWUrRDVTMEFlZXBy?=
 =?utf-8?B?ZFlBR05wM3poRjRRRE1xV3ViQWk2TWZyUzNNMXNLMStxN3FuT2F4M09hMjE1?=
 =?utf-8?B?d1k5MXpZNHhaVzhQOGdNQ05sazN0K0w4d01YQ2pRTFo5Z1M0M2hlSnJBL01Q?=
 =?utf-8?B?RksvQ1psa3BGZE9IUmV3N2puRlVseXA4MWJkb3ZzbkNyN2swam9zNVc5TkVw?=
 =?utf-8?B?YXp6cGpZOWM5bWRVeFRBdjBvbC90aGl6Q3Zlc1VYa3FIeDFueWdZTFlPd1I3?=
 =?utf-8?B?MlVVdFJ4Q212bGxKeDk5UWsvUnpUMUgzUGdPMjFtUzd2RHdiVEsvaXFrV2tp?=
 =?utf-8?B?b01jaHpka2lXRDVlSHM3MC9ZSGFvQnNuSDMram4vSXdOZ05PYlhkKzdlNEdl?=
 =?utf-8?B?R2d4RFNla3lnVWlZMkEzY3kvbXR1eTQzU3kxSHg2U3BLakY0WU9oZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e9ac0b-6db2-4cbe-efe7-08da4f031365
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 19:13:05.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmpQji8QogRXiQz7Y60+XY1L3CuMHonCTUPYsnw9WPxg5CxaUBExES8icjaZh4rQ2TuDgNjkIf8Iixgv/Wpmbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
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
> Include <linux/device.h> and <linux/uuid.h> so that users of this headers
> don't need to do that and remove those includes that aren't needed
> any more.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>
