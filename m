Return-Path: <kvm+bounces-53544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B44DB13CAE
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83DBD1C248DA
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA50265CDD;
	Mon, 28 Jul 2025 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cpwGIWh6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65048263C69;
	Mon, 28 Jul 2025 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753711669; cv=none; b=Nosn8mJ3ftW7fAQ4edrYpjY8+lbjZwxtyFCEZ6DVA8zWVOAmhy68QwqICrkzXBJQ8v5wcIZcbxSsSn0Ej//K6xXHGeJ51LrRsRew7ksUuRVgxlwMskaTqTzq3XSMIAgqjQOBLHK/nwJO1Zf65qQwaOISeysgMU2Mj5BGWudDtJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753711669; c=relaxed/simple;
	bh=fLcJynvRjEAQ2TGOrv+85IQpzGf1/razRWhQR/d40LE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEH/4bp497R3H3oMLktnehJH8UBtrOS8hjnbvAAL3aDGN9VJ52wTGzYHjlWRb8s1AKmdLLiJoSpaB8RxubvCBdKGZcMxPfK9TcbM+FsLXKWBDlNbijkiqePZF73t6RRhxy5AzAflJq27dObbRHeSQT4UwaiYxTHvogcPPhd4vUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cpwGIWh6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SBVZ2d002686;
	Mon, 28 Jul 2025 14:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cZERLj
	eDKTEaxCqzY5B0AbixZXcwi1Mo+oACr1d8QX4=; b=cpwGIWh6YPFUECfkBq+5LB
	bfErdnmkm0DQQnYwzR8f3r+ifm4iEZR2xYArKRMVxOjErP8BlSWcMXUCu4AiJRqi
	5dwxmfIgP40MvZ3yYM9cGEpmKteLwevcWohK9SVC18z5k2xMLgyAHSamOsH2R/0F
	oq9jSYdOXyywhJ75emGo2yfmO/x/CmqxBgRW/ATqz+ikLY+oth41N0x29/paea+1
	eKf5kbRPX670OritEAA4Ktw4HdaWztPDJljfcSu7OXV8vyYd6JUNBIStQKEIEHUy
	wBHmzoJNKvg51p8I3c37QqUUWG53w1eEd5cTSOBo4NgZSDZ0vLrx23T8d8pDo6dA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qau1ehn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 14:07:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56SBXD5o028755;
	Mon, 28 Jul 2025 14:07:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 485c22dsq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 14:07:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56SE7elS52691366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:07:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F47920043;
	Mon, 28 Jul 2025 14:07:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75A9020040;
	Mon, 28 Jul 2025 14:07:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Jul 2025 14:07:40 +0000 (GMT)
Date: Mon, 28 Jul 2025 15:59:42 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC PATCH 3/3] scripts/arch-run.bash: Drop the
 dependency on "jq"
Message-ID: <20250728155942.0967cc2b@p-imbrenda>
In-Reply-To: <20250724133051.44045-4-thuth@redhat.com>
References: <20250724133051.44045-1-thuth@redhat.com>
	<20250724133051.44045-4-thuth@redhat.com>
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
X-Authority-Analysis: v=2.4 cv=Xvz6OUF9 c=1 sm=1 tr=0 ts=68878431 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=20KFwNOVAAAA:8 a=i0M0ddQKDvQEzp8E9eUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDEwMSBTYWx0ZWRfX4/fNI912FaFJ
 j8P3SL6nVPJioLUMPza+jm2OB/47WoNVCymRW9U1PbFUdaZnjN0kiG5DCyHJ+qYfgrduprJZKe0
 48Gc78kkt4qxjCEt2b89VvwrJmoYdQBrgy2cBkE3mw42BfkzKwVcGi8n3M2paVRNUedGyLMlSqK
 XSyTnB6sfN3MuDsLqBk8xMN5Y9UQKhV7ZE0qNC+gzubKZtRrKBleGTKOk4r9zGtkN1vLMvGEctm
 yQ51JdcFUK32JcycyD0gLGgVmL+MZivRmX+/0OiwqOrsQGyp9v7pytFvwcnvZtDQcaoDF8Zz8zu
 GrzNKiA8QZPr4h1iPlweaZmdNXoV/Wwl93se0/7iHljwJWIoYuyl0mhDG/6ytbH5YKPfjVsqTnk
 xiXAv5f/i5+L2//vBJcc8rYesBoDQa5/6LWqkdd+PTHkiQcWW+YQK8YoIC6+HFUAWvhpTBJ/
X-Proofpoint-GUID: dR9NrpJ-G8WYWPwor4afn_Es1lCA8UiE
X-Proofpoint-ORIG-GUID: dR9NrpJ-G8WYWPwor4afn_Es1lCA8UiE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxlogscore=799 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507280101

On Thu, 24 Jul 2025 15:30:51 +0200
Thomas Huth <thuth@redhat.com> wrote:

> From: Thomas Huth <thuth@redhat.com>
> 
> For checking whether a panic event occurred, a simple "grep"
> for the related text in the output is enough - it's very unlikely
> that the output of QEMU will change. This way we can drop the
> dependency on the program "jq" which might not be installed on
> some systems.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Marked as "RFC" since I'm a little bit torn here - on the one side,
>  it's great to get rid of a dependency, on the other side, using
>  grep might be a little bit less robust in case QEMU ever changes
>  the layout of it's QMP output...

I share your concerns, but I'm also in favour of removing a relatively
uncommon dependency

> 
>  scripts/arch-run.bash | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 58e4f93f..5abf2626 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -287,11 +287,6 @@ do_migration ()
>  
>  run_panic ()
>  {
> -	if ! command -v jq >/dev/null 2>&1; then
> -		echo "${FUNCNAME[0]} needs jq" >&2
> -		return 77
> -	fi
> -
>  	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
>  	trap 'rm -f ${qmp}.in ${qmp}.out' RETURN EXIT
>  
> @@ -303,8 +298,7 @@ run_panic ()
>  		-mon chardev=mon,mode=control -S &
>  	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
>  
> -	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
> -	if [ "$panic_event_count" -lt 1 ]; then
> +	if ! grep -q '"event": "GUEST_PANICKED"' ${qmp}.out ; then

maybe:
	grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST PANICKED"' ...

>  		echo "FAIL: guest did not panic"
>  		ret=3
>  	else


