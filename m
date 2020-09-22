Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D58273E71
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIVJWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 05:22:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgIVJWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 05:22:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M92vo0029871
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 05:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=v9R+9dW+yIUuOs8nEo+17HIplmDNhU/Pi5s3ECeH3ms=;
 b=nDFzmeJhyH5uMUWYjPK3dQchIZa1oBQ/RmkyKT1XpheDR+dSadrpJvMovLLMFOI8h+vy
 fP5gQYAhm5+uYuNKUkrTLi++LX9GgeX6PMUqIJnvMrNmG4fF0Bh91lSJAsAhr8I4pksB
 UDmn2IaxICHXlAZlanZO7mFHeWk3HUa1dNiYTvMxyC9Fi4hQRAF1ywK7EuNQKUUl9dYx
 NjjPRuLdOWqQkMOxX/0fqtaazuuR3WPWfqCcQ96sxAYAO7RswiQWC9swEQdNMX+H7W5b
 wh7KXxprykkdv1mbEGsRw68geI0PfpcrdY31IJZ928LL4TQ+RcoaA4/B3rH0mu+kBKlv lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qag4q0ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 05:22:14 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08M933Vf030488
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 05:22:14 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qag4q0bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 05:22:14 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08M9El2H026858;
        Tue, 22 Sep 2020 09:22:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gsh15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 09:22:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08M9M7Um17563932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 09:22:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D8DA405B;
        Tue, 22 Sep 2020 09:22:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AA77A4060;
        Tue, 22 Sep 2020 09:22:08 +0000 (GMT)
Received: from marcibm (unknown [9.145.156.112])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Sep 2020 09:22:07 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Use same test names in the
 default and the TAP13 output format
In-Reply-To: <d740c6a7-6680-ce7b-489b-aaa8cf712f56@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
 <87bli7tm68.fsf@linux.ibm.com>
 <d740c6a7-6680-ce7b-489b-aaa8cf712f56@redhat.com>
Date:   Tue, 22 Sep 2020 11:22:07 +0200
Message-ID: <87eemui2tc.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_06:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 10:53 AM +0200, Thomas Huth <thuth@redhat.com> wrot=
e:
> On 15/09/2020 11.38, Marc Hartmayer wrote:
>> On Tue, Aug 25, 2020 at 12:20 PM +0200, Marc Hartmayer <mhartmay@linux.i=
bm.com> wrote:
>>> For everybody's convenience there is a branch:
>>> https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap_v2
>>>
>>> Changelog:
>>> v1 -> v2:
>>>  + added r-b's to patch 1
>>>  + patch 2:
>>>   - I've not added Andrew's r-b since I've worked in the comment from
>>>     Janosch (don't drop the first prefix)
>>>
>>> Marc Hartmayer (2):
>>>   runtime.bash: remove outdated comment
>>>   Use same test names in the default and the TAP13 output format
>>>
>>>  run_tests.sh         | 15 +++++++++------
>>>  scripts/runtime.bash |  9 +++------
>>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>>
>>> --=20
>>> 2.25.4
>>>
>>=20
>> Polite ping :) How should we proceed further?
>
> Sorry, it's been some quite busy weeks ... I'll try to collect some
> pending kvm-unit-tests patches in the next days and then send a pull
> request to Paolo...

No problem :) Thanks for taking care!

>
>  Thomas
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
