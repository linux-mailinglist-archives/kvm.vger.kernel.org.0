Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B2A4608C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 16:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbfFNOVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 10:21:52 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:38289 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfFNOVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 10:21:51 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hbn5M-0007a1-1S; Fri, 14 Jun 2019 16:21:44 +0200
Date:   Fri, 14 Jun 2019 16:21:43 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@amacapital.net>
cc:     Dave Hansen <dave.hansen@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
In-Reply-To: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
Message-ID: <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com> <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1104140577-1560522104=:1722"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1104140577-1560522104=:1722
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jun 2019, Andy Lutomirski wrote:
> > On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> > 
> >> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> >> This patch series proposes to introduce a region for what we call
> >> process-local memory into the kernel's virtual address space. 
> > 
> > It might be fun to cc some x86 folks on this series.  They might have
> > some relevant opinions. ;)
> > 
> > A few high-level questions:
> > 
> > Why go to all this trouble to hide guest state like registers if all the
> > guest data itself is still mapped?
> > 
> > Where's the context-switching code?  Did I just miss it?
> > 
> > We've discussed having per-cpu page tables where a given PGD is only in
> > use from one CPU at a time.  I *think* this scheme still works in such a
> > case, it just adds one more PGD entry that would have to context-switched.
>
> Fair warning: Linus is on record as absolutely hating this idea. He might
> change his mind, but it’s an uphill battle.

Yes I know, but as a benefit we could get rid of all the GSBASE horrors in
the entry code as we could just put the percpu space into the local PGD.

Thanks,

	tglx
--8323329-1104140577-1560522104=:1722--
