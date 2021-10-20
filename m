Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFBB43469F
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 10:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJTIRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 04:17:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhJTIRd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 04:17:33 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K7qbRK032512;
        Wed, 20 Oct 2021 04:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4eINRPW2FxVxLhky8kXTcPwexrcajDLIOVdhX8RAjDg=;
 b=WCwY3dKEJabZPLyjlmB1pAiSgokoq3BQrfkhoHJ6caal2a0bn7JGFf1fZtuHCFZYnaOC
 2O8qrbjGXLmJf5vudj6eGFMGfwiCeUweolRsvzFDLhO2645Ok7KHdZTvrJetfeiHDDUi
 7tdH5F+pj7fE0XDgYigvLfe+MyO36aNNxfKXH9+w0yqx4M3UJWD1E4qACOtDA4E3nqST
 DPfp+qtt44Tua2E6TnboDD3IriOqYmSslRtC4gJLz2SWmge2I6TB14/MtOQIqOaAmFbF
 tTyEJ9YCxgTU/cP9AHfeo2ODR/vPsdxTOZ5lGaTJ2gaevBJ3l/8z2djC/8YxPzSvgkWS HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btf40reax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 04:15:19 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K7tB4t013702;
        Wed, 20 Oct 2021 04:15:19 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btf40rea2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 04:15:19 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K8ELvo031623;
        Wed, 20 Oct 2021 08:15:16 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3bqp0k7s1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:15:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K89MwP56426986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 08:09:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50AC711C04C;
        Wed, 20 Oct 2021 08:15:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C28611C054;
        Wed, 20 Oct 2021 08:15:12 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 20 Oct 2021 08:15:12 +0000 (GMT)
Date:   Wed, 20 Oct 2021 10:14:50 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
Message-ID: <20211020101450.1edbbc1f.pasic@linux.ibm.com>
In-Reply-To: <20211020080816.69d26708@p-imbrenda>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-2-pasic@linux.ibm.com>
        <20211020073515.3ad4c377@p-imbrenda>
        <1641267f-3a23-aba1-ab50-6f7c15e44528@de.ibm.com>
        <20211020080816.69d26708@p-imbrenda>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1HCBY9C0weQYX-ZQlxk-H3EfEnhnYhIk
X-Proofpoint-GUID: llTmUVaRFuqNgQvBMvp2vKj9RpdBWavK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 08:08:16 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> > >> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);    
> > > 
> > > so, you unconditionally clear the flag, before knowing if the vCPU is
> > > runnable?

Right. I talked about this with  Mimu. It would extend the section
guarded by the bit, and than may be a good thing. Maybe we should
measure that alternative as well.

> > > 
> > > from your description I would have expected to only clear the bit if
> > > the vCPU is not runnable.
> > > 
> > > would things break if we were to try to kick the vCPU again after
> > > clearing the bit, but before dispatching it?    
> > 
> > The whole logic is just an optimization to avoid unnecessary wakeups.
> > When the bit is set a wakup might be omitted.
> > I prefer to do an unneeded wakeup over not doing a wakeup so I think
> > over-clearing is safer.
> > In fact, getting rid of this micro-optimization would be a valid
> > alternative.  
> 
> my only concern was if things would break in case we kick the vCPU
> again after clearing the bit; it seems nothing breaks, so I'm ok with it

I'm not sure about the exact impact of over-waking.
kvm_s390_vcpu_wakeup() sets vcpu->valid_wakeup which is I believe used
for some halt poll heuristics. We unset that in
kvm_arch_vcpu_block_finish(). If we cleared only conditionally the
protection would extend for that as well. Which would be a good thing.
The statistics stuff in kvm_vcpu_wake_up() does account for already
running, so I see no correctness issues there.

Regards,
Halil




