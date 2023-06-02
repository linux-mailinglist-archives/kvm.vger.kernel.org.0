Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A292720AA3
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbjFBU6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 16:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjFBU6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 16:58:44 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A1E19B
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 13:58:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-974f4897d87so120703566b.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 13:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685739522; x=1688331522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lEOehxHolb8X5C6iXhr+EWaD62m3RLxWc7FOFaBtkZ8=;
        b=dHoGUlGb6XDm2/Otv+ZRHMw+mt1C/1deZYgmb1PbQDWcaUrmU2KmSAc2kc2BTjcEz2
         NVc7Xgvx3W/QvWW+44JfAtHoxd1VbKB7KChHIbhaEnSuiSn2NptrvubUZkLhtXF0Z3N/
         pLFeC99wzH7h4avZxAHDNCaTWNG66rdKwJospxaGXQ66eg+eDbMAFnTfW6PhYM5bIhR+
         bFc1eqdXjHS0/bbevi0iBBmuyG5m+Yg1Sjkc5eXPPCP0MIAziQzo5OPzx7bnJLMuPmAH
         C3m7/33P7BTRIEzOnELysCS3xEzRJY7vIPqDf24y+JQiYVE9kG0cs39LHmSxDbcqGFKO
         JWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685739522; x=1688331522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lEOehxHolb8X5C6iXhr+EWaD62m3RLxWc7FOFaBtkZ8=;
        b=kVdSaDZZ8dqnircM+xfjgLtMV/pevm6mc6ksYKPQPhKXW93C/vV92eyK1VBFMnEcNE
         YHuwQ+nH142XaxTd6tiO1awTbd6wqjgNAAOOolSwk17gGbMd9Rfm0r1PSULCmGOwU0aH
         DZ62/6sU24u3xDZ0DXTjqDwCeGG2UPkt6+e41OkRW5hokcOOGYeKGOuduUp5xUQwvS54
         ej5uHh36gdjQtrGKCWJmPtEgw2kDIgAf8L+i6SISAzEvt12Evcmj1s8wwJeSaVnJlT5W
         5WocKCY0QwaZ5Drjz3uSonafakAOFXoQyXnZ6C2YK02JsM79euhYN2ILXtJT9gByvIBC
         W1Bg==
X-Gm-Message-State: AC+VfDy4yjRiA1jTy6qLt/2uJJt3ghMU26OoyjSidTI5922NlcmX7yBr
        9Ryobai62FLOUwofuH+d0/AkP27wQ/vAmIUtL2OzLw==
X-Google-Smtp-Source: ACHHUZ6T+VfpFr7aausPLCtKE/YyzZKqrUzoefeK1VCPalyfhekvDguhrF2kEC0Zgzs2X2kV0gHIegw+Vf9hSLzZ6Sk=
X-Received: by 2002:a17:907:9449:b0:96f:608c:5bdf with SMTP id
 dl9-20020a170907944900b0096f608c5bdfmr11859960ejc.64.1685739521701; Fri, 02
 Jun 2023 13:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230602010550.785722-1-seanjc@google.com> <C8324338-FC07-454E-9A5A-1785141FEAB3@nutanix.com>
 <CALMp9eTtkBL3Fb7Dq60go6CL+zGODNn0TTavr436Q-+=mpVFMA@mail.gmail.com>
In-Reply-To: <CALMp9eTtkBL3Fb7Dq60go6CL+zGODNn0TTavr436Q-+=mpVFMA@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 2 Jun 2023 13:58:05 -0700
Message-ID: <CAL715WKm4t=y_UZZSZkd2=QPwXL8n-KnWzBS4A-ZJLQaWb0RKQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Use cpu_feature_enabled() for PKU instead of #ifdef
To:     Jim Mattson <jmattson@google.com>
Cc:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> As we move towards enabling PKRU on the host, due to some customer
> requests, I have to wonder if PKRU-disabled is the norm.
>
> In other words, is this a likely() or unlikely() optimization?

I think it should be likely() as PKU was introduced very early in the
Skylake-SP server cores many years ago. Today I think all recent
client CPUs should have PKU on default if I am not mistaken. So yeah,
adding a likely() probably should help prevent the compiler from
evicting this code chunk to the end of function.

Thanks.
-Mingwei
