Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8A37227CB
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjFENrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjFENrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:47:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40779C;
        Mon,  5 Jun 2023 06:47:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685972840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3z3FZ4kNGVy9xa9x+N03x9uqbii71mg8EBCyofU+2Y8=;
        b=Rnfn8XIs5NJXKjIsv6eK6KmEEIntsN/bQLfukf4ueM8tO45rntvwW+v/e0OE61iLpvUPXj
        Y0YZHfCfndmmFrG78x7avsDEYyl7redJ3sBxAJl3GUouo4DQOXMfUJLncCITYX3I0Kcwdb
        lZlHJMZM9wZU+VxdNugqYi7BHBgf9bg/K63EJJT6gi2HxVCddu4r5DHDXfVTWC302jLX2f
        d1EnfoT8mKa5V4rum6OcsDkjJLNqZpdRhpDgVHgajhZiS7BtVSl9ggT1sf/NHmP2Ci60z/
        4II79/LQhTh7njNJbTqCapDKy+oNjCPIj/4952gr29SVCf/yUwzjJNYVTaFteg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685972840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3z3FZ4kNGVy9xa9x+N03x9uqbii71mg8EBCyofU+2Y8=;
        b=BEVVRwgSl7daIWjIFPD5F+6XtZfwg07IhuzKN1thTiYMTn5UZmnMx9k5+dZmJWSn+yop1o
        EgCejxOFcgemkYBA==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 24/33] x86/fred: disallow the swapgs instruction when
 FRED is enabled
In-Reply-To: <20230410081438.1750-25-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-25-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 15:47:20 +0200
Message-ID: <87a5xe6mxj.ffs@tglx>
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
> The FRED architecture establishes the full supervisor/user through:
> 1) FRED event delivery swaps the value of the GS base address and
>    that of the IA32_KERNEL_GS_BASE MSR.
> 2) ERETU swaps the value of the GS base address and that of the
>    IA32_KERNEL_GS_BASE MSR.
> Thus, the swapgs instruction is disallowed when FRED is enabled,
> otherwise it causes #UD.

Which does not explain why writing directly to the IA32_KERNEL_GS_BASE
MSR is doing the right thing.

Thanks,

        tglx
