Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED82244B142
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhKIQdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:33:51 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19282 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236373AbhKIQdt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:33:49 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9GK8B8023916;
        Tue, 9 Nov 2021 16:30:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vyRSr5Fy3KBRnDB8PTePUrk9C+LIMxVJrvnbvzAwvMo=;
 b=nTNY1VuthFCBOzX+lZCOG8J7rlJvuvl+lau+Yx0LeQ5GWWRi0/BtJ7Lh10xslmb5F6Ra
 kY4caMrHPEReqIUzNyd1oEvsxV4a5L98hNhS9cfRt6bALPtrnlf9CF9/8Ft5XdLs6QPC
 UZT0ao/rMIWRzVru6XIAOMPa/cw0uZzk3N/eomoqz1M/qqkHh8agNPfiX8QXQ+UZsftf
 UGD/szgNc1pRP9BxH9o0E2PXuyB8timN1V3P4lhIn3mBdAF5/W6q9KirpZKcRjlYdfUI
 RsFARi1H1eRzc9LdN5xxq2Ufw+Krgb1DroEEZhlCtZS0RLvhSos3k1FbiL7IBjSL4OFn bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6t70b859-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 16:30:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9GMHVQ069309;
        Tue, 9 Nov 2021 16:30:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3020.oracle.com with ESMTP id 3c5hh3vm9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 16:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwbD4OT/KudcNFQfRef/debWAbqMCwpgzx6jDpcQTPsRtfTJeK5XnZg/iAIKg+L67llUlauGddea4bAmycwIgiFA1pGCoKX/Ot0DfFfyct4cGouDo8fU5zgeTgZ2EbPTa9uRL76ZTBSU5qLMGxfYWfWKcuP5xjmv3kDdrPQufm3xOwuFNO80HFRPEoiFTghEGRNMWR8T3KoRnfJsc26/99c5XEDMscmc9T8Y1t9WsbQdIMwYztqdcbiqGUPaYZKm/x3PCj06x1uCZ2JSuTWGo+UJci793dOSMLmbBsuaKpco+Ra9dqhR5oMYE+WLmj3m2BUaSyuM+G9qWdnqhazckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyRSr5Fy3KBRnDB8PTePUrk9C+LIMxVJrvnbvzAwvMo=;
 b=NOiutxbjvfMqA36y01emOh1JpdRJBAVtIg0c1TZdA9wpoJey4cwem5tS1uB/e/GyEGq8/DMz3u6SVy3BQRrEcGhrTTDDgrs7ZROv3DohvbS1OxrtlbIATilgPGbrgSmfaQm1zS+C5yzJybzPGqgGBM0l7jy8t6GWQWwdtzCSkc4hquhOS1urEovA7ypSa2hgZMHASw1HVTRnPbYGbAGrjOT0xzoFLxMZXRs1d/6m5NP0zZ+wLZUW7yNhRl6R+qnnKiV5hU5eQSJI59fdTeJaHld5B9UHMzVzNZduA7mJOxIgEMtdZ+/LPICIZ5Pt/PhB2tgKJFSe5Dvr9B8KfWPlHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyRSr5Fy3KBRnDB8PTePUrk9C+LIMxVJrvnbvzAwvMo=;
 b=YG8ir8NB7jO6PIQCNA9XWJWe7fxE7tyhXRC6Ht9w9qZaquKDG2RgpHvfDm4e/PAOY7Cz3HnuhXJq92l3Onvo1FUtiIM9dep9EV8TmogEIp6WkDBa/qX/QYeHi2ifigNxvmpvVjpYEM3g7bHNW6fsjT00sQiy9+c4rTegUQv1Ty0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 16:29:56 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 16:29:56 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 20/30] KVM: x86: Use nr_memslot_pages to avoid
 traversing the memslots array
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-21-seanjc@google.com>
 <88d64cd0-4db1-34a8-96af-6661a55e971e@oracle.com>
 <YYnQIYdsb3wwg86j@google.com>
