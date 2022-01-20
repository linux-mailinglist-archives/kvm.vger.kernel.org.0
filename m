Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B90149527D
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377040AbiATQi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:38:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16630 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231576AbiATQi2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 11:38:28 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KFhHGo002173;
        Thu, 20 Jan 2022 16:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1lFS1nfrdFJpUjtp56+cPDbI8dceMDaFEFXvwBLRnco=;
 b=sex/BZpTA4MFKgiVVDkGGOMkjxqhIQPF6jcexDLYJktgb89WzXpZOYI9i1AVjKglD3p4
 kfzzB0mgznmR4+6hGVuqcU/kHG2D30IB1ao4A+HlSN+trTAYAJ6D2GATvFkEQe/a1ShB
 e3eecVD9kMgDCiqQ+NXpUTIkAra2r0jbdfC0ey/mtUi7NgcFlHxk3z2fvS+bK2GZVd32
 r4lQFC5fLbGL11FyRgdYbLiSjuKCNJ1wuhgRSrVzKL2pkBeqBWKnd7mGGciNW1I70nQR
 zabCvicj9JChk3gSKzJ79yGEi372647D6vQXPOWz7265qFGfFl0VDhZ7VVOAwDVtXNum Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqammr54x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:37:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KGKRwh161020;
        Thu, 20 Jan 2022 16:37:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3dkqqsq3rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:37:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5vFaIPLlN8QcZ6aEtQNZLVPKCAtWhAE3Bd3ZQ91JTO45a1tiAmiJGA1nLbvu2QHrQ/FZdtpvoo8+PmbG0o0n+/IFpZ9zfEHG4QDhvV5E4YFUy8iHQqQ+I6Qwy3iXM5Zg/1oMHltDAWBpNvEcAXvjAOymh0ACTU8qPzkqSObhPrhP648hKbKUYenkrZ8Z6Y8cNeDh0lQiVo8h97raBluGaU8qRu2wh9If3tJuj1RQIZNq92D2kt6YXMdfZjdsD/qRJ4DqGeSp2eVT4H/L4wpryrBBNkU8qF0sD2rjtL8YL5KqO6j8XmSFxFtYIwQra9wddrm2b9rxPBF4EhNCDejdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lFS1nfrdFJpUjtp56+cPDbI8dceMDaFEFXvwBLRnco=;
 b=Df5tPMHmExUpaIB6dZuGFEVm6dmXjcksm0/mKKqfKAJpAcvjufTQrA31rn0Slw/uufe2LvzzbURuGU1ya9bz563mhEUi4wgQNM8haBDxMG1gxJVDxVAs6NKfnm1b+uDFNrImSKd8mJRjumMPu2NIFmaYc8Hqb3Iu3R+qLFQxxUGzUo2Bo/aq6POOAsqOZw8Up9atLMEscOkMDb9v3+mUdbrkLoUojvXWBx/Fi4pYoZ7dAlW60JHp0tzKObf1HFJeMtfSbrK+Yj666Fzh1+7+Q0dksjOPhJqsTBmzYa0H30YONgieo4/w11kSQ9TekJf461Dw1o3syZ7D49yveuRR4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lFS1nfrdFJpUjtp56+cPDbI8dceMDaFEFXvwBLRnco=;
 b=qw0kbluWHbUp53ONwOKQrdOiB30TfFtA+3Ad9y9t0KqblE5wjntD6Ch2X+XILthIiIWVvbcmoMZP0VA5n7U7QxgurKw9gMM44Zo9arLTXwfCLMTaFgIY7o7TCEfKs7+EXhcfJ7L2UNfPKT2mZmC2/UJNGXAxXWqnDGiSfKvwhcE=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 SA2PR10MB4523.namprd10.prod.outlook.com (2603:10b6:806:113::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 16:37:50 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 16:37:50 +0000
Message-ID: <a98497ce-3d58-92cc-fe0c-727c7a5d6929@oracle.com>
Date:   Thu, 20 Jan 2022 16:37:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 8/9] KVM: SVM: Don't apply SEV+SMAP workaround on code
 fetch or PT access
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
 <20220120010719.711476-9-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0076.eurprd02.prod.outlook.com
 (2603:10a6:208:154::17) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ed02147-02b9-4e68-5fa4-08d9dc3332c0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4523:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45237A2CF60589CD65D559EBE85A9@SA2PR10MB4523.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wnUJv4oWtWWf1M5kbrQVgylI9G5Xr6XYtgNsM5sUNqu57pWMLoEUgAS3JTT76XnJmcQCi0YlZm16HlKDU6dpx3fS6LLZl7S3CdIxA+UTigAY3xQV1M3OD7u1Up8hkkWryV1S9nq9ueR+qqaAwm+kynEQjndZf9LB88QzgMGboH3zL/AsdfQKFzNK36Bi+8LJQnXY04xS9fMHJJl0sDyBqr4sbuD3Xo/sRcxhf1RC2EMzG8Iev2U+yaz4gAr+BbU7AVqAvguZHQssgf9RtmQ/p1UBeapx9OCW/e4NJfNRI4w8PSFlh99dX4uxnRv6F5tbc0oNKYU8+veGsh6oQ1u2Q/+5YvQxBjYiNmddOyGNWAKHniaXXLybl2O6501Zi7eFwJoOVNgSwzQqjEsQyX4l0dXiTmdyXwRDnlGhQ+SVVoMiQxhusMoG2glhxpj0VQ2na1dkIpiMxYzKSRyRe3IrwhSbqW58a/0rZgZEMtpunDv7aBrjyzKjVeyRDBDKlMkpkcN6frqRbAVeBiaJmv0raYzcLAhBtQEfZ+JA0R+esbQlJcSRNxVBQ6e3Y8bp4KNLBjawk9HiNAPaNoPQoNt5hK1/RHO6WRKEiX1GI0bnybBWGOejI/j43nK94FJNtMxKsnPLkogqI4M/c1SxPU4bKXu5IQOzrPwMga/TrJw9Rj8McHWASlkY5ApoGQISm6Dyk8DpFIfur9wD0wYFvVqSqwQtxPFWFHQqcAVvTuNRGuJlDk6nJQdIG9IQIJX4wTzg/wWW8UvKhEeVP5OtnLZuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(36756003)(53546011)(4326008)(316002)(86362001)(2906002)(38350700002)(52116002)(38100700002)(6512007)(7416002)(31696002)(54906003)(110136005)(8676002)(8936002)(508600001)(44832011)(66476007)(66556008)(66946007)(83380400001)(107886003)(5660300002)(26005)(31686004)(6666004)(6486002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QldFd01OaWpkL21YTGc4dFhValhOVE1LMnlPazd1UzRaNzRNYVV2YVliV2Zk?=
 =?utf-8?B?S0c2VlB4aTAyK2dXcGE3RzF6SENxTkhaQmtDeFdGS2lqMFQ4U0Roa0luSDJ4?=
 =?utf-8?B?YWZ0enlFUHNCcDRpNndKZE4rMFltanJoT2orVDZaVkJsQ1V1NHZoY1J4SDZ5?=
 =?utf-8?B?eGd3bVJjNmROSW9RT2hmUE1nS2Y0NHRUbEF4U3h0cHU4ajl2clUvZ0FmOFI0?=
 =?utf-8?B?Z3puK0tqSzJabEhxQlNQbkxWeGZvZSsySjVBOGFTSTN6VFhoK0dLMjVzOURN?=
 =?utf-8?B?Nmd6UGFadWlUNGdOVUJLQk1pb3Vhei9ER2hFSEhidzBTdFl1ejRYekowTFN6?=
 =?utf-8?B?VlQrVDVsUGtLcko4T0k4OTBSRTc0MVVkeUMxdEU1L0V3QjlXNGZ2RkppZEg2?=
 =?utf-8?B?WXlZUTJSaUFEYkl3QWtBZzIrd2FiSThuL3VEeUFPRFFqYkRpYmVwWFFoemd2?=
 =?utf-8?B?MXljdmJoVEplWk9PcnRGTDNKek80V2ZOdDRqa1doR2VURFJCYjUwUEIycUpP?=
 =?utf-8?B?UWF6dUFMRFhkdFByOFlCVGhQd0R3dWlOdVFPRysrSWROSjZwNmdrbVcwZ09r?=
 =?utf-8?B?eHNJbUpHSW1hSlJCdlgrTEwvNFRxQS9kdTdCSlhsNUp6cHFxUTJxTXVnVnFT?=
 =?utf-8?B?K0lIVTNzcVdxMkdsWXcwVUFkQkYyMmtnS2lXUnhUTHhHK3I1VWN0cENoSUkz?=
 =?utf-8?B?ak5ZVVhBb1ljZTkxbjlnTGx1M04zZWpiZllSdmxpZ25PVDJ2NjJRUzRKc28v?=
 =?utf-8?B?N0lPWW9DajBiTVpwRXpuN3lOSTB5elFDa3VseVNWVEZ6cHpDbzhxRHhNWkdp?=
 =?utf-8?B?TWVia0QvT1o0WDJBTXV4MTRKSEh2Vmh5VFJXS2p5VHlUaFlEQjU1cHMzVjNI?=
 =?utf-8?B?TmV3MFFocHUyQmFpN3dDZ1dnSGN2L2QxMlI1YlZDcGZ0bkdxVlFOWTBhMS9W?=
 =?utf-8?B?UlA1TnQ2S3ROclVHUGVlUnhiOWkvZEEwV2lWVi85R2ZqVUVqNmNPYUlaTGta?=
 =?utf-8?B?Y0RCOFVKWVZKNFA0M0RVUnplSTluQmtNK2hlbjUybStYa04wbVYyTnFNV3FL?=
 =?utf-8?B?bzRKYkw5aW5NODRwSmVWTk5EeXFtcGd4dFM4QkJURERCRmhERHRISzFJWFNs?=
 =?utf-8?B?YVpES2wweXIxQnV4NVU2RDBIZDFxTDRvSGY0NEJtSC9sbEdBVHNXUElpOVlS?=
 =?utf-8?B?VU84NUxGT0hsSHVHc3ZvVTBycHYxRDkwMkFwbDh0QmlYVW0rUnJiWnZmSUN5?=
 =?utf-8?B?TUdJVkdMaW1RdEdrclFSVDF6akM3WkNjdlZjZkhLSi9SQ0JKRkpsdFp4bFd5?=
 =?utf-8?B?ajZsay9ieGl5TFBxVkkwMjlXOHFzaXFFU1dRK005ck9VM3QwMWpLakJXdG1B?=
 =?utf-8?B?bmFXQnpEbWZuV1BiVnlPUXZSTDlDV1hsdGpHcEVsSVUzeDdrdVBRYng3N1Iv?=
 =?utf-8?B?VTVhOHpLK0g1UTVsdmZlWFdqZGw3ZUVVQXE4SEhVbStrU1k4N21UTE5JbHhi?=
 =?utf-8?B?cXpTZDR0R2d6b2hMbGdFYjl0UkRnTnp6K3RuaDJoeFdvNmJnUHZhblM3SDNj?=
 =?utf-8?B?MndiRzJ3cUV4ajFFblhpWFBGVGVaaTFXeDk2ZWRaZkdVUncxRUlrTTZCL1dU?=
 =?utf-8?B?K1RCRWY1OUV0emQ0VVFya015UW43OHFmazV0MUk1aW9EdTJPdnNiTFl1bDhC?=
 =?utf-8?B?djFRbGNVVTd2SkthSnJkRWtILzZkUXFaRTFvYUdwTjdvM25aN0NGK01ZeUpq?=
 =?utf-8?B?Vm1IVnVQU3UwY3lURXpSSi83bkJXUTZZa09nQTkxUWtLU3RSbkhpZjJYeUgx?=
 =?utf-8?B?WVJSM2tJVlNBdDJENnNnWTBBbThRLzRaRTdoK3Z0cnh6R08xWWppKzljMU5x?=
 =?utf-8?B?V1NmeG5xTmtaTWtCcnN4emJvRE5mOE8yTWJEc3ZxbngwSkpla0lSWDhFT0du?=
 =?utf-8?B?cEMzOUR2SUFkbE1jUmRTMEtoTXM4dThqazkyenNoY2ZUVEdFRlZFRzlpMGh4?=
 =?utf-8?B?UkdDcHhBWS9GUjRzclZTVUEwY1ZhRVZrQkFySkxoc1JBSXR1bitFdzFjU1R1?=
 =?utf-8?B?Slk0N1kwUVVqaTlsZ2JIbW5mbnZnSkQ3a3UvU1RmdG9weEhXeTV6cWJWOU5D?=
 =?utf-8?B?VFN0aGFxM2E2K0VkdnVTY2tjWGs1T1BQMmZCZ05EdThFOVAwKzEwUEpVS25o?=
 =?utf-8?Q?CD4cmWFVyWYG9gniC9EB9cg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed02147-02b9-4e68-5fa4-08d9dc3332c0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 16:37:50.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3plWhSD0FFA3ATVLPsoetaUvD1o+rw4BFQT4PsP5EeBeCBhQvO4O+6l8Ag7nHbgSlqJmkeepq+7zgTlFWGpcRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4523
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200084
X-Proofpoint-GUID: p-84wWsTFY4ykROnBUy21Yndc0V9O_xC
X-Proofpoint-ORIG-GUID: p-84wWsTFY4ykROnBUy21Yndc0V9O_xC
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Resume the guest instead of synthesizing a triple fault shutdown if the
> instruction bytes buffer is empty due to the #NPF being on the code fetch
> itself or on a page table access.  The SMAP errata applies if and only if
> the code fetch was successful and ucode's subsequent data read from the
> code page encountered a SMAP violation.  In practice, the guest is likely
> hosed either way, but crashing the guest on a code fetch to emulated MMIO
> is technically wrong according to the behavior described in the APM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/svm.c | 43 +++++++++++++++++++++++++++++++++---------
>   1 file changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d324183fc596..a4b02a6217fd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4262,6 +4262,7 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   {
>   	bool smep, smap, is_user;
>   	unsigned long cr4;
> +	u64 error_code;
>   
>   	/* Emulation is always possible when KVM has access to all guest state. */
>   	if (!sev_guest(vcpu->kvm))
> @@ -4325,22 +4326,31 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   	 * loap uop with CPL=0 privileges.  If the load hits a SMAP #PF, ucode
>   	 * gives up and does not fill the instruction bytes buffer.
>   	 *
> -	 * Detection:
> -	 * KVM reaches this point if the VM is an SEV guest, the CPU supports
> -	 * DecodeAssist, a #NPF was raised, KVM's page fault handler triggered
> -	 * emulation (e.g. for MMIO), and the CPU returned 0 in GuestIntrBytes
> -	 * field of the VMCB.
> +	 * As above, KVM reaches this point iff the VM is an SEV guest, the CPU
> +	 * supports DecodeAssist, a #NPF was raised, KVM's page fault handler
> +	 * triggered emulation (e.g. for MMIO), and the CPU returned 0 in the
> +	 * GuestIntrBytes field of the VMCB.
>   	 *
>   	 * This does _not_ mean that the erratum has been encountered, as the
>   	 * DecodeAssist will also fail if the load for CS:RIP hits a legitimate
>   	 * #PF, e.g. if the guest attempt to execute from emulated MMIO and
>   	 * encountered a reserved/not-present #PF.
>   	 *
> -	 * To reduce the likelihood of false positives, take action if and only
> -	 * if CR4.SMAP=1 (obviously required to hit the erratum) and CR4.SMEP=0
> -	 * or CPL=3.  If SMEP=1 and CPL!=3, the erratum cannot have been hit as
> -	 * the guest would have encountered a SMEP violation #PF, not a #NPF.
> +	 * To hit the erratum, the following conditions must be true:
> +	 *    1. CR4.SMAP=1 (obviously).
> +	 *    2. CR4.SMEP=0 || CPL=3.  If SMEP=1 and CPL<3, the erratum cannot
> +	 *       have been hit as the guest would have encountered a SMEP
> +	 *       violation #PF, not a #NPF.
> +	 *    3. The #NPF is not due to a code fetch, in which case failure to
> +	 *       retrieve the instruction bytes is legitimate (see abvoe).
> +	 *
> +	 * In addition, don't apply the erratum workaround if the #NPF occurred
> +	 * while translating guest page tables (see below).
>   	 */
> +	error_code = to_svm(vcpu)->vmcb->control.exit_info_1;
> +	if (error_code & (PFERR_GUEST_PAGE_MASK | PFERR_FETCH_MASK))
> +		goto resume_guest;
> +
>   	cr4 = kvm_read_cr4(vcpu);
>   	smep = cr4 & X86_CR4_SMEP;
>   	smap = cr4 & X86_CR4_SMAP;
> @@ -4350,6 +4360,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   	}
>   
> +resume_guest:
> +	/*
> +	 * If the erratum was not hit, simply resume the guest and let it fault
> +	 * again.  While awful, e.g. the vCPU may get stuck in an infinite loop
> +	 * if the fault is at CPL=0, it's the lesser of all evils.  Exiting to
> +	 * userspace will kill the guest, and letting the emulator read garbage
> +	 * will yield random behavior and potentially corrupt the guest.
> +	 *
> +	 * Simply resuming the guest is technically not a violation of the SEV
> +	 * architecture.  AMD's APM states that all code fetches and page table
> +	 * accesses for SEV guest are encrypted, regardless of the C-Bit.  The
> +	 * APM also states that encrypted accesses to MMIO are "ignored", but
> +	 * doesn't explicitly define "ignored", i.e. doing nothing and letting
> +	 * the guest spin is technically "ignoring" the access.
> +	 */
>   	return false;
>   }
>   

