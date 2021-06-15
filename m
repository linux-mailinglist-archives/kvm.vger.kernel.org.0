Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16AA3A7AE8
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 11:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhFOJkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 05:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhFOJjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 05:39:55 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8083C061574;
        Tue, 15 Jun 2021 02:37:47 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C8B851EE; Tue, 15 Jun 2021 11:37:45 +0200 (CEST)
Date:   Tue, 15 Jun 2021 11:37:44 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 2/6] x86/sev-es: Make sure IRQs are disabled while
 GHCB is active
Message-ID: <YMh06KmGITjU4eAf@8bytes.org>
References: <20210614135327.9921-1-joro@8bytes.org>
 <20210614135327.9921-3-joro@8bytes.org>
 <YMeC7vJxm0OVJJhr@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMeC7vJxm0OVJJhr@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 06:25:18PM +0200, Borislav Petkov wrote:
> Thoughts?

Okay, I tested a bit with this, it mostly works fine.

The lockdep_hardirqs_disabled() check in __sev_get/put_ghcb() was
problematic, because these functions are called also when no state is
set up yet. More specifically it is called from __sev_es_nmi_complete(),
which is called at the very beginning of do_nmi(), before the NMI
handler entered NMI mode. So this triggered a warning in the NMI
test-suite when booting up, I replaced these checks with a
WARN_ON(!irqs_disabled()) and also removed the BUG_ON()s.

With that it boots fine and without SEV-ES related warnings.

Regards,

	Joerg
