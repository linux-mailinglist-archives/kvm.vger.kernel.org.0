Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7F47C7FCB
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 10:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjJMIRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 04:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjJMIRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 04:17:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F0CB8;
        Fri, 13 Oct 2023 01:17:13 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39D8EXBO024101;
        Fri, 13 Oct 2023 08:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=YMss3qvH5n5i3zv6eQXuaH84AzGxuWuOERg/VATRoR4=;
 b=bZCwLj7M8YEMkGE93Ap82mJyQ5B8PsXDHhmNjE29NQnmxX4Mpi0SAEDz+Hy+Z98yiL1B
 w22oLh5/MwgJRjbBsJjofJ9WyN9DXFl1aGD14POQbkqAUjBBeQRfLHtgXJR09rjEgFQZ
 GIg6Q9albpqDAqOUt6y2Rz5P4d2MfefjmwD5OMvbI2dcZneUdlU20MdBfnA91YqStVvm
 HWg/rtFj5BCLIAiYc4WXkelYf5+nh30N3QO4qC2xA/CvZsb53ADxalMkpnyzbSO92lYZ
 cqk0A2Ap/FOZ3EHSHHWe7qgGLDK4vmnS15RBxeW5/1CW7FjnkG553MEyxcq7th1DkTJj JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tq275r3rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Oct 2023 08:17:02 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39D8F4UW025800;
        Fri, 13 Oct 2023 08:17:01 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tq275r3r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Oct 2023 08:17:01 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39D5Kkp8026153;
        Fri, 13 Oct 2023 08:17:01 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tpt54tjxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Oct 2023 08:17:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39D8Gw0822544980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 08:16:58 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 464CE20043;
        Fri, 13 Oct 2023 08:16:58 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02A5E20040;
        Fri, 13 Oct 2023 08:16:58 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.48.43])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 13 Oct 2023 08:16:57 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-5-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-5-nsg@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 4/9] s390x: topology: Don't use non unique message
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Message-ID: <169718501727.15841.5127785267238990595@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 13 Oct 2023 10:16:57 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: l9RxvhO_MokNU0BY24TDKa0UtLUD6vnE
X-Proofpoint-GUID: PpgITw4z9rD2165P_LQl1amYazvP1lx-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_03,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxscore=0 adultscore=0
 mlxlogscore=858 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:27)
> When we test something, i.e. do a report() we want unique messages,
> otherwise, from the test output, it will appear as if the same test was
> run multiple times, possible with different PASS/FAIL values.
>=20
> Convert some reports that don't actually test anything topology specific
> into asserts.
> Refine the report message for others.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

There is still the "TLE: reserved bits 0000000000000000" message which may
be duplicate, but I think you fix that in a later patch.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
