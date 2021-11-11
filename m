Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7797F44DEB1
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhKKX4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:56:02 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46600 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234477AbhKKXz7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 18:55:59 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABKrTik015505;
        Thu, 11 Nov 2021 23:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9uMky55qYR1OlOvOuUkW0GNg+c41F8Ev4u264bm5eZY=;
 b=MXsyP8aX+3D6VXCuVpFB98ZlnFcsvMfnHuVyAUiIzhvutBiH9Jhjyk6WMAMbC+HGtxij
 tjCEtIU6VydAZheX9fv7lynbJ41GL6pYhZK4GQuKCY97+cmXF5jJIG3A1xq+rVvkU/Vx
 KhS6E8Vy03kQyLaCiA98wGuQ9UshdWgez5POeGObVx3my0CSUNpmEhbYo4fzeZ798AQh
 XoRImLhvg2x3bUK+vTjMG6tG5IzhmCkLEapA8zlBAj/Nv0RNAeIyPGZWbjYRZGz6DKUh
 XCPnyDBYy9yayEMnqrioDRBzVTEsDSIdnIfBo/8rtY80HhB2GVbm09iWfdZqb3/aKcH4 KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7nswj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:52:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNo9CI037350;
        Thu, 11 Nov 2021 23:51:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3c5frhpgxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:51:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/lsZrvD7G6+c9DIqitWD++VAfFMr1Oy4EUfgCu/k4U7fAseDCENkWuU0lH+F7t057xMLIQhc0qYE/TUq+DQomLSKDNhkPvGVMqEbmqh2Nc4jb5o3Tua1Oy0xfwSU8QrilcheoZ6sthFe32Q5sMb4tpM6opf4xcQ1zDnfeP5gJCoYyAdnHq6uN6X9AoxG20VJJo1FFI3WwcB0l+trbrPvwXrS4hNk1EzTfk3/8PhPSiAHuq/iZ588IOI85hjmY75AWOHp+z8Kcg/ZjmE8fsIsxMlmiARi+coH7jMx2sS950Vn5j28+7MHoA4U9nT8fAn56PqmY7c4sb/EOY1YCxFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uMky55qYR1OlOvOuUkW0GNg+c41F8Ev4u264bm5eZY=;
 b=QKHbuaEpadlmzTlJAQr4rUtppnwOAaAu8o/zOYDFPzTYCazsqkbGMBuF8DIWa+eHCx/e0lcuU+wWM/AKNAQxaK8pec3UcSetU68SxNOC7RUd51G/xtx7P3/eEIuBL3UdUfCx7Ey9dVQAqT0rGHb/1f7MBRlnGAxGirDG8H0LEchRCR7mNMH18v3Ma71cQdUq3PheUAd+4HBBYrj6ZkuwXQuAbfHZAsx+YnVV4ZXdaEpa5sqeKHDErpod2agqWNQMWnCAyF6ISun5LVajfVoOpxFHNbaBzhLHjgqgNCnLWNfSNoCQ0YGscNqTbd7Db8iNzIOEq88PWsi2cEj8O4lh8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uMky55qYR1OlOvOuUkW0GNg+c41F8Ev4u264bm5eZY=;
 b=fFZ6iNIrRBxY61ROxQixMlpja0tlcVK/rqMLE17MK8aJFOwDomj0Em/qoWRsnWuTIE/a8TbLY6VQpEXFl0hPEUwbzXU2bW5olMc6Amn+vIZyNiAEiJalGhg3mpbQU6KgSIw5C9HUGHNs+bFWvq+COjWW2+52ZbO5JSYgndidZzw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 23:51:57 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 23:51:57 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 23/30] KVM: Resolve memslot ID via a hash table
 instead of via a static array
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
 <20211104002531.1176691-24-seanjc@google.com>
