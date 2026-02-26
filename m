Return-Path: <kvm+bounces-72012-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INS/FIVhoGk0jAQAu9opvQ
	(envelope-from <kvm+bounces-72012-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:06:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A66F1A83E1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD413309B24E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3144D3E9F65;
	Thu, 26 Feb 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GzGEF53S";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C/0BXgCQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE973A640F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772118290; cv=none; b=qCBbkr8TsIpWdsWv5f2MChuHoiEoBrSN3H/1zpgnEwLu9ghX3aVqSdbRZwURpqudaE0MAn5jK4pdcgchs1aEt5PZVqfLrjoGXENUpaQcMzl1LK/clAuQVHffS5OVl1IfdlHO6dq96+uO4uTM2Y8snDh+rBrg/cIeu87Gl6M0dfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772118290; c=relaxed/simple;
	bh=pYLIuNl20p7tOmh7vf2ZBTy44J0MNJ0SA/EEn65HWbQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=snZkuPMscssUkxOJsNjTIxIE19BA1ZmYPVuQbtU2qHZIoMi4GdzfnSsa2Cl6GbZ/85KJk72rzXIo2Pw+6kyvFM0Vm5hiNPyWGHW182qQ2OrqB2qjMUtoCKRq0Wzablmaekq85wqn2ZZKj/TTflgHgCNpXzrAV4pHG1w+h4cTpJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GzGEF53S; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C/0BXgCQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QAKm5B906848
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qp3TU7bzUr1B0vZ7uPapTlnahGO7pQVMf5jftO4wjJI=; b=GzGEF53SIu6p5rL2
	FSzlRnRl/1ny7hdPTi7cfN1pijd2a8AUO4dm00PcTez3Uq4OMf1cO2K4EigAUEJm
	9oZ5mw1R+zCmREzqwxByTbrKpVLrDX8UtHagBJ4JjNSHczqKXEK+L9aRfz5s8c/e
	PXNZKU6e8gR/51X5T0nwNyiO2/GLfVpML2nvU/DEE3kv3Z6TNeSX/OaoXVw8ZQu5
	3W9Cz5+M/wN6wq62tYf91lyVqwlmfyV7C8qyZ3ePUzRjlx5CkB4XsYEYFD7VneQy
	JvelPj8eN/8bsDXt/swz/lt7ZUFonpXnhSvP+Pp3mr6p1N2is5u3j8ECBgfC/XOY
	QmSXEA==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjk2v14hw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:04:48 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679c5fde4c7so21058215eaf.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 07:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772118288; x=1772723088; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qp3TU7bzUr1B0vZ7uPapTlnahGO7pQVMf5jftO4wjJI=;
        b=C/0BXgCQwe8loJ3Sq60vQGPsgnxiNjJ0wX+CIQajtoFnUafLWAlyb+/cIO94ml91F1
         QHW/4vExbqG3lHexWBba3t35Gcd084UINuBVaWc+iACtH/X+bqnT4Z1Q0GBM56mnqRJP
         30SArFJ7MHb1WEmx1g2Q+YRPUxiWUP21GoiW5QrwHwwU0Tr7NYI9hdDIK7ZtvROp268d
         TljSIuO9p53iL+8M5zPu65awVmAp203xjuKccW+s4+/GZ0sMJ6+TlvQASC+xsMgg3PFr
         95crB68LGNk2Ytf+WeCLI/qN/Juj5lfI1N2AGtPMHgEv+QdyaSWseYLmbd/TQ54+x7V+
         /Qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772118288; x=1772723088;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qp3TU7bzUr1B0vZ7uPapTlnahGO7pQVMf5jftO4wjJI=;
        b=kz8BJT2fpo/b5wJQUyvJCO4PosI/0juu24ULaCTKVuI1ki0fbHu8s2QsKST+TuyEQn
         5qLsMk2k5D3EdKwwnKxLRJhCpV5+ZjY96NMStvKWP+5VSlLD1SN7Hieit/eZIxmZzaom
         bFtSj6HRiwI+kTYlZWhqUq4K7c+vg9llbnMZvW8sIttP12ILInQEjTqqO7VrWJ9QKdAx
         N/JlC58M/qk+BcuRM2icGIe6wBUqDh52CqnhLJxiaL1yiNtQQGld8JN8+EA5wAHpANSB
         OnGAmHcT02hqo1L4ISYUXUsIC3gaPUNuK9fHZ2P5kLNEi1C9uDzKBLqTUYn02bHaCZa4
         8iPA==
X-Gm-Message-State: AOJu0YyesCzXxnmxDjReBO3KIAEck2JXTlsXGnXvFuLWiP78F6xbs6S+
	z1oNpm5wKonS8P8q6eqxeZc/3zfP+W2zjilMLaZvDQREzfrMtgQ2pwpd+I3NmN0x/8jU2IP7eYz
	UWZOAs0MD0uNAkaGM/rWBpW6erDw9qSr279ORQZOCWXGZbs0DZGQiBYo=
X-Gm-Gg: ATEYQzx6stihzmV5XKVJjg99mKCbdwaGdBr7KTXl5XixYBIG1B2e5sM8UAz85aeS7N/
	+Ccoz6aTqFIlDLPRt40/JToB9QltL22qJIAS1n1FcErHY7wF7CXSBtLTJFqR832JlLUcPecZlKW
	qDEkyATK0bJhXnYcNWSGQM84CXRjrau8hGGuMJdRgt8G3+KnMtlSCZasqyAseifH3WyzxO3lN0/
	qD1RgyYCXyTAt4n7Vk3Bqhgb/1Ci4BOj+beAba5rXbnpwTmbp0qT5z64v8w6CqN6JQ0POeqR5aM
	ZO1hFYJJdlQ+7DclZShkkYdB7ZiUfLhs8K8CaInPbak6Vm0hE2YGBZQ86nM+HhnllMRnamoX73E
	EDkaJeUV2u+1gRF56jEzhcFWuLWDY6a7UrzAhRP+6Tij7Yg4GbYO1akC2X5ap
X-Received: by 2002:a4a:ee84:0:b0:663:3c7:421d with SMTP id 006d021491bc7-679ef9b9587mr2113794eaf.75.1772118286068;
        Thu, 26 Feb 2026 07:04:46 -0800 (PST)
X-Received: by 2002:a4a:ee84:0:b0:663:3c7:421d with SMTP id 006d021491bc7-679ef9b9587mr2113774eaf.75.1772118285481;
        Thu, 26 Feb 2026 07:04:45 -0800 (PST)
Received: from localhost (ip-86-49-242-13.bb.vodafone.cz. [86.49.242.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ae6131fsm65716166b.40.2026.02.26.07.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 07:04:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Feb 2026 15:04:43 +0000
Message-Id: <DGOZI4Q6NSDS.7AQVQ7TEK9QH@oss.qualcomm.com>
To: "Jinyu Tang" <tjytimi@163.com>, "Anup Patel" <anup@brainfault.org>,
        "Atish Patra" <atish.patra@linux.dev>,
        "Andrew Jones"
 <andrew.jones@oss.qualcomm.com>,
        "Conor Dooley"
 <conor.dooley@microchip.com>,
        "Yong-Xuan Wang" <yongxuan.wang@sifive.com>,
        "Nutty Liu" <nutty.liu@hotmail.com>, "Paul Walmsley" <pjw@kernel.org>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Palmer Dabbelt"
 <palmer@dabbelt.com>,
        "Albert Ou" <aou@eecs.berkeley.edu>,
        "Alexandre
 Ghiti" <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
Subject: Re: [PATCH v6] KVM: riscv: Skip CSR restore if VCPU is reloaded on
 the same core
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <20260226123802.154855-1-tjytimi@163.com>
In-Reply-To: <20260226123802.154855-1-tjytimi@163.com>
X-Proofpoint-ORIG-GUID: xoCcsQhTgHtBbF4ERCqqJZ7b7Xs3fJoF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDEzNiBTYWx0ZWRfX79UB20w6fqGT
 xCBECY9sANurgOKD4XUSrae9FqcWrghqS3wD3o66ZWlMp705Jc+X9gz+VN9LApt0MJ4jalYMkQj
 H7hDr2wD+5vykHSaqHrzg3LaEXjxKnlCR8VysjvXMQIMK2fIRdOPSfWqqKzT/o+VeQuy73C6m7i
 EWKXvCGQGChF1fOYAyy5yTEyesH5ufwBQHbhKZiq7TpAsEhiAZ4VX6IoSLzOy2EGdXMdW/rT5Bs
 YrcNeUExUOTR3IWkXAfq/ItH8mLIZhPvIb1bfpUoF7uZHjVisL6CkIFJWfMZ22rYIsusZO8UFg4
 vWkG2j7rISF/dcpZIDyn9UiVFa4TrwL8u88IuTBa0MM1TbscemEIOqOySLcQFQxBJQB0vIGu6RJ
 R2dWZUbsEqnOqMYuSpwccAgt4qPnIiGOb6SEI4PQApbwmAxnDvGJlCqhyDensMGWcCE003EDdO5
 Rg7cedrc7H0vQKETfLA==
X-Authority-Analysis: v=2.4 cv=PO8COPqC c=1 sm=1 tr=0 ts=69a06110 cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=9tUHzIdeCh+UoOnba06Qjw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Byx-y9mGAAAA:8 a=E61YY4l4AmgQ4UnPY0gA:9 a=QEXdDO2ut3YA:10
 a=k4UEASGLJojhI9HsvVT1:22
X-Proofpoint-GUID: xoCcsQhTgHtBbF4ERCqqJZ7b7Xs3fJoF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260136
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.87 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.79)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_FROM(0.00)[bounces-72012-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[163.com,brainfault.org,linux.dev,oss.qualcomm.com,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,oss.qualcomm.com:mid,oss.qualcomm.com:dkim,qualcomm.com:dkim];
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
X-Rspamd-Queue-Id: 8A66F1A83E1
X-Rspamd-Action: no action

2026-02-26T20:38:02+08:00, Jinyu Tang <tjytimi@163.com>:
> Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs and
> HGATP. However, when a VCPU is loaded back on the same physical CPU,
> and no other KVM VCPU has run on this CPU since it was last put,
> the hardware CSRs are still valid.
>
> This patch optimizes the vcpu_load path by skipping the expensive CSR
> writes if all the following conditions are met:
> 1. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu =3D=3D =
cpu).
> 2. The CSRs are not dirty (!vcpu->arch.csr_dirty).
> 3. No other VCPU used this CPU (vcpu =3D=3D __this_cpu_read(kvm_former_vc=
pu)).
>
> To ensure this fast-path doesn't break corner cases:
> - Live migration and VCPU reset are naturally safe. KVM initializes
>   last_exit_cpu to -1, which guarantees the fast-path won't trigger.
> - A new 'csr_dirty' flag is introduced to track runtime userspace
>   interventions. If userspace modifies guest configurations (e.g.,
>   hedeleg via KVM_SET_GUEST_DEBUG, or CSRs via KVM_SET_ONE_REG) while
>   the VCPU is preempted, the flag is set to skip fast path.
>
> Note that kvm_riscv_vcpu_aia_load() is kept outside the skip logic
> to ensure IMSIC/AIA interrupt states are always properly
> synchronized.
>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>  v3 -> v4:
>  - Introduced 'csr_dirty' flag to track dynamic userspace CSR/CONFIG
>    modifications (KVM_SET_ONE_REG, KVM_SET_GUEST_DEBUG), forcing a full
>    restore when debugging or modifying states at userspace.
>  - Kept kvm_riscv_vcpu_aia_load() out of the skip block to resolve IMSIC
>    VS-file instability.

Excluding AIA is disturbing as we're writing only vsiselect, hviprio1,
and hviprio2...  It seems to me that it should be fine to optimize the
AIA CSRs too.

Wasn't the issue that you originally didn't track csr_dirty, and the bug
just manifested through IMSICs?

> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> @@ -581,6 +585,20 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int c=
pu)
>  	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>  	struct kvm_vcpu_config *cfg =3D &vcpu->arch.cfg;
> =20
> +	/*
> +	 * If VCPU is being reloaded on the same physical CPU and no
> +	 * other KVM VCPU has run on this CPU since it was last put,
> +	 * we can skip the expensive CSR and HGATP writes.
> +	 *
> +	 * Note: If a new CSR is added to this fast-path skip block,
> +	 * make sure that 'csr_dirty' is set to true in any
> +	 * ioctl (e.g., KVM_SET_ONE_REG) that modifies it.
> +	 */
> +	if (vcpu->arch.last_exit_cpu =3D=3D cpu && !vcpu->arch.csr_dirty &&
> +	    vcpu =3D=3D __this_cpu_read(kvm_former_vcpu))
> +		goto csr_restore_done;

I see a small optimization if we set the per-cpu variable here, instead
of doing that in kvm_arch_vcpu_put:

	if (vcpu !=3D __this_cpu_read(kvm_former_vcpu))
		__this_cpu_write(kvm_former_vcpu, vcpu);
	else if (vcpu->arch.last_exit_cpu =3D=3D cpu && !vcpu->arch.csr_dirty)
		goto csr_restore_done;

This means we never have to read the per-cpu twice in the get/put
sequence: faster put at the cost of slightly slower get.

Thanks.

