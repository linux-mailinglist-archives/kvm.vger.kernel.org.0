Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87515449FAC
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241302AbhKIAlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:41:45 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12970 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241301AbhKIAln (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:41:43 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9025Oh005993;
        Tue, 9 Nov 2021 00:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=w8flj6/X9XLkgt1K8jvD5IYW4dvCcRddnyoXY3XdsRs=;
 b=z0x6gy5siCY+kaZb/zmdJOzjLYF4hChsxRTfNaVyGRUMH1LXi70t/e+q+14gy+UwMuO7
 2vC/XaWptDBAtijm9rMAA/PAau0Hbr9wMfmRhDEpd8JCH+tVND/8ysU7R3JU91zEY60Q
 MCaAIClnhW/rGLkK1ZvBmKEPmI6gC4TkRsBvFSR4wnl+ET6+Ig9TzrQh/nX/J8rs2s34
 0iFq8Ihtm1B5XExy/09rKWHayj2ZEFtWb845hB2VSGt8dkTHoiI4deZAUeoO3CTKcxPw
 2xu0TI2RH88YWHWzO32F8O0Uh81zqorHzlSOWUMjwF3eZ1uochi0PcJ/gv+egKJjBgUK EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6vkr01s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aEfR062897;
        Tue, 9 Nov 2021 00:38:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3c5hh2v3yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmHG30Zb8WVsbC+rK940hRmNP5R4kzYPFK+aiSPNKJBnG+dy9vaS/3PXk9IAmavw+AbWW5KjWjWAWNqjThdDO0cBgmPXCiTsI1asA0zIAUQIRQCpIaBspId+QfYSV2PTmqPWo4KcFRm8rJqL3f0iGhMrgUItzaRE9lFtbDASAcnpyzwyvvbLqT0Q8OQo28rv8Ncz5A918ODyYerHdfn0b4fLr0j2XDtCb06NSXQCAW+918zeiiM8oRhSwNr8BOt4qCyfyrnPPE3+eKIJvfa6fHyqbcmPQqaat45YcCYUSng/qHqMTqmcpbPlIccCFA0BZUnjaTJ/X1uAA9/p1jYUPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8flj6/X9XLkgt1K8jvD5IYW4dvCcRddnyoXY3XdsRs=;
 b=PJ/7eUBa5UOuYhR70jXH208hcbt2aOCkf4jqfKzZ5GoVMx/g++g8QK9CqxtwKBIq363ib7EWCw7gPH47ChgQ5za5QgXng48JVsDCmjc33ylsbb5Jec9JTxGzG5sRdEado01IK7AyKd57yPnC/5oHWcxPxGqrG9h1taogS3clh2MC6d9Z5asrQmymvduTriGi99i4fN5O8BiUMU5L9YhA/QU1JYVxC5N9nlVuBEtpGxlvQ+5pXm2zTo4b6Q/TCEJ6UejL6ykSKv9vsDGsYAPXKxV0c/J3wwKZdm/h/i3SYtPdBTvINCq6iHKhhEkc6qHWXs0+r6jie3fEFmYJjS/H6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8flj6/X9XLkgt1K8jvD5IYW4dvCcRddnyoXY3XdsRs=;
 b=NYhGkFXSVPRdvMIfENlgqKa8pw84quUSdO4S5q0eB/OHQXCIHYvvk8E3gEAd68p6+Vd8m3eBsI/ve3GvUNdRUejq9wFqkXvUZbj/xOGWt5CtIuS0BQs4Dd3sia/PmmSEycDS0BG2zIrXwcCMX0jfZ4LpDsdszt2PHUNvcvdTyD8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4972.namprd10.prod.outlook.com (2603:10b6:610:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 00:38:13 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:38:13 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 02/30] KVM: Disallow user memslot with size that
 exceeds "unsigned long"
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
 <20211104002531.1176691-3-seanjc@google.com>
Message-ID: <2f451590-bf89-d447-d92a-fe9f3f41ca74@oracle.com>
Date:   Tue, 9 Nov 2021 01:38:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0298.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::6) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AS9PR06CA0298.eurprd06.prod.outlook.com (2603:10a6:20b:45a::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 00:38:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ba0283-085f-40a7-d25a-08d9a31936a7
X-MS-TrafficTypeDiagnostic: CH0PR10MB4972:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4972338536EDF8B62E3F52D1FF929@CH0PR10MB4972.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPpsXTPLNZE3cvVMYTtFmj4nvpMcwZf1DlagPVG6GpH2ur4Bf+dx3UffLk3q2GUZfm3zJdAiP5FUf8kN0LUPu4XjGDBM9KLtnaBkbAk+rD3TwToRUKK5hpf5GEQ5zqn2iFLMCuMpfOIKISkhEOyAkPsnGh85A62zTl6+LB7XCbfxeMUZRBPfOMqK5ozNdOQ9ZQGWlixMYx4zhPecjOkdl9t345+PnBxszPk1lPbZHFrsuCUGxWXUmQ99KAhG9rcd7+qAQxkrUFrdMYPtCDpj51MUM8b14fAVglBKDKaq13StDHWR/jsgAHJzSlT1NtubRb/k2UY6mpl+0P9o0gu7sLM5UBaZAFw6pLtCq5qG46ImvST2lF961QfqUW48PPd4IK8by6jiYnaQqgWgMK9gmoyAY+/+0eH8Z/YpKjbl4S9Cmc6r87gE3Bv5W2ylS71oYyhnX/owVQmfjEaM3m6Xwi10z6qW+c5YaprGHMMnnkOSPUVBaYDRvBaULB16OVvhzGfdsB2cTPgJ9g9icswu8I35Qne16tAXpl9vVSCCXRN3ie9EEl8PGJSX/5vJsMTNNi16Yxq9tLHqol0LJsQP38jfQoqIxRLYdriWYKLco9PNF7HCPPIeS7ryLGrR1EBC7FxwVq+iWoS1zI4n+0vuZ5a/KZGkPd88y6e4Qb3rJ3cOZbcVAxqN5KaA0OfS/vGK1G6wj+l6pFRIDP8tGI3J1XaJ131mvb81EtQnCZzJxOc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(86362001)(83380400001)(956004)(2616005)(6486002)(26005)(66476007)(8676002)(66946007)(54906003)(186003)(66556008)(36756003)(53546011)(38100700002)(16576012)(31696002)(508600001)(316002)(6916009)(8936002)(5660300002)(4326008)(7406005)(6666004)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RE90VmloclNGMG9YZWE3MHYwWG5Sd290a01RZmJGRVlnQ1g1ZGNUazVXSjNI?=
 =?utf-8?B?SG0zdXdhd3JNOHNxTjRvMkY3bUEvNHA4L1JDMCtjcEVhSzRkUm5FN2EvUkN6?=
 =?utf-8?B?T0xIRCtPVU0yVWd5aUY5emwvZnNUazkydWdCSys0UlRtN1l4azNFRGNNM01Z?=
 =?utf-8?B?THd4RFY2MVBxM3kyajdJbEtzakMwMXlrT1g5S0ZYVUVtV1JwcHk2VDFKVUQ3?=
 =?utf-8?B?amtpZ24wUXBrZHdQb2RqKzF6M1pIRWJLR05Hb0N2WnRLM2NYdUxJNWFPRVBP?=
 =?utf-8?B?bU9zMU14WXRKbExYNHBUNDl2ZnhIRkp0MG9kVjNmMk9VSVJPS3EzSWFUazhq?=
 =?utf-8?B?akcyR2RCMi9OM2t1KzJBV2RtQks2SlVrU1lvMlhoaHlJTkRGVkJHZGo2RnI4?=
 =?utf-8?B?KzJQOWx5RGppeTJybW1HbUJlakpxY2ZLdUVMMnExbitHTElJUGtDb05uc0NS?=
 =?utf-8?B?VU9DbmRjSjlNemEvanl0ZndTWHZCSUJnK2hkZGsxN0lLcHI1QVBhUlVJeUov?=
 =?utf-8?B?bkRIUVFtRzlibnN3SFNaQ3kvRGFpK3pZME9uSmNqTFFMZ0NwZXRyVUFWSkxx?=
 =?utf-8?B?dHFzd0w1bC9FSXNVeXdKMEcxVmNjd1ZjYVJCdjRjUFZuZ2c3dVd3Q0dIeFhK?=
 =?utf-8?B?V29WN2FULzRFUndhK25tQzd0Y3d0VGp3dm1BMWZWMERCdDBmSXA0YXN1RG5C?=
 =?utf-8?B?UzhSMWFtYkhBMFpWVmEybnlnZi9BVFZMSXpCOXhxeXc1aHpuajhFTkdUQ09U?=
 =?utf-8?B?UGgxaC9Gd0dNWXhWZUQ5aUdFNE9aMWtzR1VSV2RvSTh3dnE2M042ZmhnZGJI?=
 =?utf-8?B?bXhHTkFDUGphWnZLbWRnYzdQK2lrQWMxSjRsL2hZYjFoRlJLS1Q0bTNGL2Iy?=
 =?utf-8?B?dWlQYmVVemdXM1BFaWlucXVVcWVRU3VTOEhzSjc0d2RYeDlhMkIvL24xTG9r?=
 =?utf-8?B?QlBGYVc2TlJ5MkNKUjZ6SlhOMUYxaUEzeWRwNG9EVkpLOTQzVlVpKzdsb0t5?=
 =?utf-8?B?a0hpNUxhbU0yZFJGeXZ0VTZxZGRwL2ZZbHJmaUIxeUlBU1lVSWdndldzeGdK?=
 =?utf-8?B?ZlpHMzZ1SDZwTWtDS09DUUNzK3FnQUY1dStUY2ZhWVJraDFtTWV5end6enp2?=
 =?utf-8?B?TldyTTAxdEpGUktNYnIyY2V5RjlhalNCcEdjcFJKMjhXSGgrUmh3U1I0WHpk?=
 =?utf-8?B?OGZSNFBJZWUvVVBIVDEyWXZ2bkFaMWNQZ1ZwRUNBcnFmVmNLK0pYUTFGQ1lk?=
 =?utf-8?B?WjFWT292L3RaQ3lvdjUzM2ZkRS9uVnd5ZDZ0UXdneU9tdWp1d0dhNWpNK1pu?=
 =?utf-8?B?U0NTVWc2b0FQaVRqa0E0ajlnMGwyYVQ2Ny9KSVAvRmpvVFdHd0czNHc5VHFu?=
 =?utf-8?B?eGFIZGJ1aHdNWDhuNDFSQkptS3pMRzcyZjVKM1BqUitlY0ZqRHUyUXdUcFhW?=
 =?utf-8?B?ais4alFPek42ejAxVXBHc21FRmhEQzFzb1FoRkFhcXN4UTNiakZKVWgyUy8w?=
 =?utf-8?B?dlI2ZFlFTHhldTdiZ3hJNXF6SUhianRuUzRjT1JjMVJqcVZJajlNdGZ0S2RI?=
 =?utf-8?B?QnowdHZNdHBSa3RTNm1mcUtVL0pkNGRrQ0NWV2NlUDdDY1ZmU2VSN3ViaGps?=
 =?utf-8?B?dUErRngydEQvYW1pUTdwOVJ2c2tURnN4WVIyOHpQdHBCTTFpMHAvcklSa093?=
 =?utf-8?B?cE93cVZ1N3M0NEtINDJuUmVJQ3N4d1l3MnNiN1ZqdmczMkIzaE51L2hsbVRV?=
 =?utf-8?B?MUkreTRFY3Qwdk1pVHV3NEVLTGtyZVV2Z3NPNDhDZWFGTVRQUVErdklWcUIx?=
 =?utf-8?B?RkdObmtvZ1VkV2FDU1VkUzdlMVZkRkw3Z2RpS3hYcko3TDRsaVEweStTQThB?=
 =?utf-8?B?UTYvTW0rbHZtd25IRm1KbE9NSWxod0NrbURRc01aTEY5aWthTDZCb3ZGb3Fm?=
 =?utf-8?B?d0RKbmVLRll6ZlQvdlRvbmtDeXAyRE5aV3M4aGJoV2xDdUZoTWVqZjlhbGtQ?=
 =?utf-8?B?WnFEbDgyZWtZSm8vZEZrZ1l1U1VFSFhBR2NXUmF5cHlBL1ZseEsyUFluam5D?=
 =?utf-8?B?TUFNWDE3aGR3bUR5OGh1U0JOZ3pEam53Z04xaC9QUityY203dFZrcDZ4T0Vz?=
 =?utf-8?B?a0JRSGRxSXkyNTluNkJvWkRBblNLMkR4d1Q4QW5KUzRRVFU2M2VtZitxWTdq?=
 =?utf-8?B?RmpGWkF1Y0k1T0NhYkkvMy9iVVdCQlhVN3oxQWQvUjdQZC9WYkZubHRVS3Jp?=
 =?utf-8?B?QTRsVzhjMVVIQjl4U24vdlc3aXlBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ba0283-085f-40a7-d25a-08d9a31936a7
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:38:13.7542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txm6s8v+8RbIgMwnkxmWOK3GxkIkoOEbpTf9xwR03CurQ7wbiU/v2qca+5PBRoh1WusensMTjbSih3Us2p9XOQoJUND6XD10dre/uMOyYFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4972
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-GUID: XiyzNoXu5iF_J23fppOeGHzCo6jJGNwd
X-Proofpoint-ORIG-GUID: XiyzNoXu5iF_J23fppOeGHzCo6jJGNwd
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Reject userspace memslots whose size exceeds the storage capacity of an
> "unsigned long".  KVM's uAPI takes the size as u64 to support large slots
> on 64-bit hosts, but does not account for the size being truncated on
> 32-bit hosts in various flows.  The access_ok() check on the userspace
> virtual address in particular casts the size to "unsigned long" and will
> check the wrong number of bytes.
> 
> KVM doesn't actually support slots whose size doesn't fit in an "unsigned
> long", e.g. KVM's internal kvm_memory_slot.npages is an "unsigned long",
> not a "u64", and misc arch specific code follows that behavior.
> 
> Fixes: fa3d315a4ce2 ("KVM: Validate userspace_addr of memslot when registered")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 99e69375c4c9..83287730389f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1689,7 +1689,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	id = (u16)mem->slot;
>   
>   	/* General sanity checks */
> -	if (mem->memory_size & (PAGE_SIZE - 1))
> +	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
> +	    (mem->memory_size != (unsigned long)mem->memory_size))
>   		return -EINVAL;
>   	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
>   		return -EINVAL;
> 

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