Message-ID: <f0b364ed-bf9e-5de9-0449-6d7ba3682405@oracle.com>
Date:   Fri, 12 Nov 2021 00:51:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-24-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0100.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::41) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.219.146) by AM6P195CA0100.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:86::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend Transport; Thu, 11 Nov 2021 23:51:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e30843d1-daba-4a47-4b8b-08d9a56e3ee9
X-MS-TrafficTypeDiagnostic: CH0PR10MB4938:
X-Microsoft-Antispam-PRVS: <CH0PR10MB493890AC552149BB75427D04FF949@CH0PR10MB4938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JciQytw7+zzssvnSnYhp/qteD3tWEqjPFfP9TDZZ9lkk+k/3fjGrfY2/HPHF9tInNqiSP4l6fE6jI+SLUGae3gNE5QWNzqLvjUp0m3K59CPp6EZN8cVFUxWbSLnkbaDWs/47qY6VWs0HNVSq9IJuN/QuMEU78FKIKlmnI3tMF0jMzDHiwheZAXui91eaIwjuIbKDHZQv7BKrtAZN9mACy7oM5jPrdBmBdT5dcH1cBn40u1tcsl4K9kJvfW5l9ozGWrRzGEn1eguoYeV1rt7mKWaryxKmDAHwDcU7E5+vuyyuwtBT9y11+QvKWaWIda1mmZtplt2/koKWGUzKJ4PPwzrV/tXJAbDlTtRWP2d9kXYYbh7R7W1vUmaP9HRoi/gRt07JeFVcxHwg1hFNT9fBkgqpzsN/aEt/T3SW9HVarWDuXjsPwiFmZMHmfukb2iR3sBuqxW///vQuUnCzjYeiDEaMQX5rRxC9mitgveUCaNODCxaPe8ffAEI1Qwr+5HjmU38ZHQxXXMrKAiggIFrvArkWVP1odwLbt0vxsK5ilzvGch7fkpQymxLHrdTUb/YMAiEsc4DtDT6HAX4+fAMrb8dSYW6XuqqXo2+1wqm5eIeoLh2B1wCwzbwiVsjPBU0mlJc08EhiuoXN+hHg8488jQ99TJv8mGHcVn12bXkvl33SkVLJ4PGsSs8UkZrsR+x1UmE4i1pxrTk/xeGfA5fA0FFNdTtE34NMyyJB/vyI4cc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(86362001)(36756003)(8676002)(6666004)(16576012)(5660300002)(2906002)(316002)(38100700002)(956004)(83380400001)(6486002)(508600001)(7406005)(4326008)(31686004)(26005)(2616005)(8936002)(6916009)(186003)(31696002)(54906003)(66476007)(66556008)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3ZKWlBYWjdNL2g1Y1ZUWnZPTUxXQ0tuR3REK1cvOExEYzlJTCtkMTNJeWdR?=
 =?utf-8?B?TlNheFpQWitaUHMrYWd2Z3QxWkdIbWcxUUxUNzFYWHFKdmtMcUFLQ2Fxcytp?=
 =?utf-8?B?QW1WQXBVakRvYzJRU0pMWWVjTlljYU13YTlpV0xrZE9ZT2UxMTJKSXpDQWIw?=
 =?utf-8?B?NExwbm1DWHo1anh2OExxako2Z3BCYnNObnh3U2VOcEdWUmY2Mk5MVE1TUlpj?=
 =?utf-8?B?S2tZVC9WcUNMUzlGSktUMUJ0NC9CUEwxSTFVak1ZcHRnUGQ3Ky92N2FoQlQz?=
 =?utf-8?B?cFlKemlHSHMvK2toYk1hVG1SekxqdExhVGlnbzFmMHVsS253L3M3VGN2V05G?=
 =?utf-8?B?SEd3dDlXTVFRVlpGR0J3am5LWkp4QURhV0I3M1lnUHZnOG8yNytmQnVGbnFs?=
 =?utf-8?B?eE42c0FOdDRGRzFIbFJDY1FiRlVJU01ZcThEYjlPeTdncWk5M2E0ekkvdlNp?=
 =?utf-8?B?NUZ5N1FVSWFBS1piT0FhMTUxYWJnSkhlYzhEaVJqa29JeVlIWWlWa2UwM2Vq?=
 =?utf-8?B?M0YrbGFFc2pHK0NJUk9jendHWWpUTk1PU0k3cFh4SXRDczR5dWZtcHVNcEty?=
 =?utf-8?B?N0JFWjZuZjRnczRxbjNsL2x0Z1JGakhkQVVPRGRkMG92ZDZ4VTFXd3d4MGVL?=
 =?utf-8?B?ZExkdEQwUmJZdW5ML0pzTWFsdHdqL0RrRnpRV0piZHZmYWNPWVRyZlNqVGp4?=
 =?utf-8?B?aiswL1FqdkxBN0tQeXBybmtCN1R3K2hxeHZJTjBOejkyVTJ1cUtBd29KRmxM?=
 =?utf-8?B?czloUGpSUXFPU1FiWEExQlZJSjBuRTNGTUwrV1oralE1WFRnUzVkZjdJM21W?=
 =?utf-8?B?RGRyeFptaWdGK0tmeko2RW9qTnorN21wNTFieWtVUytINTArc0FneVNhYlpZ?=
 =?utf-8?B?aFZyelIyMEozTTl4NWpwenhjWTh2emtBdEpEb3JJYkJnK3JQYkdWTE1qSUdE?=
 =?utf-8?B?ZjBTbFd6VFlzOG5BNnFHdVRhbjQ2ZzRBMjAyMDlTbC9jbEtNL1VKU2cwSWRZ?=
 =?utf-8?B?MkJaWnRKWld6WHFxOTJBRFNjYWpocVlSajNrWDYxUjhjMGtTRkdwRTdmM0RE?=
 =?utf-8?B?Yys5bFBSbnp3eGszSW94YlFNMk8xWjVrR08zUXN3ZHU1dFFtTkRNN3NnSjlV?=
 =?utf-8?B?dkdJcUFmK2VtS2M3V1ZUaDI5VFhOdGFKaTFacU82TXF0TXVVQWJJTkxUT3RW?=
 =?utf-8?B?SG04Nll2Vmpsb3NvSCtDZ1NpRWF2bmhPM3MyazhvN0RCRTNHQ1dlbTUxTzFu?=
 =?utf-8?B?ZFVNZ3hsbTE1cVV0ako0ekdHZWZvTy9WQ0JmaC9ldHNUSkR3cERoNWZ6SXhy?=
 =?utf-8?B?d05NS1ZHV2tOejFwcGV2U1B4RzRrcUg3TUxKOHMvRXYxRkVBTFBBRjlKeEZs?=
 =?utf-8?B?d3JocTJFR29KRGhrdDRkTSszbjVBczBpa010TCtpZk1aTkxTWXJqN0hvOGlh?=
 =?utf-8?B?Z2xLUDdQb05NVGlia0VsdnhQYlNMR2YxV25PWFlJWk0wdjJDUzY4dHlqa2tD?=
 =?utf-8?B?NVM0NnF5ckhoM1BVMnZKVnIvaFlqMHNjUk5BT2RZV1pjaGpYUDIraG10NGhw?=
 =?utf-8?B?QTlMSUwwYk9ud1B6MlJ0RmNRUTRhV2FwR3V1RWJiaHRHa1hxRkpwdExaS2l5?=
 =?utf-8?B?c20rZ2prOUhxeHB5bWVlamE0ekFoMi9IeCs4SUNIVERyUW54T3JnSDFRMnZp?=
 =?utf-8?B?eEt1QklFbzd0anpFc0Q0WFdxRTJweXhENEkrU0JvZnB5NTdISytjVGgzUklW?=
 =?utf-8?B?SVl0OU1LY3RFN3NCaUlRRDZENnNnc2lRUGRWaXl0cENJcFNIVG5RODdrNmw5?=
 =?utf-8?B?b1gxMUJYbkhzTml5Rm0yQU5zOTBlVEQrdVlNUUh3U3ZucDRzNEJrVGd4VE5o?=
 =?utf-8?B?SDBnKy9CcDY0dy96bmVzMXNGSVo2SVYvelR2N1JPRlRYb1c4WjQyMGR6WU4r?=
 =?utf-8?B?MitVanBKUGRZeFEzaFo0dHpuT3p5T3Y4OHBqdGozRGdST2JRWmp1NDZoRVdJ?=
 =?utf-8?B?MXVhQytGbHo5ZVArckthSVZOOXlxaTRDdG8xSVhTQ201QXp2WmY0bjZ2bDNm?=
 =?utf-8?B?WDVvM2h2T3FUeFZmRFd0MnhGMTAvMTVqRE9iZTl2Sy9oaytFa3lvRkUyMHpJ?=
 =?utf-8?B?RmQySDZJc0pkWVB4Nm9uMWZ2QW1RYWdkNnRTT2hTT0FoRVVOS1h3SjRPYVZ0?=
 =?utf-8?B?QzlEdWptQmtFYWNGQlhSK2lDVUlhVW43T0FBUkprZENRNW5RQlVTZy8xZUVp?=
 =?utf-8?B?M0J0NGI1ckdydXpZNFIzaGNjM0xBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30843d1-daba-4a47-4b8b-08d9a56e3ee9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 23:51:57.1817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azHd9qj+0UtomEB0BWYqo11FcyS5MZnu9lMA8tXIJkhL2+eIjlyMNI3sAVX8THhszztWCIlpvLqeHZRSGh84H5axOusSWNy7AuuA6zuZins=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110121
