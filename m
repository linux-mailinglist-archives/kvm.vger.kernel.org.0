Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6376B7A5C89
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 10:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjISI3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 04:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjISI24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 04:28:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7989D13E;
        Tue, 19 Sep 2023 01:28:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695112128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/J3RiWKdg8c3IzdjWmLh9zLCv7VF76fYepXRQtkHb0=;
        b=U3ecSGCa3F2gvLLwz1Ij5s049fnE+mB8KhUG/kINpG9gVGfyTRvYvyyxoFnM0is9mqZ0Um
        RSFc8r37Ueg5axCqiQW0rdvc8RErKGb7CCXtfrEA+F38yE/AwhQCiw6v622RKTttoTvTCz
        RTJsf6jx1UlOXNAoqOTC/hQxrmZqNEgjEcZByd3DjNjh5CD9r/CIe13PTRRCK31Q+Tjkgd
        HZeL25W9eVSai+S77A3weyQcehuhDyUfqHcTht0GIWMmWmyLC8mi+I7+W8KgGxNCqcw46D
        Q1jY8vAZtTR3H02IWJgTCCmosSGbuL+SzPWJ3XPqStgVHKCRxUiHTGzMUMrnUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695112128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/J3RiWKdg8c3IzdjWmLh9zLCv7VF76fYepXRQtkHb0=;
        b=Sl2Ncxcrp84n8qOLd17+QPVSsnJWwjTJhHEW5C5C3dyLrVSuoCsaT/WfyM/4UuDdWtvOxm
        EdqWbhFdtlEDc9Bg==
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
        jgross@suse.com, ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com
Subject: Re: [PATCH v10 36/38] x86/fred: Add fred_syscall_init()
In-Reply-To: <20230914044805.301390-37-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-37-xin3.li@intel.com>
Date:   Tue, 19 Sep 2023 10:28:47 +0200
Message-ID: <87v8c6woqo.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13 2023 at 21:48, Xin Li wrote:
> +static inline void fred_syscall_init(void)
> +{
> +	/*
> +	 * Per FRED spec 5.0, FRED uses the ring 3 FRED entrypoint for SYSCALL
> +	 * and SYSENTER, and ERETU is the only legit instruction to return to
> +	 * ring 3, as a result there is _no_ need to setup the SYSCALL and
> +	 * SYSENTER MSRs.
> +	 *
> +	 * Note, both sysexit and sysret cause #UD when FRED is enabled.
> +	 */
> +	wrmsrl(MSR_LSTAR, 0ULL);
> +	wrmsrl_cstar(0ULL);

That write is pointless. See the comment in wrmsrl_cstar().

Thanks,

        tglx
