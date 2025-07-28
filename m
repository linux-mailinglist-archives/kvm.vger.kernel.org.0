Return-Path: <kvm+bounces-53545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E791B13CA6
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45FDD1C2030E
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6A6262FF0;
	Mon, 28 Jul 2025 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BXWmZLVp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6EF43147;
	Mon, 28 Jul 2025 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753711673; cv=none; b=gokDw+runI4ADZaZrH4omv/eSmpfSclAd86DVvB3n8Scwt4ioPe4b5zidV7PtiICYDBoUOSmFXTfgzCAUdZOjiCUvxBRpQV/vVqpGZNkKAj33oJ/awcVD/BbIskSS167m9rJtUC8VdQmep3h91gYYhfaI7XML2467STdltXx0pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753711673; c=relaxed/simple;
	bh=/eTJHbqadWj+e6DakVytqC2l+wi+xUljkFbhSTEiZGc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lc9aHLvsl2HJJEr5iNOrgLHcnDdfuJ2vFjp2WRT65b6Z8z0PZRoDcqy4UX85Zn2M4tJjDApjEGFbAFCOokKTd15xjBCs2D6y5cbcE/F5b0/gMiGM2aX5DNWCUIobJtXh8aqYh1pryUFNUQCAZslS29qnqR/QM/JzMK5eU5vcQfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BXWmZLVp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56S53wgb031518;
	Mon, 28 Jul 2025 14:07:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=t3dnnl
	K9jBt+h2Lo3A605+oeZBvObRMVCDQh4GRyKzI=; b=BXWmZLVpj+RS2YtYKbJXhR
	lnmqpEUnod5B/nGmqzSDLP8DxXPamQQRIWVKDHo/sTFN70Vc8vkUPnJxbSjzLDcK
	qM56r0xTPwgM0DGP2mzBeCHYJI/VOTdDe7taseFNmozkar8rsHtBYGx1yVQ1XBNJ
	/9vXZi+E9MywtXanB5/h1Wqi1LUqyzT1vOGgY21citRTfYlU9DJhN5ntW+8D7AZ5
	ox/6kKD/t+ffwLqbLdlB4ZaMOerbNOlrYJq3u7muLb1yg2QWgUxMoYz4pjdcwIQl
	6k4v1EKUDO4RFAWYvTV4PIICf/N2MqWC4oUXnCg0POA+RzjB/+G93DfDshlnM7OQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qd59dwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 14:07:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56SBXiJZ028748;
	Mon, 28 Jul 2025 14:07:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 485c22dsq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 14:07:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56SE7gm711993360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:07:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C8412004B;
	Mon, 28 Jul 2025 14:07:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD95A20043;
	Mon, 28 Jul 2025 14:07:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Jul 2025 14:07:41 +0000 (GMT)
Date: Mon, 28 Jul 2025 16:03:45 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Fix unreliable panic-loop
 tests
Message-ID: <20250728160345.54c4abfb@p-imbrenda>
In-Reply-To: <20250724133051.44045-2-thuth@redhat.com>
References: <20250724133051.44045-1-thuth@redhat.com>
	<20250724133051.44045-2-thuth@redhat.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDEwMSBTYWx0ZWRfX4oEb6tjgdd/J
 1kdvIBZf9nTYH5EjPtrDdWDOSSBma7EUF8biz8eo4usAdQGgDlRswaKSkbJ8nWj+tl5RG0d7zlI
 0n/jOmM9x9HmnlpdRj++rdgGHXYVHoz3TnD3bCDbU3pJ+Fo7yNqCPQckGg89CqP5/YAuISZDDn0
 esBETZFM4ssim2JZtM8stV4cby05x1+Ia0+L2b8AXKkMFRi2r2UjS/x0VLL/FNxwDusw28a5k7P
 BKU7tsPm9hHl65OVuo8RzQI8ltUOYqlZdsMZrW8Di/P2CzwnjISpkpvzTZicJB5adB+b4xh4Gol
 yJUtd70/3Xxln9PrbduiOP96pXI7sXzXHxPRyQ0P3UlVwzk5qy3Z9jTAnoyFbd6HmbRA0LD2Mcr
 oofQDUBqXegzEwM4iDg9pef7WVsMSBiO16O/awipt6GdHJEdIDl1vOV8ciR01OmYgGJn6ESy
X-Proofpoint-ORIG-GUID: tQfXON3I9u5G-Y8h8Exw29_zyNAhUAFu
X-Authority-Analysis: v=2.4 cv=B9q50PtM c=1 sm=1 tr=0 ts=68878432 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=KoHlIcV0PfifoefMnzEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: tQfXON3I9u5G-Y8h8Exw29_zyNAhUAFu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507280101

On Thu, 24 Jul 2025 15:30:49 +0200
Thomas Huth <thuth@redhat.com> wrote:

> From: Thomas Huth <thuth@redhat.com>
> 
> In our CI, the s390x panic-loop-extint and panic-loop-pgm tests
> are sometimes failing. Having a closer look, this seems to be caused
> by ncat sometimes complaining about "Connection reset by peer" on stderr,
> likely because QEMU terminated (due to the panic) before ncat could
> properly tear down the connection. But having some output on stderr is
> interpreted as test failure in qemu_fixup_return_code(), so the test is
> marked as failed, even though the panic event occurred as expected.
> 
> To fix it, drop the usage of ncat here and simply handle the QMP
> input and output via normal fifos instead. This has also the advantage
> that we do not need an additional program for these tests anymore
> that might not be available in the installation.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  scripts/arch-run.bash | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index c440f216..58e4f93f 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -63,14 +63,6 @@ qmp ()
>  	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
>  }
>  
> -qmp_events ()
> -{
> -	while ! test -S "$1"; do sleep 0.1; done
> -	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' |
> -		ncat --no-shutdown -U $1 |
> -		jq -c 'select(has("event"))'
> -}
> -
>  filter_quiet_msgs ()
>  {
>  	grep -v "Now migrate the VM (quiet)" |
> @@ -295,26 +287,23 @@ do_migration ()
>  
>  run_panic ()
>  {
> -	if ! command -v ncat >/dev/null 2>&1; then
> -		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> -		return 77
> -	fi
> -
>  	if ! command -v jq >/dev/null 2>&1; then
>  		echo "${FUNCNAME[0]} needs jq" >&2
>  		return 77
>  	fi
>  
>  	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
> -	trap 'rm -f ${qmp}' RETURN EXIT
> +	trap 'rm -f ${qmp}.in ${qmp}.out' RETURN EXIT
>  
>  	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> +	mkfifo ${qmp}.in ${qmp}.out
>  
>  	# start VM stopped so we don't miss any events
> -	"$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
> +	"$@" -chardev pipe,id=mon,path=${qmp} \
>  		-mon chardev=mon,mode=control -S &
> +	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
>  
> -	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
> +	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
>  	if [ "$panic_event_count" -lt 1 ]; then
>  		echo "FAIL: guest did not panic"
>  		ret=3


