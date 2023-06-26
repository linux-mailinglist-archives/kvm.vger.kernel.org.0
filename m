Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CDA73E36E
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 17:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjFZPed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 11:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjFZPea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 11:34:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001391700;
        Mon, 26 Jun 2023 08:34:25 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35QFCXkk007336;
        Mon, 26 Jun 2023 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=V+Y2cq7WfTk5J2Cr2qDvHL53AGxEkQEk2hsvIhE6LrA=;
 b=iotVi9/vmNIhnsFl0WuawdTF+mP5ixDGZYAGuIgzgd/98YXGR6IpqAi0/9iwCVsF6TcQ
 tn1SYrYe8LM6UhgW3wurC4zkRk5pnsprz4l0IEWITZ6sV+zVokPmfaZB+TwhpjMlcb3u
 G8aMrddYmiHTZpYVLrnZBf+panUobC6ijnbxOJwbuFz9VJFtCNGUc52rJIU5/rimMW0k
 Msxs+ZjfbT1JgE/zPnOZ76dyXEA0o5or6TD3MSUEQXqoDe5QYKQGB408IrmjkqNfeq4i
 ZRliUZakmCSY0ZnkLTcHJaHbPluu97H4tfV3Svyzx42EMjd1xBxbOs/ZQwb/aABcsPMX 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rfd420nur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jun 2023 15:34:25 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35QFER1j013459;
        Mon, 26 Jun 2023 15:34:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rfd420nsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jun 2023 15:34:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35Q6g7ZX030161;
        Mon, 26 Jun 2023 15:34:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4518vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jun 2023 15:34:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35QFYIE245154586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jun 2023 15:34:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8C3120049;
        Mon, 26 Jun 2023 15:34:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91A1A20040;
        Mon, 26 Jun 2023 15:34:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 26 Jun 2023 15:34:18 +0000 (GMT)
Date:   Mon, 26 Jun 2023 17:34:17 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: Align __bss_end to a halfword
 boundary
Message-ID: <20230626173417.6b6b70cd@p-imbrenda>
In-Reply-To: <20230623093941.448147-1-thuth@redhat.com>
References: <20230623093941.448147-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bzMAVwUB_fzMoREDDJNC8RqcVONxtp4-
X-Proofpoint-GUID: ifvth31eWlVmbBs-dPIGXRSmvOCVN7c_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-26_13,2023-06-26_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Jun 2023 11:39:41 +0200
Thomas Huth <thuth@redhat.com> wrote:

> We are using the "larl" instruction to load the address of __bss_end,
> and this instruction can only deal with even addresses, so we have
> to make sure that this symbol is aligned accordingly. Otherwise this
> will cause a failure with the new binutils 2.40 and Clang:
> 
>  /usr/bin/ld: s390x/cstart64.o(.init+0x6a): misaligned symbol `__bss_end'
>               (0x2c0d1) for relocation R_390_PC32DBL
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/flat.lds.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/s390x/flat.lds.S b/s390x/flat.lds.S
> index 0cb7e383..5e91ecac 100644
> --- a/s390x/flat.lds.S
> +++ b/s390x/flat.lds.S
> @@ -37,6 +37,7 @@ SECTIONS
>  	. = ALIGN(16);
>  	__bss_start = .;
>  	.bss : { *(.bss) }
> +	. = ALIGN(2);
>  	__bss_end = .;
>  	. = ALIGN(4K);
>  	edata = .;

