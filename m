Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B7362E396
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiKQR4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240329AbiKQR4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:56:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0119D82203;
        Thu, 17 Nov 2022 09:56:08 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHHKhJQ020659;
        Thu, 17 Nov 2022 17:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9hO88NdYDKs7FuUbkEqfKzDgmaeOXCOSpvoEOiM7LRs=;
 b=mXcrW83Bb/CYKSAogDrnLaJ43Lhoe1XrQsC4lRNWL9LWDdJ7cBv6s2r46YkMmvytObtJ
 Sbwik8XhkuS5Eb0voQ7P7hT6kZ7ehN4scOR2ZDf3XX5hcHVnMyKqFjALk85jX7DnBkmJ
 gMQvymUxOydQnmOoBVkYMEO9dtRtzzQ2tdgiSx0mLDD9Xe5vzhz1IuaeipVptbNmXvk7
 HnAT53D8lUi7H8Urd4Pn8UGEJqz62tUKNQfivrZqk404exnA8u8f7vWNX2lIutEFtm0e
 aatazz6fidTHnTEWCjzbcLJQD458dsfnGtwM76FFJ8k1nU5OaeX35k3cEwd8wQ5NLwyZ Pw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwqguv32p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 17:56:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AHHp9B5029507;
        Thu, 17 Nov 2022 17:56:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3kt348yw29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 17:56:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AHHu2Hx32309788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 17:56:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A315C52052;
        Thu, 17 Nov 2022 17:56:02 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.145.29.204])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 17C1E5204F;
        Thu, 17 Nov 2022 17:56:02 +0000 (GMT)
Date:   Thu, 17 Nov 2022 18:55:57 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/vfio-ap: GISA: sort out physical vs virtual
 pointers usage
Message-ID: <20221117185557.40932450.pasic@linux.ibm.com>
In-Reply-To: <20221117110143.6892e7e8@p-imbrenda>
References: <20221108152610.735205-1-nrb@linux.ibm.com>
        <659501fc-0ddc-2db6-cdcb-4990d5c46817@linux.ibm.com>
        <166867501356.12564.3855578681315731621@t14-nrb.local>
        <20221117110143.6892e7e8@p-imbrenda>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OeIFd2GkmSaA0joDuFafhx29U_AyhW1s
X-Proofpoint-ORIG-GUID: OeIFd2GkmSaA0joDuFafhx29U_AyhW1s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Nov 2022 11:01:43 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Thu, 17 Nov 2022 09:50:14 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
> > Quoting Janosch Frank (2022-11-15 09:56:52)  
> > > On 11/8/22 16:26, Nico Boehr wrote:    
> > > > Fix virtual vs physical address confusion (which currently are the same)
> > > > for the GISA when enabling the IRQ.
> > > > 
> > > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > > ---
> > > >   drivers/s390/crypto/vfio_ap_ops.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > > > index 0b4cc8c597ae..20859cabbced 100644
> > > > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > > > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > > > @@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
> > > >   
> > > >       aqic_gisa.isc = nisc;
> > > >       aqic_gisa.ir = 1;
> > > > -     aqic_gisa.gisa = (uint64_t)gisa >> 4;
> > > > +     aqic_gisa.gisa = (uint64_t)virt_to_phys(gisa) >> 4;    
> > > 
> > > I'd suggest doing s/uint64_t/u64/ or s/uint64_t/unsigned long/ but I'm 
> > > wondering if (u32)(u64) would be more appropriate anyway.    
> > 
> > The gisa origin is a unsigned int, hence you are right, uint64_t is odd.

The reason for the cast was that gisa is a pointer, but we needed to do
integer arithmetic on the address of the object pointed to by the
pointer. It happens so that the pointer must point to a piece of memory
that is 31 bit addressable in host real address space, but for getting
the address from a pointer, casting to the unsigned integral type
with-wise corresponds to the pointer is IMHO sensible regardless of
that information.

>But since virt_to_phys() returns unsigned long, the cast to uint64_t is
> now useless.
> > 
> > My suggestion is to remove the cast alltogether.  
> 
> I agree to remove it

Right: that cast makes no sense any more. And with that change:

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

