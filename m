Return-Path: <kvm+bounces-36970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A540DA23B34
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A9743A1BF7
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFBB17C225;
	Fri, 31 Jan 2025 09:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sbs3jfOV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD81E885;
	Fri, 31 Jan 2025 09:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738315252; cv=none; b=Bi/tjjReFBzAv9DWmPiMhxN1hWGrVxvrfs/1nJLcGinAtQaI+yFHBeoe1IaDk+IZENYioUbhx7kiZEQP3MszFVmeL/k8FosSJLC4BHYyXOLPq0sCXNMe0xG+41zi1S4Qfux41Qgrp+RM/tgbI12gGPg4V/2Nr0hcO/T74WGiAGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738315252; c=relaxed/simple;
	bh=8L15m/O0weqA5baQonrg5+d9UwjTWxIz1VE/+dW0AUU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=e5So4STNGC/9Yu6aAEHf+fEIKfB2PT+LMVF3eQAammpaZ8Isl4N64Q9A2CubYGWjY9T1sEt9CspqFwedjkwCYUef9YJx4xpEj7zWRaUkiVqhmI6Lfg3va6D59zOS0ubT8aMNrFkMIfpaVTkKHoXNixlIz4vaLLNK9tp5cP28Ebc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sbs3jfOV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2ONNc021914;
	Fri, 31 Jan 2025 09:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vSXFP5
	DD3PDvi47lemUtw03u6AIa0s+tWHBwjs2nX3E=; b=sbs3jfOVE1IlpfkXPLSaAy
	SQqUAwFS7cNDA0crzBhvQEvpF5Tp+TDavc7PuOB39t+PHoQIg29akwiAnvvcs5y2
	buYm3xaVYtrujHsrCrahi4CswXUzBhm4zW9QI97cHcuUnq7aPivf9NJf39V46CU8
	i5uQ46SAzuR9+pCtAuYFzn6XRoQReQPllsdVzucJkQ1vCPBOXljiTXRE6ClSLNyx
	ryzKhVuj3i7PhEor7heHBtfKov2W8N6eBYdSR5TC8smiC25qORcCGa2sAM+NMSM9
	gl8GMCBt2sw4G383JWM+vyHC9RXKPvnSLjn4drVqsGzncgianIJr+ZwA3BF6lBmA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gnby9ept-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 09:20:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8BIrZ017237;
	Fri, 31 Jan 2025 09:20:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gfayav6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 09:20:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50V9KhY133292980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 09:20:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E84A3201B6;
	Fri, 31 Jan 2025 09:20:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BAE9201B3;
	Fri, 31 Jan 2025 09:20:42 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.71])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 09:20:42 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jan 2025 10:20:42 +0100
Message-Id: <D7G5BPWE5YKX.36U48WGFMOSAQ@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x/Makefile: Make sure the
 linker script is generated in the build directory
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.18.2
References: <20250128100639.41779-1-mhartmay@linux.ibm.com>
 <20250128100639.41779-2-mhartmay@linux.ibm.com>
 <8734h3s0rj.fsf@linux.ibm.com>
In-Reply-To: <8734h3s0rj.fsf@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TimTZjX2uZ0i3LjDmWk_wu20sFGQRLRr
X-Proofpoint-GUID: TimTZjX2uZ0i3LjDmWk_wu20sFGQRLRr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_03,2025-01-30_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310067

On Tue Jan 28, 2025 at 11:14 AM CET, Marc Hartmayer wrote:
> On Tue, Jan 28, 2025 at 11:06 AM +0100, Marc Hartmayer <mhartmay@linux.ib=
m.com> wrote:
> > This change makes sure that the 'flat.lds' linker script is actually ge=
nerated
> > in the build directory and not source directory - this makes a differen=
ce in
> > case of an out-of-source build.
> >
> > Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> > ---
> >  s390x/Makefile | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 23342bd64f44..71bfa787fe59 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -182,8 +182,8 @@ lds-autodepend-flags =3D -MMD -MF $(dir $*).$(notdi=
r $*).d -MT $@
> >  	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
> > =20
> >  .SECONDEXPANSION:
> > -%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj)=
 $$(snippet-hdr-obj) %.o %.aux.o
> > -	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>
> > +%.elf: $(FLATLIBS) $(asmlib) s390x/flat.lds $$(snippets-obj) $$(snippe=
t-hdr-obj) %.o %.aux.o
> > +	@$(CC) $(LDFLAGS) -o $@ -T s390x/flat.lds \
>
> s390x/flat.lds should be replaced by $(TESTDIR)/flat.lds

fwiw, s/TESTDIR/TEST_DIR/

Otherwise, yes, will fix it up when picking. Thanks!

