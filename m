Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C452C7620C9
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjGYSA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 14:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjGYSA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 14:00:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A48BB;
        Tue, 25 Jul 2023 11:00:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCGSb5SsjAwZ+FniE3ph98GLjpVd1RYMUpZzS2aMHB21WgDarHCd9UGkDGkh2OAwEa7wNCyHWX98s3fhwkimVn1oq8hzNyOPxcRqosl52oaGQlJoVmeoJ9VggBeV+3rt+VHIVW9ddk2bCCtpjk02h6BsBk46cRGmT7PNdBIXtU2vN+V2+bLq9otPLEDJCNgVpVqSCBI8mO5PAX0N4+axeKQeiZxXfI9wAF/p2qSnb14uNkkUEDSEQffBRsYMfftCSR0Ge7oMksGoYVdJN/gzU28xuVhxNU97NzCsM7N+fDyxOXxRwGnWnxeKZ/hwppuy9UF16SFcdGzt/GzvgbD8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVfdPiYMTjsrsgFPFqrzuF/QmuQ/Knj4Hoi8Q3guZqA=;
 b=TwAvK8TvZyfhgAYEImUv+3VKNk4LlGWCSuAgA7TPpVoPNpw3l9CxnjsZp6ZoZ+MVZnXYbfmPpQq7mRK1hsztSKUIgQzrj3gr55jg3OVnOtjjD252waj6oAypmAMac2V7CzhOHF2oGiZgI/0LQ5vNPSeIPJ5PCJa+uBdQtWOwvbycCWjOt9m4dqzDRd5SBTYwUEKG6wcM+qvIpTV5O3Yy23lEEMTeOjjrDX5VxOZT/9dErZgr/AbR1aqShiNXvxFJ48yVvKIitBmxCdDlu85M3hVI609RfebCI6bErkmLnPERFzal3MaESfSjRmitn3qlNP8KECFLiVnV0eMspTk81g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVfdPiYMTjsrsgFPFqrzuF/QmuQ/Knj4Hoi8Q3guZqA=;
 b=YlUsTqWV8c6KEShtnbP0P1/058ErJOUC78/MeNE9McEKRF6hNy3tD2LwHGruioybHvCA/sfHZywHtEd2h+YryZ6Oo/lKNLBX6QQrRWWq8hWo4cgMfqnmI1NQeYuDkJJpknMiiRnJ/kVuI0h2FEw2CkKmFx0wSkdzAIC8ldcpb4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 18:00:23 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Tue, 25 Jul 2023
 18:00:23 +0000
Message-ID: <1978855f-2e8e-7478-cb28-4f16eb842eab@amd.com>
Date:   Tue, 25 Jul 2023 11:00:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 5/7] vfio/pds: Add support for dirty page
 tracking
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-6-brett.creeley@amd.com>
 <ZMAGkcIPnWs/+Y/B@corigine.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZMAGkcIPnWs/+Y/B@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::33) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA0PR12MB4445:EE_
