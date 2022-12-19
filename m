Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF0C65103B
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 17:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiLSQWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 11:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiLSQWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 11:22:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E56F1;
        Mon, 19 Dec 2022 08:22:39 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJGC4mS015106;
        Mon, 19 Dec 2022 16:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/MlesHWmSmCvX8Cum6kIB419EK9KYfGxSMx1WSEvsJo=;
 b=kWqzbpJcbxl1sRb0LDAwhwLyPojKhOfhwqPBtSyXTGtlimHzkUDzYgFP9S4OTwQFgnKk
 knlk8IJ/wKjH0R8y7rLipSw1TbE7PiQEZfN9+XT34Ysqc9mhvn1GjfqjJczKhd2tYyg0
 d1NbNszRXrRTOnYA125HP2qjcD7mnsKVEcXpkaCAkqrEYM/2pMvROBpog6UACkh6Lo6C
 r7KhH9OOFn1RkCkWsiu8B9fM5qICIvzNa8J8fL+8oU8EhZR8sAwAOgi6moitjlsAuxwf
 jEfiAyBKUv8MhiF5Hjhb31EMKf/RGMnXzRI4pvL2XVL9H8I+6VDbT4XUXBGe+PjOK2Bj kA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mju8wrd5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:22:39 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJF7sjx026638;
        Mon, 19 Dec 2022 16:22:38 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3mh6yvj09s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:22:38 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJGMaRj60096882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:22:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B8DA58053;
        Mon, 19 Dec 2022 16:22:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1816F58059;
        Mon, 19 Dec 2022 16:22:35 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 16:22:34 +0000 (GMT)
Message-ID: <61827ce18008642d556ca899179fb6216a079939.camel@linux.ibm.com>
Subject: Re: [PATCH v1 07/16] vfio/ccw: remove unnecessary malloc alignment
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 19 Dec 2022 11:22:34 -0500
In-Reply-To: <f814a82c-f1a6-4e90-4898-290dbbc73770@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
         <20221121214056.1187700-8-farman@linux.ibm.com>
         <f814a82c-f1a6-4e90-4898-290dbbc73770@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bNRCGqM8eo_A2BjvsjWpDgszt2HN-SAO
X-Proofpoint-GUID: bNRCGqM8eo_A2BjvsjWpDgszt2HN-SAO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190142
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-16 at 15:10 -0500, Matthew Rosato wrote:
> On 11/21/22 4:40 PM, Eric Farman wrote:
> > Everything about this allocation is harder than necessary,
> > since the memory allocation is already aligned to our needs.
> > Break them apart for readability, instead of doing the
> > funky artithmetic.
> >=20
> > Of the structures that are involved, only ch_ccw needs the
> > GFP_DMA flag, so the others can be allocated without it.
> >=20
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> > =C2=A0drivers/s390/cio/vfio_ccw_cp.c | 39 ++++++++++++++++++-----------=
-
> > ----
> > =C2=A01 file changed, 21 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/drivers/s390/cio/vfio_ccw_cp.c
> > b/drivers/s390/cio/vfio_ccw_cp.c
> > index d41d94cecdf8..4b6b5f9dc92d 100644
> > --- a/drivers/s390/cio/vfio_ccw_cp.c
> > +++ b/drivers/s390/cio/vfio_ccw_cp.c
> > @@ -311,40 +311,41 @@ static inline int is_tic_within_range(struct
> > ccw1 *ccw, u32 head, int len)
> > =C2=A0static struct ccwchain *ccwchain_alloc(struct channel_program *cp=
,
> > int len)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ccwchain *chain;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void *data;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size_t size;
> > -
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Make ccw address aligned =
to 8. */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size =3D ((sizeof(*chain) + =
7L) & -8L) +
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0sizeof(*chain->ch_ccw) * len +
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0sizeof(*chain->ch_pa) * len;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain =3D kzalloc(size, GFP_=
DMA | GFP_KERNEL);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain =3D kzalloc(sizeof(*ch=
ain), GFP_KERNEL);
>=20
> I suppose you could consider a WARN_ONCE here if one of these
> kzalloc'd addresses has something in the low-order 3 bits; would
> probably make it more obvious if for some reason the alignment
> guarantee was broken vs some status after-the-fact in the IRB.=C2=A0 But
> as per our discussion off-list I think that can only happen if
> ARCH_KMALLOC_MINALIGN were to change.

Yeah, maybe, but the "status after-the-fact" is a program check that
would be generated by the channel, just as would be done if the ORB was
located in a similarly-weird location (which we don't check for
either). Since this is all mainline paths, I don't think it makes sense
to re-check all those possible permutations here.

(And, for what it's worth, it's not this allocation that matters, but
rather the one that gets stuffed into the ORB below [1])

