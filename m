Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF5783C7E
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 11:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjHVJHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 05:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjHVJHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 05:07:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12556189
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 02:07:18 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37M93RUA017989;
        Tue, 22 Aug 2023 09:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dRqGjAVe1kAczp6pVHaIImosCz/E28t8r+6o95HynQA=;
 b=oaXxhb5Zow9eKVW3jOc7taiX2uVVbDy9/3bpFYwvYWbBSPSQEZgqk0W+XMXs39OPgPzT
 q/9UXCRau/bV7x9wv38EVoA2NyE/6UP/6R78sJMXSToCFhZ8AnEfjEDR1Tl/HOtCwNNf
 GSPI8xEPhmUd8fUGn0d4iQGlowXMEkPj07aYPDpDB8YEt9U+J5rLyK4HutOZjf+skLHA
 ECPXzsuDSQKZZgALV11kQP52Kk/n8McsLsysAU9yZvw5t9rAYyQUmBvbOJcUA8zqB34P
 h5eRH+78LYgdZq7YlzRRijRITzjWxFwJFQ/rYpvL6E3eqyXxy2yDCq2xA6DXovFRINDn MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3smt1yg654-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Aug 2023 09:07:09 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37M9492M020570;
        Tue, 22 Aug 2023 09:06:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3smt1yg50y-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Aug 2023 09:06:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37M6IXxI006917;
        Tue, 22 Aug 2023 08:37:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3smc7w55dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Aug 2023 08:37:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37M8b0hH26935952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 08:37:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC98B2004D;
        Tue, 22 Aug 2023 08:37:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8747A20049;
        Tue, 22 Aug 2023 08:37:00 +0000 (GMT)
Received: from [9.179.29.40] (unknown [9.179.29.40])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 22 Aug 2023 08:37:00 +0000 (GMT)
Message-ID: <79f8ebd0-e4d0-5e28-f014-5ae0c1f2ec41@linux.ibm.com>
Date:   Tue, 22 Aug 2023 10:37:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH] Makefile: Move -no-pie from CFLAGS into
 LDFLAGS
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230822074906.7205-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230822074906.7205-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zSBEFvQt6sVJL_9q0EmDG2wJhKn-zUku
X-Proofpoint-ORIG-GUID: L2jj_MixVL5cMckUXznoAG6XbSRijNVG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_08,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 clxscore=1011 mlxlogscore=915 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308220069
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/23 09:49, Thomas Huth wrote:
> "-no-pie" is an option for linking, not for compiling, so we must put
> this into the lDFLAGS, not into CFLAGS. Without this change, the linking
> currently fails on Ubuntu 22.04 when compiling on a s390x host.
> 
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: e489c25e ("Rework the common LDFLAGS to become more useful again")
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Just tested it on my system, this fixes the compile problem.

