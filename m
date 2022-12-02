Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0556404DD
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiLBKk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiLBKkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:40:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D83CEFA6
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:40:01 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B297rig023771
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 10:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=tV22aHPpaXBSKW1YZ9lGDgmccSgpeW1qpMQqYmJA3zM=;
 b=C7j3UdiujnLVrJM6G6435wuZ4Nmbeloq6yXpFv6IrlhUWPGeoyWPoIhJCrtqePWRT6xk
 FB8X6XeFMRA9vENVsUMcfWWEDsyCG4CUjK+ISEvuZI+vxN7vs/LyuTmKgpadNkIdZNTN
 D70Kbs+D8urWdPxC5gDxIDvRriPoqzbsV3jVeu0Nf2zRt+7zS+9Qk8ltZqhYjPFqN3d6
 EIoFsbTFiVHKYmqM8Le17nHE7bjTstaAd2rDkw/dy2g63m6SX+1tye0PKylZm5N9gLJ2
 ju6umIrGZu0QPe330KLrBJiU6BI9AkEsAVpQjGUkVVcGH0i4Gji5wrdU5ac/NzhhpK6O Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7ce4d65h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:40:00 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2AMmKw031770
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 10:40:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7ce4d652-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 10:40:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2AaOle015292;
        Fri, 2 Dec 2022 10:39:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2j10u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 10:39:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2AdtnS64487910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 10:39:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 107B1A405B;
        Fri,  2 Dec 2022 10:39:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E80B5A4054;
        Fri,  2 Dec 2022 10:39:54 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.23.75])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 10:39:54 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com> <20221201084642.3747014-2-nrb@linux.ibm.com> <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related functions
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <166997759426.186408.182395619403215562@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Fri, 02 Dec 2022 11:39:54 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9JWSQzH-B5TTVvt0pYp3QtvGfnjclBFp
X-Proofpoint-GUID: kK9Cj44zPeAA8yvZpfGTQJ9ecBOoFRZ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-12-02 10:03:22)
> On 12/1/22 09:46, Nico Boehr wrote:
> > Upcoming changes will add a test which is very similar to the existing
> > skey migration test. To reduce code duplication, move the common
> > functions to a library which can be re-used by both tests.
> >=20
>=20
> NACK
>=20
> We're not putting test specific code into the library.

What do you mean by "test specific"? After all, it is used by two tests now=
, possibly more in the future.=20

Any alternative suggestions?
