Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94834674408
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjASVLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjASVJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:09:39 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A46945BFD
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:17 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id j1-20020aa78001000000b0057d28e11cb6so1431222pfi.11
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=glbcvlue13ghg8fH4Z2hVVePF8XkK30IUFyxhvitmoc=;
        b=PoXkJxhppYvejc4Ue5Kc7MilB4VjNe0O2Q0ydftnFLHGPH5qza5QOyQ+nErDMZMEhO
         10ySBbjw7rOKoIG40umUCJGf/ssh0chMeMUYZx1zdO7XqiCqWgSajk1LU9cudVUVJgCV
         rN7u6HshPw+tV4pywNF9ynJSwbNCEpCtF6WYbESqDbOp/nVbM4XGhJe0iUJwQqpxxWmg
         PVng0ViS+2JcheS7/jTEGs/p6sqRpDwVxE2G8FQwzbvReXaheObm8BTmoDptSo59Pplf
         tNhWeyaS8bI/iubs7JsyXzDGgrLtNNq2kN0EWSnt7V3zv3u7Mwn0Bz1dFCJnj/mB3Qmq
         5wMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=glbcvlue13ghg8fH4Z2hVVePF8XkK30IUFyxhvitmoc=;
        b=P/U6KI0La7/8HBd0kBR+sDXIe2KhQzkYM6h8kDm6e2BvDL9lvk1FQcPIGgzFNqecYp
         WkgSE0w7EoCmzQBecZJFFU5uXySIUhFVnp/LlqlzCxETyLsqlbSBgnlCAT0vX5YTCcPA
         w6gdmFHzfPVu908ZGZf8Uh+aGeKZly23YvO5ImXu1MLnxOr9vbt5PE4JJyztjuIk9Jn9
         CIhLTg1WulQDoK59TZEZYLjsSFenoMyuhFAsjjdMb5I5rlePh4nOPbUWR6ZhAf7TjmxK
         kejBuPtQ2ypj0UiBrMeaHhvZD5X/Eap7ERXtaM1IS9aKEQFWThe657DKRN4ptBYbt9ks
         rPNg==
X-Gm-Message-State: AFqh2kqSF+LK+tyBhKuT2Ppurp3DUi2y0/3Hiv5PIr1RaZvl65T14Y2e
        ZSEaQKfIycXX0H+TLufa9VsBXORX+Rg=
X-Google-Smtp-Source: AMrXdXtKOslrToo7TAuCDXajwguTTYg1prZsZVT+iQMyKdzJjwkv6ixxJ+CKpxPj/6laEFevvcX8IYNVsec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3006:b0:583:69e8:e6d with SMTP id
 ay6-20020a056a00300600b0058369e80e6dmr1061373pfb.16.1674162197086; Thu, 19
 Jan 2023 13:03:17 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:03:09 +0000
In-Reply-To: <20230113220923.2834699-1-aghulati@google.com>
Mime-Version: 1.0
References: <20230113220923.2834699-1-aghulati@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409058943.2374162.15945588703835553093.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Account scratch allocations used to decrypt SEV
 guest memory
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anish Ghulati <aghulati@google.com>
Cc:     kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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

On Fri, 13 Jan 2023 22:09:23 +0000, Anish Ghulati wrote:
> Account the temp/scratch allocation used to decrypt unaligned debug
> accesses to SEV guest memory, the allocation is very much tied to the
> target VM.
> 
> 

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Account scratch allocations used to decrypt SEV guest memory
      https://github.com/kvm-x86/linux/commit/e78dfc2b6ff0

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
