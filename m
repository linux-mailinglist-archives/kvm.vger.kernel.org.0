Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFD7422815
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhJENkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:40:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233975AbhJENkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:40:07 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195DaPFw016050;
        Tue, 5 Oct 2021 09:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xDAZK6EDYXlGHLA5HvmL/HdVAlGDOo2EAebFz7+iOXY=;
 b=j0PPVSs1r12CxOzNzcEzH6w50YYR0H+9bmvSBZJ/M12voQAW8IB+UmgAl2CMWJHk8FA/
 9NArxzKlSGV2gF6g4urjPeXGintEFCMYi1xszAwOsSm5T0TCuNTanKuqxeIp/ezQIBUu
 6EAsgRT6nRgctfgjNxnuXEBxIM0Ifa1wsl3HBEf0BWtpTknMBBP6NRiztOadn4Cm6G6p
 4xiNcVZRe4RHo0OU2FZe+kkIVTV1tEgBjn40gOiIJ5/o1i2og47uG3lU7CXLVlmLmd0i
 BzgUXPufX2iiEI8efH0/BKh7Uridkzky0oOisCXSNKLW/bg/iV6XMFY3lVMhV+yryvWN EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgpbpj72d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:38:16 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195DbefV023809;
        Tue, 5 Oct 2021 09:38:16 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgpbpj718-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:38:16 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195DWcSZ001969;
        Tue, 5 Oct 2021 13:38:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2a0ruk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:38:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195Dc62E62390668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:38:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0C68A4066;
        Tue,  5 Oct 2021 13:38:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03711A406D;
        Tue,  5 Oct 2021 13:38:06 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.76.223])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 13:38:05 +0000 (GMT)
Subject: Re: [PATCH v5 02/14] KVM: s390: pv: avoid double free of sida page
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-3-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1cd7259e-ab4c-1c3e-6846-e3c5ff26bda1@de.ibm.com>
Date:   Tue, 5 Oct 2021 15:38:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210920132502.36111-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3Mh7vKeMHyGk5-h_oEDqJIa_-Ddh-rFA
X-Proofpoint-ORIG-GUID: GjNmMB0_x8_QXhJxxZTd3YjAhQUST0cF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=749 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 20.09.21 um 15:24 schrieb Claudio Imbrenda:
> If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
> free_page on a random page, since the sidad field is aliased with the
> gbea, which is not guaranteed to be zero.
> 
> This can happen, for example, if userspace calls the KVM_PV_DISABLE
> IOCTL, and it fails, and then userspace calls the same IOCTL again.
> This scenario is only possible if KVM has some serious bug or if the
> hardware is broken.
> 
> The solution is to simply return successfully immediately if the vCPU
> was already non secure.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")

makes sense.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/kvm/pv.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c8841f476e91..0a854115100b 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -16,18 +16,17 @@
>   
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>   {
> -	int cc = 0;
> +	int cc;
>   
> -	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
> -		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
> -				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +	if (!kvm_s390_pv_cpu_get_handle(vcpu))
> +		return 0;
> +
> +	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +
> +	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> +		     vcpu->vcpu_id, *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
>   
> -		KVM_UV_EVENT(vcpu->kvm, 3,
> -			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> -			     vcpu->vcpu_id, *rc, *rrc);
> -		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
> -			  *rc, *rrc);
> -	}
>   	/* Intended memory leak for something that should never happen. */
>   	if (!cc)
>   		free_pages(vcpu->arch.pv.stor_base,
> 
