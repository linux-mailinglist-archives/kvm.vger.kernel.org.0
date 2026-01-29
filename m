Return-Path: <kvm+bounces-69583-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOTpNiKce2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69583-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:42:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8844DB322E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 594723038AEC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B233542C0;
	Thu, 29 Jan 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f7V7Hx79";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FY4c2kG4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE96353EEE
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708424; cv=none; b=M6ok2mcFcvZZUg7b7tDLcs2DGjZD7ch6N06+YzlvUskzlHVW5WpHUNlQJYMDwkFYUoUEpZ+cfBDQsrsThNjdsJx6qxYceEUgkYl2r6xXyJuplueeHDKPDpwzTwSkzIeMHF2COydBPMSAciV+fz7JYJWuThFzYmpPlNeiyoO+C7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708424; c=relaxed/simple;
	bh=Y7xSqJOLzh/EuohcFb1CceBmaiKhuh4bwDL5EdHyAP4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=bfMpVSW7UpDGXBU0xjjozfkob6a7nybFiMsBvAKMzf3CftacSpaXbuJEqbhSvhXRexaARTQgy568I/s1kzGzCpW4kZ7YAFO1dTEqbfhPLuzGRccpTi2rG3sSLtkOVzVjrCBrvIXt+DvB+ZJojkYPvj+rDAYrj6PmzmVRPsWbiOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f7V7Hx79; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FY4c2kG4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TASYvj2033252
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X7MOImJj+nJlLfYhfSrfFXuD7mz/bcT1kMUBG+e2q/g=; b=f7V7Hx79jkuVVvVr
	I3cL1XQ68fPAOX24673vkTDdAOoC1EHZZgyJDUv495w0gl5j8bxtYrHw/jT1JpwH
	RRflRq295ifnjRKV1bKN7aMA+1rBb98hcmGsZFXJ+ymi8Ph7RXYB7J/KuNimU4AV
	ndEEeSl5h6ZWF+brJjlshuUN8pnRsl30aL19U1UNoSQf5jqQtw5LhpPi0Urj1+H9
	AFrFTZ4O1+3CiO7hOANxU/BuaxF03hJiXgSYSJRgzIypXdszXMMaWBS6K4Ef1Sv3
	Raie5SYbYv1mN6xTlOj9UPE8z760GiThwxWm0xIHuvgahfHQfOUsSgJbf9QDNFmw
	SHTLbA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bytqy3jdq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:40:21 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c70cff1da5so323756085a.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769708421; x=1770313221; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7MOImJj+nJlLfYhfSrfFXuD7mz/bcT1kMUBG+e2q/g=;
        b=FY4c2kG4wxzjINBEorFZTXA/jhDzthnFZBQpfPIeuFgdXOMwL5MndPwelo7ZzsUM1o
         IeooQDn9JrDmFrgfQX8Etti/hEMHJBuQLbuozC8yP4+8gSbkWpkuk3kMoKGsXD/Dk6op
         cdaR1inpu2gUtJKM1QikoCIxU8eSwJNJmm7oAALJbU+2ZBAeP1EBj2miS3BYZUUViu7H
         5L/dkdlUCI3XkTrGwlJ/QfM20CJ0HsJxkZfby4sOhTrMa63OBF0SUKVS76pabYduDSjy
         S9pyTELb0o4cT2piHryA3VB+I0zvNqmvPAoPTSRLUu3mgescX9PbAp+8JatwsDB9s1Ya
         bpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708421; x=1770313221;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7MOImJj+nJlLfYhfSrfFXuD7mz/bcT1kMUBG+e2q/g=;
        b=WpRLVdv9r2TPi+916XaE+fQ7GZGzi54AfHrFuC+SvOUk44sIxrEwAwMAL+HFdyOERp
         nW4T68brz9nDIZSxRVTD5vIwVqCocSN/aIcDvMpEuFkU8GopAqKixWdrsYEz1LS5VOpp
         6GxR/c4rVWcaiIZMkV8Tnd+V3RBVhEAdGTqVpScXJEBo41Mpc9z9g269RKupPN23aVEV
         VeNb3J/pDLmW5mS3SGsS6bGqL59TLak1+3vA90awpTlI0IOMWBvPsG1sfS3HhmNp5RV2
         1PjENbVdbKNY4tOCJtqtFXE6LdWWRt1RAlsFsL7BcSwOfaOj0z6r6SbPCTO0bsoriQ4I
         USFA==
