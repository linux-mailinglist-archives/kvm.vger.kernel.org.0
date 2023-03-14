Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF66B9CA0
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 18:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCNRMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 13:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCNRMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 13:12:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC0954CA8;
        Tue, 14 Mar 2023 10:12:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EFRpwX024290;
        Tue, 14 Mar 2023 17:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zbL6z7+6qs0jsQro0gjG3UEdcHypj946ofeVc8Zaub0=;
 b=NHX6HzekuQwYAzTalj2eUQ2J/EO3e62DerQyeRAC2x64RtMw08RD2lq9Sz6XcJXdbBm/
 bbwI5JK4BdReOOfitm9gLBEMGI80Ezf9doTBJ7E0ELkRLuW9TYmIQgD3tNXkEOl2hPMP
 f/X3jFuf/T4MIBO+DspEx6hhNdUztnIyG+DTX5C5ay2zGq62QDX7azSKnYBMXU/6QuHG
 AMNiW5cQjoFowOVAqtJ/mXWcRs/6o9i8zEuoNwKTKGKJ/z5kVMZP6HUtX4V0U1w0MsaO
 rv5E1Z/tydSxo2eKStF2o1CedkvBwPIhu/DUGzMFDk4BD/S3LsvajGlRFyrAHW0D4eYA ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pau6m3tuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 17:12:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EFHvDs002666;
        Tue, 14 Mar 2023 17:12:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pau6m3ttd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 17:12:29 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E8ra7l019120;
        Tue, 14 Mar 2023 17:12:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3p8h96m24v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 17:12:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32EHCOld18022940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 17:12:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 111552004B;
        Tue, 14 Mar 2023 17:12:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE40320043;
        Tue, 14 Mar 2023 17:12:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 17:12:23 +0000 (GMT)
Date:   Tue, 14 Mar 2023 18:12:21 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x/spec_ex: Add test of
 EXECUTE with odd target address
Message-ID: <20230314181221.6df1e4bd@p-imbrenda>
In-Reply-To: <3976942b40bfb2c2a222d251db1629df7b6819c2.camel@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
        <20230221174822.1378667-4-nsg@linux.ibm.com>
        <20230314162526.519364c5@p-imbrenda>
        <3976942b40bfb2c2a222d251db1629df7b6819c2.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XMrcv5zP0uCh9MnN-pPYN_OspJzvwMaB
X-Proofpoint-GUID: blisjUXCBl21OOB5JlyQEB9BCRggS3kR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_10,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140140
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Mar 2023 17:41:24 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Tue, 2023-03-14 at 16:25 +0100, Claudio Imbrenda wrote:
> > On Tue, 21 Feb 2023 18:48:22 +0100
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >   
> > > The EXECUTE instruction executes the instruction at the given target
> > > address. This address must be halfword aligned, otherwise a
> > > specification exception occurs.
> > > Add a test for this.
> > > 
> > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > ---
> > >  s390x/spec_ex.c | 25 +++++++++++++++++++++++++
> > >  1 file changed, 25 insertions(+)
> > > 
> > > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > > index a26c56aa..dd097f9b 100644
> > > --- a/s390x/spec_ex.c
> > > +++ b/s390x/spec_ex.c
> > > @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
> > >  	return 0;
> > >  }
> > >  
> > > +static int odd_ex_target(void)
> > > +{
> > > +	uint64_t pre_target_addr;
> > > +	int to = 0, from = 0x0dd;
> > > +
> > > +	asm volatile ( ".pushsection .rodata\n"  
> > 
> > and this should go in a .text.something subsection, as we discussed
> > offline  
> 
> Yes.
> >   
> > > +		"pre_odd_ex_target:\n"  
> > 
> > shouldn't the label be after the align?  
> 
> No, larl needs an aligned address, and the ex below adds 1.
> That's why it has the pre_ prefix, it's not the ex target itself.

I understand that, but 
> >   
> > > +		"	.balign	2\n"  

doesn't the address get aligned here?
so the label here would be aligned to 2

> > 
> > (i.e. here)
> >   
> > > +		"	. = . + 1\n"

and here it gets the +1?

> > > +		"	lr	%[to],%[from]\n"
> > > +		"	.popsection\n"
> > > +
> > > +		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
> > > +		"	ex	0,1(%[pre_target_addr])\n"
> > > +		: [pre_target_addr] "=&a" (pre_target_addr),
> > > +		  [to] "+d" (to)
> > > +		: [from] "d" (from)
> > > +	);
> > > +
> > > +	assert((pre_target_addr + 1) & 1);
> > > +	report(to != from, "did not perform ex with odd target");
> > > +	return 0;
> > > +}
> > > +
> > >  static int bad_alignment(void)
> > >  {
> > >  	uint32_t words[5] __attribute__((aligned(16)));
> > > @@ -218,6 +242,7 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
> > >  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
> > >  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
> > >  	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
> > > +	{ "odd_ex_target", &odd_ex_target, true, NULL },
> > >  	{ "bad_alignment", &bad_alignment, true, NULL },
> > >  	{ "not_even", &not_even, true, NULL },
> > >  	{ NULL, NULL, false, NULL },  
> >   
> 

