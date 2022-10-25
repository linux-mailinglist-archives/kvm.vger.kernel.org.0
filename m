Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4860C653
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiJYIVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiJYIVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:21:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEE01011BB;
        Tue, 25 Oct 2022 01:21:36 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P8FNtD023302;
        Tue, 25 Oct 2022 08:21:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=jR7Y3G7wnhwchaurS9O0Zg2UMKW0DwoOHxekFtSLqMk=;
 b=ErhUd8Vyyc70E9ix2+fS6UKckmK5qcGZCp/rUCJ/gmdy/xTlFXnVWWzI6B5X+5GBAv+w
 ky8xHBeOROUga5bt3El4zMfO/oDe7djm8Wl5Q+9j8cDef39yMDGkTsQAfJnU/f7Adj1x
 d6uNV2qIaOO6Sco6M2efimBHmXXfK6Xp6WQIRfvTBnncZn2N+xhP4T68ojnWOoOrr0vc
 U1zwE7QiqDLE2r9MTZBAZqNE8M6VkOdz4WBBnJty5pjicN7WnIsbhtT32X3cjZbDuDTt
 P6KdSIGLZSoonLzhohW//6iagdCd3L2jmLeHZycIgtf7qCUlGwkl53obF7vkNbwaKHmi Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kec4p85ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:21:36 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29P8FS4i023509;
        Tue, 25 Oct 2022 08:21:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kec4p85g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:21:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P8KsU6020961;
        Tue, 25 Oct 2022 08:21:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kc7sj518b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:21:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P8GHnT30474640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 08:16:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E832FA405D;
        Tue, 25 Oct 2022 08:21:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB0A8A4040;
        Tue, 25 Oct 2022 08:21:29 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.54.69])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 08:21:29 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6dec3e0e-4b77-ffe9-533f-207606e327c4@linux.ibm.com>
References: <20221024160237.33912-1-nrb@linux.ibm.com> <6dec3e0e-4b77-ffe9-533f-207606e327c4@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [v1] KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Message-ID: <166668608958.9899.746645726790124193@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 25 Oct 2022 10:21:29 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _aoLQZPOKqSYEAJl36rHQtCeeiwxSjI6
X-Proofpoint-GUID: 1PzNzOfYG6a-dl1Ckb8BWqu1lRkLk8mV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Christian Borntraeger (2022-10-25 08:37:21)
[...]
> > diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> > index 94138f8f0c1c..c6a10ff46d58 100644
[...]
> > @@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vs=
ie_page *vsie_page,
> >               WARN_ON_ONCE(rc);
> >               return 1;
> >       }
> > -     vsie_page->scb_o =3D (struct kvm_s390_sie_block *) hpa;
> > +     vsie_page->scb_o =3D (struct kvm_s390_sie_block *)phys_to_virt(hp=
a);
>=20
> Do we still need the cast here? phys_to_virt should return a void * and t=
he assignment should succeed.

Yes, right. Fixed in v2.
