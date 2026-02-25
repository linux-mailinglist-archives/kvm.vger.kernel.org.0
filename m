Return-Path: <kvm+bounces-71887-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIjOLSNbn2lRagQAu9opvQ
	(envelope-from <kvm+bounces-71887-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:27:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BDA19D312
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C600B3115AFB
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E43330CDB6;
	Wed, 25 Feb 2026 20:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jycbxzVZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jKr9rhCy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230A830C361
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772051074; cv=none; b=kBEviIWALzMIk2sS8MpcJNMm99j1qZ2yRbXTfZboGaZi3cf2e+1Yxtoxa5S3vwfiRQ2YZIqQCcxv1HPPgp2PIOaqjSn0U8ElPqKsVxq9wQ1t9gCYY6mmpRlSywgRKeQ8eKEMYRcfwPMMEy63c3NnslsK/wtaMcDoLnNoni72q68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772051074; c=relaxed/simple;
	bh=blfiAhqk5wSihJs8lThFww0GGUzGfALeIXzqOsyfO64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAIrBhj3Q5Ywl7GvrH53P8oWsZU5Js5yvXHGDP0d7RFEPPM8aCArmHjlDbjZy034JIa67YjjHWnQRNiqqPzCWTxIJNXiqmyN4gW0XlBgSpGVh5CITm4TFo9BcP+Mi7AXy2bdDsJClbAwX08ZnDKfBHYTnt8eSgYPX5BwGThcE60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jycbxzVZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jKr9rhCy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PH4bQ61363583
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ViM3bl/bhSwh8kkJsBsCCLgQ
	HaybEDvS+RnPqWJYUig=; b=jycbxzVZxCPwB0Wm6fMD8BMxRMoCpxf3Fa8xUSwq
	Q/95DIUkpR4zp/21/Ao3lTEm637b1sn0VzRZJw7y6LbIkT0dfNSfW3lJJpHBAP7z
	MCL62hcovmylKC+yQJDBno3fX6oWA/cQyHnPG0J6Gprsil0O129pEzLqR9L6HBzw
	RVKvX0ilA6zzRaW/dRvf31rNNG9tklNZ9ZPJtPgqJovWO1/5r2j8hfCuos8NL19N
	hafj1hTUe5tvD8vdBYdkdEE47QdkjP2NhOBoB70NxTFJaFXZCB+iyyrqX3llIUEK
	PlcMkgVwzsfeZXgb0uipGLq8xQkFB7nZ2vgmOTQ/MhQgXQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chp15bfs7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:24:30 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-12721cd1a2aso1411054c88.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772051070; x=1772655870; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ViM3bl/bhSwh8kkJsBsCCLgQHaybEDvS+RnPqWJYUig=;
        b=jKr9rhCyVpfBMETqEGRGyI0BY8a1UkVFLjUJltrYcpiunW2Nk9vS9lMsbDzTmVmrBN
         zjz3rFBHbFtsBJkwe1angcyS6GSh3XSN+BtRjiaEjMUwTAcfX3ZTA+Oyh2WBooCygCS8
         fLCF4romodkIonwp/UVU6BMsecvgPHgabYBJ/ItdhUznniHz1x1QL9OvZzMNGbCVOd0V
         1L2b7Us2uci08wjVIoWyUKDuSDfvt93/WwX1PsfKFwitY32FcB2i8eFQLlwDUMF8ExMW
         7xuUAjYL3oKmy/4fPpU4WrES+wNaaTnRC/nL6/IP1VY2g54O5s60QbO30v5nOH3XwFwN
         pLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772051070; x=1772655870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ViM3bl/bhSwh8kkJsBsCCLgQHaybEDvS+RnPqWJYUig=;
        b=gYtIjcmlawdqeKXElOM4A7PR7Hws0q1mYRtmP8QB3zUB17t59KApqtO6Qzh9dsr7Vp
         WjTHCWDzjsAW0XCrNr6OSegyOIzDsyMeglpnW0H4z7cmkYjV/8DL12+VRfo/rhvfUUMu
         o16UTNHUmldXJbuXu7tHUMm18OPE+YYKYEZ0w+/WStwvXGH59UsM3pbpUT3VGgfyMi+Z
         f0j0Wl8coJ8VnsAYv0PJZpONHr1HN//mqEncWCy/uC8tFVhekyxXKxEHxdfOrKgGTPwv
         7Neu3MbMx1A/fapDUWwQIn5IaCNolI+YSlvUVmH3NdBOPjtO22cDyZNEcPiW/Ih1syUb
         zHCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjNzkaY8ip0sbDZtjJSmzCDQQnBOTchWJPJPZYNUP7LO9hu0CWb7mJADtcERpSp4cDJnI=@vger.kernel.org
X-Gm-Message-State: AOJu0YycBrgxai37GqRrEW9r8Se8qCf4hDyzoOZxiABuuMh1pat+bUhz
	L0FwWtaY5bgd2LOylba0TG5V8fL5UI01EJDMJQ8jW6b9jUd9NzkqACRL+14eaKuDhVC0L4afHTT
	cUtE3zhVGpSNIIUfu1p6zUNN+Xd4oNG9LwIOCmgpvl26xTeANgl83Tvt8hLDkx3Q=
X-Gm-Gg: ATEYQzws8GG2g98eo5qxUZg9OLSA8Di+a0CB0orOkjbz+ZBrzqLQafpxbt0tmlLB99+
	6WSSq27sjfe9UhmzQ4cLq7uoFlnAuooh6u3RHavBCEcwyR28CRi82Jq9AmkONcMogxLBoM20ZI0
	9SR2yb88hmCQYdY14k0KK8VT7bzmID8noUVzqzfSHKMh8wV8sRoiYww5KcvMG++8T4yfc+lDigQ
	jkf0aLq7dswQXE1ggBvP2qhc9xbGm/DM9SsR0X1svU2C/iphh2uxYOndMqzxA+L6XtehczezYWY
	ACF3PnDtvvRLdgUANGmbQttwdd8yQzskFpiqmF0wI5f8kVv7k+KNt/jTKhF/VpV/EvJw+WMOEbY
	RgD9Y+Ei+B9CFjSwx57wN6lcVdE9LP1QU
X-Received: by 2002:a05:7022:1602:b0:11b:a3a7:65cd with SMTP id a92af1059eb24-1276acbc703mr7227447c88.12.1772051069884;
        Wed, 25 Feb 2026 12:24:29 -0800 (PST)
X-Received: by 2002:a05:7022:1602:b0:11b:a3a7:65cd with SMTP id a92af1059eb24-1276acbc703mr7227424c88.12.1772051069326;
        Wed, 25 Feb 2026 12:24:29 -0800 (PST)
Received: from localhost ([138.199.100.237])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1276af2ea06sm17068982c88.7.2026.02.25.12.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 12:24:28 -0800 (PST)
Date: Wed, 25 Feb 2026 14:24:26 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
        Conor Dooley <conor.dooley@microchip.com>,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Nutty Liu <nutty.liu@hotmail.com>, Paul Walmsley <pjw@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] KVM: riscv: Skip CSR restore if VCPU is reloaded on
 the same core
