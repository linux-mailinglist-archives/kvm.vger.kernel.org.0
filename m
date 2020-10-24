Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915C2297A57
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 04:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759110AbgJXCSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 22:18:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:33753 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758993AbgJXCSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 22:18:00 -0400
IronPort-SDR: 2RH/FNdOG9AFkgbvximiRNomPfJAF/xK9xaGkwbnmgbD6w3nXjBD1uyZBdBCNxtnRUKKngZ0cj
 AQMY/e7ep5sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9783"; a="185460127"
X-IronPort-AV: E=Sophos;i="5.77,410,1596524400"; 
   d="scan'208";a="185460127"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 19:17:56 -0700
IronPort-SDR: 9RBacQdNkHhCcMZPaYO4BR1g1mtLwJ7NH2H78y41WLcX8q46n8YeT2V/LEPMrCB18zwA3SpbcR
 dIG+QDiK5Mxg==
X-IronPort-AV: E=Sophos;i="5.77,410,1596524400"; 
   d="scan'208";a="321931498"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 19:17:55 -0700
Date:   Fri, 23 Oct 2020 19:17:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: kvm: x86-32 fails to link with tdp_mmu
Message-ID: <20201024021754.GC7824@linux.intel.com>
References: <CAEUSe7_bptXLQQt5TkUoVitnFbnAF-KkyqQpcZnYuKgSGuBpPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_bptXLQQt5TkUoVitnFbnAF-KkyqQpcZnYuKgSGuBpPw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23, 2020 at 09:13:21PM -0500, Daniel Díaz wrote:
> Hello!
> 
> We found the following problem building torvalds/master, which
> recently merged the for-linus tag from the KVM tree, when building
> with gcc 7.3.0 and glibc 2.27 for x86 32-bits under OpenEmbedded:
> 
> |   LD      vmlinux.o
> |   MODPOST vmlinux.symvers
> |   MODINFO modules.builtin.modinfo
> |   GEN     modules.builtin
> |   LD      .tmp_vmlinux.kallsyms1
> | arch/x86/kvm/mmu/tdp_mmu.o: In function `__handle_changed_spte':
> | tdp_mmu.c:(.text+0x78a): undefined reference to `__umoddi3'

The problem is a % on a 64-bit value.  Patches incoming, there's also a goof
in similar code that was tweaked last minute to avoid the %.
