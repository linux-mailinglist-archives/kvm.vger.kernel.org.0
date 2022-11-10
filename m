Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0DB624448
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 15:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiKJO3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 09:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiKJO24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 09:28:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB932A415;
        Thu, 10 Nov 2022 06:28:55 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AADF8c5018964;
        Thu, 10 Nov 2022 14:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cQiqgBQrdHZc6YQIYzpdwluHu6IRtl7nBe8wtqk6DLQ=;
 b=jgsfDPzwe009UYYxgL6IrtxkPkKV59I0FPYWM7YUfXdGpXu8iSQkJrFEezC4xnRG+N9A
 gLZegi07N+GTZgOQVhH6CcFrcxECS5AUUttDB2WyQ/0vGv5a7t0L6J8N3kXBbzFm7l0P
 PrZk0tU2FTMh3shfHZSEty1RODg8QLpjjMQF1hv3UYIXR5IVNDCLbiySiQbit2d+1kzw
 csV/UBtN3eRScooTYwYsGn30fF49FnGp8EJskkY8VGV6NV3PLgX7Rtj6HUjtqurh7aR8
 PQJ+c9c/kX2V8BbuE9O8UDoK2k3ifjF21S2DC+UvGI46wS/1aXTxAQ0T+U3m6mrx0M/D sQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ks212a6t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 14:28:55 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AAEN9Fk002508;
        Thu, 10 Nov 2022 14:28:54 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3kngmtp4gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 14:28:54 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AAESsbK17301970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 14:28:54 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A403B58057;
        Thu, 10 Nov 2022 14:28:52 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B71758058;
        Thu, 10 Nov 2022 14:28:51 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.229.253])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 14:28:51 +0000 (GMT)
Message-ID: <906322b1c53dfef15d8f5141f7af15a480dc434e.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio-ccw: sort out physical vs virtual pointers
 usage
From:   Eric Farman <farman@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 10 Nov 2022 09:28:51 -0500
In-Reply-To: <166807228813.13521.7185648742806016994@t14-nrb>
References: <20221109202157.1050545-1-farman@linux.ibm.com>
         <20221109202157.1050545-2-farman@linux.ibm.com>
         <166807228813.13521.7185648742806016994@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eaSQGZyhwys3DKPLJ2cp9W-6VOBLxDFA
X-Proofpoint-ORIG-GUID: eaSQGZyhwys3DKPLJ2cp9W-6VOBLxDFA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_08,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=774
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-10 at 10:24 +0100, Nico Boehr wrote:
> Quoting Eric Farman (2022-11-09 21:21:56)
> > From: Alexander Gordeev <agordeev@linux.ibm.com>
> >=20
> > The ORB is a construct that is sent to the real hardware,
> > so should contain a physical address in its interrupt
> > parameter field. Let's clarify that.
>=20
> Maybe I don't get it, but I think the commit description is
> inaccurate. The PoP
> says (p. 15-25):
>=20
> > Bits 0-31 of word 0 are
> > preserved unmodified in the subchannel until
> > replaced by a subsequent START SUBCHANNEL or
> > MODIFY SUBCHANNEL instruction. These bits are
> > placed in word 1 of the interruption code when an I/O
> > interruption occurs and when an interruption request
> > is cleared by the execution of TEST PENDING
> > INTERRUPTION.
>=20
> So the hardware actually doesn't care what kind of address this is.
> Rather, the
> CIO driver expects the intparam to be a physical address - probably
> so it fits
> 32 bits -, see do_cio_interrupt.

Right, it doesn't even need to be an address; we could write 0xdeadbeef
if we wanted, so long as that could be decoded by the driver on the
interrupt side. I really just wanted to point out that it was sent to
the channel, not that the channel (or anything else on the hardware
side) used it. What about this?

   The ORB's interrupt parameter field is stored unmodified into the
   interruption code when an I/O interrupt occurs. As this reflects
   a real device, let's store the physical address of the subchannel
   struct so it can be used when processing an interrupt.
