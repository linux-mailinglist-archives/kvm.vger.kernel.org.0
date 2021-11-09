Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD185449FA8
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbhKIAlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:41:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4806 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234180AbhKIAlh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:41:37 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A907cUZ013263;
        Tue, 9 Nov 2021 00:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BEKzvpf7LVBeLRBAhu37FDSwwVj681JLuFBuIymW0ww=;
 b=msLZy/iJemykQnCYzkc39nHUh9rQvUe3Yf/W8D6U5X4HSRnZn+vTAb3QHc5lNag149YG
 I+fG46dDAKxo0+zJg/LkkyZ373b/sbaitoV2O7oTrADE8UKQYHi2bKTvUoihttuFesA/
 6FRs8py3JtDs3DJ99yeXket5mMIhUjlDIl4nx37K6fHp2T7W7MiUM8aiO3Z8H/CBz6Fm
 ClsezjIQH00RNYDybfNeMSTB+tBdxjtKItD6do3PrE+z+4N9QvN6K5gE3BotMfKZblbh
 GJBzOVF6xE/8uZK6AOW4rSVeR2yjsGIboF1G0zFRKLdWNtwCRbYskRKcVcfFY09bCcPO Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8qya8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90Zxvk132537;
        Tue, 9 Nov 2021 00:37:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 3c5frd6rsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:37:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvarrJYFpwozXNz575XZssWObWPbF54bDdi0sc1BruxIvRetD2C5T6VD5bj2ThNbd8DT+Y5DKcKWWz7wnnBkaC4PEvnTLzKesyyJoxToDA3XelrEw81U3YH7zGZXDkipseYOC8Oh0ue+Ry7d6bWXUF/eyORQTGJmoaP1nU5/qjC4SOYIUDwxMjlnBwiYy2aVlw0IR0RgLU4jA3rVus7Q974uFYSq7tOidrNBQWrs31kjO/G4mhRzL36QMxW/hN3kSezY4PcjVXfTFf+VD77R7ZlqH5Wss7xvXzF7ilUnu9Zr3bS2OifkOXmsGq26BjGqvC1WFEQOf4/qAe02p0foZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEKzvpf7LVBeLRBAhu37FDSwwVj681JLuFBuIymW0ww=;
 b=Evyp+Cwcqqvl9AoyYuTKlDMtNqfiQPFBeKkiGe9wWKKTv2iDl9mM0wpr7hPeyhyO+M3MF+T0H1sDYWKi5OA+wT85RHAXJOvcKtmb+mgjxbuujZUxGFzThcUEIJMn/q8R8lKYwZ+iQ7a2/7E3uBA/E6r/L0vmUdyxRQYmv075rsfScb2YxZWShFKKyCSa4tD88vT6REUj3abAx6h6RvM1senSlIu7dkJPyuP6Q4Rl2y6cJBzc+znmM6p7C1hls1CJ9Ar11znLKj04V55+3ysKYktm/vk0x0m/YFOIVBGbijiVOxXLxeESv/uilz3qoUJ2wUN7kdaBTXc39ql7glxiTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEKzvpf7LVBeLRBAhu37FDSwwVj681JLuFBuIymW0ww=;
 b=d7+dqix16zKR7selWvPhlF4ImcV+YEC58rPe5w/eJ7xLN6gk6vDCG5rGX4efRSa3yKjKlqakiVXeoI31LWZpi4mU0P2ixVj075EYrJGnLQxUS0gfGEpbQrhb6urYfL9TD+ly8kROgm/csjk92wdUengSV4MUzTcKXrrlxABhFSI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4972.namprd10.prod.outlook.com (2603:10b6:610:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 00:37:56 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:37:56 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-2-seanjc@google.com>
Message-ID: <6407c2d3-854b-edf6-9990-b54a5baedd0a@oracle.com>
Date:   Tue, 9 Nov 2021 01:37:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0274.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::20) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AS9PR06CA0274.eurprd06.prod.outlook.com (2603:10a6:20b:45a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 00:37:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a67fd2f-1042-4ab2-a50a-08d9a3192c6a
X-MS-TrafficTypeDiagnostic: CH0PR10MB4972:
X-Microsoft-Antispam-PRVS: <CH0PR10MB49725AFBE6A02517DE8E9203FF929@CH0PR10MB4972.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVFcpZMmakvwPMTAPAS28XOuTzvDmYL3K8vZ5BD1L2STDgtYcGVgNBbeNLNmeqcQB9x4khsRybqpLolvZIhuod/qKbQpXlOxaFPngxUhmtIiyZFQ1fj3X95y+e5Sv0jqzdQCJp9TwU69SRv7lIO3hyzjHzE+A4FrJ2BifdwDVzKBpWDFMcPN0vqSO/ZGP2n8tcKlLcpC30mEBCIXbe5o76CPCZYHTiKh7vtXlUWNCnFB0lt4fHfkCkTfgS0MChjFk16u16XLESFC7HNUXm75yfZH11xcXlxegsszyeNgcnTd/hyW2t9GqIJ8BTLKqIZsJvCO1Vj1OEFwurPUWFL3sy7nKwyzNBdICoaQqeVR0+tAIDDqzYt89EuiGdSmit1LXsSiz9RZSAbw08ZwrIN8ujdmbaWS/D9eKRgi4OzDt8JRoaXZ/nEAPF0FB3oQF6NPDd88vnC2kUJGb9hLGgJt5lKe5PS+9O81CdAUciYy+3lXWmh/4q5JQzVPbZUPEK1vo5CWGAuIQ87NblnnVq7LlfNr+l4gvFQmQhPnWy9Bcg0XXPTLdrHs7pPnGraci9Ewygo/1QAKh/3kLBNJF+neaHaLqgoNNk8nmytkoIoEMd5pLtTxhuJ94P5utLbQKQe6DdLdV+2x5pTVgQ9EZ69BxA4NpRpT1TpN7IU5Cec7Vrsn2aunluzJrDfz0gzvyEYdxZkbIiDdJFsF3jIHBme97JKsQLcTKZ/KNrX33LfdkDg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(86362001)(83380400001)(956004)(2616005)(6486002)(26005)(66476007)(8676002)(66946007)(54906003)(186003)(66556008)(36756003)(53546011)(38100700002)(16576012)(31696002)(508600001)(316002)(6916009)(8936002)(5660300002)(4326008)(7406005)(6666004)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlptTTZ2Umpld0lLNW5xdkJRSEdack54THZuZllkOWhUN3YwTlJBVVVheTNv?=
 =?utf-8?B?SW5BRUt1dUdOS3J3N2pWV2lFaktlSFhsT0M0V3U0bFNkY3NqdXZyNHdzT0pD?=
 =?utf-8?B?K3I3STU5ZURFSno0ZUdVT0hBS0owQ3g5b3pYV0htcUVRS3NFTUZ0TjIrSkgv?=
 =?utf-8?B?S3lkc25iZFVOaXhPYWpLeGhkTEJSbU40RzU2V0tXY05scVhxc3R0LzNvMEZW?=
 =?utf-8?B?NlYvci95NWozWkdRbitHcDZqbEwzZ2EyTGZuenlKem9Vc3RrU0U2QlVTVW1E?=
 =?utf-8?B?SFoyaHhIZnJ4V25LV3o4Tm9KclFpYkdrdEJtNFJoc0lZaXgycHJRVGcrTXVF?=
 =?utf-8?B?djRGRnpvbHZVL29ab3FmS2pkd0NpMGRiWUtPMElpcmdqTXlGSC9qQ080U2kr?=
 =?utf-8?B?TUZWSEhNY3paTVFBa0JqRFpwRXR1c2doT05BN1hERXYySEExOWdBQ1VReVRs?=
 =?utf-8?B?Skd0WlBWMDNteUt4UkNnMEpLQ1dUR3dPYlJTT3pBZVFEZXpDRXVhRTI2VjA5?=
 =?utf-8?B?MmwyS3BXN3hHb2ZjSDhEM0RMak9ndjZYMUwyYlNHNG11Nm5Oci9seTZFNW8y?=
 =?utf-8?B?TEtxMXVIbWtHVmFaTlZvZkMzbFgycDAwSmpsVmZNamdUOWErTzdRSisxb0NH?=
 =?utf-8?B?ZUx5eUtabUc5bjNOT0pFbUFFZCs2OGt1bFRZMXhoR0lHSXVuQUVHSkppeDUr?=
 =?utf-8?B?bzhhWEhSaStaNUVVZ1pGRFdabmhOaGFuZktWZDU5MDJsc2V2YWsvd08yRzla?=
 =?utf-8?B?NU1NZ0lJUWZjd1B4a0dSQ0haNzlsRVZZTzNKaDU0YURUTXc0MG8xclpiNGZM?=
 =?utf-8?B?RmhPdDFPaTFBZ3cxaytZSU9BMm41ZmxUTGVhaXQ4LzFFRUlEUUxKb3hHWGxK?=
 =?utf-8?B?WmI1WDFScVE0MG1Hd0x1cmpQNEkrY2FheWsrYzZUU3ZuS0U5NHpsSWVZMXlV?=
 =?utf-8?B?N0FwMmZpYWVQSFBmMXlPUzV6eW05WTBvZCtJcyttcFQyRU9rRHdna1Vkdm43?=
 =?utf-8?B?Nk9EdEVGbG80Q2kyZm1GdTRrNHNJLzVoQkxreWFaZXZXYXFQVjNTeTlhaXVa?=
 =?utf-8?B?RWRNZk1IK1J0Y05sanlzQWFpUDQyR1dqQmVQL2JMek5VaDVPSG1OdHBORlJG?=
 =?utf-8?B?VTJmblFwaUFySzRHeXJDL0pBZlk0S09FL2RSeWRzNGtJK2EzVUNwVXRqN0RX?=
 =?utf-8?B?RFZid2dkTVNzcWZIWmRZSzczdlZYYytKQ3ZxOWtDa3lHQlVmc3J5Z3h3d0Rk?=
 =?utf-8?B?MDlYNFdtVEhtRW1LNlpLc3I0YkNpU1RNSTRCUzBzVWt0dTZHTlJ5cVhYNG1X?=
 =?utf-8?B?S3JOWGNhdUZ5NnkzZmFDTTlOODM2OGtJSzQ4bnhlRFF1RVN5djhOTzByQ25C?=
 =?utf-8?B?dlUvbGZkSnpuYkpIWnY1K0pNLzBLeG1sRGdEc0lyYUF0V3k5eXJ0VTNKbjVK?=
 =?utf-8?B?bjVrWWxpSG1oejg3MnpvRlNpV0t0WDV6ekZLcHBvTjhYQVhuYTBRQXo1bHdU?=
 =?utf-8?B?dXM4MjhGR2M2TnNSQnBCeCtIQ0hSNEZlV0FiTjM1cjlEbGUyWDBFRi9RU2JO?=
 =?utf-8?B?L0tGbGt1Y1Fia3ZuaUlFRWZSdjYzb3MyUnhXQ3F2bWM5Z01WazJFMkFTOXMv?=
 =?utf-8?B?RVNhS2R4bytFZkljV0kvWjdSV1BFN2JXRmlXb0ZzMGo3Z0cyZ3V6NHZBRVR2?=
 =?utf-8?B?WFZYbmxrRE0xSGVxL0J2SDBWSTE4NC9TOFJvcWlaMlI5L21ZaVYwVWRHMnhs?=
 =?utf-8?B?UWtYazJJZmgyUDRDRzVzNzkxT2pxUGg3WmVJQUs5NXlxSEc4bDVGVjF0T1VP?=
 =?utf-8?B?NTMzVVEvdDNkVDB1bkR0eUJYaERvWUdBTUU2Yk5XdFZUTkNBMDQxMjIrUnJ5?=
 =?utf-8?B?a0hJQUVsVnh4d1ZwY0h4WHJaVWhUTWg2UlNWUnJQRkhoTkpiNjhRUk5KOVFL?=
 =?utf-8?B?REFFOGpEMWlWNUFhOWFrdzFQa1hvMmI1WXpXUTVqMndMdEFUajBCOUxOaDRm?=
 =?utf-8?B?SHlGTkp0bFpaTkNTMmExYkl5Sk9xSVJibmFCOXlXVkhOUkc5NnNvak1iNURB?=
 =?utf-8?B?cXRsdzV0NHBMZ1VmTVJvcUNpb2hVYUk1d0NPL1FCU3Z3SE1ocmZ5QjJsUldQ?=
 =?utf-8?B?MVJHa3FTR2dJa1UxeW81cWFHZG41VkFvVkNUV0dNZEo2ajhvdnV3QVhmYTRW?=
 =?utf-8?B?c3RqNy9PY3dIanBXTzM5UEZjM3ZESEFzMVZnZzh2NHQwYmdtczhYcHBRUGJz?=
 =?utf-8?B?aTFVNWQzc21NSldjK0hDVS9KL2FBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a67fd2f-1042-4ab2-a50a-08d9a3192c6a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:37:56.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8Sgq2D4wB4OLEiSjxHj3cGYAOaePMQA4hTgkaaKU49jgDrYhsbE9h2ptg/XaHlNVSXigd1hsvvVp5EnQYceKIGJuyYZnZ7No0U2JigijJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4972
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: Xz8M8vPiB_eV3KtkHDt6Yc-FAqcv5_mA
X-Proofpoint-GUID: Xz8M8vPiB_eV3KtkHDt6Yc-FAqcv5_mA
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> When modifying memslots, snapshot the "old" memslot and copy it to the
> "new" memslot's arch data after (re)acquiring slots_arch_lock.  x86 can
> change a memslot's arch data while memslot updates are in-progress so
> long as it holds slots_arch_lock, thus snapshotting a memslot without
> holding the lock can result in the consumption of stale data.
> 
> Fixes: b10a038e84d1 ("KVM: mmu: Add slots_arch_lock for memslot arch fields")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 47 ++++++++++++++++++++++++++++++---------------
>   1 file changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..99e69375c4c9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1531,11 +1531,10 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>   
>   static int kvm_set_memslot(struct kvm *kvm,
>   			   const struct kvm_userspace_memory_region *mem,
> -			   struct kvm_memory_slot *old,
>   			   struct kvm_memory_slot *new, int as_id,
>   			   enum kvm_mr_change change)
>   {
> -	struct kvm_memory_slot *slot;
> +	struct kvm_memory_slot *slot, old;
>   	struct kvm_memslots *slots;
>   	int r;
>   
> @@ -1566,7 +1565,7 @@ static int kvm_set_memslot(struct kvm *kvm,
>   		 * Note, the INVALID flag needs to be in the appropriate entry
>   		 * in the freshly allocated memslots, not in @old or @new.
>   		 */
> -		slot = id_to_memslot(slots, old->id);
> +		slot = id_to_memslot(slots, new->id);
>   		slot->flags |= KVM_MEMSLOT_INVALID;
>   
>   		/*
> @@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
>   		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
>   	}
>   
> +	/*
> +	 * Make a full copy of the old memslot, the pointer will become stale
> +	 * when the memslots are re-sorted by update_memslots(), and the old
> +	 * memslot needs to be referenced after calling update_memslots(), e.g.
> +	 * to free its resources and for arch specific behavior.  This needs to
> +	 * happen *after* (re)acquiring slots_arch_lock.
> +	 */
> +	slot = id_to_memslot(slots, new->id);
> +	if (slot) {
> +		old = *slot;
> +	} else {
> +		WARN_ON_ONCE(change != KVM_MR_CREATE);
> +		memset(&old, 0, sizeof(old));
> +		old.id = new->id;
> +		old.as_id = as_id;
> +	}
> +
> +	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
> +	memcpy(&new->arch, &old.arch, sizeof(old.arch));

Had "new" been zero-initialized completely in __kvm_set_memory_region()
for safety (so it does not contain stack garbage - I don't mean just the
new.arch field in the "if (!old.npages)" branch in that function but the
whole struct) this line would be needed only in the "if (slot)" branch
above (as Ben said).

Also, when patch 7 from this series removes this memcpy(),
kvm_arch_prepare_memory_region() does indeed receive this field
uninitialized - I know only x86 and ppcHV care
and kvm_alloc_memslot_metadata() or kvmppc_core_prepare_memory_region_hv()
then overwrites it unconditionally but it feels a bit wrong.

I am almost certain that compiler would figure out to only actually
zero the fields that wouldn't be overwritten immediately anyway.

But on the other hand, this patch is only a fix for code that's going
to be replaced anyway so perfection here probably isn't that important.

Thanks,
Maciej
