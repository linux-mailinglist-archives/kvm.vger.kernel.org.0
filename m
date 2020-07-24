Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E373E22CCA8
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgGXRzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGXRzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:55:55 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D75C0619E4
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:55:55 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x9so4909548plr.2
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QrjebX+2MVOIfEwIWOQEBEmYNWrE9lHIByJGfCaahp0=;
        b=hpYudzwzACcZEpNTXqhIf8svOe4F5gdhGn3v/8i/VFeHAJKdvEe7O8ZFIQ/2xPOfM5
         eUZZk0JqNgrmR8+mnIW+v60vhGaERWbXIJj0woZtDy5keFrTIVcMoqzC0Bq/uE4CvYE3
         +ouQm9QjiTT6IYzRowgORlrhQ4w5uXgmCxi4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QrjebX+2MVOIfEwIWOQEBEmYNWrE9lHIByJGfCaahp0=;
        b=d2sSBbzjlQGYQmUU36n6tKGVfqejWENrG9naxoROA/ApPvap2cnn2miwk0diawgg0G
         UJ+XO3t10a3y8zMXgz7J6I4Eoa342/73WzDcOp5nOfdYtUnTqo7umh+fS2DYbPkXVrkU
         qIar9xMcb798yZtialju7U4dN86VUaqyzSOFZImOvU8H2VWr7OIwC8zvoN3czB2TU80f
         LhoQVFCTZQ3l486gfq8vdlaW5nR4dLyvwMtURtZ+9jX0e00DO0oDIWOqFvlrVppLmU8Z
         mleRgFQK4ETMHbwJxsmzuPpq1G3+Ex9yfXDkO0BYHXklg6NVb1yJLD7ilgG5EeYC1bmr
         vLog==
X-Gm-Message-State: AOAM532JLJ9o1/1erOQLJ+uf9dwTU4VcuriJTKDVj+5huWuHv2plUFaF
        m0+0Fpcuem2hRjE/Ncz7Bpi/xg==
X-Google-Smtp-Source: ABdhPJw33GS/18bzdmYBhAOo0OUTefZ+sCJH0t7Z7U3EzxF0uRV20RMB2IXpc67zADTPhpGVqdwIsQ==
X-Received: by 2002:a17:902:e901:: with SMTP id k1mr9615159pld.130.1595613354599;
        Fri, 24 Jul 2020 10:55:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t1sm6805590pgq.66.2020.07.24.10.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:55:53 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:55:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Martin Radev <martin.b.radev@gmail.com>, hpa@zytor.com,
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 75/75] x86/sev-es: Check required CPU features for
 SEV-ES
Message-ID: <202007241055.655EFCB4@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-76-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-76-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:03:36PM +0200, Joerg Roedel wrote:
> From: Martin Radev <martin.b.radev@gmail.com>
> 
> Make sure the machine supports RDRAND, otherwise there is no trusted
> source of of randomness in the system.
> 
> To also check this in the pre-decompression stage, make has_cpuflag
> not depend on CONFIG_RANDOMIZE_BASE anymore.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
