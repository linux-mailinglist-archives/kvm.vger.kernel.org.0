Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451577CC37
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 13:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbjHOL7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 07:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbjHOL6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 07:58:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C88199B;
        Tue, 15 Aug 2023 04:58:32 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FBvk7L019539;
        Tue, 15 Aug 2023 11:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Zu7cXJvPVx2WqzJM1LVy5qKbxNzBYeKWJPOVQm3gN10=;
 b=tIkzRHcUBRBP2VeguYyX+CV7/CXVSZEYJAqTGbgf1Xur1prlYoGNvtoVq14RjZ5btwXl
 YgPrhH9USQwZ9XIVb71Cibz3Kqso2RFdVp4c58HcAZj1KwmEKklOoM8JShnVbHOZMiqZ
 QYrLUOv2CTnIF7gs32/h5YJD1Y31ODCZJ5tMqVtWzXyGuCFRVQGzhefKNqxCgJtRBmBi
 xOVewM/l9U6+zn/W2qWNdb1C1k/ZarM2C0JeDDw2J4ei8oOf7qpNg4Vic1omz6HlAJlS
 tjytKzKhuzo6kHQ6hS0dSN3ASItkYQxPyR3zYf8+MeJGffyyJi2cMk0pxaVU4/31u20/ zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sg8gvgdv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 11:58:31 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FBdaA3030479;
        Tue, 15 Aug 2023 11:58:31 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sg8gvgdur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 11:58:31 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37F8meUC013234;
        Tue, 15 Aug 2023 11:58:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sepmjm3dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 11:58:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FBwRU362259654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 11:58:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0BDE20043;
        Tue, 15 Aug 2023 11:58:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D39D20040;
        Tue, 15 Aug 2023 11:58:27 +0000 (GMT)
Received: from [9.171.12.89] (unknown [9.171.12.89])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 11:58:27 +0000 (GMT)
Message-ID: <1b156168-f349-bc42-fa1d-9a6e8bfba5e1@linux.ibm.com>
Date:   Tue, 15 Aug 2023 13:58:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20230810113255.2163043-1-seiden@linux.ibm.com>
 <20230810113255.2163043-2-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] s390: uv: UV feature check utility
In-Reply-To: <20230810113255.2163043-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mvfsdy4UCmusm0yAkvXmHaZgfRmhZYu3
X-Proofpoint-ORIG-GUID: 4fh4Ddj1OHU8Z3lGjsPRGQJjYOp37igP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-15_10,2023-08-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150103
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/23 13:32, Steffen Eiden wrote:
> Introduces a function to check the existence of an UV feature.
> Refactor feature bit checks to use the new function.
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Please add a bounds check, then:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 5 +++++
>   arch/s390/kernel/uv.c      | 2 +-
>   arch/s390/kvm/kvm-s390.c   | 2 +-
>   arch/s390/mm/fault.c       | 2 +-
>   4 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index d2cd42bb2c26..f76b2747b648 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -397,6 +397,11 @@ struct uv_info {
>   
>   extern struct uv_info uv_info;
>   
> +static inline bool uv_has_feature(u8 feature_bit)
> +{

if (feature_bit >= sizeof(uv_info.uv_feature_indications) * 8)
	return false;

> +	return test_bit_inv(feature_bit, &uv_info.uv_feature_indications);
> +}
> +
>   #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>   extern int prot_virt_guest;
>   
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index b771f1b4cdd1..fc07bc39e698 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -258,7 +258,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
>   	 * shared page from a different protected VM will automatically also
>   	 * transfer its ownership.
>   	 */
> -	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
> +	if (uv_has_feature(BIT_UV_FEAT_MISC))
>   		return false;
>   	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
>   		return false;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e6511608280c..813cc3d59c90 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2406,7 +2406,7 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	struct kvm_vcpu *vcpu;
>   
>   	/* Disable the GISA if the ultravisor does not support AIV. */
> -	if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
> +	if (!uv_has_feature(BIT_UV_FEAT_AIV))
>   		kvm_s390_gisa_disable(kvm);
>   
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index b5e1bea9194c..8a86dd725870 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -599,7 +599,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	 * reliable without the misc UV feature so we need to check
>   	 * for that as well.
>   	 */
> -	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
> +	if (uv_has_feature(BIT_UV_FEAT_MISC) &&
>   	    !test_bit_inv(61, &regs->int_parm_long)) {
>   		/*
>   		 * When this happens, userspace did something that it

