Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B193A4423
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhFKOgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhFKOgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:36:11 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB22C061574;
        Fri, 11 Jun 2021 07:34:13 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0aec00fa6ee867e791c992.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ec00:fa6e:e867:e791:c992])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B0AA21EC053C;
        Fri, 11 Jun 2021 16:34:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623422051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JGxv2dGnM8cqh24lNorMXXQYkTm9QOB8k1UUbsYV/vA=;
        b=PH73syyPX9IvgmsETxZdfxrCSsZMWTcA/pYMQegpkdofXR1cXEg1XEPuJS9MYErLFdFNqX
        ITpfIWTUsaN5vpq8JBkZPeXh5LbRBqlJGvqLVqRf8JiTAeW7VP9luNAuq1h46swcUr7Uja
        MtzdkWa9Pi00OJI9vUBJ/0Onm7xcNq0=
Date:   Fri, 11 Jun 2021 16:34:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
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
Subject: Re: [PATCH v4 2/6] x86/sev-es: Disable IRQs while GHCB is active
Message-ID: <YMN0XT8Job08HfWH@zn.tnic>
References: <20210610091141.30322-1-joro@8bytes.org>
 <20210610091141.30322-3-joro@8bytes.org>
 <YMNtmz6W1apXL5q+@zn.tnic>
 <YMNxNEb/T3iF4TG8@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YMNxNEb/T3iF4TG8@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 04:20:36PM +0200, Joerg Roedel wrote:
> I am not a fan of this, because its easily forgotten to add
> local_irq_save()/local_irq_restore() calls around those. Yes, we can add
> irqs_disabled() assertions to the functions, but we can as well just
> disable/enable IRQs in them. Only the previous value of EFLAGS.IF needs
> to be carried from one function to the other.

Wrappers:

	sev_es_get_ghcb():

		local_irq_save()
		__sev_es_get_ghcb()

and the reverse.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
