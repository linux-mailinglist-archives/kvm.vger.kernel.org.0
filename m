Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B62681066
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbjA3ODI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 09:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbjA3OCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 09:02:54 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD57B3B0E7;
        Mon, 30 Jan 2023 06:02:46 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UCWM1j007664;
        Mon, 30 Jan 2023 14:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : cc : from : message-id : date; s=pp1;
 bh=yVh7i4PK4fHQvv7D9ESf+QBk4rtC5xmNe0nBGfUj+yE=;
 b=N6o6Ej5QyHykPiG/nOJ9Dvy7bv1GNxV4b2aGDjJeJfwpjmxCzRxa3pmdZYHprdrd7xS+
 bq4aXL/2OeWfsi0C4MXjf/TaLwWa7rN1bfSEubWNXiBe2CxnTHZxXM4vK8iX6MmMRFgE
 H58HIwpjUR9ALx52kzCuFl+vNN9DxHB8euwNPDLb9HEN42K9n2Joh1Ooi4Jf54dg0jdH
 yQ8bL1me70Cr4g80SC/7EUUNIHVhIc9aoiorNInbVxDKF91NrKb8rCIf9olOsjMQnHuw
 EpDrzYTnrJ7QRR5tjxijn/TVVoOMD0IXnk3TY48KnsMt4JYx5qGRQ2Sb2Mcj6+vXOyHm fw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nedyut65v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 14:02:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30TDgQiN001561;
        Mon, 30 Jan 2023 14:02:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ncvv69nk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 14:02:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30UE2dFX42926544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 14:02:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72AF12004E;
        Mon, 30 Jan 2023 14:02:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D4DB2004D;
        Mon, 30 Jan 2023 14:02:39 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.92.217])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 30 Jan 2023 14:02:39 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6e37979d-45f2-0714-d1ab-673f64cdd872@linux.ibm.com>
References: <20230127140532.230651-1-nrb@linux.ibm.com> <20230127140532.230651-2-nrb@linux.ibm.com> <6e37979d-45f2-0714-d1ab-673f64cdd872@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH v4 1/1] KVM: s390: disable migration mode when dirty tracking is disabled
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <167508735843.11453.11149771785732701137@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 30 Jan 2023 15:02:38 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rTCKJe8idpzqs7EucLVd20ry4ThFsdqX
X-Proofpoint-ORIG-GUID: rTCKJe8idpzqs7EucLVd20ry4ThFsdqX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_12,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=785 malwarescore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301300131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-01-30 10:53:23)
[...]
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 9807b05a1b57..2978acfcafc4 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4537,11 +4537,17 @@ mask is unused.
> >  =20
> >   values points to the userspace buffer where the result will be stored.
> >  =20
> > -This ioctl can fail with -ENOMEM if not enough memory can be allocated=
 to
> > -complete the task, with -ENXIO if CMMA is not enabled, with -EINVAL if
> > -KVM_S390_CMMA_PEEK is not set but migration mode was not enabled, with
> > --EFAULT if the userspace address is invalid or if no page table is
> > -present for the addresses (e.g. when using hugepages).
> > +Errors:
> > +
> > +  =3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +  ENOMEM     not enough memory can be allocated to complete the task
> > +  ENXIO      if CMMA is not enabled
> > +  EINVAL     if KVM_S390_CMMA_PEEK is not set but migration mode was n=
ot enabled
> > +  EINVAL     if KVM_S390_CMMA_PEEK is not set but dirty tracking has b=
een
> > +             disabled (and thus migration mode was automatically disab=
led)
> > +  EFAULT     if the userspace address is invalid or if no page table is
> > +             present for the addresses (e.g. when using hugepages).
> > +  =3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> May I move this to the top?

Sure, please go ahead.
>=20
