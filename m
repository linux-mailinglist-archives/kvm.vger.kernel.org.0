Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E184792688
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbjIEQE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353695AbjIEHS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 03:18:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1630BCC2;
        Tue,  5 Sep 2023 00:18:53 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38577eX8014936;
        Tue, 5 Sep 2023 07:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=NVrP+y+EzWtZ/uhKnUhSlxsATRFuK9IFx4I3cEpahTI=;
 b=Hs4OJwvYXceRi3R6Wb6sGZylMvoKrjQYdiuestPdsSbT7vC/qclx6Mssq0n/KaI/m60w
 M5aBidjQwTblxRn2UOFZb4hsUQfKA44P0o7We5UsepOKvJNrHPJUHBkRwuUAvztHIjgP
 75BT+ICSe5auobRp7pGOhcQYJBzxE0cOVplfrOONRdyG82/hKaTqB6KmqyKNWWiBvzH8
 Ty7Th9e4ZH1nCTmwuyq+2eRjI0czWRv//g0VtPs2iN7khtPxrxY8puwRyIb99BGBbaKU
 aWEgWXydgRNL70O/jUOE4aFLXL9N4iVgUhVkxEUiIPaxsTvjucAkyoWeOwu+rfm7rKGO ew== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3swnpvjdmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 07:18:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3857ELjv026826;
        Tue, 5 Sep 2023 07:18:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3svgcn8n6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 07:18:51 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3857Ilkl12059214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Sep 2023 07:18:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3871F20043;
        Tue,  5 Sep 2023 07:18:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C91B20040;
        Tue,  5 Sep 2023 07:18:47 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.21.157])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  5 Sep 2023 07:18:46 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1f5636f6-18f3-442a-4a60-62440d4907af@linux.ibm.com>
References: <20230901105823.3973928-1-mimu@linux.ibm.com> <169381110909.97137.16554568711338641072@t14-nrb> <1f5636f6-18f3-442a-4a60-62440d4907af@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Michael Mueller <mimu@linux.vnet.ibm.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Subject: Re: [PATCH v4] KVM: s390: fix gisa destroy operation might lead to cpu stalls
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169389832663.97137.6664097784907615369@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 05 Sep 2023 09:18:46 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N1dIeidzk2_SddhXYJ5HFqJTIL_dUtpQ
X-Proofpoint-ORIG-GUID: N1dIeidzk2_SddhXYJ5HFqJTIL_dUtpQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_05,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=556
 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Michael Mueller (2023-09-04 16:11:26)
>=20
>=20
> On 04.09.23 09:05, Nico Boehr wrote:
> > Quoting Michael Mueller (2023-09-01 12:58:23)
> > [...]
> >> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> >> index 9bd0a873f3b1..96450e5c4b6f 100644
> >> --- a/arch/s390/kvm/interrupt.c
> >> +++ b/arch/s390/kvm/interrupt.c
> > [...]
> >>   static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32=
 gisc)
> >>   {
> >>          set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
> >> @@ -3202,11 +3197,12 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
> >>  =20
> >>          if (!gi->origin)
> >>                  return;
> >> -       if (gi->alert.mask)
> >> -               KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
> >> -                         kvm, gi->alert.mask);
> >> -       while (gisa_in_alert_list(gi->origin))
> >> -               cpu_relax();
> >> +       WARN(gi->alert.mask !=3D 0x00,
> >> +            "unexpected non zero alert.mask 0x%02x",
> >> +            gi->alert.mask);
> >> +       gi->alert.mask =3D 0x00;
> >> +       if (gisa_set_iam(gi->origin, gi->alert.mask))
> >> +               process_gib_alert_list();
> >=20
> > I am not an expert for the GISA, so excuse my possibly stupid question:
> > process_gib_alert_list() starts the timer. So can gisa_vcpu_kicker()
> > already be running before we reach hrtimer_cancel() below? Is this fine?
>=20
> You are right, It cannnot be running in that situation because=20
> gisa_vcpu_kicker() has returned with HRTIMER_NORESTART and no vcpus are=20
> defined anymore.
>=20
> There is another case when the gisa specific timer is started not only=20
> in the process_gib_alert() case but also when a vcpu of the guest owning =

> the gisa is put into wait state, see kvm_s390_handle_wait(). Thus yes,=20
> it could be running already in that situation. I remember having seen=20
> this situation when I write the gisa/gib code. But that's case in=20
> process_gib_alert_list()
>=20
> It does not hurt to have the hrtimer_cancel() here but I don't want to=20
> add a change to this patch. Eventually a new one.

Ah OK, thanks for the explanation. hrtimer_cancel() also waits until the
timer function has completed. LGTM then.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
