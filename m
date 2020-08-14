Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC76244A21
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgHNNGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 09:06:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbgHNNGp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 09:06:45 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ED2AuZ139660;
        Fri, 14 Aug 2020 09:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=v45GiFYyi6zned0O6yfjwXviSuIpFQP0lrJJKKfZ1Eo=;
 b=JOG4sEiUVntBRYEewKGdeaF2QRuIOkerETRWfKza0X/GRlSa2sDluB+H1GIxcH89jY+2
 1kpvafakf6phAWhrseA0Zd07mzklUONGC1BOW75qR1wkGLPSGu/4wD/xE2Li3YJbH87b
 JDSSdJ3YOrjwHiuxlHdNU6D8r8+Mw4MQvN9CFvD22p+Xm28pW8atxR9S+81y+geu5CDL
 aPpcSVRFNeRUw50YLpShe1gVERJufEnOzA2eePMFYFXZIxFSoGQQ9nvHSKkREbhWrF/2
 FXfIVIOd2Z3/c7ZnjpgTLA9etL9v6bznimUa1tfndCkn/ywdvlin1/BMKfAQYwm/n5c6 SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w30r7bms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 09:06:44 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07ED4nUJ153006;
        Fri, 14 Aug 2020 09:06:44 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w30r7bkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 09:06:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07ED5UK9008167;
        Fri, 14 Aug 2020 13:06:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 32skp7v3qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 13:06:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07ED5AKw63439334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 13:05:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A92FC4C040;
        Fri, 14 Aug 2020 13:06:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37C9B4C04E;
        Fri, 14 Aug 2020 13:06:38 +0000 (GMT)
Received: from marcibm (unknown [9.145.57.205])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 14 Aug 2020 13:06:38 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 3/4] run_tests/mkstandalone: add arch dependent function to `for_each_unittest`
In-Reply-To: <20200813083000.e4bscohuhgl3jdv4@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com> <20200812092705.17774-4-mhartmay@linux.ibm.com> <20200813083000.e4bscohuhgl3jdv4@kamzik.brq.redhat.com>
Date:   Fri, 14 Aug 2020 15:06:36 +0200
Message-ID: <87h7t51in7.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_07:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=2
 impostorscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 10:30 AM +0200, Andrew Jones <drjones@redhat.com> w=
rote:
> On Wed, Aug 12, 2020 at 11:27:04AM +0200, Marc Hartmayer wrote:
>> This allows us, for example, to auto generate a new test case based on
>> an existing test case.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  run_tests.sh            |  2 +-
>>  scripts/common.bash     | 13 +++++++++++++
>>  scripts/mkstandalone.sh |  2 +-
>>  3 files changed, 15 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/run_tests.sh b/run_tests.sh
>> index 24aba9cc3a98..23658392c488 100755
>> --- a/run_tests.sh
>> +++ b/run_tests.sh
>> @@ -160,7 +160,7 @@ trap "wait; exit 130" SIGINT
>>     # preserve stdout so that process_test_output output can write TAP t=
o it
>>     exec 3>&1
>>     test "$tap_output" =3D=3D "yes" && exec > /dev/null
>> -   for_each_unittest $config run_task
>> +   for_each_unittest $config run_task arch_cmd
>
> Let's just require that arch cmd hook be specified by the "$arch_cmd"
> variable. Then we don't need to pass it to for_each_unittest.

Where is it then specified?

>
>>  ) | postprocess_suite_output
>>=20=20
>>  # wait until all tasks finish
>> diff --git a/scripts/common.bash b/scripts/common.bash
>> index f9c15fd304bd..62931a40b79a 100644
>> --- a/scripts/common.bash
>> +++ b/scripts/common.bash
>> @@ -1,8 +1,15 @@
>> +function arch_cmd()
>> +{
>> +	# Dummy function, can be overwritten by architecture dependent
>> +	# code
>> +	return
>> +}
>
> This dummy function appears unused and can be dropped.

So what is then used if the function is not defined by the architecture
specific code?

>
>>=20=20
>>  function for_each_unittest()
>>  {
>>  	local unittests=3D"$1"
>>  	local cmd=3D"$2"
>> +	local arch_cmd=3D"${3-}"
>>  	local testname
>>  	local smp
>>  	local kernel
>> @@ -19,6 +26,9 @@ function for_each_unittest()
>>  		if [[ "$line" =3D~ ^\[(.*)\]$ ]]; then
>>  			if [ -n "${testname}" ]; then
>>  				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$che=
ck" "$accel" "$timeout"
>> +				if [ "${arch_cmd}" ]; then
>> +					"${arch_cmd}" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts=
" "$arch" "$check" "$accel" "$timeout"
>> +				fi
>
> Rather than assuming we should run both $cmd ... and $arch_cmd $cmd ...,
> let's just run $arch_cmd $cmd ..., when it exists. If $arch_cmd wants to
> run $cmd ... first, then it can do so itself.

Yep, makes sense.

>
>>  			fi
>>  			testname=3D${BASH_REMATCH[1]}
>>  			smp=3D1
>> @@ -49,6 +59,9 @@ function for_each_unittest()
>>  	done
>>  	if [ -n "${testname}" ]; then
>>  		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check=
" "$accel" "$timeout"
>> +		if [ "${arch_cmd}" ]; then
>> +			"${arch_cmd}" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" =
"$arch" "$check" "$accel" "$timeout"
>> +		fi
>>  	fi
>>  	exec {fd}<&-
>>  }
>> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
>> index cefdec30cb33..3b18c0cf090b 100755
>> --- a/scripts/mkstandalone.sh
>> +++ b/scripts/mkstandalone.sh
>> @@ -128,4 +128,4 @@ fi
>>=20=20
>>  mkdir -p tests
>>=20=20
>> -for_each_unittest $cfg mkstandalone
>> +for_each_unittest $cfg mkstandalone arch_cmd
>> --=20
>> 2.25.4
>>
>
> In summary, I think this patch should just be
>
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 9a6ebbd7f287..b409b0529ea6 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -17,7 +17,7 @@ function for_each_unittest()
>=20=20
>         while read -r -u $fd line; do
>                 if [[ "$line" =3D~ ^\[(.*)\]$ ]]; then
> -                       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$o=
pts" "$arch" "$check" "$accel" "$timeout"
> +                       "$arch_cmd" "$cmd" "$testname" "$groups" "$smp" "=
$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"

If we remove the $arch_cmd variable we can directly use:

arch_cmd "$cmd" =E2=80=A6

>                         testname=3D${BASH_REMATCH[1]}
>                         smp=3D1
>                         kernel=3D""
> @@ -45,6 +45,6 @@ function for_each_unittest()
>                         timeout=3D${BASH_REMATCH[1]}
>                 fi
>         done
> -       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$c=
heck" "$accel" "$timeout"
> +       "$arch_cmd" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts"=
 "$arch" "$check" "$accel" "$timeout"
>         exec {fd}<&-
>  }
>=20=20
>
> Thanks,
> drew
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
