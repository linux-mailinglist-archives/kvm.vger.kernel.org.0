Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3076A8121
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCBLfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBLfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:35:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA5D1B541;
        Thu,  2 Mar 2023 03:35:16 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322AiLsB030357;
        Thu, 2 Mar 2023 11:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dOAo4yP20BN2tMvLNTdTUQ9lWV9N88XXslr4sX2EaiY=;
 b=NOy3uKXatHZhVjhlYrjt7dk9peFQ+ghLo3nhedJCxpLkT91i7tygH4K+wODyfBkGsFq+
 +tydf3Q7mSMslJrrFP1RKERe0KWqkEZbaEcB+ZMov/jO9P7bKLQHMryatbYsH2IEFGJM
 IVx1PX44rxqUvo7KWoHHVHEbUR1+OzSbmxSx+Sa+CkM2XbI6e0MTVyFBHCpyehGjsHcP
 MZXRMI9gSZE+Z+p8ELs29MS3qFRtqfxWFCY96cw1dBk2RMPxG8NGyoVXjLjMDmhMiZg5
 XB3mJ2Zp9YNUW99CvpjbE/6sgje4ZoOadttLjicyrupsB7PUMLHG4ZF8cWjaOkgBavLH rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p2tag996v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 11:34:39 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 322BPU3D010598;
        Thu, 2 Mar 2023 11:34:38 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p2tag996d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 11:34:38 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3229qNok024547;
        Thu, 2 Mar 2023 11:34:37 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3nybe9vkru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 11:34:37 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 322BYZi44260488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Mar 2023 11:34:35 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90FD95805E;
        Thu,  2 Mar 2023 11:34:35 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83B3F5805B;
        Thu,  2 Mar 2023 11:34:26 +0000 (GMT)
Received: from [9.65.199.252] (unknown [9.65.199.252])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Mar 2023 11:34:26 +0000 (GMT)
Message-ID: <7bb7de5b-8650-d632-5d8d-13e961092514@linux.ibm.com>
Date:   Thu, 2 Mar 2023 13:34:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 54/56] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        Dionna Glaze <dionnaglaze@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-55-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <20230220183847.59159-55-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sW6S_sH2skBR2gF5i0T43zjzYupGR-JF
X-Proofpoint-GUID: wwIKig-YXQZM25e08VegcV-Ep_P_1img
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_06,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/02/2023 20:38, Michael Roth wrote:
> From: Dionna Glaze <dionnaglaze@google.com>
> 
> The /dev/sev device has the ability to store host-wide certificates for
> the key used by the AMD-SP for SEV-SNP attestation report signing,
> but for hosts that want to specify additional certificates that are
> specific to the image launched in a VM, a different way is needed to
> communicate those certificates.
> 
> Add two new KVM ioctl to handle this: KVM_SEV_SNP_{GET,SET}_CERTS
> 
> The certificates that are set with this command are expected to follow
> the same format as the host certificates, but that format is opaque
> to the kernel.
> 
> The new behavior for custom certificates is that the extended guest
> request command will now return the overridden certificates if they
> were installed for the instance. The error condition for a too small
> data buffer is changed to return the overridden certificate data size
> if there is an overridden certificate set installed.
> 
> Setting a 0 length certificate returns the system state to only return
> the host certificates on an extended guest request.
> 
> Also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow space
> for an extra certificate.
> 
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: remove used of "we" and "this patch" in commit log]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 111 ++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h   |   1 +
>  include/linux/psp-sev.h  |   2 +-
>  include/uapi/linux/kvm.h |  12 +++++
>  4 files changed, 123 insertions(+), 3 deletions(-)
> 

[...]

> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 92116e2b74fd..3b28b78938f6 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -22,7 +22,7 @@
>  #define __psp_pa(x)	__pa(x)
>  #endif
>  
> -#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
> +#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */

This change should be removed (it was also discussed in v7).  If I
understand correctly, 16KB is a limit of the PSP.

-Dov


>  
>  /**
>   * SEV platform state
