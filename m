Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F2424D729
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHUORD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 10:17:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgHUORD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 10:17:03 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LE22SG189458
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:17:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zRIdx6EuooxuSC9Ok857ggmmuGSrrc9/lzb9XZURCXI=;
 b=W9ooIEqj6fJ8M0MYEQwCA7zA8OG/3TSWb4hk5lvZZynosGicPd6B5dXvvywRQqMtTscv
 R6ALQonYDJWEmNt+HqeMu8kjdPM3FhNdtccsyvoFhU7HNr2vdDsTAxQVjDE+jgZK2Bys
 CTF+EZkXHztuN9GC0v/lvaDknwhD0bF8M1fQjXv2CSjac5zn5Mi7p42vV0LIQHMTNX0W
 ISvgPgskTNnyXcQQyNGu1GO319xhgKna/SMIXtfEOmj3kS7eGAVMdiApivLQ/9fkwkT4
 21TuAZU54dE3pf2hcpOGfkcahfcuxQmDmr4RFPHnU7V3BLz0AGKw9rv3ttkaVUsVTA1M 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3327xu5wtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:17:01 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LE2foI193757
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:17:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3327xu5wt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 10:17:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LEFXkN032251;
        Fri, 21 Aug 2020 14:16:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3304um4dtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 14:16:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LEGugA60162492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 14:16:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D473BAE053;
        Fri, 21 Aug 2020 14:16:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BACAAE055;
        Fri, 21 Aug 2020 14:16:56 +0000 (GMT)
Received: from marcibm (unknown [9.145.60.23])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 21 Aug 2020 14:16:56 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] Use same test names in the default and the TAP13 output format
In-Reply-To: <86d94ab0-9554-3af8-96c5-825c373615ef@linux.ibm.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com> <20200821123744.33173-3-mhartmay@linux.ibm.com> <86d94ab0-9554-3af8-96c5-825c373615ef@linux.ibm.com>
Date:   Fri, 21 Aug 2020 16:16:54 +0200
Message-ID: <875z9cf5ih.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=2
 spamscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 04:05 PM +0200, Janosch Frank <frankja@linux.ibm.co=
m> wrote:
> On 8/21/20 2:37 PM, Marc Hartmayer wrote:
>> Use the same test names in the TAP13 output as in the default output
>> format. This makes the output more consistent. To achieve this, we
>> need to pass the test name as an argument to the function
>> `process_test_output`.
>>=20
>> Before this change:
>> $ ./run_tests.sh
>> PASS selftest-setup (14 tests)
>> ...
>>=20
>> vs.
>>=20
>> $ ./run_tests.sh -t
>> TAP version 13
>> ok 1 - selftest: true
>> ok 2 - selftest: argc =3D=3D 3
>> ...
>>=20
>> After this change:
>> $ ./run_tests.sh
>> PASS selftest-setup (14 tests)
>> ...
>>=20
>> vs.
>>=20
>> $ ./run_tests.sh -t
>> TAP version 13
>> ok 1 - selftest-setup: true
>> ok 2 - selftest-setup: argc =3D=3D 3
>
> This doesn't work for me, we can't just drop prefixes.
>
> I.e. it needs to be "testname: prefix1: prefix2: prefixn: Test text"
> selftest-setup: selftest: true

Okay, I=E2=80=99ll fix that.

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
