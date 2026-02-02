Return-Path: <kvm+bounces-69905-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPuxMub3gGmxDQMAu9opvQ
	(envelope-from <kvm+bounces-69905-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 20:15:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3C8D070D
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 20:15:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E8E1304523E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 19:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CC72FF669;
	Mon,  2 Feb 2026 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S4pPMtsC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h9zEvVgR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEDF2FCC0E
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770059667; cv=none; b=Fb32z7AolB/KlFccD8F0+2vmDGD8ZsIQs2Ps3YCY4AT/+JanzFCWdhTibHrywUr5f0jBDJYwtKMuBT8PSx1vFX1mIy1Ep74g6I1irofFXqcbkKG8SulDohzCxmOh8U8sjxmicD4mh10YM54ViHS06ERAPV3+crCdXtfadp0W+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770059667; c=relaxed/simple;
	bh=PdWYVM9bQtDe0TudJddgK+d7dqdKR0v+WMWn+GfPpOI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Mdcm7HSbRmoKmB98Y/MyUopJebkYUOLraC2AUtAchzreeJtkBHE1cKmQrHcR/XL1p7gZgcjTi5hWuXWXe9YzxIuWgVtfOvxa7HARxyCctnVRnKOBnK/s8dMZ3MdmyWRVNHnGmv3giAvEGXoWCyEsLfoqtFu8KefxN6om9iaA/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S4pPMtsC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h9zEvVgR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612JD75H2261991
	for <kvm@vger.kernel.org>; Mon, 2 Feb 2026 19:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/8zI+RIop4TnDr5DdAUmDHiyZhpKs0Nv2xs4iv2+KGE=; b=S4pPMtsCc78QnI5G
	/VtZ9+pEPulUv/gY0C4oEuQlmLvZ5LxZDmQeMk/oXwp2u2Z/FSopfMRZlITtFVtm
	AM2gzLtqaigijBFZRqxGUY8MYRfHB3ysBtr5XzRIQ2CEdaBamMBz0IH/nNGwu170
	HrJqJAmRpH+wVy07ZoyDzi7hrUkoNS6SJiy+TMOZanhSCOivZrtxB1sxqD1a5Rug
	6inUY+m/XSR38YQC8/VWtLgZ3dDKDeIj5hezzRQKu3WeBCBQvL4FmstGDRvLWfy9
	c1xcrFm5JzmgG5xson/0wfZDrR7LDNgNgPJi5ZO66jJP574sUtO7yoqU/VioeFuO
	dzj00g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2tmthgrt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 19:14:24 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c70cff1da5so1280344485a.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770059664; x=1770664464; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8zI+RIop4TnDr5DdAUmDHiyZhpKs0Nv2xs4iv2+KGE=;
        b=h9zEvVgRO6HvxGAQ6W4C/kCt8ihS01yLCGlCUnYaSaROqhWRZuaJHIbT5c4/AArq2v
         SUzFDNBOeEbCAg2Fj/p7XUVErvTGsGUCWaX9t3QLL8uXZ5uE/PoNz+yyCmLQGfvw/7Ow
         u9tNGCtPxD5iW8AzUEmP+nXmZaIRY3IXzbul8824wt+920gGy8WUkDOObE1TOOxptlkq
         o7RW7gcDVnzpNd80WBGWMEhG+lryQC7ldXp7yZ9pqkM76DbeX8HChSEztLVYzePhYgAf
         yXPcNreTwdfg8YQX89HjZkk3buWNbp8SGl0PAe9GSWGL5OXecIZmw6PQ2WBOVF91g7OQ
         t9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770059664; x=1770664464;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/8zI+RIop4TnDr5DdAUmDHiyZhpKs0Nv2xs4iv2+KGE=;
        b=X4YZIrZT36o3MEUEtmLlNCi1tK02HqMhppNY6kJL9E2y6BTUYAT0FQdM8rN7Ac80/v
         +GZh/w78Pr5YgIyZ2beIoLgtsJAwKYNL9w7CfNavzLmMxB8Xy7/Z1Clp9vrZDIelH3e6
         n1KNSutuHuNjxZ0ungqH37DYTeEKvqgfey7r2I1iUfmTev3wO57apWby09l0LcQUY6Rz
         5FNx8mjhtVnMgJQy/nrdReyF0CuRjcrSdFUmyMd+5Fx/swcdbbOnFj76rMKMbzJHWQ68
         38DpCf5/09QTMjLdGLB5sye9QSef2rgIKst4rsKn7d8Pft1quIikvxg04wOh5/fE4/C6
         qGUg==
X-Forwarded-Encrypted: i=1; AJvYcCUtxSu1Q/DGApEILx+7m6CCapFKxaYawbBatRIn/Xwc6SCiax/Dh/6TXyiaupIFedI3YoA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHjGHoMgmqR8hl0l24ff1/N3L2c7ga/Lb4zbysUti7lqNZZQMU
	LljGpBZ9qfFtPW22E2n+8HWNvyCb3SsAa88qnOsF1ETO7EYDtshq013Yf6y+XvxPUA3CJFwRkby
	K3TDlm0kwMy/4YRCRjgzh3BU/DKzBCqPJqNCZAZsog/alo4fp2fSvTc8=
X-Gm-Gg: AZuq6aJaGxM1/RkPt9H0dJ1TwflkwxsnwQhvxsww5nYjoaipztuo+Il+P6qW6EhJB/X
	4/DSPcW5fyf76MglQYIAzhu6zP/dBUbEqpbHQarcHkmijm0Y/+jefzUDuafMxSlEa+/xsppQn5u
	aZsDjlKC1iWuRtI56vAcqxM6OJeENFADryp69ocrDF6u1lH5vv4koL7W1deWdpv0Dmo7bUfCBfh
	V5WsjuOwA5Kj/gN2WDnMzmbxcZ66lpuGi+3zvc7Z+mYqidZhGQj2GvGZWFEmYZN8c0TAx8vAByb
	iopye2uca10x6NCIXdEkwcqMFafcx+Ic9Pauzzj6v8IjBmurD7s79sxBYlUtOYi+xfqZ55buDv8
	KOIffxKmbyHRo5cFuq7ki+dhJjCsLk5XDsKLPHFKSsab8Owm2
X-Received: by 2002:a05:620a:254c:b0:8c5:38f2:810e with SMTP id af79cd13be357-8c9eb330b40mr1572185585a.82.1770059664117;
        Mon, 02 Feb 2026 11:14:24 -0800 (PST)
X-Received: by 2002:a05:620a:254c:b0:8c5:38f2:810e with SMTP id af79cd13be357-8c9eb330b40mr1572179985a.82.1770059663552;
        Mon, 02 Feb 2026 11:14:23 -0800 (PST)
Received: from localhost (ip-86-49-253-11.bb.vodafone.cz. [86.49.253.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482e267b699sm98668775e9.16.2026.02.02.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 11:14:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Feb 2026 19:14:21 +0000
Message-Id: <DG4PS6NRRUC1.1FL8WBJVEEM4D@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/4] RISC-V: KVM: Detect and expose supported HGATP
 G-stage modes
Cc: <guoren@kernel.org>, <ajones@ventanamicro.com>, <rkrcmar@ventanamicro.com>,
        <andrew.jones@oss.qualcomm.com>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
To: <fangyu.yu@linux.alibaba.com>, <pbonzini@redhat.com>, <corbet@lwn.net>,
        <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
References: <20260202140716.34323-1-fangyu.yu@linux.alibaba.com>
 <20260202140716.34323-3-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20260202140716.34323-3-fangyu.yu@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=Xb6EDY55 c=1 sm=1 tr=0 ts=6980f790 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=HFCiZzTCIv7qJCpyeE1rag==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=PElOwc1BOWmaZxrSg6EA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: nk2AS2qAhcdYxXCa99hFvbXlIWnGXJmp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDE1MCBTYWx0ZWRfXxk+TsWy2Wtpz
 kVUWEnBIrmUFtjLUF/02/5MTfk+dn0zUx1HK9Z/Sh15pYFLCLA+KfzkStYGMxyRaAj1BAkzPWjo
 z4vKzuH/lLJh06mIlqWIY+4yzQrqZeR8vG+vHZhRw6Acam488S3GK2VNdf5KhmNB5ARLNVhd+sJ
 7QnXVRlqLTl1I48mwfRbTiPn9yi1R3C4kLy4s9O2lRerNxTAGgCWk9n9d+fB61VYZ/ePaq1qoT5
 8BhhoO+EOtYzG0mG+5ZuQmJe9X0JviI9vKm6ury4HnCeCxhKZvNFkMJDgnmmr9LHs7+UKegbUWm
 4U1sObG+CQbePScWN+UEhSIY5k6ptSg4ChM9GZaSpg2vfhiLT7VGwmgSPor9Re/pnBBT7CjRx22
 YgiB4nD35bh1hahLwZg7zF9hJJd2Nu3dhw0a7koFp1KaT95EpVW2w00RzAr9Mn1GzYXk4JUkfw7
 tXYFmL7LPppiQZYUIeg==
X-Proofpoint-GUID: nk2AS2qAhcdYxXCa99hFvbXlIWnGXJmp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020150
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.87 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.79)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	TAGGED_FROM(0.00)[bounces-69905-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oss.qualcomm.com:mid,oss.qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alibaba.com:email,qualcomm.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 2F3C8D070D
X-Rspamd-Action: no action

2026-02-02T22:07:14+08:00, <fangyu.yu@linux.alibaba.com>:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
> supported by the host and record them in a bitmask. Keep tracking the
> maximum supported G-stage page table level for existing internal users.
>
> Also provide lightweight helpers to retrieve the supported-mode bitmask
> and validate a requested HGATP.MODE against it.
>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm=
/kvm_gstage.h
> @@ -75,4 +76,40 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gsta=
ge, gpa_t start, gpa_t end
> +enum kvm_riscv_hgatp_mode_bit {
> +	HGATP_MODE_SV39X4_BIT =3D 0,
> +	HGATP_MODE_SV48X4_BIT =3D 1,
> +	HGATP_MODE_SV57X4_BIT =3D 2,

I think it's a bit awkward to pass 9 when selecting the hgatp mode, but
then look for bit 0 when detecting it...
Why not to use the RVI defined values for this UABI as well?

There are only 16 possible hgatp.mode values, so we're fine storing them
in a bitmap even on RV32.

Thanks.

