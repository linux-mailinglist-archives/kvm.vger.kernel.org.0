Return-Path: <kvm+bounces-73156-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id XtcED6Uiq2n6aAEAu9opvQ
	(envelope-from <kvm+bounces-73156-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:53:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80883226DC8
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6AB75307E089
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 18:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA1E36F406;
	Fri,  6 Mar 2026 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z1ANarkk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RJ55baI9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989EF1DB34C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772823194; cv=none; b=ngLQsFZWcfqcMlhi/mjgigrQOrGjxaDOAED2hVaI7zbSPQ2iyxeZMBnOafbNNSO2pw3gdPhUnfJH1zfCa+lkJwzH9jHZTlaDAfsALc9MaQlRivuvpKmL5WeovfboOzaGihtNYBf4/UwlXoNjx0VS+zpa7Li8CmjVx43IRGKDgYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772823194; c=relaxed/simple;
	bh=LYhqsVmPhSwkgmQtAbsow/O5kb6aCGfGiA5aFGr4VG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yw/asPXq38Z85jHlMM4gGF+uNK6bN/PMkQ6CYucy4lEP9/unNmOidErJj5zlRJmmiFHZGM0s+ZXuw/WBuuNGLSIbuzZew2jM298MZD2NpZ9JDYnm2T21VBV7F/KZ+qshD1+ZUC1w2cYGSWqRysHRtMlHqz+yYddWvhEHuAGIq60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z1ANarkk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RJ55baI9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626H1pFB1898321
	for <kvm@vger.kernel.org>; Fri, 6 Mar 2026 18:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=vbp1ttRZMGjxaHz3QpJiubYE
	eCxSAMpCj2BS/Tc8NRU=; b=Z1ANarkkgcNTCYsGCtI6BQ07sr77CJ5gvLjPNzHy
	Ck+e7fNdPA8bbKm556RRejS510orYKj4IRNF2gjGmYADjALjRz/oU9SvUVrOm50m
	6AyJNHyKU41dt5feCUOVgxYTG0/JORX+Mw5Qdioj7Q63KKOn5VO89q4Eg/f5XmUV
	WZI0DuEa0qOr9ogVIYlASFNTFLyFtfkxJ1CqTiAgBpTVt2eTctv0qdzyl0QfuRRW
	jNWHN1I+27K96f8ItaVaHFyptjBwVzRqnZ8q5TIkpyBBriSjESvWl+vzNlLxVCrm
	WOaLVLlXHkRXjUMCpxDST6M7xRv8INtbEZgisvm6sYZTvw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqx14hfyd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:53:12 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2b81ff82e3cso4837873eec.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 10:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772823192; x=1773427992; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vbp1ttRZMGjxaHz3QpJiubYEeCxSAMpCj2BS/Tc8NRU=;
        b=RJ55baI9SOar1hdYes3fyPzWU2/3dDznaAFOUjtVWtp1LmfKytdORmlSPVJznP0CGj
         61eC3U+jMfVMArotIWauq+ybqVdg3eU2izuZIPzQiHNT+UaW7/zZ0wNThvN6p+81OGeR
         bMeBnWp241jeBVtEMGo2QSLMcCsvhSdX6WBbhwf77oko/bBbL51qdnr1pnjfKuublwpR
         isStIld0fpr4En+lB1LTt3vaiW3AFvZTaCCaw9eci/bnAcI1Q65nocc9wH6SyAaJ5u7c
         xt6TidZkCJ5ooaecul141PgBVWW+wKjsEygV8AKnAuNsRQ8+SA8ek6iVNbB1UuWOYY84
         xfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772823192; x=1773427992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbp1ttRZMGjxaHz3QpJiubYEeCxSAMpCj2BS/Tc8NRU=;
        b=J+xB7wdbtCc4DMFlZBPx4Hh1VLIiL0MXO36zGLdDPa44M3OLpveEtULLBZB14dbvQU
         RODKVSCiahkixG3PRdL+ZxiczcNFvM47Lc5tL4oCeSWopCpiluCrPAlf7CWNIn/OLwwv
         TVaKiaW5OYrplWS9krAnl1dK6FV6opc4VeSCPVsN45F1Be+Zuz+RZA5V7rgwiryUA/r9
         nQYaLFIJriU6HiGs/Vltt07WQC9ZCImYoU3lj6ZTBOTZ+PzSJ/+oh8Rsmmp12Ebrp+/c
         ypTirRfMhqRR8DpPqUqdypPOhrBMz78n8mIrG95cwemfx6c/efyiOL6XBaccsHL98/ig
         krCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVce6/O0K/Evi2gM90JvqRGSR6+9TBK0oMPugK4PSCw7p8leP2yEWDiicfG8JNNP16BxxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwdFAgv0cp52SSsqS84m6AI90xO4Pq3hfAkf40xba7cNjKAjeS
	krNDXxgFnnHu+olFUE09veWU704f43bqy+iDaJ2VgXr9I9FEotwPaxokq8/8fnFlEETGW9pkmZ6
	VDFajl5A5/idET5xCHeSZCOYLxd7ztxfMebWEHtlW6L/BrbnS8zK6tvc=
X-Gm-Gg: ATEYQzxrmetiBWTxdQPhxS6KJzLlWhN+OcK6AK9wiRJt+T+/JFNXR844mterCWISrj3
	s7EsD9Z2b8qvgyAHPtx2nd1u/BXho0yTfUUMnzeb9P7LaU4TcfGQPm2vpA+Qu3Tc93R+qYakflJ
	TafYQsJ7Bklw6hi1fYpTqfnr+t/jSo0oGFEDA9VZY8LavpEQR1hoZYR04gylpJAZDNpI6tymaAg
	Mm6fOm79rFMmRH/PQqwjCgHSK6voKleFIvva4ZXpsLhPoIqftdKHSbh13tCf/CIWMHkKJFmNKG/
	IwxAU2JjPHcsMIeSN10Uk+Zi/qylugyFM4p27EUTLBXsdiZaZeLiIJxyN3SCtOQMRNIc7WrtwN5
	GLKOdZgi02CN7m0azh4WoTe2iNfLXeqo=
X-Received: by 2002:a05:7022:e13:b0:127:fa:7758 with SMTP id a92af1059eb24-128bbf83c4amr2989627c88.9.1772823192094;
        Fri, 06 Mar 2026 10:53:12 -0800 (PST)
X-Received: by 2002:a05:7022:e13:b0:127:fa:7758 with SMTP id a92af1059eb24-128bbf83c4amr2989614c88.9.1772823191558;
        Fri, 06 Mar 2026 10:53:11 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128c3f58d24sm1934819c88.12.2026.03.06.10.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 10:53:11 -0800 (PST)
Date: Fri, 6 Mar 2026 12:53:10 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH 2/2] RISC-V: KVM: Fix array out-of-bounds in
 pmu_fw_ctr_read_hi()
