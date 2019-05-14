Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359931CC07
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfENPh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:37:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENPh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:37:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4EFY5Ad041917;
        Tue, 14 May 2019 15:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=K6RAKYDjcjRrn7OwP84UHYgsO7ChGZaEr+sqPb3xwhc=;
 b=5XJ/WDUHZ0rtX1wy7iGiSQInjd4Yje8V0Nmw7F2TpN62bao4hby9ViD40alDqoIimCcT
 IqmNrySa/hvm/yvNnPV7kAphqhwRpXXmIo9tmtGOcJefID4qORAU6rmiyGDpSb8VzGkL
 wb2TZXj3OraOSmMlRjSCXoGgbjRn5+uqIUwZ+EjtnghualrShvTzaqilDUUKkav3ZVEG
 DUvMwQXC/emAR1qaIFGPMioz6EbIWV+l5UJVwALQDf2XpMOl/tGCRp2uLVjWvH3o5D1j
 ygyljCSo8K2hmvy8qbg334BYRGKGGy7EcRlTxjFeqnVaX0FP4NSfdl91Nuo1L4e/hW2f uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sdnttpxv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 15:36:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4EFZLrw135409;
        Tue, 14 May 2019 15:36:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2se0tw7m68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 15:36:58 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4EFatFM011608;
        Tue, 14 May 2019 15:36:56 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 08:36:54 -0700
Subject: Re: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
To:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
 <20190513151500.GY2589@hirez.programming.kicks-ass.net>
 <13F2FA4F-116F-40C6-9472-A1DE689FE061@oracle.com>
 <CALCETrUcR=3nfOtFW2qt3zaa7CnNJWJLqRY8AS9FTJVHErjhfg@mail.gmail.com>
 <20190514072110.GF2589@hirez.programming.kicks-ass.net>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <95f462d4-37d3-f863-b7c6-2bcbb92251ec@oracle.com>
Date:   Tue, 14 May 2019 17:36:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190514072110.GF2589@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=941
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=973 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/14/19 9:21 AM, Peter Zijlstra wrote:
> On Mon, May 13, 2019 at 07:02:30PM -0700, Andy Lutomirski wrote:
> 
>> This sounds like a great use case for static_call().  PeterZ, do you
>> suppose we could wire up static_call() with the module infrastructure
>> to make it easy to do "static_call to such-and-such GPL module symbol
>> if that symbol is in a loaded module, else nop"?
> 
> You're basically asking it to do dynamic linking. And I suppose that is
> technically possible.
> 
> However, I'm really starting to think kvm (or at least these parts of it
> that want to play these games) had better not be a module anymore.
> 

Maybe we can use an atomic notifier (e.g. page_fault_notifier)?

alex.
