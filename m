Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8BE22CCA0
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGXRyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXRyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:54:11 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B2AC0619E4
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:54:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so5708744pgq.1
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LlWadNnJdj0hYYYVqCSZw2hjiyDxpJ2Kj8kn/NHt3FY=;
        b=atxoVVvNQ3oTazgRIDpHxSGrFLt9cvtoIBlvch0KQdY3aDyXvLQIdUzTcezi4vTG7R
         p3oklZStvCkO8gbZjqGkGxlAitCYYYinGGGKXpTA/1ZkFvIU2Ri3ri/cv2Fi2+1owHn3
         aDPZiQhkJ2XnheLh3/Pzmn1G0Q2Js7lTuAUNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LlWadNnJdj0hYYYVqCSZw2hjiyDxpJ2Kj8kn/NHt3FY=;
        b=jjeqdQwbH0oEB/rkvFhZ63L0EJE6lffJvg1kuBZ75Gs74qUzn5EUOB75m8BoF00JkB
         DVnaUN0sSjlkN+jszP87Im7bB2KiHD9IdhfK5+eZmWoLKZ1nGlZ6cll8NyoHi+0zJCN7
         ufuT/ZJkvtmuJY5do6+5sTKFSzyH3z1M6qUKvxpeQwPbmB5A4w7T69puMK6OJigzaS2O
         uTIjx/CYrbjQlAH0f1FP7aTO4OMIeTIrVU3tNkcD7ru0l7BeZaDebq9UJeI69NcfxCPO
         eIqJdcGltet2gkR52wD/sAZJH2a81p7MrCJZ4Jk2BMXyTIlJsOO/J7QZjtfuDufcbbQe
         0hZQ==
X-Gm-Message-State: AOAM532PGywTUBbsDYIlzMZHM/LOdpkH+x9jpax7YWITf3eTJIaMayYw
        CuhgF7HyPm698gzt1ejW9o3Il2dKsgY=
X-Google-Smtp-Source: ABdhPJwAqrIfdoT4BFkrasAiJFdaIdj3r/Ze/FIypWTH8bIiiBhHfRqSOlNvvGH0vC6qTvZaO894kw==
X-Received: by 2002:a63:e241:: with SMTP id y1mr9814521pgj.410.1595613251093;
        Fri, 24 Jul 2020 10:54:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id my16sm3221207pjb.43.2020.07.24.10.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:54:10 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:54:08 -0700
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
Subject: Re: [PATCH v5 39/75] x86/sev-es: Print SEV-ES info into kernel log
Message-ID: <202007241054.B7E226E8@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-40-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-40-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:03:00PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Refactor the message printed to the kernel log which indicates whether
> SEV or SME is active to print a list of enabled encryption features.
> This will scale better in the future when more memory encryption
> features might be added. Also add SEV-ES to the list of features.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
