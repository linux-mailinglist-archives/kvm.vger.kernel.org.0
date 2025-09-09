Return-Path: <kvm+bounces-57109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE04B4FE91
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C065A5E1D83
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 14:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45470229B38;
	Tue,  9 Sep 2025 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fvu5U9WH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E672C22F77E
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757426554; cv=none; b=SM4DczmoESujNXke4RMoJboclvdf3VrdvgvX2BVj1QS30ydYsp9C2tBbgrcuIbWbwBg8mwC7MP2y5QNsmU/qJPWZhYUK4TyGgAxSd8+mLwlpBWhshQD5iD3037WG0GwkkK22LEX+ibd4KtLG3DWWdPeRx5ORGPrAZaiwa6JYj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757426554; c=relaxed/simple;
	bh=G1dPPDxJXLZo8fMZuEE7FGykyGE8FBrH9KLefb2wg/s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAi8xWUm6sCD5jvlEN1ifJPdzeR1Fa/Sp3qzA0btvpgkwQIrv/5Bxlj651ePCeWHl8J+YoCpURMVpnMgVQ6w15C5xtCLl4dJz+e9qMYFPB9rQkasp4cib4ccpfKL2IkPoC6BVAeiTreZqwPgQq+SGWq2DmFkpknjthiNxRpK7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fvu5U9WH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896qZJc022621;
	Tue, 9 Sep 2025 14:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=x5cSmE
	2GiowbYIIxGD1VOGSOplzrFRBCQcKij5HxouU=; b=Fvu5U9WHty6h08lgYJzxdQ
	zYjHjbptz8GENbRw5Qrke6cwMkvKAGMSvmPDe+w4rn9bGnS0zPKqTm2GdXNEW/Qd
	0j5VvYnh7IKzB1H66pnf6P6QulPBqE0/cOHFGBqScXQuOgKJ43i5zG0UHV8OzRSk
	6Q5176D9Szp7yN2tHLLLkVNNwg7MJKfJ91HnCUrois4lWfjydtASn/KNUWAIrkgs
	KRvZbMItkpd9CPAGl4xuoq6qCYHcNKjZCwnU0KTeAkH7x5DrwlA/TUt6m7qJbTqf
	Nl7Qvhagvd5OjHT6mw/mE1jkeFVBC1vOY1M7oxvJ/WgmZtT2g9yk+u2Y2k+CDS1A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwr873-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:02:25 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589D9EEU011434;
	Tue, 9 Sep 2025 14:02:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9ubpuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:02:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589E2JiA31982190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 14:02:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4DE120040;
	Tue,  9 Sep 2025 14:02:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 850CA2004D;
	Tue,  9 Sep 2025 14:02:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.75.184])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  9 Sep 2025 14:02:19 +0000 (GMT)
Date: Tue, 9 Sep 2025 15:49:08 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Janosch
 Frank <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?=
 <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the
 dependency on "jq"
Message-ID: <20250909154908.49943d59@p-imbrenda>
In-Reply-To: <20250909045855.71512-1-thuth@redhat.com>
References: <20250909045855.71512-1-thuth@redhat.com>
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
X-Proofpoint-GUID: LL5a0u_SGauvi1ZNrbbBgpFM9UYko3WS
X-Proofpoint-ORIG-GUID: LL5a0u_SGauvi1ZNrbbBgpFM9UYko3WS
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c03371 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=i0M0ddQKDvQEzp8E9eUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfXyXSJEzuqvbvS
 3xiQHjOO/6DUyz2fYr7MW3GxDYgWV0fNnZ4+b1wU5C+98rt6H/xQMr4ErZXW+8EN4I07xsADmut
 Y9xnS3Is+cr2DKB7Q8cX9tmwKlbHiBKNKpFRnb2TpQj/6r7zOuW6eIJuu+sflfzo72F74uPbQF+
 kCOy6aP/PaWhl5CrBE/nHbR5pXV2hmFcECRxuB6VJKxLMIq2DNVWgdNENixpVh07KXxBnVJJ+ka
 bCG8dtCc5jPqUSTHtKo4ZsIyJUWkX9bIUDGetbdm0iR4tUdXbzshfGuqsfqMCu4UMWvfx4xdNe7
 ge0z7MA1gSSd5Kp4zBc5+3jU2WdXhB6S7QDJnrDglaq6h/uAc877WfPeem7ER5XMUWacKiWkzAt
 JkJEaLVI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

On Tue,  9 Sep 2025 06:58:55 +0200
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  v2: Change the regular expression according to Claudio's suggestion
> 
>  scripts/arch-run.bash | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 36222355..16417a1e 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -296,11 +296,6 @@ do_migration ()
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
> @@ -312,8 +307,7 @@ run_panic ()
>  		-mon chardev=mon,mode=control -S &
>  	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
>  
> -	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
> -	if [ "$panic_event_count" -lt 1 ]; then
> +	if ! grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST_PANICKED"' ${qmp}.out ; then
>  		echo "FAIL: guest did not panic"
>  		ret=3
>  	else


