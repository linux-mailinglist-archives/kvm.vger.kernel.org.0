Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29792CC4F0
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgLBSVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:21:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLBSVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:21:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2IAGEP060754;
        Wed, 2 Dec 2020 18:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NvXmPPCGdV/IwlwX5m8biP5G7/GLn4XsbadAGDcm+UM=;
 b=aiAw6KzZJljLGyousX8MtLMVHd63vVGtR1foBlXW8W0fuHHk2AKDixJYmbwQ5Pil7kwy
 0qpdDkeRikZjMEH/vNv5XFOb57gzQDhAdKzpRZMepwCqVsi/VbRAGofkImCr9wXZWqbm
 NcOdTJmJ7LSNhsQjefYc3uF5eTau2wq83ViDfGa5q9WK1n+R0DywICH3yLVGkZEQ7r5o
 BweQnoSYe20iiXboQ20a1lUE3gKisul58g2Vxng52y10/Fo7GPMASeRU/FlJ71HNZqe2
 U13Y9NdtAqxTjdxltH0OtxcdxcUdduNko70s6cxDEhztIy4B92iqSbcKswOyhThmXhfj TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqt01w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 18:20:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2IABEx151364;
        Wed, 2 Dec 2020 18:20:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540f0rnrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 18:20:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2IKLKE003344;
        Wed, 2 Dec 2020 18:20:21 GMT
Received: from [192.168.0.108] (/70.36.60.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 10:20:20 -0800
Subject: Re: [PATCH RFC 02/39] KVM: x86/xen: intercept xen hypercalls if
 enabled
To:     David Woodhouse <dwmw2@infradead.org>,
        Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-3-joao.m.martins@oracle.com>
 <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
 <240b82b3-9621-8b08-6d37-75da6a61b3ce@oracle.com>
 <684bd330949528ecd352d4a381165c2681c0bae9.camel@infradead.org>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <9971be28-8a0f-a108-6d5e-6a891e395b5f@oracle.com>
Date:   Wed, 2 Dec 2020 10:20:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <684bd330949528ecd352d4a381165c2681c0bae9.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-02 12:03 a.m., David Woodhouse wrote:
> On Tue, 2020-12-01 at 21:19 -0800, Ankur Arora wrote:
>>> +             for (i = 0; i < PAGE_SIZE / sizeof(instructions); i++) {
>>> +                     *(u32 *)&instructions[1] = i;
>>> +                     if (kvm_vcpu_write_guest(vcpu,
>>> +                                              page_addr + (i * sizeof(instructions)),
>>> +                                              instructions, sizeof(instructions)))
>>> +                             return 1;
>>> +             }
>>
>> HYPERVISOR_iret isn't supported on 64bit so should be ud2 instead.
> 
> Yeah, I got part way through typing that part but concluded it probably
> wasn't a fast path that absolutely needed to be emulated in the kernel.
> 
> The VMM can inject the UD# when it receives the hypercall.

That would work as well but if it's a straight ud2 on the hypercall
page, wouldn't the guest just execute it when/if it does a
HYPERVISOR_iret?

Ankur


> 
> I appreciate it *is* a guest-visible difference, if we're being really
> pedantic, but I don't think we were even going to be able to 100% hide
> the fact that it's not actually Xen.
> 
