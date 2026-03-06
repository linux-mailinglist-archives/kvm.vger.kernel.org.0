Return-Path: <kvm+bounces-73155-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNskOowhq2mPaAEAu9opvQ
	(envelope-from <kvm+bounces-73155-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:48:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6796B226D91
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:48:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 319A6305B49C
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 18:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEBA36F42F;
	Fri,  6 Mar 2026 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EsEeCLFn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ilaR1iah"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEEF2206AC
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772822920; cv=none; b=h6XO6ePjruJVooIIWfu9GEEZbglAuCUkmsfdpfTM3TmGO2gc/BNpubW4Tx65s0yYwy9lyAZksKNskGST9ewAOnKNCxrFnH3jOsgNiLbjOpAJvlWS8pGHMLz+tgKtOaBrLgpfuHegSzHdiC+svAmgzpmdlfIx8V6IFbu0JU6qrlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772822920; c=relaxed/simple;
	bh=HYE9cWE5eYcSxFyFdPpjFCTlHzPyUpceZNDauZILwG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C53AXhCjPYry1NmMbQj6f8zNaVfCBCdMudzD0HsJoVV8GE1o/z548MHwMbjpO2k/4zspDpYLJoSiZpivzfppJ1FfOyllvqb6wE3v2RSgLtoEU4hBC/dUW4q7pn50UTThRkcg3hGzES7IqMSqaWUL7OAWZ99VDskhXY176q3EWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EsEeCLFn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ilaR1iah; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626H1dGl232831
	for <kvm@vger.kernel.org>; Fri, 6 Mar 2026 18:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=NPwo3cTU9Dl1aKmohJUbynAG
	EZLvr2w5QZ5ywnXg5H8=; b=EsEeCLFnL4zpuVKiUXVvxfIrQ40D3u8z42hPho2y
	D2oByRXhvHX+Exhu3vr/S8dmZ+LJwXQQzKkzUCxdqWIUi34BeYeT7MGq5Lwip1lH
	AqdGtG14Oy+ynPoEQTy5sWuDMGnmfEswlASnHDoZCyb8b4EmLUx8kd+UonCIJqCZ
	zEM3a5iwajrIUmpSHFjG/1ijGy2E09nMW290bR3ZFZf3JykFhiXE8wVJIyEk4HlL
	GE2jluuah0h41qcTgyjc19IwXQF1KbRKlP+q9nEaFBhycEgQumCj7AsMVKYAULk1
	RgIhia9Edt1t69Z36bg1rzC0FYP6lCL9DkAgFsW8pIDnAg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqgp441sa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:48:38 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2bdf6fe90a9so8456329eec.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 10:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772822917; x=1773427717; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NPwo3cTU9Dl1aKmohJUbynAGEZLvr2w5QZ5ywnXg5H8=;
        b=ilaR1iahOsu5r+JP6jY3fMDZQO04Zta4druw68S0N7BK+0N0on8qLdUDqKm99VeRrv
         JpY+ceSKQQLF+vBl/bVTKHUjdsQ1d3NeqAMGHqWSbH4VHOXwSN7H7U1kHjEf0O7Z/yFt
         fK+/1Wu18uoAKOOfDdqgXBsyAngY/TNZJHZQOevu/WVfPe00qv3t2F9VDurr8/2xxikP
         HiYuYBwYhbsxNZb7NBA/wn9iEclX7r1VVc84J6XHhl29t6GNasRV30y/FOBc3ZShWsaD
         5cwr7CtbOZGlZjiL3wx0OtjGlfOHVe3ni6uD8j/UO5eiYeARSqbWYK0aY/YxHcq9KBiT
         G9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772822917; x=1773427717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPwo3cTU9Dl1aKmohJUbynAGEZLvr2w5QZ5ywnXg5H8=;
        b=vIit185Yt3ii0ZplH/KdDVg4/SyagIRdwAjYBpgHotrcTTmro3+NcPvAQ0XUyB+bJI
         4Wos6WdApMMHOBJNsKpVUAww5D9a+xsLmtXjl3CZ9CEEw73ChjLGNhcIn8+Nqqh9XSOi
         fZc5ngpXZ/9HCE8ZkmGSMaWizbFQu1CuMOUkOkuMcAo8IBpuxYN7CzcoaG+OAggSKtSy
         BsskZcjmf3DSolucugWzGG2EtpIBrI/gtVBOqZPLAbIXib/3iVgcTN1FURbMURXdT6WD
         ipiojxPM+mMyfsDgBe4sVOaUE9ueu6nCiZZIbUbhiEt2xSjcYmXuXJ/vVnDrnq2a/goJ
         +Wfw==
X-Forwarded-Encrypted: i=1; AJvYcCXzcYqg5xTa67KSgHCddbEVMJ9ud+muk2PRDNRJICUDdMSba8vaBuyYmgthutuyGj7lxdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvrnyfurwaRdUhje1xjTlZ9t6ZgVg6P7Nen2BmiJuREKBiixzf
	iTNTCCr95iGndFF/f803FdJRBXRDy0mlNdz+BfN3FVr+vslaiPI+GreFS6hvym2HGGbtp3qm7iL
	eca19P6vXnSrqLH72hBIp55PX51f34rNMPZQ+I0m9bhZCNJSt3q9XAS8=
X-Gm-Gg: ATEYQzxG/78FHr6CesrBpHtNvPvIekQfKyidLFIlm9DAJhezQGr1wADk/6eQLzpp5EC
	Hg+vTN5alxVLJ+53s5bi/pkLt3WgZDLW7r5kiO4VMVUmCI++XBacUU9kIRoLr30WPeZT1W6HIPE
	mjYCTEwvH4pLUWelPlEUzx+TSl4yzdt5UGNUDna2kSNc/PSH/AwgW6OVGj5LxUlH/qlBFR4gELX
	MwVotFtNOQVTJ9YgZsQwBz+7UHD9QAfc52hZ1s5Eynj5jVrt4+OdbwCyOuFmPGoBT88l8MaAy5F
	hjzX28rOJX+wJMjIpb9TBbuFfQZyLndL0nMVNm9chwwQhLVIGXCO/lYoZx3PnYu6fmbb+q2FrLL
	H6GggK6RkI5hZnU83Lehr9bGc35BUlhM=
X-Received: by 2002:a05:7300:a883:b0:2b0:5b6b:6529 with SMTP id 5a478bee46e88-2be4e064a5fmr1152044eec.39.1772822917081;
        Fri, 06 Mar 2026 10:48:37 -0800 (PST)
X-Received: by 2002:a05:7300:a883:b0:2b0:5b6b:6529 with SMTP id 5a478bee46e88-2be4e064a5fmr1152030eec.39.1772822916383;
        Fri, 06 Mar 2026 10:48:36 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f984ceasm1998273eec.32.2026.03.06.10.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 10:48:35 -0800 (PST)
Date: Fri, 6 Mar 2026 12:48:34 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH 1/2] RISC-V: KVM: Fix array out-of-bounds in
 pmu_ctr_read()
