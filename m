Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84238722D4F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbjFERH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbjFERHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:07:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38D812D;
        Mon,  5 Jun 2023 10:07:12 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685984830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zWSvQuDlI5XP7F5YAdOwhbRwYR+BYLizHf+PTJ4QfcE=;
        b=IuUo3DZk+lmfLBy2KqpWXOMFmdL7STVaifG6mz7RZxt1vMQdEFZldiH5zBiY4Qwi37h+Vv
        1j7qhBIeGpQMyjAJ3cdG+6LKiEWKBBz32Zy7t3THGkPmruLMf2u5rrukaCR1A0DUApONdL
        DswdosBkhJ4N6AS3Ur4r22ylO7xBJ4Z9vDPup7mKpcKJ+H/CnkzdBjgV57qKU05hdzg13D
        S2Wjuq5codIGdkTM6RtDgktD6cMeO2+VIuY69svfe8RiAeZ7+z+X2o5d0Tgj0Ld/IVT/tg
        IvriXItQzeANliE9fofyQYTg1HOxfXNunG5UL5zjlAMhsBjh+Cy20/4ynVm/3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685984830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zWSvQuDlI5XP7F5YAdOwhbRwYR+BYLizHf+PTJ4QfcE=;
        b=jkQEdQpSQCffjllYTgnVXEW+2YdGttz1iezI+0I4t8wrFAuMq0fMjBCQK9Deud86rzfHq4
        xr5J+kYvIrsd91Cw==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
In-Reply-To: <87leh08e1h.ffs@tglx>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
Date:   Mon, 05 Jun 2023 19:07:10 +0200
Message-ID: <87edmp6doh.ffs@tglx>
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

On Sat, Jun 03 2023 at 22:51, Thomas Gleixner wrote:
> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>> IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
>> is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
>> into common_interrupt() just before the spurious interrupt handling.
>
> This is a complete NOOP on not FRED enabled systems as the IDT entry is
> still separate. So this change makes no sense outside of the FRED
> universe. Can we pretty please make this consistent?

The right thing to make this consistent is to get rid of this vector
completely.

There is zero reason for this to be an IPI. This can be delegated to a
worker or whatever delayed mechanism.

Thanks,

        tglx
