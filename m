Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C22F468001
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 23:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354018AbhLCWto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 17:49:44 -0500
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:14977
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229985AbhLCWtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 17:49:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNavfkvYw5Mp0anR6/VLvLsune4YRNoHhcsIXnfo7eXwg/y2lycR9hcZtUIPGJo+fkOqdZYftlK2tq4ZlRcvFpodYANYlbfhdY+HgIabmp2FRU4bnclHz4frElmfjM0WP35SV5Z3DNktTNYXuPFEvskWEJLeHs+X2Fv6F5DyqHuWbwHVanj+1aA36Rv/EBN21xB3GfJpWiBdpmL/aGOzGBiD56foDlA/jyOOM9HSIt5t7IMyaW5PgkZkNiDi5P87PZL7dcXo77JOzC1vjl2URpmi8jJyOZkhjtyZ0a0jslYQwjyJiowxH+EXp2TRtbUH7p7NX3Uu8e4+6pKTiaCZKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHiZbfhiUmZm/mrM3R2bv5d+kWLY2kvhvTZnVuDdt+w=;
 b=lPVnpBFBT3yJGZgqngdfDaX0edeNsNSkH5VbTDoNQAhmSKNQs6lYA9e+t/iRfP5P0Jcu3M+BF5lLTA59wbyR4Wzy/gVhw4uLieenxbtrwQK1SYnSY0DQnE6sM7bXKi53DWgzh+D1Yx7AO4iXTsjyVSDdwOn5e8e+292kKlQ2VS5eS09e2KqehZEEvtNAil8TcvoRkH2S0kYCUDeoiTovdIdQRbzgB0R8ahcftpLlvMae6YKA/i2ox9Ai5WbWAkhWIJ/lAwPJYp2/O4FMyBH3UqY4abf5edNNsXWmRv+v1H4UBcPnbCP2bNUmy4RIqMCpy8CzVsOpA6wwX01n9obPeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHiZbfhiUmZm/mrM3R2bv5d+kWLY2kvhvTZnVuDdt+w=;
 b=oG3a5zoTAbxjYb6Y3e+krZ2Bsp2irvycyp7l66DJH/kwtNC86OR6iV/nSs+cr+WWNiT8W9ATAadrp3y1MNJcAjb2RRIBNA/+KkIauaZ+qaLAzbv8o9ayjDMmvLOCpxHR6sNglwjs2DDNINgRZiBOZtHZfFzDEQepsCd0YjF91IU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 22:46:17 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::c8a7:285a:2bdd:a64c]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::c8a7:285a:2bdd:a64c%7]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 22:46:17 +0000
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
 <YapIMYiJ+iIfHI+c@google.com> <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
