Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539075A811F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiHaPWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 11:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiHaPWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 11:22:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5455DD8B3C;
        Wed, 31 Aug 2022 08:22:11 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VFG4kL029622;
        Wed, 31 Aug 2022 15:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8lifCs+Vpucok23R/oaopnqzvPUcXxy686872IvWQRg=;
 b=Hsvxt+Y8oHC1HP0GTafFfOpH23ifsV61oFm1bptOaHxSIp9Tkyj0Wa/Vx8YXYt3NFMcn
 rK4+YVBNHQDnXtRGSjdpHOPhe/CmcHVj+XAIy29nkMpbUr2oONx2LAxhC+877oCUUQX9
 pMoydvOW8R/0meWT8YabpJ/uVzilQ1I20i0QK2U3jd2oYfbKTtaOSkFi2FpoPHBpguvT
 ZYjJ8tjyyUkQ562D57RG8MGyz5bImCOFIen9PqKJ/vlwR5bZiQ5BPdQyCnLpjNEEg2Xj
 SlpXZxD0ZGf//gfVNF+ENq9/KDhq0azhXoORB3MPIQICyH0PnyfPXjFvVKptZe57nlY6 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaa4jg5uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:21:59 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27VFGpbx031663;
        Wed, 31 Aug 2022 15:21:58 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaa4jg5ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:21:58 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27VFK67d018086;
        Wed, 31 Aug 2022 15:21:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3j7ahhuy84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:21:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27VFLrLS39846274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 15:21:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 458E74C04A;
        Wed, 31 Aug 2022 15:21:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C2AE4C040;
        Wed, 31 Aug 2022 15:21:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.79])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 31 Aug 2022 15:21:52 +0000 (GMT)
Date:   Wed, 31 Aug 2022 17:21:51 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: Pass initialized arg even if unused
Message-ID: <20220831172151.3e04c64c@p-imbrenda>
In-Reply-To: <20220825192540.1560559-1-scgl@linux.ibm.com>
References: <20220825192540.1560559-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LWcHmtMXlv8RqadyvTO4zIR9mrj7I-te
X-Proofpoint-GUID: lXWEMvgH9t1hMSF6tmvW_9iJy-22h1GI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_09,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 impostorscore=0 clxscore=1011 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208310075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Aug 2022 21:25:40 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> This silences smatch warnings reported by kbuild bot:
> arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
> arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.
> 
> This is because it cannot tell that the value is not used in this case.
> The trans_exc* only examine prot if code is PGM_PROTECTION.
> Pass a dummy value for other codes.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> v1 -> v2
>  * drop unlikely, WARN_ON_ONCE instead of WARN (thanks Heiko)
> 
>  arch/s390/kvm/gaccess.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 082ec5f2c3a5..0243b6e38d36 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -489,6 +489,8 @@ enum prot_type {
>  	PROT_TYPE_ALC  = 2,
>  	PROT_TYPE_DAT  = 3,
>  	PROT_TYPE_IEP  = 4,
> +	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> +	PROT_NONE,
>  };
>  
>  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> @@ -504,6 +506,10 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>  	switch (code) {
>  	case PGM_PROTECTION:
>  		switch (prot) {
> +		case PROT_NONE:
> +			/* We should never get here, acts like termination */
> +			WARN_ON_ONCE(1);
> +			break;
>  		case PROT_TYPE_IEP:
>  			tec->b61 = 1;
>  			fallthrough;
> @@ -968,8 +974,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  				return rc;
>  		} else {
>  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> -			if (kvm_is_error_gpa(vcpu->kvm, gpa))
> +			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
>  				rc = PGM_ADDRESSING;
> +				prot = PROT_NONE;
> +			}
>  		}
>  		if (rc)
>  			return trans_exc(vcpu, rc, ga, ar, mode, prot);
> @@ -1112,8 +1120,6 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  		if (rc == PGM_PROTECTION && try_storage_prot_override)
>  			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
>  							data, fragment_len, PAGE_SPO_ACC);
> -		if (rc == PGM_PROTECTION)
> -			prot = PROT_TYPE_KEYC;
>  		if (rc)
>  			break;
>  		len -= fragment_len;
> @@ -1123,6 +1129,10 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  	if (rc > 0) {
>  		bool terminate = (mode == GACC_STORE) && (idx > 0);
>  
> +		if (rc == PGM_PROTECTION)
> +			prot = PROT_TYPE_KEYC;
> +		else
> +			prot = PROT_NONE;
>  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
>  	}
>  out_unlock:

