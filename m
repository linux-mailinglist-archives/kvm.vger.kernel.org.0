Return-Path: <kvm+bounces-72153-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uO5BHB2coWl8ugQAu9opvQ
	(envelope-from <kvm+bounces-72153-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:29:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D94831B7A5A
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E7A53302BDEB
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EEC26D4C3;
	Fri, 27 Feb 2026 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gMN6reQx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XqbYS5QE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED21123E34C
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772198937; cv=none; b=GI0nBimc7K99e4TvS5YY/8IEx7OCiQa3WyDphg6gGKNKE013M3Jhzuc9PxIt9CBtUenBoRP0kpMOrA+LQdBVuuDQNjQ2hWlSDWTcDgzF4P5OrVTPQzGXMlesS+oJJWw7EuH1mJPjaLKyaMs2ZVaR7I+7Ke8WgirtPd470ZSm0IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772198937; c=relaxed/simple;
	bh=ywQttif3CalR9NUeMqe0jrGf5rptr1jELNO/5/jL9A0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=bGo5FNA/TxCS8avTEuSSfnSMygGWMm1CBQP18M9oyChBVKKG11JbZiN6Je76g67sCB7jcH+spavYGTKvDF/u/w7ZhD0llu2exhqk4+inDwMLLUqgsAkVCDUsdlfx7XCRrBoRgDmvsAJTRw5zH/U93OF5O0n1JEWbrdMH6HWJDHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gMN6reQx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XqbYS5QE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R9chD42402979
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	az4A8WsRSQIRPaSotZ08AsqnlM/RQPqIKqEzlZWYba0=; b=gMN6reQxhwE+cY0e
	1i2jQY3avQAz/Eux6j5Ou9pjJcaJXBKsZqkB0v8UtRpcUeBt8kxc50SxK5cdGN0x
	vy7H6+ikVAJ8qVKPtDk4sgoqIDFWzgejc2kNn7HD/kLTvtxe5EakL69qayNZu2pl
	oOT2Iw2vhAgSRVz+rO7563JOMa6CxXMFUMnjyTggW8Dnnrc7VykQA7qRtOBSJ4y3
	mcqmLzmUGQROrvZfJESD9hHWlx/4MqjZBNEh0dAqb7XxP2XCu6ielY6lp54RjoFr
	gB9Jo/QSP+58/TXO2YBQ/1rz7FiuZ9E3yoE1jxMk8xnuoh9D+6KkSkMI7sJABIf3
	Szv4ng==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjw23awq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:28:54 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cb52a9c0eeso2689461985a.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 05:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772198934; x=1772803734; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=az4A8WsRSQIRPaSotZ08AsqnlM/RQPqIKqEzlZWYba0=;
        b=XqbYS5QEEw2WMm+IXIji8KC+OinWWPbYsIo0LlfdfS/B/gqsG0j7m45BBQbGJOp8eY
         bhZc64T0rga4YWz6qJnDbybV1mLr83Aw0NMNNOB54mUul2RiS+FsnOGv9rSxcQYP2Jg3
         FZ95WjM27z3ttkTX5Hsz5SQixw2fN8i8WkHr7YJNxhxamMvSd37IDVV0YIB4dp3Hy6yI
         h8Ho7AAh7eoNZ0ETRmjbHsjzCyyZs/HAf2ZzxdN8aCSSLBBuegXFUpvQQ/nqzZnO1DpV
         aLyAph6tZWhO9pUzRtSAE//Rz7mpWacTRiWARfJ0zCd06zr6eP8ludjKPGSaa4allrWB
         BpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772198934; x=1772803734;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=az4A8WsRSQIRPaSotZ08AsqnlM/RQPqIKqEzlZWYba0=;
        b=Yo23jVgQjiTc3TGmTwouaGd6SLjTTDDpKh01cRNBIDgO6ZMPV9d6qnP7eZoD+w/7Yb
         DKFu3xMuC2hHmr3irl9b2lWurvHxgLxNNcqoQf0JdB9l/9RpVFC0fFJOMmkgRj8vM6WM
         Aax7L0AbZkMz6t0KEnpjkEmuG6Pj6c2P1dPSXDPWJiRIWwx8OAWuFk0lBcqu80XHymwi
         d2IoKjbMFgaZyi2quxjCxL1L5G6HxPDRqBd6/IsOferBwWz/hyjlY+kUZDuHlyWC/lmZ
         LXTCI99InT0fEGTRbTBZ8JbP5sKffWuXTS21HcD25bw0vuTyAreXh/hhdZBxuv8YevNi
         d0rA==
X-Gm-Message-State: AOJu0YzFpk2GsR++S76GMQkFFmbyETmMW2jhx25u6G8a+6oYtQeyaXDd
	2g4EuszviwmOJsbpQNj4cD738388a82TvsK6nA0LE4WFJ2AY6xhy6ySM/67Iygxv0X1oS27CQUT
	WvyGXCd2xTPMWl47jqCUF2YLYt2oXrZZRdqmyj44ec6q1xjEim43SF2A=
X-Gm-Gg: ATEYQzyB6T1dSrRNdXOLYtQFT4AADzxPIRWWZLjIf8JPm1slNC6lVaG5lwjQssjV6GP
	Ssb2IwHxsevGqN6zK8QGOQLxpulaMIFaSfT05Cya9k5Wj1UXW7CuEK7iH8c2l9s8UcITVQOFfkm
	D9Nhee+IwCm09G9DiJzwoqdNoEwh1DlaN51tWw7R7IMzzhNF+FV048MlYb3CkznHTaZOOT1WCKu
	jh85l/wRNd+OkGowjNj0nFAdfgj8oG4YzyFqDFE85IhipoSZUijtiFtI1LC/Gp+N32kl7dzagVl
	VFFaH/JB0KoMAlfNplsSQdYhh4fJ1FJDj+di5hKtYacGnwxAt2Y5bLnKbXFJ+hqQDWRx1Zy1SPu
	PSQhmYcEvZpoJJOJSytF7AhrVrgBFg5N3EB8HbqcQCHtvAZn52oRyLDR4xRnN
X-Received: by 2002:a05:620a:7108:b0:89f:8bb8:c103 with SMTP id af79cd13be357-8cbc8df0b7fmr340489685a.49.1772198934182;
        Fri, 27 Feb 2026 05:28:54 -0800 (PST)
X-Received: by 2002:a05:620a:7108:b0:89f:8bb8:c103 with SMTP id af79cd13be357-8cbc8df0b7fmr340483885a.49.1772198933454;
        Fri, 27 Feb 2026 05:28:53 -0800 (PST)
Received: from localhost (ip-86-49-242-13.bb.vodafone.cz. [86.49.242.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ae93357sm145840866b.48.2026.02.27.05.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 05:28:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Feb 2026 13:28:51 +0000
Message-Id: <DGPS39X0VRTU.3ATPEH33LUF1G@oss.qualcomm.com>
Subject: Re: [PATCH 4/4] KVM: riscv: Fix Spectre-v1 in PMU counter access
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Daniel
 Weber" <daniel.weber@cispa.de>,
        "Michael Schwarz"
 <michael.schwarz@cispa.de>,
        "Marton Bognar" <marton.bognar@kuleuven.be>,
        "Jo Van Bulck" <jo.vanbulck@kuleuven.be>
To: "Lukas Gerlach" <lukas.gerlach@cispa.de>,
        "Anup Patel"
 <anup@brainfault.org>,
        "Atish Patra" <atish.patra@linux.dev>,
        "Paul
 Walmsley" <pjw@kernel.org>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        "Albert
 Ou" <aou@eecs.berkeley.edu>,
        "Alexandre Ghiti" <alex@ghiti.fr>,
        "Andrew
 Jones" <ajones@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
References: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
 <20260226-kvm-riscv-spectre-v1-v1-4-5f930ea16691@cispa.de>
In-Reply-To: <20260226-kvm-riscv-spectre-v1-v1-4-5f930ea16691@cispa.de>
X-Proofpoint-GUID: ViTkmbBJhVFjaG1yu-5TVzNLMmXyBifP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDExOSBTYWx0ZWRfX9ASEQ96B66CH
 BN9NMa9kk818Coc55Sl0Iig8ikyt1Hy/83v8EAXS763U+jlJDaqpiWZ5c3CwlIA041dMosTJAKv
 3GOY1tz4rNjJKlsWV6WicMJcqKI6RyyNtSh+Bt5XsLY6UpidbZvKtpyAdQLKXgGN/qJUA067rEw
 hVXwAtBRZ8HOrdw+BEX7qwEc54mOK6Ov5CZiA8NYg990b8KmLAVFt9SdtOAKRN+MrSXI8tv/eIX
 49IVGWbNjfqlhY3+IWTGxcoaL1iAfzqcYr744MO8vChturY+ra0NO82F9mTkome5FBD943B5cTC
 0l4LdGlZ0Y0iPUX8p1plfJ11PmoKlJufShpN082lFdLuHUOjQJsdErKESNaLgxRXn7RV0OYn4kI
 b8OA9ajKJQTsXsBPnqiIDMkcr+inylPJ38aQGvU5G4dzusS0ZE0hlL/+02NxgC37pCB8IoWTU7r
 M7RqIkuM7WM2jrCxFEw==
X-Authority-Analysis: v=2.4 cv=cJHtc1eN c=1 sm=1 tr=0 ts=69a19c16 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=9tUHzIdeCh+UoOnba06Qjw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=l_Klt5aIuPl-FdbJcjgA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: ViTkmbBJhVFjaG1yu-5TVzNLMmXyBifP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270119
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.72 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.94)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72153-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:email,qualcomm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,cispa.de:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D94831B7A5A
X-Rspamd-Action: no action

2026-02-26T15:19:01+01:00, Lukas Gerlach <lukas.gerlach@cispa.de>:
> Guest-controlled counter indices received via SBI ecalls are used to
> index into the PMC array. Sanitize them with array_index_nospec()
> to prevent speculative out-of-bounds access.
>
> Similar to x86 commit 13c5183a4e64 ("KVM: x86: Protect MSR-based
> index computations in pmu.h from Spectre-v1/L1TF attacks").
>
> Fixes: 8f0153ecd3bf ("RISC-V: KVM: Add skeleton support for perf")
> Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
> ---
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> @@ -525,6 +528,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu=
, unsigned long cidx,
>  		return 0;
>  	}
> =20
> +	cidx =3D array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);

This one also covers a non-speculation bug, since the previous condition
used cidx > RISCV_KVM_MAX_COUNTER. :)  I'll send a patch for that.

