Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29541604CDB
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJSQNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJSQNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:13:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C6C19344D
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:13:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFCfGc028171
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=WD86yXeCzAj0bJhtFgLI4gubCaCkYBx47W+sPB5gEZs=;
 b=OnA3+7lzqNBf8mW6hgGFwquW5fljcxUaORMz4rScCuFyMRgcFVlVUjwDjcnRHTFjMTw+
 OItKx1qPpNh5pbTMyy/EYWtXd52IgYUjTG3eMdMh/Hcgrk8zLYZPoA6i8k/2F8gRV0Rr
 CDK2bMdS30W/gv/S3Ynfea0BQEWfsgTUFdgse814HbpaSGo5v5iSLSlxyOBFNqEkgCEW
 oRO6v13dq/aBbRZxRBE2OcbeivaBqZBg3euZ6GYzQWZtNXWPFa7R14rQ+rVhZ2SGYfsD
 z3rAOu7Rw3cKiiWE054eJwEO9Zc0D6CC/jr250s1aGghYC1d20l16XfUZfxlqMLEbSrE Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakp2rhu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:24:23 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JFCgRn029760
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:24:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakp2rht2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:24:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JFML28005267;
        Wed, 19 Oct 2022 15:24:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kajmrr3tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:24:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JFJGQW49348904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:19:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C219AE04D;
        Wed, 19 Oct 2022 15:24:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 304A4AE045;
        Wed, 19 Oct 2022 15:24:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.32.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 15:24:17 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221019171920.455451ea@p-imbrenda>
References: <20221019145320.1228710-1-nrb@linux.ibm.com> <20221019171920.455451ea@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/1] s390x: do not enable PV dump support by default
Message-ID: <166619305695.37435.2798515077166987872@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 19 Oct 2022 17:24:16 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Cgb4X6h9I7v40lrrCxNkxl4hWjnqod9
X-Proofpoint-GUID: uil3z1hXzE_ovvJc-xVu-AR58kwsiBVS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=764 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-10-19 17:19:43)
> On Wed, 19 Oct 2022 16:53:19 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > v1->v2:
> > ---
> > * add indent to CONFIG_DUMP if in Makefile (thanks Janosch)
> > * add comment (thanks Janosch)
> >=20
> > Currently, dump support is always enabled by setting the respective
> > plaintext control flag (PCF). Unfortunately, older machines without
> > support for PV dump will not start the guest when this PCF is set.
>=20
> maybe for the long term we could try to fix the stub generated by
> genprotimg to check the plaintext flags and the available features and
> refuse to try to start if the required features are missing.
>=20
> ideally providing a custom message when generating the image, to be
> shown if the required features are missing. e.g. for kvm unit test, the
> custom message could be something like
> SKIP: $TEST_NAME: Missing hardware features
>=20
> once that is in place, we could revert this patch

But that would mean that on machines which don't support dumping, PV tests =
will never run, will they?

So we need some way of specifing at compile time whether you want dump supp=
ort or not.
