Return-Path: <kvm+bounces-13878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5B089BE36
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 242AB283D6B
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 11:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F07669D3D;
	Mon,  8 Apr 2024 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LimIfbDp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B4C1E497;
	Mon,  8 Apr 2024 11:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712576352; cv=none; b=qJ2PXwKsNhnk7LeSvr7wqcJjmlZ/e3mQXWcN6Wh5gwesvxvhMkGcxxu497tFoCybUf7wcUYD6CRoQ7S/0iB8uWyUsb1LS8kdOzDvABpmGpKPg7xXfkuiofx+t+W6LAy5A8i/92Y0AGWvaP/xD1KbSUEQQ2mGr50Y2HdPIr86jCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712576352; c=relaxed/simple;
	bh=2h7MXEy8xqPHMn26EYH9wUF5do0zeDbk7rti3eL5q5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZ4WVCOBOWhgIAqaMZh69OoNzbo0HC2/oEeqioZf7OAOTztRom01XJwWr5Jd5VxvajiwsSGSwAecDnszFJRrXin0jEVyYR3Qx5bQT6+BSdLsUUnJ8MDCklQ5yrqRDSS74KPWW5LVc8aDS+wHAOOvKavKcfYQHrKkaP7Chy8AH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LimIfbDp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438BO1xv001057;
	Mon, 8 Apr 2024 11:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=HaoV9SuNaGbyMRXssMYGcBSujlsTNO1OPbytpEM2Z+c=;
 b=LimIfbDprt+I3kTXGcEUmbwF0CJ/fwrnnlI437DMWQpLhkAzfGA3tpAP48vpnAbUjZs1
 1StrFjzdFG89tXSS+SoKO9+xieM/LtoH8oli/eWudB3ltFpAtjLbx0WLwBsScyx7EEAz
 CRGW8pQQNk/VLFCd+DBjCDLzTocsu10IhIDBpIZCR4r3HU8B0XHecWCSGqwsAuu6W8Sd
 X/NSswmBum+oIlCcDR50lwGbjCMTPkzUFQ/pA2w2iwZzVFzbAhHQh8hSGW5IMld0EumU
 d8Oacce0Ck3FdXyPykkyUZESSbFMDluRUXuv4AhowU0NkloFKJ0SOiP9GGpTNQ+3W2eg Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xcd32gbab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 11:38:59 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438BcxYu023309;
	Mon, 8 Apr 2024 11:38:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xcd32gb8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 11:38:59 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 438B2Kng013550;
	Mon, 8 Apr 2024 11:36:37 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbgqt82b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 11:36:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 438BaVpY52429146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Apr 2024 11:36:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA3632004B;
	Mon,  8 Apr 2024 11:36:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CA6420040;
	Mon,  8 Apr 2024 11:36:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Apr 2024 11:36:31 +0000 (GMT)
Date: Mon, 8 Apr 2024 13:36:29 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Fix is_pv check in run script
Message-ID: <20240408133629.34a2e34c@p-imbrenda>
In-Reply-To: <20240406122456.405139-3-npiggin@gmail.com>
References: <20240406122456.405139-1-npiggin@gmail.com>
	<20240406122456.405139-3-npiggin@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Rtx2J5yZJfc77DY7OQwVS7sBexkA9qPA
X-Proofpoint-ORIG-GUID: TlKnqTW2cgczLH94wvwnxH6eaPXVRH2I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_10,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080089

On Sat,  6 Apr 2024 22:24:54 +1000
Nicholas Piggin <npiggin@gmail.com> wrote:

> Shellcheck reports "is_pv references arguments, but none are ever
> passed." and suggests "use is_pv "$@" if function's $1 should mean
> script's $1."
> 
> The is_pv test does not evaluate to true for .pv.bin file names, only
> for _PV suffix test names. The arch_cmd_s390x() function appends
> .pv.bin to the file name AND _PV to the test name, so this does not
> affect run_tests.sh runs, but it might prevent PV tests from being
> run directly with the s390x-run command.
> 
> Reported-by: shellcheck SC2119, SC2120
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: bcedc5a2 ("s390x: run PV guests with confidential guest enabled")

although tbh I would rewrite it to check a variable, something like:

IS_PV=no
[ "${1: -7}" = ".pv.bin" -o "${TESTNAME: -3}" = "_PV" ] && IS_PV=yes

> ---
>  s390x/run | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/s390x/run b/s390x/run
> index e58fa4af9..34552c274 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -21,12 +21,12 @@ is_pv() {
>  	return 1
>  }
>  
> -if is_pv && [ "$ACCEL" = "tcg" ]; then
> +if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then

if [ "$IS_PV" = "yes" -a "$ACCEL" = "tcg" ]; then

etc...

>  	echo "Protected Virtualization isn't supported under TCG"
>  	exit 2
>  fi
>  
> -if is_pv && [ "$MIGRATION" = "yes" ]; then
> +if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
>  	echo "Migration isn't supported under Protected Virtualization"
>  	exit 2
>  fi
> @@ -34,12 +34,12 @@ fi
>  M='-machine s390-ccw-virtio'
>  M+=",accel=$ACCEL$ACCEL_PROPS"
>  
> -if is_pv; then
> +if is_pv "$@"; then
>  	M+=",confidential-guest-support=pv0"
>  fi
>  
>  command="$qemu -nodefaults -nographic $M"
> -if is_pv; then
> +if is_pv "$@"; then
>  	command+=" -object s390-pv-guest,id=pv0"
>  fi
>  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"


