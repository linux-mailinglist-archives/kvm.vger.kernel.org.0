Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FFE6E4340
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 11:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjDQJH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 05:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjDQJHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 05:07:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082074EDE;
        Mon, 17 Apr 2023 02:07:05 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33H8cEBW023826;
        Mon, 17 Apr 2023 09:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XVnJ7cMxpaLuIIrKdWZwV4tyoYGz5nYFcMU9B7y59eo=;
 b=tJtS1cOoFfBrh76ctfnsFJkTyp8nj3BRLrg8Ngf4++thokg54neqIHHmItxiO8OqFjfc
 0CmRIYoF4r3a3nPMZmX5nuHGWc9+BQU19xiWJLDYYCCQmYL4qKHIOifYKX3ea/LOMX42
 0izkeRI3gPLAnxJwjgPaj9i23TDc9aJwq+cqgD/kObNu5AReEJ8V6FLcZQSyT7bGFXxE
 L2Ba2iDoVXdHtugrgVggUSAuuDTN9qu4cMJowLEtpFnU5ijO/PF+ZcjNLvhFFIWZ/Cd1
 6bkBd+pycVeeshIzSjWpTYm1qziatLvAWj9gaixCLwPzgdfTvKGKILJzArUBg9RPKM2L CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q12s5rkhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 09:07:00 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33H8cVU6025072;
        Mon, 17 Apr 2023 09:07:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q12s5rkgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 09:07:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33H2kYSt014903;
        Mon, 17 Apr 2023 09:06:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pykj68yuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 09:06:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33H96qwI12124854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Apr 2023 09:06:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BF8020049;
        Mon, 17 Apr 2023 09:06:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9EE20043;
        Mon, 17 Apr 2023 09:06:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.177.111])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 17 Apr 2023 09:06:51 +0000 (GMT)
Message-ID: <ea529fc34e7b4b3b28097fb53e65928c249f6a88.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Improve stack traces that
 contain an interrupt frame
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 17 Apr 2023 11:06:51 +0200
In-Reply-To: <168171822413.10491.11548053616048775653@t14-nrb>
References: <20230405123508.854034-1-nsg@linux.ibm.com>
         <168171822413.10491.11548053616048775653@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7lsubMXY8e6RUtsfKIR8MeXt3NME3ysm
X-Proofpoint-GUID: 5Naw9RMl9h_VWGXSSy2Z52cSwlq1R_ML
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-17_04,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=835 adultscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304170073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-04-17 at 09:57 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-04-05 14:35:08)
> > When we encounter an unexpected interrupt we print a stack trace.
> > While we can identify the interrupting instruction via the old psw,
> > we don't really have a way to identify callers further up the stack,
> > since we rely on the s390x elf abi calling convention to perform the
> > backtrace. An interrupt is not a call, so there are no guarantees about
> > the contents of the stack and return address registers.
> > If we get lucky their content is as we need it or valid for a previous
> > callee in which case we print one wrong caller and then proceed with th=
e
> > correct ones.
>=20
> I did not think too much about it, so it might not work, but how about a
> seperate interrupt stack?
>=20
> Then, we could print the interrupt stack trace (which should be correct) =
and -
> with a warning as you suggest - the maybe incorrect regular stack trace.

Not sure I'm getting the point. Do you want an implementation that doesn't =
have
the weirdness of using a frame with a special symbol to warn?
We only output a bunch of caller addresses and pretty_print_stacks.py forma=
ts that
into a readable stack trace. So by having the special symbol frame there ar=
e no
changes needed to that script, but it certainly would be possible do it dif=
ferently,
e.g. output "STACK: dead beef WARN 0 ffff" and have the script
print the warning if it sees a WARN.
