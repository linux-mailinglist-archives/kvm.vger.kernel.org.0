Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3170E6743F9
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjASVJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjASVJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:09:18 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125209FDE8
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:02:25 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id h1-20020a17090a470100b0022646263abfso1429167pjg.6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eDFHsxZE6WnWPiyaWFEGdZYHZw6Jl23+uspi1Ylj/bI=;
        b=eE+xLMKTVbe83/vvnxoXLWgVtpdulivQgymwGJU+d6dNlNDEGWoSKqQAdFDaE6DRhY
         7twUkU1yYpejM7GAJQ76zNkgYA1cy0DRa19BTgyzKI8F5tNjkO7CezNEf4f236ftrM0j
         gZ/YsGRn85xo5+Fpr+EWI5GIqOh/dH1zkaFUHsx55wAQxQiMH4tZ8TAZScRN5tP6W+XW
         X5FkdOKo1bYR6DzUy/GQFbsQHFv6g8Wzv02IVW4oFRybfGcFhKQEy7M2Cav2bPtUPvvj
         o5MkZeJQiabAEt01JlW0RNHIFt/jhZGwgJ2TCaPIDH2bmYH/Vf6PG/16+1tWfD9mWzKi
         zT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eDFHsxZE6WnWPiyaWFEGdZYHZw6Jl23+uspi1Ylj/bI=;
        b=N5cMfuf3e7+PeYBKI9UdwNJzYkn6HOUMZv2Lb/fzhCQFavBFsiaAsYPgTeSuuPDUYj
         U+6zncTX257t/P88eu4Ys5g3Gjzf8pRvRsgWhbLgyxt53dXS/on9jO3yPtK4+h0kSfHL
         bfghkM7BIqqTtGLIwSD1cP+hvqc2M8F5IQA+4utAN1xGDFjLD4xxV0+SI/l+Al7O2qsO
         FK/o/z7+CUmndYuR+sdBPOCReMDzS2UPtGhhGftlc5ItdBxSlysMp+olNRDjYhw7HCDt
         Adbck33vvR++8dhpj+bBZeRt274lK4C0ppA1LThEE3yAyrl1qjV/TrqB6hKXxZ+tL7Bx
         E7Kg==
X-Gm-Message-State: AFqh2kq60CiW9OBjnzZySr/5+YfbL871zyIAHaoi6gBlaBzvpFt018NQ
        ROiJiPfq38+GY2TqmEDscTsVKbGjjik=
X-Google-Smtp-Source: AMrXdXulSClZQ8ubBluIxMxkhtGa4HocdGBesVdMDQcXnzU9SYa8kSQ52vDEsfp/0/mz1cGeJwSHsBjcSSA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:910c:0:b0:58d:bb12:2da5 with SMTP id
 12-20020aa7910c000000b0058dbb122da5mr1081255pfh.27.1674162144539; Thu, 19 Jan
 2023 13:02:24 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:01:23 +0000
In-Reply-To: <20230117222707.3949974-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230117222707.3949974-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409119811.2377485.14729800505315505470.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Stop assuming stats are contiguous in kvm_binary_stats_test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org
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

On Tue, 17 Jan 2023 14:27:07 -0800, David Matlack wrote:
> Remove the assumption from kvm_binary_stats_test that all stats are
> laid out contiguously in memory. The current stats in KVM are
> contiguously laid out in memory, but that may change in the future and
> the ABI specifically allows holes in the stats data (since each stat
> exposes its own offset).
> 
> While here drop the check that each stats' offset is less than
> size_data, as that is now always true by construction.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Stop assuming stats are contiguous in kvm_binary_stats_test
      https://github.com/kvm-x86/linux/commit/d9e552858fab

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
