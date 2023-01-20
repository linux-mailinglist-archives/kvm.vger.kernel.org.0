Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6672C674F74
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 09:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjATI1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 03:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjATI1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 03:27:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAF810E6
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 00:27:47 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30K8Kwlq021090
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=5ZU4OwP34vgCXekl2YW6L2iyyIk+6BlzAApDlz7pTog=;
 b=OboQtwed9LeKTNHIhXl1Vvf07zDdH0ucMo29d4lBIasALP4Go75f/uqEqjrpky39V7mT
 18isoYOpY0aLHVKYoDef+jO1NWqXHnt3YTvuN0p4Gx4vCoKIvkFJZcywoJyQUeDSXAd8
 /nNhjW05GQyYroS0Zv9snw9MVKNzZGbbM6UWm/KaJlAWeyS4wBfOgLMXSBMpyAJBuExo
 RRynEJREzo7LVmZw14aB5x5HtkWqim1a0WpqvA0wxHpJMZnCcm0T1vlsoiNn7kn1fzFv
 MK0K47iKEGWUvhXhUsH5wArNvUhoIjg7v2eMVhDF9vZiKCy4Y9xq65LyCVovkcIA7fvY bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7qc9r4fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:27:46 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30K8L2dQ021577
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:27:46 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7qc9r4f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 08:27:46 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30K20MsC004582;
        Fri, 20 Jan 2023 08:27:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16dm5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 08:27:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30K8RccV46072186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 08:27:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53B8220049;
        Fri, 20 Jan 2023 08:27:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 342DD20043;
        Fri, 20 Jan 2023 08:27:38 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.19.180])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Jan 2023 08:27:38 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230119114045.34553-2-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com> <20230119114045.34553-2-mhartmay@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/8] .gitignore: ignore `s390x/comm.key` file
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <167420325748.19639.18077815976999309170@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Fri, 20 Jan 2023 09:27:37 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x4--71gMxgnfHpeuumjswOjKM7dBXGEs
X-Proofpoint-GUID: Arb8jDNj37jgark343Xk2807stvh2tBy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_04,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Marc Hartmayer (2023-01-19 12:40:38)
> Ignore the Secure Execution Customer Communication Key file.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

good find, thanks.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
