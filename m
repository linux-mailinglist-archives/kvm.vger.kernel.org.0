Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D54785D18
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 18:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbjHWQQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 12:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbjHWQQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 12:16:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F67E78;
        Wed, 23 Aug 2023 09:16:35 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NG7tVv017059;
        Wed, 23 Aug 2023 16:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=w8QYNl3yL/cBFxwdBLHJlStrut5knJs1xpHl5DZXxrg=;
 b=g+XUQseGc67t292FYboz6XFsAhqHM/W0L5eJnRFJVQ66k7rdgGOfDt3y1F4PB2yBL3qn
 pv8O0vN6nJbLP9VlKClfSaevHvyYCE7gYjYd1LrVDbKQwYoUlkoby6HLLavhdVtcqvze
 wF2rwhAzYXbyLOLg3pVQZ0iWE2g6HdT4l9svUjdKUB4d4qD11DDf6mBS7xZnPDd2VIhr
 wLhEaCKSX3W8JI9QwZgo5L5OPU+n9osjc5P+QdXU881pEhvcXvVWJH5e0aJ7Lb2zsbNT
 A3J+vUWdn6iGYieRBmY3mD5OXkq93i0CyvckNJGiFjughjxsLYhRovxlPMnO0+DwFXL5 tQ== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3snn72rcg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 16:16:34 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37NENBE7016549;
        Wed, 23 Aug 2023 16:16:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn227qpfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 16:16:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37NGGUPI24511210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 16:16:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F29A720043;
        Wed, 23 Aug 2023 16:16:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD44220040;
        Wed, 23 Aug 2023 16:16:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 23 Aug 2023 16:16:29 +0000 (GMT)
Date:   Wed, 23 Aug 2023 18:16:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu
 stalls
Message-ID: <20230823181627.7903ad6f@p-imbrenda>
In-Reply-To: <ZOYtd7m2TqMDIb++@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230823124140.3839373-1-mimu@linux.ibm.com>
        <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
        <e144381d-4ff3-d7b6-5624-813ea22f196a@linux.ibm.com>
        <ZOYtd7m2TqMDIb++@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iT3CfrmhEuqtemqA_FVoz6JW3EGkv3xE
X-Proofpoint-ORIG-GUID: iT3CfrmhEuqtemqA_FVoz6JW3EGkv3xE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_10,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 mlxlogscore=826 adultscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Aug 2023 18:01:59 +0200
Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> On Wed, Aug 23, 2023 at 04:09:26PM +0200, Michael Mueller wrote:
> > 
> > 
> > On 23.08.23 15:23, Alexander Gordeev wrote:  
> > > On Wed, Aug 23, 2023 at 02:41:40PM +0200, Michael Mueller wrote:
> > > ...  
> > > > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > > > index 9bd0a873f3b1..73153bea6c24 100644
> > > > --- a/arch/s390/kvm/interrupt.c
> > > > +++ b/arch/s390/kvm/interrupt.c
> > > > @@ -3205,8 +3205,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
> > > >   	if (gi->alert.mask)
> > > >   		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
> > > >   			  kvm, gi->alert.mask);
> > > > -	while (gisa_in_alert_list(gi->origin))
> > > > -		cpu_relax();
> > > > +	while (gisa_in_alert_list(gi->origin)) {
> > > > +		KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
> > > > +		process_gib_alert_list();  
> > > 
> > > process_gib_alert_list() has two nested loops and neither of them
> > > does cpu_relax(). I guess, those are needed instead of one you remove?  
> > 
> > Calling function process_gib_alert_list() guarantees the gisa
> > is taken out of the alert list immediately and thus the potential
> > endless loop on gisa_in_alert_list() is solved. The issue surfaced
> > with the following patch that accidently disabled the GAL interrupt
> > processing on the host that normaly handles the alert list.
> > The patch has been reverted from devel and will be re-applied in v2.
> > 
> > 88a096a7a460 Revert "s390/airq: remove lsi_mask from airq_struct"
> > a9d17c5d8813 s390/airq: remove lsi_mask from airq_struct
> > 
> > Does that make sense for you?  
> 
> Not really. If process_gib_alert_list() does guarantee the removal,
> then it should be a condition, not the loop.

this is actually a good question. why is it still a loop?

> 
> But I am actually not into this code. Just wanted to point out that
> cpu_relax() is removed from this loop and the two other loops within
> process_gib_alert_list() do not have it either.
> 
> So up to Christian, Janosch and Claudio.

