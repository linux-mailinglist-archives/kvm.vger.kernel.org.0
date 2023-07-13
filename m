Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120CA751C61
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbjGMI5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbjGMI5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:57:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC196E0;
        Thu, 13 Jul 2023 01:57:24 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36D8FZiD032114;
        Thu, 13 Jul 2023 08:17:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=c2E00v6X+HS5HKC8I00Bh7T23EFf1Pk7Nd2znqVCCv4=;
 b=kF2yElUOQ1TnD5cAu6mxxjul+K3/wC8T8fePwPR1GjF1ygIZp3DxsC4F8eTNxkon8ToJ
 scYCjRMByXOfDaubAdiLKQk5zWCvi+3a/lsz5LTrn4C5ZJIKwcBJ5KWHI8ISPvH4fYfD
 lI2yYXLl83JSqJat9YDw60WGhCzr4CNwEB0ceSD4Su/7UOtYR8aFbcVEvX9chhp3eoaH
 lBgqzO72A9H2PEHclGp16/PY5ltacmFiVUKHQ47ny44tYQGnAZIEwUT7F0A+9z/Uvz6v
 wl721ukatbg6FU3HljQoTrDlEwqcafIj0aypTcf2QTSnVitJPc/0fY0lr06qrw01uS17 XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtddcgd7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:17:14 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D8GrAZ003153;
        Thu, 13 Jul 2023 08:17:14 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtddcgd6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:17:14 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36D743vl011007;
        Thu, 13 Jul 2023 08:17:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rqk4mjprt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:17:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36D8H9tL22545106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 08:17:09 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92AB920040;
        Thu, 13 Jul 2023 08:17:09 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 659F42004B;
        Thu, 13 Jul 2023 08:17:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 08:17:09 +0000 (GMT)
Date:   Thu, 13 Jul 2023 10:17:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 3/6] s390x: sie: switch to home space
 mode before entering SIE
Message-ID: <20230713101707.1d1da214@p-imbrenda>
In-Reply-To: <3dbe3094-b796-6b78-a97f-130a82780421@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
        <20230712114149.1291580-4-nrb@linux.ibm.com>
        <3dbe3094-b796-6b78-a97f-130a82780421@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QSX_blz22zSqAMMRpK9bP_OrSoVhV3Lf
X-Proofpoint-GUID: K5sJ2YjcPAbqguCrjVMNrKZmW-bcwq7W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jul 2023 09:28:19 +0200
Thomas Huth <thuth@redhat.com> wrote:

[...]

> > +	irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
> > +	psw_mask_clear_bits(PSW_MASK_HOME);
> > +
> > +	/* restore the old CR 13 */
> > +	lctlg(13, old_cr13);  
> 
> Wouldn't it be better to always switch to HOME address mode directly in our 
> startup code already (where we enable DAT)? Switching back and forth every 
> time we enter SIE looks confusing to me ... or is there a reason why we 
> should continue to run in primary address mode by default and only switch to 
> home mode here?

the existing tests are written with the assumption that they are
running in primary mode.

switching back and forth might be confusing, but avoids having to
fix all the tests

> 
>   Thomas
> 
> 

