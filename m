Return-Path: <kvm+bounces-3329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C24F38031BB
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7611B1F21025
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA2022F1B;
	Mon,  4 Dec 2023 11:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SJb8ovpu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10EEB6;
	Mon,  4 Dec 2023 03:48:46 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4AqB6R007962;
	Mon, 4 Dec 2023 11:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jvnzeAMxLSa3R3RUGFBSlGOHPyXrSHn1fnjBGRZkCa0=;
 b=SJb8ovpuwaH7ArxbbWtmUKsBnntbSViSL5kEMuUUCpVx96+Qlu2WCrQOU1il0VQ1Qv3r
 ttEZMAQzmWezIwrRKtPqxlupO2bXBEQeDgMwe+0kwf3xHBka9juYw2o0kvRRLYDp8xMb
 gBOHnzdJUy+HV9ynEQ5Mw2GxCQ4dTHNhUBNY8kalk12y9lN/4Hg0tmHu26+kAN1T+f8y
 zfyOEPbTnUzBHggUYu6YOi7CFIPd7Eyvcp62b7wzqvSlaHAIAM8vyvyTCZ4+J90nkckd
 NlHeEP9BxAosFdbV4Nq26P8NCom8QTEW1SsNpUjPHw4BO/fDJlBNo8oibuxhkze5eZB3 Ug== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usb6s7bju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 11:48:46 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4An2Tb022857;
	Mon, 4 Dec 2023 11:48:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urgdkqs25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 11:48:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4Bmfbw15991386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 11:48:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D049120043;
	Mon,  4 Dec 2023 11:48:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12B2120040;
	Mon,  4 Dec 2023 11:48:41 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.42.250])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  4 Dec 2023 11:48:40 +0000 (GMT)
Date: Mon, 4 Dec 2023 12:48:39 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony
 Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
Message-ID: <20231204124839.093f4f76.pasic@linux.ibm.com>
In-Reply-To: <20231201181657.1614645-1-farman@linux.ibm.com>
References: <20231201181657.1614645-1-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cyD-Ub5VnEHi1APb4RmHCrtXYas5DJZ5
X-Proofpoint-GUID: cyD-Ub5VnEHi1APb4RmHCrtXYas5DJZ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_10,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040089

On Fri,  1 Dec 2023 19:16:57 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> The various errors that are possible when processing a PQAP
> instruction (the absence of a driver hook, an error FROM that
> hook), all correctly set the PSW condition code to 3. But if
> that processing works successfully, CC0 needs to be set to
> convey that everything was fine.
> 
> Fix the check so that the guest can examine the condition code
> to determine whether GPR1 has meaningful data.
> 
> Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for AQIC")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

> ---
>  arch/s390/kvm/priv.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 621a17fd1a1b..f875a404a0a0 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -676,8 +676,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	if (vcpu->kvm->arch.crypto.pqap_hook) {
>  		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
>  		ret = pqap_hook(vcpu);
> -		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
> -			kvm_s390_set_psw_cc(vcpu, 3);

Maybe a comment that tells pqap_hook() returns 0 or -EOPNOTSUPP
that singnals this should be handled by QEMU. But that can certainly
be done on top, and it is not a part of a minimal fix.

> +		if (!ret) {
> +			if (vcpu->run->s.regs.gprs[1] & 0x00ff0000)
> +				kvm_s390_set_psw_cc(vcpu, 3);
> +			else
> +				kvm_s390_set_psw_cc(vcpu, 0);
> +		}
>  		up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
>  		return ret;
>  	}


