Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1416D1CEE
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjCaJt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 05:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCaJsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 05:48:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1136D2033C
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:47:28 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V9ET88021692
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=84r5p7JX1Jex/EJxSW1h5fSB6t99p/e9BQcdF61TzGg=;
 b=Or+ap3jrKMYwKWVGmrvSHylwZlJlTPLfOsEMlQOZrisWLtRhFnnkqzFHLySuiQM5DUT9
 P7lcnufx7OAeOKcox/Etn3WSM+PpaKbPNQt8rSVRjDG0nZI1ydXLPUZcM4YJzivQF4FI
 8TbnkpcXhO+lGvSgh1+rNiLMHweReR+tD4HCNONrKSFAO4kSjrCsM+7tIWzmLKlJHWHa
 JjqIKnG8jd9nENmiXeNnmUTXqEQZelfsh7Wd+ttk/AC2ZigXgwwLZRoukF2wMKORFAk0
 dah6awmM5rAfqpaYjq5nfaRanHdkO0EN/JAGdQRy2EylzsPNYtSsDaDKmbY0QpUeUAxX ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvq9grgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:47:27 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V9c0dm015308
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:47:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvq9grg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 09:47:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UNUpbF013396;
        Fri, 31 Mar 2023 09:47:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3phrk6wct1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 09:47:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V9lLKB38797792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 09:47:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40BE62004D;
        Fri, 31 Mar 2023 09:47:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AE0520040;
        Fri, 31 Mar 2023 09:47:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.12.80])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 09:47:20 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230331082709.35955-1-mhartmay@linux.ibm.com>
References: <168024782639.521366.8153497247119888695@t14-nrb> <20230331082709.35955-1-mhartmay@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4] s390x/Makefile: refactor CPPFLAGS
Message-ID: <168025604039.521366.11731416796810140141@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 31 Mar 2023 11:47:20 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: riTtlOZky4bBchFeHyUKQA7YUbEvOmYG
X-Proofpoint-ORIG-GUID: 3dRRN91uqLG5SM5nKydhjjH9J5X0YcJ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=872 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310075
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Marc Hartmayer (2023-03-31 10:27:09)
> This change makes it easier to reuse them. While at it, add a comment
> why the `lib` include path is required.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
