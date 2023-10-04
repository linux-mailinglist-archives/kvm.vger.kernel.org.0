Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808F87B832C
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 17:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbjJDPHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 11:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjJDPHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 11:07:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84514BD
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 08:07:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a4f6729d16so11245537b3.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 08:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696432023; x=1697036823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eVgljSrAaP4g9db6ArVQwSMJVgICRyWVUAk78dKeWs=;
        b=S7QcEe+nGvfXl3YC5lbQ6Nqx7TNFcssVdM/Pk2rh8feEgGakzccv0v6F04TbOEobFB
         +z05k439al5OFrHa+wALunwfqy7uEjVw3Z54+o81NB2dlEXVm/A71cfqgFOoRtxuWk9M
         x8OVvENTVosc00bgHjGu+XLpz+oXiX6r7+b3u681drD0ySNQc3o58LM9V1mQ3pfXwcb0
         eeVi/aX5VrbGSDdBJNiKvm5RpGa2Uy9+UTyagw1uAdfzlDMEpE2G08/gSaJCrigSO0Os
         OR5MNW22XmwuwtvjvRP9RL7NDN2M+WvEHfpRMdRQRZPPpjZUdO6lkvob1ZHHPjIn5cUK
         BRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696432023; x=1697036823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eVgljSrAaP4g9db6ArVQwSMJVgICRyWVUAk78dKeWs=;
        b=Ufs3EhXL9QlsUtwjzUzoJcQCVm5mc3WJ/VQDaY11y3QpjymQX707yGRPrFR6z7GzH3
         L4q0asHXbGaxvJmGtAuPc5u8+LI3H4hejb3SrQ0XNzM3k2wK8XFhU+neqWvxvMR0Cob3
         Yd4f9uiIzvhCan0jTMo7ujukO8C9zfP+drnk2ZjG3in2gbUiCjwqth3iCsYEac8b+gVj
         HDECdPPgA40ITZYf92YSVd8SFPnBgVPK5mdi6rU7ZbwV2rIsVFTAgCcdKMf+lztkPhyW
         SpmzQKXdgbSWwB2FkjhYjTw88HcJwXFtbEg4FvZm/uDkdLzfyCMt6qmmPK1EHXtSI5g4
         doGQ==
X-Gm-Message-State: AOJu0YyaIors4GnIKvdfBXfQ5YtlCxWWUM0HzeAB2+PFSNLdqnPGJKbZ
        5UeIzwNyA5rqDBWsoHGDJRoFvDr4Lzs=
X-Google-Smtp-Source: AGHT+IE/Q16oJvQguIZWdE2Ej77em6srkLwhWrMzXqQpR51O7yNiLgubhFBrSB9xOzQlVEy+ZcDow4PEi88=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b61a:0:b0:59b:e86f:ed2d with SMTP id
 u26-20020a81b61a000000b0059be86fed2dmr48698ywh.5.1696432023672; Wed, 04 Oct
 2023 08:07:03 -0700 (PDT)
Date:   Wed, 4 Oct 2023 08:07:02 -0700
In-Reply-To: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
Mime-Version: 1.0
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
Message-ID: <ZR1_lizQd14pbXbg@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Fix partially uninitialized integer in emulate_pop
From:   Sean Christopherson <seanjc@google.com>
To:     Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Oct 04, 2023, Julian Stecklina wrote:
> Most code gives a pointer to an uninitialized unsigned long as dest in
> emulate_pop. len is usually the word width of the guest.
> 
> If the guest runs in 16-bit or 32-bit modes, len will not cover the
> whole unsigned long and we end up with uninitialized data in dest.
> 
> Looking through the callers of this function, the issue seems
> harmless, but given that none of this is performance critical, there
> should be no issue with just always initializing the whole value.
> 
> Fix this by explicitly requiring a unsigned long pointer and
> initializing it with zero in all cases.

NAK, this will break em_leave() as it will zero RBP regardless of how many bytes
are actually supposed to be written.  Specifically, KVM would incorrectly clobber
RBP[31:16] if LEAVE is executed with a 16-bit stack.

I generally like defense-in-depth approaches, but zeroing data that the caller
did not ask to be written is not a net positive.

> Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
> ---
>  arch/x86/kvm/emulate.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2673cd5c46cb..fc4a365a309f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1838,18 +1838,24 @@ static int em_push(struct x86_emulate_ctxt *ctxt)
>  }
>  
>  static int emulate_pop(struct x86_emulate_ctxt *ctxt,
> -		       void *dest, int len)
> +		       unsigned long *dest, u8 op_bytes)
>  {
>  	int rc;
>  	struct segmented_address addr;
>  
> +	/*
> +	 * segmented_read below will only partially initialize dest when
> +	 * we are not in 64-bit mode.
> +	 */
> +	*dest = 0;
> +
>  	addr.ea = reg_read(ctxt, VCPU_REGS_RSP) & stack_mask(ctxt);
>  	addr.seg = VCPU_SREG_SS;
> -	rc = segmented_read(ctxt, addr, dest, len);
> +	rc = segmented_read(ctxt, addr, dest, op_bytes);
>  	if (rc != X86EMUL_CONTINUE)
>  		return rc;
>  
> -	rsp_increment(ctxt, len);
> +	rsp_increment(ctxt, op_bytes);
>  	return rc;
>  }
>  
> @@ -1999,7 +2005,7 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
>  {
>  	int rc = X86EMUL_CONTINUE;
>  	int reg = VCPU_REGS_RDI;
> -	u32 val;
> +	unsigned long val;
>  
>  	while (reg >= VCPU_REGS_RAX) {
>  		if (reg == VCPU_REGS_RSP) {
> -- 
> 2.40.1
> 
