Return-Path: <kvm+bounces-57320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E17B53382
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EAA5585B8F
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCB4322DCA;
	Thu, 11 Sep 2025 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Yk1YDA1D"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9199324B0B;
	Thu, 11 Sep 2025 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757596783; cv=none; b=BxDn1V/2YmgCFnZIlq//bqIr7RkTUhnoBtLErVXVcFnAcA4+oh1E3u5vH5rqCJ6CVXOYO8HENzHJ4sD1WjiZwG9ikMXJWtZhI2eDJmxCxedF/xvT+4ATbTmd5ZqixGyIJluJaL0ijKIS/8WdUvDDDyJZQuUlq+eygxli9WqzahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757596783; c=relaxed/simple;
	bh=+yEjZSzV5FAVZ72/nT3u8PRtna74Onm4LO+syKkb3so=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pog9LNrERQlFQUAGawxWzt5czzy8OtWBAeAPn9CkXKw61+FGyPYMgj5jr8hiv8B1b3B+VR+G5zbaMDR1oR+5j1r69/Nr5rJC60iuyWgmTwF6Sd9TR7CAh7+EppQ2cDFK1mgchTGca0ekT6C4xDqR7mthy5WK7NiMVGRskKKojvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Yk1YDA1D; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDAfnq001272;
	Thu, 11 Sep 2025 13:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ThrRaP
	bzrbPnQRDS36lYM0XQaSKvF27c/UkW/03ruSU=; b=Yk1YDA1D05pijSgSNfnmTV
	4Aib39Dx5q95BUZXDw3eSaOx36C6l16rB2WIYM0umAcUBJ8ziZ2vVbdtKfF0t7aX
	TQsQHwAqYRj1WA3LW3eYNLluHKEQ6U0IaMbqizA+SZ0qsWyUj/anA0a6E0tHroZH
	E/u7eBUhrBxmMMuvgJhQRIZoUHsITkQasYn4oTx8RA7wJ68mq5SZUOoAtoz/uI5e
	hPEP3/oq8n2Z1TT0orcdocshvjrX4N+nB2NAjUyGQA+m55n/6pgGuVL5JZxWuu4B
	2DRz1E298fKwZh0Mpbt3hdyGDH8cJUziG4eNT2VjZwbSj/67AMyqZW/h/4Y3+RWg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukesjd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:19:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BAGb4J017227;
	Thu, 11 Sep 2025 13:19:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmnrtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:19:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BDJYmD48234832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 13:19:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6DF720043;
	Thu, 11 Sep 2025 13:19:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 924ED20040;
	Thu, 11 Sep 2025 13:19:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 13:19:34 +0000 (GMT)
Date: Thu, 11 Sep 2025 15:19:32 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 09/20] KVM: s390: KVM page table management
 functions: clear and replace
Message-ID: <20250911151932.2bce5e01@p-imbrenda>
In-Reply-To: <91f044a5-803f-4672-960b-cd83f725af44@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-10-imbrenda@linux.ibm.com>
	<91f044a5-803f-4672-960b-cd83f725af44@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfXzGmyY/q9446j
 6Kzl/cGIhgrh8hwZZEKBBDout8sP9riCLdY4beRVNdKKcFZKoDBLAnNVyXL8eAu8iOEKtVTSqt3
 5DklzdVpaY58WLhJZOSQDjxlsX/973uYXyUU6ghHh4+njCbK/GZkqLC+OZy9S1+6xafW8c3dhN1
 7COebpma920RiDriPVWubGFV/aEJDevLPIBtCIUMtYTDX4TUUJfI/RQApTrVBM1UmmWz5yHDUsB
 Gv55ImccRXTENKtOvRBUalnH+TvOJQl8w3lfDHuJhOb75MBt9P6OxidoJI1UzCwA/l2lW7Wiq7i
 LZug+2mQTP05OvxkAUR2kTcETfxytHMcZjC9Jt421OcfS4xpdNkShV8Bt3pXlLMMXo9B/imWykw
 Af/ywrGw
X-Proofpoint-ORIG-GUID: YoBl2pXYhS1simZ9dYkJ-9-V2xxXDxBS
X-Proofpoint-GUID: YoBl2pXYhS1simZ9dYkJ-9-V2xxXDxBS
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c2cc6b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=0_kEiP-UzsYf8isQq8oA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On Thu, 11 Sep 2025 14:57:40 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 9/10/25 8:07 PM, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds functions to clear, replace or exchange DAT table
> > entries.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/kvm/dat.c | 120 ++++++++++++++++++++++++++++++++++++++++++++
> >   arch/s390/kvm/dat.h |  40 +++++++++++++++
> >   2 files changed, 160 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
> > index 326be78adcda..f26e3579bd77 100644
> > --- a/arch/s390/kvm/dat.c
> > +++ b/arch/s390/kvm/dat.c
> > @@ -89,3 +89,123 @@ void dat_free_level(struct crst_table *table, bool owns_ptes)
> >   	}
> >   	dat_free_crst(table);
> >   }
> > +
> > +/**
> > + * dat_crstep_xchg - exchange a guest CRST with another
> > + * @crstep: pointer to the CRST entry
> > + * @new: replacement entry
> > + * @gfn: the affected guest address
> > + * @asce: the ASCE of the address space
> > + *
> > + * This function is assumed to be called with the guest_table_lock
> > + * held.
> > + */
> > +void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce)
> > +{
> > +	if (crstep->h.i) {
> > +		WRITE_ONCE(*crstep, new);
> > +		return;
> > +	} else if (cpu_has_edat2()) {
> > +		crdte_crste(crstep, *crstep, new, gfn, asce);
> > +		return;
> > +	}
> > +
> > +	if (machine_has_tlb_guest())
> > +		idte_crste(crstep, gfn, IDTE_GUEST_ASCE, asce, IDTE_GLOBAL);
> > +	else if (cpu_has_idte())
> > +		idte_crste(crstep, gfn, 0, NULL_ASCE, IDTE_GLOBAL);
> > +	else
> > +		csp_invalidate_crste(crstep);  
> 
> I'm wondering if we can make stfle 3 (DTE) a requirement for KVM or 
> Linux as a whole since it was introduced with z990 AFAIK.

AFAIK we don't support machines older than z10 anyway

but in that case we can only get rid of csp_invalidate_crste(), which
is not much.

I can remove it, if you really think it's ugly

> 
> > +	WRITE_ONCE(*crstep, new);
> > +}
> > +
> > +/**
> > + * dat_crstep_xchg_atomic - exchange a gmap pmd with another
> > + * @crstep: pointer to the crste entry
> > + * @old: expected old value
> > + * @new: replacement entry
> > + * @gfn: the affected guest address
> > + * @asce: the asce of the address space
> > + *
> > + * This function should only be called on invalid crstes, or on crstes with
> > + * FC = 1, as that guarantees the presence of CSPG.
> > + *
> > + * Return: true if the exchange was successful.
> > + */
> > +bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
> > +			    union asce asce)
> > +{
> > +	if (old.h.i)
> > +		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
> > +	if (cpu_has_edat2())
> > +		return crdte_crste(crstep, old, new, gfn, asce);
> > +	if (cpu_has_idte())
> > +		return cspg_crste(crstep, old, new);
> > +
> > +	WARN_ONCE(1, "Machine does not have CSPG and DAT table was not invalid.");
> > +	return false;
> > +}  


