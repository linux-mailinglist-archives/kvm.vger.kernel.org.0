Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659A859B593
	for <lists+kvm@lfdr.de>; Sun, 21 Aug 2022 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiHURMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 13:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiHURMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 13:12:07 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC721E0F
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 10:12:06 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s11so11158856edd.13
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 10:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2IG7yxCXKhrrmlYS5yO7XY8+9kSj2TtQKMSIeXBcBeM=;
        b=KzixGCuDnswaMadZqR4ynhhwNXnoXEVyUxEjeuDGHd5tL+ljlGzsi+LE8LF7F5lwRn
         v9mjz4V1ufMkIAeKimYo9EAgIy0HyOy9AOd/PAq3eqylpiDSkisiUMxEQp1Y8V7AtTGo
         NbrWgFjyqJ/5NmxocTy3bgtBX7ufagCwkWDhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2IG7yxCXKhrrmlYS5yO7XY8+9kSj2TtQKMSIeXBcBeM=;
        b=7qb/nVdh3e/XmFB5CyEOm/UYZF2rhflqYhHwEDczINjrnQD4ZOrDTig89koGKCupsm
         ULZh57bCe7hQ0tUP5+ZpC6gGcUUU0oFzE+a5OYFM8jZ+6Si48Dmmus63/gKNUC/xLoGB
         nAv1lSa7x2CR14HazAo1LARpu55O+ct/f0VxxC1lClvkgy2MeuY5DjoS2lRn7ChwxjDs
         gwiAXaIHfdHyrV2ZWi3Beylfb4tqzMtZwaA4gMnWSFLliSVJT6KqoyhtpVhULhb7swuU
         7w0AyvZb1swf/rmpihcHwKu3Y3N4IKUelfVSBf9O5QVbxY0XGFnIS096CKrWAOOEZmg2
         WJFw==
X-Gm-Message-State: ACgBeo3DY04svyuMrTQt3xPoputO98aPolQM5oRJL9Qcdoc07Tq7Hb2U
        Q8jbnDEMnTumuJ22sgOj+cAX+TsvyYK12uTe
X-Google-Smtp-Source: AA6agR56dm72MeEV+T9KUcLW3q/sCHkoZHewR5Cr5fyPhwU0UA6R7xRUmo7kzkC4vZJAkdCaLskfJA==
X-Received: by 2002:a05:6402:2751:b0:443:d90a:43d4 with SMTP id z17-20020a056402275100b00443d90a43d4mr13548903edd.368.1661101925066;
        Sun, 21 Aug 2022 10:12:05 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090630c900b0073c9d68ca0dsm4119467ejb.133.2022.08.21.10.12.03
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Aug 2022 10:12:03 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id r83-20020a1c4456000000b003a5cb389944so6574037wma.4
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 10:12:03 -0700 (PDT)
X-Received: by 2002:a7b:c399:0:b0:3a5:f3fb:85e0 with SMTP id
 s25-20020a7bc399000000b003a5f3fb85e0mr10127541wmj.38.1661101922857; Sun, 21
 Aug 2022 10:12:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJFc9AnH_9CW+bSRotkKvOmkO9jq-RF6dmyPYOpq691Yg@mail.gmail.com>
 <20220819190640.2763586-1-ndesaulniers@google.com>
In-Reply-To: <20220819190640.2763586-1-ndesaulniers@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 Aug 2022 10:11:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLcuvDDS3rZfEgDrwbdJrTx8HCRNiZ5cDc80-_gzHCxw@mail.gmail.com>
Message-ID: <CAHk-=whLcuvDDS3rZfEgDrwbdJrTx8HCRNiZ5cDc80-_gzHCxw@mail.gmail.com>
Subject: Re: [PATCH v2] asm goto: eradicate CC_HAS_ASM_GOTO
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Borislav Petkov <bp@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Applied directly, just because I love seeing old nasty stuff like this go away.

             Linus
