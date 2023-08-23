Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AF7785CDF
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 18:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbjHWQE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 12:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbjHWQE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 12:04:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339ADE71;
        Wed, 23 Aug 2023 09:04:26 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NFnG7C029721;
        Wed, 23 Aug 2023 16:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=OpIG5SSgl0+fpsPXok+YlAgaq2Jnt2PP3wLfO9+RP2Y=;
 b=m5mSYtp1e1ZWLy+Q402OCLCRHbBcfuGndttPI+D/Jmvmdtd6x4h3o30Dxtv+3AJVL+He
 4EQFrjOMXblRklvb6kJG+jPNKKxJo3gMiUJk6RatDrMumz55qrIrZTY6o8pSgHPkxlP4
 /RyCHympmCJQgR0YdMMYGn1pH8DiB0aO7Cyj3ZZsem25GznOqB8Y7InrzoGbaAgJ72zH
 Caf4GoLwimLcdfj2A0HXXW+QUHJbu+mWI8DHy/0xHl7UmY53olm3O9fPN7WtQOADI1cE
 vAkxISPsfBhuWqqYgPCK9u668uOvwKdZ5J3BAr+jRa9UAfC+c7AzlF8PvnBBpmOIukL4 7w== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3snn3e8e65-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 16:04:25 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37NEaY8Q010305;
        Wed, 23 Aug 2023 16:02:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sqk1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 16:02:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37NG20Ze43713110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 16:02:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F62A2006F;
        Wed, 23 Aug 2023 16:02:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 562D02006B;
        Wed, 23 Aug 2023 16:02:00 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Aug 2023 16:02:00 +0000 (GMT)
Date:   Wed, 23 Aug 2023 18:01:59 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu
 stalls
Message-ID: <ZOYtd7m2TqMDIb++@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230823124140.3839373-1-mimu@linux.ibm.com>
 <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <e144381d-4ff3-d7b6-5624-813ea22f196a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e144381d-4ff3-d7b6-5624-813ea22f196a@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GPexpL1ucogNIluVZ54km1Ir6EPTD9ou
X-Proofpoint-ORIG-GUID: GPexpL1ucogNIluVZ54km1Ir6EPTD9ou
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_09,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=651
 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230142
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 04:09:26PM +0200, Michael Mueller wrote:
> 
> 
> On 23.08.23 15:23, Alexander Gordeev wrote:
> > On Wed, Aug 23, 2023 at 02:41:40PM +0200, Michael Mueller wrote:
> > ...
> > > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > > index 9bd0a873f3b1..73153bea6c24 100644
> > > --- a/arch/s390/kvm/interrupt.c
> > > +++ b/arch/s390/kvm/interrupt.c
> > > @@ -3205,8 +3205,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
> > >   	if (gi->alert.mask)
> > >   		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
> > >   			  kvm, gi->alert.mask);
> > > -	while (gisa_in_alert_list(gi->origin))
> > > -		cpu_relax();
> > > +	while (gisa_in_alert_list(gi->origin)) {
> > > +		KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
> > > +		process_gib_alert_list();
> > 
> > process_gib_alert_list() has two nested loops and neither of them
> > does cpu_relax(). I guess, those are needed instead of one you remove?
> 
> Calling function process_gib_alert_list() guarantees the gisa
> is taken out of the alert list immediately and thus the potential
> endless loop on gisa_in_alert_list() is solved. The issue surfaced
> with the following patch that accidently disabled the GAL interrupt
> processing on the host that normaly handles the alert list.
> The patch has been reverted from devel and will be re-applied in v2.
> 
> 88a096a7a460 Revert "s390/airq: remove lsi_mask from airq_struct"
> a9d17c5d8813 s390/airq: remove lsi_mask from airq_struct
> 
> Does that make sense for you?

Not really. If process_gib_alert_list() does guarantee the removal,
then it should be a condition, not the loop.

But I am actually not into this code. Just wanted to point out that
cpu_relax() is removed from this loop and the two other loops within
process_gib_alert_list() do not have it either.

So up to Christian, Janosch and Claudio.
