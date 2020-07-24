Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636EC22CC4C
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgGXRka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXRk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:40:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76623C0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:40:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t15so5705672pjq.5
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QMsfHaQGQ+0SRHcIqI75rby1zzIeBrnwc+TycCSBhRM=;
        b=UFmzpMf7uzK2lx30P3rhoBpvw5w85/VUsDXt/5ykAeCH/VFrEJEwB9RmNcdbY2LhWz
         FiNtcwq6cYSJDFEy9jc1V2I68Ud1ixnRqGj5AYeAVOuh08EcTn9UXClFjujGlNhJqqyt
         /o0xfCbeW0wGt1skpJ0dBBA+3UPdspZahcnFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QMsfHaQGQ+0SRHcIqI75rby1zzIeBrnwc+TycCSBhRM=;
        b=YzVP4LlhSul16VdmKjunISpRA+TCmP8lwBWZOKeZltH+rvwZzpDCYeHQiuTeahbnFe
         sa3e4INoMC9n+eOHF6+dXHPbT6bdgzLMlXvwL81HBqo+GurS9gnHXbJ4o7Y76dm5/E4U
         Tg6RCCoOTgLh4VXCMBiH4Bg9BDaLTm5Xa8XySe23XuiHyi21cJFa/Uqhm9b1w3ltDgu8
         IUTO0gx+mk9+bMS31/2mGW7G38Gr/HC0d3790EU+vFtDmTlwuPo1Cb8dNvPcK3NQycX9
         RMLKi+vvCDwo/+v8i0/WaM3B9oeZMqzfY+Rocmx/uOfr1/nJ6QnAMVhrrUASdCiAgfNM
         MChg==
X-Gm-Message-State: AOAM530cJkq3eTSDVUT/ZQ8OaJESbiAYgGHk2+IrGfmkKC4PpuRuO5sE
        uJLFEJ6iNlRzsdOOdvJ9w67A+g==
X-Google-Smtp-Source: ABdhPJyekeM+nvr+iN70DB8t8eLU5BEdU2IBMUBrLQ9bGL/yN7X161hHc1aZr2MM8o1xGhcfY2+Q3A==
X-Received: by 2002:a17:902:9a0a:: with SMTP id v10mr9082983plp.134.1595612429062;
        Fri, 24 Jul 2020 10:40:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q24sm7188513pfg.34.2020.07.24.10.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:40:28 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:40:27 -0700
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
Subject: Re: [PATCH v5 31/75] x86/head/64: Load GDT after switch to virtual
 addresses
Message-ID: <202007241040.4A0CF961@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-32-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-32-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:52PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Load the GDT right after switching to virtual addresses to make sure
> there is a defined GDT for exception handling.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
