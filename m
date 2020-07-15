Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338782210DD
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 17:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGOP0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 11:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgGOP0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 11:26:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2E2C08C5DB
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 08:26:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x9so2537386plr.2
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 08:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OVseGDlS5NduALoUhVbQMz2ayVd7lsCazvkJdrEWQVA=;
        b=kYphxsBDglzPvHIBCffGnlCguQJ5Jq0VYcOblzLx7EXfk29Rvu/bG7pBwbBpNwzFXG
         +lD2Fb60wFmiV61BCGzq/Gs9UPJEvIkYkAw7CfcZN9nq8hf6m5XYh4qRJi90dSIrkeil
         VQFSgKQ9JBDSo0SH2E//vgbDwR4wEPOwmojY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OVseGDlS5NduALoUhVbQMz2ayVd7lsCazvkJdrEWQVA=;
        b=dnx3isH2EtlRL7frmKVqqAm9TG9Fomcliho2FRAoddX2FJ0wjCemWpYkM/t6+MA4Zs
         YQVfpCsj5+drn9Q1XlLdmxKQsM4F+9MEzdVlJFNRC1ibMJUxHWbf0L698jav8Yr4K9zG
         BwAG8mKlelURZBqc1UHJgTOjRuzpNQPo3g5vp6CrxKfLr2S18CaWrIx+DsWjRpmBcMxp
         eZdzHreuaUV3ZEj9Knb2EYQSgoHlrnz4l7sYCcZ4m1e52N7cZG0hRSKZHOAFcRgC07Nd
         ghpoAW8AR4SFhD56nWXBhfzRrouCg0c0qbSCKTmA6URi2ZErYHz1KB5RoYX36hzSUele
         /iuw==
X-Gm-Message-State: AOAM532V14Bynh5vj/eceWKCPsNxz993u6HtAylys5DPOU8HgnWsTjA5
        7t1tkvt0olg3FBcgZy0ZYUNDIA==
X-Google-Smtp-Source: ABdhPJztkAQ9Aa2pbyAHIkXtH9WpSQcQHYyGPARbbSQPgrfyf6qes0+MO+jyCy83QwcUYG4c4hENOg==
X-Received: by 2002:a17:90a:e987:: with SMTP id v7mr185305pjy.56.1594826776564;
        Wed, 15 Jul 2020 08:26:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j17sm2463861pgn.87.2020.07.15.08.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 08:26:15 -0700 (PDT)
Date:   Wed, 15 Jul 2020 08:26:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 70/75] x86/head/64: Don't call verify_cpu() on
 starting APs
Message-ID: <202007150815.A81E879@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-71-joro@8bytes.org>
 <202007141837.2B93BBD78@keescook>
 <20200715092638.GJ16200@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715092638.GJ16200@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 11:26:38AM +0200, Joerg Roedel wrote:
> Hi Kees,
> 
> thanks for your reviews!
> 
> On Tue, Jul 14, 2020 at 06:40:30PM -0700, Kees Cook wrote:
> > Eek, no. MSR_IA32_MISC_ENABLE_XD_DISABLE needs to be cleared very early
> > during CPU startup; this can't just be skipped.
> 
> That MSR is Intel-only, right? The boot-path installed here is only used
> for SEV-ES guests, running on AMD systems, so this MSR is not even
> accessed during boot on those VMs.

Oh, hrm, yes, that's true. If other x86 maintainers are comfortable with
this, then okay. My sense is that changing the early CPU startup paths
will cause trouble down the line.

> The alternative is to set up exception handling prior to calling
> verify_cpu, including segments, stack and IDT. Given that verify_cpu()
> does not add much value to SEV-ES guests, I'd like to avoid adding this
> complexity.

So, going back to the requirements here ... what things in verify_cpu()
can cause exceptions? AFAICT, cpuid is safely handled (i.e. it is
detected and only run in a way to avoid exceptions and the MSR
reads/writes are similarly bound by CPU family/id range checks). I must
be missing something. :)

> 
> > Also, is UNWIND_HINT_EMPTY needed for the new target?
> 
> Yes, I think it is, will add it in the next version.
> 
> Regards,
> 
> 	Joerg

-- 
Kees Cook
