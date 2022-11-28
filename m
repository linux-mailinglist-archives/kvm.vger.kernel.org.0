Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AB063ACEB
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 16:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiK1PsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 10:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiK1Pr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 10:47:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDB51835C
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 07:47:51 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASDm16A013187
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hieO0JBCRz1AmSey0p54J4z55HSOjpbLrPRX6iF/QRo=;
 b=NbVJQNMuXMTJ5M+2aRL9BH/6E67l/Y/rUNrc4qo47njD56tNCbzwqdp2L7yoWwi1c9/H
 rcBtnHghRo1ARF3BqhFhJs2+AHoYOmPh4h4RwNingLc6BT/APD3elUVr/WgyTAP+6DZ5
 WIReQrTR2obIpiJuh2dX5zijVM28lPlKmI5z5fZBZqId8C0J0CyiUm+GJja4cOm9OEQi
 tp0UObWB4yrrp3jDlidNq1oxvT/c6dSORA+7kjwSQM+ZW5ywkxYgzKlUqzEn8SOA+hJf
 zp07lFYCLEPo3yFnPpe2WE1APPRGRhmf4XgLEUSVxSzZ2Lbf+HZhqEjOB7+Uy3XlkDe/ Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m4x6gk7b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:47:51 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASEsVYN001115
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:47:50 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m4x6gk7a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:47:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASFZFHY017281;
        Mon, 28 Nov 2022 15:47:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9aspb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:47:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASFljtd56492292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 15:47:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24987AE055;
        Mon, 28 Nov 2022 15:47:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E002CAE04D;
        Mon, 28 Nov 2022 15:47:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 15:47:44 +0000 (GMT)
Date:   Mon, 28 Nov 2022 16:47:43 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v1 1/1] lib: s390x: add smp_cpu_setup_cur_psw_mask
Message-ID: <20221128164743.407e22aa@p-imbrenda>
In-Reply-To: <80691035f83c3ceb1b0e576086c4a60689a32e99.camel@linux.ibm.com>
References: <20221128123834.21252-1-imbrenda@linux.ibm.com>
        <80691035f83c3ceb1b0e576086c4a60689a32e99.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _u1xs6h8Y7okcBjmsB8fuchwK-91APRL
X-Proofpoint-ORIG-GUID: TfIuuQr-82fWtL_w_nC-qGoywXZiUgZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_13,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Nov 2022 16:10:32 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On Mon, 2022-11-28 at 13:38 +0100, Claudio Imbrenda wrote:
> > Since a lot of code starts new CPUs using the current PSW mask, add a
> > wrapper to streamline the operation and hopefully make the code of the
> > tests more readable.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/s390x/smp.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> > index f4ae973d..0bcb1999 100644
> > --- a/lib/s390x/smp.h
> > +++ b/lib/s390x/smp.h
> > @@ -47,4 +47,13 @@ void smp_setup(void);
> >  int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
> >  struct lowcore *smp_get_lowcore(uint16_t idx);
> >  
> > +static inline void smp_cpu_setup_cur_psw_mask(uint16_t idx, void *addr)
> > +{
> > +	struct psw psw = {
> > +		.mask = extract_psw_mask(),
> > +		.addr = (unsigned long)addr,
> > +	};
> > +	smp_cpu_setup(idx, psw);
> > +}
> > +
> >  #endif  
> 
> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Although I would have expected you to also use the function.
> 
> I'm wondering if just improving the ergonomics of creating a psw would suffice
> #define PSW(m, a) ((struct psw){ .mask = (uint64_t)m, .addr = (uint64_t)a })
> 
> Then it would look like
> 
> smp_cpu_setup(idx, PSW(extract_psw_mask(), addr))
> 
> and the macro might come in handy in other situations, too, but I haven't surveyed the code.

hmmm, this is actually not a bad idea at all

then it would be possible to also define

#define PSW_CUR_MASK(a) PSW(extract_psw_mask(), (a))

and have the code like this:

smp_cpu_setup(idx, PSW_CUR_MASK(addr));

I think I will do it like that (and also send a second patch where I
actually put it to use)
