Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04271F7B7
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjFBBVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjFBBVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:21:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865681B5
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:21:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-568a85f180dso20641297b3.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668902; x=1688260902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E8/ZQDn4lQxbq9Kv926uaNMZbM7Cblwtjn3q+UPTzec=;
        b=Hwisx0vO5cMNabBWQp2fM/HSKoh10ML0abHqwJGGr0qB8l1kCZLWgirynab2M0p2Kv
         L0k8RANoQwrjO2x6fWhtp7CePjL1odw4yrS6bY9qhGULjxlEpz89+YqwvlkE7FvXkQQn
         0AaqwpzQHLEdf18s4pGnGN6NZt+oBYDaWHB6S9uTwiuB9YH50jZrZuLrSSpoVBtQUz6R
         /u4zpXm5ER2jSETpYU970B34v2fHC6EX0ulAROmJx37lg3VCgGVr2DhjQLdpZKS4aTMz
         p7zsIZwMUQMxcyx9f65zI4WaZ7Uo3e+jBvxefCOUwA2kxwhkDE0wbML83QtA9YPDgOeA
         hypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668902; x=1688260902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8/ZQDn4lQxbq9Kv926uaNMZbM7Cblwtjn3q+UPTzec=;
        b=Qlpl+mW24Qs7JNqi+7ueZQSPQfk4n9eIZFaEVZcLWauB1t2yypenmGodwcMUXm92WB
         fMNEbbVfROV+w+zH7czkzBGHFB3hvtFxBvOnnOfGKdi8N28O/fgZhs0NO4pmURcE8heg
         PU9Va5Msziiw2VijbgoVeUpq3FtDwZ2lQ8YHFu8058AMZ6PfeVd7PI+dmXk9V6MG0Zct
         AVdXTjYPEjD3KxKcKLZdAsIRP1TwZeb0ksH1iEJHKHdTEViPwH5yunkW+IFBWpdmMC0n
         aC+ilg3vNPuCvHzCZtPqtNKIQjmc50KYLA7KQAr3gDFX1UB8/fu5j3jttwC7IAgN3ixQ
         iKsQ==
X-Gm-Message-State: AC+VfDy2mZmqr9FbPzup0w4WoEwzM3l+xRpZ6oEL1OotIMS+fq56ipOq
        IZdaL00IeLSblZj27Yz+x2H+MQ6xaVc=
X-Google-Smtp-Source: ACHHUZ5Bl/HGC1nLPCY/p9KC3Ia4ZxgrAdISshCOaKLBkJi2Wq89zZ5D1PHQOcWY9uGh7bNcHg9y577PwHQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af15:0:b0:568:ee6d:3364 with SMTP id
 n21-20020a81af15000000b00568ee6d3364mr4016244ywh.4.1685668902772; Thu, 01 Jun
 2023 18:21:42 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:20:58 -0700
In-Reply-To: <20230307135233.54684-1-wei.w.wang@intel.com>
Mime-Version: 1.0
References: <20230307135233.54684-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565180722.660019.15543226381784798973.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, dmatlack@google.com,
        mizhang@google.com, isaku.yamahata@gmail.com, pbonzini@redhat.com,
        Wei Wang <wei.w.wang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 07 Mar 2023 21:52:33 +0800, Wei Wang wrote:
> Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from callers is
> 32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
> provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
> will be converted to 0, which is not expected.
> 
> Improves the implementation by using bool in KVM_BUG and KVM_BUG_ON.
> 'bool' is preferred to 'int' as __ret is essentially used as a boolean
> and coding-stytle.rst documents that use of bool is encouraged to improve
> readability and is often a better option than 'int' for storing boolean
> values.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
      https://github.com/kvm-x86/linux/commit/c9d601548603

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
