Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB996620BA
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 09:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjAII4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 03:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbjAII4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 03:56:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7519816497;
        Mon,  9 Jan 2023 00:49:19 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3098ck2w006263;
        Mon, 9 Jan 2023 08:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hWfYjnkAVqvyl4dzq7RgGEw8+A9a4wP90jdKvWZJsp0=;
 b=s2Mjzui3Oy+yWNbw3GSqc6hq6rNTNkbmlg17DekZ+UJNMSpdLCEbBahW7hiCGbK3d3Rs
 64Yez8AYNgiMksWaBdmoqdVL534OlEYT6vpTsUedndyStn99nxrOe6exKPaocdL2L50C
 Ixdmsf+Xgsw6IYNpt37CX9NsDNUZzKxP6PRubhrthShEFw2a/BaXC+kauPF/caNtt+bc
 SOMzN/YhCQTE4BZtC5hjQfOdaCzf+pWVoQ4zfA6u89SuRneIWh4v1M7j6hFdSVXt8BG7
 6KzKYNsb7aCY1athbnGFQTQ5Soy1UFxVe9zNEXyreTjVai3PvCLiT3a/17xourLBpDs5 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjmkyvne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 08:49:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30986p6M009009;
        Mon, 9 Jan 2023 08:49:18 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjmkyvmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 08:49:18 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3096VQZ1023347;
        Mon, 9 Jan 2023 08:49:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3my0c6svfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 08:49:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3098nCSI45547874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 08:49:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5097B20049;
        Mon,  9 Jan 2023 08:49:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA20620043;
        Mon,  9 Jan 2023 08:49:11 +0000 (GMT)
Received: from [9.171.86.101] (unknown [9.171.86.101])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 08:49:11 +0000 (GMT)
Message-ID: <62e9db6daecef9ffc70560ac87ae5be77697ec21.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Christian =?ISO-8859-1?Q?Borntr=E4ger?= 
        <borntraeger@linux.ibm.com>
Date:   Mon, 09 Jan 2023 09:49:11 +0100
In-Reply-To: <Y7hifk0RHT3tlqqW@ziepe.ca>
References: <20230104154202.1152198-1-schnelle@linux.ibm.com>
         <20230104154202.1152198-2-schnelle@linux.ibm.com>
         <20230106102450.2e6c70bb.alex.williamson@redhat.com>
         <Y7hifk0RHT3tlqqW@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NS2XXR9rfFSNbxTjvp9VTWS-nowa3VpZ
X-Proofpoint-ORIG-GUID: 9c4g7Gxt86OM1qVO9vFF_1-O0e_QhhOM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_03,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-01-06 at 14:03 -0400, Jason Gunthorpe wrote:
> On Fri, Jan 06, 2023 at 10:24:50AM -0700, Alex Williamson wrote:
>=20
> > > -	ret =3D iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE=
 * 2,
> > > -			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
> > > -	if (!ret) {
> > > -		size_t unmapped =3D iommu_unmap(domain->domain, 0, PAGE_SIZE);
> > > +	list_for_each_entry(region, regions, list) {
> > > +		if (region->end - region->start < PAGE_SIZE * 2 ||
> > > +				region->start % (PAGE_SIZE*2))
> >=20
> > Maybe this falls into the noise, but we don't care if region->start is
> > aligned to a double page, so long as we can map an aligned double page
> > within the region.  Maybe something like:
>=20
> > 	dma_addr_t start =3D ALIGN(region->start, PAGE_SIZE * 2);
> >=20
> > 	if (start >=3D region->end || (region->end - start < PAGE_SIZE * 2))
> > 		continue;
>=20
> Yeah, that is more technically correct
>=20
> Jason

Makes sense, will incorporate this into v3.

Thanks,
Niklas
