Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4907A1DC7
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbjIOL7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 07:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjIOL7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 07:59:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E65CD8;
        Fri, 15 Sep 2023 04:59:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-31ff1f3cde5so560736f8f.2;
        Fri, 15 Sep 2023 04:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694779171; x=1695383971; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iniQNpxeJMnhN0yeQ4uN2ztNWPHxjhWGs1K97TxC2M4=;
        b=GaVfTP2Ub/O67fDjJ0bLZN1+Dfd1ar3f/LVmpOCOtwD1bjTAWPu4v5JDIrc+00plw/
         b0OsTYsAqSREPfDoons5J1mIkTpxyMWzLlHMGWFFgsCrE8Ia4OQowSuFBSxqQYo/L1Rl
         1SEim7QUOabhZ77n6z8SVC+2CJromjSCw8xynCQf1vdK0vMpzdqObBEYIv7npxDVUoKk
         nY9EqTw/XWXAtLeTf7Vz82jgW4SBeiKS33REVuAzNv9ttNpaUNcRUaRSekjQG8V1NOJ6
         QLs+mCAZj0QOoa5Myp8M8O6fUXAHW2CB9yQLvRuyOcSZy9pXngQD8wZz1doFh8BKiI4x
         78EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694779171; x=1695383971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iniQNpxeJMnhN0yeQ4uN2ztNWPHxjhWGs1K97TxC2M4=;
        b=KBHWfZrG6LsD4czHBRqFH11ktAoi60yIUj1zSbRZaJApLJvTxnSQYjVMYoyiHDZdqE
         L1sJxUOKxdixb+s8P2BeMlssb2k5GIJ0iYRQ4Yu016bYzT3jWTs67/MtLuE7O8lYbJaT
         4aQb5XApx2/olCiN12vBpg2vkSxE5NkRvGEu+ATKJSNlFjU8+pGhK+bZ8wSPPPOD2gEo
         KW9XyaqZ9SegTZ8F+D3nM7O3ul3GJAzvN+glj9rQgdAWEZD+e4SmYUARtUtsnn3KZscC
         L8vMOFdJy5fCmmco2fQd8c/RcQWGNaJmv/xJtAUUUQks+ZiAC9hZbwh3E6/E8slHDq2x
         kSuA==
X-Gm-Message-State: AOJu0YyL3z3EobmBEBVY+tUNsLmRYdwsbMC7jLdHItjWEUCoAEfBSs0z
        PehUQkpWF7MgBio08T/XBWw=
X-Google-Smtp-Source: AGHT+IFoOUevIZ6RMJ0jm/kPpnWnjjeV6chX8eEK6W6Hp4h6S/m2viQ2l13JZcpn/oFOu2cu86F4Tw==
X-Received: by 2002:a05:6000:91:b0:314:1b4d:bb27 with SMTP id m17-20020a056000009100b003141b4dbb27mr1266743wrx.64.1694779171214;
        Fri, 15 Sep 2023 04:59:31 -0700 (PDT)
Received: from gmail.com (1F2EF265.nat.pool.telekom.hu. [31.46.242.101])
        by smtp.gmail.com with ESMTPSA id q11-20020adff50b000000b0031c71693449sm4304510wro.1.2023.09.15.04.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 04:59:30 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Fri, 15 Sep 2023 13:59:28 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page
 aligned
Message-ID: <ZQRHIN7as8f+PFeh@gmail.com>
References: <20230818233451.3615464-1-srutherford@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818233451.3615464-1-srutherford@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Steve Rutherford <srutherford@google.com> wrote:

> early_set_memory_decrypted() assumes its parameters are page aligned.
> Non-page aligned calls result in additional pages being marked as
> decrypted via the encryption status hypercall, which results in
> consistent corruption of pages during live migration. Live
> migration requires accurate encryption status information to avoid
> migrating pages from the wrong perspective.
> 
> Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SEV is active")
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>  arch/x86/kernel/kvm.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

I suppose this fix is going through the KVM tree, or should we pick it up
in the x86 tree?

Thanks,

	Ingo
