Return-Path: <kvm+bounces-64491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAA39C84B16
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 12:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C3403A9EC2
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89443314D16;
	Tue, 25 Nov 2025 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="siNE5s4f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005E929B795;
	Tue, 25 Nov 2025 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764069411; cv=none; b=U8H0sjFUfMrc21Idk56RsJ9zHIg34s5A7SuEcy/TbWW/7/WAWn/Y57Bfdi/s02ZsyJXO+XctLIKrXCCSQoSDoNGe0Q9foXLDBZYE0zE8otwubMULklQ0qX/R5m9uIdKuNRpxRL9RA6k2GPgTCRpI8wegvmQOKvGNU1WCtkf4WRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764069411; c=relaxed/simple;
	bh=IWawuzqG+2NV1QobnSFkgHOEywGckk9oKebW7gd1Qmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjDND7nkJOpcc+D9nWtw16xbp1M1pRzrS+ErVi+qUecGSgRX1YstcEMp45Bj0I0/5g3RoricKrmKTUTWijGJ097XlmoV+DkxKY6qs0RWUcXRAzhf88Pf9UR1r32UwqZpM6cn6jaXXNzg4fk8i4XySN+jhvZKPa2JxvF8cUMGK/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=siNE5s4f; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP80ZuG003341;
	Tue, 25 Nov 2025 11:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yBK0rSdQ+Tmt9dIIgOSx96whnlK9kL
	+IoST1r0RrPwI=; b=siNE5s4fvC4tpRqK7AwuvA3bWYcedhYm2iX/oEvVKMe8ys
	FRhlW6a2rIttieRNHkWI5lgVLr/csLiR9grcsDr1n8fXPJg09WoxK3FYb9DGc0/n
	sPizbVQFocFHRYZPcifoPuTGWSJzV+9lGsC/fLbl0uUyDazYWKU/nWWvdHKWIY3M
	44N3vAgHhrS9Inffz/dLRTgQDfrb/VAuVsnpfgcIOq21I62mAzw5q+IGEkJmFWOR
	fjtE1NvKBYQkXZxMO1ACOpy1CbOzsWKKynZFYyRVeqs1DEfXu8gle/IuO2otL3jJ
	kyXttyQC5fQcUNuKmcHn9RwFX0R0bNX5iJnxQX8Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u1ve7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 11:16:25 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5APAYHlq019023;
	Tue, 25 Nov 2025 11:16:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aksqjk415-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 11:16:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5APBGKIx30998976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 11:16:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 814BF20043;
	Tue, 25 Nov 2025 11:16:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 074DF20040;
	Tue, 25 Nov 2025 11:16:20 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 25 Nov 2025 11:16:19 +0000 (GMT)
Date: Tue, 25 Nov 2025 12:16:18 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH 3/3] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK
 functions
Message-ID: <20251125111618.10410Fa0-hca@linux.ibm.com>
References: <20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
 <20251125-s390-kvm-xfer-to-guest-work-v1-3-091281a34611@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125-s390-kvm-xfer-to-guest-work-v1-3-091281a34611@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX7tNP2tBxAgd7
 QjZ/cl9mM1HrRM01HDDVMGWXX2gFqWJ5ICVG+Hy2ioGnXscq7uu7HRl81/GfvLMd5pMpASzqnb7
 I28erhp8dqNeCQzliIjpXUmIfx+Cc0s9HSfYjkKGaTIWutqJoWYWjC7M+gDYdra5QxRfdsQsUHh
 k1dxCWL9H9QTiaZyqUszlz1xjBWrzOOL+yO3U9pAsX9jY9hWh5Qcrm23QHBXiM3daThHWBC0/ME
 XScU/QXVtW2MQNETWZSoEqjegWF+F14ujHKl+YU5i3jSSPMzhLmhJ2Qb54c9WZrYbvU1K0DRo7P
 hlxv9tlrdA6xFrs/efAizM8r8RaC0d3anwmt4Phhg640/gp/QM22GoV8xFkDgQYii6QUnUsiZTa
 vCmmh5Sw9SWnop+dJKsemjeWF8AYPA==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=69259009 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ldvqa60LikrQ3swS9-UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ANGSFDJNVT9Sw5sXetchXIiaviJvshW7
X-Proofpoint-GUID: ANGSFDJNVT9Sw5sXetchXIiaviJvshW7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

On Tue, Nov 25, 2025 at 06:45:54PM +1100, Andrew Donnellan wrote:
> Switch to using the generic infrastructure to check for and handle pending
> work before transitioning into guest mode.
> 
> xfer_to_guest_mode_handle_work() does a few more things than the current
> code does when deciding whether or not to exit the __vcpu_run() loop. The
> exittime tests from kvm-unit-tests, in my tests, were +/-3% compared to
> before this series, which is within noise tolerance.

...

>  		local_irq_disable();
> +
> +		xfer_to_guest_mode_prepare();
> +		if (xfer_to_guest_mode_work_pending()) {
> +			local_irq_enable();
> +			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
> +			if (rc)
> +				break;
> +			local_irq_disable();
> +		}
> +
>  		guest_timing_enter_irqoff();
>  		__disable_cpu_timer_accounting(vcpu);

This looks racy: kvm_xfer_to_guest_mode_handle_work() returns with
interrupts enabled and before interrupts are disabled again more work
might have been become pending. But that is ignored and guest state is
entered instead. Why not change the above simply to something like
this to avoid this:

again:
	local_irq_disable();
		xfer_to_guest_mode_prepare();
		if (xfer_to_guest_mode_work_pending()) {
			local_irq_enable();
			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
			if (rc)
				break;
			goto again;
		}

		guest_timing_enter_irqoff();
		__disable_cpu_timer_accounting(vcpu);

But maybe I'm missing something?

> @@ -1181,11 +1181,21 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	barrier();
>  	if (!kvm_s390_vcpu_sie_inhibited(vcpu)) {
>  		local_irq_disable();
> +		xfer_to_guest_mode_prepare();
> +		if (xfer_to_guest_mode_work_pending()) {
> +			local_irq_enable();
> +			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
> +			if (rc)
> +				goto skip_sie;
> +			local_irq_disable();
> +		}
>  		guest_timing_enter_irqoff();
>  		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);

Same here.

