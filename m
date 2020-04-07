Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A86E1A0C97
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 13:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgDGLLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 07:11:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728129AbgDGLKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 07:10:49 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037B2pB4094511
        for <kvm@vger.kernel.org>; Tue, 7 Apr 2020 07:10:48 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082hgm9uq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 07:10:48 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 7 Apr 2020 12:10:43 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 12:10:41 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037BAg4b51839080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 11:10:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B487EA4054;
        Tue,  7 Apr 2020 11:10:42 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 463A9A405C;
        Tue,  7 Apr 2020 11:10:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 11:10:42 +0000 (GMT)
Date:   Tue, 7 Apr 2020 12:52:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 4/5] KVM: s390: vsie: Move conditional reschedule
In-Reply-To: <20200403153050.20569-5-david@redhat.com>
References: <20200403153050.20569-1-david@redhat.com>
        <20200403153050.20569-5-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040711-0028-0000-0000-000003F3AC5A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040711-0029-0000-0000-000024B94356
Message-Id: <20200407125214.35c70f2a@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_03:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=937 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Apr 2020 17:30:49 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's move it to the outer loop, in case we ever run again into long
> loops, trying to map the prefix. While at it, convert it to
> cond_resched().
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kvm/vsie.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 4f6c22d72072..ef05b4e167fb 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1000,8 +1000,6 @@ static int do_vsie_run(struct kvm_vcpu *vcpu,
> struct vsie_page *vsie_page) 
>  	handle_last_fault(vcpu, vsie_page);
>  
> -	if (need_resched())
> -		schedule();
>  	if (test_cpu_flag(CIF_MCCK_PENDING))
>  		s390_handle_mcck();
>  
> @@ -1185,6 +1183,7 @@ static int vsie_run(struct kvm_vcpu *vcpu,
> struct vsie_page *vsie_page) kvm_s390_vcpu_has_irq(vcpu, 0) ||
>  		    kvm_s390_vcpu_sie_inhibited(vcpu))
>  			break;
> +		cond_resched();
>  	}
>  
>  	if (rc == -EFAULT) {

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

