Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267C76C7E33
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCXMlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjCXMlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:41:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D1311E89
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:41:06 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OCCPYc030929
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=7M354cPJptrDjBkvEpyXdtMi5d2Wl7+OVe6cs5Zb08Y=;
 b=dN+pWo+ASU0FDA0GmLJwimeE+MJsV6YgJaUdIDQzTr+Y5cY07jjNt2tCLA9xAvykzehR
 HXvt1EaOZq7Fz/cKZerkAjBR8l5X0JjUgjAtk7oC3E7UFcS0EZho1nsfVGclz78Zt5mf
 EIrd8hE1puNFjL+s6HfUNE+RqD1lV+4GuYhmgKOkCPjN734h699WcYqMmcJjJ03LmG1v
 vdFinyokRwcOSf7fFo9dpA9lCvi+0s8Q4OoXeRS6/ueYMUG2E6ntvc/mG52SV+6dfRAZ
 ZfJb9olcd53xB8Kk/36p29Srlg+PagAhnQMcqXyjlnecmM4DRVP3K/S3rSVM3Gc0XkU2 Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbnf8q2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:41:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OCRHE3032031
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:41:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbnf8q1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:41:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLKkCw024788;
        Fri, 24 Mar 2023 12:41:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pgxkrrueq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:41:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCexcq38142232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:40:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC8BF20043;
        Fri, 24 Mar 2023 12:40:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9801D20040;
        Fri, 24 Mar 2023 12:40:59 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:40:59 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230324121724.1627-8-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com> <20230324121724.1627-8-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 7/9] s390x: uv-host: Switch to smp_sigp
Message-ID: <167966165925.41638.11203831050984737199@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 13:40:59 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bzTq5m2EAqETF0tCpmeEk5IpMMziiFHC
X-Proofpoint-GUID: 1a4zv5VU4ZS_92MYUiQbp0bJIk0w64i4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_07,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=843 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-24 13:17:22)
> Let's move to the new smp_sigp() interface which abstracts cpu
> numbers.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
