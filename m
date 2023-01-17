Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B151366E88D
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 22:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjAQViH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 16:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjAQVey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 16:34:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B765F4DCCB
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:58:30 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HJQFI0002556;
        Tue, 17 Jan 2023 19:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Apa+RLI5AIUlbQGPDiuO1LW7cPjZPExNp+EC46G6sRQ=;
 b=K55NvgHxkKzCmRh9NAaeHlx9ZXQ6oSmULSEAlgdueeMD+cfBxtjAsSbYZUOGLPIFzyU0
 SltjT0BOd3w5bB2rEpE0yDO71DIK4Zcs4SisrJMNaHZWyMm/OXgYcTP0MMxl3R/QWFyf
 H3+8XXVVD/9umq2ukcQJpnHuVZdW35Ax33Q+6AyMq+dK1A5mU1XKTAtQyU6M2XTuxVny
 mI4gqzvUM+5tDD86431UOdiY77ssTQAefU2E2TYSgXs9vH8YD3ICx7LaWyLJxu43/oLE
 vnRPBgHDEBaNvEzA2Lko67aM+zhY6jtfUf1bslYNBby9jyjWtE7DXsWV6NUfgQVpgweY pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n61ty8kfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 19:58:22 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HJUNpd015511;
        Tue, 17 Jan 2023 19:58:22 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n61ty8kf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 19:58:21 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HAwjps016548;
        Tue, 17 Jan 2023 19:58:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16k5gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 19:58:19 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HJwF9O47317394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 19:58:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 894252004B;
        Tue, 17 Jan 2023 19:58:15 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2381C20040;
        Tue, 17 Jan 2023 19:58:15 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.180.94])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 19:58:15 +0000 (GMT)
Message-ID: <0103e627a835013e00a9c55d46348e76b94366e9.camel@linux.ibm.com>
Subject: Re: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested
 topology entries
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Tue, 17 Jan 2023 20:58:15 +0100
In-Reply-To: <22aff83d-4379-e4f0-9826-33f986ddeec7@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-5-pmorel@linux.ibm.com>
         <e65bce5b-977c-ed19-9562-3af8ee8e9fba@redhat.com>
         <22aff83d-4379-e4f0-9826-33f986ddeec7@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OJ7MDHxD0Koil2ixbWftLc8OOaXFBM_G
X-Proofpoint-GUID: 9GAHTua5RR4KG8xd242-hY5X4l3q0p7C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170156
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-01-17 at 18:36 +0100, Pierre Morel wrote:
>=20
> On 1/11/23 09:57, Thomas Huth wrote:
> > On 05/01/2023 15.53, Pierre Morel wrote:
> > > The maximum nested topology entries is used by the guest to know
> > > how many nested topology are available on the machine.
> > >=20
> > > Currently, SCLP READ SCP INFO reports MNEST =3D 0, which is the
> > > equivalent of reporting the default value of 2.
> > > Let's use the default SCLP value of 2 and increase this value in the
> > > future patches implementing higher levels.
> >=20
> > I'm confused ... so does a SCLP value of 2 mean a MNEST level of 4 ?
>=20
> Sorry, I forgot to change this.
> MNEST =3D 0 means no MNEST support and only socket is supported so it is=
=20
> like MNEST =3D 2.
> MNEST !=3D 0 set the maximum nested level and correct values may be 2,3 o=
r 4.
> But this setting to 4 should already have been done in previous patch=20
> where we introduced the books and drawers.

I think setting it to 4 here is fine/preferable, since 2 is the default unl=
ess
you tell the guest that more are available, which you do in this patch.
It's only the commit description that is confusing.

>=20
> I change the commit message with:
> ---
> s390x/sclp: reporting the maximum nested topology entries
>=20
> The maximum nested topology entries is used by the guest to know
> how many nested topology are available on the machine.
>=20
> Let's return this information to the guest.
> ---
>=20
> >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > > =C2=A0 include/hw/s390x/sclp.h | 5 +++--
> > > =C2=A0 hw/s390x/sclp.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 4 ++++
> > > =C2=A0 2 files changed, 7 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
> > > index 712fd68123..4ce852473c 100644
> > > --- a/include/hw/s390x/sclp.h
> > > +++ b/include/hw/s390x/sclp.h
> > > @@ -112,12 +112,13 @@ typedef struct CPUEntry {
> > > =C2=A0 } QEMU_PACKED CPUEntry;
> > > =C2=A0 #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET=C2=A0=C2=A0=C2=A0=
=C2=A0 128
> > > -#define SCLP_READ_SCP_INFO_MNEST=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2
> > > +#define SCLP_READ_SCP_INFO_MNEST=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4
> >=20
> > ... since you update it to 4 here.
>=20
> Yes, in fact this should be set in the previous patch already to 4.
> So I will do that.
>=20
> >=20
> > > =C2=A0 typedef struct ReadInfo {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SCCBHeader h;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t rnmax;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint8_t rnsize;
> > > -=C2=A0=C2=A0=C2=A0 uint8_t=C2=A0 _reserved1[16 - 11];=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /* 11-15 */
> > > +=C2=A0=C2=A0=C2=A0 uint8_t=C2=A0 _reserved1[15 - 11];=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /* 11-14 */
> > > +=C2=A0=C2=A0=C2=A0 uint8_t=C2=A0 stsi_parm;=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 15-16 */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t entries_cpu;=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* 16=
-17 */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t offset_cpu;=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 18-19 */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint8_t=C2=A0 _reserved2[24 - 20];=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* 20-23 */
> > > diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
> > > index eff74479f4..07e3cb4cac 100644
> > > --- a/hw/s390x/sclp.c
> > > +++ b/hw/s390x/sclp.c
> > > @@ -20,6 +20,7 @@
> > > =C2=A0 #include "hw/s390x/event-facility.h"
> > > =C2=A0 #include "hw/s390x/s390-pci-bus.h"
> > > =C2=A0 #include "hw/s390x/ipl.h"
> > > +#include "hw/s390x/cpu-topology.h"
> > > =C2=A0 static inline SCLPDevice *get_sclp_device(void)
> > > =C2=A0 {
> > > @@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB=
=20
> > > *sccb)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* CPU information */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prepare_cpu_entries(machine, entries_s=
tart, &cpu_count);
> > > +=C2=A0=C2=A0=C2=A0 if (s390_has_topology()) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read_info->stsi_parm =3D =
SCLP_READ_SCP_INFO_MNEST;
> >=20
> > This seems to be in contradiction to what you've said in the commit=20
> > description - you set it to 4 and not to 2.
>=20
> Yes, I change the commit message.
>=20
> Thanks.
>=20
> Regards,
> Pierre
>=20

