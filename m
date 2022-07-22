Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CD157E0A8
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 13:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiGVLIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 07:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiGVLIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 07:08:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466D0BDA05
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 04:08:34 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M9i0ms018158
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=gnJrKYpRWoECkZfpMxQNq7BAHGUHoAot6mmNZndFSdk=;
 b=bk/C8WTT2ioJVHIkyAEEebyytln/kqpJX5vF06NWHvCsO6+VmTQTyowPncf7Kkf/6jrh
 Lc37nW9ehofXFDRQEjT4qGoiVxXsTLHj9jUEs51JmlN2X1qd23nW1N/VcTViqX2IkVWX
 beHx8TkU8lutHuUi0j6PwYpy+qreW+OooIoV8ztqXj1Th1O1J95HI/oJdp7U8YfzFoKE
 ju0rvFNSbo4kYObazqFU5ubqXaAmR1Cgh7Jec/0BaW8eXrTS4Pj/vZVv6MNu9TDNQjnO
 l1mAJ2g5ins8hHCUntmG1FAvkYXNRxiAfNF/faBxyUvUaJljwEPXWX+Fh7HncnwJy8b/ jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfsh7abdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:08:33 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M9kXXa000754
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:08:33 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfsh7abcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 11:08:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26MB8BgR024222;
        Fri, 22 Jul 2022 11:08:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3hbmkht91q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 11:08:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26MB8duS31261016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 11:08:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3921FAE04D;
        Fri, 22 Jul 2022 11:08:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17405AE057;
        Fri, 22 Jul 2022 11:08:27 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.80.183])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 11:08:27 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <facc8a71-954a-4b4d-5d63-d07b69125a80@linux.ibm.com>
References: <20220722072004.800792-1-nrb@linux.ibm.com> <20220722072004.800792-4-nrb@linux.ibm.com> <facc8a71-954a-4b4d-5d63-d07b69125a80@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: smp: add tests for calls in wait state
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Message-ID: <165848810687.161082.2344144216592218763@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 22 Jul 2022 13:08:26 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N4U4xasVoFXdNI0VACQYelN_yDAF10-3
X-Proofpoint-GUID: ET6aHIYemN0vO-2R9BziILpEl2B2aa-W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_02,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-22 10:30:46)
> On 7/22/22 09:20, Nico Boehr wrote:
> > Under PV, SIGP ecall requires some special handling by the hypervisor
> > when the receiving CPU is in enabled wait. Hence, we should have
> > coverage for the various SIGP call orders when the receiving CPU is in
> > enabled wait.
>=20
> When the SIGP interpretation facility is in use a SIGP external call to=20
> a waiting CPU will result in an exit of the calling cpu. For non-pv=20
> guests it's a code 56 (partial execution) exit otherwise its a code 108=20
> (secure instruction notification) exit. Those exits are handled=20
> differently from a normal SIGP instruction intercept that happens=20
> without interpretation and hence need to be tested.

Changed.

> >=20
> > The ecall test currently fails under PV due to a KVM bug under
> > investigation.
>=20
> That shouldn't be true anymore

Yeah, it's not yet in mainline, but is soon gonna be. I will remove this.

> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   s390x/smp.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 75 insertions(+)
> >=20
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 683b0e618a48..eed7aa3564de 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
> > @@ -347,6 +347,80 @@ static void test_calls(void)
> >       }
> >   }
> >  =20
> > +static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
> > +{
> > +     /* leave wait after returning */
>=20
> Clear wait bit so we don't immediately wait again after the fixup

Changed.

>=20
> > +     lowcore.ext_old_psw.mask &=3D ~PSW_MASK_WAIT;
> > +
> > +     stack->crs[0] &=3D ~current_sigp_call_case->cr0_bit;
>=20
> You need a mask but have a bit, no?
>=20
> ~BIT(current_sigp_call_case->cr0_bit)

Oopsie, thanks, good find.

This reminds me the ctl_clear_bit() I added in call_in_wait_received() is c=
ompletely useless, since I handle it here. So, I will remove it there as we=
ll.

[...]
> > +static void test_calls_in_wait(void)
> > +{
> > +     int i;
> > +     struct psw psw;
> > +
> > +     report_prefix_push("psw wait");
> > +     for (i =3D 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
> > +             current_sigp_call_case =3D &cases_sigp_call[i];
> > +
> > +             report_prefix_push(current_sigp_call_case->name);
> > +             if (!current_sigp_call_case->supports_pv && uv_os_is_gues=
t()) {
> > +                     report_skip("Not supported under PV");
> > +                     report_prefix_pop();
> > +                     continue;
> > +             }
> > +
> /* Let the secondary CPU setup the external mask and the external=20
> interrupt cleanup function */

Changed.
