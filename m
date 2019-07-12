Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F22672E8
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfGLQA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:00:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44314 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfGLQAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:00:55 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hlxyU-0004Ej-To; Fri, 12 Jul 2019 18:00:43 +0200
Date:   Fri, 12 Jul 2019 18:00:42 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com, graf@amazon.de, rppt@linux.vnet.ibm.com
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
In-Reply-To: <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
Message-ID: <alpine.DEB.2.21.1907121751430.1788@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de> <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019, Alexandre Chartre wrote:
> On 7/12/19 12:44 PM, Thomas Gleixner wrote:
> > That ASI thing is just PTI on steroids.
> > 
> > So why do we need two versions of the same thing? That's absolutely bonkers
> > and will just introduce subtle bugs and conflicting decisions all over the
> > place.
> > 
> > The need for ASI is very tightly coupled to the need for PTI and there is
> > absolutely no point in keeping them separate.
> > 
> > The only difference vs. interrupts and exceptions is that the PTI logic
> > cares whether they enter from user or from kernel space while ASI only
> > cares about the kernel entry.
> 
> I think that's precisely what makes ASI and PTI different and independent.
> PTI is just about switching between userland and kernel page-tables, while
> ASI is about switching page-table inside the kernel. You can have ASI without
> having PTI. You can also use ASI for kernel threads so for code that won't
> be triggered from userland and so which won't involve PTI.

It's still the same concept. And you can argue in circles it does not
justify yet another mapping setup with is a different copy of some other
mapping setup. Whether PTI is replaced by ASI or PTI is extended to handle
ASI does not matter at all. Having two similar concepts side by side is a
guarantee for disaster.

> > So why do you want ot treat that differently? There is absolutely zero
> > reason to do so. And there is no reason to create a pointlessly different
> > version of PTI which introduces yet another variant of a restricted page
> > table instead of just reusing and extending what's there already.
> > 
> 
> As I've tried to explain, to me PTI and ASI are different and independent.
> PTI manages switching between userland and kernel page-table, and ASI manages
> switching between kernel and a reduced-kernel page-table.

Again. It's the same concept and it does not matter what form of reduced
page tables you use. You always need transition points and in order to make
the transition points work you need reliably mapped bits and pieces.

Also Paul wants to use the same concept for user space so trivial system
calls can do w/o PTI. In some other thread you said yourself that this
could be extended to cover the kvm ioctl, which is clearly a return to user
space.

Are we then going to add another set of randomly sprinkled transition
points and yet another 'state machine' to duct-tape the fallout?

Definitely not going to happen.

Thanks,

	tglx