Message-ID: <cvy2kbbkihlcza5njphjrivm7s3i4fksp3qolocff5ktzuuoad@hji3ioyoxe67>
References: <20260306073739.3441292-1-xujiakai2025@iscas.ac.cn>
 <20260306073739.3441292-3-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306073739.3441292-3-xujiakai2025@iscas.ac.cn>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE3OCBTYWx0ZWRfX3sHucrd0WLaD
 Tl1UNapm46xCVYP97dskxJ9iwMwM1oJn4VAwcbimELoa3vLz2/C67/VFx1LnCN4r9bXfLcEXz6Q
 tPhBmzJpTkNZOagcJhPWjAMqLhaGDs2l+H5OalNHk4aqskStFICJKoDcutH2tNOUeJr3qW5D1UB
 bnlafLO3jgN5VwFSnC2XcYNIHyixSzX90i3W3jwaWPOB9sqkAq0HZGbffMvUVEhrNLhU0jxUOmc
 uNbLsjiHjEW+aOW+LnVciceVXoeIBleJ/IdKMue6Gns7Dvk9AWADZWbPRvfV2b2rY9gT8trN1MO
 aN/KLie6mxeYZe3x0M23iW4eiHhFEZLt4aFEoTmn+FkFlJZB6wR2DiOXFEJNR16OhNvkyXq8K9Q
 KQBovrEmmccNIdnU+fnXh8V+NfAAlLZZWzjb4iPIv06ccy0ylt5B8KqUJ4hpd08qjNqBKbHIWAX
 fmlXrNPJHICatJ3MNXg==
X-Proofpoint-GUID: glQlQibLIkdM8io1jyJE26WsrGJ0yPaH
X-Proofpoint-ORIG-GUID: glQlQibLIkdM8io1jyJE26WsrGJ0yPaH
X-Authority-Analysis: v=2.4 cv=e/MLiKp/ c=1 sm=1 tr=0 ts=69ab2298 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=GYm9Nfl5zRQZIgYA3ZMA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060178
X-Rspamd-Queue-Id: 80883226DC8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73156-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,ventanamicro.com,ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:url,infradead.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,iscas.ac.cn:email,oss.qualcomm.com:dkim,qualcomm.com:dkim];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 07:37:39AM +0000, Jiakai Xu wrote:
> pmu_fw_ctr_read_hi() has the same issue as pmu_ctr_read(): when a guest
> reads a firmware counter that has not been configured, pmc->event_idx is
> SBI_PMU_EVENT_IDX_INVALID and get_event_code() returns 0xFFFF, causing
> an out-of-bounds access on kvpmu->fw_event[].

This paragraph won't make sense when it's looked at independently in the
commit history. Either don't reference pmu_ctr_read() or just fix both
with the same commit (I don't see any reason to fix them separately -
the fact the two locations getting fixed were merged separately doesn't
matter as a commit can have more than one Fixes tag)

> 
> Add the same bounds check on fevent_code before accessing the fw_event
> array.
> 
> Fixes: 08fb07d6dcf71 ("RISC-V: KVM: Support 64 bit firmware counters on RV32")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index c6d42459c2a1..b7ceda1643ec 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -227,6 +227,10 @@ static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
>  		return -EINVAL;
>  
>  	fevent_code = get_event_code(pmc->event_idx);
> +	if (fevent_code >= SBI_PMU_FW_MAX) {
> +		pr_warn("Invalid firmware event code [%d] for counter [%ld]\n", fevent_code, cidx);

Same comment about the pr_warn.

Thanks,
drew

> +		return -EINVAL;
> +	}
>  	pmc->counter_val = kvpmu->fw_event[fevent_code].value;
>  
>  	*out_val = pmc->counter_val >> 32;
> -- 
> 2.34.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

