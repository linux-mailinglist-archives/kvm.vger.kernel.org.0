Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954E346C436
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbhLGUMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 15:12:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6660 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229867AbhLGUMi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 15:12:38 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7I4VWK029722;
        Tue, 7 Dec 2021 20:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eaJXqnMrh9u27uCAfKpy51HK4RccmEcHswHkC2pyENM=;
 b=lHjWv3b5cYAmikbZitmC5LJbwnwXO4yRVAOYN9DWlSz5T2jobNJS/KXO/eK5rFRNwTX9
 4t05s1LfJJvYBieV+Q8h1WYrGfb7u9IYsiS3T0p2tL7okUv/1URkok5JUxEA+uArWTPH
 sSz5yCeokkf1BBNA62WbRGtkoVp8Br4ft4jvFQdYa67qdeg2mNu4D6KvsAsk0XmNZpbj
 YiThs7vgF0hPVkeL+IOOpqRHIbtbjVrm+OWRJBYAoxcWh7yykX8mKuM+a2Gmmcevy62/
 jSYJ7XsvPjDJKc09smyDeRPlKN2E/5JW/B0AMthwUBZxCVVjCHYyLlyp1yQz5bDnxucR OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csctwpfeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 20:09:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B7K6iM2164607;
        Tue, 7 Dec 2021 20:09:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 3cr1sphq8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 20:09:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuUbRISJkuob6ie3OkHkOE8jG5AdkGaJWYGhw13XLBd9PeEzJ6ix+Wlcqz4SGgGHYibt6HaC7M3qAWXCmKkdEOE5mKykjm0caL86lfE+47+Wf8Jz0OejFLP5LJCvFb53+auG80J3LfdZQW/gimfUfMBQHsCquOXJY0tV7r9EAOcYOFrpqEfQwXAkwUJuvIYyZZ3a+WDYxuQhWL2H8vUl//ZhvEygffhprJc0kWjRWBvDSRpPYBZjEfnIWNgtF8XQhvyqE4ASFxfvmZdPreqHynnnkYNiIwKJlEhfUq3+0Ornta2Fwgr4UCwRHNWyaC4Xp/HX0op5I3Ti2ltiHEU9wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaJXqnMrh9u27uCAfKpy51HK4RccmEcHswHkC2pyENM=;
 b=Si5Mt3BZyKkOL8gbT0uiAtY8bMjIZSnUEZZBCrFfZ0dJzvtxpP/JpKhS4l5PYzbdiBlrjYtGpH7QLXMMVbVjiTUhfiwom6uH7WuNPDPCiF6dHormpRlgVAqiszAyAQu8Z0Vcrn8zoaZ+YVqZBThKDHGKrTWf3wcyT70HCsL4cVHzgOs+E/sT8uOzf83ni3jsdutk6WrhXI9Gw1ORY6sGqz2GIyjCXeTtecJIxrggMvGa8K6YmtnNXkCpPyR/jymOrZgqvfQ7GYUXVFh0D/xUj7goBLk7cbvP/I0P55qiTAy21mlingREUBCMcynvpKJFH+ZtsUHrlObx6lMT/1ndDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaJXqnMrh9u27uCAfKpy51HK4RccmEcHswHkC2pyENM=;
 b=O0ZjLTTqOIBz+p05W2z828zBr3ZexJm5k2zFXaT/4mUdekN8qX7vm9UmRJXe6BKZBX3aB/VfQf1+1qib9799IOyQOnHATTl+ddRl3etbkKRBkXJuFY8TfkdXs8UFJVVI47HFwxs/qUbqLktYB+Xc3uo8L3rrBAJQAu0c79cnkqA=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2621.namprd10.prod.outlook.com (2603:10b6:805:49::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 20:09:00 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca%2]) with mapi id 15.20.4755.023; Tue, 7 Dec 2021
 20:09:00 +0000
