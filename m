Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619E252894B
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbiEPPzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiEPPzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:55:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FA7BC9;
        Mon, 16 May 2022 08:55:42 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GFJq6Y005103;
        Mon, 16 May 2022 15:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=t0ClClYMkC/iTWfan5duQAMMKjqUnZwjHAs7zWUBZSk=;
 b=eZlhNt/9v+LWvA6VpAUqGC1tq+Kucbn7n5VPqMPOHKThUwExB1023+JORnvbJ8KcuIls
 17aZoBY9yHzMx3jOprrEEISMKN6rii2d6CF89EHWxHgrocZF32Q4pZtVfLXJWmXXXr57
 Rr8D3C13Tm6al8oyxGqtBwIYm165ztRwhEVLrBt/kzyl6c/VeYg8bRBj/Cu86EsHF015
 NtYPbg9H6wDOzfn0b/Xff4qqP9qyYcxJUx45UTDBhqOL2gXElITFrzOM4kYG0r/vTMyI
 10Jt/9NtHyy1cwz8dHq6wTBiPnPuc4kesusS7nbVbAQhAZu9Pwfvy+Kq8KHZ76F1TSge Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3s5arq7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:55:41 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GFNf9p017257;
        Mon, 16 May 2022 15:55:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3s5arq76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:55:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GFcHP1011961;
        Mon, 16 May 2022 15:55:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429axtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:55:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GFta1036962736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 15:55:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D1914C050;
        Mon, 16 May 2022 15:55:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1C904C040;
        Mon, 16 May 2022 15:55:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.224])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 15:55:35 +0000 (GMT)
Date:   Mon, 16 May 2022 17:55:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 01/19] KVM: s390: pv: leak the topmost page table
 when destroy fails
Message-ID: <20220516175533.4bf3dd93@p-imbrenda>
In-Reply-To: <560068a1e89c2ceec0d544fcc62fa3f95d390182.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-2-imbrenda@linux.ibm.com>
        <560068a1e89c2ceec0d544fcc62fa3f95d390182.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NdHOyIzm-ngimXbtZNM6EmZZ8_2dNMtF
X-Proofpoint-GUID: xFKmkhYpDwSeRdCE-aPd4fPxVtAFBupF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 09:22:09 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Thu, 2022-04-14 at 10:02 +0200, Claudio Imbrenda wrote:
>=20
> [...]
> > +/**
> > + * s390_replace_asce - Try to replace the current ASCE of a gmap
> > with
> > + * another equivalent one.
> > + * @gmap the gmap
> > + *
> > + * If the allocation of the new top level page table fails, the ASCE
> > is not
> > + * replaced.
> > + * In any case, the old ASCE is always removed from the list.
> > Therefore the
> > + * caller has to make sure to save a pointer to it beforehands,
> > unless an
> > + * intentional leak is intended.
> > + */
> > +int s390_replace_asce(struct gmap *gmap)
> > +{
> >  =20
> [...]
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Set new table origin whil=
e preserving existing ASCE
> > control bits */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0asce =3D (gmap->asce & ~_ASC=
E_ORIGIN) | __pa(table);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WRITE_ONCE(gmap->asce, asce)=
; =20
>=20
> Can someone concurrently touch the control bits?

should not happen, nobody is using the ASCE while we replace it

moreover, all callers of s390_replace_asce hold kvm->lock, as do all
functions changing the ASCE
