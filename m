Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A78621021
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 13:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiKHMSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 07:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiKHMSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 07:18:11 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3F93E0A0;
        Tue,  8 Nov 2022 04:18:10 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BEAD01F897;
        Tue,  8 Nov 2022 12:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667909888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeUj1KQeijZc8VVyU5Jhg9NQ2cupqwdXYW1sF2iO20E=;
        b=D7/6PUWNj0Ikd3aiqq8Zwis4IBwu0fRF8Xi40rePYUojl+9f0qZf9Gv4vfhpnFLVxzUnPu
        RcHeQDtJ3HpYJrv0U7SQef4C+vbHSeDiOlSOgsq8BOOg6X35NS684w/Q6yl+j3GN/n8Jq/
        hrZ4qJC25VSQ510tGYT6NW4Y7wB2bhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667909888;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeUj1KQeijZc8VVyU5Jhg9NQ2cupqwdXYW1sF2iO20E=;
        b=Eh5rMSTKnPpOmUDZVSU0beIStwJAZ205hU+JLe+dQuxTaTK28GlQozBvgsL7Mphpk3W+n1
        BV6wqTs4PxVssMCg==
Received: from hawking.suse.de (unknown [10.168.4.11])
        by relay2.suse.de (Postfix) with ESMTP id EA6762C142;
        Tue,  8 Nov 2022 12:18:07 +0000 (UTC)
Received: by hawking.suse.de (Postfix, from userid 17005)
        id 5D94D44039C; Tue,  8 Nov 2022 13:18:07 +0100 (CET)
From:   Andreas Schwab <schwab@suse.de>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Exit run-loop immediately if xfer_to_guest
 fails
References: <20221108115543.1425199-1-apatel@ventanamicro.com>
X-Yow:  Now that I have my ``APPLE,'' I comprehend COST ACCOUNTING!!
Date:   Tue, 08 Nov 2022 13:18:06 +0100
In-Reply-To: <20221108115543.1425199-1-apatel@ventanamicro.com> (Anup Patel's
        message of "Tue, 8 Nov 2022 17:25:43 +0530")
Message-ID: <mvmiljpd4ht.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Nov 08 2022, Anup Patel wrote:

> If xfer_to_guest_mode_handle_work() fails in the run-loop then exit
> the run-loop immediately instead of doing it after some more work.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 71ebbc4821f0..17d5b3f8c2ee 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -984,8 +984,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	while (ret > 0) {
>  		/* Check conditions before entering the guest */
>  		ret = xfer_to_guest_mode_handle_work(vcpu);
> -		if (!ret)
> -			ret = 1;
> +		if (ret)
> +			continue;

If that is supposed to exit the loop, it would be clearer to just use
break.

> +		ret = 1;

There is a condition on ret <= 0 later in the loop that no longer can be
true.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