X-Proofpoint-GUID: hVGcF-rOAkFRn2UikYu4Yw-pb0p-cly9
X-Proofpoint-ORIG-GUID: hVGcF-rOAkFRn2UikYu4Yw-pb0p-cly9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Memslot ID to the corresponding memslot mappings are currently kept as
> indices in static id_to_index array.
> The size of this array depends on the maximum allowed memslot count
> (regardless of the number of memslots actually in use).
> 
> This has become especially problematic recently, when memslot count cap was
> removed, so the maximum count is now full 32k memslots - the maximum
> allowed by the current KVM API.
> 
> Keeping these IDs in a hash table (instead of an array) avoids this
> problem.
> 
> Resolving a memslot ID to the actual memslot (instead of its index) will
> also enable transitioning away from an array-based implementation of the
> whole memslots structure in a later commit.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/kvm_host.h | 16 +++----
>   virt/kvm/kvm_main.c      | 96 +++++++++++++++++++++++++++++++---------
>   2 files changed, 84 insertions(+), 28 deletions(-)
> 
(..)
> @@ -1259,17 +1257,49 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>   	return 0;
>   }
>   
> +static void kvm_replace_memslot(struct kvm_memslots *slots,
> +				struct kvm_memory_slot *old,
> +				struct kvm_memory_slot *new)
> +{
> +	/*
> +	 * Remove the old memslot from the hash list, copying the node data
> +	 * would corrupt the list.
> +	 */
> +	if (old) {
> +		hash_del(&old->id_node);
> +
> +		if (!new)
> +			return;
> +	}
> +
> +	/* Copy the source *data*, not the pointer, to the destination. */
> +	if (old)
> +		*new = *old;

This way of writing it (that, is re-checking whether "old" is not-NULL)
suggests that it could have been set to NULL inside the previous block
(since the last check), which isn't true.

Thanks,
Maciej
