Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1C6761A9C
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 15:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjGYNxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 09:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjGYNxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 09:53:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6E2A1;
        Tue, 25 Jul 2023 06:53:36 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PDaePY007871;
        Tue, 25 Jul 2023 13:53:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=wLhNYbd6Zd+GGabhnUQinZ43yjFdh0s+zYY7HZXUS/g=;
 b=FYSPcI/jc+OAvaxxr7FXroHcgtYYqehoUdpww9EVoqV0jIYpYuQjNr4TXgLSmoA50cX3
 OQT03rd+2lYLlWzVMjJRAwFPHyOhxXRgDRBJCjuGuPgjsoa5LK5fUYNQzegosn8+op65
 uMpnm1JZChJQH2HnGDNGi5qd8ygJ70o3JddbecdR7rUm33Q2lFXEDcuSHnlhzalcoZaE
 mLybouT1/DOOMpXpmwGQsjUPQupSqlwf+aWm3bohMbTard5cmspY5+PezWNvzSwd3fKG
 NVbaqzrgocaN4TrkZSflGP/Unkohr4CzYtAi0G1GUPPSzxUIu6gmHsiPoxHKtO/QUVOO +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s20jtmck8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:36 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PDagQl008042;
        Tue, 25 Jul 2023 13:53:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s20jtmcjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:35 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PCj8sn016607;
        Tue, 25 Jul 2023 13:53:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0v513u6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 13:53:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PDrVEC20775652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 13:53:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 782E820049;
        Tue, 25 Jul 2023 13:53:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F0A820040;
        Tue, 25 Jul 2023 13:53:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 13:53:31 +0000 (GMT)
Date:   Tue, 25 Jul 2023 14:25:01 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
Subject: Re: [PATCH v3 4/6] KVM: s390: interrupt: Fix single-stepping
 userspace-emulated instructions
Message-ID: <20230725142501.36073387@p-imbrenda>
In-Reply-To: <20230724094716.91510-5-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
        <20230724094716.91510-5-iii@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DonmjFEagg8Csm1voCQIh97jh6BJ4qkd
X-Proofpoint-GUID: MMLt008fTRtlGKOeY3cmi0qj5nd-Yaoa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jul 2023 11:44:10 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> Single-stepping a userspace-emulated instruction that generates an
> interrupt causes GDB to land on the instruction following it instead of
> the respective interrupt handler.
> 
> The reason is that after arranging a KVM_EXIT_S390_SIEIC exit,
> kvm_handle_sie_intercept() calls kvm_s390_handle_per_ifetch_icpt(),
> which sets KVM_GUESTDBG_EXIT_PENDING. This bit, however, is not
> processed immediately, but rather persists until the next ioctl(),
> causing a spurious single-step exit.
> 
> Fix by clearing this bit in ioctl().
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 0c6333b108ba..e6511608280c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5383,6 +5383,7 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  {
>  	struct kvm_vcpu *vcpu = filp->private_data;
>  	void __user *argp = (void __user *)arg;
> +	int rc;
>  
>  	switch (ioctl) {
>  	case KVM_S390_IRQ: {
> @@ -5390,7 +5391,8 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  
>  		if (copy_from_user(&s390irq, argp, sizeof(s390irq)))
>  			return -EFAULT;
> -		return kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		break;
>  	}
>  	case KVM_S390_INTERRUPT: {
>  		struct kvm_s390_interrupt s390int;
> @@ -5400,10 +5402,25 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  			return -EFAULT;
>  		if (s390int_to_s390irq(&s390int, &s390irq))
>  			return -EINVAL;
> -		return kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		break;
>  	}
> +	default:
> +		rc = -ENOIOCTLCMD;
> +		break;
>  	}
> -	return -ENOIOCTLCMD;
> +
> +	/*
> +	 * To simplify single stepping of userspace-emulated instructions,
> +	 * KVM_EXIT_S390_SIEIC exit sets KVM_GUESTDBG_EXIT_PENDING (see
> +	 * should_handle_per_ifetch()). However, if userspace emulation injects
> +	 * an interrupt, it needs to be cleared, so that KVM_EXIT_DEBUG happens
> +	 * after (and not before) the interrupt delivery.
> +	 */
> +	if (!rc)
> +		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
> +
> +	return rc;
>  }
>  
>  static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,

