Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD744DEBE
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhKKX46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:56:58 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5744 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233025AbhKKX45 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 18:56:57 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNFMdm028574;
        Thu, 11 Nov 2021 23:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NbvHRwciHoktRiMxL06o1ay5beCoi2/5wxa1jf+nfdk=;
 b=Y3TSDU5Kn7ZPL+e4D+1N2/yasVbRlQEupRaYB+r654Q3RkixxeCxzlE2JABWcEbcR/YL
 gme3CqypzJxsvL/ApLJGKudmXTqh7FFyY4xVXB6AsrXlmnkwIrTB7ey1AjQdJ2eHPA23
 od6UmZ0CxmidyPZ3hNVKb8unw0zyTDeCZ/KrBSzRiKLirrXwi9XZcx5vYA5kGyFSae+Q
 NTYyeYTSWU2spY91XKBehIljqk78gVIGvCM17mSVTc6JbXuqsiOM65EabVUPht2/i0pg
 3gD45eaRFVn4QyD67JP4lhfWY0WWj7Jblo63mmwFn7VFSwfcxc9z8OAtrEFLw4WI1pit mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c87vxv1pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:53:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNo9vk037396;
        Thu, 11 Nov 2021 23:53:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3c5frhphhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:53:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxLTl+o86hHhUBsS9mOo9xhcNVkBqkpiYNw6+W9rPgfBwvTXfwoAm/HyJJ6+Fxq21UwpzaKS9eHIlOkbuIqHx86FIlv2pkyZnASxafJ/+6qYtCVjKO5rWBlY5raMlrqsHrQxe3O6elN+wdsgi1fYwiaP1FOE0ztq646ctio0eRjmNEVWFRsaKQA02s/R+g3Ibj/JyQe7uyvvqyLVqg2ijMkGA+HtJKpWz0IOuRziN9edRS0OhjnrK93MVwZVK/qGhqyLsPWizWfCz2lsXvLt6F8xFZ7/UgS7UmjMagnqEqBW4priz9xi59RimYo7C+gMIZcfIzZTZUC0HhGeONuaHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NbvHRwciHoktRiMxL06o1ay5beCoi2/5wxa1jf+nfdk=;
 b=dKCe5orPqfKZJChyTxwTiWdgRGK50rAnkytv+z8KnsBjwdqiwKIykzPRhVKK9vMmqevZ1CQ81YpnPtbQaEb27KcUKGhnc/RW9AsPm+ojR2aX1o8EknqgMCkYtqLw86W0YOTBiX75XFwEY3ukajlddRrwz8BTVWABqfTgjlyHm1qFwooa8htt4+A/uZ7UL81CyQlfISCj5/gF1w0ywm1uNoLXx0y9mk+aKJcub46YaBMzWzwGH6NaYRuC6Er0gOocl1axPiHKmI72EHVw4R6pBU64rhcFgHDjS69NCoNX25wVoeeOZGQDfzt2fzFph6mCsyI/cqRTZR91DPxVaF56FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbvHRwciHoktRiMxL06o1ay5beCoi2/5wxa1jf+nfdk=;
 b=yk4G4i7K8jev9COd1qfHXRKJXy/Gns8Is17QT6tYxkqS6ggJXSitDiIKSwVCVIi2LK12eC6vV/J1jD33iEFLiQMeN2fXm/G6qVgccOhngODNopBQDDv+wpSFHMOGsYCks/RFkDqWML1BBPyBo9Vwq5c3OqFma2ZoivK47n+A888=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 23:53:19 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 23:53:19 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 30/30] KVM: Dynamically allocate "new" memslots from
 the get-go
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
        Ben Gardon <bgardon@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
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
 <20211104002531.1176691-31-seanjc@google.com>
