Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694096C7DFA
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjCXMY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjCXMY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:24:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2977312CC4
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:24:27 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBBaD4025256
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=IdOHJD6bM24w+hbvuYTN8i0le9brgLni7SzEEXdvLuo=;
 b=W+f8JX36dIlPZut6906FlVMwYttiuaNmlhnp2MxYHnPNemUAvP4gVTlMuqTczv36l4O4
 oHihgEwxSgyd7QpaTFMhq+dNfden95MAoat2D2FgrwiUlSVaAGNC2quU7GYAy38a8x6d
 auAv8po85QleWp3MSXizEegmNlJrqwXpSxq22GLrcrkK3i7Z6RG0qT87LsDt2cFTBxza
 VYbrP1rXSpHOmmgNfjniDs2eafZ5E2UC4NwCKfRXP3a2XUq5/Oyh3wKLL+3BwuFCthgZ
 03P+iGKFs3Sa6wd/sSb2/U/ThDM48O4jptTWOMHHOf8Lq45sF2k/Ki11c/jugFmOM86J 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phas9snww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:24:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBgs3K014467
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:24:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phas9snvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:24:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLKcrB024767;
        Fri, 24 Mar 2023 12:24:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pgxkrrty9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:24:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCOKK814222062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:24:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B6EF20043;
        Fri, 24 Mar 2023 12:24:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37AA720040;
        Fri, 24 Mar 2023 12:24:20 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:24:20 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230324120431.20260-2-frankja@linux.ibm.com>
References: <20230324120431.20260-1-frankja@linux.ibm.com> <20230324120431.20260-2-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: Introduce UV validity function
Message-ID: <167966065985.41638.10356712838273252799@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 13:24:19 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mBew0mjSA3subjLtW7eTzsbEomJED1Hx
X-Proofpoint-GUID: I3kGhSgeyYoyFWD2m2ekRge1pXdRE-xf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-24 13:04:29)
> PV related validities are in the 0x20** range but the last byte might
> be implementation specific, so everytime we check for a UV validity we
> need to mask the last byte.
>=20
> Let's add a function that checks for a UV validity and returns a
> boolean.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
