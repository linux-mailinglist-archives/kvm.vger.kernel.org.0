Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C005996FE
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 10:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347531AbiHSIOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 04:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347527AbiHSIOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 04:14:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6E739BB5
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 01:14:05 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J82YRb037507
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 08:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=RAK12W6oAmWnzmbz62YsI8uhjsgzJn0eWriwuh0tsW4=;
 b=Kt/Sc8LvYhC3Q+dhKhlxJCMtA1MWU7MAU7Et0/DZ7tbtdvwPeR+YhNeIiwclfjRfzejy
 K9d7FzAgoFEHLOvTOetmZT7+lsVOGN+94XRWb11dZBocfaCAimxQgFdSXPpVNM6Krnes
 uZtjWkmgW8bG/1NrasPA/XX+aU+DrAPU/dGN3SFjN9ASEmFurtQLKw7Mz9dCEsLWEJ/J
 PavnJZheueASoxFPKHlFzmgnvT92LzfhjKalONvUrRkdtELoIRCLxLlTegX/54AMsdDc
 ZrNwm6kN7pBPaoH5yj7ZzTTCRZ+czV+XHp2iCCF0+TvcOpOvoO1uL6vHnI5NbmTUSc4g 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j26nnrbcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 08:14:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27J83mvp003410
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 08:14:03 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j26nnrbcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:14:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J86nYM014885;
        Fri, 19 Aug 2022 08:14:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hx37jf03w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:14:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J8EHvn32178608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 08:14:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CFABAE053;
        Fri, 19 Aug 2022 08:13:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34B56AE04D;
        Fri, 19 Aug 2022 08:13:58 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.155.203.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:13:58 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220818152114.213135-1-imbrenda@linux.ibm.com>
References: <20220818152114.213135-1-imbrenda@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com,
        seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] lib/s390x: fix SMP setup bug
Message-ID: <166089683797.9487.15356625692841421235@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 19 Aug 2022 10:13:57 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wVH0ZvGcxw1IkJ8bsdLmZZD1QA8Rce3G
X-Proofpoint-ORIG-GUID: aSEmAol1-s5wb6cKDxDw2fnxV1GiABxH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=401
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0
 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-18 17:21:14)
> The lowcore pointer pointing to the current CPU (THIS_CPU) was not
> initialized for the boot CPU. The pointer is needed for correct
> interrupt handling, which is needed in the setup process before the
> struct cpu array is allocated.
>=20
> The bug went unnoticed because some environments (like qemu/KVM) clear
> all memory and don't write anything in the lowcore area before starting
> the payload. The pointer thus pointed to 0, an area of memory also not
> used. Other environments will write to memory before starting the
> payload, causing the unit tests to crash at the first interrupt.
>=20
> Fix by assigning a temporary struct cpu before the rest of the setup
> process, and assigning the pointer to the correct allocated struct
> during smp initialization.
>=20
> Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-and-tested-by: Nico Boehr <nrb@linux.ibm.com>
