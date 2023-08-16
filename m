Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD877E814
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 20:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345335AbjHPSBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 14:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345400AbjHPSAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 14:00:48 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FEA10C0;
        Wed, 16 Aug 2023 11:00:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeLkor22qHz35A5dHXc+QgpS5f7w4pC91GyeYEoqzJkdtjlf//jbLM17SCoLIfWhDElwWAGNXy8D145JHLQ1SvM9Q4dV6n3vKDm5oZFhelGzvUZBJW0VO3pA3uaHy0OVySOr3Th7ePgyjcO1/04vQ1a02ljBzb0D9QrzMHXtBWTU5v0a3vTJzSfBjCwStbcOt2KObeIGZdXPzCCvfb+nDRCqkOzEGFzYjB2yP4uEftU/d1wED5z24LR2j/OV1vn8VvY2zs7x0wsqNyx9r99nrBiQo/NIzpdbVbO1x4U4AymtUkcOIoEf8GBW+ObNt2qVCvhuTcz/qeK0AHtQN/EtjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PpczKEylxjW3tqnI7LtisfeOSre+KtzJ0ZvvJKV314=;
 b=CfGXWP1qF3RlSvIBlBZtcXY8FR6Px2punQ/oJkgvm6OWoFcqnrILom/JiXj0YI0OzGBXA+KMvBvNOcxP7ZLnELxvxvH/x3UXQERKihfRKBFghYVlGBV3S8tRVujulJTLG0G54M0gJJ4aV1tDaxUjxXUOTF1yOvVDDWfKYvZq331Kc8ZKzPeQu6Sem4TSDapvB6duA5OXBS6qrG8sTtixoK250HcHQle4rE9GpzJ129CpwRloQ/juyEri8zy1GSTH50SwoWuRxhQNmY6jnp1pjrluP63W6+NqmpAx7GbxHXIYk4SkVQqaiAWoM28qGDBDJ5YgId/Z/rmeknHjnOdDXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PpczKEylxjW3tqnI7LtisfeOSre+KtzJ0ZvvJKV314=;
 b=Lb1+SjWkgw42xBV9T9U28/AASvGGw5yr4lUG+lHyYLou9NWRjVeGMbuZ+m8j46EKQo5LnGH/3nTCUEDfiBD7MrgtgkAGxAE3FgmoVXLM4cH6fIhOTWXLxyCaZZUaj4rs6Sc9xfAEJ1smtw4fPKWff1+aMqiFtG35IAwN1+WzmdnwfSskqfjmEJ/XxIQlvfMs3sHLoGBYCMwCHDgtW6QOojnlC/P5C705LC8U7PVxGf/mIZY3DOChQlAwvxSbj4ANghKslUs14vpBhQ3VcC/956sUBmtwee6QcSW7mgfbYmDpADTRb2BMfAO6c4vFuQupIeZnAiotnsmJN6nT5C/p5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by DS0PR12MB8270.namprd12.prod.outlook.com (2603:10b6:8:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.30; Wed, 16 Aug
 2023 18:00:44 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::6077:f23c:253c:79f6]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::6077:f23c:253c:79f6%4]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 18:00:44 +0000
Message-ID: <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
Date:   Wed, 16 Aug 2023 11:00:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        mike.kravetz@oracle.com, apopple@nvidia.com, jgg@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com,
        Mel Gorman <mgorman@techsingularity.net>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
 <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:a03:334::12) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|DS0PR12MB8270:EE_
