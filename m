Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FE63FDFB0
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245260AbhIAQUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:20:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245312AbhIAQUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 12:20:48 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181G3emd143345;
        Wed, 1 Sep 2021 12:18:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=k7jwf9mEpW9jMLXlEdUYvNg47RVo/cTl0rw993cyzzc=;
 b=VcjPk/5yS1kAMACqyb3V3u2u86H1AdJJhaaAf9xA9RVF4un99U52rI2kHIbJ7FvBJqdg
 JiLhg5gUKKNV1p1OTvWQpZbTfc2XeKi638BzUe5wRRvR09OyQ+DUGynqfMlgK54ysfd2
 finYC2MLPCptL5gfA24DuhXMQoEOXA/i9HlPskkCUt0i0LG9cxlD6/DNPxfcOU9HPsBT
 2Kz5IEe6R+Xx9MQi/DDv4jpmCBrXvHwL8Gcd1Ir9j3eJ7XFEgNRoksD6nRtYAnAdrtlQ
 on5SU7JVNkP3AhS/S3x4/SwUZoXlVyZH4dfNufNzOCTDgeiI7yBJ8Er1LcIawSwF34i3 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3atcnm0fn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 12:18:22 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 181G3pKY144452;
        Wed, 1 Sep 2021 12:18:21 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3atcnm0fmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 12:18:21 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181GCmkw011119;
        Wed, 1 Sep 2021 16:18:20 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3aqcsdcr1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 16:18:20 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181GIJK834210266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 16:18:19 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 814AF78080;
        Wed,  1 Sep 2021 16:18:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F348678068;
        Wed,  1 Sep 2021 16:18:16 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.89.117])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 16:18:16 +0000 (GMT)
Message-ID: <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@redhat.com>,
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
Date:   Wed, 01 Sep 2021 09:18:15 -0700
In-Reply-To: <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
References: <20210824005248.200037-1-seanjc@google.com>
         <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
         <YSlkzLblHfiiPyVM@google.com>
         <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
         <YS6lIg6kjNPI1EgF@google.com>
         <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
         <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cmJTtet4j-0_5Tu7NNTq16pd3vB50BKT
X-Proofpoint-ORIG-GUID: 6b2-nvEpGw7ETdYGEPlsN8GDLSUDkpl9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
[...]
> If you want to swap a page on TDX, you can't.  Sorry, go directly to
> jail, do not collect $200.

Actually, even on SEV-ES you can't either.  You can read the encrypted
page and write it out if you want, but unless you swap it back to the
exact same physical memory location, the encryption key won't work. 
Since we don't guarantee this for swap, I think swap won't actually
work for any confidential computing environment.

> So I think there are literally zero code paths that currently call
> try_to_unmap() that will actually work like that on TDX.  If we run
> out of memory on a TDX host, we can kill the guest completely and
> reclaim all of its memory (which probably also involves killing QEMU
> or whatever other user program is in charge), but that's really our
> only option.

I think our only option for swap is guest co-operation.  We're going to
have to inflate a balloon or something in the guest and have the guest
driver do some type of bounce of the page, where it becomes an
unencrypted page in the guest (so the host can read it without the
physical address keying of the encryption getting in the way) but
actually encrypted with a swap transfer key known only to the guest.  I
assume we can use the page acceptance infrastructure currently being
discussed elsewhere to do swap back in as well ... the host provides
the guest with the encrypted swap page and the guest has to decrypt it
and place it in encrypted guest memory.

That way the swapped memory is securely encrypted, but can be swapped
back in.

James


