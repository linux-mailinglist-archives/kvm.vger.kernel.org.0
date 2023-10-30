Return-Path: <kvm+bounces-56-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A577DB453
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 08:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1269AB20DAB
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0BE6ABF;
	Mon, 30 Oct 2023 07:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NZMk1E8P"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313D6AA7
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 07:30:41 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84879BD;
	Mon, 30 Oct 2023 00:30:37 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39U7BZep019514;
	Mon, 30 Oct 2023 07:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=egzwXkF4JfFlnhYDclVe21mtap08zHwMPFF8smpGZZs=;
 b=NZMk1E8Puvi2o13skueQtTC1KNnGv3Y6TOIpRJwVTvhQz72j7wGyJaxB8wd/vBTWDAPD
 iR4Ba4xeh7HCg4NKJAfbOBNMMCrAv46LREWRr/ALhlplJPBqwdXnH3cWjwlSWhwFjzf8
 FpQs7DPafdoxdWG9Y0Pt/jIjqmMXUI4CCv7sxmV0gFO4pIxOyU+mX9JypS83F0u4Cn/J
 cQYDh/vE+XOEYHRaTSlqdEH/fW29b3s023TaBsk54pS1BX76vuqqDNbUxxFnSG2sG1bp
 JlgYKg4kT861hVmlMM8yleiaNRW4JpQ/ThtKsQystsgbg2g5QucR41XQ8NXIHq9bUYVE 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u1xr9k8km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 07:30:22 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39U7C6W3022213;
	Mon, 30 Oct 2023 07:30:21 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u1xr9k8jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 07:30:21 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39U52JmE019881;
	Mon, 30 Oct 2023 07:30:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1d0y7pf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 07:30:19 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39U7UGqg16712316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 07:30:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8231720067;
	Mon, 30 Oct 2023 07:30:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47DD92005A;
	Mon, 30 Oct 2023 07:30:16 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.71.140])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 07:30:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0f132157ec6437326c6bd63f8be18976b19f058a.camel@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com> <169823651572.67523.10556581938548735484@t14-nrb> <0f132157ec6437326c6bd63f8be18976b19f058a.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 00/10] s390x: topology: Fixes and extension
To: Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc: linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
From: Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169865101572.16357.716294326143671029@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 30 Oct 2023 08:30:15 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mpbyY604XHzUiTIcNjy6qtYoLbQcsGuZ
X-Proofpoint-GUID: auZGWl2ocuwVKlYI2_mhteG7FFydOH7P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_05,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2310300055

Quoting Nina Schoetterl-Glausch (2023-10-27 18:36:12)
> On Wed, 2023-10-25 at 14:21 +0200, Nico Boehr wrote:
> > Quoting Nina Schoetterl-Glausch (2023-10-20 16:48:50)
> > > v1 -> v2:
> > >  * patch 1, introducing enums (Janosch)
> > >  * add comment explaining 8 alignment of stsi block length
> > >  * unsigned cpu_in_masks, iteration (Nico)
> > >  * fix copy paste error when checking ordering (thanks Nina)
> > >  * don't escape newline when \\ at end of line in multiline string
> > >  * change commit messages (thanks Janosch, thanks Nico)
> > >  * pick up tags (thanks Janosch, thanks Nico)
> > >=20
> > > Fix a number of issues as well as rewrite and extend the topology list
> > > checking.
> > > Add a test case with a complex topology configuration.
> > > In order to keep the unittests.cfg file readable, implement multiline
> > > strings for extra_params.
> >=20
> > Thanks, I've pushed this to our CI for coverage.
>=20
> And it found some problems.
> Want me to resend the series or just fixup patches?

I think it would be best if you resend the whole series.

