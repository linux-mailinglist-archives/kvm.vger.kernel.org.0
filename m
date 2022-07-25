Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512A8580551
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 22:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiGYUPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 16:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbiGYUOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 16:14:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAD722282
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:13:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o6-20020a17090aac0600b001f23d8bfe2bso6256568pjq.7
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=aXF39YGuGq7rFD1Pd5G269OU343VpF9tMbBwMhURwGI=;
        b=Je2tn5OPhtP29EI/zHpQnrwMiKB2FfehJZGB/irDk48vHhqNGMptB6NNqi+kOaFTP2
         HTG1QsouWfAfiMrpDfJKQx6chFfhZ9WmOhBnlNHSAnDHOBBBY5gUETwzcQOi9MpJA8/C
         rMthn8tesU2bfFFlVffb8jg1ZXWdCcsBkq90Yyq/OldMMN83lqLRGEQ13p1GEnr3c0Xe
         dw/7MhmX3z94ZPrI58oUzgUVroHZWqXX4ggoLCXg9t2SJ3AUiv2AvqPgblGomXOdybfo
         ApoGkp29m5nzWBSpY64yhGkABkFsi3gP16ESJ0BM27T0AUuRVnX+nVdbohQ/5cNzEp6V
         K5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=aXF39YGuGq7rFD1Pd5G269OU343VpF9tMbBwMhURwGI=;
        b=AoIYUId5tvu7jnPxoaFbxQBbDNjdeJJKwkjwCr2mbSEZqyCPXrzA6cl8u0uSz6oSg1
         3FSSigTEnYgbkJVrAtCSFc4k8HNmEZBHNul3pofHmNe6Vfx3Kx1pCAAzjWVd06SDS5si
         S2jrvaNRGHOnxhskp6GO1GW729s9eZLeWvT9w8p/Mu7xt1iK6mQGHHglZtV1zBc7YrVX
         FMYZ/NDfa+84AoqMPH4MkgLisG5kWtEgthpC3VrwyrfHieDauOFtY5yO7PdBEyEOFHV1
         TpRK4Xg8V/+7c0pCmGaCQQO/a9S5qkccu9ZxmuXv+G2+L/ro3lH/vGfk/vdYiR6LMsMd
         Rq6w==
X-Gm-Message-State: AJIora9mLCA8EGBX1p36MhJTNO/jufEFuIIeF+vV0rCvbkt+VnDZsYQo
        r7Mn5KG4HWPN0dcI5XPxiVNlRf5Goy4=
X-Google-Smtp-Source: AGRyM1uU54RYk3oEHtH73M9KHdH7/zoRoZmuQYFrf/W4hLWxlgeJrbSXr8qe/ln7TDid0BqHb6ZjI3rjfwY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:10e:b0:1f1:f3b0:9304 with SMTP id
 p14-20020a17090b010e00b001f1f3b09304mr26596pjz.1.1658780019151; Mon, 25 Jul
 2022 13:13:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 25 Jul 2022 20:13:34 +0000
Message-Id: <20220725201336.2158604-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [kvm-unit-tests PATCH 0/2] x86: Don't assume !x2APIC during boot
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get the "pre-boot" APIC ID via the x2APIC interface (RDMSR) if x2APIC is
enabled (per APIC_BASE) instead of assuming xAPIC is enabled.  UEFI SMP
support[*] wants to use the pre-boot APIC ID helper to configure GS.base,
i.e. before "resetting" the APIC to xAPIC mode.  This causes problems for
the SVM INIT-SIPI test, which sends APs back through the boot sequence
without taking them out of x2APIC.

Posting as a separate series mostly because I don't want to respin the
entire UEFI series, but also because it's not impossible that someone
will want to run KUT with firmware that forces x2APIC mode.

[*] https://lore.kernel.org/all/20220615232943.1465490-1-seanjc@google.com

Sean Christopherson (2):
  x86: apic: Play nice with x2APIC being enabled when getting "pre-boot"
    ID
  x86: cstart64: Put APIC into xAPIC after loading TSS

 lib/x86/apic.c | 14 +++++++++-----
 x86/cstart64.S |  4 ++--
 2 files changed, 11 insertions(+), 7 deletions(-)


base-commit: 7b2e41767bb8caf91972ee32e4ca85ec630584e2
-- 
2.37.1.359.gd136c6c3e2-goog

