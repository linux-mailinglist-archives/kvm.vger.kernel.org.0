Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806A6449FD9
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241448AbhKIAol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:44:41 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48054 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241437AbhKIAoi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:44:38 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8NxaHD001213;
        Tue, 9 Nov 2021 00:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IqDWwD4ERdXRhqIZGKOkCfya4vPcQgsnjvdVggnZMg4=;
 b=PgygsWhuYWzYxD0GaYaRijHKSxfnX9wvtZabPhFRtYtQ/VCxccfdDgpgYsPbGexfQB5R
 9tt8pONmRvIHroTiVbIVepvLoMcCBNKXXBVrqSlEVyZIhBfDuaCQlY3hD8o4pKTidF7Z
 8jD6ErIBul3t5onKRgiweM2B+iRmcHst3kPC8GO1bgY1XToggID4Or5pF00R8/1fXkXx
 hSM9AIn1mJndE1e5Q8srxSPPM8rCJioTFZ1397u4mCszTjMagBxC0aDI/ZG89kEJX9yy
 PgAZyIM+0uO/5qbuejPODdhLLf9SCPGm38cZedCRXNdyE9x6q0m8nnYJTDlce599nX5G ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6uh4fp05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90ZwOl132460;
        Tue, 9 Nov 2021 00:41:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3030.oracle.com with ESMTP id 3c5frd6uum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCnBnvPYNTQI39UJwHBX1meqsQszDfpWhqZ6BPB+XCq+pEG+sTO4HQXyVIS9NFF5xWWg51k7acJEKwj6zhFsCisHIHutKhlLvWkg2Cu+Wy8CYxuGUzN5RJ5wmPWyyjmpkH/9R8YCu4HYvbmUgPy2dr9bXLjMtI7p1LnBUYIlPTGMRpUScNPO6IsJTYT//G9QtXHH9YUy0S5AnY4PJAxN+QFt2YHxCGadsx8dmhJiJorZWt0gmkp+K4us4Uroe3x5PaLfh6uxaO6H5Obk62tHcQo8EozUZcaSFP71qJtZHvi3OnqzpdjiGpuf0od8NmtgcLK4N9YoX/YXzAUh0Iml6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqDWwD4ERdXRhqIZGKOkCfya4vPcQgsnjvdVggnZMg4=;
 b=T5lzsLeMdjJ69U+6FqBwwUIOhLwrGpPoSzYKRqlzyGGzae2h8vAhkX4iTKosO61rAg42mbCaYRMWhzjsTvTOMtt8BBwor9vdn53FWvpKnDJ7ItZF28NiJU/i9fbbNr8a7A6mlqtHAp8HeK6F3c02axvWdAlw2ucUZx+1Dbn+RsLBV01O+0OuwXP67E8znySVvk3UssdBZJTWbXyoe73968aw6A2IwzuQtwrfMRCnfq5JeNnaUsbbaVNJ+oJR5pS4JpeMXm9RxpLTDLl2Ny0yIccrRh1CBhmujzwadVJH8dZ1Cfsk+6p/EEYHiluFbt1nCfn4FmCKT7klhYmX7gqw+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqDWwD4ERdXRhqIZGKOkCfya4vPcQgsnjvdVggnZMg4=;
 b=sfSQajdLdia6yGQIvOLICKkp5y+BsFm8/Qe/IfYusuruA9TSaozWh0NqB0TIe7jQhI7ZSlMjX7/hejua3wLIbXRMn3ozRx4d1IpgzRF5LkYIKDuS5Wt1YQAbPpXSRycrkWGwr7K5/GITtxl9YaLHU+W4M6/a3QkphWB4Lzz0ufo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:41:20 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:41:20 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 18/30] KVM: Don't make a full copy of the old memslot
 in __kvm_set_memory_region()
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
 <20211104002531.1176691-19-seanjc@google.com>
