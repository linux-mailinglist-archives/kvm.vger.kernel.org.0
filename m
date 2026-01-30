Return-Path: <kvm+bounces-69735-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAsGEjvVfGlbOwIAu9opvQ
	(envelope-from <kvm+bounces-69735-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:58:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DF8BC4FF
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 66C4F300B29E
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5C63451C6;
	Fri, 30 Jan 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WrHHYB5I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q605g9Sl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09BE2D97BA
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769788718; cv=none; b=L5e4rYdjZNCkmLzYmfX1FvWZ+lD6asw10HSv9nV64lMWDfv/+clyEJ6n9SqrEw743RKhbEKczRqwA7Sw0EsYvd0X5ywQnZhBAVdc9vIQWDLzrSFxgWj5lkt/H1fUMg4VTZduprC+vYbe/1laZTkHhPqnAEKMXpkzGpQSxgWKq4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769788718; c=relaxed/simple;
	bh=JHNaQF/tDX4f6NrSy7kAELk8akXPiqvpv6QvjBz8r8I=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=tMDrP5ubouaR29MQ3q4qlsLcHHoEUyBEwCgO0amVryxDBzuvD6c/Z2PmWJUOvKRRRWuVSfpQaXCwMYxDUUZS5SywqTIZYI7ENTW37f2xy6oA6Nq5LKjj5qBaCuJI3dCZsgbWgmERjcu15SMI1mtnm+JTbhjLljUiGxZFQevG4xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WrHHYB5I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q605g9Sl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60U9V1TD2675395
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 15:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lQNZhRVTVABmpgTnG4Zg3cj198URaNvQKUlnGCClzJk=; b=WrHHYB5IUzWk3xSd
	mLrptX3mVqYwutQLOSwiXhQDrtxyCqpRwXE7pmXSQIcVZbUQ3UZqG95BoFl1cLUD
	HTgyb5Rjht5SrPoMzWK9ewSHsHjSjBxrHAtRCurs3zg9qAZU4ykYiTOmXSM2BR9W
	dsFgwrbdg3Rs59TzFLEzQ4HcXl9cwwG7SVPQM3FfrHgGAHs5TRWJd5a49dFZpbhy
	giU/zPpIAMQKCggL8MRs/Y713kfc8P/ZMn28fVUqbY/RZkFS4IX8jyHaupnarTPP
	SYDvZec8LT6XzlVCY7kDchqY9m5f8rIndL3rQle4aDC3HcshG19AQr8Q2/cnUe+y
	jpyktA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c0t341642-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 15:58:36 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8bb9f029f31so644395185a.2
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 07:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769788716; x=1770393516; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQNZhRVTVABmpgTnG4Zg3cj198URaNvQKUlnGCClzJk=;
        b=Q605g9Sli7o3GQC1T05Ku+k47c42bcuQhd9g8zqJqpevLD9hKhWW1fDSB11ZXpi26K
         1NQes3V4DkTnhciHEguIpPUnU+heEx+N3JFoAAm3DJ+8T2VkDtCrm1uugsmNJs8aREnK
         06PgJR0W+q57TV0CZEdnicxnrQZgnaBqbatbJxOIA2fMV9zJne0JxHmCW7FMiIetWvt4
         OR55hk/QPrflZsJJM7ZXFFqVIcrRW/6deu085XCXFY/zZ9Yg3XzYiePhZFR+eWRYCXPa
         bzSCkq/kXXDZyTZGjk4ZKXouJ2QLLVoVM9KTRlhyMBZyrs1cNTmGzv/V7+oVrG93Pcuq
         ifWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769788716; x=1770393516;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lQNZhRVTVABmpgTnG4Zg3cj198URaNvQKUlnGCClzJk=;
        b=V7wRgB/pQ/eHgX6o/Pl5YwwWs1YhQhSwI9UQkGyNjOtiiIy4+lrZD+GqeWyA53w+ZV
         bVn+On/r9YNNiLKmm9q0BjfRFss7rChOf91s0BaaM29r7CrDOvvji7S1yxLrka0CCNH8
         /euxYNALSK4d/qdCMM23CTk4vZnFssaztmUhnG4BUW6I1To7armlxxoVa2+b/SbK4IGO
         OsGCrl8MQ1TPyVa6LXSApqswT3/P2bLuIpeA8ykfkOydRWalfY1jcjH1ifIgwaYpo65v
         QNnBgHnK9bn3+QgOd1ljk+1qThnpZeVNRKKlHcKzuibK8deg800d9lqt+7zTVCqiDyNR
         WAzw==
X-Forwarded-Encrypted: i=1; AJvYcCWzuvatSlAF2Ch+C8cgdMA0wBftqtlfrYx1llujxVUAf6m4XyMUDrlPurSq3+J/klew/9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnG5KveKgBiI14NgTxY3u7iIE9rICQHnKIMUZEsqZwQBlSd3/u
	RhoynMDzBYAFeMAkH1NdaDGWaxdL3x/UUP79/S6duDBoVr6a09WNGymzQqmzddG/5d9gVy04TO5
	BBizQgQcIiyHdw9MYuxDARfy4A660C5eILmCZUwk7Ar5pNq5xIb2XBls=
X-Gm-Gg: AZuq6aLVrG/TckJFaC3AJnimCt3o1e55676WQ3fImEOXhY1+JGadzif21PP6Mf2keda
	j2WZBy+QMOcCgbrHMUMf6Kq9tW7IQYIECWpIaz1kTVMsGGx+0eJonEQNneBNObLnr3W2xpfFLwv
	ZZWPj5sv3SiSyRZDgpXFgXh5yjll7nLsaw1fbz7qv+/r8FSvCSPThRtTK7gEEaDIiaJ4jjdB7/w
	9fvWej2Q7SCgGoRbfsjLCjUJa15uDth5Zl2Vuw9xrQjlUNTkl260Q2Rp6HVxw0qaNljbBiEIkzn
	zF0MrBVFoAAPiF6vplOS12JwyhaVGUvVjMH4hM5XksX/Sb4QCoBBGS5kRcyrBAdhS863QHT0kmu
	TpA1z2D+1QU1atZIwOqYbj1mywR6WSnrRMZIQzM0HpNWkpig/
X-Received: by 2002:a05:620a:29d2:b0:8c5:36be:41fe with SMTP id af79cd13be357-8c9eb32be89mr429757185a.60.1769788715897;
        Fri, 30 Jan 2026 07:58:35 -0800 (PST)
X-Received: by 2002:a05:620a:29d2:b0:8c5:36be:41fe with SMTP id af79cd13be357-8c9eb32be89mr429754485a.60.1769788715467;
        Fri, 30 Jan 2026 07:58:35 -0800 (PST)
Received: from localhost (ip-86-49-253-11.bb.vodafone.cz. [86.49.253.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482dbd4a5b8sm27030845e9.5.2026.01.30.07.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 07:58:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Jan 2026 15:58:32 +0000
Message-Id: <DG21QMIKJS7W.1OUK0OFL8S3A8@oss.qualcomm.com>
To: <fangyu.yu@linux.alibaba.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
Subject: Re: [PATCH v3 1/2] RISC-V: KVM: Support runtime configuration for
 per-VM's HGATP mode
Cc: <ajones@ventanamicro.com>, <alex@ghiti.fr>,
        <andrew.jones@oss.qualcomm.com>, <anup@brainfault.org>,
        <aou@eecs.berkeley.edu>, <atish.patra@linux.dev>, <corbet@lwn.net>,
        <guoren@kernel.org>, <kvm-riscv@lists.infradead.org>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <palmer@dabbelt.com>, <pbonzini@redhat.com>, <pjw@kernel.org>
References: <DG16GDMKZOBM.2QH3ZYM2WH7RO@oss.qualcomm.com>
 <20260130132458.16367-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20260130132458.16367-1-fangyu.yu@linux.alibaba.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDEyOSBTYWx0ZWRfXxzxz/1bIC5Bc
 3iub+hKlacHmwr/0JWcLmURx/Mak6BHiHGKFD5qvNn4RR8O4x5RXj/N9p/O108AimOzkosKYr/W
 R6YV5AET8ejYpW9rj1auW6QOfKrcma5DzY1c344w4OTHd+QgpRIMYkqQ13N9UT3M48bEH6o+VlJ
 X9OKbkzLCz5V1z8B7Zn8oo1Vot7H77uqEYkTZncoLYjSmvaIoyUgKanbZBJd6WCXXdKLH0jlY3p
 fQdXejMlr1mIWmQUTw/7sf+Zblsd9k8qdHfazW1WoC2vnORTlVh1mYc834y8OMiMJ1ywFeeuKTp
 HVNAbTkwMnjsJRdMC7V8RUGe0w1ZF56gtbNbf7GyTqx18M/Anp7sSZOUn0rHviiHcEZT5roOFis
 TV3v3W5/6NjaMMG775hEucTOPS6PejTDLGBNNR4qZ9+2PHvOHDMS/Sd8X8mcw2YlGnWajP6cLfe
 DO3r/XXBZmSWB7azPkg==
X-Proofpoint-ORIG-GUID: BPS3r_TLlPIXNCRZSF8MQKbkgVgKf2Ko
X-Authority-Analysis: v=2.4 cv=QfFrf8bv c=1 sm=1 tr=0 ts=697cd52c cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=HFCiZzTCIv7qJCpyeE1rag==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=SRrdq9N9AAAA:8
 a=655hpoqrAi3NGJe9dLIA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: BPS3r_TLlPIXNCRZSF8MQKbkgVgKf2Ko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_02,2026-01-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601300129
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.87 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.79)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69735-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 80DF8BC4FF
X-Rspamd-Action: no action

2026-01-30T21:24:58+08:00, <fangyu.yu@linux.alibaba.com>:
>>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>> -	kvm_info("using %s G-stage page table format\n", str);
>>> +	kvm_info("Max G-stage page table format %s\n", str);
>>
>>Fun fact: the ISA doesn't define the same hierarchy for hgatp modes as
>>it does for satp modes, so we could have just Sv57x4 and nothing below.
>>
>>We could do just with a code comment that we're assuming vendors will do
>>better, but I'd rather not introduce more assumptions...
>>I think the easiest would be to kvm_riscv_gstage_mode_detect() levels in
>>reverse and stop on the first one that is not supported.
>>(I'll reply with a patch later.)
>
> Please refer to the discussion here:
> https://github.com/riscv/riscv-isa-manual/issues/2208
> If Sv57x4 is implemented, then Sv48x4 and Sv39x4 must also be implemented=
.

I don't think so, sadly, but we're mostly dealing with technicalities
here.  As Andrew pointed out:

  "The H extension itself does not impose this requirement, so
  technically Sv57x4 without Sv48x4 conforms to the H extension spec."

This means it's completely valid to support {Bare, Sv39x4, Sv57x4}.
The RVA23 profile imposes additional constraints via Shgatpa:

  "For each supported virtual memory scheme SvNN supported in satp, the
  corresponding hgatp SvNNx4 mode must be supported.
  The hgatp mode Bare must also be supported."

The requirement only goes one way, so an RVA23 implementation with just
{Bare, Sv39} in satp could support {Bare, Sv39x4, Sv57x4} in hgatp,
because RVA23 nor ISA prevent Sv57x4 to be there.
Not that I expect any sensible implementation to do this...

Btw. do we target only RVA23 with KVM?

Thanks.

