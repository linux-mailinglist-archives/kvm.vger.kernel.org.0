Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6781A67C614
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 09:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjAZIl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 03:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbjAZIlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 03:41:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC1A268A;
        Thu, 26 Jan 2023 00:41:20 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q8F7HL018861;
        Thu, 26 Jan 2023 08:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : to : from : message-id : date; s=pp1;
 bh=GDEOnVu+COxV2PclfIdsMMQdNLKRdvrb3EzBbHP/KJI=;
 b=CRD2N6Q1ZowdIKHMRV/lAuchV00JsvvqzI+Ve9fPo33oQ+Cmxyd9Ru7a1JX2KyH2Qa6R
 8BYPHhLbN87e5/EG+J0iMMHNI420WmRoxvg1aQR4onQgetFZD5NGTd7QoEtcVb/pKJ7z
 XyKtq0s7NIey64WKwFh9oEh4UzzsiLfCLQeh9QEn6oPcLfU/6rpWYGpLMfmYsoczzWqF
 V6UNyyxhnBrqqkrFmlegESaYe8bh36aWKJN5B8a3kZm6TGwRS+QuJ+9cYlnaEiJPjpxB
 5UxG7UK/7mtzW655WbOg2Fp/YRg8XiMqTsapQ+NuD9QeKe9donT1fjg00nknrJEi2bmK hw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbnu8ggd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 08:41:19 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30PFbgIo025273;
        Thu, 26 Jan 2023 08:41:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3n87p6ce5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 08:41:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30Q8fDt344827120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 08:41:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51FC220043;
        Thu, 26 Jan 2023 08:41:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25DFB20040;
        Thu, 26 Jan 2023 08:41:13 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.83.223])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Jan 2023 08:41:13 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2ef9a5df-cd05-8f27-f8ee-4c03f4c43d0d@linux.ibm.com>
References: <20230120075406.101436-1-nrb@linux.ibm.com> <2ef9a5df-cd05-8f27-f8ee-4c03f4c43d0d@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] KVM: s390: disable migration mode when dirty tracking is disabled
To:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <167472247246.63544.9612120960891768862@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 26 Jan 2023 09:41:12 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Td0nCmKhCaDqbswadxp-xyTFX_v1O_YG
X-Proofpoint-ORIG-GUID: Td0nCmKhCaDqbswadxp-xyTFX_v1O_YG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_02,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 mlxlogscore=860 mlxscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301260081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-01-25 14:55:59)
> On 1/20/23 08:54, Nico Boehr wrote:
> > Migration mode is a VM attribute which enables tracking of changes in
> > storage attributes (PGSTE). It assumes dirty tracking is enabled on all
> > memslots to keep a dirty bitmap of pages with changed storage attribute=
s.
> >=20
> > When enabling migration mode, we currently check that dirty tracking is
> > enabled for all memslots. However, userspace can disable dirty tracking
> > without disabling migration mode.
> >=20
> > Since migration mode is pointless with dirty tracking disabled, disable
> > migration mode whenever userspace disables dirty tracking on any slot.
>=20
> Will userspace be able to handle the sudden -EINVAL rcs on=20
> KVM_S390_GET_CMMA_BITS and KVM_S390_SET_CMMA_BITS?

QEMU has proper error handling on the GET_CMMA_BITS code path and will not
attempt GET_CMMA_BITS after it disabled dirty tracking. So yes, userspace c=
an
handle this fine. In addition, as mentioned in the commit, it was never all=
owed
to have migration mode without dirty tracking. It was checked when migration
mode is enabled, just wasn't enforced when dirty tracking went off. The
alternative would be to refuse disabling dirty tracking when migration mode=
 is
on; and that would _really_ break userspace.

Or we just leave migration mode on and check on every emulation/ioctl that a
dirty bitmap is still there, which would change absolutely nothing about the
return value of GET_CMMA_BITS.

Or we allocate the dirty bitmap for storage attributes independent of the d=
irty
bitmap for pages, which increases memory usage and makes this patch quite a=
 bit
more complex, risking that we break more than what is already broken.

This approach really seems like the sane option to me.

For SET_CMMA_BIT, nothing changes.

> I.e. what allows us to simply turn it off without the userspace knowing=20
> about it?
>=20
> >=20
> > Also update the documentation to clarify that dirty tracking must be
> > enabled when enabling migration mode, which is already enforced by the
> > code in kvm_s390_vm_start_migration().
> >=20
> > To disable migration mode, slots_lock should be held, which is taken
> > in kvm_set_memory_region() and thus held in
> > kvm_arch_prepare_memory_region().
> >=20
> > Restructure the prepare code a bit so all the sanity checking is done
> > before disabling migration mode. This ensures migration mode isn't
> > disabled when some sanity check fails.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migrati=
on mode")
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   Documentation/virt/kvm/devices/vm.rst |  4 +++
> >   arch/s390/kvm/kvm-s390.c              | 41 ++++++++++++++++++---------
> >   2 files changed, 32 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt=
/kvm/devices/vm.rst
> > index 60acc39e0e93..147efec626e5 100644
> > --- a/Documentation/virt/kvm/devices/vm.rst
> > +++ b/Documentation/virt/kvm/devices/vm.rst
> > @@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed f=
or PGSTE migration.
> >   Setting this attribute when migration mode is already active will have
> >   no effects.
> >  =20
> > +Dirty tracking must be enabled on all memslots, else -EINVAL is return=
ed. When
> > +dirty tracking is disabled on any memslot, migration mode is automatic=
ally
> > +stopped.
>=20
> Do we also need to add a warning to the CMMA IOCTLs?

No, it is already documented there:

> This ioctl can fail with [...] > -EINVAL if KVM_S390_CMMA_PEEK is not set
> but migration mode was not enabled

[...]
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index e4890e04b210..4785f002cd93 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -5628,28 +5628,43 @@ int kvm_arch_prepare_memory_region(struct kvm *=
kvm,
> >                                  enum kvm_mr_change change)
> >   {
> >       gpa_t size;
> > +     int rc;
>=20
> Not sure why you added rc even though it doesn't need to be used.

You prefer a line which is 100 chars wide over a new variable? OK fine for =
me.
