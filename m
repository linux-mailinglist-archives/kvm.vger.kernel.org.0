Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61C02C8400
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 13:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgK3MTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 07:19:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgK3MTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 07:19:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCFZtV184141;
        Mon, 30 Nov 2020 12:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/35K4M/vmL9FoPVuaJdBb8J6kRJpXAhoQlQqV1gB9sw=;
 b=g2o5UNGG1m6W0t/io8GIPnOLmP+R5iFchuKeyJkoU1RFSwc8yF2JlkN80c4t54p85SbP
 XSy+Wbp6hs7isHovSbxrZCXooK2Roy4YYVKtbuLd5QP7rGGW3R4P9LGZZiuPa2bP3h9c
 MeDsLwxlk2aKqV8mfRYmUJiXWLVkg4CfJd5BBhmu1C0m5cYG06PdmVPwm55bVVNpvn0v
 /PzF/5OMPbKWlt2iPCbLoPnO1SR5hNq+Aoy0QghqO+R5RWt7cLBP3xrznU+BoDaam5W3
 B3oYEHN0VxnzKOClWQEi8BxJutjqqs3dVWLIN2Isxwng5As6O8PzqH8LV0GoOwahpW76 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkcpp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 12:18:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCACAh152207;
        Mon, 30 Nov 2020 12:18:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540aqhenf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 12:18:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUCI0T7031903;
        Mon, 30 Nov 2020 12:18:00 GMT
Received: from [10.175.212.254] (/10.175.212.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 04:17:59 -0800
Subject: Re: [PATCH RFC 11/39] KVM: x86/xen: evtchn signaling via eventfd
To:     David Woodhouse <dwmw2@infradead.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-12-joao.m.martins@oracle.com>
 <874d1fa922cb56238676b90bbeeba930d0706500.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <e83f6438-7256-1dc8-3b13-5498fd5bbed1@oracle.com>
Date:   Mon, 30 Nov 2020 12:17:54 +0000
MIME-Version: 1.0
In-Reply-To: <874d1fa922cb56238676b90bbeeba930d0706500.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/20 9:41 AM, David Woodhouse wrote:
> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>> userspace registers a @port to an @eventfd, that is bound to a
>>  @vcpu. This information is then used when the guest does an
>> EVTCHNOP_send with a port registered with the kernel.
> 
> Why do I want this part?
> 
It is unnecessary churn to support eventfd at this point.

The patch subject/name is also a tad misleading, as
it implements the event channel port offloading with the optional fd
being just a small detail in addition.

>> EVTCHNOP_send short-circuiting happens by marking the event as pending
>> in the shared info and vcpu info pages and doing the upcall. For IPIs
>> and interdomain event channels, we do the upcall on the assigned vcpu.
> 
> This part I understand, 'peeking' at the EVTCHNOP_send hypercall so
> that we can short-circuit IPI delivery without it having to bounce
> through userspace.
> 
> But why would I then want then short-circuit the short-circuit,
> providing an eventfd for it to signal... so that I can then just
> receive the event in userspace in a *different* form to the original
> hypercall exit I would have got?
> 

One thing I didn't quite do at the time, is the whitelisting of unregistered
ports to userspace. Right now, it's a blacklist i.e. if it's not handled in
the kernel (IPIs, timer vIRQ, etc) it goes back to userspace. When the only
ones which go to userspace should be explicitly requested as such
and otherwise return -ENOENT in the hypercall.

Perhaps eventfd could be a way to express this? Like if you register
without an eventfd it's offloaded, otherwise it's assigned to userspace,
or if neither it's then returned an error without bothering the VMM.

But still, eventfd is probably unnecessary complexity when another @type
(XEN_EVTCHN_TYPE_USER) would serve, and then just exiting to userspace
and let it route its evtchn port handling to the its own I/O handling thread.

	Joao
