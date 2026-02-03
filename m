Return-Path: <kvm+bounces-70090-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gImcGJ9ogmmETgMAu9opvQ
	(envelope-from <kvm+bounces-70090-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:29:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9ECDDEDB8
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 225AA3067A28
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 21:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5031536AB64;
	Tue,  3 Feb 2026 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Kb73YfIX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PP1A2oEG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BDB2A1BF
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 21:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770154037; cv=none; b=pBA+LSAei5n7r5WpseA9VO7JngBWzOZt2HVB35o2Bs4MSG0ATHmhP+GGY3a6Fz2jtVM+RtOPT4O8PV2r0prFvgvj6Wo3nwEqDVFhu4qkCMvPB1etrAVwCoGTp9LTYpfyqASQNh0tYp6FEqKlfzibTL9d5Wc8r0AArvm8jmm1sUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770154037; c=relaxed/simple;
	bh=zqnprRyZRcGU4YyrflNwRIudKW+IdpfYNqfznl54BDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRSFwKaoNtnZcZ1E2q+U75fy3BLDnAmX7MRL8PIhxz13PURWA/vZDFngTCbr4EPV0Aidqw8TFo2O07mNvRnbRFwq3jSzCEcA4w1jk7kYI4vknzbMefGD76DdXInQ10+gUPC52fTMRKBzOnJ/l+FVlu6BybbG1ruSm6QnYFcs8X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Kb73YfIX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PP1A2oEG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613Im0kQ2154790
	for <kvm@vger.kernel.org>; Tue, 3 Feb 2026 21:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Tz1a6xsKW0DDS5mq5QeO0TOyjfRK1srfv9pCRWVxbLE=; b=Kb73YfIXSmTcR7d4
	RlyaDCniI7YeU7LMIO9bX4/1FnCN05gtV+1lh/rWKPjr6c6OUzuI/xzLCVjs0m5k
	BVtZATrWM9YXMJrXia7vyBObHcatr/A/fuaxqkHEvTpEoXVUBzzfoDEefeoh2h5i
	IGeg02PrcidCJhe7qU5Yg9jZUqQICqwhA0kZA4fjm5jzLMqB/KKILdOY1fwLiuBL
	3dNQYdGvr+1eq1hjkA5sc97Vsk7xialvB/2Z/AcWYKspTSSZXEKgnNY0g1IrftZn
	azWRE+0ywQMyOt8LuWtZHTRCwAzb1foz6f7Me+f8dGOl5/Z374ft2i5YEoM7A04e
	GhJ8Ug==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c3dutjdk0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 21:27:14 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2b799f7a603so372579eec.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 13:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770154034; x=1770758834; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tz1a6xsKW0DDS5mq5QeO0TOyjfRK1srfv9pCRWVxbLE=;
        b=PP1A2oEGzwflz0L1RweUdFFU70U7Ne4UDBfm2gcD+YxwJ0xYcqlvydzSSNGz4ASdo3
         gJJBAnuf3wHak+6l3LbCh/ef8QnQ7knUablTg7Lh1Levr2J6hhfCYTVcn85aOgilwwxu
         anWxw5PkLkPRSnJg6PFrNO7/oSq66ybtN/e++gNGCkxFfJInL21M+BsXv/Dt7Zf6rIBL
         kTtCX0KbLsNmQvl7vfsR57Wij6AaOxdNeK8MknZs6zbGpo07+yzO6ACRJ0ISbawxtk5Y
         pKCyCvUM01DPG9ZwkXLI2y1h5RNLxaAbCAuK3m6svAhwN36uyoTt4gQjOxy5f3hGZTm8
         TjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770154034; x=1770758834;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz1a6xsKW0DDS5mq5QeO0TOyjfRK1srfv9pCRWVxbLE=;
        b=CSfCcG9JEfMAraqJPHyHjJ+Mf3bGGDOAwvXMOGSEAgkt03lU5THteJryIJMhmYGrDz
         Hexd7n899n5L+RHKdJR98I4lFP/hzialg5AdNqHFxGPOUvwmMmESkfJuoPGt5k4pbpJg
         8MwErKd1ZZWAb74ne2PUsiS+F2mbjNMk92bZwbxI6skCZ2vuxuERDFDMyjTvi1s8swFf
         RueWgCvuoLTCB9x2uxNsTAMXkp/zQhVe25YBUpjGclqP8gOyXMq9DLrUQCTQ47STqxNm
         t+CEWqzuXc/Tsf+U0kqf4yulDej8n17oC0S/EuKlzy8XWhpj2vP5O3a0e9xQLKPypHFJ
         BVRw==
X-Forwarded-Encrypted: i=1; AJvYcCX3AAdswkxF+m5S+SjqsR7bNvL7cmiFb2DExyJQtWMKlflCfoHgaD3tym5YsDFM4IlrEFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbU61MA4yU8XuuLPyjuBIjaw3gM+DITcpawlu1Fe8maXrZ0h8R
	ext+stp5rilw5R+vizPV4v2oBGNQ9K/RLSHJdnQEr3AoXbrp9uHsri1x59tNwoBqHuqRRaiOnkY
	mxatozvEdXxZcnhDzL8dzB/iAr0FiuVDGah5o6i3BAu6w1ku9lKiSmRs=
X-Gm-Gg: AZuq6aLA6IWz0PFaJj9NONQVfkcESTQZ3ehjHr/oNSLUr96lFwi1grc2gIbHPkaM0pH
	Re7TMqANqUZ6f6Qw21ssc5Y4XF8BNFDBD8pibTrRGbVGxYveYyAWQ7zxxBK4L9O/zXdMgTn8r72
	bA16XlOpGFq6tZuJjxF9TstN3qpijuA//5+uEM+uDIyi/cXW6EGlwOJSHnziD/JerHTX8ZxWFqg
	3dMbbs8d33Hh0UHPXNI48vqLLpccZkLLLV5ItFJoCKYCvM0WgzTE2Y2UbzIstFEWdQzM/DUX6hp
	kRJ0IS2oPZekQZIu4ZxBLcJGCKyVy42/dyABsmYYmNuAFgmuVxayChl+w9/fVAvsFJ07yQMr0Bl
	ROzHDSV7MirvuKnwNre8=
X-Received: by 2002:a05:7301:6094:b0:2b7:5e35:fa9e with SMTP id 5a478bee46e88-2b83287e6e9mr528559eec.3.1770154033829;
        Tue, 03 Feb 2026 13:27:13 -0800 (PST)
X-Received: by 2002:a05:7301:6094:b0:2b7:5e35:fa9e with SMTP id 5a478bee46e88-2b83287e6e9mr528545eec.3.1770154033326;
        Tue, 03 Feb 2026 13:27:13 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832e4cd26sm463464eec.12.2026.02.03.13.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 13:27:12 -0800 (PST)
Date: Tue, 3 Feb 2026 15:27:10 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: radim.krcmar@oss.qualcomm.com, ajones@ventanamicro.com, alex@ghiti.fr,
        anup@brainfault.org, aou@eecs.berkeley.edu, atish.patra@linux.dev,
        corbet@lwn.net, guoren@kernel.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, pbonzini@redhat.com, pjw@kernel.org,
        rkrcmar@ventanamicro.com
Subject: Re: [PATCH v4 2/4] RISC-V: KVM: Detect and expose supported HGATP
 G-stage modes
Message-ID: <fazd2fcfuwldtrarm6aw26qa5g6fcieoa35xz3bwchif6qfutw@xuvspa4e533b>
References: <DG4PS6NRRUC1.1FL8WBJVEEM4D@oss.qualcomm.com>
 <20260203142422.99110-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260203142422.99110-1-fangyu.yu@linux.alibaba.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDE3MCBTYWx0ZWRfX9jLID0By28/I
 OJINM8X+MUBjWbKP2uS9c9atm+qF+Y4n4ePg91XHqtyohy8w0ZdySEVv1NHjEe77UsCvcV+1BLg
 3Gtn4NVnK3G+hbcQIqSVVmiZ/sdrRXWz04bex4PuDQblE37Z78y2UN7QXJky0wruH6j04TIpymV
 TwvX7uj+Te8jVVANfANXdcEVCTgWcIIYf8FfI7JwAiExf5TAvGicqbX6JdeMvqaIj2LQTeDertK
 HyCPZE+bwbOC+3uDrHlPOkOaJ6rytyTBc03N4ka1eYd6TWgN/sWnJtt0456ew2YMyXrpehlNTmw
 /nohCA0RUaPv/ks6/Z4T1H/kvCzRWipA6F0hsHXwx8Oi0GTLt9/tltcRFnv6gmSwhgL+jpUTELt
 a1Lrx3rnKiiBllsPBzEJlSv9haz7E0wFY8Pz4fLeYAnz7R3WBhaWp0yPN6MAvgiJgO0GbhrMVku
 rPBfuigNwSRDWz4Uqjw==
X-Authority-Analysis: v=2.4 cv=FrgIPmrq c=1 sm=1 tr=0 ts=69826832 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=Y6f1DytA9gW5mLcrTH8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: avwMggsGA_O6_fBY-66HVBwRgOfWnNLq
X-Proofpoint-GUID: avwMggsGA_O6_fBY-66HVBwRgOfWnNLq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_06,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602030170
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70090-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oss.qualcomm.com:dkim,qualcomm.com:dkim,alibaba.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[18];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D9ECDDEDB8
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 10:24:22PM +0800, fangyu.yu@linux.alibaba.com wrote:
> >> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >>
> >> Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
> >> supported by the host and record them in a bitmask. Keep tracking the
> >> maximum supported G-stage page table level for existing internal users.
> >>
> >> Also provide lightweight helpers to retrieve the supported-mode bitmask
> >> and validate a requested HGATP.MODE against it.
> >>
> >> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >> ---
> >> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
> >> @@ -75,4 +76,40 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
> >> +enum kvm_riscv_hgatp_mode_bit {
> >> +	HGATP_MODE_SV39X4_BIT = 0,
> >> +	HGATP_MODE_SV48X4_BIT = 1,
> >> +	HGATP_MODE_SV57X4_BIT = 2,
> >
> >I think it's a bit awkward to pass 9 when selecting the hgatp mode, but
> >then look for bit 0 when detecting it...
> >Why not to use the RVI defined values for this UABI as well?
> >
> >There are only 16 possible hgatp.mode values, so we're fine storing them
> >in a bitmap even on RV32.
> 
> I think this is a good point.
> 
> Using logical bits 0/1/2 is indeed less intuitive than testing
> BIT(HGATP_MODE_SV39X4) when userspace passes the architectural HGATP.MODE
> encoding.
> 
> However, if we use “HGATP.MODE encoding as bit index”, we need to export
> those encodings to userspace. Today HGATP_MODE_* are not part of the
> UAPI, so userspace would need to hardcode magic numbers.
> 
> So if we go with this approach, I’ll add UAPI definitions for the HGATP
> mode encodings (e.g. #define KVM_RISCV_HGATP_MODE_SV39X4_BIT  8, etc.) and
> then define the returned bitmask as BIT(mode).

The best part of Radim's suggestion is that there is no need to add the
bits to UAPI. We can write in the documentation for the capability that
the mode values match the spec. kvm userspace can then just look at the
spec to determine those values and create its own defines (which QEMU,
for example, has certainly already done).

Thanks,
drew

