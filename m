Return-Path: <kvm+bounces-57182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF73B511FD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A7C443C28
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D2D311C1B;
	Wed, 10 Sep 2025 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a1sRTbAD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B0302CB4
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 09:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757494868; cv=none; b=F/mNSIrt0a1FlPhBxzi0O1GQ6Sp2J4MBMcHpHsEZwGBroGSEPliTK2jvUOELWWCmESfIoIcOmX/t227QCcQPL7OjOZHSrgXCIAsXsL3GzbsQmm4qNzVfdys5arJNdF5Roylh2Jz5WNgGeV6cudcXca+G/Tq0Efw/cT1/zoUcxWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757494868; c=relaxed/simple;
	bh=H8W0yqUCgTHFQBnp1kNcIp+xxdnnPOEa9QVnhoMdLSI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H35qUjH6NsK/q9SV+YP1JnA4WA4T0K94WJ0QiDINommhq4agyh3CHVAt2qc726JNrDTFEu1KmTAFF2JUlgGCgKKrSicX6clj8f1SuXClVBJmZgaOEcSiX1St5TCwS1AFEZ5Z897Ck58/pzPwRLH6mC98wJXH5/WcRreP4AvGgBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a1sRTbAD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A3h9rU001309;
	Wed, 10 Sep 2025 09:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=W2en4B
	XqU8F2Aqgp1aZfN44I7h44YLXMk277rBv5FsM=; b=a1sRTbADJK/YnQgkpe7+e4
	XCpRxOacc0xuFGDccFDUQQeQRzXZUCtUBaKf0bkPK+RLI8PcEbkn89FdCzqbya1d
	dXI/oNjrEsNK1EnO8MCudWP6tcB25/svOLFe+MjwitgwgiUjd5K2nNwR9TKsWBDL
	n4mEK2PIJed8bN5wkGuY/ST0NUIwxW2ksnZ5gX6KGWi+L3xGsjbhTnqgZHZDElKu
	a99QCS2eF2eYvHFibJXTiduhtVZHoJdvCknghqayRmPEv/H49ax23xZJ4c9IX68r
	by00G8Ug9H29sMORMQ72fViA6ftnOkFCUxWLrbJV5fB4Fz3/RL/1T8ldp0QSv42A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acr4s7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 09:00:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58A6XLbq010666;
	Wed, 10 Sep 2025 09:00:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910smyhvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 09:00:51 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58A90lBP53739810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 09:00:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BE2620063;
	Wed, 10 Sep 2025 09:00:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35C0E2004D;
	Wed, 10 Sep 2025 09:00:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 09:00:47 +0000 (GMT)
Date: Wed, 10 Sep 2025 11:00:45 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Nico Boehr" <nrb@linux.ibm.com>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
        "Andrew Jones"
 <andrew.jones@linux.dev>,
        "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the
 dependency on "jq"
Message-ID: <20250910110007.26fa1643@p-imbrenda>
In-Reply-To: <DCOYKSEY6V79.3HE423J6WWXTT@linux.ibm.com>
References: <20250909045855.71512-1-thuth@redhat.com>
	<DCOYKSEY6V79.3HE423J6WWXTT@linux.ibm.com>
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
X-Proofpoint-GUID: vIm0YNqOgzOJhs1GJnM0vGAUGibByHLi
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c13e44 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=nUK683HXKINPA0QMzp0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: vIm0YNqOgzOJhs1GJnM0vGAUGibByHLi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfXxgcCTzpOFPcd
 Xb6YvkVMeIE/R7/U5ZwqpcSGebxMoMmHQwKiFZbwS4tnusF7onPdk2RSbz5d2sm01Hfj1xaMSGY
 btdxZfBybCKtlUpVK4SYkQ4hbexHtS7+ldmdvWiM9sc0UPzo76bdOBp3i6Mxp5s6YmvDWB4vJ8W
 PN20X/9r8ZkU1qrzjok18syHRmd0BeOlDl74rWOR6Ge9jL/XWGnAlnLCwy9KvCxP8TrsDePDKD0
 MqgCmgjk20bMJh2Q2WKx2jPgoPQssL5eYtYtCDTpH+KS/PrTmq3novxhmvGFXej65jLElicP+jQ
 X4DfKLuw98ks40Cr3WXkECEe2kCOj/OtJq91YlP+vMifQGfM/fWxJJBpASm2QykS0nP4EcsLFrq
 cL/IzuxO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

On Wed, 10 Sep 2025 09:57:17 +0200
"Nico Boehr" <nrb@linux.ibm.com> wrote:

> On Tue Sep 9, 2025 at 6:58 AM CEST, Thomas Huth wrote:
> > For checking whether a panic event occurred, a simple "grep"
> > for the related text in the output is enough - it's very unlikely
> > that the output of QEMU will change. This way we can drop the
> > dependency on the program "jq" which might not be installed on
> > some systems.  
> 
> Trying to understand which problem you're trying to solve here.
> 
> Is there any major distribution which doesn't have jq in its repos? Or any
> reason why you wouldn't install it?

I think it's just a matter of trying to avoid too many dependencies,
especially for something this trivial

> 
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 36222355..16417a1e 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -296,11 +296,6 @@ do_migration ()
> >  
> >  run_panic ()
> >  {  
> [...]
> > -	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
> > -	if [ "$panic_event_count" -lt 1 ]; then
> > +	if ! grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST_PANICKED"' ${qmp}.out ; then  
> 
> This changes behaviour.
> 
> Now "event" can be arbitrarily deep nested in the JSON. It could even be
> completely invalid JSON.

in that case we have other issues

> 
> Not saying we shouldn't do this, it just comes with a cost and we need to see if
> it's worth paying that.

I don't have a strong opinion on this, but in general I like the idea
of having fewer dependencies

