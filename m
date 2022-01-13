Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC5F48DBB8
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiAMQ1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:27:31 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20306 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236620AbiAMQ13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 11:27:29 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DFJD4q019921;
        Thu, 13 Jan 2022 16:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 to : cc : references : subject : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ECb7CfBlEuGHRmv62emubM5P+xlIPAJAJBQP3+b9fiE=;
 b=kNtVoAlUsSNvF2rhNZcbCWacYxfycLUv08JRGEHSR4B85vlehBvLdgsM3Y7g1OgBZRm3
 3VNtu29jW3B8NQ3xX2MEI5rbBKsNlMC6Vs3g2PfYto0wJYjHHr+rs19Uacj7oSoxeIS6
 2HsuxSAGEbaoDvTxS87s9bGwwLkU2Zg0LzgSj14Ver9nZE8yQp3f1eeHTd1ZPbizIN+z
 PKm2+wcneSc1jIPeRXsZfhSdldbh424B/F4KnCGbxPrwoKuKxnHCNBXeCoYepSB0Qm0a
 +JnhFh/W1EavxlzX/ZmdbuMktswp3mhmril1PMUzriV+hBqOxfRgeUKehRqPyW3yH8JI zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3djkdnrpbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 16:27:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20DGFjCJ123318;
        Thu, 13 Jan 2022 16:27:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3df42rry3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 16:27:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7FBQWkGdHqQVdUmgpmrYSyW7fjagMNqXuMXiSeZL/cXq4F7Li7TYepsP5EwjMSjCYi3+ozfmIRNDtmppfWWxaG0OYwSoKZr1Ue2ARu/cGVntYYbabzy4+moTaPmdOZMJMijWpCjS6RcquwA4VNAVtpTf+MwD79hOdTCVfw9XvxTS/LffjEJfFGCie+WiSBzNVBT/oNDRMYEtiwuC9fLbPl7/B7+sL9/MnAyLc16i/+j62jkqziSeM2y3UPhF2oKISadR+6I1i4rnP9jguoT1xnqzz9/u/duc4UvrD8yB8WEcjIOS/Meyo3V8DznW8N2ibiwUV988xa2XteedYgpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECb7CfBlEuGHRmv62emubM5P+xlIPAJAJBQP3+b9fiE=;
 b=ZWA1+FnLJVhI9DfdvqF+XsN8HKi8PZId2wntJ1zSefNgwibApY2Yl0K9c1S8nk9skmQLf+F7eIuLu7ilVT4OQksb9std0CV48XYi8dY6H1+MaV9ekKsGY3TV7T7edFZZkArgX2q8Z3ACzQ+js5MqNKdMAdqS8UVa5noHgCTX87CY6dq0YztLV6FyQTFpxwFsFtSr1wzT95rf+EtITcaq36jMqQhxSTKRXfU3g6K/VXqdKHOATCDFuU19mk6pO6as+B/otByTTq+InU55nMBXjX5OsWGOwt4Ma77ZBe6A2tAfgGEw8Lo0exNG5u67EpUjAMxPNkM+YRNHIJf5vce9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECb7CfBlEuGHRmv62emubM5P+xlIPAJAJBQP3+b9fiE=;
 b=DNXJLzasFEMkMPQg7+acE5sCw+VktKPTDTLpvUQz5vA9Ni8RGPN3YcDeW0PDGnFdWQmnFdZC55LshL5OFPofwGQEBd8hhePslvnv5G1a17wbiwQu4zc4sj4uovJ2V4jyxp7QJpttRvh3zRRIH7tDYqLSnSgbl4W0CfKmeTZBxh4=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by MN2PR10MB3342.namprd10.prod.outlook.com (2603:10b6:208:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 16:27:22 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::5cf2:f465:3a2:3ac4]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::5cf2:f465:3a2:3ac4%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 16:27:22 +0000
