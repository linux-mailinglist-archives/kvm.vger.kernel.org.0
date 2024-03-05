Return-Path: <kvm+bounces-11058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C02A872654
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40F2A1F27AE3
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21573182BD;
	Tue,  5 Mar 2024 18:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qzYmfu1h"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70623D268;
	Tue,  5 Mar 2024 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709662348; cv=none; b=cpP5uCDgSm/DFlLE0rah7FR6mGBTQbzuXHSXOcA1CN7ahbLxDncvZGKC8iKSrSNFIl4swHzPODAtvyMz8w8R5+HXgRk8o9bvVdBtvVNoXNGh6zpMNRz4KENK541hoN0u/fY48hgJRwzGLK0Bh5bSHqaOqkec+76WpMYVXrS8ztQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709662348; c=relaxed/simple;
	bh=9vipu574yiFwOGB2dNLkYs5NVgo28YMdgCx0IIHp8so=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FHMgtbfYdCIBMW2mPlH8ow1GRE1461YSYjuAq2rBM+HjFT0rTdE0d2E7By4nQ5MByhLe8jCgywcLzpbYKLniOhDwmksfaOpXJh+uK9zs524zASiv3Q4J7t9UKWIy6xUcByn9A7SRixzPqij9zCSADq8yL/MGL04IyJ2ZUP3eHd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qzYmfu1h; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 425I1O9w028459;
	Tue, 5 Mar 2024 18:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OAG4lH8cid1xTqKfPe4A888GdO1cBtPArWGsFsvze8g=;
 b=qzYmfu1h52MaL34iSbEbfdpuFwH+/9UMKFvV9er1fPIogEo7ZXaUgZDGvoAruAwQzU2Q
 GKonxnQNiaUC+uQDl74ny6wwoZqxawCoBn1ZqScei+xT+H6FAKUw9mxjpZsBDeaF7wzJ
 7CcytS3v/z2TKGELkBS3i5RyrYwJIA983tojfi4EDfGv5E5Mdi3PuYfmc/HxrTapu7Tf
 ov5sDBQTjhlzTBwyN2bqjmV7KWGcPrz5Xo1zTlVCnHTqImrFf3U4HPrU59J42vvfgobJ
 nBXUFSleTfy4v+Qmy6j5PDU/Xfe7FOolmS/78mmX+WxfppIddixQnYvZc6l5OGkcy6YH Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wp6x02yfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 18:12:25 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 425I1dVC031608;
	Tue, 5 Mar 2024 18:12:25 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wp6x02yff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 18:12:25 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 425H9aOD031533;
	Tue, 5 Mar 2024 18:12:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wmgnk1279-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 18:12:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 425ICIjn28705452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Mar 2024 18:12:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2FE02004B;
	Tue,  5 Mar 2024 18:12:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6061120040;
	Tue,  5 Mar 2024 18:12:18 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.10.18])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  5 Mar 2024 18:12:18 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com, npiggin@gmail.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: Wait for incoming socket
 being removed
In-Reply-To: <20240305141214.707046-1-nrb@linux.ibm.com>
References: <20240305141214.707046-1-nrb@linux.ibm.com>
Date: Tue, 05 Mar 2024 19:12:16 +0100
Message-ID: <87il20lf9b.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oclqbRRxHESKo2DHgpH0OzidF8k0cPJO
X-Proofpoint-ORIG-GUID: j-5GQIfJQRE9pCiTkbhfFek13mgIdNhY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-05_15,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403050145

On Tue, Mar 05, 2024 at 03:11 PM +0100, Nico Boehr <nrb@linux.ibm.com> wrot=
e:
> Sometimes, QEMU needs a bit longer to remove the incoming migration
> socket. This happens in some environments on s390x for the
> migration-skey-sequential test.
>
> Instead of directly erroring out, wait for the removal of the socket.
>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  scripts/arch-run.bash | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 2214d940cf7d..413f3eda8cb8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -237,12 +237,8 @@ do_migration ()
>  	echo > ${dst_infifo}
>  	rm ${dst_infifo}
>=20=20
> -	# Ensure the incoming socket is removed, ready for next destination
> -	if [ -S ${dst_incoming} ] ; then
> -		echo "ERROR: Incoming migration socket not removed after migration." >=
& 2
> -		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
> -		return 2
> -	fi
> +	# Wait for the incoming socket being removed, ready for next destination
> +	while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done

But now, you have removed the erroring out path completely. Maybe wait
max. 3s and then bail out?

[=E2=80=A6snip]

