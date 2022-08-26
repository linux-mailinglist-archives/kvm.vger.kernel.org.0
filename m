Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435885A1D76
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 02:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243843AbiHZAFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 20:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHZAFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 20:05:08 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFD278226
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:05:07 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f12so26366plb.11
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=6AiKwkDcKOsh0d0RBuOF7pp4bP8c0lf/dlSyLeEcbss=;
        b=l9li/7PCCJgOYQIZ/T7Pj5f0q+kL6RP1A8OCFyL0o3MZnN8hZV5lw2x87yGkbVgh3Z
         lgaQZJp+D7XYltGhUrjVoy0cycpSFfA0fE4gp/3WMXS/3au+ggHFkO/M+stoE7b2FNj6
         PDMTbTZk/pTs2vG212P2nm4jHIPzi+YHnHIGpF55mC3ij/KHYjueWmyFXh4lxFuyKq3y
         tLQIn6kk3yhivxBduLAazn/q54EvcRA2hqSi+ty7ge0NuK67o6mA271huLoh5ADeq0op
         uG6xO7E5UfQh2e1I6FvkArhZ4wyJbsxuqfzy82D+aiLWkui8q4TcHPZWdoU59dKoeD68
         6Yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6AiKwkDcKOsh0d0RBuOF7pp4bP8c0lf/dlSyLeEcbss=;
        b=loPu1+gs4bo9idWYDF4gH0b/bGCkdtu8KkkVkjI9XTrko8VzbvmbtfbCXL6cXMaq/I
         Nly5gzCOQfa8pg3l84ucbvaMPE0GkiBZL2EoNrAREQab4VYNyQupVbqogN8Wmoaj3gul
         dlQgm6KTb5BTdlLgnQQN3CX7J8fAbTBYbOLJuyrHpK51xM4aEX8Pq5hOau0mDgq1nDKW
         sJxwRTWdkyFOfVu6kD2GwuZAzgj0Fw5quvsjPCIjChCGqf9B6jjdPEw9nvLFfebAuTvE
         OQXq3zfcONH1+N8kkFcSRC+qFa7dUm5fjKZqA/ORgjQ0sAtHctPaMi9mrBl4OxEN581O
         ezcQ==
X-Gm-Message-State: ACgBeo1GkFSJopk/TRNfsJ4e6ERHVnUquUW7Edi9RMJUAX/hF+DkfAVM
        IHWTsZZUf9tChG1xP1ufkKwy36hQnKRyUw==
X-Google-Smtp-Source: AA6agR7RRqll1LbG38UTTjdk8smXbr3pUNh9agoHWb3kNNlVDcswHYB6qyQuYmjrAb6qBzPqTw4PWA==
X-Received: by 2002:a17:902:b7c8:b0:172:ba7e:e546 with SMTP id v8-20020a170902b7c800b00172ba7ee546mr1324289plz.22.1661472306941;
        Thu, 25 Aug 2022 17:05:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902650b00b00172a567d910sm118008plk.289.2022.08.25.17.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 17:05:06 -0700 (PDT)
Date:   Fri, 26 Aug 2022 00:05:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     Thomas.Lendacky@amd.com, bp@suse.de, erdemaktas@google.com,
        jroedel@suse.de, kvm@vger.kernel.org, marcorr@google.com,
        pbonzini@redhat.com, rientjes@google.com, zxwang42@gmail.com
Subject: Re: [kvm-unit-tests PATCH v3 04/11] lib: x86: Import insn decoder
 from Linux
Message-ID: <YwgOLu6qS0PEw5fL@google.com>
References: <Ylm0ZmhaklG9AqND@google.com>
 <20220825164221.17971-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825164221.17971-1-vkarasulli@suse.de>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Vasant Karasulli wrote:
>      There is at least one test that I know uses string IO i.e. x86/amd_sev.c.

That one should be easy to convert to directly do #VMGEXIT when SEV-ES is enabled.
Or maybe delete it an enlighten emulator.c's version?

>      I will check if there are more.

Tests that explicitly validate string I/O aren't all that interesting, we really
only need one string I/O test for SEV-ES.  I supposed one could make the argument
that it'd be useful to ensure that string I/O generates #VC as expected, but that
can be done without actually decoding the I/O.

Hmm, or cheat.  E.g. write up a dedicated #VC handler in x86/amd_sev.c for the
string I/O test to forward the #VMGEXIT, but rely on the existing checks in
test_stringio() to ensure it was done correctly.  That way there's no need to do
fancy decoding, but the "spirit" of the test is kept intact.
