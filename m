Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8220C6C7E31
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjCXMkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjCXMkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:40:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22821E5E3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:40:23 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OC2mB0029012
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=+nUxCB0eyD8UuP42icHJlEXRd5sBclFlXLLD0pBDGfI=;
 b=V+I/Cp/0wqIFoHzOVlxrSSefAjGAUCKPmMzsf+2vcfEWXZMDs9tDPvEb1Oa19ifqroCV
 P6W0sNcJKSGwKmxt/ZDaLf9WRlBBIALaV93hjnBPgAzbcZKIkMQ8iDOkuSrXC/lt/2cG
 sHD7CjNqleL1cgg37D3mNf/wK4JyZRANwCYX4j8wg/XeXTRPTJasXiWUUamx4nZ76Lsi
 UTF6vKI+A8RyAJq3/G9ErlNyS8rkUcKuIuJ2lO7k5V2qTqx9sjy5iUw9bKh9igdKIS8z
 j4YiwVXY/E39ZBsrbrG1xpw5lSZjy8xyA4Ne4Gc56o4UksBqXXE2zABnR100AOCCFN4w nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph94wvqx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:40:23 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OAlWu8024511
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:40:22 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph94wvqw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:40:22 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NM7AOH000464;
        Fri, 24 Mar 2023 12:40:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pgy9cgp0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:40:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCeGaZ26673764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:40:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB3352004F;
        Fri, 24 Mar 2023 12:40:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 873E720040;
        Fri, 24 Mar 2023 12:40:16 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:40:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230324121724.1627-4-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com> <20230324121724.1627-4-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: Add PV tests to unittests.cfg
Message-ID: <167966161621.41638.10341940214393062344@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 13:40:16 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fdENTG_4P9qoPzJN20Yqgp1cR5fnNJH2
X-Proofpoint-GUID: 82YzUrsfx3TBRh-L2wLl5MFl4aDpfLLS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=909 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-24 13:17:18)
> Even if the first thing those tests do is skipping they should still
> be run to make sure the tests boots and the skipping works.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
