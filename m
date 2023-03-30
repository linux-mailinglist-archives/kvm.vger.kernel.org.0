Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E16D0BC2
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjC3Qt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjC3Qtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:49:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221E710259;
        Thu, 30 Mar 2023 09:48:42 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UFO4KU030836;
        Thu, 30 Mar 2023 16:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ybj/9QsIxhW0TRpEjVAODEQ3DdftEBDWyDhWW/e/etc=;
 b=XoVHnXK8xaGqxZ4727hFyJ8M03W7gTSoWbHzyKSOYVMFjDdztIn2wz33hAxKxHbiZhAj
 365rZhN52i2eDBIP7Sbxa43hIy8BEs/T9/PYTfqPlBB1rjUeROyQ7yj5DXhzQZrej/yy
 0YAKEXI44F2t8KK2JXF/72EMAG9uNWrU0XNnGJER0tLzUOtOy/mm0Pw2wfd+nAKMoCfV
 5kSSi3PDxQsDmfsYCKBoaDDqOLKrZJsa/3FKl8izC5qcMO7m2yifdfM80/pUhE9/omvK
 cCN9n5rnSeAnrvVZwQrLU8n4PO+GAeCxm2/h6+1wIYHaidogwslGV68MJ0pNAy9xyekF YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmph9pj9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:22 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UGS0vo039209;
        Thu, 30 Mar 2023 16:48:22 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmph9pj8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UADGfT024399;
        Thu, 30 Mar 2023 16:48:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3phr7fw04b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UGmGGC15860118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:48:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0916F2004B;
        Thu, 30 Mar 2023 16:48:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3A7D20040;
        Thu, 30 Mar 2023 16:48:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 16:48:15 +0000 (GMT)
Date:   Thu, 30 Mar 2023 18:09:00 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: Add ap library
Message-ID: <20230330180900.723c060d@p-imbrenda>
In-Reply-To: <20230330114244.35559-2-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
        <20230330114244.35559-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uOLzcUn-4fgAd8Vc1e6gl3kgEwaR1arO
X-Proofpoint-ORIG-GUID: CUNYECk8dA6FgQoP1xVrEkgE_4yGZAV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Mar 2023 11:42:40 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Add functions and definitions needed to test the Adjunct
> Processor (AP) crypto interface.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>

[...]

> +bool ap_check(void)
> +{
> +	struct ap_queue_status r1 = {};
> +	struct pqap_r2 r2 = {};
> +
> +	/* Base AP support has no STFLE or SCLP feature bit */

this is true, but you are also indiscriminately using a feature for
which there is a STFLE feature. since it seems you depend on that, you
might as well just check bit for STFLE.12 and assume the base support
is there if it's set

> +	expect_pgm_int();
> +	ap_pqap_tapq(0, 0, &r1, &r2);
> +
> +	if (clear_pgm_int() == PGM_INT_CODE_OPERATION)
> +		return false;
> +
> +	return true;
> +}

[...]

> +struct ap_config_info {
> +	uint8_t apsc	 : 1;	/* S bit */
> +	uint8_t apxa	 : 1;	/* N bit */
> +	uint8_t qact	 : 1;	/* C bit */
> +	uint8_t rc8a	 : 1;	/* R bit */
> +	uint8_t l	 : 1;	/* L bit */
> +	uint8_t lext	 : 3;	/* Lext bits */
> +	uint8_t reserved2[3];
> +	uint8_t Na;		/* max # of APs - 1 */
> +	uint8_t Nd;		/* max # of Domains - 1 */
> +	uint8_t reserved6[10];
> +	uint32_t apm[8];	/* AP ID mask */

is there a specific reason why these are uint32_t?
uint64_t would maybe make your life easier in subsequent patches (see my
comments there)

> +	uint32_t aqm[8];	/* AP (usage) queue mask */
> +	uint32_t adm[8];	/* AP (control) domain mask */
> +	uint8_t _reserved4[16];
> +} __attribute__((aligned(8))) __attribute__ ((__packed__));
> +_Static_assert(sizeof(struct ap_config_info) == 128, "PQAP QCI size");
> +
> +struct pqap_r0 {
> +	uint32_t pad0;
> +	uint8_t fc;
> +	uint8_t t : 1;		/* Test facilities (TAPQ)*/
> +	uint8_t pad1 : 7;
> +	uint8_t ap;
> +	uint8_t qn;
> +} __attribute__((packed))  __attribute__((aligned(8)));
> +
> +struct pqap_r2 {
> +	uint8_t s : 1;		/* Special Command facility */
> +	uint8_t m : 1;		/* AP4KM */
> +	uint8_t c : 1;		/* AP4KC */
> +	uint8_t cop : 1;	/* AP is in coprocessor mode */
> +	uint8_t acc : 1;	/* AP is in accelerator mode */
> +	uint8_t xcp : 1;	/* AP is in XCP-mode */
> +	uint8_t n : 1;		/* AP extended addressing facility */
> +	uint8_t pad_0 : 1;
> +	uint8_t pad_1[3];
> +	uint8_t at;
> +	uint8_t nd;
> +	uint8_t pad_6;
> +	uint8_t pad_7 : 4;
> +	uint8_t qd : 4;
> +} __attribute__((packed))  __attribute__((aligned(8)));
> +_Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
> +
> +bool ap_check(void);
> +int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
> +		 struct pqap_r2 *r2);
> +int ap_pqap_qci(struct ap_config_info *info);
> +#endif

