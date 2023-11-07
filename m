Return-Path: <kvm+bounces-1053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6757E4879
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B4BB1C20CFB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF69358A9;
	Tue,  7 Nov 2023 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E4sYMxpb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFB630FA9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:42:29 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4555A116;
	Tue,  7 Nov 2023 10:42:29 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7IeiIE003031;
	Tue, 7 Nov 2023 18:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6e9g5TataTjtWaCWdXYn+6nf6rWz4+9eM6ZYPAfwEXI=;
 b=E4sYMxpbQ4SoQwB5gC8w4QA3ZM6Jpi5jGCUFzIGA8YTEC46n8avpmSe2lM8P+NlrIdUf
 V68ZLr7+rP2zMpfC1mqftwz6dNn9icdkqZjznAinzH+AuK9HI+3PCQUKL0u0JtVVGbbQ
 ykexxZuAp0n5HbYNHegzxYBzPnf7NjIFJnHoPY5MCZtd63Nc+3KjM6WGdy5kcV59DIP8
 O2j2BouRJ00YdbzWyJikutBWwI5uSpV68itZIQtdMamiLmbGEDapubLQl+EZtIIT5P99
 HlSZLkTkDP1Vsva2cBfqJ2VFDAXmc25FUFV512t/lU8Mh8HE/hYOcDvY3FeQJvllHI+m 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7tqkr11c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 18:42:18 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A7IewTJ003333;
	Tue, 7 Nov 2023 18:42:18 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7tqkr10v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 18:42:18 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7HNZeC007918;
	Tue, 7 Nov 2023 18:42:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u60nyjxbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 18:42:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7IgE3D15270402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 18:42:14 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7F5F2004D;
	Tue,  7 Nov 2023 18:42:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F3E520043;
	Tue,  7 Nov 2023 18:42:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 18:42:13 +0000 (GMT)
Date: Tue, 7 Nov 2023 19:42:11 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 02/10] powerpc: properly format
 non-kernel-doc comments
Message-ID: <20231107194211.337bbc4d@p-imbrenda>
In-Reply-To: <169929081714.70850.5803437896270751208@t14-nrb>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
	<20231106125352.859992-3-nrb@linux.ibm.com>
	<20231106175316.1f05d090@p-imbrenda>
	<169929081714.70850.5803437896270751208@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JGbdimfDR6sN7FuOYNAevApGSWYChkZ4
X-Proofpoint-ORIG-GUID: CGQFV8Wgswp2kZXs32-C2vfUkDjrFd3u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_10,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070154

On Mon, 06 Nov 2023 18:13:37 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2023-11-06 17:53:16)
> > On Mon,  6 Nov 2023 13:50:58 +0100
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >   
> > > These comments do not follow the kernel-doc style, hence they should not
> > > start with /**.
> > > 
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > ---
> > >  powerpc/emulator.c    | 2 +-
> > >  powerpc/spapr_hcall.c | 6 +++---
> > >  powerpc/spapr_vpa.c   | 4 ++--
> > >  3 files changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/powerpc/emulator.c b/powerpc/emulator.c
> > > index 65ae4b65e655..39dd59645368 100644
> > > --- a/powerpc/emulator.c
> > > +++ b/powerpc/emulator.c
> > > @@ -71,7 +71,7 @@ static void test_64bit(void)
> > >       report_prefix_pop();
> > >  }
> > >  
> > > -/**
> > > +/*
> > >   * Test 'Load String Word Immediate' instruction
> > >   */  
> > 
> > this should have the name of the function first: 
> >  * test_lswi() - Test 'Load String ... 
> > 
> > (same for all the other functions here)  
> 
> Since none of these comments really follow kerneldoc style and are mostly
> static anyways, the idea was to convert them to non-kerneldoc style, by
> changing the comment from:
> /**
> 
> to:
> /*
> 
> But I am just as fine to make the comments proper kerneldoc style, if we
> see value in that.

oufff yes sorry I had totally misread that