Message-ID: <829b0c0b-7735-51d7-3728-b8fd1d54e92d@oracle.com>
Date:   Tue, 9 Nov 2021 01:41:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-19-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0017.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::29) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM6PR08CA0017.eurprd08.prod.outlook.com (2603:10a6:20b:b2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 00:41:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f1e54b4-f8f5-4c8c-4595-08d9a319a5bc
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5273A7E2532A044DAA3FE4DEFF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTSc/vt2TS/erz5RQ9QTcO57S9xN4Z2fQ/6f/yDFJk5QO/RJX2/+IpFo1+oOB+y0B8rKt/NTD1Pt+lxAW1u8O3JOL1DooXekB0fsrmxYQt0/1FJRr6u0ZJTYkLu00YGBiP1037Np07B8bSDqyEYasJEpmxKZBUBPTbGEhfhANd665kkUGluM56MtVsaSgMF7BHXBVCGAArQKXFEAWzRfclfTttaIR/EledBflTgPSlaGR5lpyC4Zd/JeqDwWsA0ZUb+beT+OSbBYBWAjYf0SFYfRCZJueXN5yCj2ATySw0ZD0P3KC5EHvfB9TAeqevOYl2VH+tui334SBRrd0Gzc5T8eXHBWgUyhObHzASIuzai5CvUdiSItQqfFo7r7GNG/ugSqapHVq7F69K9isO97DED5uCesf1fzo3D90EmlyzgD7ScnKnYodAkAGkJrEjdavTsEhQZ4+u29JZ1e1Ml1jiHp4P9YufiytOihCJuaAsUsuzcM9X730XY5pOHKdugEybERml3u+R2rxHKwfLdvaET+uzML8UU+aRsgCAsee6iekDE0AaBImoEOm31wzcFE1+0H23OinytPSHkYEjPAwYjNrb22YOJk09SqDprPGBwXYfa99wdUhVTjEOz8l2ZMW9QyyE7DKUcul4cSJJ2qt5xdg49yD4PJMnZQSe5CzJXIY/f2h2nKH3jJ/M0W2IhFosaYlUlvjKdBMduk0ekBgSy5Sd2My/X6ybNMUjpBqMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(4744005)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjNralRtVFRLc2pQSVJaMEFaaDJxb3FKbjBPV3lTWTVla3RJb3VzeFg3Tm1W?=
 =?utf-8?B?Mkl0OTJwM3Rqa2N3dkxpeGp3ZWRzRkViTlh1Q3A2ZFZsTlBaZElxcDhBQjlp?=
 =?utf-8?B?MVZza1hDcHprcVBTaVVRNk04b2tyNEk0Zis0RGhIbW9ycWtVZFlyM0dKS2kw?=
 =?utf-8?B?YXFQMDdqa3pEbjh6WnBScStJb2NESFFZVkJidFdMMy8raG5JYTVyU01PNXlF?=
 =?utf-8?B?cTh1dFFVM2VzMFJ0TUhLbiszOGJUYUNlN1ZrQkVuOVVDM0lDY2FkSjQvOUEr?=
 =?utf-8?B?UlEwaGFQOTYwYzFFMWZCNTQ1S0llekVFRlp1TDFTUHFqMTE5Ny91U0J4TVl2?=
 =?utf-8?B?azZ5c3lNcmpFWktGMjFlcURGRG1GUFY5OWhpZ3AvRWpIM1dVQUZhcWJyVElW?=
 =?utf-8?B?aWdOczlzcmlnRkhJNXlsazhPSFhjR2h0WjFHeC9rRTVKWm5FckpEVUI1dlNB?=
 =?utf-8?B?L2Zkams2K3BuRHdBTWJ3eFYvREZSeGJRNXdkRlZzRk1kWnAzelhKbmsweERB?=
 =?utf-8?B?QjVwbTk1cEVnQm1XRkpwaGtaN3Rrd2w4cTZVWFN6a0tqSVZGS3d5Q3lEN2RS?=
 =?utf-8?B?MldQckdxZlljemJIQkhVNUhHSlR4aTFjNlQ5TkRxMjVtNzFhQ2FxMUlBU2ZK?=
 =?utf-8?B?OTFiK2l6NGhpVzJyZE5ESlFpYXZ6VTMrUG54THUyMjBxcEoraDZpRWQzek9n?=
 =?utf-8?B?YnpPR1g1MWNjekpwNFVqM1hWOU11VHBXWEhsRzhDNVNpQ0Y5RDB1WWFYQXNI?=
 =?utf-8?B?dEdnK2JvMGpqVWU2LzVDQmlhN1FmSldtWXlBWE40Q3A0T1dsZkFyWkd0WXdH?=
 =?utf-8?B?SDgvcHlaYjVPczF2ZmFSdndpZzFFTmxvQ01uVkF1UU5hYURJYlJzSkcvOE5r?=
 =?utf-8?B?YllMcE5PZUt6Y0NIL2dsY0MxU2V0SVJCcDVxY3JWcmlaaFV2aC9LWXE5UUph?=
 =?utf-8?B?aUh1bGJjYURmTkdxZjZJL1UzY3o1T0NkZHZMQmQxdkJUQjVkRlJqRnJZZVVY?=
 =?utf-8?B?TDFqSkwyMFZXNkJkdzRuRzNzVGFhWU1XRk9jdjVDUTFMMTY1V0hHODFWLzdT?=
 =?utf-8?B?NS9kaWt2M3FqZzdBbWpWNkUyVVdqQ0w4aDNkSTQ2Q1R6THVjMTJRcE1YUXh2?=
 =?utf-8?B?NTk5VDFtd0FtY0EvMnRURk9rZXIyQjVHL0Zxbk9DczFNV1FkTmxnZml4QXIy?=
 =?utf-8?B?bGhGS2ZuOFZqVzFUWGM0L0cvUEtlTnhOMVp1ZGw3eTgzTW83by9qcXlXNU9K?=
 =?utf-8?B?WTY4N2VRS3VuSmY0RWROajJmSEgralpjVzArNkNubkJCYXRsMStRMmgvaWF4?=
 =?utf-8?B?TFl2Q0NybjFRMkVVU20xZ25tL0RmQ21WNmwrUDNtdWRnalRMTlQ3Wko5NHMz?=
 =?utf-8?B?eElFTDE1VlNMaGNmMGNwTllOb1ZVbVFMeWtFUldLMWt6aEdhS0paOVFCUFlm?=
 =?utf-8?B?M21wYWxHVVZsalVjRXVLN0hDdkltb3lhVEhKTEdTK1NqQmVJd0p4NmFkU01p?=
 =?utf-8?B?TnpHOExVdDRMa2FEb0pITzM1bWNVUGltV1J4M25rUDNTMzgxSGhxNExndHdr?=
 =?utf-8?B?bURybDZOR2tNVlJqUFg2MHVjU0lHNzlhTXEyTEd1RnRsNDY0VGE2UXZvSFFE?=
 =?utf-8?B?ekduZ0k4eDVOK3ZZTXB3cDdDbmhUNFZsV2J3WEdITDNmT0tHcEJUdEdtamJK?=
 =?utf-8?B?b0E5WllOMU5LTXV1ekZiRldtUk5aSURFaFJjRUNvSHhtQzFSMnNQQnVyazVD?=
 =?utf-8?B?b1FCZHdLV2NhOFh4Ty9TdGZma244QXJIcGRSOVVENEpRS1YzeDdwdE5TclFY?=
 =?utf-8?B?RnFGaDE1RzJYNFJkQmh3RVRwWCtKa3FteDY1cS9RQzU4eS83ZjU5a014SzFq?=
 =?utf-8?B?bEM3MnBrTUhvckRUMjdmQjZOcEo2Z3IvUzFBZWFPYXd6K0l6N082all0L2x5?=
 =?utf-8?B?RlhXZGRCeTMxckxWVUdnSldBNEs0TEtqTHVuK2Y0QzNhWGhGTll4RFUyckZI?=
 =?utf-8?B?Vis3QS9HdVZUNk1rbm9DazZhOVhnYktUQzFMMkVyMzJMOTl1OUIwbEZOSnRj?=
 =?utf-8?B?OEZpN0FCaGxJOXJ2b1FzenVkdXBCcnRkamtlZVd3eHk2M2xHQjBreFJuN3I0?=
 =?utf-8?B?OHMweHZIZ2dNMDJBWENacjVaQjc0K0lpZ3Z1cS8wN2t4NSt1SzFKZ0xiOXpa?=
 =?utf-8?B?Tkg5WjBMNHNOcEFpM00xMm5va1FnUFY3dHRGcEoybm8xOXdyMTZnUi9hYkF5?=
 =?utf-8?B?aTA5akZRRkJXNnQybzlWQ0lGSktBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1e54b4-f8f5-4c8c-4595-08d9a319a5bc
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:41:20.1134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OH0z5tW8WXp6lpEZmvg2i1KS06JJqQ76BXk9eB5AcdhB5WbrVD46MXP2HhAJNUVI+EHhvOKurys0uvadEy0A+oARD4UfK6unZoMkv9uoBrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: ZO8jcQR2OJ7P4eE-Ia0KSW3wilj6WBw8
X-Proofpoint-GUID: ZO8jcQR2OJ7P4eE-Ia0KSW3wilj6WBw8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Stop making a full copy of the old memslot in __kvm_set_memory_region()
> now that metadata updates are handled by kvm_set_memslot(), i.e. now that
> the old memslot's dirty bitmap doesn't need to be referenced after the
> memslot and its pointer is modified/invalidated by kvm_set_memslot().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
