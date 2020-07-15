Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264A32201CA
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgGOBYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgGOBYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:24:09 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D81CC061794
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:24:09 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so706088plx.6
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rBR5AjI82R5bYhOng71+5jFKvQ0oN6P/Kk11F4Z3+zk=;
        b=n+kU5hvp8QX2eErdqh0W7QLokIV7OjxOGug3362dtYmAU15jXA2quaw1LOjlA2OxHr
         grTkzjMkDFKiGgnsiQ1p2YDXLg3DuC9x59mWeMy98rbQ5Kngg7FI+StxG6d9e+/dJMkM
         ujFENwTUf9nN1xF3xXq+X+clzZw1jOue0CTl4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rBR5AjI82R5bYhOng71+5jFKvQ0oN6P/Kk11F4Z3+zk=;
        b=sN51TXrhIqX8MA/bZxfYsc0JDhIKOMol0qLHx81EHotfBzW/uLk8dmlRkja6hQyF3R
         eCDDHVNS5AkjfQ9aPCiV28vjPgJPau1fSkZMRIY5GZqTuOMKDVILW7DzseF7rS8DfJWD
         uHD0LgpgcQAYL5YRde3KYZaZrpHyeI52zxCYp2mVrRgn0S/Xv2vdVZcVN8xQwDKsZ4P4
         1IKPqFEQTpzQBDzPYgde7wUnCXsjryPu5qP3AJZEJaJAJTfsxkkRJtrO8hpBKLWuQHBF
         w/8kpkL6VSf0KkWKMQ21XbwH8WXpet/iwEGF8fgCebDiwN5Guy3A3S3YL3JpeD5DMUY6
         CD3g==
X-Gm-Message-State: AOAM533dHjjJPN3lO0th53LT7Jv3Jtx+0/0mVPFFx9mlhjYCIPbPElaa
        H8tleOa+heX583i+DNZfVijjHg==
X-Google-Smtp-Source: ABdhPJw6NKyQlM4kooKTBPKRrF+2YxBrMmlRUoDFIuOrU0Oa7HnOhiNFeW3EcDZ1pSOeMms4CpZIuw==
X-Received: by 2002:a17:90b:243:: with SMTP id fz3mr7470339pjb.17.1594776248812;
        Tue, 14 Jul 2020 18:24:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j13sm263522pjz.8.2020.07.14.18.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:24:07 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:24:07 -0700
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
Subject: Re: [PATCH v4 14/75] x86/boot/compressed/64: Add page-fault handler
Message-ID: <202007141824.C00ADEDC0E@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-15-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-15-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:16PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Install a page-fault handler to add an identity mapping to addresses
> not yet mapped. Also do some checking whether the error code is sane.
> 
> This makes non SEV-ES machines use the exception handling
> infrastructure in the pre-decompressions boot code too, making it less
> likely to break in the future.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
