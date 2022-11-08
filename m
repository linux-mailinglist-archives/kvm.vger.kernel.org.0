Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72C2621D6C
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiKHUIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 15:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiKHUIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 15:08:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE611D327;
        Tue,  8 Nov 2022 12:08:36 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8JIlF9002751;
        Tue, 8 Nov 2022 20:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=u2PWSQOO6tyqo1D2YZwibcbVCAeC3azCnDDg3eH43nk=;
 b=sEslA1ZijQHFIIf0XM87msiCgOAAujhS1fBVGWFvlbtoiTtjPi7sxSKY3paWS1P4ZqYP
 crIJ87DwvOIHI0WsyEGQe70ygKW07UUNnv6Al76ocCtjsvZeceyIsg/PGK7rW2GNHNCv
 MNj51xs5qbSfzot9SXBPq6ArGiwvc0pXg2mkCWdHXU1IBVtjl2kKBQjv2jqbkMbgdUpY
 33rw94EET5Xxd6haA8gHxTs/MwJuIAAxjroF4gmj+sTg0nNVXTd7lPDe8s8aoEL0N+dI
 Hdyp8Cj8MwDIvqtX9L4a4RFpqG3nMuDiaeFqTWL1pGMMM1pGYJU/IFHz50as9y3DTFaM vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqw5k97t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 20:07:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8Joaro029933;
        Tue, 8 Nov 2022 20:07:23 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqw5k97s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 20:07:23 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8K539J017853;
        Tue, 8 Nov 2022 20:07:22 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3kngmt6x20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 20:07:22 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8K7MuK2032294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 20:07:22 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4F535806D;
        Tue,  8 Nov 2022 20:07:20 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C36E5805A;
        Tue,  8 Nov 2022 20:07:19 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 20:07:19 +0000 (GMT)
Message-ID: <fbaa1f1d0510d51045120d896ac8b4aa01dd333f.camel@linux.ibm.com>
Subject: Re: S390 testing for IOMMUFD
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Date:   Tue, 08 Nov 2022 15:07:19 -0500
In-Reply-To: <Y2qvYJRsv+mO8FSM@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
         <Y2msLjrbvG5XPeNm@nvidia.com>
         <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
         <Y2pffsdWwnfjrTbv@nvidia.com>
         <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
         <Y2ppq9oeKZzk5F6h@nvidia.com>
         <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
         <Y2qvYJRsv+mO8FSM@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WeNucM9j2s-2iJ1wm61mvNhqirrQiUGb
X-Proofpoint-ORIG-GUID: GS_F6gHOofHAPELNco4d7HSfOFnXDF5U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 bulkscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211080129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-08 at 15:34 -0400, Jason Gunthorpe wrote:
> On Tue, Nov 08, 2022 at 10:29:33AM -0500, Eric Farman wrote:
> > On Tue, 2022-11-08 at 10:37 -0400, Jason Gunthorpe wrote:
> > > On Tue, Nov 08, 2022 at 09:19:17AM -0500, Eric Farman wrote:
> > > > On Tue, 2022-11-08 at 09:54 -0400, Jason Gunthorpe wrote:
> > > > > On Tue, Nov 08, 2022 at 08:50:53AM -0500, Matthew Rosato
> > > > > wrote:
> > > > >=20
> > > > > > FWIW, vfio-pci via s390 is working fine so far, though I'll
> > > > > > put
> > > > > > it
> > > > > > through more paces over the next few weeks and report if I
> > > > > > find
> > > > > > anything.
> > > > >=20
> > > > > OK great
> > > > >=20
> > > > > > As far as mdev drivers...=C2=A0=20
> > > > > >=20
> > > > > > -ccw: Sounds like Eric is already aware there is an issue
> > > > > > and
> > > > > > is
> > > > > > investigating (I see errors as well).
> > > >=20
> > > > I -think- the problem for -ccw is that the new vfio_pin_pages
> > > > requires
> > > > the input addresses to be page-aligned, and while most of ours
> > > > are,
> > > > the
> > > > first one in any given transaction may not be. We never
> > > > bothered to
> > > > mask off the addresses since it was handled for us, and we
> > > > needed
> > > > to
> > > > keep the offsets anyway.
> > > >=20
> > > > By happenstance, I had some code that would do the masking
> > > > ourselves
> > > > (for an unrelated reason); I'll see if I can get that fit on
> > > > top
> > > > and if
> > > > it helps matters. After coffee.
> > >=20
> > > Oh, yes, that makes alot of sense.
> > >=20
> > > Ah, if that is how VFIO worked we could match it like below:
> >=20
> > That's a start. The pin appears to have worked, but the unpin fails
> > at
> > the bottom of iommufd_access_unpin_pages:
> >=20
> > WARN_ON(!iopt_area_contig_done(&iter));
>=20
> This seems like a different bug, probably a ccw driver bug. The
> WARN_ON is designed to detect cases where the driver is unpinning an
> IOVA range that is not exactly what it pinned. The pin side already
> does this validation, so if it fails it means pin/unpin did not have
> identical iova ranges. Some debugging prints should confirm this.
>=20
> I looked at CCW and came up with the following two things, can you
> look at them and finish them off? It will probably help.

I happen to already have patch 1 in a series I've been working on in
parallel with the private/parent split. I haven't forgotten it. :)

Patch 2 doesn't address the above symptoms, but a lot of that code is
getting reworked by the aforementioned series so I didn't spend a lot
of time studying your suggestion. And as I type this I see you just
sent a new patch, let me go try that...
