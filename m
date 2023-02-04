Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA768A745
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 01:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjBDAbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 19:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBDAbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 19:31:16 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C099D57
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 16:31:15 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id oo13-20020a17090b1c8d00b0022936a63a22so5340186pjb.8
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 16:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lByIgZGDDz1AWQnoy/jL6LEoFJ0M1TjI3XQiO+pftNY=;
        b=VqP+YWOOqsRWJRPmCBx0Mr+woCuy3KOE8jYw5LIC/xF6h4IYOJvrtqqADJJaxlqpzd
         MnL9CZA1UO5WRgNc3vTKBCmJYrZQr9aj3sq+FtO61yppNGPv0cYvcPnqfaVx0gRumXrZ
         CXX3a501VCjSguEwnMBMrieeXDoEWx7Iq7kpVqDipjhfwFgTgHDHCPEBk5wk3AsH9+uJ
         P6xqxoxGgYkdXy1t4StSKm9fZKP4LebOxgKLI/y/qzjexVjCQYyELyYGQZIkJW1d58Kn
         2feKjMy9qMLtrY/z6QUHfpl6SRjw6O7gHkdxHlCvE794PBBkQCnm9uFcZYyQXorNH3Tw
         xqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lByIgZGDDz1AWQnoy/jL6LEoFJ0M1TjI3XQiO+pftNY=;
        b=OsTeWzvKu+HBHvxa2Z8ysHp8KI5f01guuyRR8QtlAZCupLzx1a6xwoRX3C3YKbClHe
         sP+UL6db5V80OOF7OVFARkB9zwnJaxPFPvLgDqbkzDsiIhNcmPqQnjxBDGPmozrj1jX8
         9rQgQ137EZzJBjMZIdtH39kUnPirEUD/S/WjprGREqGROpUphIIvk4eta0h4fkhAvQeI
         xq2zmhYF4G0ZlR9bYoJ8nGwdDQWW/TxxQR6UqEPh+fs2eylz6Odxd/ewsaxLqEtDn9gA
         HSv+Z/EvpyNrbbc8Tz/E6oIA2omjzpY+ov441Fqf3l1kt2h6T33Gh9+tDMy+6MMObsOQ
         RkbQ==
X-Gm-Message-State: AO0yUKX1W5WfuBoYmtcWPTxzQ+Z2ItWo3/j5Avtq/1aBuaacyzOMCZHA
        Byh569+JLps6zSzd/d+vaoh/NnLzDNA=
X-Google-Smtp-Source: AK7set/MczPM2IFN62Nho0mzVC3mhJ4+ZSv5nl/K8Fj7Hf5quUjWrxBDGJRVMEQtoctyeOW5VYnH+nqYK1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7794:b0:198:ef8f:4d89 with SMTP id
 o20-20020a170902779400b00198ef8f4d89mr207059pll.15.1675470675363; Fri, 03 Feb
 2023 16:31:15 -0800 (PST)
Date:   Sat,  4 Feb 2023 00:31:06 +0000
In-Reply-To: <20230126013405.2967156-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230126013405.2967156-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167546527977.181193.13181130110472254623.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com
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

On Thu, 26 Jan 2023 02:34:02 +0100, Michal Luczaj wrote:
> Two small fixes for __load_segment_descriptor(), along with a KUT
> x86/emulator test.
> 
> And a question to maintainers: is it ok to send patches for two repos in
> one series?
> 
> Michal Luczaj (3):
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/3] KVM: x86/emulator: Fix segment load privilege level validation
      https://github.com/kvm-x86/linux/commit/0735d1c34e49
[2/3] KVM: x86/emulator: Fix comment in __load_segment_descriptor()
      https://github.com/kvm-x86/linux/commit/096691e0d2a1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