X-MS-Office365-Filtering-Correlation-Id: 13fc99fd-d558-42e2-ff99-08db8d39046c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ex6tt9fowHlFGQCTcZlHmKc3ZK7ARWODle5bQNkGee8b0V3XYf8tnq643xtzY87o2T/HTFT2o+NgaIyxBB6ln3PleLP56N/DAjfGWtTMCMsItjICcAflWY2p9GCN3nbEJHAXa/e4yrPjBRYUa0wYxSVnuIasZ1Uhn2rUcdgVSVy/5l50s27U3fscOWfzCosZVEF972whKGBnsvg472TbGdlgwULRN19MyZcL/royB+HwrLFfrxwNyGcUvnT2Og7uocZTYxQ6NS8LAXymSxm60ksOwSYdohLKy2wR5BdYgVeOcabSTtffbqiANaIZzHF38WnB0vUz+rkb3gMvZS4sUp/hTG3xg+M1WXypg8QuXfViJQw9lcD0PxlhycvA9JxifFdAMRQuk5WDDE8cV6gGpvGbiK5OH+eQZTpSo+D20UmAM3hS6fAAH42Nebpo9tWgd/CQDi5pokUKEL6IsFZG5+4paiHWgVHhoSo+n2UBk6n3HuqnZffAKvkWCOJbNRWe+wY5WbHUCstgsui/XCO54XCAplNk3hKr2jC7d1z1Z03xWs3qClWxuPngzj1vglJCYjgXj0cswsN0KFc6xs0gsaEn9aifC1iDaZXEJs9NFvc60otZy2tnru2cW+yZsPyeRlofSmeb1cYkU+YHESojLgDsxPTgWlJcEU9E4DzMxGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(53546011)(38100700002)(186003)(6506007)(83380400001)(2616005)(36756003)(4744005)(2906002)(26005)(8676002)(41300700001)(8936002)(5660300002)(31696002)(478600001)(110136005)(6512007)(66476007)(6486002)(66946007)(66556008)(316002)(4326008)(6636002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cm5uSk1YcVFjUjE4ZnZnUkJLclJFaHVPVXlKOU1ISDk0c3JIY29HMzMrRnBn?=
 =?utf-8?B?VWozdDU4OG9MbG5sN0xCa0lweEJCRzJuWnUrTTFwQmUzR0NQYWhxaE1YSzR6?=
 =?utf-8?B?bmMrczJXTGw2bUVCVDhYVlFQNE1MR2pvcEc1SGhsL1YxYVM5dmhXeWtEcjI3?=
 =?utf-8?B?U0ZhN05HdEN4MWNsVFB1WUpkMW1obnRrVHpwQkg3eTIyM3hsWnFGL2FNQmow?=
 =?utf-8?B?Vi9zb2V4UllKVGhiK1ZhNEZuZXorcVM4ZytoYUsvc3dDbTFUOXZFMXBoRjZE?=
 =?utf-8?B?VVIySmVjM0hJa2hCSlNLU2ZaaFNoVmJBbFVsdTlIcFM4QnMwN3V1RmxBRGZs?=
 =?utf-8?B?SXdXbnRBVXd2ZjdFU2NyWW43YlhzNHZEYk1HOXFENXNycHZ5cW1ybEJnR09R?=
 =?utf-8?B?WE56T2Z5Z1NVNGZGSndLWmFVcWtHV0VjWnhWSmF2dHdiRVZLUW5WaGRGNCts?=
 =?utf-8?B?aE94dXphOUtDRWhlcVZuZTAvRlIvZk5lcDR4b3RzeThYbys0b3RQZ2xZd2Rs?=
 =?utf-8?B?czhBelBGbWsvb01Mc3NNU3cxTjJvcnJrU2FLL0Q3NHhncG1OcEwxaG43RFlM?=
 =?utf-8?B?Qis4RjJ6NENUaUJtVnlwRDF1SkxhOUxzRWhneThIUFZXQ1VhUXlIRXRnUEFw?=
 =?utf-8?B?SXBMMnB6TjMvVmJ4ZVN4RHJEM052aXhodkpESEpuQUV3cXdUNWNTMHprNDJu?=
 =?utf-8?B?TlRaWnZvOUxpU2NRYWVSK0ZDU0FXMVNTUlkzbkpBZm9Za212THFISWhKT3kv?=
 =?utf-8?B?VHArWWNWcVlOYlJMK242QWZoSStjanpvTEMrVTRhWm10Wm1VMW5nTSszbmZR?=
 =?utf-8?B?cVZ1SFpUbHI0ZEpGaVNySmVyUGxyRndPby96NnNCMzZlRGxhQWsxNVdZQ1pN?=
 =?utf-8?B?UENiWjk4WnBIQTFNdGZLek1BMHZzLzJVWXhHY3ZCc3N0RjdjMnRvZjZJa1Fk?=
 =?utf-8?B?Tm5UTk53c25CYXdYaDhzSDBWM0pHcXA1TThLZFBPRTJrQ1dHd0tMWk9pVXRq?=
 =?utf-8?B?OGtNNG1PVlAzTGVNcGExdmc5N2VkQmhuYWhTL2JncUNjaVBKVnVlSTE5M3Rl?=
 =?utf-8?B?eU9oRFFvS3RONGllY1RQVlNmV2Nqb1dQeGhyWU9CNDRnSWdxUmlNbTR0d2R1?=
 =?utf-8?B?TWRReHUrMmY5eXBRQ01WMHVzNU8xWkh0b04vQmorMis0RFFQZFk5bmpxUnY1?=
 =?utf-8?B?eXF4ZUNlMjgrYjJxOTNrVE5oa1NTMWkxYXA5T3A2K2h0Tm9XQ1pvSTFmVnI1?=
 =?utf-8?B?RTBJNnlURHZVR0R2WTRRd09uOHN5RzlsWmpWd2FqRjdYeTI5eGVZWVNUeXlB?=
 =?utf-8?B?ZXNaZWtHUXBQQUkyNVdsblJNS01wSWhqVDE2dnF5ZVZqdmdhNkhic00raG9R?=
 =?utf-8?B?V3I4WkYwMXFZS3NGTWFtR3NmeHdwQ1FxMGtBR0QwUFBQZ1AwU3RyMVBUS3g1?=
 =?utf-8?B?Y29LTk83VDVZT3dLaEwrcGZOZThaVUdoRDZHNVRPcXZycFAxZkExck5VdTZa?=
 =?utf-8?B?WFF4UFdPcndSbjd2bEJkRWhWREM0bWlkUm1sVURIdDVYOU4zUTNMYXVYVHMw?=
 =?utf-8?B?cURDQ3NTRHFWTTRkVkZKSnUvc0tneVhBMjdTL2NjYTNTN2xYQ2VVQXNLU1FV?=
 =?utf-8?B?Uy9HK1BYS2NMOTdad0xYVUhJRzF6dnpKYloxUWV1b3hwRWNlM3VkWmtIb0JF?=
 =?utf-8?B?RlcrcGJJZFp6bWFqQzFLMUhTQlhZN24rRjZNN0VZS1l4UUNOeUJBZ1JaeGcv?=
 =?utf-8?B?U2llNG5GdjhNbUtJYXVNZThRRWFidTBPU1VwMHlkVXhhN2I3cnY4NEVzZG85?=
 =?utf-8?B?SFpJY0poR1pSRnFydmF0QVkzbk5QTEJHS3grU3dLL1dBenVpM3V2RmFYUFV2?=
 =?utf-8?B?c3A1NlRYbkRGd2NaMG1aNW5UME93UHRJb2VUMlNjMlpaaWlsYStNTmFUWGhC?=
 =?utf-8?B?dHpCM2VxMnNtVk5Bd3NZL0lQK2ZZR3M0Ni9wNW8xSHZnNnZqamFYNFc4M1M1?=
 =?utf-8?B?Tm5vbGV6Y2x0Q3MyZzVtVHhXN0o4NzhlTUhWd0g0WGlvS0xHd1RRQUo3b2Z2?=
 =?utf-8?B?eUR0S1NSZjBVcjZUUTN2R1JjUitKRVh4QU1TbDFvQXdlaEdpNmExUGgrZzRS?=
 =?utf-8?Q?TpAnYFhE/iFdUVdh7XLF1lYOH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fc99fd-d558-42e2-ff99-08db8d39046c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 18:00:23.1197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cH4RL6RmYbSRggVi2mVgTCxWXBotay60KkS2Dv5ZjddjBB/VEPxI82tvuvhYxQ8GP2fu3EY7dht0GgjUJwqv6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/25/2023 10:29 AM, Simon Horman wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, Jul 19, 2023 at 03:35:25PM -0700, Brett Creeley wrote:
> 
> ...
> 
>> +static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
>> +{
>> +     if (dirty->host_seq.bmp)
>> +             vfree(dirty->host_seq.bmp);
>> +     if (dirty->host_ack.bmp)
>> +             vfree(dirty->host_ack.bmp);
> 
> Hi Brett,
> 
> I don't think there is a need to guard these vfree calls,
> as I think they will be no-ops with NULL arguments.

Another good catch. I will also fix this for v13. Thanks for the review.

Brett

> 
>> +
>> +     dirty->host_seq.bmp = NULL;
>> +     dirty->host_ack.bmp = NULL;
>> +}
> 
> ...
> 
