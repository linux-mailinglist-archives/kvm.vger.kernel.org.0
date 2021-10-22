Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB36D437627
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 13:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhJVLry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 07:47:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30702 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232670AbhJVLrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 07:47:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MAsD8N031032;
        Fri, 22 Oct 2021 11:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yZXw4e+hXs4HoFGapQZWMyRlYtJlFZ1ij5c4RH4cw00=;
 b=0qhLlnGuTDiUlTcLFOVONRFziOxOsu2L8dF9xwDM+lousbskmkwBt8/3WJliqX0VhAiv
 rvNKdelRpAh3WrHTpLe4rVrAXu98dpRsK9mTl8yjW71KF4iNDSGwSllB473uI9ESdXIy
 pICpKigAcbUCFhSj0QmRYOGBeaYBYXVTDIb6TDppan0R3oIcIAPcH1Df/P1rxeZOEgN1
 Jegk5f+neM9Z6C2AmU/lYxNrR+W6KXB3sJweemIFwwjDx4h5wxMubi+Ix3WH6EUuX3do
 8CGMJ69raqBLlURj4grUgnYi3nWTJenutLm504AHTxKInFFwriOIgRfTfnaFQFL9VDeU Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3buta88pcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 11:44:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MBf0T4158082;
        Fri, 22 Oct 2021 11:44:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3bqmskusx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 11:44:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkgsuvOWSJKDRtsYLza6Rr1OQILK/E8J9Wd4EnlODTBLcATVaCzZahwi4wErJo72xddjMgQ31iRo995aG3HGHu2rG5VL3noi5ZlcY/lye3Rn2CdH0sr7l8L3XNKovmGcm8DKqIxhDtO482lh4Eg7Z1c8hCIS52wvb+dZdURsFeVRVMWqD81yW6U1DNPpWwV3PKIvXgYA3upNNRzdGrR4a4nPhdMfL02hIPYTUts1UEi4oXT2tjLT8jkXxVuQPO6BDXk4QnPMmOn++QrT2efh9W6LX/6ZqGvQVsZlkLMzJHZ9QlOwjvholChE+3B2zGswhpeIxXaBV09YKAHR9635KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZXw4e+hXs4HoFGapQZWMyRlYtJlFZ1ij5c4RH4cw00=;
 b=Ya5I5oxpa/P99cvhDrBWTqBBx42JEdfGjxfdFyrO4H6x2XY4vOv+RVqPcNQuLv5YenDvUxyqhFvYx3u3oZM27CyU9sjgJCFCrFGTNGc2hQzgkLlSUhZgAhysWr5ta1t6SsAH/hQLFjbjXt8CzPOLssK+JmaEPUYXj4jSeVgpiCv0ovyPtKrHlx8I7AWjKNyuOdGQysmOAFXr+ZVw/TIAnIPYJmZmZzui3emgylVKs8yAGxCjrubWJA89fWT4qxOnOEJtLTxLFmsV1MiJc5Z2T9fw89K9LQB9CPeBzyTqhfNBvLR8fnG0jm4b1BXJMZsVSVnI/7nxVEYlNBjnyze62A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZXw4e+hXs4HoFGapQZWMyRlYtJlFZ1ij5c4RH4cw00=;
 b=Ev8zo1wd4BJfQJXXfIvNoAAzPWIdI5XWuUIR6x/lJina8wl8CMFmp51IwhxFnN7bD9qiFyKSnyM5fG1INfFqfgs69vz3QRig/hqHz7ERRUQCNa7yGtOW4lhlUigSOBG3i1gEUWPSWywaCR/Ldss392QRAp9bIfcuVoUIbREVepg=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB4011.namprd10.prod.outlook.com (2603:10b6:5:1d1::11)
 by DM6PR10MB2508.namprd10.prod.outlook.com (2603:10b6:5:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 11:44:52 +0000
Received: from DM6PR10MB4011.namprd10.prod.outlook.com
 ([fe80::4879:b979:bb47:1e68]) by DM6PR10MB4011.namprd10.prod.outlook.com
 ([fe80::4879:b979:bb47:1e68%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 11:44:52 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Drop a redundant remote TLB flush in
 kvm_zap_gfn_range()
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>
References: <20211022010005.1454978-1-seanjc@google.com>
 <20211022010005.1454978-3-seanjc@google.com>
Message-ID: <ed34e089-5a35-2502-5a7d-ad8b1cf6957f@oracle.com>
Date:   Fri, 22 Oct 2021 13:44:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211022010005.1454978-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0216.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::30) To DM6PR10MB4011.namprd10.prod.outlook.com
 (2603:10b6:5:1d1::11)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.16) by AS9PR06CA0216.eurprd06.prod.outlook.com (2603:10a6:20b:45e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 11:44:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab3c60fb-a8fe-4ca4-9a02-08d995515c7a
X-MS-TrafficTypeDiagnostic: DM6PR10MB2508:
X-Microsoft-Antispam-PRVS: <DM6PR10MB25088C2819E6F1C999B3A0D5FF809@DM6PR10MB2508.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BoFmkeAdjQf7dWfAZb9S8ZmN2clJUVln5MBzf62gmgRI2qMH/JBUQRlg2oqpMiAkhLrzY2iZHoqg5RxNu2Blrb8RaWPIRuAzkwzpTjKT4Vu/U1Qm8zJ7X/8S8Kpfjc0nJXbXgNpDJ+XargpVLfW+2f2qhz5++q5xBcf2NNhwr6bqWeiqEger9M8UMYzMOBWx4PRlWduY9aMTgCw/Bb+RtTCbmt9hBiapso6ZWY5Riaxl9Oozmmireuue5ylYniO0xydhCNXf+sFvQyV1GTmdwMXaiELwr5KqGFYwwMHnYyKtNxtpGsm7/rgBBgI7XpAEgYcg7H7M8SvPkknqBB3O1jcEYnG7dFERsJmI/shhCyDHesnXv4GFEUoCN4bR1Evu01C1fmYwZvgVTzOLZMuMCvv9XeQRvIWua6Ue4hS63YGMyaq02BJzOa7JidBLHDSSVtAYFstX1Np5f3XoTWXbTuatGe8EECuCXLGpYdAWjafIvftjl9luNhIiTQJvIcYD0sH5RfeC7LYAHIPaWhZXhKJpRjTSeOBlFhTQ4AZ6WmhUcEyEqEbFs4t9AuSXKV71CC4krexlBNrIzh2XIHW5YzBnY+roIDr79h+Ra9B4XGga0bMkEP4DcmPOF5bIafnR6+vW7rlShuVv6AymBPqKYh5XSptRYj6bDARRNjkxC4BMh3sFUd83m8p21ZzpuIy5RHWwm6I83HY0Ejec0MEOb70Ao12wk0xele/ACkJZA5Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4011.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(8676002)(956004)(2616005)(8936002)(26005)(6666004)(31686004)(36756003)(110136005)(6486002)(38100700002)(66946007)(2906002)(16576012)(508600001)(5660300002)(66556008)(186003)(66476007)(31696002)(53546011)(316002)(86362001)(7416002)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjV5MUFtQXFSL1ladWpIMXhiV3B2cmxJdFJMaFdzTzF0SG0xZ2lIc1dmVGNl?=
 =?utf-8?B?c3NIRGZKZFJYU1A0b1ZsUGl3bGVPREYyS3lHdXBvSEZpZ0ZMdlBUazl3RG9p?=
 =?utf-8?B?dUd4cGRTazJPc0tVQ00vZnN4SWkwUE4wSHhyTlBDZ0FGdHVvb0JBMmZYSW1I?=
 =?utf-8?B?bTYrZ1dwMHdTbHlqUnNHY0N5YXZMSE44SGxZaU54MEYxZmtveVFpUk4yMmwx?=
 =?utf-8?B?L0MrbHFmWVBzZWV1eXU1YnZlbS9ENHFCQ3k0T2VGRTNRd25yUy9LNTdJQm04?=
 =?utf-8?B?V2dKbU10enRYYmhZWVBJc2NlT2lLN0h1TG8zOGZjZWsra09lOHlVcjkydjE4?=
 =?utf-8?B?RWhCTFZpMkx3dlpjcTE3ZXNHMmxQUk15cEZGTzNIclhjbUNaWVFWOFhDcytD?=
 =?utf-8?B?MDVqVWxyZldtWVZFR1FHTlZyamp2MnV1eU51UG1iNEN4cFY2Q2xEUnV3aS9j?=
 =?utf-8?B?Q2JIb1FPemFxM0ZLKzM4dGNtWGlYKzl2RFk4T1RhZytqV3hybmN6YkNpTFF1?=
 =?utf-8?B?QU1mS3ZhS20wTmd0M3RPTW1NN0lUTHA3cUw5eE95cER4bm5FZThpMDVISjVq?=
 =?utf-8?B?bXFlNHBWL0F3aW9UQW5id2NsQ3BlN3RBNk9NM3RFUFhJL05HbzBwK0JSUElr?=
 =?utf-8?B?YSthdmd3WDFmcVV6TW9HMzNIL2tkMHBEYWluRm8wYUNxa3ZUempkZ3Z4VnNs?=
 =?utf-8?B?bUs1VElsY05DNnZDYU5WSWFTeFpOS1lQeHU4Z2duQ3N5VkljREZiU1dvUllQ?=
 =?utf-8?B?QS9YZWU3Z0taOVIrNVZIazgvY2Y3UjdUd0F3SERhQjZ0TW91VCtKYlFZeHRI?=
 =?utf-8?B?Sm1WRXFNSWtSZFhuOVJCeExOaDZNTVc3bkFYZkhGZlBVSHIyOXZYVUZsa0JC?=
 =?utf-8?B?SkMrRkdoQXFGcDdXMVplY3NsVGpnL1lUclVkZFBySUtMS3M4TVJuMEgranJp?=
 =?utf-8?B?QVh0VEVLVGhWa1dsNGl0eTBKamVkbCt6SVFZVkNCYzBqeTc4cjRVazk1YVNE?=
 =?utf-8?B?K0ZUUU1uQjFWekJtYU52dHVoTTF3dDJkTDhNQjQzU0pQK0dpSG96NHJDMzlH?=
 =?utf-8?B?RmU3YThwbWowTUI1SVNOb002VkZJRitQb01Sekl5STRuSGdTdDVIZS9WZE5l?=
 =?utf-8?B?T2R2NERlREZSMk94MWNlZVNXc1BLbVF1cW5xS2VOdCthVHd1c1RScGRlaFU3?=
 =?utf-8?B?QUUzMFVMbHBkMU5YaldDNENlclJqdjhiazhYVC95azlZMTF6NFg2WXAvem5l?=
 =?utf-8?B?T0JkNlRPdUJqTEkyb05MRXJQNUpXc1ZBNmhEN2JXbTVMZWhUd0xOU1hxWStu?=
 =?utf-8?B?TGxVU09ucCtQTzl4Z1kyYUlrZUwrUmdEME5NckI4N3dqODU3UGFEVkZFWjZX?=
 =?utf-8?B?Z3p0aVdobDhaT0tVd2RsUi80emVRaEgxTzlBeGMvZno0K240eHBlTnBDcVBZ?=
 =?utf-8?B?cjlha3BPQm5hbFN0d09tR09ZaE9sKzI2WnMyNG1TdWRZWWtxRzFhM2U0b2Vl?=
 =?utf-8?B?VnhDUGFkQTJhdHY5VEh3dTA3ZDNlemIxQ05icGNkWHBsQXg0bnVVM08rUktk?=
 =?utf-8?B?bGFKT29nYzU1a2tEUHJTZWVqVlVBakxLVWJ1R1FLdmp6OUVMUVkxMm5BeUEy?=
 =?utf-8?B?SzVacy9tdndtZjVsNHUvSXVoK3BJU0YwWjNTaFlCNC9pVHhqbGVwMXN5Y1RI?=
 =?utf-8?B?ai9RV0VOVFBnaU8rY2JDeVV2Z0Y0dmdpaGYyaVpydUFZaStFUXM0blpMTG13?=
 =?utf-8?B?WkpOVlBrMjIrMmM5NmdUOU05ZGJzR2hDaEFqK0haSkdmdUhLWHhUMWpKdnFz?=
 =?utf-8?B?dG9YZ3NRM1RndDJNYlhaLzBqRzJOcnp2MkpBbEdOK0k4dG5GVkhPTU91dUQv?=
 =?utf-8?B?UHZJcDg5S0R3UkVDQWoxTmlqZTEwbGtCSzB5UUtqVEthbWRvVnE0KzdBaTM1?=
 =?utf-8?Q?DIRYOrUM3v792yqmZbhF8LhDbiJ3YF/b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3c60fb-a8fe-4ca4-9a02-08d995515c7a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4011.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 11:44:52.7543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: maciej.szmigiero@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2508
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220065
X-Proofpoint-GUID: ZaFUDZyGGxiYqNce3lwkBkrfq1OsJrtj
X-Proofpoint-ORIG-GUID: ZaFUDZyGGxiYqNce3lwkBkrfq1OsJrtj
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.2021 03:00, Sean Christopherson wrote:
> Remove an unnecessary remote TLB flush in kvm_zap_gfn_range() now that
> said function holds mmu_lock for write for its entire duration.  The
> flush was added by the now-reverted commit to allow TDP MMU to flush while
> holding mmu_lock for read, as the transition from write=>read required
> dropping the lock and thus a pending flush needed to be serviced.
> 
> Fixes: 5a324c24b638 ("Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f82b192bba0b..e8b8a665e2e9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5700,9 +5700,6 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   						end - 1, true, flush);
>   			}
>   		}
> -		if (flush)
> -			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> -							   gfn_end - gfn_start);
>   	}
>   
>   	if (is_tdp_mmu_enabled(kvm)) {
> 

Unfortunately, it seems that a pending flush from __kvm_zap_rmaps()
can be reset back to false by the following line:
> flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start, gfn_end, flush);

kvm_tdp_mmu_zap_gfn_range() calls __kvm_tdp_mmu_zap_gfn_range with
"can_yield" set to true, which passes it to zap_gfn_range, which has
this code:
> if (can_yield &&
>     tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
>       flush = false;
>       continue;
> }

Thanks,
Maciej
