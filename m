Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE126D1C9B
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 11:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjCaJhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 05:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjCaJhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 05:37:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24661D863
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:37:08 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V7qa3j005510
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=JNDC7vN8YQ6hraoqqLVOblAcZNN6ylvaKiHu9r8JCLw=;
 b=pcC0nqGieMs9hemylCW7WsiR5RklRaviYEgTvW7tCvhTrXKPs9UX05awINLBLNJxdB8N
 Q3Xe96At55ZAuTJ9xOXm9JvfATa0UEbbF2TxoM3efL7U478iRU9GdMvKWkA9YZ7iB/Bd
 hDUgm9i/CYMm/bNtSWw+5hMRXHB4HbAy2ssFyVG/lJlh5nN8DFxfuL0zSidvdsnJWO8f
 UlK/wUF26GlUFyCX0rmeQ3r5c+fRRQ/0h9/EndBr3IBFk3x/Es188vjIOyI6CjmFQiRd
 KRmHhKYmPjqTrc8ZM0hGlKacbs4hXDg5V10qx/gIgDPwMBZ8HDIhJVy72476MmKoFewP 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnugytbum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:36:54 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V8aOTe006412
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:36:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnugytbtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 09:36:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32ULi5g3005448;
        Fri, 31 Mar 2023 09:36:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6pn4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 09:36:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V9amhu23331512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 09:36:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F1F02004B;
        Fri, 31 Mar 2023 09:36:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CC8020040;
        Fri, 31 Mar 2023 09:36:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.12.80])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 09:36:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230331082709.35955-1-mhartmay@linux.ibm.com>
References: <168024782639.521366.8153497247119888695@t14-nrb> <20230331082709.35955-1-mhartmay@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4] s390x/Makefile: refactor CPPFLAGS
Message-ID: <168025540813.521366.8353031165543177822@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 31 Mar 2023 11:36:48 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jcfG3NHZ9E0lBJeO22nG_dy9vSNtItVL
X-Proofpoint-GUID: OEftPYwK1vGm5Pr4pJyv9gXLIeeIqv-0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310075
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Marc Hartmayer (2023-03-31 10:27:09)
> This change makes it easier to reuse them. While at it, add a comment
> why the `lib` include path is required.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  s390x/Makefile | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 71e6563bbb61..06720aace828 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -63,9 +63,14 @@ test_cases: $(tests)
>  test_cases_binary: $(tests_binary)
>  test_cases_pv: $(tests_pv_binary)
> =20
> +INCLUDE_PATHS =3D $(SRCDIR)/lib $(SRCDIR)/lib/s390x
> +# Include generated header files (e.g. in case of out-of-source builds)
> +INCLUDE_PATHS +=3D lib=20

Do you mind if I fix this up during picking?

ERROR: trailing whitespace
#35: FILE: s390x/Makefile:68:
+INCLUDE_PATHS +=3D lib $
