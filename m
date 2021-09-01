Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B473FE10E
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344895AbhIARTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 13:19:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344594AbhIARTC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 13:19:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181H2hFi162524;
        Wed, 1 Sep 2021 13:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=/ympYdJM3XRWQJFFpSJOM0Ubg/CJuYugMsPvn7VHyGs=;
 b=XW36RHTxqwO1NWf86WhdmzT+kjmPc6x1qjQaaQIGlAwhf5Zic0OBkN8bABo3ZrJz+fwy
 0mYJkREuQypGov0pE0iov+321SdavRBqyzTQW30/dVEguFpEn4HiciKg6PgPJ7QH0JIP
 hgXVG1SCK5FFNOi2yAH4hOOY6VBtWSR6Noi0KHUZ5DcdPg5UDnEOpjyFZ5Qa6WkTpkwh
 2f8c7dqf0T1rvxN9bkl3D3BmiaRkHgx4Uy5Ujpn7UJ049SPSbHhbEJ5kPMM+24h184dd
 PH5LlueOohgB4WsE3sOrEmHUA8iBBmLpUY5LAdI/uKVcVeDa8EMzyms96YfnXgZ+qPxf ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3atd3kh0yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 13:14:04 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 181H2p84163299;
        Wed, 1 Sep 2021 13:14:03 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3atd3kh0xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 13:14:03 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181HCllP017210;
        Wed, 1 Sep 2021 17:14:02 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3aqcseahw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 17:14:02 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181HE0Q440698160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 17:14:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AFD878078;
        Wed,  1 Sep 2021 17:14:00 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1B577805C;
        Wed,  1 Sep 2021 17:13:57 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.89.117])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 17:13:57 +0000 (GMT)
Message-ID: <95da4155a7d65a5085955b83a6d25aaadeb1d88e.camel@linux.ibm.com>
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
Date:   Wed, 01 Sep 2021 10:13:56 -0700
In-Reply-To: <85b1dabf-f7be-490a-a856-28227a85ab3a@www.fastmail.com>
References: <20210824005248.200037-1-seanjc@google.com>
         <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
         <YSlkzLblHfiiPyVM@google.com>
         <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
         <YS6lIg6kjNPI1EgF@google.com>
         <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
         <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
         <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
         <85b1dabf-f7be-490a-a856-28227a85ab3a@www.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0TxHihYJkq5cDi4z8E0PEVP336--GHLZ
X-Proofpoint-ORIG-GUID: K2bKnIWqtE-C5aGE46gfB3IBKWxJjcd8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-09-01 at 10:08 -0700, Andy Lutomirski wrote:
> 
> On Wed, Sep 1, 2021, at 9:18 AM, James Bottomley wrote:
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
> I asked David, and he said the PSP offers a swapping mechanism for
> SEV-ES.  I haven’t read the details, but they should all be public.

Well it does, but it's not useful: we can't use the PSP for bulk
encryption, it's too slow.  That's why we're having to fuss about fast
migration in the first place.  In theory the two PSPs can co-operate to
migrate a guest but only if you have about a year to wait for it to
happen.

James


