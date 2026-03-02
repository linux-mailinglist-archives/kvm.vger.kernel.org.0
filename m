Return-Path: <kvm+bounces-72424-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KLV7HwQJpmmRJAAAu9opvQ
	(envelope-from <kvm+bounces-72424-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:02:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA8B1E4951
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8ED14301DEEB
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BDC1A6819;
	Mon,  2 Mar 2026 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QekejI2m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NSFmSvdz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29BB16132A
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772488661; cv=none; b=Wn5O3btWUAwyBMFboGlv3MoAHhcKQCgHHfXnuGspPF+K003mv30HF6bCyP8DSQAiAKxsKdAoHxAGeTxV6QhVaZFGPlKjxDENT386NxiQHwqp18LVHlkYcqW0VdP/NLiha1MqCITFPvhnz4zlepM0aE0Vjy68iZpSyPMaiysM/Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772488661; c=relaxed/simple;
	bh=rkLPlMUYiUKbkvwZg90We9QKLp263vaP+3vQEnbTceA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6/sWSOG8q35EMlcOuA4nGgqyH0vKBkNzqWFB3H0IPb46LNvVoKYVUv/2zqwccamuN1VChTYCJ+A3GDbb678jaxw5JHx2+TRNrYxGoG/FztYpHPawkfiU5gj1zeF97gJXNeoy/Jn7JX7mooJbn2Xuu44LjA2MJ4hLsrwLm/xtoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QekejI2m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NSFmSvdz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622KnxrV959075
	for <kvm@vger.kernel.org>; Mon, 2 Mar 2026 21:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=kKGEnQyVqddtbVsVaKzEMP9/
	0r9eYevQQlpSxYQoULw=; b=QekejI2mpiNgKb1T0/vwrfrCoNAOsem1o8Sw/ucO
	FHzM/wRfm4PxxcRiftZRmvgH5WcI7YV7n9cfJOH5RtmUKFgnzgo+lE0izVwDhVgT
	QtJmS0rUZLV9vNYNyjdaZj6nhHI9+BRckTWrNWV1pWx1io7ydCOgP+IA7E3vnuMQ
	JU8PGldNHy9DY+3C1TyWRmJY+XK7YhYgcIvKBR964pyrJ9V+KTNFTmJznWZLyvGy
	mbwpAETh2U8fhYV81pQU6KIjAu98mxVBOPWvz02FgrDALKS7ZzlHBkNtND91bXAg
	8XN7sDhqjzCTy0GT1hJ0TBFV7x/V+DMlyIfvbeIl3J/l/g==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnhx585nf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 21:57:39 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1275c2ae713so8279727c88.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 13:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772488659; x=1773093459; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKGEnQyVqddtbVsVaKzEMP9/0r9eYevQQlpSxYQoULw=;
        b=NSFmSvdzRr+YQgrsM/r1waEQoz4c1J+ndTnpl2VtyiukRkc74ZHdA1NMXxcbR5n1sN
         fnVnTWtMHHgC5KLV3X+bFOkzGbodAmkF9aUEuv6cKYLFO5al5eN7444ifFdmWHyFWPL/
         yTZmZNTMm5t4feba3848R92qOuxYwJyvvftftgJsqv4piWM9hJq6QFTvKjBI0O3kWH2t
         qHQdwLzloMPjvVqtwX/OcWxAKS7SFv0wCzFjCqxQVYP3+x4wY+Qvo8b4Zt2LGqgcJHEU
         TmHS4CraDA47k4Gzgis8ADDtR2A3WAo3dJX4sMzDiEtEMRK9co2xEoZ8JNughnJb6w8e
         DN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772488659; x=1773093459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKGEnQyVqddtbVsVaKzEMP9/0r9eYevQQlpSxYQoULw=;
        b=Vw6G9qYp2HzJE9SukwfMeqLBh2xHRTkE1zEUGVOPGrDsyYoOHvCX/AOwiR5kOC3KGF
         ARgcYi9yj/+SHvJHWlaRBqLtcGf8aXP4HYEjLCYBLwkGNndamLWhugEkDyqB301tFb3e
         3aklyv6rMt2rg/m30IcK82T70UrIRDCv6uSK6JleataZ3AxHRXjE5wp4RtbSddgiaE8n
         6TJkJIUMCIfh4H5byhklUGyJ1yHk3oLEn7FTdTUR2gU8XYz6VzRSvcQNpfqfEEBHxxkg
         S0CpgTQyVlU4ILpUxS5HhCy249OhqvrdIAr8Ogt6cak+sdANX83JN52dZOgKZKdZBVVN
         +WtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLDT83jpPLaPlUcDLc31apXMuJL2CEG2c8s8tYUHfK1/CKp0iXZnKSnS2fcpcARj4Ga8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbm/JOvp3Hxs8cBNe3MSb6WZT7qO/J2+UJV0wFTfDCmlQvU3X2
	mdGjwswuSr35W4CASKlKQDY0P/2drM+uiZUke3c+yilmZs4/In63euUjlOLLTf2Lv+ZouWuSWVJ
	obHHtSePWXmknYoIUn6fat9LKdnHkf5khxQV+A0Dz05RXA/SjbotseMs=
X-Gm-Gg: ATEYQzx1E5WFXfO3JUdljJhwp8tVHpc2HcZQ6Ok9cuvONAn41p9Cc771FbDpYAK+awm
	uawMvJgqN4waXP9RIXfD2svRymgGT/7k+i8rZYRjQgxPGtuRk0kMJ9ijdJK3S96Z+mYRhmQeM96
	+m/V6msyq+YsAdqyTX9sNiTw+V8wQBesPz5g7SuzfkzjCVh1Z8C4pOqScOVBEk79plR+xWyEcEH
	AQvurgRrr/1vCtocLEDg5sBeDg5l7/mQzvrBGXQuoPmUPvKFGPDpCNvxXGVUPfL1/Jx2TSzlXWE
	6mQCY/LGogBXdnlwvISMwYmcbmWHqU56c1C9ETHJc5eBwisPal3pw1qsTT38e4G+WJyMTEtXbu+
	PWbv8hpHEXZeIC4kgGAuYwwBQTjJXR8Q=
X-Received: by 2002:a05:7022:4584:b0:119:e56b:9590 with SMTP id a92af1059eb24-1278fcf8749mr7439095c88.21.1772488658569;
        Mon, 02 Mar 2026 13:57:38 -0800 (PST)
X-Received: by 2002:a05:7022:4584:b0:119:e56b:9590 with SMTP id a92af1059eb24-1278fcf8749mr7439077c88.21.1772488658006;
        Mon, 02 Mar 2026 13:57:38 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdf662eb6dsm7208496eec.2.2026.03.02.13.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 13:57:37 -0800 (PST)
Date: Mon, 2 Mar 2026 15:57:36 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
        Albert Ou <aou@eecs.berkeley.edu>, Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v9 2/3] KVM: selftests: Refactor UAPI tests into
 dedicated function
