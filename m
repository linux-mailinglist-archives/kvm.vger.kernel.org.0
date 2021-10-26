Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEF943B3E8
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbhJZO0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 10:26:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39526 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232773AbhJZO0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 10:26:05 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QDx6Ie018600;
        Tue, 26 Oct 2021 14:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WkQiH5Roki6FoYZdVYmdAs4BmdZChPXrZMyymeivFBo=;
 b=x54zDPyZ+Vs8Qu3m32nX0b8bmCJ+K8Lqdb8IlKHFzelaWKfoExA2TTj5sBbiqNW/JTqP
 jyCqCfG1CCsKcqC5SLxm0UblMmWeqokryVKH7cldI51NPeuxynF+QenbuZmLw57S81EC
 v191UpabHCnbBOHpO3qI/zwUGpmu1d5MIFIyTmiqvu27r2P1v0E9r9B4x9w1BdX8R4ZA
 y1fv6gPK9Or/FY1Yk2KKN/bdqu/+Mub7YDmdcdRXhW3ukqJKdiPQ6y0cpfBgc3GXSzZW
 xMO/LDH5obandccjHD0ba442ZGG9jSdmUd1WULtXTLH/QOp12+ShV8vuxlATBpwyaQtw rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhvmub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 14:23:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QEFvm9050589;
        Tue, 26 Oct 2021 14:22:46 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3030.oracle.com with ESMTP id 3bx4h0n0f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 14:22:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCZ6dSZMijxIIpHQlY/A9/l7S1+e6z9yxdWozVGQxqF5dexqWm9o0dLMknBAoI0QYKpqNh2Mz7LlBROYl5tHsiCj95j/plu7esaHOx5QhEb+k6Fa5ySqKiGRlqBUkLPhyKWvmDvfPCHA5jGgC3iOtjM8LfMACcaVVHwWQCrxiJ0mfkBma03/93NCON+tL7OCPhtYiJe+TNyc9F0Fcllef7HYmCanmfef+gUWIE24XJYApcUxKhxf0mZvxDGfiXpgdbWzJvrVF0fTBAbd7W+mW8203uei+6MYfh7NvkmdBaU93byKx0rOW3l5pM+wf5+Wiuf7QZzcqKcZ+3lYKdvzig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkQiH5Roki6FoYZdVYmdAs4BmdZChPXrZMyymeivFBo=;
 b=LNHDMjvkbLb3zzB32k4F7MR3vibL0R5wXdltdjvtvbABK5anMnrLnorrNYm2IDx1otDjpuNWgnR507uTeXeVfUNT+tcbNwf+bPbsUATmlskuId028lOA3FfZbJHj/9i2oEco7ee+mSbfWzGIFC0Ge8xT7MF/A+RhCLbU8O4Ts2jsPL3O+98+iM3HbMAiXavZK4qe+H41S2DjFN18Qe5oRIQeFAC5Ff0LSgrzE2aYeXL14GHu6diGwCbIK91jWeMgh6+JiY5ubZrPPzvom89WhCFhJFWYDq64fpO+xxIFaYVjPn/VBYgKIsFDRv0tOHpLJwyaESm4vs8Jwg1UPydXZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkQiH5Roki6FoYZdVYmdAs4BmdZChPXrZMyymeivFBo=;
 b=G3pTD3cpsgLUwQpphYCRjm2sElx3yKK3KNzuSy68l5tLHNU0LMazMsOsyk4+vG11OD/OrzHCinusEXmSN4sNy6T2Ot9gG+xtjp8+ieT0dTDvlkuZbIPnOmUiglepFufYZQ1Q0mM2NjooQ2vR9gwiVig+lRAGKTQ8QdrYeLA+vyQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH2PR10MB3750.namprd10.prod.outlook.com (2603:10b6:610:b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 14:22:44 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:22:43 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Drop a redundant remote TLB flush in
 kvm_zap_gfn_range()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>
References: <20211022010005.1454978-1-seanjc@google.com>
 <20211022010005.1454978-3-seanjc@google.com>
 <ed34e089-5a35-2502-5a7d-ad8b1cf6957f@oracle.com>
 <YXbPrOXlSMJrVaqA@google.com>
Message-ID: <aabbe822-cae8-c1ea-9f9e-c35145754e83@oracle.com>
Date:   Tue, 26 Oct 2021 16:22:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXbPrOXlSMJrVaqA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0235.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::34) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.169.139) by AS9PR06CA0235.eurprd06.prod.outlook.com (2603:10a6:20b:45e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 14:22:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b66ac2e6-c6ec-4686-49f8-08d9988c1336
X-MS-TrafficTypeDiagnostic: CH2PR10MB3750:
X-Microsoft-Antispam-PRVS: <CH2PR10MB3750BCFFFC4B7F4944E0615DFF849@CH2PR10MB3750.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7IRGtW2aW5ejewFzA8aKxzNpZj+GdYCM4yYAfwNxkjKIdFtntWkEKoQNrUNq9J4MY487B4Rdf+oUAP2Kq+imahg6Un7pox1WkKPkZn5nuZcO/8SPQM7p2bsFw9db03XRyVobtuQ1vgJzBaQ4OOMzEQdEMDY5knx8ehKmfZaRshTA7TTBASredk/pg/AavPQlqkt2DNKeWSEU2ariY73kwLT+FRoEp3ywUrdLWoLmkLXvKZNCLQ+lOs6mTXVPc/ENL9ilmxtnpkivjaJ2DKqUXc98EYNAc1+aU47nTOEaTMT86B+nsQUuNGvWMfdez26mDT45lHpaJQk88h6NHn+fmExBvfLw6mVWQS2Cp+7Qtj8S4b5UMKjt+Mhhs5IF1qyueuFdJBwJvdyj+d7+YPKZhkawUZ9lTNgER20ZlR5TUra/AhBr4IaFHNrv6dOgpI8QMCSzKOvFE3ct/C2uo+qStu91rbTQSgvabfsoPQmNmb/s8S0S6rU5nK7TKd78ghXHCJ7nQz40XJfR2qFdP18QWuiTm+GRBwTyl4oBLFtvy5WTy6kdW6cX2BX2Zdu/TRUFEwbSF2BL9eTK/mPqIK3n5W4aOnQTJ5OssOaFfe/aTqT9rZWvYe5o3J0Ukd+Q9OzPZlbHwkz6LC+uyDOjyFidzdKUaDgPj4DSsnu5tyauLoZJ1Qn6m0cRDoC9CJLEdTXbIMMAgAGMsCw1sMY4RqFpj6NbG8e076QPCMeiTljAf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(316002)(16576012)(31686004)(66946007)(54906003)(186003)(956004)(2616005)(26005)(6666004)(38100700002)(36756003)(86362001)(53546011)(83380400001)(31696002)(6916009)(7416002)(6486002)(8936002)(5660300002)(8676002)(2906002)(4326008)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?angyd0s4WUo3VVVPOGJlTnIzYWQwckRSM0Y1Y1pnSUwrdFVPT2F5WS9mbzZS?=
 =?utf-8?B?WkQ2MTFiRHR5dHVyWTVpWmRzOFZBV3pEcnN6SzJtc24zSnRKcXNQUWVnU2RL?=
 =?utf-8?B?UUl1RmxoSnUwTVNWN3o2cEdXSjQzUXlCZ0hscnBXWVpkcFU4aGxPeStIMG9S?=
 =?utf-8?B?dDF1TEVSd3F2cHN1azRiQkN0eEhML2lpTmNLdDJXOFpTY3ZPTGhOaSthbmJq?=
 =?utf-8?B?RjMrazBlZ09od29MMlZVeXBvN0xLaTNYUkZkTEVKRjVDOFFIUFlFSHkwYkMr?=
 =?utf-8?B?MGp4eU1NM28rTzI3VDdjRU1HWFN0SGVUcXZmUEk3VXFzcHd1dWxUUEtUSjZB?=
 =?utf-8?B?cUZ4NUplanNyTllrY3c3YTN2K09Jc0lKOFl1ZEhhSTNoT0s5UC9nbGlOR3lF?=
 =?utf-8?B?NzdXUHlPa2VUUFltRXJQNG9sNXV0N290S21wT1ZRWXZJNHJPVFdmakVVWjJT?=
 =?utf-8?B?NHl6dGxiRUVmUmk3U1UySU1kMFk4QjhvaTVIK0VFaVozQWVjd2lMVGJXbERK?=
 =?utf-8?B?M3pJSnNGQ1RyZk5UZGZUN05zcldHNzNBa1ZLTTFsb1pvR3JKdVUvMFRlQkVi?=
 =?utf-8?B?REI5Uy82dXJteDZVaWNEaFJKWFVxdlNQZVdWZzdMYzRyaGVSUHFDK09tWjhU?=
 =?utf-8?B?bnQ4NjI4QUZEdWl4cEpWR2s1OUtKVHRPdHZwMURSeDRuRlBCTW1wcFhmRno3?=
 =?utf-8?B?Wko5YmgzZWdDdGN6OXJSZHhqbmhsM1VLTGtSeGJpeFEvelp1Y1E5NzUyWmRa?=
 =?utf-8?B?a3dEeGdjUkpub0xVKy9obW05alE2TW9wOEN0ak1uNG9hOWNPdTNwV2Y3c25S?=
 =?utf-8?B?cXlkTlF4NGdhR1l3bXJrYkZTS3cxcElCWllWeER5a1NNVEd1Um5rNDRWUDRp?=
 =?utf-8?B?YUVNYWpjbVdWR3lrUVJWc3BTWkcwUnlnZ0xsTlR1R1NXcG9PazM5KysrUU9p?=
 =?utf-8?B?YUxsakpBV2Y2c2hYa1Njd0RzeUYzMnNzNWZwTVBycVprWlJJRGtnclNnSFR3?=
 =?utf-8?B?a0NVbVpMQlZsV25QNkYyMGIyNFkyTGhSZGY3WHh4Z1MvUU9MSko0V0lnQkVF?=
 =?utf-8?B?K1pGVVpHL2xSZDlRbWt1d3BZSWJUQ0g2VWgvK3NUYzFVakNVMnEzMTRnVktS?=
 =?utf-8?B?Tm4wRzlyeGg2QVdmSGdjRGNpaFljSUZhamFGa3Eya1laUWNlY3owYWlrRElQ?=
 =?utf-8?B?bU0yaXZja054dllQb1Y0cUllMkxwMmorWkl1OXhMR2IxYkZCWjBRVEl6bVo4?=
 =?utf-8?B?eUZ0bVJrT1FjOXE4NjdJbEZ0NDB2YURaMUZWckRGT0hESVJOT200Q3ZvNTJu?=
 =?utf-8?B?VjRHcWxPZThrbE9ncGpUUTFGblVSd1RiMWJuVm81NnR3SDRyWTkvTnRoSGFo?=
 =?utf-8?B?Z1FOR0lvUU13cVNVWTFaU2JZeCt1Q3M3RUtCa0xZMXlWZlBNWnMzNjdwVjgy?=
 =?utf-8?B?eGtJS09LdlMxU3VCbS9UbWpLd1NsS0V6M2VzOHo0UEhhUFhURjl0RzdBci9T?=
 =?utf-8?B?aU1oSmEvTXdGcDVjSlhnZ0l3L1B0OGV4SnBGYW9rcHZ3Y2c1dDUrL2RjODF5?=
 =?utf-8?B?aEREOWs2NDNJMm5UM1NKV3JqQ1JXaVpDU0dReWRKUG56dzd2VkoxakowdGJY?=
 =?utf-8?B?SHhKTFpHUDJtWlhpMXpXTmplYUhlZzVDOUNtME04OXVjMFhHd1ZQRkxSUytl?=
 =?utf-8?B?R2twaW9lR0R0b29BYkJwSDl5Q1U3bVZhY1hlaTFIbFRqVUNSN0x2ZnN4SGNE?=
 =?utf-8?B?M3JGb3JLZE1hS0pQcE9iY0JYTC90Ym9hTFlZNDhXMTRJVTljbjB6MnZKcWlJ?=
 =?utf-8?B?KytmT0lGVlJaMnpkcWpwbVMzalpPQ1VLNTF2dmxCVGdZeFFaWWhlSmFGdWs2?=
 =?utf-8?B?bXJ3OHhaUzBaQXJOWUd2elZ1SlJlQmlHTWgwUGJwbkV6L3M4VUxEdDFxMFBa?=
 =?utf-8?B?Qk10NTlkVG5FRUxKS3YzQWhMdDA2Ym1OY3p1TkdTd3lkdlpYYUUrQndGM0ow?=
 =?utf-8?B?aWdXaUZLVGRxWUtFZnZoS0dpMDRVSVNxeS9lL1R1aks0dXVSS292UjBjK2FN?=
 =?utf-8?B?TExzZi9GMDl6VDQ4QXAwL1NHbnoxYkFvdEZGVGt3VDA4NGFTakJzb3JOMFNB?=
 =?utf-8?B?ODJZVVRzVkFxMXQwMVRLdDk2RVVlcnBWa3dDK2JJMXY4eUs0c1pnOURWc2FT?=
 =?utf-8?B?NnRNYWw4T0k2cUt0aE5KTm1ZT2xuN09jNi9FQmxuYWdmbHFoTEtIZGZWQnB4?=
 =?utf-8?B?SG5KVjFZWkxpb2oyOXlobjVRc0dnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66ac2e6-c6ec-4686-49f8-08d9988c1336
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:22:43.8472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqqvVKRXsGBWnzhndCFcUTfmqC6D7XqgBkm53e8oW8Zipps7W5PV2l4yZNT9eWP7wSiUM8XfXnndx5VQ63n2ac0F2o3QSz8XOn82BZ2iiiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260082
X-Proofpoint-GUID: Oh_ORc6d6xz3jCvIk7nkpW5_I0Hcfmog
X-Proofpoint-ORIG-GUID: Oh_ORc6d6xz3jCvIk7nkpW5_I0Hcfmog
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.2021 17:39, Sean Christopherson wrote:
> On Fri, Oct 22, 2021, Maciej S. Szmigiero wrote:
>> On 22.10.2021 03:00, Sean Christopherson wrote:
>>> Remove an unnecessary remote TLB flush in kvm_zap_gfn_range() now that
>>> said function holds mmu_lock for write for its entire duration.  The
>>> flush was added by the now-reverted commit to allow TDP MMU to flush while
>>> holding mmu_lock for read, as the transition from write=>read required
>>> dropping the lock and thus a pending flush needed to be serviced.
>>>
>>> Fixes: 5a324c24b638 ("Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"")
>>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>>> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>> Cc: Ben Gardon <bgardon@google.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 3 ---
>>>    1 file changed, 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index f82b192bba0b..e8b8a665e2e9 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -5700,9 +5700,6 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>>>    						end - 1, true, flush);
>>>    			}
>>>    		}
>>> -		if (flush)
>>> -			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
>>> -							   gfn_end - gfn_start);
>>>    	}
>>>    	if (is_tdp_mmu_enabled(kvm)) {
>>>
>>
>> Unfortunately, it seems that a pending flush from __kvm_zap_rmaps()
>> can be reset back to false by the following line:
>>> flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start, gfn_end, flush);
>>
>> kvm_tdp_mmu_zap_gfn_range() calls __kvm_tdp_mmu_zap_gfn_range with
>> "can_yield" set to true, which passes it to zap_gfn_range, which has
>> this code:
>>> if (can_yield &&
>>>      tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
>>>        flush = false;
>>>        continue;
>>> }
> 
> That's working by design.  If the MMU (legacy or TDP) yields during zap, it _must_
> flush before dropping mmu_lock so that any SPTE modifications are guaranteed to be
> observed by all vCPUs.  Clearing "flush" is deliberate/correct as another is flush
> is needed if and only if additional SPTE modifications are made.
> 

Got it, thanks.

Maciej