X-MS-Office365-Filtering-Correlation-Id: 36d4ee79-8a5f-4663-7ef4-08db9e82b5db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kmi75n2RgypXYbCq2l8XHpxKVRftIX+f9jindKcPWyVRjJEOm2isDi6hksGbxK980rd0F+ajkoZ3wPaphCoc+xlAcl9zYw37Gt3dQR/7QTSB0Ykvlv3du9ySnUFwxorv4syYFUxBOtYqo1zoPb5qAqvYWV+J02Dxp9BdlaWVRUaFOYY6ieoe8/18ck512n57+goDFwhwSLqaDjS+083an7LDfQ+ce5IsJgQzNSYw47HOQRp5i8d292Ehj4VhqE/Ezba4g9U6KNiFUTw5gOuEtY6Ow3t3RiSoSaAdGXBjXHtR+A1Khes7/cDjbTolQdEtlVwMkVsQ8L41i8Ab8aQgS7EjqlAvdT2Iq3qvNtGkBOYVRrFhJuSPzdMaGVxg5OqmTXOiqUFfB5fG245zqgQgLcbInOONy36//CtPZVFhwdjxE3VVpzJi3PXDaQOVg32QpF46900QqmPnj3LvNTAd+ZqLqdmRR1wWyhUyhzd2LLPgXl2jDZA98XEcbE9MxDkl0TL9IgbYXhQez/AM/C2oGwstDxKUUMiwXXbvplltyYzsWWnUYkFToWdPgFSxlfi99Y0tN/I0j/a8IGkIeByU/oAYYnFkPamG+vbQXSTVc9AYMBBst+9SdVpcdiw1Ny61xcu+wp6rdFOfDTALR02qCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199024)(1800799009)(186009)(316002)(66946007)(110136005)(66476007)(66556008)(41300700001)(5660300002)(38100700002)(31686004)(8676002)(4326008)(8936002)(2906002)(4744005)(478600001)(7416002)(86362001)(6512007)(53546011)(31696002)(6506007)(36756003)(6666004)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STdYQnI2dVdEaW5BNU5aeDRRS2gyYlBDcXhWdFVTUjk3NXd5SURnUlFZZ0ZR?=
 =?utf-8?B?OXFqZjJxM3lKdTJpL2llK3RUQmdoRjNGc3pEbGtzd0RiTjFKbC9ZODB1dUJT?=
 =?utf-8?B?dU5OYU9RQjJ4QVFLVG9mbnZzTHZuVFo2RkFiYnJlMExDT0FZOWM4dldOZDVQ?=
 =?utf-8?B?cDZncHhBLzJka3ZvYmkwZnVwV1piR1NHUkVHeDB6TXZwZHZ1NDZUeUlqT2Fq?=
 =?utf-8?B?NGpTK3FjSklOaGo3cHg3QUlaTjNSYkZOcHZ2V01sUWkzQ1FYamViL0gyQ3FH?=
 =?utf-8?B?KzZGcjRwTkdoNEZPK1J0NFVGUjRoOSswZ2wvUlZmcTlSMVl3MUxjeWQ5Nk1U?=
 =?utf-8?B?RHU4WC9SaDRGSitPRVBwR0FqUzBQYzRscGlLSVQzanRaMTBDWHBqMWJuSXh5?=
 =?utf-8?B?N3U3L2hES2hRU095QWN2cm9sM1dSNDhKZXZ1bzYxb1Z1Nm02QXRXQko4Smti?=
 =?utf-8?B?aVV3R2RIbnNCaE9CQjhFbHJqOTZSZW5MeVE3djE3LzJLYkdaUllrYVAzYkVK?=
 =?utf-8?B?Y3FoSTRTdUFxUGJNZFJJZG40YnhqeGdSczhHakFsem9LYWRqL1loNGppa2JN?=
 =?utf-8?B?cHdiWEZZN2JOOWRoZFRuSFdVRVo1akRIYkpROFVtbmVQall4a2JncDRsVktm?=
 =?utf-8?B?M0tER003cHpMV2ZjaytZTXFCcWNBYm1SUTBhSXlNZndpSjYyNU5CQ1pCRklL?=
 =?utf-8?B?Qm43TkJiQlZGUmZ0L0hpQWpPbjlzTmhJNTZFNEJLSktqMnRHeENmTG15TVAr?=
 =?utf-8?B?akVUblB1V2pJMll0bWIyeEx2Rk9Bc3JCMERvZlhFd3JUVDFZRklCaVZUcXhE?=
 =?utf-8?B?blJRNGRIRUVuUVJkK3BCNzBmNUtkZ3VwOXpDNFdjZDNkSnovQzk3amZXY2xD?=
 =?utf-8?B?WVV6SmZHYnlvSEF4UmJ3M1dWVmZoMysveHRPRE9PNGtyam9DOEhpUXdmNDV1?=
 =?utf-8?B?WU1oV0wzUk1YZ1p0STJHaUFXeVc2dldnKzVBWmgrVE8wanpha0lsNTA0MWY1?=
 =?utf-8?B?M3FCRUFWYnAvTDAxRDN6d1JvaDJvcm9sNHRUMzIrUDBFdWp5SFBxRUREcmhG?=
 =?utf-8?B?eXJ1TTN3VXZod2l1UHVwR2RWNWJzZUdCcFZncStZVzJRWlFVc0FHZ0ZDVXZT?=
 =?utf-8?B?VTJpTG1BSkR1R3lVY1NkWlFrWUM1SVhQajNqZUJ5QWZiWElCbWV2b0lJOHY5?=
 =?utf-8?B?bkV0WnNmVEFPbXZlbXovbk83d2hKWWRYTWI5OU5KOXgrVlpmeTFMaEZoWHVr?=
 =?utf-8?B?S0JxRGk2Ukp0WXNOWGhhdWc2WmNzUlAwNmxhNDh5QlBRcUkyNUF5ZVU4cUZm?=
 =?utf-8?B?ZXVBRFJndFNPWWtmN2xoZTlFdlZSeC9RSk1WOEE1MnFpQUNQNXdWYllyaWhw?=
 =?utf-8?B?SlRhRjZ2Ry84M1JhVEE4N3VXeG5rRmtJTjRML1hpeGJjZ3ExdGhDSEV2alBK?=
 =?utf-8?B?bFJwZnRSVjVOQ1h5aWc3Wm9CeThXSG1zK0hLdXN0YWRCRFdlenNNT3Q5TmJF?=
 =?utf-8?B?TlIyNUM0RW9vTmFaOG5qL1J0ZTBPVVoxemFOblRjM3QvUlJIUXdZQjNQTkEx?=
 =?utf-8?B?TDhxWFdvWCtDVnNTV1VES0dLemEwSm1Uc3VGMEY4Q2NCOWVrakZsVWtTcFF2?=
 =?utf-8?B?UWhqb0RUd2lHZWg5NjFNVGJ6Q0tLc3haM1pQRTJCSjZrVzZ0QjE4anM1NDBu?=
 =?utf-8?B?MmdCOEFnNDEvdDU5QlRyN1MwMWQxdURiWjZGNzR4eTNHYmFQVFpZb0ZUWWI3?=
 =?utf-8?B?dTV3eEFNTGUrYlRxaHE2VjJ5dlY2ZmZGcjBrSitRK0pqYmZIbVBST0hhTGpN?=
 =?utf-8?B?OFM5c1J4N3VTMWxvY2hURGJGc3hCZVJEMEF3UU1kRlZYRnpzdmM1elZvOTJ3?=
 =?utf-8?B?a04xOFc2cVBjYk11RUdRMkxNcmxYTTE5Z2RGUVovYUR0dnJNQk1GakFPeFVs?=
 =?utf-8?B?ZDJra01NNnBPQUt5eUEvdy9UOXVwZG56U3FhYjFYM3BBVkxTNCtIblVRMkJT?=
 =?utf-8?B?NmtGc3dSMVBhdUxxVnEwQkNYYmk2VkpiM2FIVWhkd01OZzJieTJzcWNNN3hl?=
 =?utf-8?B?T2ExR0hEdXVqSHlBSlFuYXhNQjF5ZDIwbkNBbjlGa2pLSzhvR2ZRVGxrNi85?=
 =?utf-8?B?bENqekY5Ry9PdWZuaDFnU2NSL0FQWjE4SW5lNXNmTFdTeHcvS1l5NTFhU0Fj?=
 =?utf-8?B?UlE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d4ee79-8a5f-4663-7ef4-08db9e82b5db
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 18:00:43.9862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8Ms1YIHV2HTlyHEasnkT7lJuDigtE0np+Zt1XGR4ubVQjVK7ssFXphYmNSInXWNrXnqIaSnDxXg7/SoQQDnRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8270
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/23 02:49, David Hildenbrand wrote:
> But do 32bit architectures even care about NUMA hinting? If not, just 
> ignore them ...

Probably not!

...
>> So, do you mean that let kernel provide a per-VMA allow/disallow 
>> mechanism, and
>> it's up to the user space to choose between per-VMA and complex way or
>> global and simpler way?
> 
> QEMU could do either way. The question would be if a per-vma settings 
> makes sense for NUMA hinting.

 From our experience with compute on GPUs, a per-mm setting would suffice.
No need to go all the way to VMA granularity.


thanks,
-- 
John Hubbard
NVIDIA