I noticed a few other places where mis-speculation is possible,
see below; can you explain why they don't need protection?

Anyway, the series looks good,

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <radim.krcmar@oss.qualcomm.com>

Thanks.


---
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 4d8d5e9aa53d..08301b6033f0 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -87,7 +87,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pm=
c)
=20
 static u64 kvm_pmu_get_perf_event_hw_config(u32 sbi_event_code)
 {
-	return hw_event_perf_map[sbi_event_code];
+	return hw_event_perf_map[array_index_nospec(sbi_event_code, SBI_PMU_HW_GE=
NERAL_MAX)];
 }
=20
 static u64 kvm_pmu_get_perf_event_cache_config(u32 sbi_event_code)
@@ -559,7 +559,7 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu,=
 unsigned long ctr_base,
 	}
 	/* Start the counters that have been configured and requested by the gues=
t */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
-		pmc_index =3D i + ctr_base;
+		pmc_index =3D array_index_nospec(i + ctr_base, RISCV_KVM_MAX_COUNTERS);
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		/* The guest started the counter again. Reset the overflow status */
@@ -630,7 +630,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, =
unsigned long ctr_base,
=20
 	/* Stop the counters that have been configured and requested by the guest=
 */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
-		pmc_index =3D i + ctr_base;
+		pmc_index =3D array_index_nospec(i + ctr_base, RISCV_KVM_MAX_COUNTERS);
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		pmc =3D &kvpmu->pmc[pmc_index];
@@ -761,6 +761,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *v=
cpu, unsigned long ctr_ba
 		}
 	}
=20
+	ctr_idx =3D array_index_nospec(ctr_idx, RISCV_KVM_MAX_COUNTERS);
 	pmc =3D &kvpmu->pmc[ctr_idx];
 	pmc->idx =3D ctr_idx;
=20

