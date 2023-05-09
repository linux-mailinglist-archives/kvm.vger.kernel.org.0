Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE586FC9FE
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 17:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbjEIPOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 11:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjEIPOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 11:14:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B3C448A;
        Tue,  9 May 2023 08:14:15 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349FBsB3002772;
        Tue, 9 May 2023 15:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uyJcDoqLZNk8uiZ7bO3d+Hcz7IEGragFwLVwnNqn+uY=;
 b=Y3lRD+XvGA8A+Pohccypgkllu69Q4BTrR4JR3q3sEG/TbMn4TEvdUiB0na/Hi+4UvwUl
 4uqSWnYz6gtyxwAUCkSzMxMjyUgZbcUnUoACrl3l46TWEcuWE31D1YnoXPLH/0jhprAI
 vIggwhJZr+jM7p7pcLt2mcUTbu8NYhPAm3glwfpx/g6bi0jeuTZjEAK3UmE0MeemuqG/
 ousTNpA9GmJhXhhe9F4+pPIpLj1eVZ3Jhzkj0PAkxTxFdg7kE0LpCz3VK0LWfZ9VZZL0
 Pv+l7w9fyq9vul2yYYizyHb8GVux/Tb46/2YPuZ9la7jkSzpwgpl2glOxNypiY7k8WbR oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrkv062j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:14:14 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349FCRJk007898;
        Tue, 9 May 2023 15:14:14 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrkv05xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:14:14 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 349D8h4W018219;
        Tue, 9 May 2023 15:14:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qf7mhge7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:14:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349FE6eR6161056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 15:14:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE1D920040;
        Tue,  9 May 2023 15:14:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 702FD2004F;
        Tue,  9 May 2023 15:14:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 15:14:06 +0000 (GMT)
Date:   Tue, 9 May 2023 17:14:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@linux.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 2/3] KVM: s390: add stat counter for shadow gmap
 events
Message-ID: <20230509171404.1495e864@p-imbrenda>
In-Reply-To: <168364406109.331309.632943177292737298@t14-nrb>
References: <20230509111202.333714-1-nrb@linux.ibm.com>
        <20230509111202.333714-3-nrb@linux.ibm.com>
        <c762bd30-9753-7b3e-3f46-b15ba575ee7c@linux.ibm.com>
        <168364406109.331309.632943177292737298@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 64VnOJyP__ofV1gDndutwXQgVxnBg1cE
X-Proofpoint-ORIG-GUID: 2tSoFN5NT-gD0Zhxj0RMPQsgw24Mq1bx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 16:54:21 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Janosch Frank (2023-05-09 13:59:46)
> [...]
> > > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > > index 3c3fe45085ec..7f70e3bbb44c 100644
> > > --- a/arch/s390/include/asm/kvm_host.h
> > > +++ b/arch/s390/include/asm/kvm_host.h
> > > @@ -777,6 +777,11 @@ struct kvm_vm_stat {
> > >       u64 inject_service_signal;
> > >       u64 inject_virtio;
> > >       u64 aen_forward;
> > > +     u64 gmap_shadow_acquire;
> > > +     u64 gmap_shadow_r2;
> > > +     u64 gmap_shadow_r3;
> > > +     u64 gmap_shadow_segment;
> > > +     u64 gmap_shadow_page;  
> > 
> > This needs to be gmap_shadow_pgt and then we need a separate shadow page 
> > counter that's beeing incremented in kvm_s390_shadow_fault().
> > 
> > 
> > I'm wondering if we should name them after the entries to reduce 
> > confusion especially when we get huge pages in the future.
> > 
> > gmap_shadow_acquire
> > gmap_shadow_r1_te (ptr to r2 table)
> > gmap_shadow_r2_te (ptr to r3 table)
> > gmap_shadow_r3_te (ptr to segment table)
> > gmap_shadow_sg_te (ptr to page table)
> > gmap_shadow_pg_te (single page table entry)  

but then why not calling them gmap_shadow_{pte,pmd,pud,p4d,pgd} ?

> 
> Yep, right, this was highly confusing to the point where I was also
> confused by it. Will change that, thanks.

