Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520AB2439BC
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 14:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHMMX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 08:23:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgHMMXZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 08:23:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DBYuWj076283;
        Thu, 13 Aug 2020 07:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nPx5fyCIb2EV6EMKeovtiedbwyfD/IBEq2I/uhLhlEE=;
 b=acLF4TuRctogIE4XWjhCMKAvBNP6lBPFeOiqjI1PM7QOISqx/8CYID/iCmRgz/MfZwTg
 usuzNKNWEEV+SCMW44w3TaQLtYBZYxlyV+dKfzP38CaJbYnF56QJkwlxDo8rSdt6B3A0
 LRA1SjqYPyHc2j5c8uXgM3/ley0ZDvZa/p7AXmHg0qisPTQ7+Errpj+d2mrsdCvd7WKS
 K7solIbvOExTcjxuUG3aHMMx7jgJokL3EH443RrzLEbIhUAlfuIxVxDJRlBrJnC5ucfN
 OTqvq0pBj++vtaDPZhEm+DjvwNcLr9749D5FZLMSwFTMPAqeaMBKEcnDeY5XISptmA4v YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vqqcvx9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 07:45:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DBZ62L077023;
        Thu, 13 Aug 2020 07:45:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vqqcvx8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 07:45:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DBeF05007978;
        Thu, 13 Aug 2020 11:45:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 32skp85gjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 11:45:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DBjmO723658820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 11:45:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7201DA4067;
        Thu, 13 Aug 2020 11:45:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E596FA405C;
        Thu, 13 Aug 2020 11:45:47 +0000 (GMT)
Received: from marcibm (unknown [9.145.178.142])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Aug 2020 11:45:47 +0000 (GMT)
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
Subject: Re: [kvm-unit-tests RFC v2 2/4] scripts: add support for architecture dependent functions
In-Reply-To: <20200813074940.73xzr6nq4xktjhpu@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com> <20200812092705.17774-3-mhartmay@linux.ibm.com> <20200813074940.73xzr6nq4xktjhpu@kamzik.brq.redhat.com>
Date:   Thu, 13 Aug 2020 13:45:46 +0200
Message-ID: <87lfiihiqd.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=2 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 09:49 AM +0200, Andrew Jones <drjones@redhat.com> w=
rote:
> On Wed, Aug 12, 2020 at 11:27:03AM +0200, Marc Hartmayer wrote:
>> This is necessary to keep architecture dependent code separate from
>> common code.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  README.md           | 3 ++-
>>  scripts/common.bash | 5 +++++
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/README.md b/README.md
>> index 48be206c6db1..24d4bdaaee0d 100644
>> --- a/README.md
>> +++ b/README.md
>> @@ -134,7 +134,8 @@ all unit tests.
>>  ## Directory structure
>>=20=20
>>      .:                  configure script, top-level Makefile, and run_t=
ests.sh
>> -    ./scripts:          helper scripts for building and running tests
>> +    ./scripts:          general architecture neutral helper scripts for=
 building and running tests
>> +    ./scripts/<ARCH>:   architecture dependent helper scripts for build=
ing and running tests
>>      ./lib:              general architecture neutral services for the t=
ests
>>      ./lib/<ARCH>:       architecture dependent services for the tests
>>      ./<ARCH>:           the sources of the tests and the created object=
s/images
>> diff --git a/scripts/common.bash b/scripts/common.bash
>> index 96655c9ffd1f..f9c15fd304bd 100644
>> --- a/scripts/common.bash
>> +++ b/scripts/common.bash
>> @@ -52,3 +52,8 @@ function for_each_unittest()
>>  	fi
>>  	exec {fd}<&-
>>  }
>> +
>> +ARCH_FUNC=3Dscripts/${ARCH}/func.bash
>
> The use of ${ARCH} adds a dependency on config.mak. It works now because
> in the two places we source common.bash we source config.mak first

Yep, I know.

> , but
> I'd prefer we make that dependency explicit.

Okay.

> We could probably just
> source it again from this file.

Another option is to pass ${ARCH} as an argument when we `source
scripts/runtime.bash`

=3D> `source scripts/runtime.bash "${ARCH}"`

Which one do you prefer?

>
> Thanks,
> drew
>
>> +if [ -f "${ARCH_FUNC}" ]; then
>> +	source "${ARCH_FUNC}"
>> +fi
>> --=20
>> 2.25.4
>>=20
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
