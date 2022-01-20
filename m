Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6DB4951B3
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376783AbiATPov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 10:44:51 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44924 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347001AbiATPou (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 10:44:50 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KFhJRQ002189;
        Thu, 20 Jan 2022 15:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xEm0GcOEdB/PJ+h6uH+Tvqy33Lo7K+t6cYUSUhWKnSo=;
 b=odOlCVXUtG3FACxAIbTZmlg1ByO5IkvS6bw0/7aodIvNaJPC+133tRx/h6iVhMS5TE1c
 Nu74zjWwtVDe0bO0B+mphRy8IS4Z95l0uM78zFLKm4VANeazLnYVyDyF71oOBEbZm3sw
 4wAJEXJ0li/SUtvlhAIns36UqL+gwiQOBAZr70wW6KJ+soVmqqB6X40YtG3VEmxmQAJX
 hG2JVwiAElcertMPWcKOr93HVd94gEyiNFf0T3sTFEz6nAtPb8FKB2OKbn2nKpTWACO3
 OTv2JQSRuT+Kkr7xQv9dYR5hxnljUDXGfKOoL5XztAL7pg20IuGrZc86ps0i0nKpZCDw yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqammr030-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 15:44:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KFf6B9190287;
        Thu, 20 Jan 2022 15:44:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3030.oracle.com with ESMTP id 3dpvj28t70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 15:44:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCH89uPB3BFxJ1hzdH+GE7KWA+Ez2I0Eo9rSiUyUb3upm19OwfFWp0z01Fe6P69Kt6fTCzO+rMfaskgp9AdqH54paTmdgXNMvW4WlMzvd1Kn/Ajv3RqUT/i9O1tU/ljmdSiVsKUTyq3WSGfMMGIrwfdRqvc6Lr5E1EkvFraczLS8b8rvDy2myvJftPkUx0wJvE3fTI3OhX7NhzBz7M9pohDITOSSEUn+AHYLB4HN4su2E0ZF6DKNXjIhzd5PYPfFH7AHXVx3z65qxf3967tvlRi3JUkxowAz9DlTQ/mqmW3HtcMmwJVg308yevSLNtBFdR3s71ZI6iDo7ZlHI0pDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEm0GcOEdB/PJ+h6uH+Tvqy33Lo7K+t6cYUSUhWKnSo=;
 b=V3mLmJf24J+fa0emYmnL4rppKex0x3pCx4kAnLO/uijQFxAJEZQC6mVsFuBojY6zog4G31EWL5Ubk9fX41l4QdmkagTmfrr19Z7X8mgSEyn40oPy2LPFbNl0QUfuPZVLpmjpjx4oMmSGffPLall9bZR234sreuYaU0PFRehtOJAKlX9SYWj9LNpR7F2lDpDH4GAyo0172hw/+uRbwMNlv1UiwwNXxAq+njDEZFQW0ONqj+CAXoDSdQqaXyBjdV386s7A+wPG/nn/s/OHKpmEpTFPH/6yzi21zJXTuKCVUNsp1yPYnnwZIAAN+xfycA3HPKhcnzx84eSHUqYPdXktqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEm0GcOEdB/PJ+h6uH+Tvqy33Lo7K+t6cYUSUhWKnSo=;
 b=QGTYVrMhz+7OMY6ey/ODw5dy8oHHviFLITic6Amoa7VeXmvaiEq0ZEeVfhKZbfCYQ5GbMkOfnH6oK/MCLvO1oof+6ytwAOTbfr/NK9MT7p/8eCnjCg2r+g1JfJ3I8gFhzs92JlWkexBflDaiYuMFtjfSOR86AELCQg/NEv8J/DE=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 MWHPR10MB1583.namprd10.prod.outlook.com (2603:10b6:300:27::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.12; Thu, 20 Jan 2022 15:44:10 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 15:44:10 +0000
Message-ID: <483ed34e-3125-7efb-1178-22f02173667a@oracle.com>
Date:   Thu, 20 Jan 2022 15:44:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 6/9] KVM: SVM: WARN if KVM attempts emulation on #UD or
 #GP for SEV guests
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-7-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::18) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 974e5b7b-1d3b-44d4-bd8c-08d9dc2bb35a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1583:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1583A5B9D1C70262B89ACD31E85A9@MWHPR10MB1583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwG0BDeLnvJVAW+9ho/usjiTZNmEIg6JgKTuNxsDGkc7h08ZjMf+QX+VY4J+7tmqLOaxLqaQfFlplRrJHTzRi0KvxX8CjiGLOCTiJy+mbBV6tDlVPVvq233YeBKF6ZBZbQK+JQEeGNm8wTShSKkgeJ89AoeoXxJdcvYHqDqKU43uu0ZWwUB/eHl2jhwXk6Rtc2Lc94BCiAG00QrDBucPAn9zQr7oIwXVcRXjOOvEdkv5pIryRTC+9BlajHwBKyhKoGe1ifmAMSPfqYOGJo9iu7OfK7QV+22pKcR4DNXqWCG/eNt5IVagn0D8CDpbQv9XLCAyEzaCd7xi6x4z5cAXDx4msl90970U7nfM6exfflTQwc/RlCbrFoMM2H5GKtpGPSswJjDTArGmEPDK7jCpUHarD92xt9B4ylHlWxrL+Mj+4Hr/AzIZWm6x5pVw8wwVtJovMGxvz5rdca3u6hx/40XVl5RS1opLnzdSnr/blRbYHCCh9/Lbd/hBImnh8RuPwnh6kVkBfHgzQdQy8S0X6UPLW2/l3R7KBej2ULhZBzUNtFJFIioL1bHXhhM4gXO6X0tHfQn3QladFsjmWZreQFOSunH7m6bagtUEx4gtbNsG+CyalQUbud1ELIvj9QxL0sDIoKV+KC6RCiJQoaXS76F1CrTxcIn5z2cdQBdwupVY5mv1y6HELUTWJlsnZjd2r9np4HXuN+IoUhvy7stTc8nvLEPFP55ENPZexIQgrhP36xoAf9kEaE9gV7V503ZV+4T5MHgVW8bSQYQSYszgKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(6486002)(38350700002)(7416002)(66946007)(54906003)(6512007)(186003)(66476007)(31686004)(8676002)(86362001)(107886003)(4326008)(83380400001)(316002)(8936002)(52116002)(26005)(44832011)(2906002)(31696002)(6506007)(53546011)(66556008)(5660300002)(2616005)(508600001)(36756003)(6666004)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3VVVjI3c09rMHV3OW9ibjNVL3dPV3U5NzV2STVIbXlrZ1F0RWJqQ3ZXTXRY?=
 =?utf-8?B?eWQrdDNYZE9EeG5NR1ZHZ256RHk0ckQrWldGVndBVmdyaHlvRnlJK2I5Z2Q5?=
 =?utf-8?B?RStqbzBGcVV6WU5HRFhsRllZd0VKbngxWElIQmZ3S1lya0Z0NlRucFRHNlh4?=
 =?utf-8?B?QWNkSm5qTks1V1N5aFN4eVJsME9nRjc5bGtYbXdHdHpDQ0xQNFB0aGJPL3VS?=
 =?utf-8?B?NnVMTzNtOXJmQTF1ZHNHUU5jR3d5Ui9jK2IydlN6YjhnTHJHU0EzaWNPNjZ4?=
 =?utf-8?B?TnlPTi96a2dTN0pVN3AzakJFMmRnWnRXVVdaRGw4bndGY29oaitCMUgvSk44?=
 =?utf-8?B?OU12ay9GREVwYnhEWkVmTVlMQjJPTzVQMFlEWVdaa0k2b0F4MDlYM3I1Y05r?=
 =?utf-8?B?MWQ3VjJCU0o2MUFVSVN2dWJac2xoOXd1N1JvT0gwaUZzRFduOXg0QTRmS2pL?=
 =?utf-8?B?cTBVRW9ZRzBGR241THNWMDdtdFNwckpiQ0NkakxBcmhKdklmUzZTRVZDdGs4?=
 =?utf-8?B?YzR5WnZJNlRoaWNYaytFRCsrT2xyWlF6eXV1RmFNUGJERVUrTmJ5dVdqbncr?=
 =?utf-8?B?MXhlY1JkMTF5d1VMWTJQNFNWV3RCQm5iUEdDcWhxMFpjbnc3S01CQ0VtNmh0?=
 =?utf-8?B?MlIwT2Z4cjQySUJJQnNqd0FENDBTaHdsU1I0aXRaTEx1NXNWRWRWanhuY3VI?=
 =?utf-8?B?RXUvY0ZTMnY3L2JEZFBqcnhBRmpTNm1ZS1d0Ty9VKzQ2VXQxL2lDMzAyZzl1?=
 =?utf-8?B?bWNkMDBXZHduK2FFcXZFVkhlbHI3azhna20vSWRoL1FnK1d2NTBUWS9MU1lz?=
 =?utf-8?B?TFJTUllpZGU5cWhHK3ZjblkySmNHazRpYnQzcnM5YlFYY2QrQ0xlaTRlTWZo?=
 =?utf-8?B?S25DUUlLRWtMcHpzYStBa0NwZkxmclFJVnNFYWhWSzdneFMzU2x4U0dBa0VN?=
 =?utf-8?B?d1pvTDBrUHZCblljZkdyZ3BOSDdmV25YenF3TFRsYkl3ZEM0QmdERFp1QVpC?=
 =?utf-8?B?a25pdUJYYU1GNldhemE0NDJHZVVEZW5SL2MyTGFZaHV3RmR2T2V5azJjVFdH?=
 =?utf-8?B?UmdxUStDbXhWT0FoNWN2R0Y2QlpmbFN4RUNZaGNRQXBzY0w4TGlQK0Y1Rk1K?=
 =?utf-8?B?T1hpMmVEaGdxVkJudHZLbUluRzFqUmkxQ0ZUOHZMVmtPL0NnN1BwRmIzWnFI?=
 =?utf-8?B?QlpVbVg0QWlUaTVud1pvcU9wc0RHMWw4NDNBK1VzNktWMVljUjgyQkp1dTdJ?=
 =?utf-8?B?QVFjWDlTaEd5VWVXSnZET2xaejFzOVg3T3VheCtjTVl6SkIzZ3E5RDB3TUlp?=
 =?utf-8?B?QXplMFhUS1dqNnIzOVB1YUliMk9vcXNNZ2JkTklKUEZUaTQwYkR5YUFqQzlI?=
 =?utf-8?B?TTA4M1l5Tno5dG9LeklvOUZ5WFRxUk9BV3BEdERsWURyL1pFc1ZRU3B6eVpZ?=
 =?utf-8?B?Z1FxYnIydG1WNzRyRFpWL1JRNDVWTjgxSER6YjdJRUZrV2YveW1IZHdRTTZK?=
 =?utf-8?B?RFpuK216L21YbGhJNENieWphcms1NkRLZmkvaUpBbHl0Z0RMNVR6RXBSQVIx?=
 =?utf-8?B?OWhiMHI1VUx5SWhHcStqVVVIK1V1MmRCNitucmljQm9pM05sdEI2K0JrWkZN?=
 =?utf-8?B?NkhTc2NwVk5qTjBEU0lnTjJSKzJhanZhYUdreDBWRk9jR2FBQ2NXM1U1OERu?=
 =?utf-8?B?N0ZTaHF5bFlyU2lEVFhPMElHMGxFeUtuS1lHc3E3MTRYYjZJZTNTNXVHZW52?=
 =?utf-8?B?QnhaQyswWGlkVHExRWEzRFU3S0FPRmxRencyRVRQdFlNZ095RmltbXhKUmsv?=
 =?utf-8?B?RkY3MVZVMVdYZlh5RGtMaWM3bDhrMEhUTTBMSXNiL2hxUkl6ZHhObHJhYVdl?=
 =?utf-8?B?RVVIOUN0NzQ5ODBvdUVXaXZpZWNOTTRoRDBNWWxtYzRHeE5yUCs1RlJ6eVNi?=
 =?utf-8?B?ZlVYcjF0M3gwWHQwYk02KzBjUUJyM1dCcmhFV0NnTzhLSlprWFJDTDgxL0xz?=
 =?utf-8?B?bHJkV1dGZHVTZWR2QUp6TnN0VGhaa2k3SVk3eXNkVWhUd3pweEhlaEMrTVZm?=
 =?utf-8?B?WjRxZGozMm0rcXpxUXlpUk9ORHN0WlRsSjVwQUw4UTFHejdEWE1tV2ROWG53?=
 =?utf-8?B?cE9QZFA0akxieG1Fc3VRTjlKTTlHOUdvUG9CbVhpa0xVeXZZUi9na0RDOFAw?=
 =?utf-8?Q?aaKKPQpOlOdHBjUT1ESkDa8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974e5b7b-1d3b-44d4-bd8c-08d9dc2bb35a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 15:44:10.2908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a4J/HRkoBj0jOqpimcou/js1FNehK45E1KaFk9Z2Sb0DC/QY5lceoMZSIIoDHaPYX3A/jdSR9FmQe8xSPTbaRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1583
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201200081
X-Proofpoint-GUID: 3o7ipg-V97RX8Cjc_Agqz0E_VZMwS6eV
X-Proofpoint-ORIG-GUID: 3o7ipg-V97RX8Cjc_Agqz0E_VZMwS6eV
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> WARN if KVM attempts to emulate in response to #UD or #GP for SEV guests,
> i.e. if KVM intercepts #UD or #GP, as emulation on any fault except #NPF
> is impossible since KVM cannot read guest private memory to get the code
> stream, and the CPU's DecodeAssists feature only provides the instruction
> bytes on #NPF.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 994224ae2731..ed2ca875b84b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4267,6 +4267,9 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   	if (!sev_guest(vcpu->kvm))
>   		return true;
>   
> +	/* #UD and #GP should never be intercepted for SEV guests. */
> +	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP));

What about EMULTYPE_TRAP_UD_FORCED?

Otherwise
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> +
>   	/*
>   	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access
>   	 * to guest register state.

