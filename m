Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF32522CC9C
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgGXRwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXRwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:52:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7605EC0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:52:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id md7so5727086pjb.1
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pJMZ9swT3K3bqjJGXw2k3ORIxQ+qFSg1qs4vP+1tpg4=;
        b=cdWoE2eg0lqtaBCE7gX8/22rPZSJybcSuLoAOGnkDhjuuDHjBqXvxoqznKJrXHU3o1
         iTxCtOeQqhFXAo17sRdniHvJKXR9VakV+aww3rop+nAi5XFiPGcfGlfmBDL//k6IuZ7a
         IW2nzon8XqUePb5x1bKZ2zyLYXpunn4GzgxYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pJMZ9swT3K3bqjJGXw2k3ORIxQ+qFSg1qs4vP+1tpg4=;
        b=tYbEibYXiTt+D2RS9TTxSmXi2frDcRSgKca/E0tHKBA0l8UAZm4lSYLy9lPQIPzm2N
         /iNwoosUaaeMzVlN2vCU3F1So09NEMQdxxS67CtWd2uJGPOufkhTrrBuqs1A+ogIFEy7
         x96tu5NKXUmtNE4q7nbEhmLoBBSCC9nxu3fT4un1Zsd5KC89c1t+RuAXIosV/xHTL1u9
         sZWjmj0bBRAjVoUFHswflJrXoH/wQ8qiYzCVIkUqW1uK6eOKtxOUdSfLvB4zXBkAUL6G
         MCR0aTzwJYR1zHRU6/dWMdCKkGoCeetuQf169WC+ArXRyt15SuDrznHyGSEbz17UK0dd
         F+Yg==
X-Gm-Message-State: AOAM532216dAY2+l7PiLFFbFPjNMX0NqxoOQp+h0FqZG2hpbVzNqB3tB
        vFjsk3OI3uFTBER9lA+0ep/9nw==
X-Google-Smtp-Source: ABdhPJwHNZHpjJqrSuBBG12NUV/AuorcdxM+aZufctkjPno4wSr16cgJs0zf8rkmYhm9hIrfeFYV/A==
X-Received: by 2002:a17:902:e903:: with SMTP id k3mr9265756pld.148.1595613157934;
        Fri, 24 Jul 2020 10:52:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e28sm6990626pfm.177.2020.07.24.10.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:52:36 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:52:35 -0700
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
Subject: Re: [PATCH v5 34/75] x86/head/64: Make fixup_pointer() static inline
Message-ID: <202007241052.1B5F51DB4@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-35-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-35-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:55PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Also move it to a header file so that it can be used in the idt code
> to setup the early IDT.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