Message-ID: <fee75f86-26b0-2dbe-770a-8ecf5cc9e178@oracle.com>
Date:   Fri, 12 Nov 2021 00:53:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-31-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0058.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::32) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.219.146) by AS9PR06CA0058.eurprd06.prod.outlook.com (2603:10a6:20b:463::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend Transport; Thu, 11 Nov 2021 23:53:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31902282-cedf-4e13-3e6e-08d9a56e7012
X-MS-TrafficTypeDiagnostic: CH0PR10MB4938:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4938C8257CDA3CDBE6D4E913FF949@CH0PR10MB4938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uUQyvsWH6je5jMV51QfGJXxOvF9OgZquYk/wCO7R73lgtHNRpIyc5ckY03cs7AnIo5L7zg1XGLTmoA6LnvIZjU6OGLdHl+pcOHq1dHAjpDYTIn2ZxaMYHVs1cLjXCpKGNyIbRjh1X+QRzS2nEEPCahbBs2D3i+2So+QYvJLpoNfQNDXjqRi1QA9KvA1ODJXH1HfI6BRLTx/2edyzUDgEN5Gss4OfTHAnICCxiEXgaojrsOdtIUFQiovVxhnCULO0nb7nJpI+a0EppFuyYHFnuxWrAvrErYITIogW61sGvlzgAOzdEezzcGKeLhG7sm/v38nVVefRstzPF5SfsJVxkQIjAYlhm1JfYOR3U+tv818oLfZDcmK03150S+OKkuj7SX8Zqa92g5g0FUMUv+DEwvPVAFSEeWebCSeqCxhUD4WJrOQ40MDUZS2tJlmFHcKbcClWm5yggPXjeTCHgQIK7WE8Q38xkabrptsBi19nfkous3OAZnXJHwDQVqzzZFOWgLhDHtiK32FCBsnznI+ch+gxiDPZRrRQ8vo+BxigfQRHpOjhCrxYq0/Y33fmWuPqdiym6dlK5h6i9NU5lAqBuv+rq6rRw988baHQyf39yupGxFb8EcC+5qrudY0L03Ci/Dgj3TcrcxCljer2Cf9r3xU46qi1UPfKLA8cYZCSig4I4pyO1eyj2scXVRl5WjQFbSDPAOfjgVLMvESejfYKIr5Rk3xpJDLbjQY4NlB555g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(86362001)(36756003)(8676002)(6666004)(16576012)(5660300002)(2906002)(316002)(38100700002)(956004)(83380400001)(6486002)(508600001)(7406005)(4326008)(31686004)(26005)(2616005)(8936002)(6916009)(186003)(31696002)(54906003)(66476007)(66556008)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWlTQUNGTk1RWkFITUdFaGhZQXQ3MVpLSURsNng5TG9mRnhHTkpXRE1LL0Q4?=
 =?utf-8?B?VVZoQnZZT1BIVzdsQ1dPM1ZqeGRyckdsakJldGpFNHVXT2I3djZZSlpIT1B3?=
 =?utf-8?B?NUlWa1FsbzhRZlZ0K2JvSnRGd01FczFXTVJaV1BROWE1WHMvZFdkL3piVkdK?=
 =?utf-8?B?Z1o4bllrUkpJVXZKY290WUY0c25MRkZnZ0U4ZjlVcU9iNDYwazBwa1hQSG5r?=
 =?utf-8?B?eU45QXhQZ0ErWHRKTjdHZkwxRmZnbXE3aXlzT0s4OXJMdEprK29VT2ROd1Ft?=
 =?utf-8?B?VlBwL0Y5YUJ2MGV2RStVSWFJdEIyaGZFSjlrZEVQU08vUWZmN0pyU0FSbVZB?=
 =?utf-8?B?d0kvejNMazBOa0I3TDM2WFRMUmxmSlQxTFl3SVEvdTZMcHdXVWYybkNiMXZq?=
 =?utf-8?B?MHR2VWNSTmFkWUZGNG1zRDk3M2czZUFBVEV3aVpQQkkwM0xNN3NROG1aayta?=
 =?utf-8?B?NnF1bWdXMmJ1YkttbU1vTFpFZGt3eWJ4RXhQZ1VzMmFBTVJqS2dCVEwya2RN?=
 =?utf-8?B?c1VlSUVMN0VaaklFTFNOZ1l6aS9RQVBlOVNsYXhGR1RRTTJLKzZPV1NmWGVG?=
 =?utf-8?B?WVdCUXRqaVNldlN5WUErSk1qbGtuUStyZzZ4TkUzQUpWUEdFVXJoalYyeWZ3?=
 =?utf-8?B?VVQySThrSXZJaEY5LzB3RzR5aERiZTFmNStyWFBoQkxNRHBabmpFNTNLVUJl?=
 =?utf-8?B?YVRGcWRvS0VvckZHWnRNaWN5YUJGRmp5K2trdHM2aHlVN0U3MW5YTFRIdFVX?=
 =?utf-8?B?SzdBTktqT2NTZWVuTXZwM2tXb0w3clhOcXF5em5wNUt5NUZTVDVUSUtiNWhN?=
 =?utf-8?B?dWlDY0hUQnEzV3crN2w5V0RNT3dVWXRiY2pEb016VFJwVCtNRHYxZmxLb3RD?=
 =?utf-8?B?ZFdrQnd5ckhtV21KT1RHMUdpdnFKN2NPK0Z6YktKZ2NnUVV1bjBaam9IMWxr?=
 =?utf-8?B?UXZzZWpEVC95eng3aHFxSlBwOCt5MEpGUGw2T3BFZUFtbXFqR2J2dGpmbzV1?=
 =?utf-8?B?L1RERFVHNFllRStsMFhCcmxUZkszeVdkMzJKUDJVc2djMmhCUk5RRXdvUGU4?=
 =?utf-8?B?UW9aY014bnlLVUJSVGgxVG5oMTZ3WmN1WVBpbHZ0STl5NXdVRnhmWWZNc0lY?=
 =?utf-8?B?QWtNRExYZUVtZXM1TURNVjdOY2tMaVkvaWlBbHRNMDRySVk5cDJjQk1iVnlQ?=
 =?utf-8?B?bEhKTGg1VCtNSlhBNm83MGhlU1VPK0hhbThBQ2huZmlEWnNCbCtMVE1Rem1B?=
 =?utf-8?B?ODlObDNSWmxwQlcxa1IybFNMbHlnWGVuTW1uWDlYU21mTVhnaUczclpZK0VH?=
 =?utf-8?B?bFV4OG5wWUx3Q1J0WlNnY3RMWUo3WjlnOGE5a2VjQWZxSkNXeURoTE1KaDI3?=
 =?utf-8?B?dnhzZVBiMStma2MvZS9qUmlkWm9SY3dsdnZHc2Zma0FmKys5VlVlOHhud0w1?=
 =?utf-8?B?VFovT1dIeTZhWWNrUW9rOWtQYnJmWUFXeDUxVHQyMUpqdUVIeFZFVlk0QjNv?=
 =?utf-8?B?azFJeGtVTVZFYWhnQ3kzR3hnNWJPQTdHZWpNMkZ3R0s1UnI3eS90UERHZ2U0?=
 =?utf-8?B?VlNZc3BteHJjNmY1WldEK0tNNjZrYy9SWExNRUVDNHkyd1M1MXFIZjlSNlAy?=
 =?utf-8?B?RXdCOXlYZ0tGR0VqbVZjNWpWZlQrTDlSelQ3SXBHMjhPd282SVpjODdxN3d4?=
 =?utf-8?B?R1JPUzM5UHczY2dIR2FRRTByaTAxQksyMmxURjhrTFkrb1pPSmt6STZ5dFJG?=
 =?utf-8?B?NnBaZzFCNW1GaS8zSG54bEZMU2FHMFl0cDJVRkFoNGJCK1JqbHZXUWFHN3F3?=
 =?utf-8?B?V1hxRnFaZTZVcUx0RkJQbXpMc3lRN1Z2SjMxMS91amxkNFlKOUIvQ05DRzBT?=
 =?utf-8?B?U0FONGUyT2Vwa1paSkM5RG96YXlGZ3FpWHJYR3VHeDBDTVZaQ0w4aVQrSkRj?=
 =?utf-8?B?V0s5TU5uNG9JVkJ2a2REMkJGRksvNkppQzZzdUZ5cXhOK0h5c1RKclNOdVRs?=
 =?utf-8?B?THhaMlRHQ250T1hXdTZjMlNac3RZRGtRUlVLdXYrM3Rqd3Z4eUhkUnVTaS9W?=
 =?utf-8?B?aUtoam9SNWZaeFNpTy8xMElkdytQdWZlY2c2SDJ3R0xVS05NWGxtZE1LU1Bs?=
 =?utf-8?B?QzR1WWM1QXZ4NkZkaVZLdlNmY2YvSUZGckN4WjcrNG1kM0lVYXVFOW1SMlVQ?=
 =?utf-8?B?YXI3NGNRRUpiM3c2ZWg4RTFpNVl3WWR4KzZmeVArNW9IejdFQ1ZVUlZhOVh5?=
 =?utf-8?B?RkFEQWY0aFhkcmxuV0h2NlF3ZVhnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31902282-cedf-4e13-3e6e-08d9a56e7012
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 23:53:19.7123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1gXEZn22ljodnmAKtJcXSa5JZYL6LHG6C7KkkN1s0YoJZaMeNbMmMTwvLs7j/2arEqrashPtsC9UT8LHsLn51ql6EV3NaHC0f4c174c3xA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110121
X-Proofpoint-ORIG-GUID: Hqv2TD4V1sNbUIxNHCboAaYo4hREljUd
X-Proofpoint-GUID: Hqv2TD4V1sNbUIxNHCboAaYo4hREljUd
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Allocate the "new" memslot for !DELETE memslot updates straight away
> instead of filling an intermediate on-stack object and forcing
> kvm_set_memslot() to juggle the allocation and do weird things like reuse
> the old memslot object in MOVE.
> 
> In the MOVE case, this results in an "extra" memslot allocation due to
> allocating both the "new" slot and the "invalid" slot, but that's a
> temporary and not-huge allocation, and MOVE is a relatively rare memslot
> operation.
> 
> Regarding MOVE, drop the open-coded management of the gfn tree with a
> call to kvm_replace_memslot(), which already handles the case where
> new->base_gfn != old->base_gfn.  This is made possible by virtue of not
> having to copy the "new" memslot data after erasing the old memslot from
> the gfn tree.  Using kvm_replace_memslot(), and more specifically not
> reusing the old memslot, means the MOVE case now does hva tree and hash
> list updates, but that's a small price to pay for simplifying the code
> and making MOVE align with all the other flavors of updates.  The "extra"
> updates are firmly in the noise from a performance perspective, e.g. the
> "move (in)active area" selfttests show a (very, very) slight improvement.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

For a new patch set version when the "main" commit is rewritten anyway
(I mean the one titled "Keep memslots in tree-based structures instead of
array-based ones") it makes sense to integrate changes like these into
such modified main commit.

This way a full algorithm / logic check for all the supported memslot
operations needs to be done only once instead of having to be done
multiple times for all these intermediate forms of the code (as this is
a quite time-consuming job to do properly).

I think it only makes sense to separate non-functional changes (like
renaming of variables, comment rewording, open-coding a helper, etc.)
into their own patches for ease of reviewing.

Or if the main commit was unchanged from the last reviewed version so
actual changes in the new version will stand out.

Thanks,
Maciej
