Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303A0449FB4
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241328AbhKIAmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:42:21 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60072 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234358AbhKIAmU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:42:20 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8NxCYN005904;
        Tue, 9 Nov 2021 00:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6S8ikrJoIVpovO7Fo+DU1sNA7KhVVaD4L3oYAUG7Dbc=;
 b=lUiXtlzQ72pB/Ba26E5WzR9/r+XYjScxbTdQP7RMuRReVh7wDEDgLPrUaMFaqcDrlG/v
 rjPBxP5kd+hPdLCCLo60Rr0z+H0No2O2MS+mrEvfU+xFbOy877QOPWhwadomeRUUOYCK
 k6ZkDDNv4/Fl7KXaCsOHarWrUV/MHOj0J/lmVPzc57z0A/HeRGduiYThi+JaC8k/9D8K
 m0WFpMuh9qr7DkQT9/kavulHbp5ST2dLtJ0o3HHScZa5J3eOU1cPy4TtKEiNYc6j6/Au
 S6KazDDfXWB5u8Opo4XoyBciZ+M8av1V/LklROVg/HBOEOpyv8SBehtKBD/NTfpCyBR0 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6vkr01tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aEgX062892;
        Tue, 9 Nov 2021 00:38:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3020.oracle.com with ESMTP id 3c5hh2v4bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahixYWM293QtbKkgQQ20J3J0gpLImlCLJuvHnANjMtAUdcJyqdP96adxt/EVc+RmIJDoDRjhqiXYNonQ+VujjauxJRDJ6fa9rR8/he0FnZKg+i1xNeupa0QnkQWm9kjlHlBhloMr3fmkAErbTS4XNxcEk/m3c66QmAly1nLagg9IcylD0SdhENehcscFg0XplN0bG0Z9MOyeS8ULBeo7qyzgm6miSVA7WED9WWJzB5vXp+KNOVPJYmZb+1K8l1mxOfp0YR0Wuai8PWVCyTyebUXP8U1zOO0gVo7FhAs+X374PWtugqrhB1iOzDMpAnNmyQp2DAqyStXAlXlsD5UggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6S8ikrJoIVpovO7Fo+DU1sNA7KhVVaD4L3oYAUG7Dbc=;
 b=n2eGCrEVHkRU+Eaq/luDEVaixoMSBrdqpdfSplN+dU3dpXy4BMZJ6bDyDBkBPjyu68nBzihHMDlTgSU9cPCJLEAtojoHc9SsG/w6w3M9znCk4veTOgDg9Qjz8p9Ta5+VQtjji9ID831iXgobeSAvRbWZERsb4rDCGKrN6sV/RuzL+jQwSzEVaAcxA4sBnlzcenbEk2SNfIRyma9rp0Xv+bRFZAIwXDpiZtrJvJNz4PFabWEi941Q3nsJgqIbldNN705/k5e/k4Jkqsl04nc36khwBAdfkNka470sftcn+B/arzdbj+VmnmLgGxJP5no6V+zZ6gyn/GnkN/VhBSHheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6S8ikrJoIVpovO7Fo+DU1sNA7KhVVaD4L3oYAUG7Dbc=;
 b=eI1LEsBnOGOKVS43w/a1O4vUoFqV9++DUGLL2Xme44t+uuNhNgmy5MbYcVHrq0yzb9TDQHHP5YkMqf09tJBP2T4JZWauXA6uxqDByXtqI5cymu8dJrQPiRVsEHJwNhPayRr1I8kMJvbEyTqWVXV7rz7X1yZ/R2zDeknS76VMJTs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4972.namprd10.prod.outlook.com (2603:10b6:610:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 00:38:46 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:38:46 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 04/30] KVM: Open code kvm_delete_memslot() into its
 only caller
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
 <20211104002531.1176691-5-seanjc@google.com>
