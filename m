Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5AE735962
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 16:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjFSOWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 10:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjFSOWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 10:22:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1482E7;
        Mon, 19 Jun 2023 07:22:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1687184545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3265BdkHw/TgDMpSNFMXbUh+sahX2JrlmMLLSPY0m4=;
        b=U8PUmX3V76SL9uxXsX9c91YmtfXtFlihNq234UtV5p4EAd3gMeu5RncXVHDq0DpplIVHx0
        3DJJk0iaA8hT/IYe1YNUnktWjm83gMW/7hWgYIpmXsM83OYT81OdxhehdM+qsEGDLNgtVV
        YwqEZ7X9UxeoBG4HGyP1U2C6mOQBfana5nQTC+Lm+nTnhDzHpLxAL/gnK/yIvSjxKM4Yap
        knYyLq7XzKpXqJwxjIW4tEoGEQQ9tdFmjXm9xOdAjy+Yt092+MIgH5gVHrGP0ax0fl4cTw
        /jQxn1Y2HmdY77UbXtEDECnOoh4XiwZNnnsEq+IAeLgAy69N8LRS6tQXy+FyCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1687184545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3265BdkHw/TgDMpSNFMXbUh+sahX2JrlmMLLSPY0m4=;
        b=unreUa79f5oCxgY0Y8IEvu477CSuX8qwPv3P7kfSQr9LiXolpiY7MoJbfYoojs3C0Z2bn+
        jYdbpTAtTnR6tDBQ==
To:     "Li, Xin3" <xin3.li@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
In-Reply-To: <SA1PR11MB67344FE6C8A83810D0CAF175A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
 <877csgl5eo.ffs@tglx>
 <SA1PR11MB67344FE6C8A83810D0CAF175A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
Date:   Mon, 19 Jun 2023 16:22:25 +0200
Message-ID: <877crzr0pq.ffs@tglx>
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

On Mon, Jun 19 2023 at 08:00, Li, Xin3 wrote:
> To me it's better to keep the changes in one patch, thus the differences
> are more obvious.

The rename to vector_schedule_cleanup() can be obviously done first.

> We need a second patch to do vector cleanup in lapic_offline() in case the
> vector cleanup timer has not expired.

Right. I was lazy and just put a WARN_ON() there under the assumption
that you will figure it out.

But a second patch?

We don't switch things over into a broken state first and then fix it up
afterwards.

Thanks,

        tglx

