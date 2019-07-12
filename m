Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E971567241
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGLPXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 11:23:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44219 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGLPXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 11:23:55 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hlxOi-0003SX-Ud; Fri, 12 Jul 2019 17:23:45 +0200
Date:   Fri, 12 Jul 2019 17:23:44 +0200 (CEST)
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
In-Reply-To: <bfd62213-c7c0-4a90-b377-0de7d9557c4c@oracle.com>
Message-ID: <alpine.DEB.2.21.1907121719290.1788@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <2791712a-9f7b-18bc-e686-653181461428@oracle.com> <dbbf6b05-14b6-d184-76f2-8d4da80cec75@intel.com>
 <bfd62213-c7c0-4a90-b377-0de7d9557c4c@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019, Alexandre Chartre wrote:
> On 7/12/19 3:51 PM, Dave Hansen wrote:
> > BTW, the PTI CR3 writes are not *strictly* about the interrupt coming
> > from user vs. kernel.  It's tricky because there's a window both in the
> > entry and exit code where you are in the kernel but have a userspace CR3
> > value.  You end up needing a CR3 write when you have a userspace CR3
> > value when the interrupt occurred, not only when you interrupt userspace
> > itself.
> > 
> 
> Right. ASI is simpler because it comes from the kernel and return to the
> kernel. There's just a small window (on entry) where we have the ASI CR3
> but we quickly switch to the full kernel CR3.

That's wrong in several aspects.

   1) You are looking at it purely from the VMM perspective, which is bogus
      as you already said, that this can/should be used to be extended to
      other scenarios (including kvm ioctl or such).

      So no, it's not just coming from kernel space and returning to it.

      If that'd be true then the entry code could just stay as is because
      you can handle _ALL_ of that very trivial in the atomic VMM
      enter/exit code.

   2) It does not matter how small that window is. If there is a window
      then this needs to be covered, no matter what.

Thanks,

	tglx
