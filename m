Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74881BAED
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfEMQWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:22:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfEMQWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:22:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DGJRLm096886;
        Mon, 13 May 2019 16:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Q1bINLnpf6kvvyhbh9wb20AMsLQSmmPWkmS1SRk8YqI=;
 b=nhBkFt4TTWkWTnFgnFD71MoII8v8qNZFc6Elm77XUUgHXt3lp0q+2/oYlnroJQfovuZd
 7AUooQFDhTilIYxmjomt35bt4cZVDxxdgwpSMW70sZshbKz6Squu1fXsA1G9vv/f5HX6
 GUWLYDKVlUnNnCTLw0oLk+RAWeJ0kPnHWByjzKFEJScb0qRO7Ka1kYZetAPUcCEbLmkN
 2Yivm6DE52Kq/b8YnYYbi/ZdNnrK91hgGkL8L2tlU/iQSMUGLSJ/Oq7IbFs13qTP9Ib+
 H4dJvl0TnaXAPNrSsalPig97N1VCTTjKUF1rhuJRUxu3tNWO0Zp/0wnmeLwyR8zo5VcO Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2sdkwdgcje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:21:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DGJZnA118286;
        Mon, 13 May 2019 16:21:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sdnqj2eqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:21:22 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4DGLLLW011879;
        Mon, 13 May 2019 16:21:21 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 16:21:20 +0000
Subject: Re: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrXADiujgE6HJ95P_da5OyB05Z5CqR028da50aCUHv4Agg@mail.gmail.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <0ed10cf2-d21f-3247-5b38-4cc1f78e38e1@oracle.com>
Date:   Mon, 13 May 2019 18:21:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrXADiujgE6HJ95P_da5OyB05Z5CqR028da50aCUHv4Agg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130111
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/19 6:02 PM, Andy Lutomirski wrote:
> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>>
>> The KVM page fault handler handles page fault occurring while using
>> the KVM address space by switching to the kernel address space and
>> retrying the access (except if the fault occurs while switching
>> to the kernel address space). Processing of page faults occurring
>> while using the kernel address space is unchanged.
>>
>> Page fault log is cleared when creating a vm so that page fault
>> information doesn't persist when qemu is stopped and restarted.
> 
> Are you saying that a page fault will just exit isolation?  This
> completely defeats most of the security, right?  Sure, it still helps
> with side channels, but not with actual software bugs.
> 

Yes, page fault exit isolation so that the faulty instruction can be retried
with the full kernel address space. When exiting isolation, we also want to
kick the sibling hyperthread and pinned it so that it can't steal secret while
we use the kernel address page, but that's not implemented in this serie
(see TODO comment in kvm_isolation_exit() in patch 25 "kvm/isolation:
implement actual KVM isolation enter/exit").

alex.
