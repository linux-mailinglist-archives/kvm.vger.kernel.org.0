Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7CB576553
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 18:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiGOQbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiGOQbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:31:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8828FD13C;
        Fri, 15 Jul 2022 09:31:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 401732005B;
        Fri, 15 Jul 2022 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657902707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrF0UTA3Ef9yvnb0oLwXwzJSpicZgGURdMHOPVAzQqM=;
        b=MyheM1jZdB7zhyU4p8/tTnFyNL8zYY2lMmrYuo/EbDaOYhAAHPSAnMK3uHFod2pl+e3A2d
        R0Igb+uEChD41vbKud4NI2wnXfDj9tTssn9T3xnFHUXFN8Z/vuxRgDMvEGDjqkir2LYQhE
        JCWVqDRkRSc3tzk+p2we2TAOYT5uXVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657902707;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrF0UTA3Ef9yvnb0oLwXwzJSpicZgGURdMHOPVAzQqM=;
        b=Q0BWzNw5P/FusF5cWz01gg3OZNhsK5V8CDirztkQZkkgCjwn4EXf9OviQqKV7O3h6aj5u4
        8kOC6KPMEPN5NoAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3373513754;
        Fri, 15 Jul 2022 16:31:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NFKHDHOW0WJVcgAAMHmgww
        (envelope-from <bp@suse.de>); Fri, 15 Jul 2022 16:31:47 +0000
Date:   Fri, 15 Jul 2022 18:31:43 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        peterz@infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: emulate: do not adjust size of fastop and setcc
 subroutines
Message-ID: <YtGWb3vTITBS9Wj2@zn.tnic>
References: <20220715114927.1460356-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220715114927.1460356-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
