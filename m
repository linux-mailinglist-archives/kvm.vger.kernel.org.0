Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717E12C8E07
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 20:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbgK3T0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:26:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgK3T0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 14:26:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJFAHh010116;
        Mon, 30 Nov 2020 19:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=k2IvULPGlTPSH2d5C04hBupxMPjNibGgDLwGP6qaVSg=;
 b=U9WnAmFr6xUeNUib3qlI8r8HeYq+XBE8tnUXq5w8nMtk8MUIDeipfNjM0IDnTHT7iuyd
 ygeZL7sE5U27BdFU2aLXbg4yZSjfLB8Wuu+fyfxlInYg8bSYjUZkuyoorWHCo7WJ3YIm
 1YYRum+JTP8jZF16aGFba9g5Vr58daT0bXgV+lU7R+d6pnGZpYmtuTw6xFZYujZHA5mr
 yITZZ2Jc/L6oC0NX1G8BWLiEo1UwFb+mszriKMVJlFXDT3ra6eeyeQd9V+uQo27vYMZb
 gEFeWtgpeGH8Z2tsmbPWUZJRnOiuJoUv5jNHHNqk7iRfqLI0FvV+wqzSnUrEmo5x2pLF NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqewmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 19:25:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJGLrS109167;
        Mon, 30 Nov 2020 19:25:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404kybrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:25:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUJPHFD029341;
        Mon, 30 Nov 2020 19:25:17 GMT
Received: from [192.168.1.67] (/94.61.1.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 11:25:17 -0800
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
 <e83f6438-7256-1dc8-3b13-5498fd5bbed1@oracle.com>
 <18e854e2a84750c2de2d32384710132b83d84286.camel@infradead.org>
 <0b9d3901-c10b-effd-6278-6afd1e95b09e@oracle.com>
 <315ea414c2bf938978f7f2c0598e80fa05b4c07b.camel@infradead.org>
 <05661003-64f0-a32a-5659-6463d4806ef9@oracle.com>
 <13bc2ca60ca4e6d74c619e65502889961a08c3ff.camel@infradead.org>
 <35e45689-8225-7e5d-44ef-23479b563444@oracle.com>
 <fbeb5b70f4c6b036b71a58d4a2a13c534ed360a1.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <106892fc-83a8-d397-fd96-b5fdeda442d2@oracle.com>
Date:   Mon, 30 Nov 2020 19:25:12 +0000
MIME-Version: 1.0
In-Reply-To: <fbeb5b70f4c6b036b71a58d4a2a13c534ed360a1.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/30/20 7:04 PM, David Woodhouse wrote:
> On Mon, 2020-11-30 at 18:41 +0000, Joao Martins wrote:
>> int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>> {
>> ...
>>         if (kvm_hv_hypercall_enabled(vcpu->kvm))
>>                 return kvm_hv_hypercall(...);
>>
>>         if (kvm_xen_hypercall_enabled(vcpu->kvm))
>>                 return kvm_xen_hypercall(...);
>> ...
>> }
>>
>> And on kvm_xen_hypercall() for the cases VMM offloads to demarshal what the registers mean
>> e.g. for event channel send 64-bit guest: RAX for opcode and RDI/RSI for cmd and port.
> 
> Right, although it's a little more abstract than that: "RDI/RSI for
> arg#0, arg#1 respectively".
> 
> And those are RDI/RSI for 64-bit Xen, EBX/ECX for 32-bit Xen, and
> RBX/RDI for Hyper-V. (And Hyper-V seems to use only the two, while Xen
> theoretically has up to 6).
> 
Indeed, almost reminds my other patch for xen hypercalls -- it was handling 32-bit and
64-bit that way:

https://lore.kernel.org/kvm/20190220201609.28290-3-joao.m.martins@oracle.com/

>> The kernel logic wouldn't be much different at the core, so thought of tihs consolidation.
>> But the added complexity would have come from having to deal with two userspace exit types
>> -- indeed probably not worth the trouble as you pointed out.
> 
> Yeah, I think I'm just going to move the 'kvm_userspace_hypercall()'
> from my patch to be 'kvm_xen_hypercall()' in a new xen.c but still
> using KVM_EXIT_HYPERCALL. Then I can rebase your other patches on top
> of that, with the evtchn bypass.
> 
Yeap, makes sense.

	Joao
