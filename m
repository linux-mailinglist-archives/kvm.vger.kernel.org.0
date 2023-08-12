Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E287779CE3
	for <lists+kvm@lfdr.de>; Sat, 12 Aug 2023 05:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbjHLDAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 23:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjHLDAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 23:00:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4559B30EB
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 19:59:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-267f1559391so2928466a91.0
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 19:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691809199; x=1692413999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lYtGFhRIF3a7yomMcivmbgdKn93U1qRaBLx6Bg8h8rk=;
        b=E+MYHTAy1msmFnQy4eHSPpLWsDNzx24BKdirkeIUx+yl2SzuIfz8TD7Rm6EN23Dhyj
         dKnH48eiCYdcKvHjNJUlKvovq7PgKRC2yltx9tnW6KGwHFXEk5ZFjsRQ96WZo6Rj/aFx
         4wzfMiqhJ5LCsP/inbTpol8L5m3jBRFSdXVPkywPaXe9jVkSxgDZDkwvlCa21bXK4/2M
         XUn12FxeooPUfzEOA/qB+anXA3KwCOLyKEKR0hpdlvMdDfxMuD/yfkR/6NpN4prChZtM
         Ba7417gebkaN/g0y+pUoF6FwTWyxqccEj051j640rpNiUcZi/4fkvIywiugeXLGjlNP5
         Zieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691809199; x=1692413999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYtGFhRIF3a7yomMcivmbgdKn93U1qRaBLx6Bg8h8rk=;
        b=fCuvQHA51WdTa/LlMrjWfeqiAyk/i4+ph+oS2kUYUZA0PYDqKGhe5Po5DxA6aTq11R
         XS1gS9inYDdC1Zp5n8gBRiM0ozOtSe1ac9vtucJqsGvDDkBf5tG571Sd0BwBLHXL86D/
         uretFDkVXhyWMOm1QKa6BC8Ubp/8BYMMxZzWAWiq/XFZsDqyG1elX6ZSorx2YwLMxCVt
         Szc4iNFLi+u+DFYpBSqCP6So6pWSlkb4TlABEcimgGjI8DdfVhM2s6Cw+WnlpCg9kgRu
         GYELt5r59bm38svmnBMF1YAZzbtmTDCoetAuTHadLnlwEAwDRh2aAJr40iqKoI3H1c9v
         ueXQ==
X-Gm-Message-State: AOJu0YzKBdwtyGNpDIBQbHQtJgJUE75Hz2ynak44sYJnYE1YPML9umku
        xIKEfui2X7nqAY0qlfaHUHx/ReAgxmU=
X-Google-Smtp-Source: AGHT+IHRNQFfk8YmRBI7eNsxZhwUc6Xw54mH9pKv6vQ6lZ4kaC4BEdmwJgdAhYvxJJzYUFVu9ATUFsySxPs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4615:b0:268:776:e26 with SMTP id
 w21-20020a17090a461500b0026807760e26mr792296pjg.5.1691809198717; Fri, 11 Aug
 2023 19:59:58 -0700 (PDT)
Date:   Fri, 11 Aug 2023 19:59:57 -0700
In-Reply-To: <20230811180528.GJZNZ4aIHCn3zMaida@fat_crate.local>
Mime-Version: 1.0
References: <20230811155255.250835-1-seanjc@google.com> <20230811180528.GJZNZ4aIHCn3zMaida@fat_crate.local>
Message-ID: <ZNb1rXGWfyM0XdjB@google.com>
Subject: Re: [PATCH] x86/retpoline: Don't clobber RFLAGS during srso_safe_ret()
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Srikanth Aithal <sraithal@amd.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023, Borislav Petkov wrote:
> On Fri, Aug 11, 2023 at 08:52:55AM -0700, Sean Christopherson wrote:
> > A major motivation for doing fast emulation is to leverage the CPU to
> > handle consumption and manipulation of arithmetic flags, i.e. RFLAGS is
> > both an input and output to the target of the call.  fastop() collects
> > the RFLAGS result by pushing RFLAGS onto the stack and popping them back
> > into a variable (held in RDI in this case)
> > 
> >   asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
> 
> Right, and I've tested this countless times with gcc-built host and
> guest.
> 
> But Nathan's case where the host is built with gcc but the guest with
> clang, would trigger this. And as he confirms, that fixes it so I wonder
> what is the difference in code generation to make this rFLAGS corruption
> noticeable in that particular configuration.

Might be I/O APIC accesses?  Unless things have changed, the I/O APIC code uses
a struct overlay to access the I/O APIC, i.e. when doing emulated MMIO accesses.
If clang generates an ADD or whatever and consumes flags, e.g. instead of a
straight MOV, that would explain the problems.
