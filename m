Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BD47796AF
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 20:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbjHKSF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 14:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236948AbjHKSFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 14:05:49 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8AE30D8;
        Fri, 11 Aug 2023 11:05:47 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E2FD440E01A2;
        Fri, 11 Aug 2023 18:05:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id c3WvF_auBTsI; Fri, 11 Aug 2023 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1691777143; bh=TG6qdhwBVxwwpW817Qu9jh6xKcsj+nyAfk2svsio2bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gC1Z4gBZMKWYNbeH6y1iZcr+uZA9On7jttERP/Lg6g8e33GhxmiVSB8u8tJ/k6O+H
         ccm2f1GqLap8JML38vWteOtuv0tQz1ffDrPjeW2sMWXPZrBEA1Lo/cYJ5F31t17E3W
         RKi5y2wPNcLAnHVhTtZbWBi0f/VGRLeIoogtOINH2epomPcu20LAkPIr8ecPLucRy5
         ndswql3j5spFNqpKhHbOTw8xL8jLbiI5/+W51uRSi5rhyg0Du5uNCIom9QE8vruvs+
         03d3v0hQ0B1APMkAs3BYDpQxUOj/FTUkz7rlmFLv2DLj0WpLg3wY95UGTZWQZL7xpm
         RcAYg9L+7TQfvHPcGyM3FzOIZiH3TR0CnCwUbAqwT9djKAstNfth/zUjrFbSyU/hlH
         rjqKTSci0Rr5huwkSSNIeU07Cu77wRWgMVrN3GoBIzlrUfQTnmMkq2fArIwA7p57T3
         ddIhXr/xYs649PUmQJ/9TUKUSGLKt6On7G0u2tu5bG4DK2blI0dj4wtLhz9ww2U+4b
         Uop3R1JuoVDNoDdSVeXlW/D3xd1g2+yMfhhiKqaTx1DrG60cWNkDln9aLWdIM4FrBu
         DXKhJvNQ47uuFUIYTNhqDc2f7GX8sJCZO21eTHxKFNzN8fMj18+CeMly0y6kfPIk1P
         0wfg/EgKtuc6/K58owuz13Lk=
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8EE2840E0194;
        Fri, 11 Aug 2023 18:05:34 +0000 (UTC)
Date:   Fri, 11 Aug 2023 20:05:28 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Srikanth Aithal <sraithal@amd.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/retpoline: Don't clobber RFLAGS during
 srso_safe_ret()
Message-ID: <20230811180528.GJZNZ4aIHCn3zMaida@fat_crate.local>
References: <20230811155255.250835-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230811155255.250835-1-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 08:52:55AM -0700, Sean Christopherson wrote:
> A major motivation for doing fast emulation is to leverage the CPU to
> handle consumption and manipulation of arithmetic flags, i.e. RFLAGS is
> both an input and output to the target of the call.  fastop() collects
> the RFLAGS result by pushing RFLAGS onto the stack and popping them back
> into a variable (held in RDI in this case)
> 
>   asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"

Right, and I've tested this countless times with gcc-built host and
guest.

But Nathan's case where the host is built with gcc but the guest with
clang, would trigger this. And as he confirms, that fixes it so I wonder
what is the difference in code generation to make this rFLAGS corruption
noticeable in that particular configuration.

Oh well, later when the fires are put out.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