Message-ID: <kxssxvwvt2dyzznftbuudkxt7gonnceou4jrjswyhkhg5vrkgh@26sivnbte6mq>
References: <20260228005355.823048-1-xujiakai2025@iscas.ac.cn>
 <20260228005355.823048-3-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228005355.823048-3-xujiakai2025@iscas.ac.cn>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE2NCBTYWx0ZWRfX0ltHyfhpGo9J
 3A3izZMxqZp1+twupRi/fyj1BB8ownsFu6uss4la8MWmiG3qyQb3Fg2q3HZ6k5FVkl/O+UcTfEU
 B2yJZ0AiMLdgoTzDaSFdylTBGHVAUpEEoeC7yGruvAoQxQ7DeH0NM/Hgcv57sQwEiMkE45bxq1t
 JpuKZIug1uugpO4C3AN9W3WPt9nDCdmITD5v9GSScxOkVMlrcctDWVssuLUJIl4p8VDaZX6amv3
 ZdMvVD+ZgaqTH1hobVLoh5AzELxiZh/j9ae9PxJrrJGO8QNQxcjHM4MOTL2QmNtqErpq/a1nkyC
 zLJVZ0dRIpn6MWhBlooddTUxmWvHguEP8cu6JvjEJOaXeexJPJ6WRSHWmt/MWspQGDSr6wZMLcA
 II1D2xRMVvxvpWp3WJtFS5YNWSpQGTyAoB4tdf9SXUm7dpUtDuBa+Rd9FuHbB6ZLWhAHc5lUJk+
 JUc1jv6P0Wl0nzVaETg==
X-Authority-Analysis: v=2.4 cv=T9CBjvKQ c=1 sm=1 tr=0 ts=69a607d3 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=oAJ8CtkVvmEuxm3YF40A:9 a=CjuIK1q_8ugA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-GUID: y5Gj-Hhh3mwHOF5K-sqhoMKSP-OXpMzO
X-Proofpoint-ORIG-GUID: y5Gj-Hhh3mwHOF5K-sqhoMKSP-OXpMzO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020164
X-Rspamd-Queue-Id: 1DA8B1E4951
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72424-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,oss.qualcomm.com:dkim,qualcomm.com:dkim,qualcomm.com:email];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

On Sat, Feb 28, 2026 at 12:53:54AM +0000, Jiakai Xu wrote:
> Move steal time UAPI tests from steal_time_init() into a separate
> check_steal_time_uapi() function for better code organization and
> maintainability.
> 
> Previously, x86 and ARM64 architectures performed UAPI validation
> tests within steal_time_init(), mixing initialization logic with
> uapi tests.
> 
> Changes by architecture:
> x86_64:
>   - Extract MSR reserved bits test from steal_time_init()
>   - Move to check_steal_time_uapi() which tests that setting
>     MSR_KVM_STEAL_TIME with KVM_STEAL_RESERVED_MASK fails
> ARM64:
>   - Extract three UAPI tests from steal_time_init():
>      Device attribute support check
>      Misaligned IPA rejection (EINVAL)
>      Duplicate IPA setting rejection (EEXIST)
>   - Move all tests to check_steal_time_uapi()
> RISC-V:
>   - Add empty check_steal_time_uapi() stub for future use
>   - No changes to steal_time_init() (had no tests to extract)
> 
> The new check_steal_time_uapi() function:
>   - Is called once before the per-VCPU test loop
> 
> No functional change intended.
> 
> Suggested-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V8 -> V9: Created a temporary VM with one vCPU in
>            check_steal_time_uapi() instead of adding extra vCPUs to the
>            main VM.
>           Made check_steal_time_uapi() parameterless for all architectures.
> V7 -> V8: Used ST_GPA_BASE directly instead of
>            st_gva[]/sync_global_to_guest() in x86_64 and ARM64
>            check_steal_time_uapi().
>           Created a temporary vcpu in ARM64 check_steal_time_uapi() to
>            avoid EEXIST when steal_time_init() later sets IPA for vcpu[0].
>           Removed unnecessary comment in RISC-V check_steal_time_uapi().
> ---
>  tools/testing/selftests/kvm/steal_time.c | 67 ++++++++++++++++++------
>  1 file changed, 51 insertions(+), 16 deletions(-)

Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>

