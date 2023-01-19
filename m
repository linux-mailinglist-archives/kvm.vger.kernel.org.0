Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB04E6743CE
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjASU6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjASU4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:56:23 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7B54954D
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:55:42 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id j1-20020aa78001000000b0057d28e11cb6so1423664pfi.11
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kr5Q2q0Ve+Pe7+jty2F9WP7IXPdPCiaONGdC3SEcJCc=;
        b=JkxQZ/LVH/doRkTNSUgHIzqJaOyeOz+COgABHjmdN+WH4SnXL/nz5hbWj/VKwNNVZG
         kGbCjEn58I77K4yGndK8XJo+LUpRbqCdBfOvfrKmDnWOYl689/kkl/sBwR7RNEbd3d3f
         EQg/RX4IBBeZ3cbCX9pkToCuZ5RlWKsCE9IScqQ3J4/WZ1d2Hf2QM357nZgZkuW8KOfB
         drFIDkUY2qRqJYR6OxBeXevkWOhW+suw3TVJnOLzWlgDSiMezXr/Foo5290cKicj1Otm
         Yz3JNSvapNwD/hRyLxftb0bFts2Qxjfr+kd+N+7MaTSv+95X8urL0Bv81c+y0RDk8ywA
         33TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kr5Q2q0Ve+Pe7+jty2F9WP7IXPdPCiaONGdC3SEcJCc=;
        b=jNICsd1d5OT17NEZ2Gi/KSTxMfvP+ZX6K5E7bGkyjM65sVCqa5jMpy2zNAOAk9mGFq
         pQsQFL9V/fjQy7CfU0pFJdNmetGr6ykEbC6zLwTNWo+J0QKwLDPO7cwU5P1AJHjuyhqk
         iU04Dl9wtXE9/QZEe6EbuZOJjFTLA/TKpUytL1IztnBD6XfCzCzWWk7L5JKKEtnSR4X+
         pSTncjkbe+FzsyJsz/WCUIFHWGXfBs2y2LKkD151TPpZzPGz2gSZgzJQtWvLeQug3TUB
         rRjeTXjx43ViCevkccsjgj+8nmW+5I1C0TmgyG20kymC2Ffhf/TVGtd5mekw/fCo6y3k
         t6kw==
X-Gm-Message-State: AFqh2koHgkYt4WED9Mely6jdnPL6Y9JQ2Kpb/omjtUfquEM1wkkm9zqB
        O5EYFFVgGShuPv/6YNonb0ddz/1UsRo=
X-Google-Smtp-Source: AMrXdXsuBbPBjEznnLSHkdPQBP68LTshyCgo7rSUXG1m6MFFIQwwWFDTODCN2vx+gGO4Jg5ebGIcn9UOVlQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:414c:b0:229:9369:e62a with SMTP id
 m12-20020a17090a414c00b002299369e62amr1532308pjg.231.1674161741551; Thu, 19
 Jan 2023 12:55:41 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:54:04 +0000
In-Reply-To: <20230105100310.6700-1-jiangshanlai@gmail.com>
Mime-Version: 1.0
References: <20230105100310.6700-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408804666.2363885.5695334430262199072.b4-ty@google.com>
Subject: Re: [PATCH] kvm: x86/mmu: Don't clear write flooding for direct SP
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 05 Jan 2023 18:03:10 +0800, Lai Jiangshan wrote:
> Although there is no harm, but there is no point to clear write
> flooding for direct SP.
> 
> 

Applied to kvm-x86 mmu, thanks!

[1/1] kvm: x86/mmu: Don't clear write flooding for direct SP
      https://github.com/kvm-x86/linux/commit/5ee0c3718540

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
