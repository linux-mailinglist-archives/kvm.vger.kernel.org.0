Return-Path: <kvm+bounces-39987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4B7A4D435
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 08:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5361188FAC9
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461541F5435;
	Tue,  4 Mar 2025 07:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JmZpxTo6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA80A1F4624
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741071694; cv=none; b=V14jUAihrZYIypD9JHqWP133HffCIXiMVMU88Vg6YrVRzB+/cGBIPf5t5YD2dpuR6qMcj0xsz/21W87vpXvyCvDy1cmBsZBJQ3JBbOAa/WxE2wwoZp8g5w0tBcvS0wfHNa3cB+hboK8xjOrfFkxnMikG+qyxgzZllvc2fmIJWyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741071694; c=relaxed/simple;
	bh=biYyQV553IsEcQX5UybCF9F1rsbMLi5ffO1CL9XXEs4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=DxBPzsqzeHNhTSUjuynnDx+lx53EYEB9uYp+CrLqlK7QuYKClq5ZcBuBkYtAUrbBZIMR/kmju7JF6v8Wo6xkPmxCJuNz7X6uPtLsbI/OD33xHHFAj0Je7yC5yaMIFeSbWL+J/ezIMTxdoUfu+CO0dLq/IOBNySG9NbCsiIgm/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JmZpxTo6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523KcNw1017163;
	Tue, 4 Mar 2025 07:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Pumfsa
	4bRdjruZKH1R4yg3gXZQMaBBsq79aEvVFWpzE=; b=JmZpxTo6LMM9RfJHQw/7YS
	PhJzIJ7qwNHN4mF3imyIrHkJ/5v1TULpQUnQTlpebv2bo3n9bjMO3Xe24zadPnWJ
	QYlX09uzt7FJAsrXtja2pueGRAyoqkKk7NZqBZBGdOMtTEFbdPkGfNQFqGbzcigR
	8dzLhMgI+efwJAbFqSMJVLUcgvbjOxJYxcmhHOSC23PqfL3FAI4+Vb43KcXkRHog
	zOfPCiWDKuLeAzq7KvufCkZted5piXEATzZADy80DJ3o0H+UQUhnWSjAUQJs4tkR
	pj+WLRJOqNtDe6qIxSm8sgsYGOsqLT9iQISW2OuKeNaTgJaG7yDZJuSqhFafl07A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455kmyj86t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 07:01:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5245NN8O020877;
	Tue, 4 Mar 2025 07:01:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 454esjusg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 07:01:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52471M4331654164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 07:01:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 777082004E;
	Tue,  4 Mar 2025 07:01:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2E002004B;
	Tue,  4 Mar 2025 07:01:20 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.90.107])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 07:01:20 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Mar 2025 08:01:20 +0100
Message-Id: <D87AEG6ZHH71.1Q6THN7G0WE3T@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] arch-run: fix test skips when
 /dev/stderr does not point to /proc/self/fd/2
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Andreas Grapentin" <gra@linux.ibm.com>, <kvm@vger.kernel.org>,
        "Paolo
 Bonzini" <pbonzini@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>,
        "Andrew
 Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.20.1
References: <ld5vg3ytv252ceaymg4mnq5jpnmklfvt2xkoldg67vkjl4awba@w3gc24eqeoxc>
In-Reply-To: <ld5vg3ytv252ceaymg4mnq5jpnmklfvt2xkoldg67vkjl4awba@w3gc24eqeoxc>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DAqPHv5mW8mOQ9Tw0GVq59m7nmpsr1bS
X-Proofpoint-GUID: DAqPHv5mW8mOQ9Tw0GVq59m7nmpsr1bS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_03,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040057

On Thu Feb 27, 2025 at 2:07 PM CET, Andreas Grapentin wrote:
> In configurations where /dev/stderr does not link to /proc/self/fd/2,
> run_qemu in arch-run.bash leaks the stderr of the invoked qemu command
> to /dev/stderr, instead of it being captured to the log variable in
> premature_failure in runtime.bash.
>
> This causes all tests to be skipped since the output required for the
> grep command in that function to indicate success is never present.
>
> As a possible fix, this patch gives stderr the same treatment as stdout
> in run_qemu, producing a dedicated file descriptor and handing it into
> the subshell.
>
> Signed-off-by: Andreas Grapentin <gra@linux.ibm.com>
> ---
>  scripts/arch-run.bash | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 2e4820c2..362aa1c5 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -33,11 +33,13 @@ run_qemu ()
>  	[ "$ENVIRON_DEFAULT" =3D "yes" ] && echo -n " #"
>  	echo " $INITRD"
> =20
> -	# stdout to {stdout}, stderr to $errors and stderr
> +	# stdout to {stdout}, stderr to $errors and {stderr}
>  	exec {stdout}>&1
> -	errors=3D$("${@}" $INITRD </dev/null 2> >(tee /dev/stderr) > /dev/fd/$s=
tdout)
> +	exec {stderr}>&2

For consistency, please add stderr as a local at the beginning of the funct=
ion.

With that fixed:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

