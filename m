Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D841B4FE499
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357030AbiDLPX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356998AbiDLPXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:23:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149DF1B797;
        Tue, 12 Apr 2022 08:21:07 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEnaLQ012609;
        Tue, 12 Apr 2022 15:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dsxqLb2Mk/1BCqT7Gh/NuM34+pCbF6cZSHEFyVTkrgc=;
 b=pt4Ai/0JEwMXCgRSjqdaJ188mmCC/IwrCU8RW3lEHum8g67wnZDRaJhBbvWh7n8wEYCj
 /FH0Nnm4FbGrsL8UWNzQKumSFyzk9+FTlpP6IhZ4xqo+RnImNxIeJg5BI+3u0DYMfVMb
 KvX0U4jeoin5njodMhzgeuK8LKJH+/cZmzFy+UCXWPn8/VOsyl7epxe/Ya+/rvk0MyHa
 gamtmj3aeu88iCUO5W4vNxlP2icxOqsFY71j/bhVR4Uji/AgIwg3Kgv03IjZopOE00QR
 v1tojzuZfFSrNQWI6faI1tiKiHT0HuDUMFWUfxfvGQEIBEASCO3vIvOAykP/guvjsLSZ lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b65xvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:21:06 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CFJJVC029246;
        Tue, 12 Apr 2022 15:21:06 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b65xsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:21:06 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CFHoQx010344;
        Tue, 12 Apr 2022 15:20:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3fb1s8v57x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:20:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CFKtMf50921956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 15:20:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B0AB42042;
        Tue, 12 Apr 2022 15:20:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB4BB42049;
        Tue, 12 Apr 2022 15:20:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 15:20:54 +0000 (GMT)
Date:   Tue, 12 Apr 2022 17:20:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 0/2] s390x: Add tests for SIGP store adtl
 status
Message-ID: <20220412172053.0208445e@p-imbrenda>
In-Reply-To: <20220401123321.1714489-1-nrb@linux.ibm.com>
References: <20220401123321.1714489-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BypjyuaJmOzcDvLq365XWlN3XPASOXXs
X-Proofpoint-ORIG-GUID: ITrdphvD9s8k1JUe0f27nxyjnZpbb1ij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_05,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  1 Apr 2022 14:33:19 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Changelog from v1:
> ----
> - Move vector related defines to own header
> - Write restart_write_vector in assembler to avoid undesired use of floating
>   point registers by the compiler.
> - Minor naming fixes
> 

queued, thanks

> As suggested by Claudio, move the store adtl status I sent previously
> ("[kvm-unit-tests PATCH v2 0/9] s390x: Further extend instruction interception
>  tests") into its own file.
> 
> Nico Boehr (2):
>   s390x: gs: move to new header file
>   s390x: add test for SIGP STORE_ADTL_STATUS order
> 
>  lib/s390x/asm/vector.h |  16 ++
>  lib/s390x/gs.h         |  69 +++++++
>  s390x/Makefile         |   1 +
>  s390x/adtl-status.c    | 411 +++++++++++++++++++++++++++++++++++++++++
>  s390x/gs.c             |  54 +-----
>  s390x/unittests.cfg    |  25 +++
>  6 files changed, 523 insertions(+), 53 deletions(-)
>  create mode 100644 lib/s390x/asm/vector.h
>  create mode 100644 lib/s390x/gs.h
>  create mode 100644 s390x/adtl-status.c
> 

