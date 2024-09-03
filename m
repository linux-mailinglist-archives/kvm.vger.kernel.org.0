Return-Path: <kvm+bounces-25731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE316969A83
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 12:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C7BD1C234D7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E3C1C769E;
	Tue,  3 Sep 2024 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rc7OPU5f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DE01C62A6;
	Tue,  3 Sep 2024 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725360393; cv=none; b=SByY/i+vr02NC/9dc79ZtKIxxjrLY9Ae52dhGLJ8l8JXZF/04XvlUkXjPAzb9Iz49UJRnlH3NWPLp9DILhPcunMWKiKl4TwlLzSfJc+bnzW5yzjsCmHW74IkVucpha2BR43+VE1DUN1D4Tb/lDjjh64rEpY+6WAXRrBFN60OEYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725360393; c=relaxed/simple;
	bh=o2b8c0Bj9mGYJ2AYqfrkFbiLNg7TbfSyPnNo4eWzeAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rEHxoOAvme3XLqoR8s7LKOLNeGuWBHJJ6K8GkiA/+O/+Tknk7bFTrvoYRjv4ud7+Z05jTCKwTRbUpMfeqFwwOP0oUoe9T+fJdGE4wFQBvaVBq+GEex47X4CxvlvPQboP++xDrTNVr7PKq64HiRh6SMDMzk2xDFscemHyLchEaMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rc7OPU5f; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483AhtGG009059;
	Tue, 3 Sep 2024 10:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=LF2nPU0WECcKjBshktK/8eKhGHS
	63EdWoNHlS3x2fEM=; b=rc7OPU5fYa/M0xHjfWJRNiK1yORZcqWmEPgdrdKdoLB
	Y/Z6d5thv7FE4jLjiSpyRxQtPnN8N8UiqDbN4pIoJRo7ckJM+pd+tWw1nlIeDYGg
	x8i1MZCmhCa5TeTvYQCb+SEzaf5caRGyymP+BxMz6s4l8e8thXWlDzqPvfDpvkfY
	BMSWsOr30naT1+FxITbTZ7IvEPvGNZqhaQh4vwv1E3mIwsWEyeFwL7zN0DCSFuYS
	QzoDXG5fSRIiG7J33A2CSrl/KiXzAuib/IDj1tbjmx+AAj4iCv7nzATfLFbTfAFP
	q7jpzbuWv8OhVk1FolfFQx1EJK4fv7K4JNG3SGZDdKw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41bskkwe2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 10:46:27 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 483AkQJt013282;
	Tue, 3 Sep 2024 10:46:26 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41bskkwe2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 10:46:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4838r8Jm009226;
	Tue, 3 Sep 2024 10:46:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41cg73j0ns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 10:46:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 483AkMdv55902706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Sep 2024 10:46:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35FDA20040;
	Tue,  3 Sep 2024 10:46:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E129320043;
	Tue,  3 Sep 2024 10:46:21 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  3 Sep 2024 10:46:21 +0000 (GMT)
Date: Tue, 3 Sep 2024 12:46:20 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico Boehr <nrb@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE
 interpretive execution (format-0)
Message-ID: <20240903104620.8020-B-hca@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-8-nsg@linux.ibm.com>
 <172476771096.31767.10959866977543273401@t14-nrb.local>
 <0d1fb151a09701588f98547cdb9f74bc743cb615.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d1fb151a09701588f98547cdb9f74bc743cb615.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YipagRHv1OMrmAj4hqPwCO8b1FulxjTe
X-Proofpoint-ORIG-GUID: QlEL6-c359IfK7AOlDSRMVcheUXAhR6V
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-02_06,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=707 clxscore=1011 phishscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2409030085

On Mon, Sep 02, 2024 at 04:24:53PM +0200, Nina Schoetterl-Glausch wrote:
> On Tue, 2024-08-27 at 16:08 +0200, Nico Boehr wrote:
> > Quoting Nina Schoetterl-Glausch (2024-06-20 16:17:00)
> > 
> > And: is long displacement even appropriate here?
> > 
> > The cast also is hard to understand. Since this is not super high
> > performance code, do we just want to clobber memory so this gets a bit
> > easier to understand?
> > 
> > > +                 [len] "+RT"(res[0])
> > 
> > Same question about RT as above.
> 
> Long, but providing a short displacement should be fine too.
> Not sure if there is any benefit to letting the compiler choose.

There are some older gcc compilers around which fail to compile if you
specify T for long displacement, but the compiler sees that a short
displacement would work. So please specify RT to avoid such compile
bugs.

See https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=3e4be43f69da

