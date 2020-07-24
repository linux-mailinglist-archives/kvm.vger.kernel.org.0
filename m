Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF10322CCA2
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgGXRyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGXRyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:54:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEC5C0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:54:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k27so5701260pgm.2
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3zh6CKPu9OXN15zjWZk7WlElaxcoMcysSL6HQfo9H3E=;
        b=BbNuGRub6gajP1oXDi9LwdUymaGqj51igXR8/6ZLQKhDEfSjyi+vtEXaLGXxlqngob
         kJegiFXVFS80BXaVFZw1O/OKTg/9rxDkgjecPYAyHkfgMBDh/BX8tEvs/bqrbasncZoZ
         RQVIid6OkNAf+JNeU/aRV3dfwXuwxI59wPrxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3zh6CKPu9OXN15zjWZk7WlElaxcoMcysSL6HQfo9H3E=;
        b=EyfApKP7zVxf418puN0iUsEAp3gYIhobfQ08vMRu6fKBhYd41Wdg9Y+SdqtmhpBi9E
         Lm0L4DETvs9uB9Jx0WKvzQg0LGWF7xkFgLT59JIq6sOa4Pht9eT+LHcIp4DmXE/zvbtQ
         pXllGxAP7C+6zru2CN6xHzt4iiNjy8GVGzQ8LLiL57WdNgJLx5+wVx2pvXRjBLxC4fUs
         JOnbsnvbZ2R8yHf7ZFXfS5CAByEhG1EdBKbTWJtdAZNmDBOx2mK6pBeHFFlyhr+2o5QL
         QB4/EuERplqnsf/45+lsQfq9mMiNEjt1mx4Hv2PVT/ENfpTM4omLMpTJ7lDx9xFOIHQP
         Az2Q==
X-Gm-Message-State: AOAM533e0bQkCztqG+60ZQLZjEp2G1fnClyCYy5O6RKG1MjXzERz+53m
        YsdJUWQpGQ4h9sfpMWMIOWW3hA==
X-Google-Smtp-Source: ABdhPJzI1NNk18MRpvgt6+LY08/9F3MGjY/+aI5dG+MQzucT+SD3uVmkPKkrl3cYefTv0keng+DOCg==
X-Received: by 2002:a63:3d01:: with SMTP id k1mr9236832pga.71.1595613279983;
        Fri, 24 Jul 2020 10:54:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d29sm5683851pgb.54.2020.07.24.10.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:54:39 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:54:38 -0700
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
Subject: Re: [PATCH v5 38/75] x86/sev-es: Add SEV-ES Feature Detection
Message-ID: <202007241054.25B564BA61@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-39-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-39-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:59PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Add the sev_es_active function for checking whether SEV-ES is enabled.
> Also cache the value of MSR_AMD64_SEV at boot to speed up the feature
> checking in the running code.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
