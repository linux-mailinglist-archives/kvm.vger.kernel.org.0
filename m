Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA522CC6D
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGXRmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgGXRmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:42:22 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBC5C0619E4
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:42:22 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m16so4878492pls.5
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XwpNl/RSgSBBWaddv3urfADovlU2IQQNUsOQ5gJRgfo=;
        b=WU9slZt/60VXkdmS1OpvEXJ8mEGSsVlwVeByIAqKlB/4k4px26WInz/NJ5KOpt9C7f
         71G2bwjhucwf/lZMokI1XX2uVD8KUgvc/COEJEVz2m64NkyoZ/IbSDZCGM/fR83z0Ctk
         /0825/9u+PETjTUByM40o6Ma8MVukMZWFS+Ms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XwpNl/RSgSBBWaddv3urfADovlU2IQQNUsOQ5gJRgfo=;
        b=YV6z/mevLPYLtTPOqYCmvbRl7vIQC1Qda/VaoZv3xorY76IfJsQbW81tsCOnJUFWGA
         2/QpaX2brPxvH2V6Rx8+/X/1a8zsq52LOZ7cHD37b5jV7cBgdDkFX9UsSeNhaeDb/9hL
         DOs4bbRbgldKL2Lo9hpeefVeVVRrhCnz+w3sN9mp5HA7Qko0e0f6LmxzgEseKqju1bPK
         Y6WYJyJ42eWZ2+EOFz2srXP9/U0DCsN/5RPcpVUZckN0dmG7Guqy96cNy6ZbhizmoV2M
         qwlUcnwNcMNqK4DlrR/n+Hkmpb7FbcyM3Ko2mtwZUsYNggi2dfaENvdORcQt2aC+1RC4
         Q2kw==
X-Gm-Message-State: AOAM530EpeHJqZgNpsVt2r9Gn8Z8AN+KMalvZJnuLxVstYV3t5SatS41
        /wx4/TPpfS6ARbzLmZPTMma2LQ==
X-Google-Smtp-Source: ABdhPJzuAMEgACl6KnJ/cKznCSDX4BZLn6+ziD98Tx6G4Jv3sBo+cq7KrfZKMmeGTt0N9+kxSsv5rA==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr208834pjb.70.1595612541740;
        Fri, 24 Jul 2020 10:42:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p11sm6540646pfq.91.2020.07.24.10.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:42:20 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:42:20 -0700
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
Subject: Re: [PATCH v5 30/75] x86/head/64: Setup MSR_GS_BASE before calling
 into C code
Message-ID: <202007241041.71B4B3E@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-31-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-31-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:51PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When stack-protector is enabled a valid GS_BASE is needed before
> calling any C code function, because the stack canary is loaded from
> per-cpu data.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
