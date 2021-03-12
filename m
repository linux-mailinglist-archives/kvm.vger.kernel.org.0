Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BBA3398D6
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 22:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhCLVFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 16:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbhCLVFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 16:05:14 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFBDC061761
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:05:14 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id w34so15583895pga.8
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Dit5vwBS0Tl56hF0sV6VbghcZIe1S41EYMzdih+yBg=;
        b=nEeSswegnhhkAibhJ1uTCz7k5obZ5nRpCoOdtmVAkMw2qaaCjJhhVDtmoL4tNpnCDw
         Y5LFSWSrhdqOAuH/HVKJ4dk5mN5Mx6FvXYQxPN2A7CDRD9SK5Oc4qZ5qKjf/y10yIm+U
         OSKK9/uMf/AV42XbKI7nsC/a4baXpBGqGB8GsManeYAWIrs59hulg3oAnNh9jUEjTB66
         vNO8UAvI9plmjN4fIXrVe6H2bUJUzRmL67aCRXe27F25eXLrkmwsdExayHAA4a9qeQo8
         Vtf8UudYTpY17b50gdeUC06E0XHFn37p5YCbAkpbpoA8ra/9ybWm42/JtkMCKoUrew5E
         yXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Dit5vwBS0Tl56hF0sV6VbghcZIe1S41EYMzdih+yBg=;
        b=k62ONNRz4fDG1yJcmIz/uVxyc7/n99RMmWwx2/2Gw6f2YqO18gYuBpeTV0MCkP4v08
         jSiUZPGikMarOlkxn1PdOAR1KjCp+DWHLRtwn+AE07sH2uFaH+RY7YDxusGK39M21yBH
         QV8CQK71ZPxZj314WAoKB54bXNyM9DJenTrAV/OCIYyST3Z9SY9GJ+hR8pb9gp/ynOLE
         tw1VAHQQzZJlBIUJbH6k8Oce/JMY8pwq2qre3vrq+9GMiHBEm8wjaRoX8YSR2B9549mM
         tP6678KXkXrUFg8psNo1CXLewNns9fIhRjy/GCpQNWG/HsdMU9hPpgUr13MbHDKp0o2c
         Nw9A==
X-Gm-Message-State: AOAM532BVhbX+OXKA+WLnDrE2sCDhlp6zaugmdWtgKBNMMIfZsFxQOib
        eEQfAdYyOygnV9q45n3LqKuc3g==
X-Google-Smtp-Source: ABdhPJzmemUX7SbHrAbNu7g0mrdTwUprvem2ml8WOxUCNjRg9YPyfEYgNbttg2HkiAkobkQsrqU4rQ==
X-Received: by 2002:a63:f14e:: with SMTP id o14mr14118322pgk.260.1615583113422;
        Fri, 12 Mar 2021 13:05:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id v18sm6632395pfn.117.2021.03.12.13.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:05:12 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:05:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 01/25] x86/cpufeatures: Make SGX_LC feature bit depend
 on SGX bit
Message-ID: <YEvXgpqvwH2O/5pE@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <eaf02a594f0fb27ab3f358a0effef5519f4824e8.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaf02a594f0fb27ab3f358a0effef5519f4824e8.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> Move SGX_LC feature bit to CPUID dependency table to make clearing all
> SGX feature bits easier. Also remove clear_sgx_caps() since it is just
> a wrapper of setup_clear_cpu_cap(X86_FEATURE_SGX) now.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
