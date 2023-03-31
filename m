Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF36D223D
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 16:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbjCaOTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 10:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjCaOTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 10:19:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7FE1FD06
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:19:38 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VE9VJL009018;
        Fri, 31 Mar 2023 14:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=bF2XlH6oOFEhN4EO/KRSBSdcL4jo3QQnxgmrnxzlEUA=;
 b=MqFm7dKiU8OT4GKs2BtCHcnkPr87W0NUQsoxikAZuzAz2VWJ/HGshktvOYLcyb+b+57/
 R+iplx3S7bEfFWqLjFkQNdIPU3BXhlzF/oLde4keyl9YgR44ZYEjAaPu+l6yxRHCI0zC
 K6/F9Jg0Qe6pZMKZPZrjpsbQvdhkIFWbvcgle2MBXf1flIZ3uTQc94nPekgdxSMkXGV/
 FWggtzmQoj4DuyS3kVS4m4vjAd9WvVnpq1ZCOmKhIVUtgJ6eSpEOZzZ3y2Z2EvzRLwK6
 klUgKRAKyddstDNe4oweJwHGtR0w1MJOyB/FSyFiJtXiiXQ7kDpFAKm/7tl0QKC2lkXX Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnwahx6j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 14:19:35 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VECNp8017101;
        Fri, 31 Mar 2023 14:19:34 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnwahx6hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 14:19:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32ULuwFi009365;
        Fri, 31 Mar 2023 14:19:32 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6pt8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 14:19:32 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32VEJTvE20775608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 14:19:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AE982004B;
        Fri, 31 Mar 2023 14:19:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 179DE20049;
        Fri, 31 Mar 2023 14:19:29 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.8.186])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 14:19:29 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <4a757f48-3fc0-4c1a-b401-8a2388b4d94d@redhat.com>
References: <20230331113028.621828-1-nrb@linux.ibm.com> <4a757f48-3fc0-4c1a-b401-8a2388b4d94d@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, andrew.jones@linux.dev,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests GIT PULL 00/14] s390x: new maintainer, refactor linker scripts, tests for misalignments, execute-type instructions and vSIE epdx
Message-ID: <168027236584.521366.16837896312489221810@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 31 Mar 2023 16:19:25 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7JtioaqzWG9-t3GMgL7iJRleR1-K2B9g
X-Proofpoint-GUID: 8JOyUQs6Xf2reraNWIp9eI5_DMNFh6e2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310111
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-03-31 15:17:33)
> On 31/03/2023 13.30, Nico Boehr wrote:
> > Hi Paolo and/or Thomas,
> >=20
> > here comes the first pull request from me. :)
>=20
> Thanks!
>=20
> ... I gave it a try, but I'm hitting a failure in the spec_ex test:
>=20
> $ cat logs/spec_ex.log
> timeout -k 1s --foreground 90s qemu-system-s390x -nodefaults -nographic -=
machine s390-ccw-virtio,accel=3Dkvm -chardev stdio,id=3Dcon0 -device sclpco=
nsole,chardev=3Dcon0 -kernel s390x/spec_ex.elf -smp 1 # -initrd /tmp/tmp.cx=
HP06rT1F
> PASS: specification exception: psw_bit_12_is_1: Program interrupt: expect=
ed(6) =3D=3D received(6)
> PASS: specification exception: short_psw_bit_12_is_0: Program interrupt: =
expected(6) =3D=3D received(6)
> FAIL: specification exception: psw_odd_address: Expected exception due to=
 invalid PSW
> PASS: specification exception: odd_ex_target: did not perform ex with odd=
 target
> PASS: specification exception: odd_ex_target: Program interrupt: expected=
(6) =3D=3D received(6)
> PASS: specification exception: bad_alignment_lqp: Program interrupt: expe=
cted(6) =3D=3D received(6)
> PASS: specification exception: bad_alignment_lrl: Program interrupt: expe=
cted(6) =3D=3D received(6)
> PASS: specification exception: not_even: Program interrupt: expected(6) =
=3D=3D received(6)
> PASS: specification exception during transaction: odd_ex_target: Program =
interrupt: expected(518) =3D=3D received(518)
> PASS: specification exception during transaction: bad_alignment_lqp: Prog=
ram interrupt: expected(518) =3D=3D received(518)
> PASS: specification exception during transaction: bad_alignment_lrl: Prog=
ram interrupt: expected(518) =3D=3D received(518)
> PASS: specification exception during transaction: not_even: Program inter=
rupt: expected(518) =3D=3D received(518)
> SUMMARY: 12 tests, 1 unexpected failures
>=20
> EXIT: STATUS=3D3
>=20
> I'm sure I'm missing something, I just cannot figure it out right
> now (it's Friday afternoon...) - QEMU is the current version from
> the master branch, so I thought that it should contain all the
> recent fixes ... does this psw_odd_address test require a fix in
> the kernel, too? (I'm currently running a RHEL9 kernel)

Thomas, I cannot reproduce this with a QEMU master and 6.3-rc4, so you migh=
t be right that some kernel fix is required.

Since the weekend is calling now, I will take a look at this on Monday.