Message-ID: <74de09d4-6c3a-77e1-5051-c122de712f9b@oracle.com>
Date:   Thu, 13 Jan 2022 16:27:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        liam.merwick@oracle.com
References: <20200417163843.71624-2-pbonzini@redhat.com>
Subject: Query about calling kvm_vcpu_gfn_to_memslot() with a GVA (Re: [PATCH
 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Content-Language: en-GB
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20200417163843.71624-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0079.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::20) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b4d9785-289b-4f79-016d-08d9d6b193ad
X-MS-TrafficTypeDiagnostic: MN2PR10MB3342:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3342940BA648CCA28F0BC9CEE8539@MN2PR10MB3342.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVgL7zIsbzsoGIZs+NrhImYhIVejthOkH04iiej9H2E09uPpykCAvJyRAcwkH++BPPmUOLPeGVzBetI2jbts9mWRJQ2RJXOsoWx57xFohK/1+AI4owJsfFTFXKbDwEFMF7b1dz1vGauqcyQHDni3j4Xv0ejPKN+joISL++v4E9wFkIyzC/yHQACc+KR4z/PhyffgQmFIa0CmL6NqZhn/8GICEDtLtmwvIINYeQRgc2BDYwKIv8UY9TixZ8cB4pJRaB7jbaq2z4NZJs+6aDgNzYVYBOFMim++Efk/sbDwUzENB1XX3/m8Hs7TbLI0F2bi8wbp3h1EhiqumYY2cmFJSFoZgOnWU49ZedRfx+qgfj/tZMGJNgJdr4qy2L5+7CJURxb0EG3NpT94U1LywibHYq1fhgLXsKgXzVTTxKr0wVN+Tcy6qj/9IMi5T6PntQc3bA62GlQTjYDD6f1OCcpo7TwejuuiwU6QZW2V4gYD5d80qP40fxtaLXyumJEaJSfo+g9v6NGo7JFmwlYv3SKqiO3ohe+Xy8fc3sOWF4tM7MjUjENK+6oHRkVYsVCBj2/jO3ZPTGi92WvHQK4QKCpDxgRGNkZPRPvMAomF/9HdmSlJUBehPQwk6YsItvsFSmS6mMP+rhKbKrr2XhApW488h0uCGlaJf6+GAKifDTJNPBwGvXDOJV3qz1hah6e92fnT31VzcAmhBaRDpEpDTIsA7RL23FCBt4gyBv8k/aGpm5QRr8ZHDS0qoDtW0RmyLp7S9AySX9lCNXsj10Dp+30/xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(6666004)(31696002)(86362001)(6512007)(8936002)(2616005)(107886003)(6486002)(6506007)(31686004)(508600001)(36756003)(52116002)(66476007)(2906002)(54906003)(66946007)(66556008)(44832011)(4326008)(38350700002)(6916009)(38100700002)(5660300002)(83380400001)(316002)(26005)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cSs2cFFxdXJISzNYdHo5RkhTQmZvOHRadGNwbmZzUlBwRmpjUldYeXJjY0Rk?=
 =?utf-8?B?amkwWDgvWDZKdzdMeFh1b0M1TEM4c3BTckZYM0RycFZTWGxSWWFlR0hta3JK?=
 =?utf-8?B?RlBuNVRGZEJYMVlFUElRWWh6MVFSYU5UWDhzdm9neFA3SmUvRFdtNnA1QXo2?=
 =?utf-8?B?ZzY5THlNM0lzOEVPSnoxU2VoaHBjS1p3RURIMUU3RXRRZlhCRWQ4RUxtQlpu?=
 =?utf-8?B?QzhnbjZqK3dsZFJWbkxJYmgxZXFqTHU0R3FmWlBJQWRaMDNYd1gwOVJPY1Bs?=
 =?utf-8?B?QkZPZnZXOXh0NUQ4OTBHVE8xb3ZPOWlPUFJRTEowVkg1UHg2dUtXRVFaZUd6?=
 =?utf-8?B?cEQwYVBZNU5MekNTVjdoTTBhT3hqd1NNek9KZnYyeGVWaXJQZUcwdmUzVGw1?=
 =?utf-8?B?SWpFYkRTYTVLNUxMR3pWMmQ3Ulh6MlpDR21tTUUvRWlFY1VXVTJuSklvOHVt?=
 =?utf-8?B?WjM4T0pDTDV4UTg4bENaWFZaVE9ZNW5QZEdMNmh1ZHBpdXFnYTc4WUZPaGo5?=
 =?utf-8?B?RXhROURpeTBJQkxjNGdkRmZ1cVZPZWVJTE5oSDJ4bldTenVLSFJvU2JvWk5s?=
 =?utf-8?B?T2FYSmwvUEtzd3pVb2ZUVlluYTBSbisya2kxN2gyNi82U0JxTXQvWWgyTmQy?=
 =?utf-8?B?UFZjWkFIMVZpN3hpeVNqZkZnZ3UvNlRSRTNNaG9YMzZCdC9PZ01ZZ3Uyd25j?=
 =?utf-8?B?WlpTRGh0eXZWRWorZ2Q4ZUdzMjcrVnB4a3RDZ2QwRzZJNUxsWjdVcmcwN0M5?=
 =?utf-8?B?R0NWSVBqWFdidXY5MEsvZWVXaktscjRMbVViUkhuMWtXWVBGL2lZczN0cU9z?=
 =?utf-8?B?ZFBoN1A1b2x1WTluaVVsWUFPNnpmSXcvMVRTR0ZROUJNQ25Yb25BZzY0WGl6?=
 =?utf-8?B?UXM2T1pVMHJkN3R3UEdXOHNhS2RQeUxxSytqdkFTYmNMZHNSSGRUSk1xQklI?=
 =?utf-8?B?eEJKYzBhWm95OWVUc1ArOVZnaE15M1hlL1BORHk5VElIcXN6ZzUxL1lNU05s?=
 =?utf-8?B?dWROY2xkV3NabGRUOUc0NjRPVXdhc2s5OFdVU2JXYUNzWkRFMGMxeDhIWFA0?=
 =?utf-8?B?R3grZjNJQnlxc2xuNWNOTjFkN1VzdlNrNzVKRnFmKzRUK0lMRk9uL1VleUdx?=
 =?utf-8?B?OXl6SUdvQ2RWQW1IRlgxMmhlektFaUg0THkzVnJOOGE1QXQ4K0pseHVWaUdY?=
 =?utf-8?B?QjhmQnFnZ1g3WXVUOStqUHBlbTRFZGNPdkFMem1DUHBmUFo1WTRpN1pZM0oy?=
 =?utf-8?B?am9NNDRZRTUrYWNudmxWWFpZZUE4ZFhKb0RLU1FTcTExWjB3VW5PenF0ZEpq?=
 =?utf-8?B?NVFadWRpU0ZYVFFiUGUvNFFRalNPMU80WWQ1elZVQk5NUEd2bEEzdXlMS0gr?=
 =?utf-8?B?YkV1ZkYweU8yUmFhVXZTVDFMeG8vSkNaWGJsUit0ajZzUTZ6R0x6MVRQYjU1?=
 =?utf-8?B?MGlqc01sbjFRMjVSVXpxbXVteHdZcG5WOCtQbkxjTGZCUDdsbHF4UVVxRzdw?=
 =?utf-8?B?UjQ2aVZaZitNOEVPM3BkdVQxR21vVnF0UjJaWlJKYjlXbTdyVjJzRjUwTi9C?=
 =?utf-8?B?R3JVM0lJM2tFV2Y2ejNRa1huOENTMUtlRXpiUHlXZGlXMTRlTXFsVm9yS0Qv?=
 =?utf-8?B?NDlEZGYzUVNxS3NIV3R6S0VHWkVWd216ak1wUEt2RStaMTNnRzlobkd6dzZp?=
 =?utf-8?B?SjZKS0hlY3B6Z1Z3VWxEemY3dkNlaWN0VGFseVhyOS9YQnBEaENQWFNPcUds?=
 =?utf-8?B?Mjk3djZqY1N5QzEyN2NOa2tFWW81dWloTjlXS2x6SjF0Y05ReCtyREFiTnBG?=
 =?utf-8?B?c0NmNmRsRkdJbDc4VFI0WVVuWEpTQ3hjemszRGFCQ0ZBQnVWMFFQelNCSUdB?=
 =?utf-8?B?a1d0S2Qyc1phM0ZQMmM0bEk3N3lKMCtxemhzeSt0Nms2M0dRU3JyV2llRXBu?=
 =?utf-8?B?TDlxcStBTW5BRkdoRWtIZytmazhZbFQ0aWNWaUxaMS94TzBtaCtZZmFOTFBL?=
 =?utf-8?B?enNCa2ZyZ2VGR2w0R0Jnc0g3TWZPS1pRYWtydmFLMVdPNHBNa0k3ZTVpcXgz?=
 =?utf-8?B?WmI5MUJxdGFnQWtLeC9FVi9ROU1jSFoxbWhPVUYxa1FuRVVMR0g5TGg1Y1F5?=
 =?utf-8?B?a0FVWXRMbS9sWHVTcm50ajFzaWhwSFpQWlE3Y2UySXppQzU4Rlh2aEdHaC9q?=
 =?utf-8?Q?75bGB3kcpS8T3Tqk9mHnelk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4d9785-289b-4f79-016d-08d9d6b193ad
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 16:27:22.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SsXA5AujNI4u+G8aRi0LGOBXeY2NHnD3/oXZUh+PNJBvweB4GmUvELD9oUCChG7N8Tw/90k443M4tsPl7ajdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3342
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10226 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130101
X-Proofpoint-GUID: kFiFeJvHqudDWfx-NMncVKi4TPhJiR1W
X-Proofpoint-ORIG-GUID: kFiFeJvHqudDWfx-NMncVKi4TPhJiR1W
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 12:38:42PM -0400, Paolo Bonzini wrote:
 > When a nested page fault is taken from an address that does not have
 > a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
 > (via mmu_set_spte) and kvm_mmu_page_fault then invokes 
svm_need_emulation_on_page_fault.
 >
 > The default answer there is to return false, but in this case this just
 > causes the page fault to be retried ad libitum.  Since this is not a
 > fast path, and the only other case where it is taken is an erratum,
 > just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
 > common case where the erratum is not happening.
 >
 > This fixes an infinite loop in the new set_memory_region_test.
 >
 > Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len 
maybe zero on SMAP violation)")
 > Cc: stable@vger.kernel.org
 > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
 > ---
 >  arch/x86/kvm/svm/svm.c | 7 +++++++
 >  virt/kvm/kvm_main.c    | 1 +
 >  2 files changed, 8 insertions(+)
 >
 > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
 > index a91e397d6750..c86f7278509b 100644
 > --- a/arch/x86/kvm/svm/svm.c
 > +++ b/arch/x86/kvm/svm/svm.c
 > @@ -3837,6 +3837,13 @@ static bool 
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 >  	bool smap = cr4 & X86_CR4_SMAP;
 >  	bool is_user = svm_get_cpl(vcpu) == 3;
 >
 > +	/*
 > +	 * If RIP is invalid, go ahead with emulation which will cause an
 > +	 * internal error exit.
 > +	 */
 > +	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))

When looking into an SEV issue it was noted that the second arg to
kvm_vcpu_gfn_to_memslot() is a gfn_t but kvm_rip_read() will return 
guest RIP which is a guest virtual address and memslots hold guest 
physical addresses. How is KVM supposed to translate it to a memslot
and indicate if the guest RIP is valid?

Regards,
Liam


