Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC972282F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjFEOGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjFEOGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:06:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB929C;
        Mon,  5 Jun 2023 07:06:49 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685974008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YDLtAwtM21aOuqJrPfE5/tWtetUTyZPJ0Vrz9O2SM0I=;
        b=k8xPO6zhDwfCKUCyKEy4BTPOaN8O2QPjnJ+fkULkspjjUn6qO/110gV2g9c7Rw/D0sgY0c
        yuFbOJM/JFB356v9F/3FT0xdhEVMfXDoa2noO4rfP3D6eg+By1VvrRk7PC+t4HdFbdqlHN
        hPaxKP5VtnfoEfAJ1qgZkljy0tBUU5HNOX/EMTr54r4ZJawp5GbEn1jrRW2q4Fsytd1msu
        s44ujBy+WxPgO34DOfd7NA8BzzYnYJq0FOWosZNvgv4EfJGAyqGR32JuRDi1QlF7lEdgOH
        6wCmaJiz0cJzlHrqTeMEshMRULz70FXdps/BBrowQiLZzMZJ7OEAjQ41gpzaKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685974008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YDLtAwtM21aOuqJrPfE5/tWtetUTyZPJ0Vrz9O2SM0I=;
        b=3ORB2+nwJtzAH3nmiJW9vF4b8PXdlTRgeYiory4d8+d78KZ4xftgEeTOoiDnL69DXOZCk4
        g5zU0c7Z9h98hBCw==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 29/33] x86/fred: allow FRED systems to use interrupt
 vectors 0x10-0x1f
In-Reply-To: <20230410081438.1750-30-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-30-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 16:06:47 +0200
Message-ID: <87zg5e57go.ffs@tglx>
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
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>
> FRED inherits the Intel VT-x enhancement of classified events with
> a two-level event dispatch logic. The first-level dispatch is on
> the event type, and the second-level is on the event vector. This
> also means that vectors in different event types are orthogonal,
> thus, vectors 0x10-0x1f become available as hardware interrupts.
>
> Enable interrupt vectors 0x10-0x1f on FRED systems (interrupt 0x80 is
> already enabled.) Most of these changes are about removing the
> assumption that the lowest-priority vector is hard-wired to 0x20.

I'm not really interested in this again premature optimization.

Can we please clarify how the final result of FRED vector layout will
look like?

I rather give up on reclaiming these 16 vectors than making _all_ system
vectors dynamically assignable to avoid an extra partitioning of the
vector space.

Thanks,

        tglx
