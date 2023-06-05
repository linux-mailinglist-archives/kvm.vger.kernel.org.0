Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B35722129
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 10:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjFEIib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 04:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjFEIia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 04:38:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B654B0;
        Mon,  5 Jun 2023 01:38:28 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685954307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K6vr5fb0CXEJhD03e4srj5+jUXBNJXWKeJF05xRhs7g=;
        b=zHMBd0Wf44emQIGIDsifyM5TkRgpKtJBEmvNOUUSHdyqxhoyx0hNk6F9Gd8RnnHoVzwyBq
        xo8qFBJzyuPI0DxrlpXftircixE9kORcjNl4tOEVUB2eZg3MaFw9pnydQD6oV+a3gio/vB
        mjNqRPlqVnFCSfeJ6I/Ecoue7o5nop5BgoSyLyklKqYiQbL31SElm3v7YgJv4QvMD5YPJA
        m3nsC4Bh1tq/uDzeimF/VMOS4IC4ureazi8CNz/2RJD1RgM9IL0oR/e7Xcr0JsdmPv2tvQ
        LIWj+enU6jPpMtwXGc2Ta00ZtD5fv1CpJghke6kypSQULsOw18DNFRWpJZUZHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685954307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K6vr5fb0CXEJhD03e4srj5+jUXBNJXWKeJF05xRhs7g=;
        b=impXIJLmTYJ2dUd0vlUvSmRQ58bfsTXLS0aux4Y3EvFIas2xIo5Ux5DHKWUJ7fjPrd1Ulr
        lNT7cIlANr6wlrDg==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 03/33] x86/traps: add a system interrupt table for
 system interrupt dispatch
In-Reply-To: <20230410081438.1750-4-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-4-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 10:38:26 +0200
Message-ID: <874jnm8fst.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>  #ifdef CONFIG_SMP
> -DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
> +DECLARE_IDTENTRY_SYSVEC(RESCHEDULE_VECTOR,		sysvec_reschedule_ipi);

Please do not hide unrelated semantical changes in a big pile of
supposed to be mechanical changes. Split it out and provide a proper
explanation why this is correct and required.

> +/*
> + * How system interrupt handlers are called.
> + */
> +#define DECLARE_SYSTEM_INTERRUPT_HANDLER(f)	\
> +	void f (struct pt_regs *regs)
> +typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));

How is this related to the other changes and why is it required. Please
make this reviewable.

Thanks,

        tglx
