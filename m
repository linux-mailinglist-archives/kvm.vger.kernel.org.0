Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8652698573
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 21:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBOUV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 15:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBOUV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 15:21:28 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F29298DC;
        Wed, 15 Feb 2023 12:21:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUOzKAqSAZiFNbeAtI5b3jnrhI2tmDY3uz8/KUlxnD4qzN9n5uSDHjH6jRbidtol9sCjIZG7KnIxfWFxMy9vJfwYT4Z0essBeGaal3AVdDHyiZCslvtHS2151rKBBfBipaHHhSi9OXayPhccjfwquEzn19DFeFUxjdyWGUJcZ1w56oJ6qFwn7GYSgOhqDnosiW2Na9+LSr28e/11/0ejVj3etP0hjDaxcv5qZS5C+4Ia/ejmYjEBY2A6gSpZBqLZEVpovWfkVLRFNMhzsIYDQzq3BFps2Z+X2YJ81XFK5TnYBESNBDXFzTLtiTUbq78faHdKBBDcEx29JUwxQ4HBsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRRIzSFuZp3MyeJWAkuCWriEGs+MBjqtbTP6BTyGDHI=;
 b=dApmui0avv6vQ8B5PlrGdHSG9Z7BsPknGFTKfp2aNw0sJjbcorjSW4j6llN7g+KMkROnhMOHaI0SRoyYMJQM+HxGkS7eKk2ug9AjnqY5e9GRklMP0HjaTKXFBy6p3zPUU5bd2xdT7cnzWRolf9J8pLnOnO63I/x7AO186PwMB/gnX3K3P2ENQjSJ8xtvrjmmN5iFdH5eXEuebcYZVGX19GJwTX9BQSMltbviCXuBHSBM34SYxzi0eqv9sZ0xCsCpn8hzuM7Pyy5PnBC7AJG4ck2jtfyGBXxwrQxRGiluw48l5HsjdQb+5zdjmqLGh80r6oH6dSIzuU7cUnQSdzPsZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRRIzSFuZp3MyeJWAkuCWriEGs+MBjqtbTP6BTyGDHI=;
 b=PB4O4TprYK7eZkNS2v1n4dGh4g0YrDbtEooZC9c5whEER3cZA/7+7Gtr0JlATRPuP+tznIPsyCSy1Wj1mRP4lZ85P1cUBSW899dh2gm8LE6AQ9pMyqxqSPBH08zrARwSq/oJtVxxa9uYQmD/xDqB8bEs6VLBXGHAjjkbVO0IRBY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 20:21:24 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 20:21:24 +0000
