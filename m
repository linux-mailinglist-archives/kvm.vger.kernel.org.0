Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD54822157E
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgGOTt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgGOTtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:49:25 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3CBC08C5CE
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 12:49:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k4so2804001pld.12
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 12:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yppoieqawtommMNv7F4xEsaylvTK3ZvGj7dcQjgO2TY=;
        b=j2qfngMt1we3l0IhZifI4twKJ3j3kBQ/HIpn7YZ5j2qvGCpY3D4CxXVvbwFlxonJnk
         6FWAS/JQzC3Vr2RY57kmgM9BiR+ZrBL3UMBVX0Dg1AEdjzFvwUMCdolO9hvbOeEsYa6u
         jBGIyYHDqd0rQYUMQHt3Rxit3HX4mUF8GqeNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yppoieqawtommMNv7F4xEsaylvTK3ZvGj7dcQjgO2TY=;
        b=kNKBfWMa4ivPdutgf5bm6tspRZy8s/DWf3XSMdc7li9cs9ynCdz4LoX4mKZtloxsQL
         3HfFra6y5V4nelMP1EoDDZNAwFo363wFs/DrO8OPlyC2lot+s7c4jAcJ3pkFegBCyROs
         Xpu5MKl2p4mwYeEJcYwDAhzhPiU1vJfaI1s0yYTUATwmrI2s7QUbAgoBPLX9p+uv4cpq
         k807sxCzGuBjUTMEUolTxPSRq/SX+QHYgjWOoNm0NjuXb6HXEQLRypDbBJcSTG2eCSgm
         XM58D+f/eOBTk6D3/S61vujSiak5d9TukLzyTzL3o+nV1bg+i+bThwJLKWVp+UGaa1kU
         DjRQ==
X-Gm-Message-State: AOAM533pAf1P0NBy58wwBTlu6O2b/pEyiBBkfE47rMp2QDkJh7iKn6z5
        ZwckffvzUicGdhHais0Z3LsN9/W08hs=
X-Google-Smtp-Source: ABdhPJxvA58SlKkMWKAljrVfZntLrDAODkXc0OEIDnErZntti/oMHX7TUTMJUyPo0nAVuQc7dj8q2g==
X-Received: by 2002:a17:902:8c91:: with SMTP id t17mr825746plo.235.1594842565095;
        Wed, 15 Jul 2020 12:49:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g7sm2685716pfh.210.2020.07.15.12.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 12:49:24 -0700 (PDT)
Date:   Wed, 15 Jul 2020 12:49:23 -0700
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
Message-ID: <202007151244.315DCBAE@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-71-joro@8bytes.org>
 <202007141837.2B93BBD78@keescook>
 <20200715092638.GJ16200@suse.de>
 <202007150815.A81E879@keescook>
 <20200715154856.GA24822@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715154856.GA24822@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 05:48:56PM +0200, Joerg Roedel wrote:
> It is actually the CPUID instructions that cause #VC exceptions. The
> MSRs that are accessed on AMD processors are not intercepted in the
> hypervisors this code has been tested on, so these will not cause #VC
> exceptions.

Aaah. I see. Thanks for the details there. So ... can you add a bunch
more comments about why/when the new entry path is being used? I really
don't want to accidentally discover some unrelated refactoring down
the road (in months, years, unrelated to SEV, etc) starts to also skip
verify_cpu() on Intel systems. There had been a lot of BIOSes that set
this MSR to disable NX, and I don't want to repeat that pain: Linux must
never start an Intel CPU with that MSR set. :P

-- 
Kees Cook
