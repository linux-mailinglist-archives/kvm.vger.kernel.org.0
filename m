Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3043375EE0C
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjGXImx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjGXImo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:42:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEEA1B0;
        Mon, 24 Jul 2023 01:42:40 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O8ciXG008251;
        Mon, 24 Jul 2023 08:42:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Tl3gZDNEYEdaaWPNDlvcc/ynd3f2Kaa18xX8M0dcUCs=;
 b=fWHdsvFvy9bcpo9EMsZBCHLMb8CUxBz/5powdiPN2aMmfFXdHjDfBpxh4japBh2/yAfl
 05tx9OB5gja1/Fg9SzXVFxow8+K+SffokMGdWm+dnigVt0tSzhSUZ+ZNj+qa2L5gJ08k
 Ez0LOluo2Efc4pX+0Y5rKNpXscuxGps2nLIzNcHoSweqKXaO6aRTNgInbjp3n/e6HMr2
 TWLuu8IGb1MBsSPy5jOE55PfHBI68TMLZWDVxOTNAcK90vWzw9x71R1tvyzQBWHsOz13
 Ufhgk+ZhYtYaj7DUhw5XKuvzjL3b308G1g9PRKPH2Aw/b2V4nrhDcYpdKsA1vvgFfmd0 yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1na5sd3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 08:42:39 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O8dmQs015789;
        Mon, 24 Jul 2023 08:42:38 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1na5sd3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 08:42:38 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O8AocI014374;
        Mon, 24 Jul 2023 08:42:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stxhw8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 08:42:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O8gUSD41025910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 08:42:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71B872004B;
        Mon, 24 Jul 2023 08:42:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2DD320040;
        Mon, 24 Jul 2023 08:42:29 +0000 (GMT)
Received: from [9.171.11.212] (unknown [9.171.11.212])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 08:42:29 +0000 (GMT)
Message-ID: <5394773f1d872f086625439cc515c50d2374a161.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/6] KVM: s390: interrupt: Fix single-stepping into
 interrupt handlers
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
Date:   Mon, 24 Jul 2023 10:42:29 +0200
In-Reply-To: <af7be3a9-816c-95dc-22a7-cf62fe245e24@redhat.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
         <20230721120046.2262291-2-iii@linux.ibm.com>
         <af7be3a9-816c-95dc-22a7-cf62fe245e24@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lH8mSE8-vi8w9qjBzkIvWsWq2c-CVSe-
X-Proofpoint-GUID: BR_enPOzDeuT2q3BI4IzaoEzZFpnBdDf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxlogscore=974 bulkscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-07-24 at 10:22 +0200, David Hildenbrand wrote:
> On 21.07.23 13:57, Ilya Leoshkevich wrote:
> > After single-stepping an instruction that generates an interrupt,
> > GDB
> > ends up on the second instruction of the respective interrupt
> > handler.
> >=20
> > The reason is that vcpu_pre_run() manually delivers the interrupt,
> > and
> > then __vcpu_run() runs the first handler instruction using the
> > CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the second
> > handler
> > instruction.
> >=20
> > Fix by delaying the KVM_SINGLESTEP exit until after the manual
> > interrupt delivery.
> >=20
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > ---
> > =C2=A0 arch/s390/kvm/interrupt.c | 10 ++++++++++
> > =C2=A0 arch/s390/kvm/kvm-s390.c=C2=A0 |=C2=A0 4 ++--
> > =C2=A0 2 files changed, 12 insertions(+), 2 deletions(-)

[...]
>=20

> Can we add a comment like
>=20
> /*
> =C2=A0 * We delivered at least one interrupt and modified the PC. Force a
> =C2=A0 * singlestep event now.
> =C2=A0 */

Ok, will do.

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (delivered && guestdbg_ss=
tep_enabled(vcpu)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0struct kvm_debug_exit_arch *debug_exit =3D &vcpu-
> > >run->debug.arch;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0debug_exit->addr =3D vcpu->arch.sie_block->gpsw.addr;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0debug_exit->type =3D KVM_SINGLESTEP;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0vcpu->guest_debug |=3D KVM_GUESTDBG_EXIT_PENDING;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>=20
> I do wonder if we, instead, want to do this whenever we modify the
> PSW.
>=20
> That way we could catch any PC changes and only have to add checks
> for=20
> guestdbg_exit_pending().

Wouldn't this break a corner case where the first instruction of the
interrupt handler causes the same interrupt?

> But this is simpler and should work as well.
>=20
> Acked-by: David Hildenbrand <david@redhat.com>
