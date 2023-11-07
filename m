Return-Path: <kvm+bounces-843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB1C7E371F
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25512280F98
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2106310A14;
	Tue,  7 Nov 2023 09:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MEG4/KkT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B1D260
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:04:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73918FA;
	Tue,  7 Nov 2023 01:04:44 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A78kONl001154;
	Tue, 7 Nov 2023 09:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=HmqbeMpBAbmkJTH6UxMA1s4HMCVRLp2iuiF5luqKrww=;
 b=MEG4/KkTpOIHOqGxYAHNohp9DiubO97RB1VBqsYmI1VjtLWsuqGKmM37KUNkVbMZS4t4
 NpIklnbUwsc+COxtjc0tYoT21Y8UxiwAU5Bznf5wOqmuhIqVHLO1bbPfKdU5b1N8+Rie
 mGJzzAoalsU9HdW4s1JYxzgCIate6+jgTr63jVN+80jFKxZK+ZZKgSM2/b8T4805QsSb
 AcIJ+po1PWwO+v4euUNt6cf0uFMsBaOuuosnNFRcjxI5t5zYv4esjND1cnOKndqDibS/
 bBfjFyonJNx4ZK5Ijrmt5dUWrWhG3z4f/5CaefO1HzQl+juXOm7yNVus6JyNQMBrJFZB RA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7fs24str-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 09:04:39 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A78kSbs001437;
	Tue, 7 Nov 2023 09:04:38 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7fs24stg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 09:04:38 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76GUHq012826;
	Tue, 7 Nov 2023 09:04:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u609sqs15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 09:04:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A794Y7Y43319886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 09:04:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A68432004B;
	Tue,  7 Nov 2023 09:04:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B21020040;
	Tue,  7 Nov 2023 09:04:34 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.68.65])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 09:04:34 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231030160349.458764-1-nsg@linux.ibm.com>
References: <20231030160349.458764-1-nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org
From: Nico Boehr <nrb@linux.ibm.com>
To: Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] s390x: topology: Fixes and extension
Message-ID: <169934787294.10115.5860620244260739772@t14-nrb>
User-Agent: alot/0.8.1
Date: Tue, 07 Nov 2023 10:04:32 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eRUNCVq9YODGWo-HjHeySrIFa_fHaxTX
X-Proofpoint-ORIG-GUID: An2kg1VCu6bZ3cwmxHuUbpa2SjUk6_ue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2311070074

Quoting Nina Schoetterl-Glausch (2023-10-30 17:03:39)
> v2 -> v3 (range-diff below):
>  * pick up tags (thanks Janosch, thanks Nico, thanks Thomas)
>  * fix ordering test
>  * get rid of duplicate reports
>=20
> v1 -> v2:
>  * patch 1, introducing enums (Janosch)
>  * add comment explaining 8 alignment of stsi block length
>  * unsigned cpu_in_masks, iteration (Nico)
>  * fix copy paste error when checking ordering (thanks Nina)
>  * don't escape newline when \\ at end of line in multiline string
>  * change commit messages (thanks Janosch, thanks Nico)
>  * pick up tags (thanks Janosch, thanks Nico)
>=20
> Fix a number of issues as well as rewrite and extend the topology list
> checking.
> Add a test case with a complex topology configuration.
> In order to keep the unittests.cfg file readable, implement multiline
> strings for extra_params.

Thanks, queued.

