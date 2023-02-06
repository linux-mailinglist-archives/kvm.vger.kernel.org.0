Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E5668B850
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBFJLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBFJLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:11:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA431716
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 01:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675674631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OENdwppPi/XCuQwjwywb1aHOM4xFMtUlUnm5Y/fK5F4=;
        b=DDRAvi8t9STFTyWgL6rrR+4uBZEk224trkqMov1/LrCaOQ75daU0VpzhLZtEX+mj8Q+0r5
        Za0HTPLUOAT8LNlKPb3i9R+eBn8UF/o7p/T6yhsP3966/38D3kL5cnkiwCM7xYBEhv7gk2
        QM5FJUHvp3REJ6ok9g41UUy/8l+bp0g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-OjSyRnbUPuGsqDn2iEgZ5Q-1; Mon, 06 Feb 2023 04:10:27 -0500
X-MC-Unique: OjSyRnbUPuGsqDn2iEgZ5Q-1
Received: by mail-wm1-f72.google.com with SMTP id ay19-20020a05600c1e1300b003dc54daba42so5445789wmb.7
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 01:10:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OENdwppPi/XCuQwjwywb1aHOM4xFMtUlUnm5Y/fK5F4=;
        b=fOy7dbz1MFEh6XvMuv4+DfT/v+SW1eQywKXGgbaWZMkpjnDjZP0Nbxe2lQcV68kuPc
         hgUPtcOP4agreq6NcSTSC8TGYFTX2nHnsV8mG0xZt+9FLzRME4PgANJ4Wi1D1at3/tZC
         o++rvgVY6Um8nYcXPb0Br4CDNUqbRgKHfrOSJkieN20lbDfokHWPRnLnn2m+6Ap2Tk0f
         uPYlEaygRbs97NkXUJBhvMTGMa4KnYGSZRJyQ1alZBfxijeoGsPFt+5fkLDRPUA3OSko
         XvJnSSYCvdGAAdXseidRazZ7zoruZpL1smnnLvravxIvEFpI/wM2fX+a/8I3UdSlgPan
         roMw==
X-Gm-Message-State: AO0yUKXJutCBZhP62t04m38SqF3xGqfX7jGbBm3hX0yRc/5jvdc4r1mE
        0uv65TgsjRHhYU/a+sH5Q7m/NWj2SKBzxsxW8X/mKEmE1nEpfoWOCeKE2Uq6Jsy9pJ//5mWSvJP
        j+TzOVEDP114v
X-Received: by 2002:a5d:5958:0:b0:2bf:1ec:a068 with SMTP id e24-20020a5d5958000000b002bf01eca068mr15680615wri.53.1675674625860;
        Mon, 06 Feb 2023 01:10:25 -0800 (PST)
X-Google-Smtp-Source: AK7set/wxExR94jQuURa/jtlumOP5Tyx7OWInrvomdXMYnzrE7aaplkYhk/scfQ+9y2j3fLYLXQS9Q==
X-Received: by 2002:a5d:5958:0:b0:2bf:1ec:a068 with SMTP id e24-20020a5d5958000000b002bf01eca068mr15680607wri.53.1675674625654;
        Mon, 06 Feb 2023 01:10:25 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id p4-20020a5d68c4000000b002c3e4f2ffdbsm3313757wrw.58.2023.02.06.01.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 01:10:25 -0800 (PST)
Message-ID: <8a9deed754bb45cf48fa8562850dadc511bbd4df.camel@redhat.com>
Subject: Re: [RFC][PATCH] kvm: i8254: Deactivate APICv when using in-kernel
 PIT re-injection mode.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     lirongqing@baidu.com, kvm@vger.kernel.org
Date:   Mon, 06 Feb 2023 11:10:23 +0200
In-Reply-To: <1675673814-23372-1-git-send-email-lirongqing@baidu.com>
References: <1675673814-23372-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-06 at 16:56 +0800, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Intel VMX APICv accelerates EOI write and does not trap. This causes
> in-kernel PIT re-injection mode to fail since it relies on irq-ack
> notifier mechanism. So, APICv is activated only when in-kernel PIT
> is in discard mode e.g. w/ qemu option:
> 
> 	-global kvm-pit.lost_tick_policy=discard
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe5615f..16952a9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8051,7 +8051,8 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
> +			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
> +			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
>  
>  	return supported & BIT(reason);
>  }

AFAIK, APICv has EOI exiting bitmap, for this exact purpose, it allows to trap only some
vectors when EOI is performed.

KVM uses it so APICv shouldn't need this inhibit but it is possible that something got broken.

Take a look at vcpu_load_eoi_exitmap.

Best regards,
	Maxim Levitsky

