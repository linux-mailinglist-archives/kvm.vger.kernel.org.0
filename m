Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A405F674414
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjASVMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjASVKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:10:38 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2D74C1E
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:04:45 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r126-20020a632b84000000b004393806c06eso1559246pgr.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OruiUK5Dzt4kcYd4lzn/m6hwLS/eCm85+gUwuHs4af4=;
        b=B8DQpTwcBOl5QFinTXULhYJWiOvM0u2n9zkLuePwqDafaPPKj/DwVfiJEGsBXAqJvJ
         54W/ZFfKTn/10l/Q7xVgFCKS6guvjH+j1Z2DHCC/kpurjAYgNpPPg4zUdUlOK/o+RAg4
         tofAN2PrjaNNvs55g4eMBmH8eNk2oKm1aD1jt2PFIiA+wmLiu1RTznorAC/vWgZkAHJo
         UUFH7Qln8N8AdfR6yDb96b2MV0sjHf3iZ5BQNwAmf25qpWHDHH/yu15NmLadD5Jy6jRD
         QU9lUiqbXor92UhA4Vr6YasneZBKAvP0HTDf1qnp1LD5W7aOB3bg4jglJ4kCYFkoy0By
         xcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OruiUK5Dzt4kcYd4lzn/m6hwLS/eCm85+gUwuHs4af4=;
        b=2yMkhy9RJqPK5Hb6Buzpx9YJKCXQPK71nm9eQjyrzVQZKjGe3t2xXbuVAFIkj3Y3m7
         Gn5sQJ9upAosaLdwRZtzyCbW9ELnx7RYb7JzuCgyb5ZsgrYbBkh3Zq/yXvRfVPx3PS3Y
         zAmlDJtPBpGum5UAp/cNW24pVc932bex3sVtwzGfRzoOs5n3zN3rGJztWrQJRY+QhpOC
         dqqOjAiHVtlGVDC/DNZPlcWFe/faH8/o+ZixuRiedFlXGI9Fv0MVp9jjolTdvf0KP75B
         dnIBiRey8wUouHgEIbgBf687Y2wWizbAsOGd2W/Suu9ljUvpKDeZEZLvqJbzEbcpaTtu
         zntw==
X-Gm-Message-State: AFqh2krGod6YL5XH2iSLQ84/kCkE7J6Ir5KGHv+n7Oms8hQF5j8iObL3
        QkYJrgfnmPaHS8GNTXnfL1Hbn8Vyc1w=
X-Google-Smtp-Source: AMrXdXtxbLnTUd7r5/f9DDWAbgt2Sm0RbEVH02kAAOFkPSTRFl+SoPBA5rbjmjXQrhKp8XdyLtldYdvoY4A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2c1:b0:58b:957a:5ec7 with SMTP id
 b1-20020a056a0002c100b0058b957a5ec7mr1198026pft.39.1674162285418; Thu, 19 Jan
 2023 13:04:45 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:04:31 +0000
In-Reply-To: <Y3aay2u2KQgiR0un@p183>
Mime-Version: 1.0
References: <Y3aay2u2KQgiR0un@p183>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408923564.2368187.15059300523466829809.b4-ty@google.com>
Subject: Re: [PATCH] kvm: account allocation in generic version of kvm_arch_alloc_vm()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Alexey Dobriyan <adobriyan@gmail.com>
Cc:     kvm@vger.kernel.org
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

On Thu, 17 Nov 2022 23:34:19 +0300, Alexey Dobriyan wrote:
> This is persistent allocation and arch-specific versions account it.
> 
> 

Applied to kvm-x86 generic, thanks!

[1/1] kvm: account allocation in generic version of kvm_arch_alloc_vm()
      https://github.com/kvm-x86/linux/commit/9370e39e6b0a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
