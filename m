Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5BE57DB43
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiGVHbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 03:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGVHbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 03:31:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CCA1409B
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:31:10 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M7L9pl020298
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=isaWe7EyBap/hjV0/A4YOvO6hu3ai4zULqcGFlRGoYo=;
 b=P56ULh808yRrGQ/bSD2GbQyanHV6SF7dyTGctHj/fIL6l4zHMve2RWEgyX0V84udIhSa
 VKVMhpJUEoQ4oLCOB4GJ4IEWwyDrhWeoPYAgvafhZ0m1Qz2nRSeaFGJqMUs8ZLJYKEGC
 UbQqmZ0o8b1e/k2cfigYFRCcjshAjFNClJI7QeOHHNemjxlgHe1r0/zYyMfXwfu7/u0I
 iNWRvKm+Io3YhwBdqPSV72iHi6VdIhI8gBdYYkWyLFa8qxBn76G1k+fymBSz4z7xlBea
 x9k1VneqRkG/G/lcELUnm8w1dRtKyafhJpO34qiQfc5ousIs1ocHXLbJtbwezcHdnuXw ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfqe8g7d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:31:09 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M7LTEW020892
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:31:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfqe8g7cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:31:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M7LLQO003849;
        Fri, 22 Jul 2022 07:31:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy901mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:31:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M7V3xU24052202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 07:31:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1168911C050;
        Fri, 22 Jul 2022 07:31:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3C7C11C04C;
        Fri, 22 Jul 2022 07:31:02 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.78.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 07:31:02 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220721183245.36b9d126@p-imbrenda>
References: <20220721132647.552298-1-nrb@linux.ibm.com> <20220721132647.552298-3-nrb@linux.ibm.com> <20220721183245.36b9d126@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: create persistent comm-key
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <165847506260.161082.3109099161458300124@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 22 Jul 2022 09:31:02 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1oCsKI5Nnuy51BU-oO_SdGx8ERt7tsZ0
X-Proofpoint-GUID: 8of_JHP_o3BRcJeXK6THoWdlTSNHblGk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-07-21 18:32:45)
> On Thu, 21 Jul 2022 15:26:47 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > To decrypt the dump of a PV guest, the comm-key (CCK) is required. Until
> > now, no comm-key was provided to genprotimg, therefore decrypting the
> > dump of a kvm-unit-test under PV was not possible.
> >=20
> > This patch makes sure that we create a random CCK if there's no
> > $(TEST_DIR)/comm.key file.
> >=20
> > Also allow dumping of PV tests by passing the appropriate PCF to
> > genprotimg (bit 34). --x-pcf is used to be compatible with older
> > genprotimg versions, which don't support --enable-dump. 0xe0 is the
> > default PCF value and only bit 34 is added.
> >=20
> > Unfortunately, recent versions of genprotimg removed the --x-comm-key
> > argument which was used by older versions to specify the CCK. To support
> > these versions, we need to parse the genprotimg help output and decide
> > which argument to use.
>=20
> I wonder if we can simply support only the newest version?
> would make the code cleaner, and updating genprotimg is not too
> complicated

I would be annoyed by having to compile s390-tools every time I want to run=
 PV tests on older distros.

If we want to avoid the --help parsing stuff, we could add a configure opti=
on to disable PV dump support. Not sure if it's a good idea.