Subject: Re: [PATCH 1/2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
 <20211207010801.79955-2-krish.sadhukhan@oracle.com>
 <CALMp9eS9_z6_47nRTaj4+dygzwA0-DsUT2UGMqjb-GnqEWHEuQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <594c0c00-f0ce-9d17-157e-242ad91f69fe@oracle.com>
Date:   Tue, 7 Dec 2021 12:08:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <CALMp9eS9_z6_47nRTaj4+dygzwA0-DsUT2UGMqjb-GnqEWHEuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::13) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SJ0PR13CA0188.namprd13.prod.outlook.com (2603:10b6:a03:2c3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 20:08:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ee2d83a-350e-46c5-6a7c-08d9b9bd68a3
X-MS-TrafficTypeDiagnostic: SN6PR10MB2621:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB262187EA8FA0921E1F8B6565816E9@SN6PR10MB2621.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aOnyIi3vOzQyCxBAt5j0Kl9C0yBc5AWc2hsqhuQn317UnW28//mpe+Ox2ad5kaoVUdUHn8hRBTUnBfwcgeZYtpJHx+P2HYIdMnKq/edtlAJWjfV+lXh/eGoyorS6rdIHP/g7s1/qE4p1kfrIzIeeBAxTnInrDPHBOXfjcQ3yEd2gu23S3SyS23GTE0dGf+c9ES7P40lEz/gkRZh7IezmVRm4YitcQ2aoTerPA6EHmsyWGK84/wqDRR5dGEH/9uvjUdpzWcsMpGTZ8wKece/MDQ3qB6Rn4brpmTYZh+vlMwJj9W7yKclOEhfvtvpQzCglPHp9JTAHp5WCYx1fo64Tksaq9fDLrzFmdW/+VrYJYhE9l+oa/O7hzvqUKokAQISefaGQt/89VsGE6RuWv8tbFsIoMDYexLAQ3d3tsQV7h+BmL6f/qBmiya8t6cIUkzsQrkMgtvGMaT0XSUT/32tPfxJVefkxCo6qdS+r8FLCvChJMhdrE4T/VfalLqF2Hj6ZaUEr78M/nwjHSSwMqUUAZSGo24Vm1EIbQu7pQKtNk9wM/6wpMYIM0X2OgS+gqvqWsQtmSjjlmH4leEZlLc6XaCLG674ZPxZKF4Saw/tYqZnoSu9i09j+WBalZVlhr3M6RWkS1IM8z6fHfZFOXIGlkv1v0gAJCFzDaAGlLnnpQ2HcVTUeFFQSs+yb7SqTkdn9H0ojzA5CosM+bB9a696MITuP5a3SSLCgRgHTjspupEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(6486002)(4326008)(8936002)(5660300002)(31686004)(8676002)(44832011)(6506007)(83380400001)(53546011)(2616005)(316002)(2906002)(86362001)(6512007)(66476007)(66946007)(36756003)(66556008)(38100700002)(6916009)(508600001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zzc1WStteXpNL2NPYU5FaUNITnlUL3ZEV2VvZDZSeW9ET2pCZDlqa3NWa2lX?=
 =?utf-8?B?MnFwelE4Z1VaVmh3N01odStSdFJBejJySzEzL0M0ZmFhc05HSU1leHlEc0hy?=
 =?utf-8?B?SXUzNE1sdjZjeXF0cmVJcGNIVSs5aFZjOEl5bDVSUlRYbkFWN1VKcFZhd3A5?=
 =?utf-8?B?ZXJiS0ttc0RkRHpFTW9MdDE3a0ZxenNjMFlyTm5DSlRORkpPRjRXOGxsMkE2?=
 =?utf-8?B?WU1ySnJzZU93TjNvK25Ubm5SY2hhaHF0UUxiUnFKa1VQR0FySnBTN0trNXVp?=
 =?utf-8?B?bkFqN1BCeHY5UHAxVDRlTVlwYnRaSW8rSlc5OHNkbCtrQk94UXR0T2NTTllp?=
 =?utf-8?B?OHNIL1ZNd1EvTlJRT05CVHc0VDVrMHhVOFg3L3hSZFdjMnQxdXhtUzAvWkkx?=
 =?utf-8?B?RVl0ZTRWaXY4V1NYeDh1VUV6dmdOUmM1VFloL1p5TStMbVEwSDluZ1pDUFVr?=
 =?utf-8?B?K1hJcGM4VTRHN0hGeTVYdnJLd0FscGN6NHBJd21JaWQyWVpGNjA2NHY4MC8z?=
 =?utf-8?B?cDRubURXcHJmVHQ0YXZZdG93eGV3VEt0YldiT1RtTmw5aGU4UUMrdEc0c3J2?=
 =?utf-8?B?aWM3eUdOVHpkcFVCTXhVMm12c1NqZkh3TjJ5em8yMEFlcXh3aU1ZRlAxb1pG?=
 =?utf-8?B?eGt6djRNYVFDV0NpTml2eW5nNE5yblo0cDZybzlxQ3FrbWFvajExZ0ttVmZW?=
 =?utf-8?B?R2puWjlsd2dJY1J3RzFHcjlURjZKREt1QXlOeVpqTnNvNTE0bEZUVXFSNysy?=
 =?utf-8?B?U0tCY0JmYzhtMW1oNFZobm81b0l2VmNHcXFhYWt6V0FJS2ZIYUFxUHV6aHJZ?=
 =?utf-8?B?dmpGekxOVEpFUm8yL3BpVUF2UFZwbjl5RFlBcVB4TFBJUlZSMDQyckZnc21v?=
 =?utf-8?B?MDI1NUtzcW1rc1dOZjc0ZjZEMktSRVNTaEdHTjZZRTRhVG5reEcrd1ljQ0Fh?=
 =?utf-8?B?S0IzUEFXSUt5em1hRExmVEU3RnR5RHIwRDlVbGhMUDE4Ykd4ZU1HeDEvYU8w?=
 =?utf-8?B?T1FTTE5HWktINUtheHVKN1ZWdC9abnpjSnBqTWVzd1BMekdzcXR0aDAvbmpH?=
 =?utf-8?B?bTJPRFBvb3VhYjdnNWJhRE9oYkxaMXFlN2FlRSsxcVBuclhpaEpnUXRxYnps?=
 =?utf-8?B?YkRwSDJtYUdOWU1IMHhMd09UWEFpbVhFY1ZsejlXWU03VTlwODFKdjhTZzBD?=
 =?utf-8?B?NE55eU16NmxJOUdhdk1oTElleFdxdGtXWTVlaHpGOG16SGZxbFFUbnNNUHVW?=
 =?utf-8?B?T1F4eUEwT1Zsd0lyVFZDUlhiMWQ1MHdBeHdqZmszV0lNUTRJQ0dNTzdJcnVD?=
 =?utf-8?B?WDAvaHBQMy9FRnRMeWJwdm9pSDhrTFA1RmFqZURUQXY3Z1dkQjU1SnVNRUFN?=
 =?utf-8?B?Wm5iUUVTSEROUEpaNFhSUXEydCt3Smx4UkhxSkhibmsxMENJTzlES0FTQXJh?=
 =?utf-8?B?aXF0TU5oMlZ6bk0rNGd5QnI4S2FWL0VyaE42WnVQblJ0bmw4MlpLbTlsckly?=
 =?utf-8?B?VEIrVVpDcThYUGlmRG9KRXVyL2luMS9Ib0kyY050U3JvTzJlZkUzRkJ4a1Bq?=
 =?utf-8?B?eDVmU0ZRK01sYktCalhidzRGV1FicnFxMTVPOCtKYUpvZHUyamphWThIZ2xH?=
 =?utf-8?B?ZlNRVEQ4MUpEbVlsTWVuTU02MWRjcG9PVGwvMkxxRE04WHZBQ0N1V2ZHbnQw?=
 =?utf-8?B?cWxwUHU1d0RJbitoWmExNWkyRCs2NmJpeFA5alN0TFBmc1ZaOFdtcVU5NitQ?=
 =?utf-8?B?KzZmaUhOYkE2VitQemlNbjd4NWUyR3Nvejh1cHc1TVZmcjJPdGNmV1VDTXBj?=
 =?utf-8?B?Z05NZGR1TkI0b0NFZ2RXMnRXZEZLaTU3UU1adGgyMjU4K0J4WDF0bG1QSjVm?=
 =?utf-8?B?MTNlRzlVMWlVRFdPejd0bkFlVExOYlAyZU9KdC9sQjlGS1g5TGV3aTQ0K3h2?=
 =?utf-8?B?c2NvMHYvTzFYOHJ3eEs1ZDhwSDBtaGsrclNtOTk0UUZVL0VDbVdGS1ZnSVk3?=
 =?utf-8?B?RFBHbWV3N3BuZlFPbThEaUErTFlqS3lVOWZ1TUJRU3BFZzlmWlpRMTJTbnBR?=
 =?utf-8?B?aHR5c3RhNkNwZnovQzlCY202Q2ltY1NFRkdsdWNlR3BkMjI5eTNnNFRneU9z?=
 =?utf-8?B?M083eW9LKzBMMlhaZzNQQlhtOWtjbE54NUNJeERwblRnN1kvQjdpMzVkRURt?=
 =?utf-8?B?TUdxYW9ISmVFNHhTaVp1SDZBZURzZzl3aUFYdzhpZ25GK3huazFib0JZeWs4?=
 =?utf-8?B?Rk5PeC9Ja2piR2piV0ZFV3dodEdHNzFtWWE2VGVnU1h3NG01QU9nR3JqR0lQ?=
 =?utf-8?Q?0fYrld9GXRbk2u18Wm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee2d83a-350e-46c5-6a7c-08d9b9bd68a3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 20:09:00.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSCymwGCw61iJyYzdA1obIPVlgZrOmnJOWBJP/sopfjz8R9Agf+XEI5SuS2lcMvAcgbzTYocTBtZEXA2he5zXI9XeRiRMz6r0/Ad56eiTzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2621
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10191 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070125
X-Proofpoint-ORIG-GUID: 5X1iQ-GvXdiPL-FJrGqb1XvL9Uf3tKyq
X-Proofpoint-GUID: 5X1iQ-GvXdiPL-FJrGqb1XvL9Uf3tKyq
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/6/21 8:33 PM, Jim Mattson wrote:
> On Mon, Dec 6, 2021 at 6:03 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
>> following guest state is illegal:
>>
>>          "Any MBZ bit of nCR3 is set"
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/include/asm/svm.h | 3 +++
>>   arch/x86/kvm/svm/nested.c  | 3 ++-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index b00dbc5fac2b..a769e3343b07 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -216,9 +216,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>>   #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
>>   #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
>>
>> +#define SVM_CR3_LONG_MBZ_MASK   0xfff0000000000000U
>> +
>>   #define SVM_NESTED_CTL_NP_ENABLE       BIT(0)
>>   #define SVM_NESTED_CTL_SEV_ENABLE      BIT(1)
>>   #define SVM_NESTED_CTL_SEV_ES_ENABLE   BIT(2)
>> +#define SVM_NESTED_CR3_MBZ_MASK        SVM_CR3_LONG_MBZ_MASK
> A fixed mask isn't sufficient. According to the APM, "All CR3 bits are
> writable, except for unimplemented physical address bits, which must
> be cleared to 0." In this context, that means that the MBZ bits for L1
> are all bits above L1's physical address width, given by
> CPUID.80000008H:EAX[7:0] (or 36, if this CPUID leaf doesn't exist).
OK. If the processor's physical address width determines the MBZ mask, 
should we also fix the existing test_cr3() in kvm-unit-tests ? That one 
also uses the same fixed mask.
