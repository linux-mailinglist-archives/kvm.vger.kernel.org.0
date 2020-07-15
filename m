Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA702201C7
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgGOBXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgGOBXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:23:49 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795AFC061755
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:23:49 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g67so867177pgc.8
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AtJMt5D7K9C8ql3zYlKfD8mfXyjKfGo9YIHofl3GNr8=;
        b=i6mXzKcIDfBhhNQRvvLg/C5UGIuMlqAh1ph4H7eqkHJDr7PuMbMBuSDLs83TP38yNB
         bTsbdAYiN8TVCvUTf3i2k44uwugHJxge/2LYPfWuuLuZ5XRPEeLUIzXPA7TaZAK1f0EG
         p+aeuoS5JQmDj4VQ5zoywN6JsJUFdTahr99K8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AtJMt5D7K9C8ql3zYlKfD8mfXyjKfGo9YIHofl3GNr8=;
        b=d/bGlHrfohhzkbwIBMPIWsQ02lcXSlOzhsiILIhcWJpZu+XJZgQc0Exz8LozXerzG7
         JUdW/OM8Y9a0ymLdT9Zyy0wGF+tGWylQCQ6TCfrQZ/vsL6tFun8r2fF5jvyWc8EvNKzl
         zkbeFY7nXdrLDL7DXCJ2rj/0imQSI3Zwz+WEV45XHQ5vAA8RTTzA/sqQ91u22GpiIog7
         hrfDsI1h/QlBGaqwMLS3kc/zqKpMN/itcYiLw1KmcLxbYf00GUnXliV3C5v814HLLcQX
         cwjkRhDVbRvbv2hNvC/MO5doheVsZ8nPe1vpbVRXSzXJXZ/N55LUZvwEeRWNP7gSDemb
         SJfg==
X-Gm-Message-State: AOAM532zWJpA27JbvgV1pn7HIbyeV8iIjFeOtG5C3kHmrwdxcuoH1TPn
        cV1+5B8H8stt/raOeVP7oIzZGA==
X-Google-Smtp-Source: ABdhPJyIl+WxpdHetqRs0iY1NDJGKOEkmNO3iE3VMFuHcXkxfBCWMMImxc6uFhuMgMteLTrgR+OaPg==
X-Received: by 2002:a05:6a00:2bc:: with SMTP id q28mr6683696pfs.250.1594776229062;
        Tue, 14 Jul 2020 18:23:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m3sm325734pfk.171.2020.07.14.18.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:23:48 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:23:47 -0700
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
Subject: Re: [PATCH v4 15/75] x86/boot/compressed/64: Always switch to own
 page-table
Message-ID: <202007141823.326D9DC102@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-16-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-16-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:17PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When booted through startup_64 the kernel keeps running on the EFI
> page-table until the KASLR code sets up its own page-table. Without
> KASLR the pre-decompression boot code never switches off the EFI
> page-table. Change that by unconditionally switching to a kernel
> controlled page-table after relocation.
> 
> This makes sure we can make changes to the mapping when necessary, for
> example map pages unencrypted in SEV and SEV-ES guests.
> 
> Also remove the debug_putstr() calls in initialize_identity_maps()
> because the function now runs before console_init() is called.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
