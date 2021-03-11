Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43633377C2
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 16:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhCKPbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 10:31:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234093AbhCKPa4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 10:30:56 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BFJLRr142680;
        Thu, 11 Mar 2021 10:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : references :
 from : cc : to : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B1iNFJ3KO5AIYzjG+f40jhVHvpBelFLlj4oPp4WlJjc=;
 b=hYmVbJK7xgp8Q4+LbI0/E3SmDMZqIIvi19t6NJoZyEr+nzzeHHwCO04jitGrikcVjQ5R
 zJiad+Eom5Z/jLiICdGOQ1I4+Vc9IJy/FcyozyDOdJqh9+saOhVKN9NhGCjpYftDJxwI
 YGAW6fIjDxGeBUAd8MVLrK3dJ6NCx2FlKFmnFjaXhfB08e2aP7QnkLwCcfOSwtp5ZfVi
 tr5NjlkEtas/JUnbAzgbXmoAh0Z2hSvGl1NPFgIOCBd6wgKCOFRioQwmtXxcAJV4EOal
 LJCRJPPOMkEgEccTvif4tcvNEt0RV9HOf66qZBMzy5b0FyUu4hbTnS5836PQanRxiF9x wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774mebee1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:30:53 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12BFKO6A147561;
        Thu, 11 Mar 2021 10:30:53 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774mebed4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:30:53 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12BFRg6Y010130;
        Thu, 11 Mar 2021 15:30:52 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3768rbvuv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:30:52 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12BFUot324707330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 15:30:50 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9054CC6057;
        Thu, 11 Mar 2021 15:30:50 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3821C6069;
        Thu, 11 Mar 2021 15:30:49 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.80.219.70])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 15:30:49 +0000 (GMT)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
References: <20210224085915.28751-1-natet@google.com>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Laszlo Ersek <lersek@redhat.com>, pbonzini@redhat.com,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>
To:     natet@google.com
Message-ID: <7829472d-741c-1057-c61f-321fcfb5bdcd@linux.ibm.com>
Date:   Thu, 11 Mar 2021 10:30:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210224085915.28751-1-natet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_05:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 clxscore=1011 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/21 09:59, Nathan Tempelman wrote:

> Add a capability for userspace to mirror SEV encryption context from
> one vm to another. On our side, this is intended to support a
> Migration Helper vCPU, but it can also be used generically to support
> other in-guest workloads scheduled by the host. The intention is for
> the primary guest and the mirror to have nearly identical memslots.
>
> The primary benefits of this are that:
> 1) The VMs do not share KVM contexts (think APIC/MSRs/etc), so they
> can't accidentally clobber each other.
> 2) The VMs can have different memory-views, which is necessary for post-copy
> migration (the migration vCPUs on the target need to read and write to
> pages, when the primary guest would VMEXIT).
>
> This does not change the threat model for AMD SEV. Any memory involved
> is still owned by the primary guest and its initial state is still
> attested to through the normal SEV_LAUNCH_* flows. If userspace wanted
> to circumvent SEV, they could achieve the same effect by simply attaching
> a vCPU to the primary VM.
> This patch deliberately leaves userspace in charge of the memslots for the
> mirror, as it already has the power to mess with them in the primary guest.
>
> This patch does not support SEV-ES (much less SNP), as it does not
> handle handing off attested VMSAs to the mirror.
>
> For additional context, we need a Migration Helper because SEV PSP migration
> is far too slow for our live migration on its own. Using an in-guest
> migrator lets us speed this up significantly.
Hello,

We've been thinking a lot about migrating confidential virtual machines 
at IBM. Maybe you've seen the approach that we (Dov Murik and myself) 
shared on the QEMU and OVMF mailing lists. In general, we have tried to 
implement migration without kernel support, which has some drawbacks. 
Mainly, it is difficult to dynamically start the migration handler 
without kernel support, which puts stress on OVMF. If there is momentum 
behind these KVM patches, we think they could go hand-in-hand with some 
of the work that we have done.

I'm not sure if you have patches for a migration handler/helper or 
hypervisor support. If you do, I'd be curious to see them. If not, maybe 
we should try to converge some of the work that has already happened. I 
think that no matter where the migration handler ends up running or how 
it is started, it will do more or less the same things: export pages to 
the HV and import pages from the HV. Similarly, the hypervisor is 
probably going to need similar mechanisms to ask the MH for encrypted 
pages. Given that we already have some of these things,  maybe there is 
a way to bring them together with this patch.

I also have a few specific questions about this patch.

I am not sure how the mirror VM will be supported in QEMU. Usually there 
is one QEMU process per-vm. Now we would need to run a second VM and 
communicate with it during migration. Is there a way to do this without 
adding significant complexity?

You say that SEV-ES is not supported. While there are challenges 
regarding setting the CPU state of the mirror, I think there may also be 
larger issues with using the mirror for -ES. With plain SEV, the 
migration handler only has to worry about guest memory. With SEV-ES the 
MH will probably need to set the CPU state of the guest as well. It 
seems difficult to do this with an MH that is in a separate VM entirely. 
Is there an expectation that the mirror-based approach will ever work 
with SEV-ES?

I am curious where you plan on putting the migration handler itself. We 
were drawn to OVMF because it is measured by the PSP. Do you have some 
alternate approach?

Do you plan to support consecutive migrations (target of first migration 
is source of second)? This is really just a question about the lifetime 
of the MH. Will the mirror VM be started and stopped dynamically or will 
it persist for the life of the guest on both source and target?

Finally, do you plan to use AMD PSP-based migration to migrate parts of 
the mirror VM or of the primary VM? The migration handler we've 
developed does not use PSP-based migration at all; instead it relies on 
secret injection to both source and target VMs to keep the migration 
keys secure. There are trade-offs either way.

-Tobin
