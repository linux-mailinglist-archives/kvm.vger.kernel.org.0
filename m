Return-Path: <kvm+bounces-63554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C100C6A49E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 74D224F6C17
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD363363C5F;
	Tue, 18 Nov 2025 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S9cmA0Lr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3653A3587C3;
	Tue, 18 Nov 2025 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763479109; cv=none; b=UMf7nk1vFGm/k4OX2KP3Nsc/L292aHLGEt4RyufKBFkvcIU4Pzb1QmV7CKaf2VhDCjM7MFz2VYpe9n8G5pMOXru7+SJevG00FlEFzcoUrIV9YC12fbILBZ0watBdfHTrUjlv1bSn/eEwAYLlVYV3a6M4X7Or/XzQi0AqinT5NIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763479109; c=relaxed/simple;
	bh=8xK59y6R3Bf5ZGLFDUxEvVS+7w8AgUdLVhQgAtXOagA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jyd3DuHyOx29NFTSMwQPSuVJ4asqS7QgduJAww6MYzmE3SQOz9ePinJpptl9TbS2Es4B2K9sa6vauSF0WqCdPd5cyGUAuAk3CURk+QeGoLFOLR7Fsfyd+0HhcL86+SNmeY/WvCIw6+Vl01w+KdWwnocV8lboBwtGmyLiko49DhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S9cmA0Lr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIEEEdi014162;
	Tue, 18 Nov 2025 15:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=+1JXlb4DiDD7Rit821lav3tYJSfTSJ
	BcuCoW4DX9+OA=; b=S9cmA0LrLa6dZy1zPRhYHQQkh5dbplfietC3zSMNTgUZhV
	/+zQFMrXL0YUn87jMh030BW//W8egts2L3qqWt314D0B3CiE0xTJdxm4LstegKPL
	p6T837eVI8z7youkrkzJQMFL5d7XsWHbODbEjTX1fH6KBLoP1ZdKEJMDlf3WadL4
	crpt8OxSH+TXNWEpnRenWYyB+9mZ3YkorIHBE7UHrM7RxrRnrhp41Ntl+GFx7JAW
	ZWVMr/pOHt5F4Cclgau6aJY8HXn/wGu6ss1gDmnd3cA9mXmG2LG3Pg+e0bNiXsmE
	MeRcH5ZCPGxWAybWRTAGNON7gsx1jiD2N7peRVSw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk9uff2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:18:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIC9698022354;
	Tue, 18 Nov 2025 15:18:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4umuqfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:18:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AIFIKNb53018908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 15:18:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A65620043;
	Tue, 18 Nov 2025 15:18:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E15B520040;
	Tue, 18 Nov 2025 15:18:19 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Nov 2025 15:18:19 +0000 (GMT)
Date: Tue, 18 Nov 2025 16:18:18 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 18/23] KVM: s390: Switch to new gmap
Message-ID: <20251118151818.9674C62-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-19-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106161117.350395-19-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U9QAh44fOUrIktzhYRplBf-d5d52Bwlb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX12Pxkc9D58tS
 Ltwc89YXyPP62T8dIK0Pg1jB/qPP+QlquLU7dEXgTvLqrQW00SR65OzqVLa8t4WXZkZw27vzcKI
 QpniU5OvaAeESh53b96EXTGckRzuF9x/zCDv0LG5M5QAIquQKgBd7yEj8Q0LPO6qyqqVU/xpO2d
 s9/8DU2kjrF6QD6T5Qs/vwGRKlvB7o1b8iZykSDkqcJRPOa/IJcm83EVHpvA9OmxkpU5LS8ir5s
 CxxZ8FeLnqKt5wcMH38nNk59x7LgGJXpHbdexTMbsPvA/6OpYa/8xNFBBdbCxb1ZP+Elgfq4WeJ
 rQnhCFkKyZ9KUr+MLCyO1Uvvr5OAwHrs7EXibeVTgX4fmUoaUZWz7kodoRECRVrdNgTzVPOGE4u
 UoDcs37IV2jC/6E3QzA/2/FY5ZlXLg==
X-Proofpoint-ORIG-GUID: U9QAh44fOUrIktzhYRplBf-d5d52Bwlb
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691c8e41 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=YXv6Z_TBdyW9syI5SyUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Thu, Nov 06, 2025 at 05:11:12PM +0100, Claudio Imbrenda wrote:
> Switch KVM/s390 to use the new gmap code.
> 
> Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
> existing users of the old gmap functions to use the new ones instead.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/Kconfig                   |   2 +-
>  arch/s390/include/asm/kvm_host.h    |   5 +-
>  arch/s390/include/asm/mmu_context.h |   4 -
>  arch/s390/include/asm/tlb.h         |   3 -
>  arch/s390/kvm/Makefile              |   2 +-
>  arch/s390/kvm/diag.c                |   2 +-
>  arch/s390/kvm/gaccess.c             | 552 +++++++++++----------
>  arch/s390/kvm/gaccess.h             |  16 +-
>  arch/s390/kvm/gmap-vsie.c           | 141 ------
>  arch/s390/kvm/gmap.c                |   6 +-
>  arch/s390/kvm/intercept.c           |  15 +-
>  arch/s390/kvm/interrupt.c           |   2 +-
>  arch/s390/kvm/kvm-s390.c            | 727 ++++++++--------------------
>  arch/s390/kvm/kvm-s390.h            |  20 +-
>  arch/s390/kvm/priv.c                | 207 +++-----
>  arch/s390/kvm/pv.c                  |  64 +--
>  arch/s390/kvm/vsie.c                | 117 +++--
>  arch/s390/mm/gmap_helpers.c         |  29 --
>  18 files changed, 710 insertions(+), 1204 deletions(-)
>  delete mode 100644 arch/s390/kvm/gmap-vsie.c

...

> +static int _gaccess_do_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
> +			      unsigned long saddr, struct pgtwalk *w)
> +{

...

> +	/*
> +	 * Skip levels that are already protected. For each level, protect
> +	 * only the page containing the entry, not the whole table.
> +	 */
> +	for (i = gl ; i > w->level; i--)
> +		gmap_protect_rmap(mc, sg, entries[i - 1].gfn, gpa_to_gfn(saddr),
> +				  entries[i - 1].pfn, i, entries[i - 1].writable);
> +

Why is it ok to ignore the potential -ENOMEM return value of
gmap_protect_rmap()?

