Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD244DEBA
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhKKX4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:56:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28302 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234468AbhKKX4i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 18:56:38 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNC61W024095;
        Thu, 11 Nov 2021 23:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OL/eYwUuUt9gMNHkWaTiT/T9ya06OK99BT6vpYXaw5U=;
 b=IoxBGimnPSMqhnmZxQMgw3bySsO/HGLv1qhppCdmhUyqMTWyOAX8QpJYKRzBX4KbAs2X
 mfahU+kibYpJ4m8y+JrAJwnrJPRF4GlsJs40ugZbdQ2azWKXfUlzGji3Q8JGcSaUWaMD
 i/0xCh2t/g2Aqm9Jw3Bmv1J6S6SYIsVjDHxij7hN0lIOqPrj66g5oBxzzrSNIjiL/ASK
 WM40W0vaKFc9sTAGMBRprQ9XXSmfXk0nPa8s5PpRpIyhCuZTuRLIvWH5vI3sloAmE/yM
 6kSYfba+MdGu/RYs1eE6jSbX3RTphw775S1zYNppKIlM8JBlg/YOs+BtklOrHItaCclB lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c85nsmyd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:53:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNpkQZ138754;
        Thu, 11 Nov 2021 23:53:00 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by userp3030.oracle.com with ESMTP id 3c842ecqrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:52:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEYcINTUkBGddIvWd9nOGSSVUlkA9M8GKpK+EO9cWBIlxDTB8b0Y7MMKEKG2Q2CVzfKjYn0sPL0VJIfJxTJMDEGYFRgwsyfnUwX2bLMk/lu7XRDn17paRJuW0KB7GadUDyP4MUx4e4Kpw3/H6wACOURhy+/qg4e+0FgY9pk760sFbd0RFfX2TIBg14EbAZGoMKV1S04pg5MBXgq/i3zJK2eBeQyRwmSZIHE43UEsVSdrqF8x7c1CpoDsnzivSt7Xxq+WCY8b+6F0ElwSFjin18GTaOnr3IRyxvSSmlzu333FJBypqrMtH0rA4G2K/mscwYZhrVV8/zcv5JhVGwDa5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OL/eYwUuUt9gMNHkWaTiT/T9ya06OK99BT6vpYXaw5U=;
 b=a70C32OLwNZkuHG+oE5w+8uC4iVU966GwU0W/7HTw1mSzWLoE27PrKMeJCd+5xhl1c2hwfGqZ+bhwc2VKH4a461UtctMMvz+rNOS/3wncc+WbSS/pi1sbcVw7zmOrwmTKeKkn6Gng944NgIex1Rcy4rA08aHWZOyGo7+1X1MO3VKwbFNf6+cWD3x59Z2YefQd2pr0HANrT+yyQvUFhjCO8jUxR646D+IcijTX0daWgdKxz75PXbJLe48s2IXbr7lz404VYSJ2S3ug73MgYp21ZfkgdY+9c+voyYBbc2fgFMXoU7c69CMNrvihQ/+Q6CNplcE63je2WECcCW3UsPsfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OL/eYwUuUt9gMNHkWaTiT/T9ya06OK99BT6vpYXaw5U=;
 b=F9hE6DBticnAl7fKQfXBnpg4O/n5twZRelKEMawg+3B5W3ubtFJiJ2uyWghb21hWAhKQicE9quPrSdGz5oIEaXrdOwwXZNNXGAyD+6D/ALRfnQgZkrlrmjRl5Ca9auDoFii6TjmgayC+KZuwiOZoL3FMzJ6H0ALV8ueNxumTTrU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 23:52:57 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 23:52:57 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 29/30] KVM: Wait 'til the bitter end to initialize
 the "new" memslot
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
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-30-seanjc@google.com>
Message-ID: <676299e2-a59b-2af0-7e6a-b2b47b7765e0@oracle.com>
Date:   Fri, 12 Nov 2021 00:52:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-30-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0048.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::12) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.219.146) by AS9PR06CA0048.eurprd06.prod.outlook.com (2603:10a6:20b:463::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Thu, 11 Nov 2021 23:52:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6890edbc-7c16-4957-10f3-08d9a56e62f0
X-MS-TrafficTypeDiagnostic: CH0PR10MB4938:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4938B293F81E0FB8D7D0D497FF949@CH0PR10MB4938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqQlBN8DzSf7ifKhwBp2XktBag2Onsc0Hs1ot9XPlnXrTFwT4MY/f+RcbUigGPDfJs06GOmkEplop/T1B4/ad4DiA+5UpubZ171A7UU7ylV2XuyFXZrbEHtYKiqySoHe2/kWgm4uiBh44HuzFDwGHCVLMpWHxj3L/R4bSO8R96UnV54tw1bvTZ0CcU655q53oGUQ3VW0V3wt7aEVMJy4w7OhryphFjz3M9WvvaXMPINOt5W72eOB+BvIhhC+P17mnKiLVrYepGUKybFco53ftvGCmsuOU/OEjopGUtQvllOZaHVQgBI3jSp0MITcyQBXRZ+65vPO/tY5U2Y+EmnchVKwjiBX/TZWv9OQBsH0H9BRxy69v24hnrHyyWzmDHCmaFttT7Gj4N5A6Bs7gmJCK84WEaUWAVuI7CK12HjJqZkBo3xhZRkKQJ9uOdTErg2ZMetCqayA++BxdYDluQvKGsDyjiDAegcbwle269aaWMaqGOU73/BP2Rm4GRSOkLXz4jgPKu+VI+a34aSl6bMMfVk3XYj9/RBL0p1oL4mebwWp4OsftV3GpH2LJXBzYF18OmecN6IKjZQdM9pmnwnADLBBb6h0LtV8QPtaooUCuhL2NtJkZ2XQrhjAsKaBPbE9hO0C2l5+YZiof5llA1gxzlWGAaBJBJwn56EA5DAbHqXXMHYIIi/OxLrF6gmKWJZeAic7bCjPYGekOb9UZVOUnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(86362001)(36756003)(8676002)(6666004)(16576012)(4744005)(5660300002)(2906002)(316002)(38100700002)(956004)(83380400001)(6486002)(508600001)(7406005)(4326008)(31686004)(26005)(2616005)(8936002)(6916009)(186003)(31696002)(54906003)(66476007)(66556008)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG5NQnZYSmNiZVZmYyszUWJ3cVZDTlZvV2FXQjNHdzdLMkRIZjBrWWkxSzNI?=
 =?utf-8?B?d1J4TFgrSWZaeThtK3dSc1lpalpSaTBKSmtLMGZ6OHdvSkp3QXh2bkMvZG5a?=
 =?utf-8?B?RjhzVjFEVDR5RmxpaWs0Z3paeXg2R3d1UTdXVU5pcnpDM0FiRGpaQWdiR2U3?=
 =?utf-8?B?WnpEbkJYVGY1QjFyT1dXWlIrM1JqcU9ZNHo5OXNvV0NEcGRQNERJcjRCT0kr?=
 =?utf-8?B?dm5CajZ5SVlpWlU1WkpONTk4Smkxd0grYU5jZHcwOTJab1FoQlNDRFRvSkVB?=
 =?utf-8?B?NmFhWm9MS3llVnFWRlZZWXlBcDh5OFBJalBjOWp6eEdFS0JqZ1pDQlNSRTRn?=
 =?utf-8?B?VHl5K0k5MFZJOG1OdmMrZ2dGRmZacWVPUDkwK2lZUWFHUWo0NGZDbGVRVGM3?=
 =?utf-8?B?b0RmSXphUnZaM3NZK1c1UjcwNFIwVlRvdkdRZDZTc1BFUDQzUlR2YTU1R0xV?=
 =?utf-8?B?WEdJY0JyaVNROTdxQ204MlMxcUJ0NEhuTHJjUzhSVVNRcGVNWURrSnNvWVox?=
 =?utf-8?B?NjRMeis1YUR6aElxekNZSWtZWkltRFYzYjlPbk5IZE1vRk1lYmtrdkVmN3Y0?=
 =?utf-8?B?MXgvNitMeHdTOTB3Mm5lQzdsZ0RyZkowN3g4bkZzM2YrK1FqUEpTMS8zUUhI?=
 =?utf-8?B?NWYydllLVHVnOWx2VzFMdko5SGg5VGVNR2hvTExMT3U1bFUxcG5CVG8wbXNH?=
 =?utf-8?B?c2NVdUxMZHQ3L1ByRmRqb0xuRVhWNHpvSzR1cDU3dEVLY0tuNnRpY0owdzI1?=
 =?utf-8?B?WGVkTlorS2gvNEdjVExYUzRTL21SYU5qdXM4NEpEZnB2Kzc0TzI5SmNPUldp?=
 =?utf-8?B?ckxiTzF6d3VRd0VmeXRKWmhiWlB4dWVWV0gzdTVEWW1zYS9LaitsSGM5TEk2?=
 =?utf-8?B?WjEyRXRMai91eElES2tQVXZZcWlFeW1GWGZ5Mml1L1ExSUhGeFZjczdJMENh?=
 =?utf-8?B?bkZrNjJ1b2J1UURTbjlMNHdVajJXQlF6Y2FkMzljMFFneFlPWWNrUzlTR0NP?=
 =?utf-8?B?aFBLQUIxZjNLcUV1aXBFSzg3Yk43ZTJ4TTcwUlJpS2VyRk9uV0luWElVOW01?=
 =?utf-8?B?dlF0b3dvL202ZTBNcVFaOEVUYWlBaUE1TExCVngrVW80R3ZrdVVySDVQOG54?=
 =?utf-8?B?ZWUxaG1oRHhvM3BWckliMitKekpOZlY1Z3U2MldoVnd0c2k1MFdBcGlvRVNL?=
 =?utf-8?B?ald0aDBNVGRNRUpDdmRuQkZ3YlNyN3N4YW9ERnJYNDJMRWh1NkNpQXV1czFH?=
 =?utf-8?B?aHJBQVFtSzl5N01MdjYwU3Rqc0l3MEo0MmZNUUp1ZmFnRWR1S3V0SjFjTUU2?=
 =?utf-8?B?T0V2eDJ1U0VOaUlzSmkvdmc2SE9tbklFNUtkVStqbXlSZHRFRG1wSisyMWRs?=
 =?utf-8?B?YTh2QlJkL2ZYNXFteGREZlBzWkZYMXh0UE53WTBncmFLdEZONW1xMEIwMlB4?=
 =?utf-8?B?RzFyRy9PSW1RK1BBTHFGNjVpakw3UzNPR1dnMUxNREtUaEFYZGpVMytEMklO?=
 =?utf-8?B?ZzJnUUVJWm5PdWl3SGh4N2hNNnMzMkg3T2FZQXNIcVNWb2FCWUc4OE9BdGhK?=
 =?utf-8?B?ZVd4eVlleG5nNXNBLzBDOVB6Sk1VaUxOc2NzT3VRQ01Hb0FrMWZYRXhmaXhT?=
 =?utf-8?B?VVl0VTc0QVNUOXNFSG9XUmNrSks5SmUwKzdTZ3Q5STBQNWJ6anlBdWtXblNv?=
 =?utf-8?B?SGNwcytxWWtKSGFYMTQ5aVFIUFU1emYwbjVveEUrL0lOUTZHT0cvNXg3bkZY?=
 =?utf-8?B?WDB4bXNhWStXdlRlQW5UM1ppT0xGZmd2dlEvVkQzd2V4SVgyZXlCcmZyaCtM?=
 =?utf-8?B?QXpXV3UyeUsyWkFLUWwxcXhDYXlCY2JFcm4zdEtUZnc4RkRCblBVSmdEYUli?=
 =?utf-8?B?eHFHSlYxLzhSbDE4UndoUGJIeEc0b2YvNkpJSzZkWjkwQlRRUVBubzd5UFFF?=
 =?utf-8?B?ZjNiT2s3NXUyblgzM2dJSHpOWjN2SjV4UlphbUtkbjJhZTRXN0Q3QjBuRVNv?=
 =?utf-8?B?WDZTU2kvTndPV1lRNkRnaGl0TnBFbzk2MUlscHVjUnJUdE9QbG5WaHl0OER6?=
 =?utf-8?B?TGNOM29VbmJGbjZXM1VLdzFpY1V2bDNCd1BOR2RNUG1KNCtFVmJqSXd4VnBS?=
 =?utf-8?B?Q2NlU1RBaHJaOE0wK2FQd0J2NTY5WllJWWdQRVllVUVUbEpXZElpVU5NN01o?=
 =?utf-8?B?V2RUZ0o3Q3hxL3lWd3RGZmUxemJnVmRwWmIyU3ZQYnl0QXBaM1I4MVlkRHVu?=
 =?utf-8?B?NVJQdWw1YVBNcG9Qck1WM05LdlV3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6890edbc-7c16-4957-10f3-08d9a56e62f0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 23:52:57.7509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rk1TYQTRl3FXLJdXcj+YlwbLs2W4y3A5NSzDhetcjph5bv32uONNfOwMFVwWDMjZg5jFsuCPTVdTX0nrRTK2UzJO2jFcvCt1KphJB3wAxTk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110121
X-Proofpoint-GUID: zYyuHJp-p1-qKv2tSkrkBBgqDcllPmCx
X-Proofpoint-ORIG-GUID: zYyuHJp-p1-qKv2tSkrkBBgqDcllPmCx
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Initialize the "new" memslot in the !DELETE path only after the various
> sanity checks have passed.  This will allow a future commit to allocate
> @new dynamically without having to copy a memslot, and without having to
> deal with freeing @new in error paths and in the "nothing to change" path
> that's hiding in the sanity checks.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
