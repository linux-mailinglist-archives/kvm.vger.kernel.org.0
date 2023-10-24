Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056F37D43E2
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjJXAZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJXAZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:25:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69FD10C
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:25:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9d140fcddso28138375ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107122; x=1698711922; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LWHz1xqzDxYD9+2i5v6SK4a1uaV9iTpi5M+TWlqOotc=;
        b=MFmCHNsmdyIBqdk+4C2iw+qYybxCOhwo9VKfTMR2x/E21VATr79UCdlwGOta1vjVb4
         tu5AClHeCz8Logj3Gi9zCjtqJSYQoEKJQtwpbFNRCyRr8i4+4xLtqJrYXr2cY2sKZagO
         cXGjTSJgxhI+1qxkxiQpRL6JSXfxYUn1Tn9rZG2CuHf+cqjgP8sI7VNc7tdrLx6QoNrF
         /9T6ykc7MApXoEgL910EfNxywas3kmGLr9lx+P9jLD2CTticMh36wkqgZFToCJIL7M88
         lILIkQBcqRzCOlbDDdq+xqwA9Bn9rxuxXWWefRmnyMiE0xKgj1YzMuOwWVSkEY4KcwxY
         WGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107122; x=1698711922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWHz1xqzDxYD9+2i5v6SK4a1uaV9iTpi5M+TWlqOotc=;
        b=uRmOpxrj+sm2lAH4ssTfMKnAWlub3SeUhHNlOF1HdH2zImHHXlDWj/Ul7E5jgK4wq5
         V5vhvISXKaV4TFEZB271t9frNnfZA5MXegHj5YfUvjsbhw3g7SvEQ41Y9q7LzBSc+J7I
         SgW8s6/0S+wxIdiPpdk9+0rYrDgtqiwu9qxC/QAzN6AOoV46aUAJEBZdKfI1t6T0wbuw
         cs/AgV62/zljuc0doRQil6WeBkRZuqhD5AT+/nRCu3LoRzZrdwa5owjsAVxwYbuofqTi
         GKjWJJRsj/A98mrGA4l7CqJlBpRWbsx8IcmiHfuexmKECzqI2KwL4hQqXENIWWDGtZSc
         7VWQ==
X-Gm-Message-State: AOJu0Yze4cVS1z1M5b2v5isJ0iMaElYk4mRrCdbafJkBsDkrRNYZZF1m
        LS5dYqzQiC5YNnX3FoSJV5O2MFJFLFM=
X-Google-Smtp-Source: AGHT+IERVP40ibj2QvNPZHlcK/iNwPR3JZUcKqn6YP/CcGabDhaZPbxLiowmyl60pgUPchkHXu4EtKRjlxY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6548:b0:1c9:c95e:6b2d with SMTP id
 d8-20020a170902654800b001c9c95e6b2dmr192625pln.4.1698107122205; Mon, 23 Oct
 2023 17:25:22 -0700 (PDT)
Date:   Mon, 23 Oct 2023 17:25:20 -0700
In-Reply-To: <20231024001636.890236-2-jmattson@google.com>
Mime-Version: 1.0
References: <20231024001636.890236-1-jmattson@google.com> <20231024001636.890236-2-jmattson@google.com>
Message-ID: <ZTcO8M3T9DGYrN2M@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Use a switch statement in __feature_translate()
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, Jim Mattson wrote:
> The compiler will probably do better than linear search.

It shouldn't matter, KVM relies on the compiler to resolve the translation at
compile time, e.g. the result is fed into reverse_cpuid_check().

I.e. we should pick whatever is least ugly.
