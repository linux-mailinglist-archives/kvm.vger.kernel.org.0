Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081465721C2
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 19:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiGLR36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 13:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiGLR35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 13:29:57 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3C4C1652
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 10:29:55 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a15so8458334pjs.0
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 10:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cPzGU1EfDB8Kgcn5JHE6BwdeQ1cMejvPjGeavCHnVz8=;
        b=FaJWZzBb1jX9HT1+ULW4ocEesfyiky40mJwIH0YyxpvyU6kqJHizewanQP8vaIOQfe
         A1HyUBeFmi4d1vBQY/nVowUu2tsmDyZBUAKSAJ5bAbntJYNdqgy3jh1XhHbky0Cc70Jp
         TafIwYWjwpyj3IbKU6k/WaDePxKSkpHBDZDWRJH/VhEwbfwbmWFGyCcjoy3VzFx4bQk8
         U2+I0yGzItVxfWW0dY6YGJrxec6sm2MeDqlaEm6u+iYkYOKW09IcxdCjRKedL+S2qbNA
         CcR/6f5kTt5JoT2BZbUcqbXTI9ZKMlLbZqDxGuKV1z+Bo4ytbimnupH+F1rd3DZVZbUi
         WQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cPzGU1EfDB8Kgcn5JHE6BwdeQ1cMejvPjGeavCHnVz8=;
        b=gQQB4ArpdX9N18pGoho4pR5ecdEapHOms4hTLkPKB4ekU7KAgexjWi5QrIMOdoFP4V
         Jmu6IQOabwJBa/gw+x1WACOTdBP/SB5uMi0c4hcpscDFafnZ+873VAc56xNwzit80k2J
         0+6o0LMY6NEdWd/NjOEB2xTfoFzfzh+/nI7zf+LiZWXMZao5IemPxgxnPhIK8WIP+Qht
         9QCsTdAXzv55DGei6IPKqKshQ2Aw0M8EL+uTu2bHDDcU5tEhLU/6BwRwohhmdoDjV1El
         3AFvy/rMG3wpr/rnZwf2n4z14Pj37ZjZsW+9QmXI+20UOPAQjFSAAugDTZk1n80z8b7v
         +3mA==
X-Gm-Message-State: AJIora/E/GY2kTNhtqmaLLAwcst2c2UvWORfl+OcSJqzngGKEELIpt1e
        g9JTGngKg6TetuFyj6KtCuWIwA==
X-Google-Smtp-Source: AGRyM1tv8Boig7iuJJg8G6TPawy0AOJXdxhyWB7ZE4Sbrj6cY35fVhpvSWNf/VS6E4WPsivU8vCfYQ==
X-Received: by 2002:a17:902:f691:b0:16c:4043:f6a2 with SMTP id l17-20020a170902f69100b0016c4043f6a2mr13927905plg.72.1657646995183;
        Tue, 12 Jul 2022 10:29:55 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79592000000b0052abfc4b4a4sm6430987pfj.12.2022.07.12.10.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 10:29:54 -0700 (PDT)
Date:   Tue, 12 Jul 2022 17:29:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH 1/3] KVM: x86: Mark TSS busy during LTR emulation _after_
 all fault checks
Message-ID: <Ys2vj6snMhuSJbso@google.com>
References: <20220711232750.1092012-1-seanjc@google.com>
 <20220711232750.1092012-2-seanjc@google.com>
 <8307c007823eac899d3a017d1616e0d08a653185.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8307c007823eac899d3a017d1616e0d08a653185.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022, Maxim Levitsky wrote:
> On Mon, 2022-07-11 at 23:27 +0000, Sean Christopherson wrote:
> > Wait to mark the TSS as busy during LTR emulation until after all fault
> > checks for the LTR have passed.  Specifically, don't mark the TSS busy if
> > the new TSS base is non-canonical.
> 
> 
> Took me a while to notice it but I see the canonical check now, so the patch
> makes sense, and so:
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Unrelated, but I do wonder why we use cmpxchg_emulated for setting the busy
> bit, while we use write_segment_descriptor to set the accessed bit.

99% certain it's a historical KVM bug in how it updates the accessed bit.
