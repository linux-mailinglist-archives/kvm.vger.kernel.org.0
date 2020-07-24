Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3A22CC7A
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgGXRny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGXRnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:43:53 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43440C0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:43:52 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so5676433pgh.3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aaWhQPcSW3bE7rs+REjPzCquXYXIKucEYvw8vc6PND4=;
        b=GhnZGzFM9H5MZ1G8rKO9LRqg8IW3cO1w1wH/BXcQWPilam/lAlnkxGLmZrE9vV4u52
         K4DmyhZRZKHcPv0GEdH0K9KyLtYBYiIg8Y7BKPfji1nPew2uVmw2Cu0KJWgn0+QrhCy6
         J33pUtSnzj+iojGpXI+KpUUcr8S8iTr9Qn8UQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aaWhQPcSW3bE7rs+REjPzCquXYXIKucEYvw8vc6PND4=;
        b=LlCthZyRJiJ8qrMfeNanrXbZt8ynX9RuMHHXgjerLaoyBJLTCd3QOVPZHfmdc/nsa2
         8PL2pSDR90ChfR35tEbHbRuwqDrUggAizHiYJvhHrrT3sZJs5pOc7hXoW0ZQOs2hwBkx
         uDmI0vFg3pXzpjU9aTKBxrlgKrrSOl2p1kk9//p2NwIQRK1+5oD9HRczT2kfNT0IH83D
         eH2Skez8wNgCyk6rpl3P5ouz+73b3Vc1yh+7MtdnSOJOtsRF8CEOVBfdwmafHmOYFA0c
         CvphKQQEVMkXb0434zZm9VGQOzx2qSpXa5lTuGl0KD2RtoQ1AxcKeIbbmdFq/dqIhGEM
         Y+dA==
X-Gm-Message-State: AOAM530cBfKAp7flgiOXw9TXKQYmHVHaROCr+mO/N+TUqTe/4GbvBeh9
        BPrc4bS85rKUTU9gDUoIHodjhg==
X-Google-Smtp-Source: ABdhPJxm1pOTytr68wKlbjbawG7twhZ21XJYJ4ElyB1DPdJJWPc/wanYtwrYMS+M80MURBbJFVeEdw==
X-Received: by 2002:aa7:8096:: with SMTP id v22mr10436021pff.132.1595612631874;
        Fri, 24 Jul 2020 10:43:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o136sm6832398pfg.24.2020.07.24.10.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:43:51 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:43:50 -0700
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
Subject: Re: [PATCH v5 11/75] x86/boot/compressed/64: Disable red-zone usage
Message-ID: <202007241043.654ABB2@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-12-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-12-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:32PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The x86-64 ABI defines a red-zone on the stack:
> 
>   The 128-byte area beyond the location pointed to by %rsp is considered
>   to be reserved and shall not be modified by signal or interrupt
>   handlers. Therefore, functions may use this area for temporary data
>   that is not needed across function calls. In particular, leaf
>   functions may use this area for their entire stack frame, rather than
>   adjusting the stack pointer in the prologue and epilogue. This area is
>   known as the red zone.
> 
> This is not compatible with exception handling, because the IRET frame
> written by the hardware at the stack pointer and the functions to handle
> the exception will overwrite the temporary variables of the interrupted
> function, causing undefined behavior. So disable red-zones for the
> pre-decompression boot code.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