Message-ID: <cb2b3958-8d7c-9216-0751-c95ddbfee52e@oracle.com>
Date:   Tue, 9 Nov 2021 17:29:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YYnQIYdsb3wwg86j@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0013.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::26) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.175.144) by AM6P192CA0013.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 16:29:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9be4cac-09c5-4fcf-1000-08d9a39e2a40
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:
X-Microsoft-Antispam-PRVS: <CH0PR10MB53380F3D13319F01915FE1BEFF929@CH0PR10MB5338.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Ax5IuI0xPh2uA99R2akK8Dsa5rEeGjmkLI3UCbg56bt66dOKzzkYSiV7V15X2B5b7NJmALXc+wXvAiYPHRnwuuo+oBnMcsgl4UDmElXLDAUdGt1jeEFkhDRqo4mSRiVaNBxK0GAWfTj0QyONBgX3jQ5JYwKakamObxdMMbA/wsC6PYipgFY5J0M7bbmaXypgnaCJJ8Qoqi2e3iq6wjxutbuCawRV4N/F74bg44kXz8gCUuCKrNxVOp4K6aNrMGy8XdPxqr7Wf7O3ayYcad9GlmcilbWbh+mbg9+/1k8//LCnDqLYaCMeu6AU2QRZDmKQd+CdxvsEe48o+JHT8ZmRSOLRHPTOv8NYxKlM5pIh6ceekbE1dl5soojyYDuDoUpex4vGPU7cNeQQdrr42y3qS3wbtFhZuvsdtyFFKTfchmD/W3yxPgfN04ex1aa9u9p5hKo/C+jmzdKqR/thVEn0+A/AXlQjdJaUZq1J+2/xEBK6FaN20dgdoLxelHZ/P1vrpIBqzXohl2fQE/O393cLk2zUuvWxCv/m9ukESDL+frTWoCQY5RuGyLAu/BJNH76cj/EWqHymBydBdMKwiFs+lFTyCRaTRc3Xk8RlsJSmDQoZfJfEAhnP8gd8yScyLGad9VVnu3i90ImeLv1+gubwENtb2CD/6f6ojxjbg022WFCeRrWiKDIOgE/zD6G10+GPApNKboPecuS/McbvHA+CVB0qmMeGv6Xm735XcLsjXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(8676002)(53546011)(2616005)(6916009)(7406005)(508600001)(31696002)(2906002)(7416002)(66946007)(8936002)(4326008)(36756003)(66476007)(5660300002)(66556008)(86362001)(31686004)(316002)(38100700002)(6666004)(16576012)(186003)(26005)(54906003)(6486002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTY3MXZXTXBDSlp3Q1MyRG1vUVNCQmpZdmxINHJ5ZXN4TE4wOFVtdDgxRzlH?=
 =?utf-8?B?d0xKMSt4bWc5NkcwQmdNOTV4cHBubUNzc0JDemZHc2h4ZDkrM3pUbzhBZktG?=
 =?utf-8?B?WXBnVHE3WFA5MXljTFMxclpiTy90UFJWb2lydmo3SHRzTEJiQk83bWdKVTZu?=
 =?utf-8?B?enYzTmxxU0t1SXFQMGpacGo5YTlpMVNpeXdxZDhoLzYwUTdGWjA5M1JscW5X?=
 =?utf-8?B?SVlVU2lucTZBWjBiZ0cyeFBKeDEycDQrdHF4REFvV0x5eXh5T29jL1Eya0pP?=
 =?utf-8?B?dSt2dHE3aWhLcDZQb2d1M0ZmdjBYZSs4M2ozVUNuWHJ3L1BUNUtKaWtxMnJ0?=
 =?utf-8?B?b2t1dzdBVi85QUo5NTYyTmI3cGVoUzNURE9QTlBOL01HbnF5VzN1Qi80T3BD?=
 =?utf-8?B?WkpqQ0ora0ZidEs5VFh1Wm12MXJUcyswaHRRdnN5U2VaNFh6WFdqRlorSUhG?=
 =?utf-8?B?Y09Tc0dDMjc0Q00xQXoxQW1IcUc0UVdHVk9oWGlUbWhBUGYvUVFHNjFHbWUy?=
 =?utf-8?B?bUlXUW1BMGpDbmdsQzVYdEZmblp1aEFzUlVEWFh6cWQybUhGakxpVW94SmJt?=
 =?utf-8?B?Wlgrdm5TYVJDcFNaZmdXSVA3TEU5YitLbTNyVk5kT0hNR0lIL1dWMkRvajAr?=
 =?utf-8?B?OTYzOWZLdTRLL3dYeWRyM1pTY0NweitULzBYWWU4YkhjM0NSYUJoZDBvUGln?=
 =?utf-8?B?SytWbFplMkhtYzI1aERNaVVNZzVkOER0bFNxVEo5TTQ0L1owbnBtUVdFa2pv?=
 =?utf-8?B?blJTNGZ5M1czYW1QL0dDczBMRVZ6aWdDSnBCOUFFaHpzTlN6dUM0dEVpVFBX?=
 =?utf-8?B?d0JjUnZGNmM5ekcyb2ZvRUZLSk9ySXVqWG14SVBVYXZDdXl3dGN3bVBVVGov?=
 =?utf-8?B?bG9kVUNZV0NidmwrMzVhMDROZ2dBWHR0djNkRGdMTzd1a0gzVmZCNkNGcDlW?=
 =?utf-8?B?eXNIcnRRK25SMi9FRHNhTHNWVVlCcjA5MW91MngvZVJERmV3cTFhWVNwYjFn?=
 =?utf-8?B?Z0xYb0RHTXdnZUFzMzJUUG1RR2tFVElORExMeURpRVNWS2M1dnRZYUxPTkRp?=
 =?utf-8?B?RmR2NjNpMnduQkRVYlQ0VWEzTExCL1Z4NzIyMWVNa2VGQjhoR3RFMjVtbFhX?=
 =?utf-8?B?T2UwL3VMcXpOd0hSZFdoak5keFpEa3U1VU0xeXFmUWZ4U0N3K3ZkS0J4ZHZ2?=
 =?utf-8?B?Vk02WENoM3RFOHV5K0JWOEg3VEFlU1owRW5RR1FLTjdLM1JDenVxcHo4Qnk5?=
 =?utf-8?B?eTQ3KzNjWFFsWlp6TWNFYnczeVhSUkIrSTAydFlzQWVzMDB0QXd2a0RLQ0NQ?=
 =?utf-8?B?MFRNMVBoNTg5OFhlMUIyM3NmM2JrdHhvajd3d0NUVjlhKzFMdHBWeklhZEdY?=
 =?utf-8?B?MS9BdFdMSjlpZ2MrUGlnK1djb2RReEZNbzM2K0dmSEU5Wkh3SjJ0WWVib3VU?=
 =?utf-8?B?dGFud0lDMzBoMEw0VFIxUm9FRFg3N0gvWnh0c1kwS2JjYklacXhtTFNlUmQv?=
 =?utf-8?B?bGRYa2NrZ1NrSVZGdzB2cDZYNmEyYkNTcUdidDQ0dSt4KzVoYzhKb3lYVTAr?=
 =?utf-8?B?NW5KWUE4bFlGQ2lIVEZyUk8zSU8wZmhEdlQ3TlJ6clE0N0xXS2FpMnhseVBN?=
 =?utf-8?B?cUJRd25DcXNqeENoME9qeDVoK0JXdXBZSVBWNDA1aWEzeDZVa1RQaFNpNE9L?=
 =?utf-8?B?aCtjYVVCdGV1aXE4dEJuVU8yOHpsUWFLQWhsUit0YzJsemE2RHBlMkpIMElI?=
 =?utf-8?B?N2cwV2xBYnVOR2dGUjd5RDVZRjlHamg4NU43S0Z1ZFA0dWR3VHhnU3hvU1RU?=
 =?utf-8?B?WlY1WHMrYlRHL1BET3JOaFExQ1dxOFd5T2k2dFk0c0ZDMnRVUko5anpTei9H?=
 =?utf-8?B?aytDWHVqZ2pSdUpySlBJRmRRTGx1Q2g1K3BPNXFuYUpJYkRSdE1kd2hVMGgr?=
 =?utf-8?B?b2ZUbGwzS3V3d3JhVHVqdkZaclhrSnNSbUk5SGl2MnpldmtSOFA4SlpZbDNX?=
 =?utf-8?B?bnVQMVIyV1A3cmlkKzhwYjhsQSs4ZURHQmpZRXhTd1lLUVRNMXVTVzBaS0hE?=
 =?utf-8?B?dWNSUDlmd2hTL2l4eTd6OXdiQjFvMG1OV3E5aHdOSllvR2hSRitreXNDaFRv?=
 =?utf-8?B?c1djVVYwazd1S1F6WFdBQ1JERWdPbTA2dGJuWitQRkVOZFhKL01HdGI5ellI?=
 =?utf-8?B?dStrWVJLV3JZV3B2TEMzUDdsanpDenF2MTdmUndLQ2V4Wk9ya0ltdDI1cUp2?=
 =?utf-8?Q?pt0JihfpnaQliCnlV2NFH6kG01Z7OlHCQ0UH0pLeTM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9be4cac-09c5-4fcf-1000-08d9a39e2a40
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 16:29:56.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHKBw01zF+1FReTCnqF6jO1eXjO9z8TDAFhHz/DSiS+5KPupTnYjiA2WoCZ67CSQoUWy3QHdL5DenKEG9lmcbDVF8qiGC1EVEMxhqo1Nx9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5338
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090097
X-Proofpoint-GUID: f6Ac7Sim4WqB0zow-oY_13sPkCUzvynf
X-Proofpoint-ORIG-GUID: f6Ac7Sim4WqB0zow-oY_13sPkCUzvynf
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.11.2021 02:34, Sean Christopherson wrote:
> On Tue, Nov 09, 2021, Maciej S. Szmigiero wrote:
>> On 04.11.2021 01:25, Sean Christopherson wrote:
>>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>>
>>> There is no point in recalculating from scratch the total number of pages
>>> in all memslots each time a memslot is created or deleted.  Use KVM's
>>> cached nr_memslot_pages to compute the default max number of MMU pages.
>>>
>>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>> [sean: use common KVM field and rework changelog accordingly]
> 
> Heh, and I forgot to add "and introduce bugs"
> 
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h |  1 -
>>>    arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
>>>    arch/x86/kvm/x86.c              | 11 ++++++++---
>>>    3 files changed, 8 insertions(+), 28 deletions(-)
>>>
>> (..)
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -11837,9 +11837,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>>    				enum kvm_mr_change change)
>>>    {
>>>    	if (!kvm->arch.n_requested_mmu_pages &&
>>> -	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
>>> -		kvm_mmu_change_mmu_pages(kvm,
>>> -				kvm_mmu_calculate_default_mmu_pages(kvm));
>>> +	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
>>> +		unsigned long nr_mmu_pages;
>>> +
>>> +		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;
>>
>> Unfortunately, even if kvm->nr_memslot_pages is capped at ULONG_MAX then
>> this value multiplied by 20 can still overflow an unsigned long variable.
> 
> Doh.  And that likely subtly avoided by the compiler collapsing the "* 20 / 1000"
> into "/ 50".

Unfortunately in this case (but fortunately in general) C has well-defined
unsigned overflow behavior so if this code has an overflow by its naive
reading the compiler is not allowed to transform it to a form which
doesn't have this overflow (as it will result in a different value).

> Any objection to adding a patch to cut out the multiplication entirely?  Well, cut
> it from the source code, looks like gcc generates some fancy SHR+MUL to do the
> divide.
> 
> I'm thinking this:
> 
> #define KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO 50
> 
> 
> 	...
> 
> 	nr_mmu_pages = nr_pages / KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO;
> 
> 

I agree this would be a good solution to our problem, since this macro is
unlikely to be converted into something user-configurable in the future.
So its units don't matter.

Thanks,
Maciej
