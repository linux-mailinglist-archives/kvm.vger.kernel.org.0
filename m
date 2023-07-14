Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAA6753FD9
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 18:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbjGNQbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 12:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbjGNQbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 12:31:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E437271F
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 09:31:10 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EGMCrj025819;
        Fri, 14 Jul 2023 16:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=UE0oINAFvaLyGNgvpbeBssB7BdDIYNx2p0pVjewMrvs=;
 b=PBwOaOqu16tFHfharrMcoRJq9BMT/x0mnfUdZmC8pu1jAgKEtellmHuw4okMhzXXfVJO
 7fpcpXlE80/q3MBC46VrMTyJ+IvxHrbMc/Jd98YKJnxCS08tl5kM+EQCjrFfuvne989R
 8EzYF/2FYdOokN6BHVQj2Z3mkCe5oTpAskmpvqNB+pJw6iqjlo2yI5GNy6bzAuY+URIi
 hvsqCLIw2E0Xx0DzIp3vDA3CpcyrGF0sKHhybxQMNgtQNHfEorbp8FzmTT28THRUGzqO
 nPHsYTMgebDeYF+Fre4Hd4MZs4t9e9y0U4hxb3o+8+FjUOair1TdM8aYM8hA+TNSEvZp rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru9tv078a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 16:30:49 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36EGMfQM026945;
        Fri, 14 Jul 2023 16:30:49 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru9tv0773-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 16:30:49 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36EDTnK3001161;
        Fri, 14 Jul 2023 16:30:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rtpvut4a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 16:30:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36EGUhV430998930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 16:30:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A3F2004B;
        Fri, 14 Jul 2023 16:30:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0CE720040;
        Fri, 14 Jul 2023 16:30:42 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.5.219])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jul 2023 16:30:42 +0000 (GMT)
Message-ID: <dbb17fa6239774d80e697ed771514b345faf5486.camel@linux.ibm.com>
Subject: Re: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement
 tests
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Fri, 14 Jul 2023 18:30:42 +0200
In-Reply-To: <88070b30-36ea-8112-41c4-0d93fc76cf80@redhat.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-17-pmorel@linux.ibm.com>
         <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
         <aa1fbe820f23bc487752ee29ee114f5d4185352a.camel@linux.ibm.com>
         <88070b30-36ea-8112-41c4-0d93fc76cf80@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ypjHKI5PkosHso3lKDRdbnqx-w5ft9Y7
X-Proofpoint-ORIG-GUID: -XF9FtyjybBk5o2JPkYYI3cF_olQVpT_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_07,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-07-12 at 22:11 +0200, Thomas Huth wrote:
> On 12/07/2023 21.37, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-07-05 at 12:22 +0200, Thomas Huth wrote:
> > > On 30/06/2023 11.17, Pierre Morel wrote:
> > > > This test takes care to check the changes on different
> > > > entitlements
> > > > when the guest requests a polarization change.
> > > >=20
> > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > ---
> > > > =C2=A0=C2=A0 tests/avocado/s390_topology.py | 47
> > > > ++++++++++++++++++++++++++++++++++
> > > > =C2=A0=C2=A0 1 file changed, 47 insertions(+)
> > > >=20
> > > > diff --git a/tests/avocado/s390_topology.py
> > > > b/tests/avocado/s390_topology.py
> > > > index 2cf731cb1d..4855e5d7e4 100644
> > > > --- a/tests/avocado/s390_topology.py
> > > > +++ b/tests/avocado/s390_topology.py
> > > > @@ -240,3 +240,50 @@ def test_polarisation(self):
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res =
=3D self.vm.qmp('query-cpu-polarization')
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.a=
ssertEqual(res['return']['polarization'],
> > > > 'horizontal')
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.c=
heck_topology(0, 0, 0, 0, 'medium', False)
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0 def test_entitlement(self):
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 """
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 This test verifies that=
 QEMU modifies the polarization
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 after a guest request.
> > > ...
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(0, =
0, 0, 0, 'low', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(1, =
0, 0, 0, 'medium', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(2, =
1, 0, 0, 'high', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(3, =
1, 0, 0, 'high', False)
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.guest_set_dispatch=
ing('1');
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(0, =
0, 0, 0, 'low', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(1, =
0, 0, 0, 'medium', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(2, =
1, 0, 0, 'high', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(3, =
1, 0, 0, 'high', False)
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.guest_set_dispatch=
ing('0');
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(0, =
0, 0, 0, 'low', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(1, =
0, 0, 0, 'medium', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(2, =
1, 0, 0, 'high', False)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(3, =
1, 0, 0, 'high', False)
> > >=20
> > > Sorry, I think I'm too blind to see it, but what has changed
> > > after
> > > the guest
> > > changed the polarization?
> >=20
> > Nothing, the values are retained, they're just not active.
> > The guest will see a horizontal polarization until it changes back
> > to
> > vertical.
>=20
> But then the comment in front of it ("This test verifies that QEMU=20
> *modifies* the polarization...") does not quite match, does it?

Yeah, it tests that QEMU reports it's own state changed when using
set-cpu-topology.
I think it would be a good idea to get the guests view from the sysfs,
also.

>=20
> =C2=A0 Thomas
>=20
>=20

