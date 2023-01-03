Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9C465C503
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 18:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjACR2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 12:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjACR2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 12:28:43 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A399CCE38
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 09:28:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id w3so1671746ply.3
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 09:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w2uVS5eI19Sw6Pc56D5ioklwVGcQUUbM38KUYxIR6ak=;
        b=n+JTS1k/8UiePU8wPJwDa4SDhOG87oYeCrIP8gry856ZIQIha0HBYEGr59X76GK91/
         8X+Q+VqESr7KgebNWIj31b+VCkgQzBC+oNvSoV/nl+BieHJL1wX9r6IjGmVg1KXPBZ6x
         O3F+32yVS9L+un62CT6ubslHBTh49QQL1KhTiVIhSAOhJ8c74cRRMMjr+NDhM4hmThjC
         To0igGXyZ8CzysaUA74v0psNTtiAUKhRySBhaFhXND8kqcrfCCO5pzJSaw+/ghTfqhEQ
         2+POBYlQQY8MuMq3KZfTEqYmWMMaBtkIArqnEgOTGo8ScXXEGI/o0nWlow5lYy7uQ0EO
         Bu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2uVS5eI19Sw6Pc56D5ioklwVGcQUUbM38KUYxIR6ak=;
        b=OsNCdIn+qdC7wIS9TA8zYI68QYO+QWS4VYvNGQAjeEwxbUseQ8R+DdPQnztxhgsM1S
         sNueeTQe8p8gaCjS9pFWB+kwUsdy55glmhgpVLHavXNTlevJoDClsmquDwo7Cli4Ib1Y
         rWuGSl7+3YCgnlxWJ28pMIptiFYxiDqHu1y+J/agsRbFKIcwHywQLvB3NpPazwY/c6fV
         Pf+YMlYQBi1N4AzwUEkAbXPBuyxRCboEQRVmTXx6dJaC7cdbEeNIkeXNvk4neSIe34CB
         VNVrHIwqf/8riQwYW06j6znyKy0TLwdPTDR9e10vi5Y9335QvaG2lJo2UB9avBq+hAeO
         E6YA==
X-Gm-Message-State: AFqh2kqnHy0YzMw2vrVLdSsJCsd5G73CmkubgTBn55tnV1YnwcAnPufN
        Jk5R07W12z7nQcW49hfsG070bA==
X-Google-Smtp-Source: AMrXdXu2daYGgZUniB4A4nFTJd8wZWd3dTw0doeQ29EbYux176F6z2lCidE6nvL41OQ/aLyPDYy2PQ==
X-Received: by 2002:a17:902:eb0a:b0:192:6bff:734 with SMTP id l10-20020a170902eb0a00b001926bff0734mr2452251plb.2.1672766922062;
        Tue, 03 Jan 2023 09:28:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b00186ad73e2d5sm22491511pls.208.2023.01.03.09.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:28:38 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:28:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        paul@xen.org
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Message-ID: <Y7Rlw/CWk3Pomu4A@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
 <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RjL+0Sjbm/rmUv@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023, Sean Christopherson wrote:
> On Thu, Dec 29, 2022, Michal Luczaj wrote:
> > Move synchronize_srcu(&kvm->srcu) out of kvm->lock critical section.
> 
> This needs a much more descriptive changelog, and an update to
> Documentation/virt/kvm/locking.rst to define the ordering requirements between
> kvm->scru and kvm->lock.

Ah, Paolo already send a docs update.  I'll respond to that patch, I don't think
the assertion that "kvm->lock is taken inside kvm->srcu" is true prior to the Xen
change.

https://lore.kernel.org/all/20221228110410.1682852-2-pbonzini@redhat.com
