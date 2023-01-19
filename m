Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6CA6740AC
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjASSPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjASSPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:15:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664DB917D3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:15:02 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id a14-20020a17090a70ce00b00229a2f73c56so6637318pjm.3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xr3qcJgaF5vAgY/VqxwE2Z8SykyvgmfIn0SNmkAE4nU=;
        b=qhMvPE0EEmswKPBN9nfYdqxGi4HHSszB3D3IZvKJLTzMB+z8e7t9oJVhxCulTj+K48
         1ffeM0ws/7/yw7STUqda2AkBMXQaJxE63pPVbHIvABTbHarfvbc7+ajRWHFyytY19cHt
         kM+YgZTJzkjAtzdtqdHyhYifGOcGPJEjSvt1+Rgp2UMS4r5tLkBY8Ew5pbcMYBrSEFPo
         gb/QzeaIVxzGUk9Y4ZtkmF6veMo14/BHj04g5falnYfDQIliBYcw9F5+nuhm6rwo2vOz
         yu67BiSthp50cEWC6OJFICGk8M0WbX9T07CUHYLSMtFEtCO1tXKDw8T7/h8tqWExludb
         vS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xr3qcJgaF5vAgY/VqxwE2Z8SykyvgmfIn0SNmkAE4nU=;
        b=3EqFNuQK3k54VSrFXVxjdIb+1kLcnRn7i6UwJpsvzQh7lePU3Z2hJBnwlwky6X/jM5
         BFYJmhOZzw9FCqR7KfrnXY/xf941hNFkqzW9L8y/9+pVS/nmCKhxsia/4Z17247y6ACp
         lCCX93rceLL9i6tBAbV1iKOdW6tyOY4T57VQd+h8j+z9HI6FLvINAg1sCNcxRcwJBw9O
         J0VMx4c6a2HbQUJL3Fjh+NjTA4xSp8oPl9QlwIBWFlAuozGaTnywwr7WlCp/GiorF1yM
         AtoIlEMp6+lhnFtyO++FAzf1F6pFmHpVcDSLkudzo2rRH/u7PjCQwf5AfRbpkzZBcpY+
         jQPQ==
X-Gm-Message-State: AFqh2kpdunxliigtFRhN/ZnfcGemggc8w0ma0STRCWFVJiQqnl6qBaF2
        SQ3g6axXSulAw5hoaqVjQIGO3g==
X-Google-Smtp-Source: AMrXdXuVsr2wL2Ppd/PjLvkpdiTDSs59fU6gdeTLm9yL9pzPrqst5KlUg1m4KtxFcUCKIQZvhK7sVQ==
X-Received: by 2002:a05:6a20:a883:b0:a4:efde:2ed8 with SMTP id ca3-20020a056a20a88300b000a4efde2ed8mr3293758pzb.0.1674152101753;
        Thu, 19 Jan 2023 10:15:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z3-20020a6552c3000000b0049b7b1205a0sm21371832pgp.54.2023.01.19.10.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 10:15:01 -0800 (PST)
Date:   Thu, 19 Jan 2023 18:14:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
Message-ID: <Y8mIoUqO8qFgoBZI@google.com>
References: <20221228110410.1682852-1-pbonzini@redhat.com>
 <20230119155800.fiypvvzoalnfavse@linux.intel.com>
 <Y8mEmSESlcdgtVg4@google.com>
 <CABgObfb6Z2MkG8yYtbObK4bhAD_1s8Q_M=PnP5pF-sk3=w8XDg@mail.gmail.com>
 <Y8mGHyg6DjkSyN5A@google.com>
 <CABgObfZZ3TLvW=Qqph16T0759nWy0PL_C3w3g=PACj9cpupBQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZZ3TLvW=Qqph16T0759nWy0PL_C3w3g=PACj9cpupBQA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023, Paolo Bonzini wrote:
> On Thu, Jan 19, 2023 at 7:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > > It's clang only; GCC only warns with -Wpedantic. Plus, bots probably
> > > don't compile tools/ that much.
> >
> > /wave
> >
> > Want to queue Yu's fix directly Paolo?  I was assuming you'd be offline until
> > sometime tomorrow.
> 
> Yes, I can, but what other patches were you meaning to send?

A minor selftest fix

  https://lore.kernel.org/all/20230111183408.104491-1-vipinsh@google.com

and a fix for a longstanding VMX bug that seems problematic enough that it
warrants going into this cycle.

  https://lore.kernel.org/all/20221114164823.69555-1-hborghor@amazon.de
