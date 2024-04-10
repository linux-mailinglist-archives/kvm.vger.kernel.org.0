Return-Path: <kvm+bounces-14144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D3A89FE60
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 19:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 378D0B28FF4
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AF417BB10;
	Wed, 10 Apr 2024 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I5tZxxg6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB44176FDB;
	Wed, 10 Apr 2024 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712769555; cv=none; b=FgWdwHUgp9RcRpu3oz4UFEQp799P1TkTXvUs2WBX+RW2SwwAD1jqTM/5a8qTozdtkO9In/4ZxY8UDiqlla78gUKyxyR8/k/LhSgglOS6U/A1f1GeoFOhNKex6toRL6ubJUg1zIN9RDhwdc0B+Xv4x15RWCqAbacsa9E9UKwxZDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712769555; c=relaxed/simple;
	bh=r+8GB3YSCFrdIgTy1E56r6fY5pMgbm3TyaFh8Y/uvaA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KcsNeqtBcPHtsCzv8WhqlIk2a1J17sunqd5gK7dBUoFOZvyOF6Lr7eXLJDv2tq7s/WUfiLrVeaoTqMt7580ZtlWRUMNWXCgBkrm/D/j2TT3MO6xa39i8AGPA7aUnbBef74mMu6psNAYtAagRanv2pgeLWBfcEmXZjOeQPdQD478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I5tZxxg6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43AH7mRK006163;
	Wed, 10 Apr 2024 17:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tHCYzRMhIHx1yvaC14xXg/YdZQNQ/pDFzRw82c7drYs=;
 b=I5tZxxg6gegTuoKj5I+zJTT1b0lB6oL9N7K9ejqGPsoZxAWyq3tBBCcXI72yk2JXCoO0
 HT8HqhbXfmKvzpLsEM+sxM8T7iRYRZnp86YA1YoHy+VDhaP4rqaj10sCsZiAPJsaGbwT
 JYBW5WeVdOqzyn4j6U4psFDqLX4IFEVILHREwQpPHmC+AGICRa6+XCjlJlVsmlzSbJ7P
 IuhjAkZdJtOmopArDII3Lc3EE9TPmtfSstyNLotvHfRpJUeK3aJp5yFDJYmmoJXolknP
 +f3pynHoICwt3IUuwr9IFkY6Pu/MI8UFlhPdlKc+64YlZ8ZavrFtMJCChd9GstKSo0d2 dA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdxkx02gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:19:01 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43AHJ1YC024473;
	Wed, 10 Apr 2024 17:19:01 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdxkx02gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:19:01 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43AEmpGk021496;
	Wed, 10 Apr 2024 17:19:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbjxkwvp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:19:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43AHIsDA42533204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 17:18:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D51782004F;
	Wed, 10 Apr 2024 17:18:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9B042005A;
	Wed, 10 Apr 2024 17:18:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Apr 2024 17:18:54 +0000 (GMT)
Date: Wed, 10 Apr 2024 19:18:53 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Nicholas Piggin" <npiggin@gmail.com>
Cc: "Thomas Huth" <thuth@redhat.com>, "Janosch Frank"
 <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Andrew Jones"
 <andrew.jones@linux.dev>, <linux-s390@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Fix is_pv check in run script
Message-ID: <20240410191853.686978b0@p-imbrenda>
In-Reply-To: <D0G5V9Z62QS1.1BWMOLQZWBO5T@gmail.com>
References: <20240406122456.405139-1-npiggin@gmail.com>
	<20240406122456.405139-3-npiggin@gmail.com>
	<20240408133629.34a2e34c@p-imbrenda>
	<D0G5V9Z62QS1.1BWMOLQZWBO5T@gmail.com>
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
X-Proofpoint-ORIG-GUID: 0YmH2oBtD0SGR4IAhO4eQzuXRiyZB7Je
X-Proofpoint-GUID: ODyBd8oJmLxEL7dQSck8JqlQ0Z9VMSXn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100127

On Wed, 10 Apr 2024 14:34:25 +1000
"Nicholas Piggin" <npiggin@gmail.com> wrote:

> On Mon Apr 8, 2024 at 9:36 PM AEST, Claudio Imbrenda wrote:
> > On Sat,  6 Apr 2024 22:24:54 +1000
> > Nicholas Piggin <npiggin@gmail.com> wrote:
> >  
> > > Shellcheck reports "is_pv references arguments, but none are ever
> > > passed." and suggests "use is_pv "$@" if function's $1 should mean
> > > script's $1."
> > > 
> > > The is_pv test does not evaluate to true for .pv.bin file names, only
> > > for _PV suffix test names. The arch_cmd_s390x() function appends
> > > .pv.bin to the file name AND _PV to the test name, so this does not
> > > affect run_tests.sh runs, but it might prevent PV tests from being
> > > run directly with the s390x-run command.
> > > 
> > > Reported-by: shellcheck SC2119, SC2120
> > > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>  
> >
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: bcedc5a2 ("s390x: run PV guests with confidential guest enabled")  
> 
> Thanks.
> 
> > although tbh I would rewrite it to check a variable, something like:
> >
> > IS_PV=no
> > [ "${1: -7}" = ".pv.bin" -o "${TESTNAME: -3}" = "_PV" ] && IS_PV=yes  
> 
> I don't have a problem if you want to fix it a different way
> instead. I don't have a good way to test at the moment and
> this seemed the simplest fix. Shout out if you don't want it
> going upstream as is.

well, I did give you a r-b for the current version of your patch :)

it's not so important, as long as it works correctly 

> 
> Thanks,
> Nick
> 
> >  
> > > ---
> > >  s390x/run | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/s390x/run b/s390x/run
> > > index e58fa4af9..34552c274 100755
> > > --- a/s390x/run
> > > +++ b/s390x/run
> > > @@ -21,12 +21,12 @@ is_pv() {
> > >  	return 1
> > >  }
> > >  
> > > -if is_pv && [ "$ACCEL" = "tcg" ]; then
> > > +if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then  
> >
> > if [ "$IS_PV" = "yes" -a "$ACCEL" = "tcg" ]; then
> >
> > etc...
> >  
> > >  	echo "Protected Virtualization isn't supported under TCG"
> > >  	exit 2
> > >  fi
> > >  
> > > -if is_pv && [ "$MIGRATION" = "yes" ]; then
> > > +if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
> > >  	echo "Migration isn't supported under Protected Virtualization"
> > >  	exit 2
> > >  fi
> > > @@ -34,12 +34,12 @@ fi
> > >  M='-machine s390-ccw-virtio'
> > >  M+=",accel=$ACCEL$ACCEL_PROPS"
> > >  
> > > -if is_pv; then
> > > +if is_pv "$@"; then
> > >  	M+=",confidential-guest-support=pv0"
> > >  fi
> > >  
> > >  command="$qemu -nodefaults -nographic $M"
> > > -if is_pv; then
> > > +if is_pv "$@"; then
> > >  	command+=" -object s390-pv-guest,id=pv0"
> > >  fi
> > >  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"  
> 


