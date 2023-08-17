Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7064477F5B6
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 13:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350527AbjHQLwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 07:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350591AbjHQLwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 07:52:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8054E26BC;
        Thu, 17 Aug 2023 04:51:36 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HBaplm017635;
        Thu, 17 Aug 2023 11:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N3G4nHVYm7yVKk+BYIEY5NbZiIgPPuKLhDVmHPcQQUw=;
 b=G3tO/TSqO4Bqeu5udr3otgyAoDM9uOsRro5NhNECpLjpr3HGe6f1M8fAx62JvlM6iiCo
 d/maGKW3wXLCtZxZZSvLw24GMSMsQ+R2Rljh+R1apewRFfGzsbc3jhPXxqn8Ksk59HUR
 rwySGzHifUbTaxqwR+U/ChfMZBaygTeRkpFyENlEm1CQ8ohb9ytqpt+FDekD3BEVjvmj
 zPAb6lBdXnmYeFG+qLF4v5suhyzxTdfxGJb/foQfHq/KMDkFpDvwi/j94FgJbxM15XBF
 BeXdmVzb754MI4K7bpSewcle2Xp8dA3JpbHMTJVNqHP6or2M/eqxRRevvd0NMY5ZBhCl IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shjq20kk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:51:28 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37HBamXq017069;
        Thu, 17 Aug 2023 11:51:27 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shjq20kjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:51:27 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37H9lRgv003456;
        Thu, 17 Aug 2023 11:51:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsx8gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:51:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37HBpN1w44892626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 11:51:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29BDC20043;
        Thu, 17 Aug 2023 11:51:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3FCC20040;
        Thu, 17 Aug 2023 11:51:22 +0000 (GMT)
Received: from [9.152.224.236] (unknown [9.152.224.236])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 17 Aug 2023 11:51:22 +0000 (GMT)
Message-ID: <7fb638d7-a168-65fc-1c42-19f83c02f2de@linux.ibm.com>
Date:   Thu, 17 Aug 2023 13:51:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v4 4/4] KVM: s390: pv: Allow AP-instructions for pv-guests
To:     Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230815151415.379760-1-seiden@linux.ibm.com>
 <20230815151415.379760-5-seiden@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20230815151415.379760-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DntML_C06uuhhSBYKCVpTNwKBkEbClSq
X-Proofpoint-ORIG-GUID: Sie6_dM_BDoGXQ7zv26hIMBDeLO3KfKk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308170104
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.23 17:14, Steffen Eiden wrote:
> Introduces new feature bits and enablement flags for AP and AP IRQ
> support.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 12 +++++++++++-
>   arch/s390/kvm/pv.c         |  6 ++++--
>   2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 823adfff7315..0e7bd3873907 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -99,6 +99,8 @@ enum uv_cmds_inst {
>   enum uv_feat_ind {
>   	BIT_UV_FEAT_MISC = 0,
>   	BIT_UV_FEAT_AIV = 1,
> +	BIT_UV_FEAT_AP = 4,
> +	BIT_UV_FEAT_AP_INTR = 5,
>   };
>   
>   struct uv_cb_header {
> @@ -159,7 +161,15 @@ struct uv_cb_cgc {
>   	u64 guest_handle;
>   	u64 conf_base_stor_origin;
>   	u64 conf_virt_stor_origin;
> -	u64 reserved30;
> +	u8  reserved30[6];
> +	union {
> +		struct {
> +			u16 : 14;
> +			u16 ap_instr_intr : 1;
> +			u16 ap_allow_instr : 1;
> +		};
> +		u16 raw;
> +	} flags;
>   	u64 guest_stor_origin;
>   	u64 guest_stor_len;
>   	u64 guest_sca;
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 8570ee324607..75e81ba26d04 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -576,12 +576,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	uvcb.conf_base_stor_origin =
>   		virt_to_phys((void *)kvm->arch.pv.stor_base);
>   	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
> +	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
> +	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
>   
>   	cc = uv_call_sched(0, (u64)&uvcb);
>   	*rc = uvcb.header.rc;
>   	*rrc = uvcb.header.rrc;
> -	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
> -		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x flags %04x",
> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc, uvcb.flags.raw);
>   
>   	/* Outputs */
>   	kvm->arch.pv.handle = uvcb.guest_handle;
