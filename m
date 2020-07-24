Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA522CC75
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgGXRnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgGXRnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:43:09 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A077EC0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:43:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m22so5665613pgv.9
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sd5Rp6atrzE1Stcg3iirVnf9ToDQSXxRMnjLTBZ9L1A=;
        b=VWFQY0cDmbN0RBRUPgEZB4t35+VutKPpoaFz/9Te/2hqGPRJlr4gQQD20xOnEsAalg
         q4QdepCDOJhFDcxkYOx0eWXU914L7Wlxsg17nmn6JKAJcVOD226V1u+tZy10pc8p4cZH
         9pTdR/jBEBTnCN1m1IfLHJtg1L0c15Pimq0k8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sd5Rp6atrzE1Stcg3iirVnf9ToDQSXxRMnjLTBZ9L1A=;
        b=OB3q996Gv7spVwcg4a/X03CdYgZ9QPFrxhXzIvou100IQXYsxrDM9onXfFXlhvcbOB
         4TrpdCUyIosD4RpySvEPSApQfucC9j0LsFPlG2AHuJL79qsKqUucP3z6UmtMk1j1To7Q
         lA/mJe61Obyo59afl73fAS1tT1IZLAUAiz2As1i8deX/8CJIoEIAvqhmChm+G7WSXHwW
         RWOfumSt0THKUCoWLZrKJ3xOHFMmkMyHjflkyLSzchs+hnBwAd3Xa7hJ05zwPjpIzzdQ
         LIc9DdR1+0m7A6ud3V2VlIjVvrneDLC6WF/B7sf1uDkpVXi4W3y1upPPXEN47WRx6Wmu
         f23Q==
X-Gm-Message-State: AOAM530G/oEA7iNidaALa5uL+/VPAHmfSjatcJ4TF6vOiEZWGlvI+9AM
        /Y907CrsZdQWWSAqNObvmnw7yg==
X-Google-Smtp-Source: ABdhPJwJFv2Oz78lM4tZKg9Jhv4RklfsNq7Gh1Z0ycsFgw9wKR0oBpge+dRt0td8MxgcFpPTLwKJLQ==
X-Received: by 2002:a62:a217:: with SMTP id m23mr9922513pff.291.1595612589235;
        Fri, 24 Jul 2020 10:43:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u16sm6647629pfn.52.2020.07.24.10.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:43:08 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:43:07 -0700
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
Subject: Re: [PATCH v5 33/75] x86/head/64: Switch to initial stack earlier
Message-ID: <202007241043.96A920ADEC@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-34-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-34-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:54PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Make sure there is a stack once the kernel runs from virual addresses.
> At this stage any secondary CPU which boots will have lost its stack
> because the kernel switched to a new page-table which does not map the
> real-mode stack anymore.
> 
> This is needed for handling early #VC exceptions caused by instructions
> like CPUID.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