>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!chain)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0data =3D (u8 *)chain + ((siz=
eof(*chain) + 7L) & -8L);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_ccw =3D (struct cc=
w1 *)data;
> > -
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0data =3D (u8 *)(chain->ch_cc=
w) + sizeof(*chain->ch_ccw) *
> > len;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_pa =3D (struct pag=
e_array *)data;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_ccw =3D kcalloc(le=
n, sizeof(*chain->ch_ccw),
> > GFP_DMA | GFP_KERNEL);

[1]

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!chain->ch_ccw)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0goto out_err;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_len =3D len;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_pa =3D kcalloc(len=
, sizeof(*chain->ch_pa),
> > GFP_KERNEL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!chain->ch_pa)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0goto out_err;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_add_tail(&chain->n=
ext, &cp->ccwchain_list);
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return chain;
> > +
> > +out_err:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(chain->ch_ccw);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(chain);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static void ccwchain_free(struct ccwchain *chain)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_del(&chain->next);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(chain->ch_pa);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(chain->ch_ccw);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(chain);
> > =C2=A0}
> > =C2=A0
> > =C2=A0/* Free resource for a ccw that allocated memory for its cda. */
> > =C2=A0static void ccwchain_cda_free(struct ccwchain *chain, int idx)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ccw1 *ccw =3D chain->=
ch_ccw + idx;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ccw1 *ccw =3D &chain-=
>ch_ccw[idx];
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ccw_is_tic(ccw))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
> > @@ -443,6 +444,8 @@ static int ccwchain_handle_ccw(u32 cda, struct
> > channel_program *cp)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain =3D ccwchain_allo=
c(cp, len);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!chain)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_len =3D len;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain->ch_iova =3D cda;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Copy the actual CCWs=
 into the new chain */
> > @@ -464,7 +467,7 @@ static int ccwchain_loop_tic(struct ccwchain
> > *chain, struct channel_program *cp)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i, ret;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < chain=
->ch_len; i++) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0tic =3D chain->ch_ccw + i;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0tic =3D &chain->ch_ccw[i];
>=20
> These don't seem equivalent...=C2=A0 Before at each iteration you'd offse=
t
> tic by i bytes, now you're treating i as an index of 8B ccw1 structs,
> so it seems like this went from tic =3D x + i to tic =3D x + (8 * i)?=C2=
=A0
> Was the old code broken or am I missing something?=20

I think the latter. :) The old code did one allocation measured in
bytes, stored it in chain, and then calculated locations within that
for ch_ccw and ch_pa, cast to the respective pointer types. (See the
reference [1] above.)

So any use of "i" was an index into the pointer types and thus already
a "8 * i" addition from your example. My intention here was to remove
the pseudo-assembly above, and changed these along the way as I was un-
tangling everything. Looking at the resulting assembly before/after,
these hunks don't end up changing at all so I'll back these changes
back out. Especially since...

>=20
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ccw_is_tic(tic))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
continue;
> > @@ -739,8 +742,8 @@ int cp_prefetch(struct channel_program *cp)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_for_each_entry(cha=
in, &cp->ccwchain_list, next) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0len =3D chain->ch_len;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0for (idx =3D 0; idx < len; idx++) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ccw =
=3D chain->ch_ccw + idx;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pa =3D=
 chain->ch_pa + idx;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ccw =
=3D &chain->ch_ccw[idx];
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pa =3D=
 &chain->ch_pa[idx];
>=20
> Same sort of question re: ch_pa

...this prompted me to notice that I didn't change the users of "chain-
>ch_pa + i" when calling page_array_unpin_free(), so now we have both
flavors which isn't ideal.

BEFORE:
                        ccw =3D chain->ch_ccw + idx;
                        pa =3D chain->ch_pa + idx;
    1536:       eb 3b 00 01 00 0d       sllg    %r3,%r11,1
    153c:       b9 08 00 3b             agr     %r3,%r11
    1540:       eb 33 00 03 00 0d       sllg    %r3,%r3,3
    1546:       e3 30 80 28 00 08       ag      %r3,40(%r8)
                        ccw =3D chain->ch_ccw + idx;
    154c:       eb 2b 00 03 00 0d       sllg    %r2,%r11,3
    1552:       e3 20 80 10 00 08       ag      %r2,16(%r8)
AFTER
                        ccw =3D &chain->ch_ccw[idx];
                        pa =3D &chain->ch_pa[idx];
    15be:       eb 3b 00 01 00 0d       sllg    %r3,%r11,1
    15c4:       b9 08 00 3b             agr     %r3,%r11
    15c8:       eb 33 00 03 00 0d       sllg    %r3,%r3,3
    15ce:       e3 30 80 28 00 08       ag      %r3,40(%r8)
                        ccw =3D &chain->ch_ccw[idx];
    15d4:       eb 2b 00 03 00 0d       sllg    %r2,%r11,3
    15da:       e3 20 80 10 00 08       ag      %r2,16(%r8)


>=20
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
ret =3D ccwchain_fetch_one(ccw, pa, cp);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
if (ret)
>=20

