Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A8877CC5C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 14:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbjHOMKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 08:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbjHOMKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 08:10:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377F9E51;
        Tue, 15 Aug 2023 05:10:00 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FC1l1r006927;
        Tue, 15 Aug 2023 12:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VS2xpbvAfRJ4RT2nYmjAb7SyLP2weknVq1Pxg7orpYI=;
 b=MXWPoTaz7a+qTAoiHgigbBVLBCn17rILuPn7rpd72LQCo5a5zCNmSlKvu3Wob4NgpBnP
 yLHiMxrBKVfhsuBoF1VInoAho4wrF/VtVapOpoyuq0RF2qbcrc4HaUTKADYE/6igCR/e
 1AhjYwLD7d3jphxrVPR+xhu+AfV4Ls1uvmDc9air3VBvb3S0cs2nXBHqiULrmysfevCc
 Yw6hBRvj2JoY8DxUuR80TT/OuTTRuFsZaLTvBZy8+nNrlpEiL8kZubrds59ZtN3S+TVD
 +unX271B8fFmQAMwe5tmwfz6vjVDV2bbhR+wIAkAU7b8QZyv8IiDgfw4xi+ni9H8XPiT hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sg90t8743-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 12:09:59 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FC2VLw008819;
        Tue, 15 Aug 2023 12:09:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sg90t873n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 12:09:59 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FBCi9b007861;
        Tue, 15 Aug 2023 12:09:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwk4fsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 12:09:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FC9sWX46137816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 12:09:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D73020043;
        Tue, 15 Aug 2023 12:09:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0739820040;
        Tue, 15 Aug 2023 12:09:54 +0000 (GMT)
Received: from [9.171.12.89] (unknown [9.171.12.89])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 12:09:53 +0000 (GMT)
Message-ID: <0718475d-907c-6c30-9b33-23b5d21b1236@linux.ibm.com>
Date:   Tue, 15 Aug 2023 14:09:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 3/3] KVM: s390: pv: Allow AP-instructions for pv-guests
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20230810113255.2163043-1-seiden@linux.ibm.com>
 <20230810113255.2163043-4-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230810113255.2163043-4-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nfvjEVYsOK9gGjdJBceNcmbbo__DsJXV
X-Proofpoint-ORIG-GUID: 3faaw7UgopxBD6fEeybJoexTkAlSEyY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-15_10,2023-08-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150108
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
> Introduces new feature bits and enablement flags for AP and AP IRQ
> support.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 12 +++++++++++-
>   arch/s390/kvm/pv.c         |  6 ++++--
>   2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index f76b2747b648..680654ff6d17 100644
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
> index 8d3f39a8a11e..bbd3a93db341 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -575,12 +575,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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

