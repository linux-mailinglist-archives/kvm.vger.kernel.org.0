Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022FB60621F
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJTNrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJTNrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:47:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D78176523
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:47:12 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KDV3Sa007731
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=tcH1y0ImtgNBQlnKV2ReIwpgFU//vZ0FDtI/eKo8NuE=;
 b=nM90zkKAp2OUhxPgoaXfJzBZU1lH2JLQDygJGq7/K8ac2xHyGiW14Q0uyNMwuEThIkri
 9CGFVwLNaXl/AswYNykz6R/vdIQye5OYX9JcZNSazBrAnD+uSvd4pzw0f1a302zbdbJg
 DsKJOpUKjSEeP1y0UfVvBpn8Y4IG7BPaOHy/l9sPWjSWrkJUTj0RufErFhnN3BZ17RKa
 nJmsaFpjYD/mFFbOHIGuzBa1BSc8IDEctJbMa7DysnuMqpm/bY1UL6m3VoBd+oJ4Tsqj
 jOzXcA6IrQlZwO8ijmIwy87BRSiY4nnxQqHzC8y9llSp+b0Qt3JyWQC/pN12oEEiQCkD Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb79mgmh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:47:11 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KDVZ9P009679
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:47:11 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb79mgmfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 13:47:11 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KDZMul010925;
        Thu, 20 Oct 2022 13:47:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg96rp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 13:47:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KDg37C47251908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 13:42:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC149A4054;
        Thu, 20 Oct 2022 13:47:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94FC6A405C;
        Thu, 20 Oct 2022 13:47:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 13:47:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221020123143.213778-2-imbrenda@linux.ibm.com>
References: <20221020123143.213778-1-imbrenda@linux.ibm.com> <20221020123143.213778-2-imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] lib: s390x: terminate if PGM interrupt in interrupt handler
Cc:     frankja@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
Message-ID: <166627362540.27216.188293983732679576@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 20 Oct 2022 15:47:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dqxJ_t5hxpFy7WCtNftGjN6QeNrUPvLX
X-Proofpoint-GUID: Ozu9t2cCYwYWIFU4nH1jREi3fnPbplZp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_04,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 mlxlogscore=476 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-10-20 14:31:42)
> If a program interrupt is received while in an interrupt handler,
> terminate immediately, stopping all CPUs and leaving the last CPU in
> disabled wait with a specific PSW code.
>=20
> This will aid debugging by not cluttering the output, avoiding further
> interrupts (that would be needed to write to the output), and providing
> an indication of the cause of the termination.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