Message-ID: <7cv4cq43l33fvpbikecjecfulomzurfmlbjk45u6amvdmnmrhu@7padusm25g5l>
References: <20260306073739.3441292-1-xujiakai2025@iscas.ac.cn>
 <20260306073739.3441292-2-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306073739.3441292-2-xujiakai2025@iscas.ac.cn>
X-Proofpoint-ORIG-GUID: cxM7WVZi80KDZ3rgVi7jocFU42A-Md4n
X-Authority-Analysis: v=2.4 cv=LegxKzfi c=1 sm=1 tr=0 ts=69ab2186 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=ABfPBq6YoVPYWZtmEusA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE3NyBTYWx0ZWRfX2CRCWxZ1To1t
 NoG+hh287E5pgEzZ0W9ivjAMkrty8yi5K6neWPz8CyFfjGC4EAX5Aashb9BO5yIVUnUG0Ooirub
 bv15RvrQwkFBdEhNjtV97inGV3dCPqn7VhuJcS3SVyIjkwts+GeyHR2FXBljxTH+YaGewhmCx9U
 0shUmNEtlK80BJrOUZaEsA1wG4OotpZv39agzIEDMuhlp2gatBOPIgL7Q6d1LuD2vePHOZZ0sga
 vEo0/qnNydq3cDvzSG6dEEoADTBcQxkQwUHvpdzL7YCmUK5c1sSkjdOaWevXk5TdeoKI78wsxcN
 PlOT1bY/r7GfUNYkSWFALLIqyTa2trqBsfPb3MakD9XbLkCTseLQ2BZLOjiYOP4QdOtjTCKNoZf
 JRKk+VPe1sB84SU1/LG5TfEsCFWek5BGuIpJfuVg/qLdzYlDExtZ0fStZ+y/Pa1vnXmPx0GusDK
 03T6UM50SfIpqD1zR+Q==
X-Proofpoint-GUID: cxM7WVZi80KDZ3rgVi7jocFU42A-Md4n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060177
X-Rspamd-Queue-Id: 6796B226D91
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73155-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,ventanamicro.com,ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:url,infradead.org:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,oss.qualcomm.com:dkim,qualcomm.com:dkim];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 07:37:38AM +0000, Jiakai Xu wrote:
> When a guest invokes SBI_EXT_PMU_COUNTER_FW_READ on a firmware counter
> that has not been configured via SBI_EXT_PMU_COUNTER_CFG_MATCH, the
> pmc->event_idx remains SBI_PMU_EVENT_IDX_INVALID (0xFFFFFFFF).
> get_event_code() extracts the lower 16 bits, yielding 0xFFFF (65535),
> which is then used to index into kvpmu->fw_event[]. Since fw_event is
> only RISCV_KVM_MAX_FW_CTRS (32) entries, this triggers an
> array-index-out-of-bounds:
> 
>   UBSAN: array-index-out-of-bounds in arch/riscv/kvm/vcpu_pmu.c:255:37
>   index 65535 is out of range for type 'kvm_fw_event [32]'
> 
> Add a bounds check on fevent_code before accessing the fw_event array,
> returning -EINVAL for invalid event codes.
> 
> Fixes: badc386869e2c ("RISC-V: KVM: Support firmware events")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index e873430e596b..c6d42459c2a1 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -252,6 +252,10 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  
>  	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
>  		fevent_code = get_event_code(pmc->event_idx);
> +		if (fevent_code >= SBI_PMU_FW_MAX) {
> +			pr_warn("Invalid firmware event code [%d] for counter [%ld]\n", fevent_code, cidx);

We shouldn't add warnings for these types of things since a guest could
fill the host's log buffer. At most it could be a warn-once, but I think
we should just return the error as quickly as possible. It looks like
there are other pr_warns in the pmu emulation code that should probably
be audited to see if they should be removed or changed to warn-once as
well.

Thanks,
drew

> +			return -EINVAL;
> +		}
>  		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
>  	} else if (pmc->perf_event) {
>  		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> -- 
> 2.34.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

