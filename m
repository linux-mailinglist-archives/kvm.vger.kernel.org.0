Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296DD52A751
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345487AbiEQPro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240318AbiEQPrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:47:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C871236;
        Tue, 17 May 2022 08:47:42 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HFGXHs032416;
        Tue, 17 May 2022 15:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=TB1p3kKXe7ux8TlLqEp76fKcROj7h9dHboi/mKo/abQ=;
 b=WcDTSouSEaBk7tnLtGwAnxDKWCxMzTGFz8FrvPcr4QGuLOTmPj0CWH0ioU2hpIKw/00S
 NoLFGHlYHrcqt6fPzH4sJdTpnbW8DhEjsumLU2NRSBzw15seL/bzeo+M+ns2T6C06lrZ
 JbpiNC5A4pZ3O7K167kIfT4603GqUg+aDPZSEzjuXkECp/Nf/GSznRgkd73RydinooeA
 J0TJiuoWXjyAWmirWup+hfG7FLeuLHFvTpOf/NjOnlE3hHuWSnw/YOK332zJnG+wXHrt
 XM0EHQsKkp0mPKC/lz+EUTBsSowmV+a4R5ZX4NHjSVEyUxOxVNxDjkUmzO57Dc9bvaSo fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dv7hp5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:47:41 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HFULWs031570;
        Tue, 17 May 2022 15:47:40 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dv7hp4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:47:40 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HFhrok018718;
        Tue, 17 May 2022 15:47:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428ujfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:47:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HFlYlv42860852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 15:47:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B76911C04C;
        Tue, 17 May 2022 15:47:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2788D11C04A;
        Tue, 17 May 2022 15:47:34 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.56.72])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 15:47:34 +0000 (GMT)
Message-ID: <1de086cac18f97b8055f499dfa3bf1ed6788d5b4.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] s390x: Test effect of storage
 keys on diag 308
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 17 May 2022 17:47:33 +0200
In-Reply-To: <20220517165253.46799a10@p-imbrenda>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
         <20220517115607.3252157-5-scgl@linux.ibm.com>
         <20220517165253.46799a10@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a0ihY11oxZzjshDl5TwqQu18G3qQCXda
X-Proofpoint-ORIG-GUID: BJd0tZGNQPDghjPIo5WlSQtEEFps-kyJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-17 at 16:52 +0200, Claudio Imbrenda wrote:
> On Tue, 17 May 2022 13:56:07 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
> > Test that key-controlled protection does not apply to diag 308.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >  s390x/skey.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/s390x/skey.c b/s390x/skey.c
> > index 60ae8158..c2d28ffd 100644
> > --- a/s390x/skey.c
> > +++ b/s390x/skey.c
> > @@ -285,6 +285,31 @@ static void test_store_cpu_address(void)
> >  	report_prefix_pop();
> >  }
> >  
> > +static void test_diag_308(void)
> > +{
> > +	uint16_t response;
> > +	uint32_t (*ipib)[1024] = (void *)pagebuf;
> 
> why not just uint32_t *ipib = (void *)pagebuf; ?
> 
> > +
> > +	report_prefix_push("DIAG 308");
> > +	(*ipib)[0] = 0; /* Invalid length */

In an intermediate version I had
memset(ipib, 0, sizeof(*ipib));
Also, if I could specify that the asm writes to a memory location that
is specified via an address in a register without displacement, it
would tell the compiler what memory would be read.
Alas that is not possible (correct me if I'm wrong), so I actually
would do
WRITE_ONCE(ipib[0], 0)
(an get rid of the pointer to array)
> 
> then you can simply do:
> 
> ipib[0] = 0;
> 
> > +	set_storage_key(ipib, 0x28, 0);
> > +	/* key-controlled protection does not apply */
> > +	asm volatile (
> > +		"lr	%%r2,%[ipib]\n\t"
> > +		"spka	0x10\n\t"
> > +		"diag	%%r2,%[code],0x308\n\t"
> > +		"spka	0\n\t"
> > +		"lr	%[response],%%r3\n"
> > +		: [response] "=d" (response)
> > +		: [ipib] "d" (ipib),
> > +		  [code] "d" (5)
> > +		: "%r2", "%r3"
> > +	);
> > +	report(response == 0x402, "no exception on fetch, response: invalid IPIB");
> > +	set_storage_key(ipib, 0x00, 0);
> > +	report_prefix_pop();
> > +}
> > +
> >  /*
> >   * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
> >   * with access key 1.
> > @@ -714,6 +739,7 @@ int main(void)
> >  	test_chg();
> >  	test_test_protection();
> >  	test_store_cpu_address();
> > +	test_diag_308();
> >  	test_channel_subsystem_call();
> >  
> >  	setup_vm();
> 

