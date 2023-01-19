Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CE167409C
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjASSNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjASSNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:13:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC38F7F8
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674151939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZdrDTN701XEr5+CWMY6m6v20b2OvSDiU2dbFC+yj4Dk=;
        b=ZMBnuSXvx1eaEbcff1+HP5rI5WWiGLYKsV904AU2do5jVwfaw3kMgAI/mNL8bqa6EhzJ3h
        /HzaFrr9vOMiG2OrMVb+Uug2f1XxetZX2XFdV6YTbYunHTNoNF9qO2IEHRoVSmFWkdzNMC
        ajeEz6Whb2vKoB+0+s+64YWE28Vl1Wo=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-9p--hi4vOW6qSsgPYkEdOA-1; Thu, 19 Jan 2023 13:12:17 -0500
X-MC-Unique: 9p--hi4vOW6qSsgPYkEdOA-1
Received: by mail-vs1-f71.google.com with SMTP id k8-20020a056102004800b003d0f2b18a22so960397vsp.5
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:12:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZdrDTN701XEr5+CWMY6m6v20b2OvSDiU2dbFC+yj4Dk=;
        b=4KdJhAA4tgoD36x187Fn8EUGd+wj1mDYiBXSkC0Y3S8D5m8JWSaDLbppBWsCS6e2cw
         ONiGiQ3HzCd7pGkQVke1mUWeMAuaJ6aluzJft34zpUcKibDSvNiSdcrXGJ97hHIy1BL8
         JVkrICP8K6SXK5EyhSzf0xYLHLAp+p3uPTECDqtEIbHLQ66jLD+VmYiRJ+BRGv6Tlv1k
         EYSlXM55QeYX02SNAkyDuyM815nVXi5T2IcnF50jvCCNCAIE5wouZV7O1CNSHtEgsfCS
         nlbUEVEen0iHN0V8Z0upGY2JuW8jL9/6u+GiqYfDQ+vt10r+4XLYb9bP/p5ELYBrnxVW
         AQuw==
X-Gm-Message-State: AFqh2koHBE9/7vcuZHLLzIx+7CAwJkSVIaJ4IEi7FokImq497q4g5gs8
        LVa05TnXDKo+w2ThmcFAF0AvPApbrb2f7LLc6A6GSsRHkwhGFGLn7l13UGNLgFBUzS+s5+T90JB
        c3ye9s+lkq2JLu+jlbA54VWGiNUSL
X-Received: by 2002:a1f:e701:0:b0:3dd:f5ea:63a2 with SMTP id e1-20020a1fe701000000b003ddf5ea63a2mr1626161vkh.10.1674151937440;
        Thu, 19 Jan 2023 10:12:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsY5p+k0R0sGPWSdQFYydcLWgiPLWtRkKOKc1nkSGhtM7pkgJykCPn8YcbFoLMnuG/wlE/Bp0MebqiMNtWQH3o=
X-Received: by 2002:a1f:e701:0:b0:3dd:f5ea:63a2 with SMTP id
 e1-20020a1fe701000000b003ddf5ea63a2mr1626156vkh.10.1674151937159; Thu, 19 Jan
 2023 10:12:17 -0800 (PST)
MIME-Version: 1.0
References: <20221228110410.1682852-1-pbonzini@redhat.com> <20230119155800.fiypvvzoalnfavse@linux.intel.com>
 <Y8mEmSESlcdgtVg4@google.com> <CABgObfb6Z2MkG8yYtbObK4bhAD_1s8Q_M=PnP5pF-sk3=w8XDg@mail.gmail.com>
 <Y8mGHyg6DjkSyN5A@google.com>
In-Reply-To: <Y8mGHyg6DjkSyN5A@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 19 Jan 2023 19:12:05 +0100
Message-ID: <CABgObfZZ3TLvW=Qqph16T0759nWy0PL_C3w3g=PACj9cpupBQA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 7:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > It's clang only; GCC only warns with -Wpedantic. Plus, bots probably
> > don't compile tools/ that much.
>
> /wave
>
> Want to queue Yu's fix directly Paolo?  I was assuming you'd be offline until
> sometime tomorrow.

Yes, I can, but what other patches were you meaning to send?

Paolo

