Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F030E2201CF
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgGOBYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgGOBYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:24:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78797C061755
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:24:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m9so676369pfh.0
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MV9eZ5OBgqTWIWwL9zpqkY6z/89bNn4vF0SnKjjFgTo=;
        b=As6jd7uWVm/c/uXeyIWNIkQkotsGzxOaaLvAOys2HbOeY1PyGOtFGLeOpMzbRY5fBW
         7CLyuBD/uXM+ETluLcq0AobqVWwAOu6WOxc9qIb+eJ501gis6a1t3VHFTz+mJN4Shyf5
         csynOX1q6Nqq6cA0TTETd6QbQtBcx5uQ7Pwsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MV9eZ5OBgqTWIWwL9zpqkY6z/89bNn4vF0SnKjjFgTo=;
        b=rh9X5yFyR6M2vcskffNRjhcfLdO2IiX3WULUx/DJmFTsBUzQE/eG6kEiFtYPMU5wr6
         UDVyYjZ76YUU3QmJnVfRYVqYjhmlXxlkHCk/ZWQU+Hugk1DilqtGnUE373WaY5U8p/3k
         +bjxL65DlHYzVVpXsiuJr7DIm2O+MJ6GY6DDgFs2+3KJdIAOz6F7sbqqbHUaQj9MEsUk
         xzO5TmDn1rhDoYzK/OOzXrfi0jOFr3+0EGzRg5XmkQcqMTDTnzThCxyIAHOx88akJx0t
         a/7MEffUk0GiXuWTbMGqe+U/1qJA5hhmHLbqEHDANRkWhipWopNAdfqguOEeMr+E81CN
         kmhw==
X-Gm-Message-State: AOAM532tMRTSuxaQ3UPHVvBJ86Nxr2/FwVMzeOqhurbeMVjJ2Lqwp/rp
        bCgbjDu+jg1kxIfJGDMip2sBNQ==
X-Google-Smtp-Source: ABdhPJwhN14rx8PS3l05EEyiO5yiHoXuh4AV1aLnKEa+PDj1AyXl4Y90zwpN7OBuitZH9VRBWPYvoQ==
X-Received: by 2002:a63:eb52:: with SMTP id b18mr5523396pgk.434.1594776286032;
        Tue, 14 Jul 2020 18:24:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z2sm328776pfq.67.2020.07.14.18.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:24:45 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:24:44 -0700
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
Subject: Re: [PATCH v4 17/75] x86/boot/compressed/64: Change
 add_identity_map() to take start and end
Message-ID: <202007141824.909CAE9EB@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-18-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-18-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:19PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Changing the function to take start and end as parameters instead of
> start and size simplifies the callers, which don't need to calculate
> the size if they already have start and end.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
