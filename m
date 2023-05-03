Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBD6F5C42
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjECQwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjECQwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:52:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B857B7292
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 09:52:31 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343GodBv026998;
        Wed, 3 May 2023 16:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dQ884//3MIN5TZFslQ5hPzbr/FOPMz2sIzKYatfvBhU=;
 b=lE1Sn5NkN5+/Qxvl8e+kky8ZwGTWAVnqgYJq1GwwSj1uSRaScY9oymdfY7XQwuXLlGpU
 08mBevZLFKowR+jq1DXBaZzyU/Nek+vUfni10OygHirWjBJizW4LUXOQ0L1xJpg8BevN
 fC0zyfzA65VVwgzCI/z+aNwuZFO88l7Pnq9/ZZamIsYJfr3wPl9UeIMtfF8eATMQYEUI
 4tSutka3fohSXcdhUVel9rQtLjeOTFEwg/mPgrwLMTM+czHrpbdxEdB1CinqLpIHT/vR
 g8C7m0zFYaMo9jyHU5Gr8SkAaU+Sz7sTHKUHrs2Rc8M0dCkxEJSbSLry5PoGltA4OlUC 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbug702hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 16:52:20 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 343GonNj027788;
        Wed, 3 May 2023 16:52:19 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbug702e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 16:52:19 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 343F8lFL023724;
        Wed, 3 May 2023 16:51:18 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3q8tv7nd5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 16:51:18 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343GpIqg11338432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 16:51:18 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DB9F58052;
        Wed,  3 May 2023 16:51:18 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C5C85805E;
        Wed,  3 May 2023 16:51:17 +0000 (GMT)
Received: from li-a300cfcc-3261-11b2-a85c-fa2d52d0d140.ibm.com (unknown [9.160.23.254])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  3 May 2023 16:51:17 +0000 (GMT)
Message-ID: <cc22183359d107dc0be58b4f9509c8d785313879.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, Carlos Bilbao <carlos.bilbao@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>
Date:   Wed, 03 May 2023 12:51:17 -0400
In-Reply-To: <ZFJTDtMK0QqXK5+E@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
         <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com> <ZFJTDtMK0QqXK5+E@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sj8sxnOtRrj090Qt4mIqkCXtAcVQqs7d
X-Proofpoint-GUID: Wa0JeZMFVsoh0Zf-drserLKROW-Ly5nl
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_11,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=881
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jorg,

On Wed, 2023-05-03 at 14:26 +0200, J=C3=B6rg R=C3=B6del wrote:
>=20
> > =C2=A0 - Are you open to having maintainers outside of SUSE? There is s=
ome
> > =C2=A0=C2=A0=C2=A0 linux-svsm community concern about project governanc=
e and project
> > =C2=A0=C2=A0=C2=A0 priorities and release schedules. This wouldn't have=
 to be AMD even,
> > =C2=A0=C2=A0=C2=A0 but we'd volunteer to help here if desired, but we'd=
 like to foster a
> > =C2=A0=C2=A0=C2=A0 true community model for governance regardless. We'd=
 love to hear
> > =C2=A0=C2=A0=C2=A0 thoughts on this from coconut-svsm folks.
>=20
> Yes, I am definitely willing to make the project more open and move to a
> maintainer-group model, no intention from my side to become a BDFL for
> the project. I just have no clear picture yet how the model should look
> like and how to get there. I will send a separate email to kick-start a
> discussion about that.
>=20

Thanks. I would be happy to collaborate in that discussion.

> > =C2=A0 - On the subject of priorities, the number one priority for the
> > =C2=A0=C2=A0=C2=A0 linux-svsm project has been to quickly achieve produ=
ction quality vTPM
> > =C2=A0=C2=A0=C2=A0 support. The support for this is being actively work=
ed on by
> > =C2=A0=C2=A0=C2=A0 linux-svsm contributors and we'd want to find fastes=
t path towards
> > =C2=A0=C2=A0=C2=A0 getting that redirected into coconut-svsm (possibly =
starting with CPL0
> > =C2=A0=C2=A0=C2=A0 implementation until CPL3 support is available) and =
the project
> > =C2=A0=C2=A0=C2=A0 hardened for a release.=C2=A0 I imagine there will b=
e some competing
> > =C2=A0=C2=A0=C2=A0 priorities from coconut-svsm project currently, so w=
anted to get this
> > =C2=A0=C2=A0=C2=A0 out on the table from the beginning.
>=20
> That has been under discussion for some time, and honestly I think
> the approach taken is the main difference between linux-svsm and
> COCONUT. My position here is, and that comes with a big 'BUT', that I am
> not fundamentally opposed to having a temporary solution for the TPM
> until CPL-3 support is at a point where it can run a TPM module.
>=20
> And here come the 'BUT': Since the goal of having one project is to
> bundle community efforts, I think that the joint efforts are better
> targeted at getting CPL-3 support to a point where it can run modules.
> On that side some input and help is needed, especially to define the
> syscall interface so that it suits the needs of a TPM implementation.
>=20
> It is also not the case that CPL-3 support is out more than a year or
> so. The RamFS is almost ready, as is the archive file inclusion[1]. We
> will move to task management next, the goal is still to have basic
> support ready in 2H2023.
>=20
> [1] https://github.com/coconut-svsm/svsm/pull/27
>=20
> If there is still a strong desire to have COCONUT with a TPM (running at
> CPL-0) before CPL-3 support is usable, then I can live with including
> code for that as a temporary solution. But linking huge amounts of C
> code (like openssl or a tpm lib) into the SVSM rust binary kind of
> contradicts the goals which made us using Rust for project in the first
> place. That is why I only see this as a temporary solution.
>=20
>=20

I think the crypto support requires more design discussion since it is requ=
ired
in multiple places.

The experience I've had adding SVSM-vTPM support is that the SVSM needs cry=
pto
for requesting an attestation report (SNP_GUEST_REQUEST messages sent to the
security processor PSP have to be encrypted with AES_GCM) and the vTPM also
needs crypto for the TPM crypto operations. We could just duplicate the cry=
pto
library, or find a way to share it (e.g. vdso approach).

For the SVSM, it would be rust code talking to the crypto library; for the =
vTPM
it would be the vTPM (most likely an existing C implementation) talking to =
the
crypto library.

Regards,

Claudio

