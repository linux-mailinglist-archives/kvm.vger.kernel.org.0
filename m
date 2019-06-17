Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A645248CD4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 20:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfFQSpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 14:45:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfFQSpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 14:45:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HIhvF7186461;
        Mon, 17 Jun 2019 18:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=GOIdRAMf3skF4wPK2T/7fFj0vhfi1GT6kR2ybYgOAu4=;
 b=lljcPfBpWWXCHaf1yRMmXyfI54fHwvCFKfK5VIao6y/jBGDnvk52ml8ocSTuVDbgc2QO
 aKpxdSEeWRAAE+4oDoqRrIrhX+jfnrFlj7QNLaYUL0F/6MzY/SzEzmD1f6vEiHByXW49
 VI5gQ1ROqihrvrj4+AK0i3Ww+1kYqFVi58GQ0JM//3tp5uKq7RYNjAPJf5QPQ90/6ssZ
 kh8E6dIhQMuR1uTOnbVXsoqrYQL40V88lnlUVGONOr9O9ZVkcJjKoy+5QYdfAgjFfDej
 Jv53Hqeo8nSxxDhrbBtZbtWsG6GEfXzg37XQNCJA9pfhAEwU7SeLpbHIik7nMCKfnIBS xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t4saq83g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 18:44:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HIhXeI066471;
        Mon, 17 Jun 2019 18:44:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t59gdcub9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 18:44:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HIiDdo015527;
        Mon, 17 Jun 2019 18:44:14 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 11:44:12 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id DF1D76A0120; Mon, 17 Jun 2019 14:45:36 -0400 (EDT)
Date:   Mon, 17 Jun 2019 14:45:36 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Message-ID: <20190617184536.GB11017@char.us.oracle.com>
References: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
 <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
 <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
 <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 11:07:45AM -0700, Dave Hansen wrote:
> On 6/17/19 9:53 AM, Nadav Amit wrote:
> >>> For anyone following along at home, I'm going to go off into crazy
> >>> per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)
> >>>
> >>> But, I was thinking we could get away with not doing this on _every_
> >>> context switch at least.  For instance, couldn't 'struct tlb_context'
> >>> have PGD pointer (or two with PTI) in addition to the TLB info?  That
> >>> way we only do the copying when we change the context.  Or does that tie
> >>> the implementation up too much with PCIDs?
> >> Hmm, that seems entirely reasonable.  I think the nasty bit would be
> >> figuring out all the interactions with PV TLB flushing.  PV TLB
> >> flushes already don't play so well with PCID tracking, and this will
> >> make it worse.  We probably need to rewrite all that code regardless.
> > How is PCID (as you implemented) related to TLB flushing of kernel (not
> > user) PTEs? These kernel PTEs would be global, so they would be invalidated
> > from all the address-spaces using INVLPG, I presume. No?
> 
> The idea is that you have a per-cpu address space.  Certain kernel
> virtual addresses would map to different physical address based on where
> you are running.  Each of the physical addresses would be "owned" by a
> single CPU and would, by convention, never use a PGD that mapped an
> address unless that CPU that "owned" it.
> 
> In that case, you never really invalidate those addresses.

But you would need to invalidate if the process moved to another CPU, correct?

