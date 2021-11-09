Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02301449FC0
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhKIAnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:43:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30446 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234933AbhKIAni (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:43:38 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A904wIt013245;
        Tue, 9 Nov 2021 00:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GdG+fn2h0ffKNWsjagSMawTQMudvkoOvz2wo9ULBbhg=;
 b=VDNAyPnpfSQtih35rRU3aJIuBa+zGwUP/uEbbdgETtRFRaHiKUgRWIK4fTO0FqMfOyY0
 zW7FZlK8qvjp/iRBKBLr25actZNlUT942F8yR8kzo4IO3zbJvJjHZtmg6ud4EmRImJ0f
 O6V+wc/VwHNqINaxOahmmDJXsFrgiAAFeGbN88AyevdJs3eExgU5CkT/JhEhxCpwiBWs
 ++Vt97lA8QeNxRN8T8EJsQtAKI4AyT5FBcvlWUlfR8UX+TJIjSmce1c5xcy0oUy0WRbQ
 BVSAyzgCxWY82ZsLo60HV3N+A8xpVqpXbFSJaldLAu3krbln9g8cwm2gZbOiOzEq8sEP sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8qyg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:40:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aaEp054109;
        Tue, 9 Nov 2021 00:40:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 3c63fs5et3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:40:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZJ6pI4CLvXboWaxtTAiqr1Qa7qGsH9277QsbfmxZvm1Xy3PzxnqqyfbZl2V1jLU76bq9x//GJNaCX4BpySSbyCIkeT2fTago46YGT+lsxdRPBCkng1d3DIZugTB0x2FvETPscXZJ5klOtBI7UhMoLsZJxAwT3nxy5VhClQ+Al4qBqU4+uPuMwvIgG49IzxtY7EWK46wQ8gWxpCuebU5SmB7XovVg8IJGDjLR3FBjRXwWgZrilepxLafhM9m6R97rNMuwczfS0AqeY08LYohb9wD9oxTNWGdJWdB9B4xJUXqMH+ujvX4YK4hOu0b5rj94kbReMMPyE03nvfPHdvHdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdG+fn2h0ffKNWsjagSMawTQMudvkoOvz2wo9ULBbhg=;
 b=ZPhPGki36/YhWrDk3vbtLA/l1o6o6wP0eJpR+FQFEbBFiZ15mXD/SrNzhVvlUc8bdSP0fIznp3O4nVi1zTJjUICkVyoeP/EBnTTcBmOuu+geya9dgPmYu1/9DijK5XkJwo0GXw5+liaJjRTt1S7papdxj0oPgtaK7ysSGTXGjgFaesT3czb+YjEDpz4lh0Ey5j7vWB0WIuC2puGBIhOz/Jpofh1e9r7t0KKxfvliyqPzffDBInonez1HnZvTWU32uz7omlVqhkxkWbT208Wbysobl5tENgH5kWj0DSeP6niybem0PQo5n0utBnrKTyegtlJ2X5zyuc2kLdZLqhZGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdG+fn2h0ffKNWsjagSMawTQMudvkoOvz2wo9ULBbhg=;
 b=epbN/eG+hGe1HxzchdIXWVri8u5A7JIE8igPQDKSbqlCUDrRx/rZOo98L9gHuihjMy0dldbbAtD1cghY9rDxoCeevl7h9L/Px0Wz8JKc3TzcetiSdbPD39rk6FA7pmHITYm023TkgGP/+V6pYvxIg1y06P0/XvGZZQueC5mKTOQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:40:04 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:40:04 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 07/30] KVM: Let/force architectures to deal with arch
 specific memslot data
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
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-8-seanjc@google.com>
Message-ID: <e12ecff3-ee69-9e2c-02f9-0e54a1cb9519@oracle.com>
Date:   Tue, 9 Nov 2021 01:39:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0052.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::29) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM5PR1001CA0052.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 00:39:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a1a3d3-d5dd-463b-9bc6-08d9a31978bd
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5273E6AF59B7AD6D85A5EA7EFF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mYko6gnhUCeRQXyADbi4uckG62Y9o5N0fPXWfl81u1uXEXn31EAh5LRi1AGySbXG64ZIGJ5xgxlKryBUcSgt8SrUqTvcQV2Ymb9CAv2qo4oi4tUrmoyFnwmk09+U+uVDcv+5vXCvpO7h1b4lGCB+Bq6+2hapBUoyZ0LnzYANfIfbmyHmOo7ZGWemtGWPw1PKgPQM3wpxs09RILhhVT+ijfvCVNQ6Gg6MnPUTUnuDGGoR9oTOXZx6riE5v0Ev6QcVvyrt69oCOs84x4XUrfd1n9u6edjzGIOtn5Atl5BSzPJn+jH3kg5vK74biCglePcVKDKg4jeuFZ2pM23yV2L+XHyFSx47xETjltY8iz5Nr5SjqaWvtcYs0fqHztwdcyfhb/l9rz8vZQMC1HYWbF62KOrvPiDwWl+c/CEXlBEazuxfulieG1oKhb3JVa/afOOkBy+X5TxVl9C81ItVTSlQ67vfLE5L2LXNJ9Nh6yCqP3DNnlNHFjSw2j475J3VPGnkMGkBBsefxMJQKSCwIdfYlh8Wn6IlsvBMmNpSDIN9b0FaErthhdWAL788E0BbxiyOXUBxwOq4e9ErHyKB3NHzstZJFuprZVz9JVqeqMYFpipOW5UQiiLtQTAqQrimNF9dlvJADsHiQqZ3U1tbtw8WfLRrNmCZFZZpuHwX56KqJcvB6rQlp6s5fQfTK7yXFo5M+ivhUL0OrVuBA7GbtBYVJ7n/PeFRYlLEA7z+B0ofpJU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG0wK2JnWkp3d3FtcFNwK2RjclIvRlRhUVhrVWNzNUxZdmRlTEFwYkFjQjBE?=
 =?utf-8?B?OUxTYUp0SjFweHIxcHhRNSsyMUg1b1dDMUIvWTFINmM4UExQN0diWnhJTCsw?=
 =?utf-8?B?WHhYK2V5NHVWL1pYT0VFeCtiMFgrWjJ1VEc5TGNCbU9laTBSdjVPdXJjWW5y?=
 =?utf-8?B?NHpONU1QOG9kemNuRm11Q3piOFFOTFV1Zm55R3JIT1JscjZBQUgva3p1VlA3?=
 =?utf-8?B?QXNzQWRSS1BrS2lTcExDRDhRMGNzaVVoSzN6YXlFWnY5QmFKbE95TFFZOGNn?=
 =?utf-8?B?R3RnTDlZdGkyYmNONGJLYVl2SXhLVTJZOTQxdTE3NUZWNFA2dmQ2anYwSmlL?=
 =?utf-8?B?K3ZQM1p5SVk1TWptaFFuUEk4YzA3b044QXZId1pqMkhZbFVxdXJidUVMZHFv?=
 =?utf-8?B?eEdQR0Mxb2pFUG9HdW5rcG1oYVFPamYwazlUdTZLNlAvaTNnK25RTFg5N09o?=
 =?utf-8?B?Qi83bk1MMzB6MW5hVXVLNHdQejY3RjljWVdoTGwzTnRPbzI0eC9GR2k1ckRj?=
 =?utf-8?B?cU1HSko3NUtVblBsS2RjdzZZNlpIVDArSWdIUWVpbVBQbkRXenRBaUkxUGVU?=
 =?utf-8?B?ZWZ3MTRHVTk5T3pUUXY3bUl4N2RmbUJBYkoxZGc5ejYxbkNUM3l4Q1JJT3BW?=
 =?utf-8?B?RmNkUjZNTHYyTmVRY29nOWliL1luenZvZEJxTTNXR0JlQVE2eGdTY1dpRjJa?=
 =?utf-8?B?Y1dQdlp4dHFNRFdtMjFqOUt1NHNvSU9LeXYveHdCOGZYZlJQWkE4c29mbE5K?=
 =?utf-8?B?djh4QXoyY1d2YU4zeDNsVnNPOVlnTlFjc1crWU85dkN5ZlFUZjRaTStpNHdn?=
 =?utf-8?B?SVBCdys5N3BGYllGUzRKVDZLb2JvTWFJOW9sZnJocFZqRHhBTWJzWnBjcHZs?=
 =?utf-8?B?ZzViSXFkOTFVa2lWSHZyY05Od0FzbmNWOXZJQ3VwSURYYTlQNGR5UmE1VjUr?=
 =?utf-8?B?ekxFbmxLQ1VaZkNSNWsrcEZGeUlqR2owbTkxRGlTTTVjNEVpcE1IT3pyOXdw?=
 =?utf-8?B?Uk45azBBdmJ4dG4yT282ejFmVytmRENCRG9rNVBrazdtQnJzRzh6aDNET1J1?=
 =?utf-8?B?M0NhRkk0TDRPdjZoMzdZNjU1QTN1amVNUDV3V1IvbkhrNzNrRE9vMjUxMlcw?=
 =?utf-8?B?SUx2M21HR3RIeFQwc0VmNDNtU0JuQW5HemM3ek5mRmJPTytXSEx3eEJNZ1F0?=
 =?utf-8?B?M2QyMHB3eEpIVVVIMlBoVDUxMXBiQ3VtQ0tHMnJEU0FiMWRQaXBJRFJSUS9y?=
 =?utf-8?B?cGVLQXdqcEVwcVF3bm9lemVBd25LblZxVVpGTkZCeFpxRHBLcGV2dTE4dnVX?=
 =?utf-8?B?dHhJRVdXZUlwU0lqQ0pybW94WWpwQ050dFIwNG1YemZGY3F0b0hQMmQvK3Vm?=
 =?utf-8?B?NHlQWnVtcE1SK042SGR4TTN0YlIrWGQ1U1V1OEVZVGN2SVJpbU1yNlplVGhR?=
 =?utf-8?B?QzJxcFd6eW03NUxpUXR0OXg4b3VENUR1aWsyZWZ3bmd0NXJIUmhudHdUY1Nj?=
 =?utf-8?B?SDBBQTFnTURJL1daT24vbk16OW9JNTBLTkhHM3poMW1EZHdhQzNZMkJxWUJT?=
 =?utf-8?B?VjFjWWYvQm1jcnVkc0ZrYk1yTVZidFZvbUJsRE53dk5xTitYRmNYSXBLQkpB?=
 =?utf-8?B?RDc5K3lGemhEUlNCZEJ6dkhFZitoVGFzdTdqQzNtTVRQVG9EQmhZYUYrd29M?=
 =?utf-8?B?ZlE0K28vK2phaVh6TTZFWTROQUtRQk43WVZoNUtjQjN0SDBkVHpoL21rWUZN?=
 =?utf-8?B?b2ViSlFWMDFWUnRpNkdJcjFwdXVHZ3RCMzVuejgvNDlVL3NBSm5yR0wyRVFw?=
 =?utf-8?B?RzVQaWhSQ1Q4a241RnVCaC9UMDNsOXBETmtaYmJmeEhiK2xaWGhqRmlpeVFY?=
 =?utf-8?B?TTE4ZjBQcUZ4MEZsbWw4NlNuQTA2Q001SnlIWnVhZjY5cDZzc1Y0b1hYMmpC?=
 =?utf-8?B?TVdpbWtPZUlIOVlVc3JXa1ovdzZZSTJQcEdtQTlQVEViMUJad0xnVksza1ow?=
 =?utf-8?B?RjZOTWNKMmxPL1ppa3NOV3ltbFRHZ0ZnSU5vQ3lDM0tRbFhXQ2krU29xY0xZ?=
 =?utf-8?B?TFNSa1d3YTk5RG55eWtCSXJBMEZiZ2E2YlI0Y2MwVy9MMXdHQUlqZFJzTi9Z?=
 =?utf-8?B?UDhnY3lhbEpUd3Q3ZmEzdTRpZmtoNEpPNGNRRzRXT3IvcEN3aTlMNTV0VnNs?=
 =?utf-8?B?TEk0L3Vpb3EyaWU1L0Q4cEozMm5pdVhQenZnSHNJR0NDS2NVMGhMTXdhNjV5?=
 =?utf-8?B?YThqNjFxakFkeUM5dEtCcTRucEh3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a1a3d3-d5dd-463b-9bc6-08d9a31978bd
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:40:04.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YT75LlM8cpi7i1jID0mf6rxJcR5uw5jbzQBvhy+Lv99wPICeJOKilq9EyCYOUQeolkCXbe3tHPI/izaI7ZIVLtRZ1ymhYBxw+0QU51go7u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: S0BMNGHwdDj24cYf3s8X2_hAymUBSEuZ
X-Proofpoint-GUID: S0BMNGHwdDj24cYf3s8X2_hAymUBSEuZ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Pass the "old" slot to kvm_arch_prepare_memory_region() and force arch
> code to handle propagating arch specific data from "new" to "old" when
> necessary.  This is a baby step towards dynamically allocating "new" from
> the get go, and is a (very) minor performance boost on x86 due to not
> unnecessarily copying arch data.
> 
> For PPC HV, copy the rmap in the !CREATE and !DELETE paths, i.e. for MOVE
> and FLAGS_ONLY.  This is functionally a nop as the previous behavior
> would overwrite the pointer for CREATE, and eventually discard/ignore it
> for DELETE.
> 
> For x86, copy the arch data only for FLAGS_ONLY changes.  Unlike PPC HV,
> x86 needs to reallocate arch data in the MOVE case as the size of x86's
> allocations depend on the alignment of the memslot's gfn.
> 
> Opportunistically tweak kvm_arch_prepare_memory_region()'s param order to
> match the "commit" prototype.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/mmu.c               |  7 ++++---
>   arch/mips/kvm/mips.c               |  3 ++-
>   arch/powerpc/include/asm/kvm_ppc.h | 18 ++++++++++--------
>   arch/powerpc/kvm/book3s.c          | 12 ++++++------
>   arch/powerpc/kvm/book3s_hv.c       | 17 ++++++++++-------
>   arch/powerpc/kvm/book3s_pr.c       | 17 +++++++++--------
>   arch/powerpc/kvm/booke.c           |  5 +++--
>   arch/powerpc/kvm/powerpc.c         |  5 +++--
>   arch/s390/kvm/kvm-s390.c           |  3 ++-
>   arch/x86/kvm/x86.c                 | 15 +++++++++++----
>   include/linux/kvm_host.h           |  3 ++-
>   virt/kvm/kvm_main.c                |  5 +----
>   12 files changed, 63 insertions(+), 47 deletions(-)
> 

You didn't include the RISCV kvm_arch_prepare_memory_region() change here
(that's actually in patch 13 of this series) so bisection on that arch
will be broken between this patch and patch 13.

Thanks,
Maciej