Message-ID: <62090a4e-cb7d-437e-88f9-b5f97a175c38@amd.com>
Date:   Fri, 3 Dec 2021 16:46:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:806:20::29) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR03CA0024.namprd03.prod.outlook.com (2603:10b6:806:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 3 Dec 2021 22:46:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abddb62d-0797-4f1f-28e1-08d9b6aeb770
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55214A29D6281F918A4C6074EC6A9@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKMAZWyjVEwYzsUK+GbtV9yKxzVi6/JXhi0u+qrPdPGs9IKDRJRhieV80rRtcMuG5K9FsPN+o0/lwIRUUyuMVjQgaT5HgmgeJsBtQ9rNs9Z9ttVvtPVDDiQjBgZcMVF0Z3Jg1uQZEQ7dzg74JpluYWMLrbovwUm7pn/GPsGUZ3JWqeLTidtQJRfMgiqXLWfpk8Dyk2Rj38OjrhNOU83nExDppjp0xJ31aoqLxKM+abZjlY1r/9MqgT8AvGJxYbEfB+fgiga2GI3Xm/K8MbUy+87BraNfLzrv2SolqIha+YIzM4xO7XYZPALXTKYLiun8slYllEzQjwRTzkiRjBpmGt5O54rviqiAprMH895o3kjOr2YEw0WYOewOhDN77bDz3y+0qdYmkBZ7LgqUtbGCvnKWX72THcEMjF1WQGuiqq6ZVP6+r3+McwOqgAlEtPMFsZCag7eZ4hPtCXuvaalgrFOZzlACgpYMXzUdeTG0h5BBQNtQjyqLLokhuMlqIPlSIbYr5WLm+Dcz+OcciPjYkuQMSKEFNioH5b2K7TSHah+KBcO/PJAhKMaHNya2aJGALp5zfLYookH7EVWT5WIRNII17B/eagx7HLP3NtNtkpJHy/fkqrCvyhjLwzVj511Inb0Kaq+7VPl1Y9B6BILBpN7drZLDP50aqhjZ41jD7W5O5AbQ3OI04eTz8j15+ylSrdvBlWuF6WUdrZsKAIEqbl3CIK/6/3AtuPXqZIeBABo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(4744005)(4326008)(2616005)(26005)(186003)(6512007)(86362001)(508600001)(53546011)(54906003)(6916009)(316002)(5660300002)(6506007)(31696002)(66946007)(66556008)(36756003)(8936002)(66476007)(8676002)(7416002)(956004)(38100700002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWVqYVBZbi9lWnQ0TmlQS3g1UFhEUEJnM2o4VW5VWGVjVHdQQytHbEdCRlpD?=
 =?utf-8?B?cmlxcmtXMGFWRnd4TTg2WlBlNkxISnFINy9LTERxWkd2OGFyQzFCZlhOaDhy?=
 =?utf-8?B?UENnT3l3Wk56cjlKRjQwYXVOcGpIUXA3QVNOTGRCVFdqQmgvZjZ5Tnp5c2Yr?=
 =?utf-8?B?aEhyTFRrMTFNQjNweFVxamcxYkwyR2tkVnRRazY1OXNOWURveWk4M3FYdkwv?=
 =?utf-8?B?ODEyZ3N6SGd3UmY4emk2dng4NlVWSHhoRUpRUnVmOVBoTWRPODh4THJBN211?=
 =?utf-8?B?ZERPNForWWp0WEl0UEVkUkt1UTdIc1o2MHRNQS9UOW41cHU2Z1Nrc2JYbzVq?=
 =?utf-8?B?MU42NDJTMWZmVlJyd21EcTVkUUw0Z3BKemtuTTJyQ01VL3NZa3R4QzhNV1hw?=
 =?utf-8?B?ZnRLVnV5eHlyOFB6R1NuWVdTZmNmZnJiWnh0U21UbUxGSmgvKzgza3B5WEFp?=
 =?utf-8?B?cjdQYisvR3lZMmhaeE5MTmMweldVeHRYbHF4Qy9hUEV3em5Ua3ppUUJoZE40?=
 =?utf-8?B?YlM3ZXpYQ29rZUtiZ1FYSjFaS0xpZGsycjRZVm9UekI5eUFvTjRHZUFCb2FK?=
 =?utf-8?B?Y3ZuOGhpdDhCQytRN050RndydTBHZU9UVTBJTnVYWlpTSFFNVlk2blU1WHh3?=
 =?utf-8?B?Z25INFFYcmplRVlaZVlZTTljcnhyNkowd2hPWmJlbnQ3WGFEMXBXb2lqRU1I?=
 =?utf-8?B?ZWRLUUN2LzdDQXhOaVdPcWtBbG9xdXJpdXRmUUhLMmdiTm53eDFSd3c5SEd3?=
 =?utf-8?B?NlpDcUNTc041bjJ4SFByK1R1cVlnaWxlVnRLc3hLYmxYSlBBbjlKTFY0U0o3?=
 =?utf-8?B?Y2JYdVFLY29hRko2VUhGOGhqcmlRQ0hENXhhUlQzRDZxcXZBc3hod0tzcFdu?=
 =?utf-8?B?czhGeVhoOWg3RDczQUFOTnBpaXl6aUJyVTY4dGF6UjlwZHRsbVlNUjZMS3N3?=
 =?utf-8?B?VlhncVJDeGQxLzVhR1R6WFo0S2FFYW9tNzBGVzc1cmpiejVnT1d4V3JsRk9v?=
 =?utf-8?B?cjltcjd2d3N3NXllSFlsTUdLYjJjb2xKeWpsd2NnczhzTnZ2WmFxQXl2YmZp?=
 =?utf-8?B?aEh1RXVWUkEwS3FvTUNwRElkL2s0TVovQllQYTJ4TmdSTzNabmhVemQ4S3Nm?=
 =?utf-8?B?VjZjSVp4K0pqZ2pHVnphN3U5OXVTUk5aSWUzNE9MTWVjWnk2bElWMElMdnNO?=
 =?utf-8?B?NXdjWFhoN0RwTzUzRFNqeVlMTHRHV2xqaXMrV2h6cHJEWkwzMlhtV2tENHdC?=
 =?utf-8?B?ajFPUXFBQUFPWG5HcEs5MUpOR1RVWmRKUk5QVFEzQlBEZFVwZjNTTkExOE1i?=
 =?utf-8?B?L0ZpejJVaGQxL0xBN2o1bGp6Yi9adHQyaEFML01WRWYrSGVQWjFtTFdNUVlr?=
 =?utf-8?B?d0Z5SUJpR2hMbzNVQjNwR0JHMXdVaCt5RURvUHAwQ0tVTzhlZHBOeGlHdmgv?=
 =?utf-8?B?bHo5V2ZaZndWUHpGbWtmcXJDWlQrd0FZQjRpQUJNdUtDaFBqNkw5UVE1ZUpj?=
 =?utf-8?B?eHJ6VmtFblE4T3Z2L2RaeU5kSVNrTVhiTE5seU93WlR1RWVibHpRK043U0dF?=
 =?utf-8?B?NklYbHZzaWJ4d0puVVRFc3JURS9HSzBSOVEwWGpoMW01Z0VEeDYzeFNFVFQ0?=
 =?utf-8?B?U3hRUkZZQjIzaHd1aW9SQ3ExQUVVWHpiWE9SRUJpRE0yYkR6WEU5endBbkYz?=
 =?utf-8?B?TEM3TllndE1oSnJjZk00SHBINk9OR0RNQVRONlg1Tjd4c0JCV0hZYVVTVU40?=
 =?utf-8?B?QUErdFp1WXpHckhpZkZvTjNtdHVhanREemhFS21rSmFlbGdtN05oeDhkMS84?=
 =?utf-8?B?TmMvNzhOajQxbDRmanRKQVpKM2grU2dTeUhQQktmMHdhWjlTbmNDM1h1ZCtq?=
 =?utf-8?B?dzlTbTErNWVQbnBmblVFTWRMeHVjMDB5RWxsY1VtL2JRdDhWdXNjcjBhZENP?=
 =?utf-8?B?R2pqWTlHN0xYSTA1ZW9WWUU0UFdxR0lqOGhnRVh0ZW9YdlBPc1c1VFQzM1Mr?=
 =?utf-8?B?bFE1Wi85b2tBVjNUYUhEL1BLWjd3WUI3Qkg5RHY2RFFWcnFlM290UGhDMGFp?=
 =?utf-8?B?YzU5MUxxMmREb2tzMi8xV2xUa083NE1nZjRKMDl6K3lRQnRmeEM3U1FLSXYv?=
 =?utf-8?B?aC9UUEFvSHcyemVNZWtYQXVXa3g3UDFXVDdNVTJycUN6ZVhrNDRmeXBPWGtT?=
 =?utf-8?Q?YYmsgemwR3CnEHAke0Hs7Ro=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abddb62d-0797-4f1f-28e1-08d9b6aeb770
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 22:46:16.9155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpshLf2tCWc3Wo5W1Rfp5nOjxatDlGlg1yzcJdsbkavvFPLagXRwGgaisywRGxfadBUKPUXXjTeoSFAHJRyNQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 12:59 PM, Tom Lendacky wrote:
> On 12/3/21 10:39 AM, Sean Christopherson wrote:
>> On Thu, Dec 02, 2021, Tom Lendacky wrote:
> 

>>
>> IMO, this should be the patch (compile tested only).
> 
> I can test this, but probably won't be able to get to it until Monday.

I did manage to get some time to test this today. Works as expected with 
an invalid scratch GPA terminating the guest.

Up to Paolo now with what he would like to see/do.

Thanks,
Tom

> 
