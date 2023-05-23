Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA64570DFEF
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 17:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbjEWPKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 11:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237439AbjEWPKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 11:10:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CB011A;
        Tue, 23 May 2023 08:10:13 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NF2eIp008443;
        Tue, 23 May 2023 15:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FS0uudSjJ96HuXoHyRk5jgs5LdL69sSYBSOnObqQnwI=;
 b=jsymdvqqm1FVq+F8sG5/6LNOdkroysFBkgC8m/kOSoyaO026fQVHvQ1R8yaEyobtHizS
 STzhkkxNoOSn5uvKBumbyPXMkpYvnmhFvW8qqNGU72aD+PiVArssDdfsgd3Suz2ryI2U
 MI43ahLhjFZTTCDCl6RhiqNRoDcDC5L0pDWAkWfV3Kdu1ud7aIE+7tVRJau4XmRML6HA
 NEVWG0k7ejT+NK0y0Abc4pr6gcxS0eiV0MPQ/q5y4qOAklL3g/ar0v2IJ2P0uF5k+WlO
 cQQvc4dXuBFG+WZEAD9gH1FkyJcm3hcrM50Ulf0/AynI1DW1sm0b7nSYR6jhpVQYNx/+ 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrx73bhes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 15:10:13 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34NDjvcC019916;
        Tue, 23 May 2023 15:10:12 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrx73bhdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 15:10:12 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34N1YCYH007828;
        Tue, 23 May 2023 15:10:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qppcf19bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 15:10:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NFA68828049922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 15:10:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E15620040;
        Tue, 23 May 2023 15:10:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ECFB20043;
        Tue, 23 May 2023 15:10:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 23 May 2023 15:10:06 +0000 (GMT)
Date:   Tue, 23 May 2023 17:10:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390/diag: fix racy access of physical cpu number
 in diag 9c handler
Message-ID: <20230523171004.719d9f44@p-imbrenda>
In-Reply-To: <20230523140500.271990-1-borntraeger@linux.ibm.com>
References: <20230523140500.271990-1-borntraeger@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D3BGqvrnjgvTSDNoPB_f11HpIhn26wyj
X-Proofpoint-ORIG-GUID: t8gaCv8tXMKbU80Z6Q1399k-_jxXhtdy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_10,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 May 2023 16:05:00 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> We do check for target CPU == -1, but this might change at the time we
> are going to use it. Hold the physical target CPU in a local variable to
> avoid out-of-bound accesses to the cpu arrays.
> 
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Fixes: 87e28a15c42c ("KVM: s390: diag9c (directed yield) forwarding")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>  arch/s390/kvm/diag.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 807fa9da1e72..3c65b8258ae6 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -166,6 +166,7 @@ static int diag9c_forwarding_overrun(void)
>  static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu *tcpu;
> +	int tcpu_cpu;
>  	int tid;
>  
>  	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
> @@ -181,14 +182,15 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>  		goto no_yield;
>  
>  	/* target guest VCPU already running */
> -	if (READ_ONCE(tcpu->cpu) >= 0) {
> +	tcpu_cpu = READ_ONCE(tcpu->cpu);
> +	if (tcpu_cpu >= 0) {
>  		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
>  			goto no_yield;
>  
>  		/* target host CPU already running */
> -		if (!vcpu_is_preempted(tcpu->cpu))
> +		if (!vcpu_is_preempted(tcpu_cpu))
>  			goto no_yield;
> -		smp_yield_cpu(tcpu->cpu);
> +		smp_yield_cpu(tcpu_cpu);
>  		VCPU_EVENT(vcpu, 5,
>  			   "diag time slice end directed to %d: yield forwarded",
>  			   tid);

