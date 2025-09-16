Return-Path: <kvm+bounces-57768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4468AB59F3A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AF2C1C04C03
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A37275105;
	Tue, 16 Sep 2025 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dl4p7m/g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3327B1397;
	Tue, 16 Sep 2025 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758043646; cv=none; b=l6PQQtlpwbimmf9cuakE3n+7KVcff82QO7vkuth6w5CLSIofqhgEurKgMRsjSHOefkdR9e/yxD3XdLEu/anoHWaZSl9Sq1d9ppZ2CAhDt8OyM50JEmwx9NVgr4+Vp958i5X0LpeQqoojRcUj4I5Nf3VIZUZd9dM+0ZC+qrofHxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758043646; c=relaxed/simple;
	bh=ESngvN1yeZiusHdvM7ydyQXIxvqXzvkNsfx/xlRibWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djY+d88ru5DGLnu4ZIlOvbg6blGSvEJ+CtPBQgSzkqJd6joT/2Dhd2Bs+r7e2r92lBGH9Ze10vKvPDaK1JLc8+SK0f1Jf4Hy3pu2Cc+Pwc05luqrdH/lcPfbsTNjfTIYiVD5vIKJXy3kInr9kZeMwKFVVqX5XIH9EEB5PzAYqyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dl4p7m/g; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GCoGNr024260;
	Tue, 16 Sep 2025 17:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=iSYL+5mY3l81AxXomstTbNEsWKz5R0
	q6umtzedePcmY=; b=Dl4p7m/g5BDC+LH5Txs7eicHor4AliWOC7mnzrLuCtDK2Y
	+Wd3mCDw4kzOry5T152SyFgctxMMMOsBom2wcnZFo9/OYJhn8i2cmWNSBCd+oEn4
	GJHhH1kC1dSgodw3hyzkVK2CdtBNEPoMDM45feTzMPYXJHLQoBQtanGbPxaitheK
	5x1DOVxlD+bgwQDltP4BhyWQF2yoEnTKziJUFU0wDa4GIz5zyak++4MliOdoWqXX
	/88O9Lo2qDMBQbb7Ps+AsrXjbWgiLbO5oyZd6874YTtdBCkkggV63DjX6UuvOTKO
	jvbDnzlL2w5d/9A41M9s71ZZNR/4heYR0QWQRsJA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avntsnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:27:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGsMTP005963;
	Tue, 16 Sep 2025 17:27:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu5b3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:27:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GHRI5534537846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:27:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDF8320040;
	Tue, 16 Sep 2025 17:27:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6397C2004F;
	Tue, 16 Sep 2025 17:27:17 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 17:27:17 +0000 (GMT)
Date: Tue, 16 Sep 2025 19:27:16 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 09/20] KVM: s390: KVM page table management functions:
 clear and replace
Message-ID: <20250916172716.27229Jde-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-10-imbrenda@linux.ibm.com>
 <20250916164731.27229Haa-hca@linux.ibm.com>
 <20250916190410.65a18e34@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916190410.65a18e34@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0jcraVm-Tsw1guVu2HLBP6qCjZ2rjhTk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfX08uC0xZxFzZd
 O5HlkgVlHtZ+m4Esm6BJRZsOpnLMgOHv8kWaZtdbKshDqdeYHTLI9B4Jv3yUS0EE0DiOzZScYEW
 y9frUTG/XA2fV9zrc35ReDi3ni2wkDcIxFv0djPy1PUElet7ayp6OlxroIBf2FIA/gFpiBe4Hu8
 5VSnf1zd7mtSAHrZzbqDHpjibbBdcJq+3+4zhamSr8EkqDh59OpDC2JM0zF2M85wWe7FxjwKbjs
 fc7QxFxbREG77vLeBWAKMe0Ry3SGpv9VN8/DtMFYA/61IL4VulT+veJQNFpfHKWy3NPAkIo7p+g
 y2B9w21qux2PjSaGq3Qnvvq8ynPy+tzdXhu3rFA6G1tDPwRUCrKZYh0T6RYw/wdrCtJmo5Ln+A4
 Uw3dAqDX
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c99dfa cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=WUDIGfiG6n5p5e_H8_sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 0jcraVm-Tsw1guVu2HLBP6qCjZ2rjhTk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028

On Tue, Sep 16, 2025 at 07:04:10PM +0200, Claudio Imbrenda wrote:
> On Tue, 16 Sep 2025 18:47:31 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > > +bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
> > > +			    union asce asce)
> > > +{
> > > +	if (old.h.i)
> > > +		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
> > > +	if (cpu_has_edat2())
> > > +		return crdte_crste(crstep, old, new, gfn, asce);
> > > +	if (cpu_has_idte())
> > > +		return cspg_crste(crstep, old, new);  
> > 
> > FWIW, CSPG is present if EDAT1 is installed. So this should be
> > cpu_has_edat1() instead, I would guess.
> 
> no, CSPG is present with the DAT-Enhancement facility (z990), which also
> brings IDTE. EDAT1 is more modern (z10)

Right you are. The PoP says "DAT-Enhancement facility 1", which
translatedto me to EDAT-1, but that is of course something completely
different. Sorry for the noise.

