Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC23FDFF7
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245394AbhIAQeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:34:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1412 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232876AbhIAQeA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 12:34:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181G2lEV135862;
        Wed, 1 Sep 2021 12:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=OK+UoipCQDRdmNhN8LKNcQBV5QECX7QgiiXDE1CWxU4=;
 b=T1/wsVCAR6dwC7SzPZYMOAO5GTEbQSnxFhT81B6soLD+eKCBveIYN31YbsCdcLgSeJM7
 IiNa/gjwakk9gXurnmUrrKxhpBqGHrmmzmyAFW9y3IgP7AR6FTe/ey7gj9gupIjx9yfZ
 VPdnjvrQcSWDQmY3faT/ZQ0+1O4kl5nkwRnBP8kX9tBkCfiKeLmK7UJIi186w+ekSpbm
 6pYuT/Ds8yZvveCZqDh5Uua+H3yCi5WrG56Hd5pSDOrBBQSdoYo4hkGwnwBdwlE1Btrc
 dkG/0VhKFsZkyzU0a5mcK3u4gcoIHLptaJTR4WzGPp4hOixR9kdvdyLHip5Iizmod0Nc mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3atafaddbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 12:31:55 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 181G3ViV146149;
        Wed, 1 Sep 2021 12:31:54 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3atafaddbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 12:31:54 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181GE1RM001502;
        Wed, 1 Sep 2021 16:31:53 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 3aqcsdd4vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 16:31:53 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181GVqAW42074462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 16:31:53 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D56857806B;
        Wed,  1 Sep 2021 16:31:52 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F6C17805E;
        Wed,  1 Sep 2021 16:31:50 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.89.117])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 16:31:50 +0000 (GMT)
Message-ID: <0d6b2a7e22f5e27e03abc21795124ccd66655966.camel@linux.ibm.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     David Hildenbrand <david@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Date:   Wed, 01 Sep 2021 09:31:49 -0700
In-Reply-To: <a259e10d-39c9-c4a5-0ab4-f42a1b9bfaee@redhat.com>
References: <20210824005248.200037-1-seanjc@google.com>
         <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
         <YSlkzLblHfiiPyVM@google.com>
         <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
         <YS6lIg6kjNPI1EgF@google.com>
         <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
         <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
         <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
         <a259e10d-39c9-c4a5-0ab4-f42a1b9bfaee@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 740NiI5iGR3hYxkUmw29dddhY5YGUAGA
X-Proofpoint-GUID: u2xUgjuS-M1puQAP-rLX-ZO2m8UUaaDN
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-09-01 at 18:22 +0200, David Hildenbrand wrote:
> On 01.09.21 18:18, James Bottomley wrote:
> > On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
> > [...]
> > > If you want to swap a page on TDX, you can't.  Sorry, go directly
> > > to jail, do not collect $200.
> > 
> > Actually, even on SEV-ES you can't either.  You can read the
> > encrypted page and write it out if you want, but unless you swap it
> > back to the exact same physical memory location, the encryption key
> > won't work.  Since we don't guarantee this for swap, I think swap
> > won't actually work for any confidential computing environment.
> > 
> > > So I think there are literally zero code paths that currently
> > > call try_to_unmap() that will actually work like that on TDX.  If
> > > we run out of memory on a TDX host, we can kill the guest
> > > completely and reclaim all of its memory (which probably also
> > > involves killing QEMU or whatever other user program is in
> > > charge), but that's really our only option.
> > 
> > I think our only option for swap is guest co-operation.  We're
> > going to have to inflate a balloon or something in the guest and
> > have the guest driver do some type of bounce of the page, where it
> > becomes an unencrypted page in the guest (so the host can read it
> > without the physical address keying of the encryption getting in
> > the way) but actually encrypted with a swap transfer key known only
> > to the guest.  I assume we can use the page acceptance
> > infrastructure currently being discussed elsewhere to do swap back
> > in as well ... the host provides the guest with the encrypted swap
> > page and the guest has to decrypt it and place it in encrypted
> > guest memory.
> 
> Ballooning is indeed *the* mechanism to avoid swapping in the
> hypervisor  and much rather let the guest swap. Shame it requires
> trusting a guest, which we, in general, can't. Not to mention other
> issues we already do have with ballooning (latency, broken auto-
> ballooning, over-inflating, ...).


Well not necessarily, but it depends how clever we want to get.  If you
look over on the OVMF/edk2 list, there's a proposal to do guest
migration via a mirror VM that invokes a co-routine embedded in the
OVMF binary:

https://patchew.org/EDK2/20210818212048.162626-1-tobin@linux.ibm.com/

This gives us a page encryption mechanism that's provided by the host
but accepted via the guest using attestation, meaning we have a
mutually trusted piece of code that can use to extract encrypted pages.
It does seem it could be enhanced to do swapping for us as well if
that's a road we want to go down?

James


