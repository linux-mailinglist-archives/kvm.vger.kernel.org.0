Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8376570C
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbjG0PKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbjG0PKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:10:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930D5F2;
        Thu, 27 Jul 2023 08:10:29 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36RF3bbe011168;
        Thu, 27 Jul 2023 15:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TvyUNc4PpxuphZI8Dz+N40X3M041nOe9C1YSCSFypqQ=;
 b=nxPYKrdZT5otiwbJFuUEEeQlh3XPHUPIs8T/TLaKogbTbI9odH2d0kvhskXTO4JaBzkh
 O90dbrSgp3cyG0Iig/TjR72kTQ3VOdcupMVPsd2a0W/h2d38j/q4SZMoUCpa8OsN9Dgv
 fCnBwgx5Q9Bh69XoltgLLeKjlVOwc6mRAkeMOvySdWLmlZyoG6M7V7C9PKfuSm6UnHg/
 7kRvHCROpGYaYK8k6ruaeQ8oTmMVmL8Nzn9tZNvtK2rEaAcrfiy3KJ1rtBL9zqkih715
 dX2gw73ooaXNvUCQUm4S0N64avD/biZ4vPbXPqwpjnik/cx0654IqwysNfRaOvnD7gjO Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3tw1rjgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:10:27 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36RF47bj013774;
        Thu, 27 Jul 2023 15:08:45 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3tw1rd9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:08:44 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36RCqGuj016588;
        Thu, 27 Jul 2023 15:07:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0v51nv8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:07:36 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36RF7XQG29229496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 15:07:33 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 834A120043;
        Thu, 27 Jul 2023 15:07:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42E6F2004D;
        Thu, 27 Jul 2023 15:07:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 15:07:33 +0000 (GMT)
Date:   Thu, 27 Jul 2023 16:42:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH 1/3] s390: uv: UV feature check utility
Message-ID: <20230727164212.0c6cc310@p-imbrenda>
In-Reply-To: <20230727122053.774473-2-seiden@linux.ibm.com>
References: <20230727122053.774473-1-seiden@linux.ibm.com>
        <20230727122053.774473-2-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V59a0JJ5VuA4O9Na0lssC8IyXd_9JIys
X-Proofpoint-GUID: kXS50J0EJO2jmUaGIMqwHOQ0tNKrqJr9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_07,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 14:20:51 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Introduces a function to check the existence of an UV feature.
> Refactor feature bit checks to use the new function.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/uv.h | 5 +++++
>  arch/s390/kernel/uv.c      | 2 +-
>  arch/s390/kvm/kvm-s390.c   | 2 +-
>  arch/s390/mm/fault.c       | 2 +-
>  4 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index d6bb2f4f78d1..338845402324 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -397,6 +397,11 @@ struct uv_info {
>  
>  extern struct uv_info uv_info;
>  
> +static inline bool uv_has_feature(u8 feature_bit)
> +{
> +	return test_bit_inv(feature_bit, &uv_info.uv_feature_indications);
> +}
> +
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  extern int prot_virt_guest;
>  
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index d8b25cda5471..c82a667d2113 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -249,7 +249,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
>  	 * shared page from a different protected VM will automatically also
>  	 * transfer its ownership.
>  	 */
> -	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
> +	if (uv_has_feature(BIT_UV_FEAT_MISC))
>  		return false;
>  	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
>  		return false;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 17b81659cdb2..339e3190f6dc 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2402,7 +2402,7 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	struct kvm_vcpu *vcpu;
>  
>  	/* Disable the GISA if the ultravisor does not support AIV. */
> -	if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
> +	if (!uv_has_feature(BIT_UV_FEAT_AIV))
>  		kvm_s390_gisa_disable(kvm);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index b65144c392b0..b8ef42fac2c4 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -824,7 +824,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>  	 * reliable without the misc UV feature so we need to check
>  	 * for that as well.
>  	 */
> -	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
> +	if (uv_has_feature(BIT_UV_FEAT_MISC) &&
>  	    !test_bit_inv(61, &regs->int_parm_long)) {
>  		/*
>  		 * When this happens, userspace did something that it

