Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB812201CC
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgGOBYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbgGOBYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:24:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58322C061755
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:24:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so883608pgq.1
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=disvEr8QTdkdT/FiP6nWZpfKiZAj+1GxhY8j6L4+VsQ=;
        b=QlGUunqmMzd7BXyHpekbCEW2V6nSjcB7yoyoPGH4TzD3d5B8mTW/71ZE2cJL8mK51k
         71ARRXSzT77AumtXxSrdaGYuwgbX2UQGZA8vfQJjrakWMO6AYGjVROqvp8NejS2m9Z2A
         7IYT8IbO38FLfB1a/Y4tOBuCZnK/Z5sSj09mI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=disvEr8QTdkdT/FiP6nWZpfKiZAj+1GxhY8j6L4+VsQ=;
        b=qPfI6FLphChRX6xI+v+BxJO6bDUJAxFs2qeZB3mbMFOswyEmt7MGP0BEnaF+IwPllU
         xY3vMrxdEPljBXaZzyWQ11taYEfgqXQxWAPuCRJoV7b6KtU5LrzjAXlVP2qsKD8U7OGt
         peWx7sKtBcge3rXoOzhs2GvC/S+PVBEKEyd+5UxcYBtaAi0Z98PFt7j0BFhpwEdzHwC7
         tiv4romhiXxTzNPKTBAZPhQ/NZS+i4NM/3/DhYYX0Ayj+qhMCfe2SKqX/cZ7lDrnCvhh
         k/5CFuep/pk7ScR6p9eTSc+oPT2xOGLkR3/feol7V3TXYjxc8QIPGxkJ4TDKDyjgWrnk
         rydA==
X-Gm-Message-State: AOAM5338Wb4kEIZmfVmR+mmyTvW8YXZMMYQSGeeG1iFq+b57ZGSsGvMB
        NNjbdRp9nLFE5P6NRDl1IZriuA==
X-Google-Smtp-Source: ABdhPJweUW+32ofnpX4MJsObP6q2/5f9TZOLrNQ+l84Tm/hPhwj19hU1a21zbXROqArF2N1b8PwEGw==
X-Received: by 2002:a05:6a00:15c8:: with SMTP id o8mr6820199pfu.286.1594776261955;
        Tue, 14 Jul 2020 18:24:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y19sm335301pfc.135.2020.07.14.18.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:24:21 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:24:20 -0700
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
Subject: Re: [PATCH v4 16/75] x86/boot/compressed/64: Don't pre-map memory in
 KASLR code
Message-ID: <202007141824.6D5B3BE7@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-17-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-17-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:18PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> With the page-fault handler in place the identity mapping can be built
> on-demand. So remove the code which manually creates the mappings and
> unexport/remove the functions used for it.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
