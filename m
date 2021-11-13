Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1573544F3EC
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 16:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbhKMP1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 10:27:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49470 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233143AbhKMP1L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 13 Nov 2021 10:27:11 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ADFEfhn018444;
        Sat, 13 Nov 2021 15:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GkdunWBalMT7VQ1F/4DLdV+J18lC3yPhPK46bHUQ1AQ=;
 b=xP5TEPlaKSLNXEgGWy0ja1Ukd3yFRW4rko2Vq+d45xKVqtdmHIK+44EBnCaUzch6Cz5D
 xH5/iNgqKf/CW6zyZL/D3XWpiVgNO0ooGZnqL185+w28JeFYUUcHqrTvcu7AujmtIUGZ
 tMP2ntHDAg1Jg9I+xoW3wgJX79aDocsNxSTsqRy8T8gvGWJ6MzVW832+6oC3bRtD6aeT
 JQG8epqxkKy/il7yixEkQEjghmXNz9ydYG81pFdNPBqC9mu5WHX67A6nk6NbBcAT9VEq
 9ANMwRntkxkbjWPbE6mZrLUJJU/Ouyx2VLx0eSDJcfOfP79rCAbDs+L7o5RyE3Q8YJyI xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ca3y198bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Nov 2021 15:23:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ADF6Fk9131542;
        Sat, 13 Nov 2021 15:23:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by aserp3030.oracle.com with ESMTP id 3ca3dcqrsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Nov 2021 15:23:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvD4IJgOdFh1zmxwpGpaqB+g4YvWDk4bn6NdGv0yAliBwYHGtX1jhgGPvHqmVD14ArddNXXEmGqLqDsI2HVbLXJjxAt0dZQRcqz6IhoXkAIZ33vnsBolZ5cA/sAUC8TZwVMKdoD6kik3r/LSibpOFv96s6/pDTedWQymvi/krkGDW4MOPYiIRe1KDRLlOYE/rUgBiv+/Mm8Vge7VLHdPOjqaPXY0dGgrR1kGHx9Jsz3C4vvtZNoKGFNCyE5Z9FVTvu6+tm5JfLwnOaD/P/geaTuwvIhyizXNQ8bKqJoDk+BG9M5f1jZ/GEi6Iip9Hj2OpRg7tXZ1WeGO4/rbWbuJ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkdunWBalMT7VQ1F/4DLdV+J18lC3yPhPK46bHUQ1AQ=;
 b=D0whMiNTU3k30TPjsmmWwNqMB5uKLaJGyRMGOpFpNX77JM+GxxvMOf7a3YR5Ix9up9n6LUlQIWqhTwjMYzxLQ1UNIWUY0VQ34mVUiykis8y825qZ0sXsMEZELUeKfzGFar7neCDOMGWsOoRQFSa0DoOjar5lGsknDll8YUnimCmstVVW5/6TK19rD6mE994tO+Wb0xzyxxqQ0UsNzL0MsKhBbtQY7EdD0WfD/+jF6ejwAvjJbsSFe7CvqhLCxeMgAPJR3Tw5bqUkSgLGTgZGiTeG77q9Rl0aFV0Q4vJr8+3PWp7RXMvKZvfITVGZQzEmgoqv9LoILoTBzyIOXbxljg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkdunWBalMT7VQ1F/4DLdV+J18lC3yPhPK46bHUQ1AQ=;
 b=tItPeXu7BvcutMz26ZHqtirOsH0bu3wz5ybaUkl5CvxbQNtiP6vKBLUwCn5elZLmoYBsRASVsLOG31nf1BKk+Q6VS9FGhjJiKmob7ToZxVTzS9Wi55Q13Cne1e72mYUweW3mQIXmMaoGVI+Om891VayiXjTHRMfBHiEksVw2fTE=
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH2PR10MB3928.namprd10.prod.outlook.com (2603:10b6:610:6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Sat, 13 Nov
 2021 15:22:58 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4690.026; Sat, 13 Nov 2021
 15:22:58 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 26/30] KVM: Keep memslots in tree-based structures
 instead of array-based ones
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
 <20211104002531.1176691-27-seanjc@google.com>
 <5f5c80ce-9189-def3-9c50-d5a504925253@oracle.com>
 <YY26dxv2kM3m2H7Z@google.com>
