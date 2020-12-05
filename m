Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CA22CFE13
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 20:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgLETON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 14:14:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLETOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 14:14:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B5J7UXK158086;
        Sat, 5 Dec 2020 19:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mhnpaIKJAXhT3xSV6mJoYT0fvoAQC/sgQWva62heiF4=;
 b=WogpGGSkxXU0z4VtfNMZZ114NQp5duow6eyINoT+HHYyxGOHlWUT4uEXScUHsZKNDt5N
 K4cF3M/dtY22hk7jZtUqr3/bprxXeEFSIyvBPN3ZVc3wHHXLBqy7nnI/56xoYBk3kDt/
 6qXA8dcTDLfDEDScDIdMKIihm4uG1V9oogFNgTGT2PLe1OSn+iR4J6UtO8s7cbPZllyb
 VRkU+rx/b1oGy644ITYyoFK9PpKYPQ69bPdSw88u5d75ZL/9pX0LrbzqvjghgPTsUubA
 b74bqn4noqdpXq/F0GtjeEYsr5umhEkCAmS6S+1PE29+Goi3B0m5RbOxpantBHaEl+I7 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ks8xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 05 Dec 2020 19:13:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B5J6JO3080779;
        Sat, 5 Dec 2020 19:13:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35820yrer0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Dec 2020 19:13:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B5JDNVG006709;
        Sat, 5 Dec 2020 19:13:23 GMT
Received: from [10.175.203.58] (/10.175.203.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Dec 2020 11:13:23 -0800
Subject: Re: [PATCH 03/15] KVM: x86/xen: intercept xen hypercalls if enabled
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-4-dwmw2@infradead.org>
 <e62dd528-2bee-9e8b-c395-256e6980307e@oracle.com>
 <9A93D396-9C77-4E57-A7E0-61BBEEB83658@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <616173a3-586f-1156-9f53-28bdcdb665a6@oracle.com>
Date:   Sat, 5 Dec 2020 19:13:19 +0000
MIME-Version: 1.0
In-Reply-To: <9A93D396-9C77-4E57-A7E0-61BBEEB83658@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=934 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012050127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=949 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012050127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/5/20 6:51 PM, David Woodhouse wrote:
> On 5 December 2020 18:42:53 GMT, Joao Martins <joao.m.martins@oracle.com> wrote:
>> I suppose it makes sense restricting to INTERCEPT_HCALL to make sure
>> that the kernel only
>> forwards the hcall if it is control off what it put there in the
>> hypercall page (i.e.
>> vmmcall/vmcall). hcall userspace exiting without INTERCEPT_HCALL would
>> break ABI over how
>> this ioctl was used before the new flag... In case
>> kvm_xen_hypercall_enabled() would
>> return true with KVM_XEN_HVM_CONFIG_HYPERCALL_MSR, as now it needs to
>> handle a new
>> userspace exit.
> 
> Right. 
> 
>> If we're are being pedantic, the Xen hypercall MSR is a utility more
>> than a necessity as
>> the OS can always do without the hcall msr IIUC. But it is defacto used
>> by enlightened Xen
>> guests included FreeBSD.
> 
> Not sure about that. Xen doesn't guarantee that the hypercall will be VMCALL; the ABI *is* ",use the hypercall page MSR and call it" I believe.
> 
You might be right. I had always had the impression that the above was is geared towards
PV guests hypercalls IIRC which are not VMMCALL/VMCALL. Xen doesn't explicitly check you
initialized an hypercall page for HVM guests.

> But if they do just do the VMCALL, that *will* work as I have it, won't it?
> 
It would work indeed.

What I was mentioning is the possibility that you let userspace fill the hcall page data,
while enabling hcall intercept () so 0x3 as xen hvm config flags i.e. you pass a blob with
hcall intercept set.

I think it's good as is given that interception is tied in with what you fill in the hcall
page.

>>
>> And adding:
>>
>> #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
>>
>> Of course, this is a nit for readability only, but it aligns with what
>> you write
>> in the docs update you do in the last patch.
> 
> Yep, already there. Thanks.
> 
