Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88974AB15B
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbiBFSpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 13:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiBFSpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 13:45:17 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48590C06173B
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 10:45:17 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d187so9782101pfa.10
        for <kvm@vger.kernel.org>; Sun, 06 Feb 2022 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g99EK4RBFIcLjOA2xsAgfPy/FWBWvPsPH9rm8hJWuN4=;
        b=biHHkqKY9Ho6lpFnUvZwHS3Q5oqNdHnItOI0AX5F4NU6WRtoewrftBfJOMU6myFuVw
         +M3wYhBHPiacfrFCkY7wbQ5phlQLfD6QNZM/QDckqZyMqFBKPudW+ryJ+gMTIWn8VS/A
         cRGemeQFuDF4522ZQFDF57DgekBIK9wYHAWPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g99EK4RBFIcLjOA2xsAgfPy/FWBWvPsPH9rm8hJWuN4=;
        b=1KO0lNIYVneIaJ3UtkwZwJDfT4Vp9nBZkabJq/LEIzoqon3DRqCGVCwb4YuX+jj3OQ
         wJUaw1BpxlAOFbwMOvsH7bW16BSETbrcOADqkMQy7hJHmTLCp6Guo49GxuglxySW51yV
         MSB3ALJIe//Jo6JUb12b/4QdpsAi+yIliJiyz4bmJ76I7yoOK8+1B3O2gIdzbxpRnwr9
         s4IaeMAzcINu7+rQM6ZhBa6FOxFhoTMOwdwgn7xryZIHg4+dsbCXdgavJuTHQhFSt9Jk
         lX2enu1EbNe8kBkSyPINFfW/wxD+FO94NFHm7Pfw7wSKECe4/xzj3dBIIXuYfBz1zI2j
         4JyQ==
X-Gm-Message-State: AOAM533RGDFVkZwP4bIhRm2DdSOd83hdkKdgAxG14dvB1FVCj9XyEWmT
        KL2N1XCrOiZgMVThqJvKMmt4Gw==
X-Google-Smtp-Source: ABdhPJwsGxmyQ5I5YdyWqLxqzGVpFwSbHqBQWHaTvyZjbtd3CV9mMg9vZBIckMMYD9dBGO8G2KeEOA==
X-Received: by 2002:a62:ce83:: with SMTP id y125mr12588532pfg.6.1644173116776;
        Sun, 06 Feb 2022 10:45:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id bv22sm8729991pjb.31.2022.02.06.10.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 10:45:16 -0800 (PST)
Date:   Sun, 6 Feb 2022 10:45:15 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <202202061011.A255DE55B@keescook>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 09:35:49AM -0800, Sami Tolvanen wrote:
> On Wed, Feb 2, 2022 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
> >
> > Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
> > function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
> > for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.
> >
> > We could fudge around the issue by using stubs, massaging prototypes, etc..., but
> > that means doing that for every arch-agnostic user of __static_call_return0().
> >
> > Any clever ideas?  Can we do something like generate a unique function for every
> > DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
> > get the prototype?
> 
> I'm not sure there's a clever fix for this. On architectures without
> HAVE_STATIC_CALL, this is an indirect call to a function with a
> mismatching type, which CFI is intended to catch.
> 
> The obvious way to solve the problem would be to use a stub function
> with the correct type, which I agree, isn't going to scale. You can
> alternatively check if .func points to __static_call_return0 and not
> make the indirect call if it does. If neither of these options are
> feasible, you can disable CFI checking in the functions that have
> these static calls using the __nocfi attribute.
> 
> Kees, any thoughts?

I'm digging through the macros to sort this out, but IIUC, an example of
the problem is:

perf_guest_cbs->handle_intel_pt_intr is:

	unsigned int (*handle_intel_pt_intr)(void);

The declaration for this starts with:

DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);

which produces:

extern struct static_call_key STATIC_CALL_KEY(__perf_guest_handle_intel_pt_intr);
extern typeof(*perf_guest_cbs->handle_intel_pt_intr) STATIC_CALL_TRAMP(__perf_guest_handle_intel_pt_intr);

and the last line becomes:

extern unsigned int (*__SCT____perf_guest_handle_intel_pt_intr)(void);

with !HAVE_STATIC_CALL, when perf_guest_handle_intel_pt_intr() does:

	return static_call(__perf_guest_handle_intel_pt_intr)();

it is resolving static_call() into:

	((typeof(STATIC_CALL_TRAMP(name))*)(STATIC_CALL_KEY(name).func))

so the caller is expecting "unsigned int (*)(void)" but the prototype
of __static_call_return0 is "long (*)(void)":

long __static_call_return0(void);

Could we simply declare a type-matched ret0 trampoline too?

#define STATIC_CALL_TRAMP_RET0_PREFIX	__SCT__ret0__
#define STATIC_CALL_TRAMP_RET0(name)	__PASTE(STATIC_CALL_TRAMP_RET0_PREFIX, name)

#define DEFINE_STATIC_CALL_RET0(name, _func)				\
	static typeof(_func) STATIC_CALL_TRAMP_RET0(name) { return 0; }	\
        __DEFINE_STATIC_CALL(name, _func, STATIC_CALL_TRAMP_RET0(name));

static_call_update(__perf_guest_handle_intel_pt_intr,
		   (void *)&STATIC_CALL_TRAMP_RET0(__perf_guest_handle_intel_pt_intr))

-- 
Kees Cook
