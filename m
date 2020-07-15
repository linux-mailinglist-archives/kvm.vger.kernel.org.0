Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494072201DF
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgGOB33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgGOB33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:29:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB41C061794
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:29:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k27so920966pgm.2
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E7jBTUN+q1MFSKfnbOqN34m9kwFSgfqPOQP4XPd3q20=;
        b=TNYBRU3rt8vQTV68BnfmZdJfy3duhGTQeyyt+yRIYHSFoG9BCK31dGBtdbo1N+7tbt
         hrI79dVb1fe0ntLBKMc4WL1x6kMHbfxRiEDmzwpmQialwoYqiYVbPw6KH1WAcausmpbJ
         J7PsSsy2KNGZvf69+Tloxy+LXK3NkkzxsHi28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E7jBTUN+q1MFSKfnbOqN34m9kwFSgfqPOQP4XPd3q20=;
        b=dPtz2r6T+ur4169tC82U7XQYbkvo4lZzy7rj4MT0sQS0FTLUqIyb87vX2kGb1CUOct
         nwx5yekngOqrXe0QJpW3z3THAA6wD5OWSYZAuavip+DT5Oc8PHU0QfbWpm6z1aH7Uh6P
         wuzAuvQv8rbdxeMHxgyBd+gU+d3A/U087cXlwsHA+Tmk0Ybfy4RDggcpPRs3mhr8jtz+
         SbJ0cZASd34DrYERQDhI5qZxbeG7A6cIMdsdF6WuGndmrvN+hJmGAzGqESVo6K8f/RFz
         YGe05hFRonCjA/GK83jt4+al6jg1OXeEzPrNL+HoXWtpxEJag5m+Um4n//jQkdiDcLRh
         fmNA==
X-Gm-Message-State: AOAM533qfiOAR+030OG9t2YibRuW51aSPBoTqKfJGwrFnKxZNtzU92m5
        tmo9WqdhGkt89lTWykj3hLaqpg==
X-Google-Smtp-Source: ABdhPJzuAx2MU3/IFIN5Fo5Om9COSAdzzeAOeGxBQatzJZdo3a9WrMaQ/5hz7S1dWNOewUMx6ayNgg==
X-Received: by 2002:a63:308:: with SMTP id 8mr6053673pgd.112.1594776568754;
        Tue, 14 Jul 2020 18:29:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d37sm311670pgd.18.2020.07.14.18.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:29:27 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:29:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
Subject: Re: [PATCH v4 29/75] x86/idt: Move two function from k/idt.c to
 i/a/desc.h
Message-ID: <202007141827.5A5D64454@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-30-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-30-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:31PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>

I'm not a huge fan of the Subject. :) Maybe:

x86/idt: Make IDT init functions static inlines

> 
> Move these two functions from kernel/idt.c to include/asm/desc.h:
> 
> 	* init_idt_data()
> 	* idt_init_desc()
> 
> These functions are needed to setup IDT entries very early and need to
> be called from head64.c. To be usable this early these functions need to
> be compiled without instrumentation and the stack-protector feature.
> These features need to be kept enabled for kernel/idt.c, so head64.c
> must use its own versions.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

But regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
