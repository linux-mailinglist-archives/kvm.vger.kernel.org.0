Return-Path: <kvm+bounces-8024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB87849D97
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 16:00:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62351C23387
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 15:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F52C2C6B9;
	Mon,  5 Feb 2024 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VHHMox9g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7502C68C;
	Mon,  5 Feb 2024 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707145114; cv=none; b=Yxe5UhErTv90s/n3BtrIxtY6OkbvM+8OfxtJL2BdHRGhwAabdJxcQvH6uX3DUI6bmRIS6bUf2ejNr612MVC3ngWGXT8kr/ePkkN1NbC8iDQQ61TZU8mSlon4IcaHvewGQcrrNF8ttVRQpbtNfdP/+IHUt+34Zm4/dkD94fbPADY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707145114; c=relaxed/simple;
	bh=waTsfiJoxQM80hWHMSF2lsDqDVP1IuRZmQUin0MjPOE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FninPVyn5GEskHpI7Bl7rcUpDfbM0Ghwoi7sM5tAfaMEvS2rAibK3YEM09B3VZoFepqaEDB+fn5UvzPBokxDfS5ofZ1XQkc3uJcJFoicAexb4MgWcmQqfQUFWqf+h6IGFp5ZAlZFFd8kVWcrt25AVfbT4WtgH37aXVB4ltszFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VHHMox9g; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415EsioW002572;
	Mon, 5 Feb 2024 14:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nh4TMa86W8hefv37pbk8GN/GhgrqUypntNlguwVBIHc=;
 b=VHHMox9grGL2VmnNa0M8KBxrVIYXjAmf3gPcvHl1Y4MI4IT3eEhju0gHmFdbO0pm/6/G
 dTFa+bdMIxigxizmIWuPAE/XRPcYxwnEX35/3a8ooYTUqBSkh6XbFX4Me44dtnEHkvq3
 rITgrwKmt+yAWi7KRvBX+g4dCDuCvAWJvEVZd1JM5dOsaeppX//wBWbRLSkDVpVi8kcm
 FAMDy+E5UnqPUcr+zEUO52oOiU809bFRJMawuaf8pUX3D2hLg/32ugskC399z9tYwH34
 3abKU2eQm/mactnq4uFw185etEah0uIGc9gGw4bU80pgwzUglZcUSWyzDzqTvgoxKZ5A 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w31usr3er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 14:58:15 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 415EtAGY003753;
	Mon, 5 Feb 2024 14:58:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w31usr3e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 14:58:15 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 415CGYPx008494;
	Mon, 5 Feb 2024 14:58:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w221jrqqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 14:58:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 415EwBEE20710104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Feb 2024 14:58:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DE552004F;
	Mon,  5 Feb 2024 14:58:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5377120043;
	Mon,  5 Feb 2024 14:58:10 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.59.40])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  5 Feb 2024 14:58:10 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        Laurent Vivier
 <lvivier@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones
 <andrew.jones@linux.dev>, Nico Boehr <nrb@linux.ibm.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric
 Auger <eric.auger@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2 4/9] migration: use a more robust way
 to wait for background job
In-Reply-To: <20240202065740.68643-5-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-5-npiggin@gmail.com>
Date: Mon, 05 Feb 2024 15:58:09 +0100
Message-ID: <87y1bzx8ji.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SUHkLwZM0WCe6bFJ9vfIMgczlRFn0ljW
X-Proofpoint-ORIG-GUID: l7laDO8Me0N025JnSH5ggM85y9dv3gOi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_09,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=946 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050113

On Fri, Feb 02, 2024 at 04:57 PM +1000, Nicholas Piggin <npiggin@gmail.com>=
 wrote:
> Starting a pipeline of jobs in the background does not seem to have
> a simple way to reliably find the pid of a particular process in the
> pipeline (because not all processes are started when the shell
> continues to execute).
>
> The way PID of QEMU is derived can result in a failure waiting on a
> PID that is not running. This is easier to hit with subsequent
> multiple-migration support. Changing this to use $! by swapping the
> pipeline for a fifo is more robust.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

[=E2=80=A6snip=E2=80=A6]

>=20=20
> +	# Wait until the destination has created the incoming and qmp sockets
> +	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
> +	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done

There should be timeout implemented, otherwise we might end in an
endless loop in case of a bug. Or is the global timeout good enough to
handle this situation?

> +
>  	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > =
${qmpout1}
>=20=20
>  	# Wait for the migration to complete
> --=20
> 2.42.0
>
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

