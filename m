Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACA822CCB5
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgGXR5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGXR5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:57:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3711AC0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:57:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k1so5711931pjt.5
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kMaFwW8t3IfIMVggiKK5OHJuDKp9jaqqEbc7QFoh/rs=;
        b=CJVXb5n6JR5dWMx2tAJLg0bcwhbi4VQqyjo9ptukfmM2mUWjqZH+jR4n9It2TyDcL6
         DImQfQV/+SB3ARDdJ+h56qcR6WkyApTGi8w3+KG7PXrxzaipl3pJotCGKEKeeIXseiao
         kT7/1zeJ2y2o+p3sPye32JbtH4ABoCfClNQCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kMaFwW8t3IfIMVggiKK5OHJuDKp9jaqqEbc7QFoh/rs=;
        b=oTnL5Zk1FqMadT0mZTG26TEzvlpGRNqAXJl94mGOuhBZ+fS3t2OHRVCsg03s+tzPGi
         BswdQDdyR6oh6R7Ye9jcN7ZWYdoFKMpZ/kaXOnfm6hNuaUK8exEjfbz+HwJCCuCF1Ukv
         iLFyLiaSVdRI1omnHUXYBbEqSnTqgUv82eAf+FKbbHWHVbux36wD0uSCni0DnH0hh1/q
         1dscVqJ5sOTFDHtWmIKGSzNWGpBMFSJrQHpljS/SKZnmo0MeISNRRVG1j6yIf9r73FsH
         5cxrGtr8uAjay1ryKVzLiNhKZX6eNVDTqbAj1BfoPPBLCOwR5KpX88YXwMJr/eL0DJzR
         DTqA==
X-Gm-Message-State: AOAM531HwPbEL5wIH1eJgN9pX8iF7C2rapJkZhscOu0iu5svvjSPRw23
        lX3z3By0OjPiUKQqZx8pigb/LQ==
X-Google-Smtp-Source: ABdhPJwT1ivDifcMkDJuyupKZW8COKgntYhL394BofNxgSA9BgFQyVU125t2d5Ivjc4ONMX5CLywvA==
X-Received: by 2002:a17:90a:ed87:: with SMTP id k7mr6699745pjy.31.1595613458750;
        Fri, 24 Jul 2020 10:57:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g6sm6950620pfr.129.2020.07.24.10.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:57:37 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:57:36 -0700
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
Subject: Re: [PATCH v5 70/75] x86/head/64: Don't call verify_cpu() on
 starting APs
Message-ID: <202007241057.2D78C2A41B@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-71-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-71-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:03:31PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The APs are not ready to handle exceptions when verify_cpu() is called
> in secondary_startup_64.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Thanks for updating this! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
