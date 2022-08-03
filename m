Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423D45886D9
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 07:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbiHCFlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 01:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiHCFlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 01:41:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A32F550A8
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 22:41:49 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2735SrZI028659
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 05:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=LyCE+3zsj8ebl+/2SYVtylg+zfCBK962s66FGf8pISY=;
 b=RlRvQeQKDQ+hZSFBiYqEPuF1V8CvzQg2lb8OWYiG5eewMFEogezpQOWWHbeEeLFPPsNs
 OXQehymW1hDgBCzE+gos/cLilL3bKSZz2fLd6fPhrc/97dMu3yUHxJlkpsvQcKP3SBfE
 RLOdSqMMfLorTFdqn0eHcONmRGToMbFW1nHwuQ7HkdZypMqnh8/j7DpYQ/Fp5yNFXt5c
 1UYAC/l6ueBkzOhmJbIbnsn6saUxiXW7AYEAVj9xAhxLJmYsscLuT04RsYVXFXydpHcq
 c+Mg2ySH/8VhDwbOYfdXcgGwF7zb3ZFlD4nu/9aJF5b8UIa6UNPwwSHJ4YX9TaDTbS25 HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqjwfre94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 05:41:49 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2735TKIo029221
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 05:41:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqjwfre81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 05:41:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2735b03D024731;
        Wed, 3 Aug 2022 05:41:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3hmv98uamj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 05:41:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2735fw6h32047574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 05:41:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B815F4C046;
        Wed,  3 Aug 2022 05:41:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9518E4C044;
        Wed,  3 Aug 2022 05:41:42 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.22.238])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 05:41:42 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220802181420.7444039f@p-imbrenda>
References: <20220802145102.128841-1-nrb@linux.ibm.com> <20220802181420.7444039f@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: verify EQBS/SQBS is unavailable
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165950530239.11298.11374325126507764794@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Wed, 03 Aug 2022 07:41:42 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X8B0up-ejsRe4Ni8ksdlWrcQ1Mrnjo6h
X-Proofpoint-ORIG-GUID: LYiHTe5HWc-VWp1qouSwBLtY8zB85BOG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxlogscore=873 spamscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 phishscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-02 18:14:20)
[...]
> > diff --git a/s390x/intercept.c b/s390x/intercept.c
> > index 9e826b6c79ad..73b06b5fc6e8 100644
> > --- a/s390x/intercept.c
> > +++ b/s390x/intercept.c
> > @@ -197,6 +197,55 @@ static void test_diag318(void)
> > =20
> >  }
> > =20
> > +static inline int sqbs(u64 token)
> > +{
> > +     unsigned long _token =3D token;
> > +     int cc;
> > +
> > +     asm volatile(
> > +             "       lgr 1,%[token]\n"
> > +             "       .insn   rsy,0xeb000000008a,0,0,0(0)\n"
> > +             "       ipm %[cc]\n"
> > +             "       srl %[cc],28\n"
> > +             : [cc] "=3D&d" (cc)
>=20
> do you really need all those extra things?
>=20
> can't you just reduce this whole function to:
>=20
> asm volatile("  .insn   rsy,0xeb000000008a,0,0,0(0)\n");
>=20
> in the end we don't care what happens, we only want it to fail with an
> operation exception
>=20
> (ok maybe you need to add some clobbers to make sure things work as
> they should in case the instruction is actually executed)

I don't mind changing that, will do.

[...]
> > +static void test_qbs(void)
> > +{
> > +     report_prefix_push("sqbs");
> > +     expect_pgm_int();
> > +     sqbs(0xffffffdeadbeefULL);
> > +     check_pgm_int_code(PGM_INT_CODE_OPERATION);
> > +     report_prefix_pop();
> > +
> > +     report_prefix_push("eqbs");
> > +     expect_pgm_int();
> > +     eqbs(0xffffffdeadbeefULL);
> > +     check_pgm_int_code(PGM_INT_CODE_OPERATION);
> > +     report_prefix_pop();
> > +}
>=20
> we expect those to fail only in qemu, right?
> maybe this should be fenced and skip the tests when running in other
> environments

OK will do.
