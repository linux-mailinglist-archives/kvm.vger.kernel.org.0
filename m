Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8E01C449
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 10:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfENIAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 04:00:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59392 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfENIAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 04:00:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E7rZFV025235;
        Tue, 14 May 2019 07:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=APVvqr1lJvph+nzc+bHSkxPBxoL6T6+MikT3VYcFYTY=;
 b=Qa00vacPoKAcDmadtKFTWQ86hpzpK8edI+E8nptO4qmbHNiluW4rA72QRsqn8dqQgb+H
 YGHr2ncstXf+JbqVMohLL2958KIfwz1ytfCJ7tbXXGN1fYU2kBNJ1BY7oD907Cqwg837
 A61+vFfLiLoFKI7Ug++Agy45D9NhL2tIeOvullD7o5jCeYuuFEqelfAWsJg31pIUxGK3
 zAykOuGR1A4gFP7D39sMxyz/OAWKeBzSF37EeCYYD6w2+diBlhHO4t4uR/f89UX7hgse
 NPu/z0kCRo8ZxHnDBqoSzEiQzVrR8NVl4GGZs4KQwlhUmJ6N7g8nenjrZc4sJIEKLJad cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sdkwdm73v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 07:58:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E7vKet144428;
        Tue, 14 May 2019 07:58:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sdmeax9xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 07:58:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4E7w7PM008960;
        Tue, 14 May 2019 07:58:07 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 00:58:07 -0700
Subject: Re: [RFC KVM 06/27] KVM: x86: Exit KVM isolation on IRQ entry
To:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-7-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrUzAjUFGd=xZRmCbyLfvDgC_WbPYyXB=OznwTkcV-PKNw@mail.gmail.com>
 <64c49aa6-e7f2-4400-9254-d280585b4067@oracle.com>
 <CALCETrUd2UO=+JOb_008mGbPdfW5YJgQyw5H7D_CxOgaWv=gxw@mail.gmail.com>
 <20190514070719.GD2589@hirez.programming.kicks-ass.net>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <b17d8525-a83b-d37b-dfb4-f09ec3b6bcfc@oracle.com>
Date:   Tue, 14 May 2019 09:58:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190514070719.GD2589@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140058
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140058
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/14/19 9:07 AM, Peter Zijlstra wrote:
> On Mon, May 13, 2019 at 11:13:34AM -0700, Andy Lutomirski wrote:
>> On Mon, May 13, 2019 at 9:28 AM Alexandre Chartre
>> <alexandre.chartre@oracle.com> wrote:
> 
>>> Actually, I am not sure this is effectively useful because the IRQ
>>> handler is probably faulting before it tries to exit isolation, so
>>> the isolation exit will be done by the kvm page fault handler. I need
>>> to check that.
>>>
>>
>> The whole idea of having #PF exit with a different CR3 than was loaded
>> on entry seems questionable to me.  I'd be a lot more comfortable with
>> the whole idea if a page fault due to accessing the wrong data was an
>> OOPS and the code instead just did the right thing directly.
> 
> So I've ran into this idea before; it basically allows a lazy approach
> to things.
> 
> I'm somewhat conflicted on things, on the one hand, changing CR3 from
> #PF is a natural extention in that #PF already changes page-tables (for
> userspace / vmalloc etc..), on the other hand, there's a thin line
> between being lazy and being sloppy.
> 
> If we're going down this route; I think we need a very coherent design
> and strong rules.
> 

Right. We should particularly ensure that the KVM page-table remains a
subset of the kernel page-table, in particular page-table changes (e.g.
for vmalloc etc...) should happen in the kernel page-table and not in
the kvm page-table.

So we should probably enforce switching to the kernel page-table when
doing operation like vmalloc. The current code doesn't enforce it, but
I can see it faulting, when doing any allocation (because the kvm page
table doesn't have all structures used during an allocation).

alex.