Message-ID: <d1c648e4-5536-111d-a7bf-3644ac68c9f5@oracle.com>
Date:   Sat, 13 Nov 2021 16:22:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YY26dxv2kM3m2H7Z@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0040.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::28) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.222.61) by AM6PR08CA0040.eurprd08.prod.outlook.com (2603:10a6:20b:c0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19 via Frontend Transport; Sat, 13 Nov 2021 15:22:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea1b7831-14f8-46f7-d172-08d9a6b97924
X-MS-TrafficTypeDiagnostic: CH2PR10MB3928:
X-Microsoft-Antispam-PRVS: <CH2PR10MB39288D3BD581AA67A2D20C4CFF969@CH2PR10MB3928.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ewKu6G7be8M2R7gub9deNJ8TrzOpm6ggMpTSaFIxBpg2zig+7PxibrbO61CGEz7ttq8T1GHtLbLV8Mm2KsyWW5fGygxEl1+IiUa319ac92anRjWbOJvlde5NtlHsBvt0IWs1vs798lPsBI46L2AlP4G4ol2GIFPH3QVLyTJE3vmJoabGl1rgfOZl/bKb8a8ugWTD93yA1O8kSr0/gCZ6DnEF6XlocQcKU6fQSSc604slvzfmYoa/btDVdLRAR+TrecZKiI3I7GWeb8KauVZ+jtbomsoofnlDRWx8IxdascwKVLjp0EG5WuEg1ElxZ1IjO2UPrveSiQ7MxPV+xReFpJJdTzByTR90UndWsZ7GbGkBh+UUbohAbb0Gg9fbLC+OK+O7dzx+VNGUwckql7pvmhlgQevkxecrRvpK6mX6i9Qrg09FFjsjMrNLgzjZrXXZj18Z57GLHXy6DkHc9HSV5bzwn+uB7TyNtc3/3oGRjOkNxisApAnuBrePo1OIGM0qUaoIMXGaHEdtHwhi1OhCSJ2NoOiYAtlihl0n6wUtvteXQiP5sMAM1DkOJZc8THagi3YB3KN9jQzwK1QL6HNtk25GU20n+qhxqHUo5ECxi1yU2dQFXnGSKXCk9aUUkLT1G9YFkwfxGR9YZgYWYQDjMHmTlOIQFVRRcvUGvtn7o9iWVEughGyVZzrQn1Ae2RL9CS49ZwcTZQqJZxATNzlsa7CxH1rkT9tXX0t/MQ828k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(5660300002)(31696002)(8676002)(6486002)(4326008)(66476007)(66556008)(86362001)(2906002)(66946007)(7406005)(956004)(8936002)(26005)(36756003)(2616005)(7416002)(186003)(16576012)(316002)(54906003)(6916009)(83380400001)(508600001)(6666004)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2RWVlRJb2hnOUdBc2tIV0dLdWhFczV3WUtCL2E0c2hMR0VBYWFSTnRDd2py?=
 =?utf-8?B?cDZxQ1pmNjllaHZlUmZUQ1ZGd1drSnNDZmtrcHIrWnRFUHlzN3lCd3puOTlO?=
 =?utf-8?B?b3FlaW5lTWt2MUlnS1lzUlFRRzUvd20wOEJ2RjBpSkE0NXE0cWQ2K2RCV1do?=
 =?utf-8?B?YXZIcTBsbEN3cGYrWlV5WFo5ZWxRRTUvWStjVENFZzB1UkFKSFozaE4xazRX?=
 =?utf-8?B?eVFueGQzRnVjS0FCVDhIRE5jYjd2RkREZytjQmk3Ym9aQ01tVXFIZ05JSDc0?=
 =?utf-8?B?bVIwZDlsZldJNkZLYWQxalA1RW1kK0NrVmZ0TVZnb2QvdDRPZEdNMG90UFFx?=
 =?utf-8?B?OU9RSXJsSEdLa2xhQitZODJvQXpBbEVWRkowamI5YU10TlVnM1RxZGVpL0pQ?=
 =?utf-8?B?R0RXOXRxSUdhMkU4aUdlVjVRR3Y4a25pR2ZMWGYwZ29OR1JhVUZyeDlqa2VQ?=
 =?utf-8?B?eCthS0hXWmJubFQ2WFo2Umt0NjFLb2lTUGhXbU5yWnhYc3BMWVFUNWRvKzlV?=
 =?utf-8?B?Vko4c0FzWmRnaFFDenVrbWdmck9tWEZZRU9PSG41a2dBQ2FUcE5UT0tBc3J6?=
 =?utf-8?B?ZENvL3hSbmcvVi9JWXZoMHlJdEdwalFFZXRDWTQ1Q2lDMVgzMVMvdHlzNEtq?=
 =?utf-8?B?VFJ3eWFSYWtFWEJSTmFpT29SZDZEbVo2RHZ1NUtrMGJFa1N2ZVNqQXF3VlNT?=
 =?utf-8?B?c3EySHM5ZStiY0FCY05VREF0d3FDT09JRVhYbjZ5S3FvNnBnSGJoTXJDZjIv?=
 =?utf-8?B?SytLTVlYQ2xYUXZHK1BpZmx0TUJweVl0VHlpYXN5b3lhbVd6U2lOcmc0V2RI?=
 =?utf-8?B?dXIxanNCSWVQVzdnczI1czhSblFmM25ZWThFSzBlb0ZYaHVnTVVQSGxkTG9j?=
 =?utf-8?B?VzRwSExyUDluMEdjc3JBSTFHTkpubW1YUjZLYUpGOGtKMXFmMElsQ2Y2WlZQ?=
 =?utf-8?B?VEdNQjFSbGxMT0hUakRSZzU1TXVQdWpxWGdSQTJ0ZTlXdTJZSTErRW5kcjM5?=
 =?utf-8?B?bGJMU3NxU0lhbFNUVWpSM0V0YTNwUFVXbkdIb1NNZVFaRWF2MnZ2b1g0b1Rh?=
 =?utf-8?B?S3BCN1VBbTY4dGFGbkNWYlhNYW43bysyQkkyZ3djdnVUQ09odTJablErVzNU?=
 =?utf-8?B?T3FpWWV0dDlKMUNEanphdEUwQVFyWGMzMnNNU0Zpam1ESHFYaFh0bG5aZDJ6?=
 =?utf-8?B?c1k1NC9lTkdWNEYwenVNT0crbHoyTEdtWnRQSCtlMTBjeWxRZjY4SnQrSXpX?=
 =?utf-8?B?VXZ2SmNjd3NiYkdSRkJBbG1XRkFVR2hHbGd4Q1NFYWUzL0VaT2x1UDhkY05t?=
 =?utf-8?B?bWNGaW4rT0w2SzhrRitkZ3IzaDdETVNpU1lYRXFPVTc0cktadzYrNnpPN2lZ?=
 =?utf-8?B?QkpubzV0RWI1eUNVZU1qRStVOXpmdUFFQWFYQ1BmNUpEUE03eXFPWm1NL2l2?=
 =?utf-8?B?Z2JWd1JIelY4ck52a1YyR29GTUR2LzJYK2NJU1E4R3NDOGZQNFYzeVBqZzBj?=
 =?utf-8?B?K1dmblNNeUxJZ1NFN0FudHU4dHdFNlhoMEh0VGFRZUlKdjlsMmhIc2lIUlla?=
 =?utf-8?B?NmxVZ0tiTEpZb0FtbjFYbzFVc0RSbWMyNWRqeDFrOW1pc29EMy9kVEV1MXhr?=
 =?utf-8?B?cVJXcGJBRm11RFZXMGo3dG5WYjB6K1RKOHUxZnUyMmxXaEk1anVzWFp0cUZX?=
 =?utf-8?B?UWdQb1NTa0dQRk90NW5rcVlnM2s3N21iU0pqWEFiNHJIYTl6Wk1KZm4rbHR3?=
 =?utf-8?B?T1hmOUhObThWZHpDQUx0M3IwdkRES1ZYQVhGbEFOdWxIanZsQ296WVlpdVNW?=
 =?utf-8?B?Y1JGOGFhaGJaZi9rakY5REdwdjFJeVJMVHoxMHdDVFZHTlFQYW5DUERxLy96?=
 =?utf-8?B?c3p4cHpLSk9VUVdheW5MTXdHb00vVU51Y05nQmtjQWxhNFRHQ0tLYlNqamtC?=
 =?utf-8?B?VE05RVJCcmZkdU5Fc0dhOWtlcHV0V2psZ2U0WG9KNnZUU0dBalFvRTdzSWJ2?=
 =?utf-8?B?NjJrR3NZYkNObzc0YnpxZTNad3BqY0pwSlNDU3RQSVo2Nk5DdjVGN1JxaUtV?=
 =?utf-8?B?a215UWlYTCt5QVJCY0xnMXI0UHRXeTQyTDVaQ1BJcDBuVXE4U0J5Y1Q2L2lK?=
 =?utf-8?B?dUZLOWZmWS9GUmtOSjJHcHJlNW5FM3hER0Rkcm13ZmZ0R2NMQUVsSGYveFBJ?=
 =?utf-8?B?K0ozRDB5YVdoTHdUT3loaWFLbHMzYk1LYjB6TWlKSmI1R2ZPRytuSitqM0VS?=
 =?utf-8?B?Vnl2b1lEbUJWazVmbnNTNExQNkZRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1b7831-14f8-46f7-d172-08d9a6b97924
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2021 15:22:58.2931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uDevX24E18STDnrMAFY30vy4LzcoZRxhurWLKNlGZ8fMX0lfsAio/qEShi3h2iOnO7FhJNroN+AlkrbdBlBaXETlVAJSNTOK7m3lZPNvjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3928
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111130088
X-Proofpoint-ORIG-GUID: oNF0vVlp-mybmtyHd_ZxiwUiylD6PfgJ
X-Proofpoint-GUID: oNF0vVlp-mybmtyHd_ZxiwUiylD6PfgJ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.11.2021 01:51, Sean Christopherson wrote:
> On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
>> On 04.11.2021 01:25, Sean Christopherson wrote:
>>> -	/*
>>> -	 * Remove the old memslot from the hash list and interval tree, copying
>>> -	 * the node data would corrupt the structures.
>>> -	 */
>>> +	int as_id = kvm_memslots_get_as_id(old, new);
>>> +	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, as_id);
>>> +	int idx = slots->node_idx;
>>> +
>>>    	if (old) {
>>> -		hash_del(&old->id_node);
>>> -		interval_tree_remove(&old->hva_node, &slots->hva_tree);
>>> +		hash_del(&old->id_node[idx]);
>>> +		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
>>> -		if (!new)
>>> +		if ((long)old == atomic_long_read(&slots->last_used_slot))
>>> +			atomic_long_set(&slots->last_used_slot, (long)new);
>>
>> Open-coding cmpxchg() is way less readable than a direct call.
> 
> Doh, I meant to call this out and/or add a comment.
> 
> My objection to cmpxchg() is that it implies atomicity is required (the kernel's
> version adds the lock), which is very much not the case.  So this isn't strictly
> an open-coded version of cmpxchg().
> 
>> The open-coded version also compiles on x86 to multiple instructions with
>> a branch, instead of just a single instruction.
> 
> Yeah.  The lock can't be contended, so that part of cmpxchg is a non-issue.  But
> that's also why I don't love using cmpxchg.
> 
> I don't have a strong preference, I just got briefly confused by the atomicity part.

We can simply add a comment there to explain that the atomicity isn't actually
strictly required here - will do that.

>>> +static void kvm_invalidate_memslot(struct kvm *kvm,
>>> +				   struct kvm_memory_slot *old,
>>> +				   struct kvm_memory_slot *working_slot)
>>> +{
>>> +	/*
>>> +	 * Mark the current slot INVALID.  As with all memslot modifications,
>>> +	 * this must be done on an unreachable slot to avoid modifying the
>>> +	 * current slot in the active tree.
>>> +	 */
>>> +	kvm_copy_memslot(working_slot, old);
>>> +	working_slot->flags |= KVM_MEMSLOT_INVALID;
>>> +	kvm_replace_memslot(kvm, old, working_slot);
>>> +
>>> +	/*
>>> +	 * Activate the slot that is now marked INVALID, but don't propagate
>>> +	 * the slot to the now inactive slots. The slot is either going to be
>>> +	 * deleted or recreated as a new slot.
>>> +	 */
>>> +	kvm_swap_active_memslots(kvm, old->as_id);
>>> +
>>> +	/*
>>> +	 * From this point no new shadow pages pointing to a deleted, or moved,
>>> +	 * memslot will be created.  Validation of sp->gfn happens in:
>>> +	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
>>> +	 *	- kvm_is_visible_gfn (mmu_check_root)
>>> +	 */
>>> +	kvm_arch_flush_shadow_memslot(kvm, old);
>>
>> This should flush the currently active slot (that is, "working_slot",
>> not "old") to not introduce a behavior change with respect to the existing
>> code.
>>
>> That's also what the previous version of this patch set did.
> 
> Eww.  I would much prefer to "fix" the existing code in a prep patch.  It shouldn't
> matter, but arch code really should not get passed an INVALID slot.
> 

I will add a separate patch that switches that kvm_arch_flush_shadow_memslot()
call to use a valid (old) memslot instead.

It is actually simpler to do it *after* the main patch series to not add
more dead code that next patches remove anyway.

Thanks,
Maciej
