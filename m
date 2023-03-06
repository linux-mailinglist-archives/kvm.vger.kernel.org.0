Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518746AC0C2
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 14:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjCFNYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 08:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCFNYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 08:24:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8311EBD4;
        Mon,  6 Mar 2023 05:24:42 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326CncpF014797;
        Mon, 6 Mar 2023 13:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=SN35yMjjmmEEBzlLzd2bCzo4k5qis9j2ApDNPDhmp/U=;
 b=SNMS+O49CH3p7Zgn1lfIplL0VsaXtztOBWCSBn+4HmFQtxbYyW0v94Ug6eAUu3NbJQWk
 47k0CGTmCwltAwA+lonKtM9GosPpte4D1IT9uxLfubFzJbvMMKzCiitKr2XNURlxrS79
 NjMZgiiws7tnHZIqHvtJ2Jxg5g4g5/lFse6yimwFNciLjweJLWq8+cBm3ApWYuzjKbXF
 BaOo0Eq74jcWyBwjzlrPRCwR1mjwOk0UCjBlsdRPVy4WI0ukhoEMshwXZp+bwj1LUKIS
 nJcT+YCCf8naTqR9jFKjYSNMIrykKYnQ2Rcpk3YjbUmp2qlwd8cusPjl4r1m0tfIfJUO 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p500dkvxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 13:24:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326DG2pL018005;
        Mon, 6 Mar 2023 13:24:41 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p500dkvx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 13:24:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326BpfVs008540;
        Mon, 6 Mar 2023 13:24:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3p4188arn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 13:24:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326DOZE14129378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 13:24:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C362920043;
        Mon,  6 Mar 2023 13:24:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35B722004E;
        Mon,  6 Mar 2023 13:24:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.29.172])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
        Mon,  6 Mar 2023 13:24:35 +0000 (GMT)
Date:   Mon, 6 Mar 2023 14:24:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        mimu@linux.ibm.com, agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/1] KVM: s390: interrupt: fix virtual-physical
 confusion for next alert GISA
Message-ID: <20230306142433.71f24c6c@p-imbrenda>
In-Reply-To: <167809983224.10483.9560033030008953399@t14-nrb.local>
References: <20230224140908.75208-1-nrb@linux.ibm.com>
        <20230224140908.75208-2-nrb@linux.ibm.com>
        <20230228181633.1bd8efde@p-imbrenda>
        <167809983224.10483.9560033030008953399@t14-nrb.local>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uJKyCptI8KC16pRlE8pPK7erKj0AaHrh
X-Proofpoint-GUID: vuOZVdwOM-XkWdlf8fFvPRO7QBa4PjHa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_05,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 06 Mar 2023 11:50:32 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2023-02-28 18:16:33)
> > On Fri, 24 Feb 2023 15:09:08 +0100
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >   
> > > The gisa next alert address is defined as a host absolute address so
> > > let's use virt_to_phys() to make sure we always write an absolute
> > > address to this hardware structure.
> > > 
> > > This is not a bug and currently works, because virtual and physical
> > > addresses are the same.
> > > 
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > > ---
> > >  arch/s390/kvm/interrupt.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > > index ab26aa53ee37..20743c5b000a 100644
> > > --- a/arch/s390/kvm/interrupt.c
> > > +++ b/arch/s390/kvm/interrupt.c
> > > @@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
> > >  
> > >  static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
> > >  {
> > > -     return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
> > > +     return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);  
> > 
> > is gisa always allocated below 4G? (I assume 2G actually)
> >
> > should we check if things are proper?
> > the cast to (u32) might hide bugs if gisa is above 4G (which it
> > shouldn't be, obviously)
> > 
> > or do we not care?  
> 
> Yes, the gisa is always below 2 GB since it's part of the sie_page2.
> 
> I don't mind getting rid of the u32 cast really, but if it is allocated above 2 GB, it already is broken as it is and I didn't want to introduce unrelated changes. Also note that there is a few other places where we currently don't verify things really are below 2 GB, so you already need to be careful when allocating.
> 
> Also not sure if this is the right place to do this check, since we've already given the address to firmware/hardware anyways in the CHSC SGIB call, in the sie_block etc... so if we want to check this we should maybe look for a better place to check this...

fair enough