X-Forwarded-Encrypted: i=1; AJvYcCVkGVkbVBmm13keP2zg/3q5m7Sm7p34Q5K7pbxJNoQNCQTYhf5RnUw7vx/93HZZ5+YSQ3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMKK72Eow/CTCzKDC/EiX3lozeUZfTFj6iKEzkf8NSchfvsfaY
	TEv54BbI++VH5LmGzDb//UuJTy6BpxqXIwZOm+7EMjzP+F5MnuzgG6fLS9R37pE+kMM0T9FsOqM
	hYYdMqnk3UY53T8I5UZKCMB8IZOwr/LzsGRpxIXTp9MRbHj6BsKjoHXQ=
X-Gm-Gg: AZuq6aI9hfRqiW5kCUSW88pSGJDnI1hb6iO1NBotIqCSW5ThwEgUghnXzQ+MX4Ov7SD
	MSR3f8RIIdbMZd2t5gkX8b7fK9HW32x6zOVVvHX7iYdesEbTI4Dk0ifX1vwWocGePSECwRBzSvJ
	tT8m0lxOKYLid8aksJnOCxjKpNHJi2gk5Mgxv7TIedG7SXgNJl8PMnmgTHDDpq3m5Kf+wPHsctb
	HGnQSspwsPpX8ZYRC6LBFeRgT/lBO3Jejz/YwNtZ9EzryKVj47ESTQ4U18jsY6tEvIOoUosc/Qu
	/J59TX7Wnof+EwG5nmR6fknvqJo5BgaapUkFTjbtmhC4ntuxR5AGkw0BGTf+EZptFTTKQ+naJTs
	EU+LxI0qNlHkl6R4tMGte4qIqseVW97AhAuUrC2WZj3Ds9Wde
X-Received: by 2002:a05:620a:7103:b0:8c5:378f:4def with SMTP id af79cd13be357-8c9eb320122mr57575485a.77.1769708420645;
        Thu, 29 Jan 2026 09:40:20 -0800 (PST)
X-Received: by 2002:a05:620a:7103:b0:8c5:378f:4def with SMTP id af79cd13be357-8c9eb320122mr57568485a.77.1769708419892;
        Thu, 29 Jan 2026 09:40:19 -0800 (PST)
