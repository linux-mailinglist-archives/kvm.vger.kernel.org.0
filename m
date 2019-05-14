Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B21C4CC
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 10:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfENI1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 04:27:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfENI1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 04:27:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E8NRWe038322;
        Tue, 14 May 2019 08:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=4GwONZKT5RET7N6PWlM860uaduZb6+5QuVv3rFgtIho=;
 b=Me7oLnU0/rmmtbQAySa5AOY/0LStOilrC3J76991LQTTFatI8eSBS258oGayJxjOmJ/D
 yHWDyCS73SnTaafYTYObBvbUdom0TeUggz2cbj3NFCkO1ERgywX83bGDVXanVtBN1ADK
 rA9iUbU7+FYqBDOL8FnBoQQUrjXihLOaBqP3eCUS59RzXfix50RyTJXON2aGBWJKluN4
 nYFPxujFDsqwPztKIgZhuv4YbdpzXoGhW26Z4odBcUA885M8JB4OpiAy7A73R0NJiT0E
 Jao0Uz8of4JvQOSHd+YQqAK/xhBmvYcu6KHzbKIrQkMWK4Qd0qKc+Pxc/nzUYRNj0Iuo ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sdnttm68s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 08:26:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E8OA2d011637;
        Tue, 14 May 2019 08:26:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2sf3cn4jgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 08:26:04 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4E8Q0LQ024611;
        Tue, 14 May 2019 08:26:00 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 01:26:00 -0700
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
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
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
Date:   Tue, 14 May 2019 10:25:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190514070941.GE2589@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140062
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140062
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/14/19 9:09 AM, Peter Zijlstra wrote:
> On Mon, May 13, 2019 at 11:18:41AM -0700, Andy Lutomirski wrote:
>> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
>> <alexandre.chartre@oracle.com> wrote:
>>>
>>> pcpu_base_addr is already mapped to the KVM address space, but this
>>> represents the first percpu chunk. To access a per-cpu buffer not
>>> allocated in the first chunk, add a function which maps all cpu
>>> buffers corresponding to that per-cpu buffer.
>>>
>>> Also add function to clear page table entries for a percpu buffer.
>>>
>>
>> This needs some kind of clarification so that readers can tell whether
>> you're trying to map all percpu memory or just map a specific
>> variable.  In either case, you're making a dubious assumption that
>> percpu memory contains no secrets.
> 
> I'm thinking the per-cpu random pool is a secrit. IOW, it demonstrably
> does contain secrits, invalidating that premise.
> 

The current code unconditionally maps the entire first percpu chunk
(pcpu_base_addr). So it assumes it doesn't contain any secret. That is
mainly a simplification for the POC because a lot of core information
that we need, for example just to switch mm, are stored there (like
cpu_tlbstate, current_task...).

If the entire first percpu chunk effectively has secret then we will
need to individually map only buffers we need. The kvm_copy_percpu_mapping()
function is added to copy mapping for a specified percpu buffer, so
this used to map percpu buffers which are not in the first percpu chunk.

Also note that mapping is constrained by PTE (4K), so mapped buffers
(percpu or not) which do not fill a whole set of pages can leak adjacent
data store on the same pages.

alex.