Message-ID: <94ce4359-a87b-cbb1-0d47-acc5257d97b6@oracle.com>
Date:   Tue, 9 Nov 2021 01:38:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::17) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by FR0P281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 00:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc1370f-eaa6-438e-35ce-08d9a3194a2a
X-MS-TrafficTypeDiagnostic: CH0PR10MB4972:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4972FBD43F5F36D1F0B2DCA1FF929@CH0PR10MB4972.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRGxA7y5UieQs0JnuLc67/VcLB688T0PpxMW443gjoY2WH9dZMwkHyvRthA71pBX5bfoqDYM2wnje2x7lpV4iinZMJnB/F9aj+jE9+V56yPNUSNTlOepJlqfGoorWn+EFa68/1HqV0N9+xO8ZMW8YtQaFHmoI/fPVGrZy01h39CFEHxTx0lO3phc0w7SYJL07q41H+V01o6T34TNheG/+7tpjAawuYVLUDWhCipMN64dzGizvQPW4J1Jg2P+DAVUqxnl99nGtm6F75/seR736MaQaNSB9MIFFB/ivgJ7/kIwlZphFv23Ow6r+L8aDsmivJir7U87fhsX+/5p2Miw0qlQ0DiIGIQd9L/qLdj4iC1316soHK6QKnCwSngNer+vvzdoVdMsbH5yIiS4GUdBifisvQVXfsqlH9xCOmgY9WIq1k1izrovxR1Mo8bPIP99e/mynOCRzF1rxHbqh0CerQflKF7qowKngJCcr96estmwUKx4B5ArdbmB5GpdV29/HjYpwLHCMAAK2MZ6/PkDHFZUy5sLB8BjsJfqqROvkRb3YXd6aYm7I1bh49Jv7/p265Bv054IDOyTcS05izE6CPPuh9s5ihbZbvEODA6NMP+ymBdYxUmczW/0k3Ui2yhgZkML54uDnovrLVghbGsC9crGtWBpwX/rbo0wqshjwM1BrEHx9eKxBb5bWRwG8hN1GNvxmAMv0FyeySZnm0JLYO6Va8z0NVxuvJ3Ieg7qtIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(86362001)(83380400001)(956004)(2616005)(6486002)(26005)(66476007)(8676002)(66946007)(54906003)(186003)(66556008)(36756003)(53546011)(38100700002)(16576012)(31696002)(508600001)(316002)(4744005)(6916009)(8936002)(5660300002)(4326008)(7406005)(6666004)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnhZaGpZaUphSVNOd1F2WjgxbWlyc1IrSmZUdE9xWWFmZ0JJRTA0NWZZdzBX?=
 =?utf-8?B?MWxWM0xmbjFZbXZBdjNZaktmT3l4bzZYMmlMRVlNRWJPQnVpOFlSay9adWpq?=
 =?utf-8?B?N0dZQTJxSEM5ME5ObE5mMUNvbXpIWDVTS1J0T3p4aStQMEpsMjVvb1MvcDg1?=
 =?utf-8?B?SlFDbVRDL0tTRzRVOEE3UG0xanB6aFFjdUxDKzM4aVpDcVo0Q21hdTdNYXdC?=
 =?utf-8?B?cll1KzNoeFYxQ3Q1enZvNWJJVEhGK3AzZ2F2d2REdENsRTh2c0RFU1ZKc0dF?=
 =?utf-8?B?RmNTWkdaWjJPeUNPOGVFN2hpV0FjbDE2RkpmMFZxbjJlMlJEUklya2IvUEJr?=
 =?utf-8?B?WmVobi8rcWFFZHNxakg5dnpqeHdOelEvZUJxZTIzZGVzQmVXdmdJdUc5UUh2?=
 =?utf-8?B?UU5KbDJrZ1ZhL3VQQTZCMjlnbEtOWkc2OW5ObnN6MzdwalY3OFEyVHNOalFM?=
 =?utf-8?B?VzZkRk40VjNlSTFZSnpBSUF3M0VmblNrRjVIZ0Vwb2dHUmxJWWpGb3ZvK0ov?=
 =?utf-8?B?UmJKREZDVEtvbEk0aFZLQW9HV0cvZ1NxQWo2Z3RweXVFMFNIWmhJYVVGYUp6?=
 =?utf-8?B?WWMvSGdKbTM3eHRlTlNrR0pkaEZsbEtYV1pCQUlwSEFvNkpzSTEwTWwrejlF?=
 =?utf-8?B?YmI1a2Vxc3pTR1ZRRUtvTHZJdC9JT25qSGc0cUxzZml2OEllb0c4U01aVlFu?=
 =?utf-8?B?MU1iajU1Nit1UFl5ODc3UThrMjRPTFVYUk80UTh0Q1lXQzRpdHRUditLcUw1?=
 =?utf-8?B?R1JCbld4amtVaUVyQk80NVkwcDhaMStMaDJHY2o5bFZnbjg0Z2RUYVRIaHpF?=
 =?utf-8?B?bHFBbC9iWXBaVmZrQkFneGdMREl4VG91M1NzNUZqYnJhMEhFZGF5bVl6RlZB?=
 =?utf-8?B?MUV5ZUpwbVNtekUyWHNBYnZmd1dkMlBMQ3N5RWpEWEFSVkJGNndrdUh4TGVL?=
 =?utf-8?B?L0s1S0JwNW95d2FTcnpOS2pwY0hiSEkzNjY1c0lGUUVpbm90VVhkU09Mek1J?=
 =?utf-8?B?b3lWN0JRWitRbHZpSGRJYzkzYnRMNEV3S0NRWEZYeGtFQ0M4N1Z6OXJkdjhR?=
 =?utf-8?B?cGdPK3VVL09QRUdFTWp4YStuTnVHcXo3WmduUFFKQXZBZ3dpMkZydkZFZGty?=
 =?utf-8?B?Y0xFVWVuODNzcnRTNnd0WDBZMThxUEdIWGpDRDRKYm1qR0RTTkFEdHRPUFJN?=
 =?utf-8?B?aEpHcUNaVHRHRXdaVEVmZEJLNVhXTzBVN1FqNTA2Z29jRk9TTHhmRFdnSkdj?=
 =?utf-8?B?ZktNTm5WRjNoekNiOXhOVnJlWDhjMjBWam93aDkvWHFOSXMzRktZc2NaT0dK?=
 =?utf-8?B?eWZHN2Fka1RMeDBNeERreDZGdzJua0lmamdmdm1MQjhpRzdBMTdjbEUrekVa?=
 =?utf-8?B?cGFqSXV2SmIwdDNvZ245amw5RXMwZm1CMkhMYU41SVFNU1Z5RkxpeERxdUJr?=
 =?utf-8?B?YU1lcE1TNGVBMFFzT2czYUJJaitPbmVyZFp6T2hWVjFPbWVocWpNTUJLY2hI?=
 =?utf-8?B?ZENoVXl0Wkl1ZzIzRmk5eVpMYWM3eGxkRXB3UEFHTENTQnVyaW5wRmtMNDE3?=
 =?utf-8?B?bjNGamtiMmpMMlFGSDRrdU1ZdStqZXZXWGtwTFBxUE9CMlZ5aVhLeG5IbjBE?=
 =?utf-8?B?bXhZZzR2bEYvajBBVXcyb1JrZzJNUkdyQ0J1bWI4S2syUFIzSm1BM3d5M3FK?=
 =?utf-8?B?SjQwZG03dFBXa2FxNEdrblRrbnp4b1UrVGE3d2FMb0NzeTc5RjkzSFFkbzd1?=
 =?utf-8?B?VVIrRCs5SkcxQ01zZlR1cjlHR3d5c3dMTXVBaWRHVm9uSW84ZWdsMTc5Q1JW?=
 =?utf-8?B?eENpUVJ6NXh4N01RWlNQMDV4a1NxaEliQ0FCaW5tbEs4OSt1aTYrT0NjbGtl?=
 =?utf-8?B?SFYxbWtDNURoQ2g2eS9paWk4V293N1NIMUlJYkFmV2Z3UXBqOVhhS2RHT1lY?=
 =?utf-8?B?eE92WTRwSXE5NGhFa1RDWUVxRDhnRmYzM1BXWmZBeHZ5UUFsOEJoUUkvSzZH?=
 =?utf-8?B?TWc1d1hEUHpQQ0V1VzBYRmZtUkI5Z0ZpbnEvV1BVRks1ZmpnbFhQdkZZQjdU?=
 =?utf-8?B?UkZMM2tZZVlZYWtkRWVmVXd3aGtFOGNnNkdrclozTkYxNlZGSUhoNFBqN2R1?=
 =?utf-8?B?ZGtLNjhOS3lhazVVVDBxOVc0M1RSOE8rWDFrUHBSSkpocnpnSDltS0h6K0Fu?=
 =?utf-8?B?dlBMQWFTbCtLT1k3bVd4alFHUHltUE8rVGQwRzRveW9WYkNqQkNqMXhrUjZZ?=
 =?utf-8?B?akVVZGhYZFJyQU9uU003VU9IOVpnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc1370f-eaa6-438e-35ce-08d9a3194a2a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:38:46.5994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LuNPicQP+1kiRpgn3FkT8NioYe8mLEf2TVbYwYuJGnYEAmQKQHCRw9XXlyDgFG5AJQ/FtyBNxJb2+BOwthvkvLW/9EWXiE3kmkDvoz77Ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4972
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-GUID: 8mk2pPjupQ8kvT71pHe8dG2G_kvixzS7
X-Proofpoint-ORIG-GUID: 8mk2pPjupQ8kvT71pHe8dG2G_kvixzS7
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Fold kvm_delete_memslot() into __kvm_set_memory_region() to free up the
> "kvm_delete_memslot()" name for use in a future helper.  The delete logic
> isn't so complex/long that it truly needs a helper, and it will be
> simplified a wee bit further in upcoming commits.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