Received: from localhost (ip-86-49-253-11.bb.vodafone.cz. [86.49.253.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-480705956f1sm111648965e9.11.2026.01.29.09.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:40:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Jan 2026 17:40:17 +0000
Message-Id: <DG199ZOUMRND.1RTVHMI6L9U5L@oss.qualcomm.com>
Subject: Re: [PATCH v3 2/2] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Cc: <guoren@kernel.org>, <ajones@ventanamicro.com>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
To: <fangyu.yu@linux.alibaba.com>, <pbonzini@redhat.com>, <corbet@lwn.net>,
        <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
        <andrew.jones@oss.qualcomm.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
References: <20260125150450.27068-1-fangyu.yu@linux.alibaba.com>
 <20260125150450.27068-3-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20260125150450.27068-3-fangyu.yu@linux.alibaba.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDEyNSBTYWx0ZWRfXxRv8ALoHfiPy
 B2EsGuPJGmz7sEjIYqWobEJFc6OHqAOadW9X4c5n703ravpiYT0nPkfNcEBcgLK2WcCSmJBSw3v
 3CyzI2T7Oh0xgItXWc0Sgruzzc6cSlw+qOhAGrGuYz3AgfMyGqEa9tXawL/baFhkjPlj0OqH0xg
 1eQkcEqHPunSkFbwQ/eyHhDqU1M3zozuT4e4BmxBD+1oAO4dlmIvChabdhJ5DMrV6k+qQSzbeeU
 +JKhjG3vWlXHDu/xsWpfiFvFtOc7UJKFtMshXl81KX7AjIGqinuuVLk1vmxg9F46kN4DS/vUeKU
 BpV9j7F3XNxFJV0Wc2/0J2iXHQmT2p/5TaDdSt4WutFrIG3I6CvxZehm0Xcec5MXlJMcOesGvfZ
 o3/wAeHbigr04sKO2VkSbyOOqGedQPB+Kp6WeJxmAL5rz+kBx/EHPSds4JFcbWQwa6ocK+wfc8L
 g+8nVuURZWCTF2/121A==
X-Authority-Analysis: v=2.4 cv=Je2xbEKV c=1 sm=1 tr=0 ts=697b9b85 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=HFCiZzTCIv7qJCpyeE1rag==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=Cpfndy8aBPzOrYTrbFgA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: 2AxcSk-RkJa04t_AWYDtP6o4_5-SWF6B
X-Proofpoint-GUID: 2AxcSk-RkJa04t_AWYDtP6o4_5-SWF6B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601290125
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.51 / 15.00];
	R_MIXED_CHARSET(1.15)[subject];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	TAGGED_FROM(0.00)[bounces-69583-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,qualcomm.com:dkim,alibaba.com:email,oss.qualcomm.com:mid,oss.qualcomm.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 8844DB322E
X-Rspamd-Action: no action

2026-01-25T23:04:50+08:00, <fangyu.yu@linux.alibaba.com>:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> This capability allows userspace to explicitly select the HGATP mode
> for the VM. The selected mode must be less than or equal to the max
> HGATP mode supported by the hardware. This capability must be enabled
> before creating any vCPUs, and can only be set once per VM.
>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  Documentation/virt/kvm/api.rst | 18 ++++++++++++++++++
>  arch/riscv/kvm/vm.c            | 26 ++++++++++++++++++++++++--
>  include/uapi/linux/kvm.h       |  1 +
>  3 files changed, 43 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> @@ -8765,6 +8765,24 @@ helpful if user space wants to emulate instruction=
s which are not
> +7.47 KVM_CAP_RISCV_SET_HGATP_MODE
> +---------------------------------
> +
> +:Architectures: riscv
> +:Type: VM
> +:Parameters: args[0] contains the requested HGATP mode
> +:Returns:
> +  - 0 on success.
> +  - -EINVAL if args[0] is outside the range of HGATP modes supported by =
the
> +    hardware.
> +  - -EBUSY if vCPUs have already been created for the VM, if the VM has =
any
> +    non-empty memslots, or if the capability has already been set for th=
e VM.
> +
> +This capability allows userspace to explicitly select the HGATP mode for
> +the VM. The selected mode must be less than or equal to the maximum HGAT=
P
> +mode supported by the hardware.

"The selected mode must be supported by both KVM and hardware."

(The comparison is a technical detail, and incorrect too since the value
 is bouded from the bottom as well.)

>                                  This capability must be enabled before
> +creating any vCPUs, and can only be set once per VM.

                     ^ "or memslots"

> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> @@ -202,6 +202,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>  	case KVM_CAP_VM_GPA_BITS:
>  		r =3D kvm_riscv_gstage_gpa_bits(&kvm->arch);
>  		break;
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +		r =3D IS_ENABLED(CONFIG_64BIT) ? 1 : 0;

Maybe we can return the currently selected mode for a bit of extra info?
Another nice option would be to return a bitmask of all supported modes.

I think userspace has otherwise no reason to call it, since it's fine to
just try enable and handle the -EINVAL as "don't care".
1 syscall instead of 2.

> @@ -212,12 +215,31 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> =20
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  {
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +#ifdef CONFIG_64BIT
> +		if (cap->args[0] < HGATP_MODE_SV39X4 ||
> +		    cap->args[0] > kvm_riscv_gstage_mode(kvm_riscv_gstage_max_pgd_leve=
ls))
> +			return -EINVAL;
> +
> +		if (kvm->arch.gstage_mode_user_initialized || kvm->created_vcpus ||
> +		    !kvm_are_all_memslots_empty(kvm))
> +			return -EBUSY;
> +
> +		kvm->arch.gstage_mode_user_initialized =3D true;

No need to have gstage_mode_user_initialized, since if the user could
have changed it once, there shouldn't be an issue in changing it again.
It's the other protections that must work.

> +		kvm->arch.kvm_riscv_gstage_pgd_levels =3D
> +				3 + cap->args[0] - HGATP_MODE_SV39X4;
> +		kvm_debug("VM (vmid:%lu) using SV%lluX4 G-stage page table format\n",
> +			  kvm->arch.vmid.vmid,
> +			  39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);

(I don't think this debug message is going to be useful after a short
 debugging period, and it would clog the log on each VM launch, so I'd
 rather get rid of it.)

Thanks.

