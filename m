Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07804722134
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 10:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjFEIjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 04:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjFEIjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 04:39:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE01DF;
        Mon,  5 Jun 2023 01:39:40 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685954379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0ljv1qUIqOFM+GI1URMBenoGBtjsnPXojxM5x+Wp44=;
        b=vThW0eAImrd5f+DASkzY6jMQ/j+eSL6dy15psCcKOatVQrt5c5o1njvZlVfpvUkIjTKBrQ
        yFtNvy0vL8K2Q9WB/l74oSnx/Z+azZpyVdullgbJjP7/LoA/xnIz9exBpmqBklvzwxqgDq
        LSB2yzFXHzZlBL9s8OsbWwm6FLlKjhWteDaD5Uro+MECUK+QNf3LVYQXeA1DmWRj2+9fOp
        BDR0PzF4/pGMl2Dib5pJcjvRGmLJx19okeweA+6jSqFtuY1NBC0h7wDD1tAqb3RMvK8+IG
        t3IMj8GGdSDoPYnTUUVgLou7ZZ/6741gVHaIE1rasKp9FY6R++NjT7C8qP/ZWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685954379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0ljv1qUIqOFM+GI1URMBenoGBtjsnPXojxM5x+Wp44=;
        b=mCTQVgnEytpkmyBk0FMcVjXbbzYjjY/34KfmuHY+hEm7k9ulGYBv4f//x46ohsE6SGQjZ7
        gdWNzIy4u6JvVYAg==
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
Date:   Mon, 05 Jun 2023 10:39:39 +0200
Message-ID: <871qiq8fqs.ffs@tglx>
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
> -#ifdef CONFIG_X86_LOCAL_APIC
>  DECLARE_IDTENTRY_IRQ(X86_TRAP_OTHER,	spurious_interrupt);
> -#endif

Breaks 32bit.
