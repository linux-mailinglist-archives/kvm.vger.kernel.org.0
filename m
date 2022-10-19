Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A84D603AC5
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 09:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJSHji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 03:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiJSHje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 03:39:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC6CBF71
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 00:39:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29J77AmZ026910
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=19aZoOqExFJNQIbKi0EyRpGkBWAOX5xo6nmtADX172A=;
 b=bwlryZSj2CYK5TGVxQj9PL38KxN1LG6MPHNzWKJVLpg257H+KOqtq8bWFpWtha6dry9c
 sgzXrCHZyIDL+o/CSaSdANxRxqF33Wdkm4FpIaa00iIPx1ZGx3Rx7/pzFoiXgz2a/i5m
 je7DmW2I8rn1kEYFPoIKanlOtd7y69vn4Gx0caMqsvtffU/UY76iSdV1vGPx2TOfw6BB
 U2eHBv/ZZvCa1WbBXSnbwyqgFr2lCccaVjS6WlktC4zL7Iy0TzNDlsPJ4rCRRvBdUCQR
 Aof2oSmlR58KTJYYeWt7VKKkCq45tIQl1b3YENnQZHCqSlXbCB46hKwgxr06Mo9AxYAw nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kac6pst5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:39:32 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29J77Dcx027276
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:39:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kac6pst42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 07:39:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29J7ODQT007009;
        Wed, 19 Oct 2022 07:34:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3k7mg8w0n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 07:34:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29J7YQ6t52625790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 07:34:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C9E64C044;
        Wed, 19 Oct 2022 07:34:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FFB54C040;
        Wed, 19 Oct 2022 07:34:26 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.15.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 07:34:26 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221018140951.127093-2-imbrenda@linux.ibm.com>
References: <20221018140951.127093-1-imbrenda@linux.ibm.com> <20221018140951.127093-2-imbrenda@linux.ibm.com>
Cc:     frankja@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM interrupt in interrupt handler
Message-ID: <166616486603.37435.2225106614844458657@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 19 Oct 2022 09:34:26 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2WnaT5tI5QBDRAhLXzP3JGE4LIk9syQL
X-Proofpoint-ORIG-GUID: Nh7CcBcdTSSxZCyO-RgEgX9zV-Wl3uds
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_04,2022-10-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxlogscore=904 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-10-18 16:09:50)
[...]
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 7cc2c5fb..22bf443b 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
[...]
>  void handle_pgm_int(struct stack_frame_int *stack)
>  {
> +       if (THIS_CPU->in_interrupt_handler) {
> +               /* Something went very wrong, stop everything now without=
 printing anything */
> +               smp_teardown();
> +               disabled_wait(0xfa12edbad21);
> +       }

Maybe I am missing something, but is there a particular reson why you don't=
 do
 THIS_CPU->in_interrupt_handler =3D true;
here as well?