Message-ID: <srfopv36p4yeaok6qhew4md6uzo7mq4u75fr2wvxtjyk45lqvj@vuqap6n2szdo>
References: <20260225031402.841618-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225031402.841618-1-tjytimi@163.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE5NSBTYWx0ZWRfXysLzDVwIL+zF
 cK3ynoW/9H1fPt3jAF9tzpEFuXt8k/g5G9Z7fYpPg7ORCstpGqJPuSiw5oWebmr4+LAQNiZwPw3
 +8L3HEXEWInGSHmOsBYeoYr8aP/MWMHGnyN+kdIC9r3B3vCGPsz4l7VZkejD/IxcTqxuTU+ckAw
 6igttTJIYniy/hbKOjaV5stccXaI8S8XCD+fQOdq1/o+k6Olm1+YNvIUoeK6jQh9it6zVX/63eu
 YXPc3z7U9+mo7wOHgVm4fEQgfk2/OdfJZcm0y8c5r+7Wb7MItNZXm/9DGZKKcUTeBe9VHwRBnii
 I4i50CkqTbd8ZuEwGoAUHqcvaz0lMkTLaAk5Nok59sEf+ooRNBXo0K2ZllJgyTHE+PRdZ3cXyLa
 jgKT26vIpD2MHdFRIdsZkb/toJTukVWBRrCuYmpm/PWkf6fc6RYPPwsWnZ3hpGEGddRTgcNVyYx
 EIU4Nn0VWp2g2dWpoJw==
X-Proofpoint-GUID: WKd3BRbgb3ys5KU8je6yAIBng8tQA0u4
X-Proofpoint-ORIG-GUID: WKd3BRbgb3ys5KU8je6yAIBng8tQA0u4
X-Authority-Analysis: v=2.4 cv=etXSD4pX c=1 sm=1 tr=0 ts=699f5a7e cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=OC80/TC5XWgnnCQ5Z9xtWg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=xdnJNkqn3fnCMyRjZDMA:9 a=CjuIK1q_8ugA:10 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_03,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250195
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71887-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[163.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,vger.kernel.org,lists.infradead.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oss.qualcomm.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 20BDA19D312
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 11:14:02AM +0800, Jinyu Tang wrote:
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>  
> +	/*
> +	 * If VCPU is being reloaded on the same physical CPU and no
> +	 * other KVM VCPU has run on this CPU since it was last put,
> +	 * we can skip the expensive CSR and HGATP writes.
> +	 *
> +	 * Note: If a new CSR is added to this fast-path skip block,
> +	 * make sure that 'csr_dirty' is set to true in any
> +	 * ioctl (e.g., KVM_SET_ONE_REG) that modifies it.
> +	 */
> +	if (vcpu == __this_cpu_read(kvm_former_vcpu) &&
> +	    vcpu->arch.last_exit_cpu == cpu && !vcpu->arch.csr_dirty)

The most expensive check condition, __this_cpu_read(), should come last
in order to short-circuit it when either of the cheap checks fail.

> +		goto csr_restore_done;
> +
> +	vcpu->arch.csr_dirty = false;
>  	if (kvm_riscv_nacl_sync_csr_available()) {
>  		nsh = nacl_shmem();
>  		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> @@ -624,6 +642,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	kvm_riscv_mmu_update_hgatp(vcpu);
>  
> +csr_restore_done:
>  	kvm_riscv_vcpu_timer_restore(vcpu);
>  
>  	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
> @@ -645,6 +664,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	void *nsh;
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  
> +	__this_cpu_write(kvm_former_vcpu, vcpu);

This write can be skipped by the fast path since kvm_former_vcpu is
already set to vcpu.

Thanks,
drew

