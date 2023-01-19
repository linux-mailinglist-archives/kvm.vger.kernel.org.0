Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2FA673776
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjASLwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjASLwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:52:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AE91ABEF
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:52:38 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JAosCp019465
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=F9ULwSTreMvIivJ6DIQUMEmGYlOuOThq0NLGhXj//kU=;
 b=E9a9uDj8v9xDP6LPEY0siuB2HzVdlfb3r4T52jLVCvNHXR41muqOxcaHKFufY9fw/0vu
 rvxseRyHr3eY7jsg9FjHF4kSx1HTqu7ChY1EdQRzOLP46aamxmCOBBL/zt+eEX1ZCwcM
 Z1YgCTeBekAOQknLpIh8kGveYHuwHeTxYoFYJz3R16uNl9rMMNVRYj+O/Kve7yufJaO1
 pi53/i1GpHhEU1BNm1ob+tsHE1O1uQAtU+JiKKbXaWmGoyR3Uce4b2bL1ZxszWkCFZWL
 NRxOI+bo4+U4K1AJ2VsT7pGPYL7S4N8Ei4/2dKnh3c4TMhA7SOZWslP84eEI/21pAmmI Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n74f89d4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:52:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBeDPS025640
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:52:37 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n74f89d44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:52:37 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J1BZNA017966;
        Thu, 19 Jan 2023 11:52:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16mttx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:52:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBqV7J47186356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:52:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 551FE2004B;
        Thu, 19 Jan 2023 11:52:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C582A20043;
        Thu, 19 Jan 2023 11:52:30 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.91.27])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 19 Jan 2023 11:52:30 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: use C pre-processor for
 linker script generation
In-Reply-To: <20230119114045.34553-6-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
 <20230119114045.34553-6-mhartmay@linux.ibm.com>
Date:   Thu, 19 Jan 2023 12:52:30 +0100
Message-ID: <87sfg6vj0h.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CLnxCSOkD3KoMz2fNlIKLNfWjlOWPDKV
X-Proofpoint-ORIG-GUID: _aqFJ-kfz79QEoofxmCku1pA4R-xo_2R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=823 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Hartmayer <mhartmay@linux.ibm.com> writes:

> Use the C pre-processor for the linker script generation. For example,
> this enables us the use of constants in the "linker scripts" `*.lds.S`.
>

Sorry, I forgot to change the commit message (Claudio=E2=80=99s comment):

=E2=80=9Cs390x: use preprocessor for linker script generation

The old `.lds` linker scripts are renamed to `.lds.S` and the actual
.lds` scripts are generated by the assembler preprocessor. This change
allows us to use constants defined by macros in the `.lds.S` files.=E2=80=9D

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
