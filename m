Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2D6D5B54
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 10:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjDDI6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 04:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbjDDI6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 04:58:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3449510DE;
        Tue,  4 Apr 2023 01:58:07 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3347uNG4030072;
        Tue, 4 Apr 2023 08:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hUjvb0t7n1d8RFRlvc24uul0qGXRpG2QvzWDM708R3A=;
 b=stcIHghzxa2kkEH14x5U5rJBddZKkfD6V81IrbO+kUxoc1cF95PNjivDnxeSl57CbVri
 fFSrwczs69JLWv7t566TcIUBfL/Pr49JndajA+8GyD81IaF2dg1+HFA0lVqb+r868DeE
 PmmtSd4ptw+qt/ZJwR+B12YsZmZJ6QOy2M+P7tQqGcFY57y3E4OEl1Ztde4JbOvDIttR
 jTJZf1LGQ1BipYMyD2nb0MlXwffHVGiPl5moq2Va6VJfm2QjQwWIcC/lTDXaOxzRzifi
 vx2LO54/FVYrOZzRSCFPiKtW2CXm97Civ4urQULdp4A/gc2S3TH+/7Xb3GX8vJO05/Yk Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prfbytcb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:58:06 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3347uXdI031704;
        Tue, 4 Apr 2023 08:58:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prfbytcae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:58:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342pLYu025987;
        Tue, 4 Apr 2023 08:58:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ppc86ssat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:58:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3348w0K419202676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 08:58:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2A9720040;
        Tue,  4 Apr 2023 08:57:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7B9C2004D;
        Tue,  4 Apr 2023 08:57:59 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.213.1])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 08:57:59 +0000 (GMT)
Message-ID: <94dcda382e095bb562e1e552c7bf44ed22949972.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 3/3] s390x/spec_ex: Add test of
 EXECUTE with odd target address
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 04 Apr 2023 10:57:59 +0200
In-Reply-To: <2e22a705-47c1-53e2-c539-63db5b92f44a@redhat.com>
References: <20230317133253.965010-1-nsg@linux.ibm.com>
         <20230317133253.965010-4-nsg@linux.ibm.com>
         <2e22a705-47c1-53e2-c539-63db5b92f44a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: va8mHPbupkMoD6YkrjfNaxIJqZISWNxA
X-Proofpoint-ORIG-GUID: hQzUQC_DyBDEBwN1tLF4bXJubUxXBdMk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-04-03 at 17:38 +0200, Thomas Huth wrote:
> On 17/03/2023 14.32, Nina Schoetterl-Glausch wrote:
> > The EXECUTE instruction executes the instruction at the given target
> > address. This address must be halfword aligned, otherwise a
> > specification exception occurs.
> > Add a test for this.
> >=20
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >   s390x/spec_ex.c | 25 +++++++++++++++++++++++++
> >   1 file changed, 25 insertions(+)
> >=20
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > index ab023347..b4b9095f 100644
> > --- a/s390x/spec_ex.c
> > +++ b/s390x/spec_ex.c
> > @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
> >   	return 0;
> >   }
> >  =20
> > +static int odd_ex_target(void)
> > +{
> > +	uint64_t pre_target_addr;
> > +	int to =3D 0, from =3D 0x0dd;
> > +
> > +	asm volatile ( ".pushsection .text.ex_odd\n"
> > +		"	.balign	2\n"
> > +		"pre_odd_ex_target:\n"
> > +		"	. =3D . + 1\n"
> > +		"	lr	%[to],%[from]\n"
> > +		"	.popsection\n"
> > +
> > +		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
> > +		"	ex	0,1(%[pre_target_addr])\n"
> > +		: [pre_target_addr] "=3D&a" (pre_target_addr),
> > +		  [to] "+d" (to)
> > +		: [from] "d" (from)
> > +	);
> > +
> > +	assert((pre_target_addr + 1) & 1);
> > +	report(to !=3D from, "did not perform ex with odd target");
> > +	return 0;
> > +}
>=20
>   Hi Nina,
>=20
> FWIW, this fails to compile with Clang v15 here:
>=20
> s390x/spec_ex.c:187:4: error: symbol 'pre_odd_ex_target' is already defin=
ed
>                  "pre_odd_ex_target:\n"
>                   ^
> <inline asm>:3:1: note: instantiated into assembly here
> pre_odd_ex_target:
>=20
> No clue yet why that happens ... but compiling with Clang seems to be bro=
ken=20
> on some other spots, too, so this is not really critical right now ;-)

Thanks, I guess it inlines the function and emits the asm twice.
Interestingly clang cannot load the address of the misaligned_code symbol i=
n C code due to alignement,
so I had to work around that, too.

>=20
>   Thomas
>=20

