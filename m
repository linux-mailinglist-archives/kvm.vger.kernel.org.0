Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6CA6CC829
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjC1QiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjC1QiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:38:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B03976A
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:38:02 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SGPQ62011973
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:38:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ChvND5HbP2Cehht+tbIw7BxXXWCJQbw/IKg4MUhmbpE=;
 b=nVJ5nF22dTSdAe+chNmruh31YTh1FogYWvCLRwvdW2kBl3nep4d/kkB/0tPfW3lK0f+c
 xsVfkIyDNXBB8LObIH+1LF8lTcIo2nXklGvK7jZ9qUzvGGC+gaLFZWqqc2mvLcjgcBR/
 KzbJe1KZ096cuD5JLdB6lCeGDHC20wXMIwb49Vk5QEdWZ49B6ISBrimoIZ4tFxE45XC6
 UVahQ4vGKXACgX61x7CL/aS1i4MdbgB5IOk2iPAyDIvwohVCHHBvuEm2xJCOc0NkjFtL
 vdVn5HCS6N2TO8GJSwNtSeADNEl+3VRCSIqpwcjczIXE61L6jrCqBC5Gyk9jC3X1WvuY ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm3rc09sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:38:01 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SGSio6020577
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:38:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm3rc09rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 16:38:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S8aSkx002045;
        Tue, 28 Mar 2023 16:37:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6m5vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 16:37:59 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SGbt6w63308146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 16:37:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 560C72004B;
        Tue, 28 Mar 2023 16:37:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3185020043;
        Tue, 28 Mar 2023 16:37:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 16:37:55 +0000 (GMT)
Date:   Tue, 28 Mar 2023 16:44:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: Introduce UV validity
 function
Message-ID: <20230328164446.29c38a99@p-imbrenda>
In-Reply-To: <20230324120431.20260-2-frankja@linux.ibm.com>
References: <20230324120431.20260-1-frankja@linux.ibm.com>
        <20230324120431.20260-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B_Hsx3D7cSDPOPgICiGDzAHsZZ8VOHTp
X-Proofpoint-GUID: ELy2EwIu8YUa2S9roOuLNdsJsvOxupeW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Mar 2023 12:04:29 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> PV related validities are in the 0x20** range but the last byte might
> be implementation specific, so everytime we check for a UV validity we
> need to mask the last byte.
> 
> Let's add a function that checks for a UV validity and returns a
> boolean.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/uv.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 5fe29bda..78b979b7 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -35,4 +35,11 @@ static inline void uv_setup_asces(void)
>  	lctlg(13, asce);
>  }
>  
> +static inline bool uv_validity_check(struct vm *vm)
> +{
> +	uint16_t vir = sie_get_validity(vm);
> +
> +	return vm->sblk->icptcode == ICPT_VALIDITY && (vir & 0xff00) == 0x2000;
> +}
> +
>  #endif /* UV_H */

