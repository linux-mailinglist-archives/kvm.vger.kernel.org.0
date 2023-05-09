Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C476FCA13
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 17:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbjEIPSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 11:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbjEIPS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 11:18:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C2E4EDB;
        Tue,  9 May 2023 08:18:20 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349F7Txq016026;
        Tue, 9 May 2023 15:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yvxgSm4F0OLa7CL2/XDs6iTGpXSrzQlxD40fAI6Cf+8=;
 b=Y2WAWKZ+ML/k3x6vCkfpZ8qxrR/i0v7wCTrXiVqH00L+y1ZANptbMvPDPNSrJT/m3Cm2
 UUTUR0NGS57/I/wLg1wHO61FL53A+uT3bZ5ZpGqcw4Ak5lkgRYV46Is6l5OMWZT+/6c+
 NR/QJvNx13SLu2z84Nb+5NfoUosHbnajwApeGGEmvKBV+7UYjT4QabZb9WKy5CmqYuUm
 NkfMy0XKqhFZmOSebQLPYlHGzINqrwVARWnV0HT8x1Lo2g0oMSjodHAmfBhyxSVRBXo0
 oDwlMa1MH13HaccdFoWj0wO6Q+FOKMjYV4zNYrpDNKgwOHjXOBXKxzped7RcEwMBngPM oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrbas12a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:18:19 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349F7VOl016171;
        Tue, 9 May 2023 15:18:19 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrbas102-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:18:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 349BrrrR031277;
        Tue, 9 May 2023 15:18:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qf7e0re5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:18:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349FIDuh52822456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 15:18:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16EC32004B;
        Tue,  9 May 2023 15:18:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA922004E;
        Tue,  9 May 2023 15:18:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 15:18:12 +0000 (GMT)
Date:   Tue, 9 May 2023 17:18:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] lib: s390x: mmu: fix conflicting
 types for get_dat_entry
Message-ID: <20230509171811.0c22a6f5@p-imbrenda>
In-Reply-To: <20230508102426.130768-1-nrb@linux.ibm.com>
References: <20230508102426.130768-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: llM5qnc0pOpSu-YYC7KXcVg7Y_AN8OKP
X-Proofpoint-ORIG-GUID: MaIaGzcmb44fE6iJrQVSR6wzZFXGO84d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  8 May 2023 12:24:26 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> This causes compilation to fail with GCC 13:
>=20
> gcc -std=3Dgnu99 -ffreestanding -I/kut/lib -I/kut/lib/s390x -Ilib -O2 -ma=
rch=3DzEC12 -mbackchain -fno-delete-null-pointer-checks -g -MMD -MF lib/s39=
0x/.mmu.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-bo=
dy -Wuninitialized -Wignored-qualifiers -Wno-missing-braces -Werror  -fomit=
-frame-pointer  -fno-stack-protector    -Wno-frame-address   -fno-pic  -no-=
pie  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wo=
ld-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototyp=
es -I/kut/lib -I/kut/lib/s390x -Ilib  -c -o lib/s390x/mmu.o lib/s390x/mmu.c
> lib/s390x/mmu.c:132:7: error: conflicting types for =E2=80=98get_dat_entr=
y=E2=80=99 due to enum/integer mismatch; have =E2=80=98void *(pgd_t *, void=
 *, enum pgt_level)=E2=80=99 [-Werror=3Denum-int-mismatch]
>   132 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level l=
evel)
>       |       ^~~~~~~~~~~~~
> In file included from lib/s390x/mmu.c:16:
> lib/s390x/mmu.h:96:7: note: previous declaration of =E2=80=98get_dat_entr=
y=E2=80=99 with type =E2=80=98void *(pgd_t *, void *, unsigned int)=E2=80=99
>    96 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int lev=
el);
>       |       ^~~~~~~~~~~~~
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/mmu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index 15f88e4f424e..dadc2e600f9a 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -93,6 +93,6 @@ static inline void unprotect_page(void *vaddr, unsigned=
 long prot)
>  	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
>  }
> =20
> -void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
> +void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level);
> =20
>  #endif /* _ASMS390X_MMU_H_ */

