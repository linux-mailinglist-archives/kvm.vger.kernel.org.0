Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB18F57668A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 20:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiGOSJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 14:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiGOSJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 14:09:28 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728C110567;
        Fri, 15 Jul 2022 11:09:27 -0700 (PDT)
Received: from quatroqueijos (unknown [177.9.88.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 3C29F3F125;
        Fri, 15 Jul 2022 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657908565;
        bh=65kdUCfkTNv3oV00kmotnY0z4oMUCHRghCx6OOkBIuY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=Q6rO1pEqZe29iu1h8yuyUeiFsW65zuWj210RNq+NgMEvnoTdZ2X4qxHAkASm5WpAH
         cG+52xnrHux8Jfsn5ZsFuRwTfwUFqmE7YEa1PAG33z4WXyigKROHPfGqssKVnuwj8e
         fh9X+tULiBqXhIa7gJFEwYMIXVn5njc6tZE81vO8TEl9xIhcSD8CFKtRlSgLlyeb0n
         h2BoJjLy3L1zstu8uNfeSC8Mthr1i4W4/H+DN5Dj63eyBu2ep2lzc8XRJzfe3ThKg1
         IDgTAYp1R3Kjh4oA9DSJzYV4AKeKGVbT8C/vZwi9EuiMyztufgulj8k+w+NGmMzDfL
         AvlcZDMaCQ8eg==
Date:   Fri, 15 Jul 2022 15:09:19 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        peterz@infradead.org, bp@suse.de,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: emulate: do not adjust size of fastop and setcc
 subroutines
Message-ID: <YtGtT2DSazLNiMR6@quatroqueijos>
References: <20220715114927.1460356-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715114927.1460356-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 07:49:27AM -0400, Paolo Bonzini wrote:
> Instead of doing complicated calculations to find the size of the subroutines
> (which are even more complicated because they need to be stringified into
> an asm statement), just hardcode to 16.
> 
> It is less dense for a few combinations of IBT/SLS/retbleed, but it has
> the advantage of being really simple.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 0a15b0fec6d9..f8382abe22ff 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -189,13 +189,6 @@
>  #define X8(x...) X4(x), X4(x)
>  #define X16(x...) X8(x), X8(x)
>  
> -#define NR_FASTOP	(ilog2(sizeof(ulong)) + 1)
> -#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
> -			 IS_ENABLED(CONFIG_SLS))
> -#define FASTOP_LENGTH	(ENDBR_INSN_SIZE + 7 + RET_LENGTH)
> -#define FASTOP_SIZE	(8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
> -static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
> -
>  struct opcode {
>  	u64 flags;
>  	u8 intercept;
> @@ -310,9 +303,15 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
>   * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
>   * different operand sizes can be reached by calculation, rather than a jump
>   * table (which would be bigger than the code).
> + *
> + * The 16 byte alignment, considering 5 bytes for the RET thunk, 3 for ENDBR
> + * and 1 for the straight line speculation INT3, leaves 7 bytes for the
> + * body of the function.  Currently none is larger than 4.

The ENDBR is 4 bytes long, which leaves only 6 bytes left. Which is why the
calculation being replaced may end up with a FASTOP_SIZE of 32.

Can you fix up these numbers when applying?

Cascardo.

>   */
>  static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>  
> +#define FASTOP_SIZE	16
> +
>  #define __FOP_FUNC(name) \
>  	".align " __stringify(FASTOP_SIZE) " \n\t" \
>  	".type " name ", @function \n\t" \
> @@ -446,9 +445,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>   * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
>   * INT3				[1 byte; CONFIG_SLS]
>   */
> -#define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
> -#define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
> -static_assert(SETCC_LENGTH <= SETCC_ALIGN);
> +#define SETCC_ALIGN	16
>  
>  #define FOP_SETCC(op) \
>  	".align " __stringify(SETCC_ALIGN) " \n\t" \
> -- 
> 2.31.1
> 