Message-ID: <c3b6efc8-4f47-449f-d3f0-1f16ae756bee@amd.com>
Date:   Thu, 16 Feb 2023 03:21:15 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 0/3] KVM: SVM: Fix GATag bug for >256 vCPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
References: <20230207002156.521736-1-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230207002156.521736-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c19db3-ae3e-4310-0c28-08db0f92357e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mp26SsnYsc5h22p/bR8+bcbNJt9ij0OuyrgoYXcKKdCKYqbp+LMmt9X0ONSEO19VNtAy+q1SvQM6UE3yYGGV3o8zZG86WginYQq9Mz4E6J3jPczpcxzBFDtK7jc90jVyebxGsJB/9R/zfpH8OceR0xtDgQXG8kOD74NvrMw3pl/WXKuOXCWFixAZAQQbF1a/4X36hY8HeiK7rhDAYk/NDYjd0aYf9HzAD7KTVTsnVoFG8L2sKmKZpbPYJYQUX+/ng706XYI+/5zaCZXSNmGofYJbmLqZZHrgsKXOVY0spgEmQQiMR7QhXnaXuXmky0QoxUyz2jbxQ4ELimNJ8Q5rEKVgh79Cny3DE2EiruSwi25SwQcs8z+gzDoLEpAX0hN2w/zeO7oy5qELUrcaU5yFlj219ZecclV13JijCqWg8XTrIuQbTmqeWUnJH1kNSGx+9o5Dzz1EVxgjFLzOTHJ0GhUJ40L+ipe5sygbdG8AuzkL9HZIJBd5B1q6ZchDGfcgjpTiv3PmsSDKP1BgChKwRyFXukM9Lph2BBYdrJit7BLniyhCl1YldnHEVYSRCsKH5/01KspIB8X0VsTmCGdYrA909E7sF+DzrxZnYor4mXJ//hkSLdYIb+WqTHXn2VXGdoTyOhD8p9Rw9GpsGxhti9VXZ/D0sYxQT1+R/v+eTv5+fj4wIdl39rB8yytEegGKqbrIx2jfgpQQiF5XyGkuPuI9WIkmVdpnFmEJEFCrJeU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199018)(110136005)(83380400001)(478600001)(6486002)(2616005)(6506007)(53546011)(36756003)(6666004)(26005)(6512007)(186003)(41300700001)(38100700002)(5660300002)(86362001)(31686004)(31696002)(8936002)(316002)(66476007)(66946007)(66556008)(2906002)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHoxMG5hTnNmQUp0cWFzL1c0bUswam1OZ0UxdThGNFh1RHBLWndvV25TV01F?=
 =?utf-8?B?UjJoMWhiNDgvTjYzTjEzaDI3a1FlUGlyc0N4YWlZdWNGaEd4dDVnQlZsV0hP?=
 =?utf-8?B?R2VVTU9MeG94bEFRT09iS1orcUY3MW5lY0lPT1dQamhGcmw0YmFCaHJFUmdE?=
 =?utf-8?B?TFR6UUlkb0hENDZqOHE1ZjFHU0FTWVVvQlVhS3BVcE9yNEp2R2lkV0xVMjRC?=
 =?utf-8?B?SVlTVTZ1Qmh6NUZoOTZzZHhsRXozZDJEYWRTVHZQM2ZsM0cxMmZReVlJUzFO?=
 =?utf-8?B?b2k3SENjbXc4a1VONUkvcnRYYTRjQzlIeGt2ZFBKV2ozRnYvcjh2ZWVlUFJD?=
 =?utf-8?B?Z0FqK3Q3NzFmMTdWZEFlMzBId0ZRUTRaanNSUmtGNXNpNlMwZVlZS0Z3R0xP?=
 =?utf-8?B?ZTE3VW9NK2ViNXF4NEdaRVh5ZVp0U1JBelBIdDJZRlVwdG5tWWpodFJIeXZh?=
 =?utf-8?B?WDBldm5iNEZnRlA5MDVmOE03d3REWi8rN1FZSk81UHBaQ2FhQnJveDd4b2VG?=
 =?utf-8?B?QUhBL1M4NVNWRGFiS29FdGhQSEdBNFdqL1FOeXIrQy9uUm0wektpUzMxUW5Y?=
 =?utf-8?B?SVpiaHZla2JJU0VxNVdXOGtNcTVzWWlGeUI2L1lId3ZrdmxoWSt1Q0oxT0sx?=
 =?utf-8?B?SWxSUUxnQ2IzZmZoTUhsSmFhai82UEdQeVU2c2VaRk1RMnBDaEc5SHVPSEdU?=
 =?utf-8?B?VjljakcvOGMzSjZBaWFGaThSem9mVFlhYWx4QmNnUlFua1dHbStvWkxJQ3p2?=
 =?utf-8?B?dmJnam5ObWZsNHB1a1BWdXYzNkljMmxmakNsWFhVbVVUOTdNL0ZVc0ZoWUNG?=
 =?utf-8?B?MzdYcUloRWtEaHBVUUNRdUlnOE1KRFpEOW4weG1jZ2xXUnRkS1Z2dUpiT0hj?=
 =?utf-8?B?SlIxTitNNUo4TU5JQnZnT2FUQUNZdks2Q1Z4bWlTUXViTE5IM0NmbXBxU3lJ?=
 =?utf-8?B?QWV6eGFhN25Xc0tibi94ekgzb2hOcHE5Z3Y1bDJuMkZBcmhUQXA1VWlDaGZp?=
 =?utf-8?B?Q2NzNmh6R3pjZ1QxdzNsZG1jeG1tZVczOEVlUGtiZnNUQzJuSHFKSXdTN0tT?=
 =?utf-8?B?aWdkYzgvVnlyNHVYaVNtUmZZbjJCRWVPcWJha2phSFpackZvOUdoZjQxcWlT?=
 =?utf-8?B?MGlDRkFIVUNTRmRiZ3N3SWE2Q3hLcW1VaDY3NHptUU5BWDdJK2NCN1V2cnFV?=
 =?utf-8?B?Y29RbGU3ZFNHZHFON3A3dlcyTjNaVUtJOGZtSUc0STFobkpaOHMvRGpEclVJ?=
 =?utf-8?B?WDNZeCtZeFBOMW8zcXAvbmNtQ1JqOHdqbTFxa2dzajZEYkIzMEZmempwNjBi?=
 =?utf-8?B?UWxwQ0ZLZXZLeFU4clIxOUtKa0I0SUNPZUs1MVRRNzJNN21rS2NneXdlb3Jy?=
 =?utf-8?B?UHE5Q05qS1hwL1dvSys2QmVvT2VkYXhNOHB5M0lZU2l1VDVQSHJnM1YvTXF1?=
 =?utf-8?B?TXIvaXZGTkJHK3dkaTVtSk1WY1VNTktQOWhvQjdmT2loZDBmWFkzeXkyV2g0?=
 =?utf-8?B?aFI1cDdZVFJVdGZvMFliOXJOLzY4MUh1OGUzbDUyL2pPMGhBRGR2L1ZYTHJp?=
 =?utf-8?B?MVZLS3NkaHdCK0tnTDlHb1JOTUNxMUN1dVFsWmZNLzlvNy9ETjczZ1pCNlZr?=
 =?utf-8?B?WFliTnZ3ZGlEVGZDd2E0eUd1NlNCa1ZWdWdMcERSUDl0WVpod1dZa2pUS3lq?=
 =?utf-8?B?dG1GQTBaeG1LN1oyRElSVitJMkxjdURMK2ZJa0RObmdSQ2VrMmVDRHhYc0ps?=
 =?utf-8?B?Rk8wSXIxY2Y2NTVsblBncTdYZWpjZ2ZlTzhBUER5cXozUTZFbkdoekU3MHRS?=
 =?utf-8?B?SlhhOThhT1hlTGdTR2MwQzUwTldjM2djTi9IdmFJZXNaTStWUHl2ei9jZTF1?=
 =?utf-8?B?UVU2N3lLK2pSY1RPUDdjcytvQ1l5MGxYeUp1Mi83eWlJeXJlVi9JVU1LN01D?=
 =?utf-8?B?VEJzOGRmeSt1NUdaS0NZSEhHclo1ZlVkcnVwa1FyYUFQU01kNlN6L0JMb2xt?=
 =?utf-8?B?SUNFRVY1TUZ4eDExcXdtTDBsSGpUaC9QL3h5VmpEdWJZSGZ6RHg5VlJMR2tJ?=
 =?utf-8?B?bFc5MnpLc1Y1WGNyYTdkS0RTVytDZk5NSCtqRXRtaVdUQXhubXFha01WNGYy?=
 =?utf-8?Q?MEV6jrxlD3HJharwfm6dCO/O5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c19db3-ae3e-4310-0c28-08db0f92357e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 20:21:24.3587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+nxzpyF+MoAn2HMqfsY6QVlS2UZb9ayx/RnK/zeC1kO5iKM4NPuEAVCNdDx4UwFadxqERPn0qKrZnWU2/BkAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/2023 7:21 AM, Sean Christopherson wrote:
> Fix a bug in KVM's use of the GATag where it unintentionally drops a bit
> from vCPU IDs greater than 255 and as a result wakes the wrong vCPU.
> 
> Suravee and/or Alejandro, can you give this proper testing?  It's compile
> tested only at this point.  I'll do basic testing before officially
> applying, but AFAIK I don't have access to x2AVIC hardware, nor do I have
> a ready-to-go configuration to properly exercise this code.
> 
> Thanks!
> 
> Sean Christopherson (2):
>    KVM: SVM: Fix a benign off-by-one bug in AVIC physical table mask
>    KVM: SVM: WARN if GATag generation drops VM or vCPU ID information
> 
> Suravee Suthikulpanit (1):
>    KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs
> 
>   arch/x86/include/asm/svm.h | 12 +++++++-----
>   arch/x86/kvm/svm/avic.c    | 37 ++++++++++++++++++++++++++++---------
>   2 files changed, 35 insertions(+), 14 deletions(-)
> 
> 
> base-commit: 32e69f232db4ca11f26e5961daeff93906ce232f

For the series:

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
