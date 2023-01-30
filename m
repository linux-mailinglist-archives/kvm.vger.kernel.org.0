Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75741680B70
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbjA3K7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 05:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjA3K7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 05:59:41 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0A36585;
        Mon, 30 Jan 2023 02:59:39 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 53F93218B8;
        Mon, 30 Jan 2023 10:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675076378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOVfea959Er0R6WACvjGpgC22Ys53793ZI7AC0xoMvQ=;
        b=FT4aRut+P53K30vxhH2SG2pULow+TY1ux3YGthTa0Yydk+1ZkqkSdCKDmf7NTDu8KH8BTS
        n0cchP5U9vUAyOy162tBomw6axUqGqPgCyCrpuJPZRJ5rCi5Dl+MzLH0y4yOSqjYz9Eh/Q
        2I2kuVvWwP4mceUo3/zPwg4mMgSHFPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675076378;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOVfea959Er0R6WACvjGpgC22Ys53793ZI7AC0xoMvQ=;
        b=Q11Rj1lXjxe5HEYRds6YYQ9s9iWekkzReDTZsUJveOCrD9U8k17AEVDZxicqT+Io/hwiMC
        zC88IqSWNBM90xAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EFE5813A06;
        Mon, 30 Jan 2023 10:59:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rvQjORmj12PwFwAAMHmgww
        (envelope-from <jroedel@suse.de>); Mon, 30 Jan 2023 10:59:37 +0000
Date:   Mon, 30 Jan 2023 11:59:36 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Sean Christopherson <seanjc@google.com>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH] x86/debug: Fix stack recursion caused by DR7 accesses
Message-ID: <Y9ejGDDUt8wGpGH1@suse.de>
References: <20230130093717.460-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130093717.460-1-joro@8bytes.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 10:37:17AM +0100, Joerg Roedel wrote:
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Missed these tags:

Fixes: 315562c9af3d ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Cc: stable@vger.kernel.org

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany

(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman

