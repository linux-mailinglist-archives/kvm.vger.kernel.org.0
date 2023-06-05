Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44257227DC
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbjFENwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjFENwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:52:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64B9EE;
        Mon,  5 Jun 2023 06:52:03 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685973122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uUOQseh5ydTYez7B9hZObsjFUYK1akvdtGONm9fjmIs=;
        b=mbNws8bz4std+L0u9Lf4aoWUTjvU2jIPojtqquY0d3WuwiPvHrZn7v72Y65DI+hjDtA1u9
        d6ibnkPXRtwGMDquSWuGVT3TgIxrKmOs7mzQtZfdWHxKeJRg31xoGy1wO4rvgMU6iuWrlN
        u+PLzsZji8C10UQTkYPxqk+gk+2tzsM257e5cSr1Xcfc+Fg51FTarTDTyNHN61lJjtSlOG
        rhWo9Q1cQMJzYqfFjccniJAPw4Jd83KSQKuoamVtsbz/Ns92GjAYCxWjumWrOtMenIRZnc
        KrWkaIlWJBVbRSrND3iGKmX2gmuG5ZTIDlEHI/l08SQe2oKFbkrL/3jgaxMcpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685973122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uUOQseh5ydTYez7B9hZObsjFUYK1akvdtGONm9fjmIs=;
        b=BNUdCmLWcHQfE4V/dctZz8skLLVebFyHPvaS9VJ/LM+GbyQuO/7QciA8XWv8PdmFh+SWL5
        VvGLhnCWuFVD38Dg==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 26/33] x86/fred: allow single-step trap and NMI when
 starting a new thread
In-Reply-To: <877csi6mrk.ffs@tglx>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-27-xin3.li@intel.com> <877csi6mrk.ffs@tglx>
Date:   Mon, 05 Jun 2023 15:52:02 +0200
Message-ID: <874jnm6mpp.ffs@tglx>
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

On Mon, Jun 05 2023 at 15:50, Thomas Gleixner wrote:

> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>> Allow single-step trap and NMI when starting a new thread, thus once
>> the new thread returns to ring3, single-step trap and NMI are both
>> enabled immediately.
>>
>> High-order 48 bits above the lowest 16 bit CS are discarded by the
>> legacy IRET instruction, thus can be set unconditionally, even when
>> FRED is not enabled.
>
> I assume this has been validated to be true on _all_ CPU incarnations of
> _all_ x86 vendors.

It's also ensured that VMMs do not get confused by this, right?

> If so, then please document it. If not, then go back to the drawing
> board.
>
> Thanks,
>
>         tglx
