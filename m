Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B2A7796C5
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbjHKSHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 14:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjHKSHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 14:07:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB1330DE
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 11:07:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d6349e1d4c2so2245466276.2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 11:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691777252; x=1692382052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=COZqDoRGH08yoJM4v4Rkr8ds3NE7H19/CuY8y3A3k2M=;
        b=rKqnc7GZnwmVL4AD1kKsOLIsmM7ht48vJ7VlAwLdvZhpk8VeKrXLGvsKeMZVzFO8rR
         znnuR35LX8aHAq8FRZXO1CkCoJhtBhq71gGg8dsiUkLKk6h6MQzAa2iYSQUcT/msY27V
         BWhZwR+ett6osrqlyzsACmu82YGgsiVkfX0gvsLzZkySnhvcUR0GgQCVi6r6s8vZA4hC
         8etnRNph2b3pLdwMj1t4+J5bMuwtdNYEAz3QdTg5aZJAXN8oKbk7zIQuenkGO2OGDdH9
         yZLQ3Oz4nMT1UAfszSBgPjXbfLZSDYKGk576nFzwf4iSSveTgRAH3fHhoNxQgmsvIs8x
         BgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691777252; x=1692382052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COZqDoRGH08yoJM4v4Rkr8ds3NE7H19/CuY8y3A3k2M=;
        b=WBxtnQir0+MvR6SXJsajJi59iYWKZ6VS1a1MlHkJbA9qMGtVuDCXUoYZm1JePZzZI5
         52Eh+AHHjBsiN+9yTwrLWWGn1M1gQ2Htj3T3lgalC7H4tG0OxnpD9llPJUUfp4GKJYCg
         xOtJjxeiVax8+2ROr6Jtgz5UClqmSTP/wLUdpYSNjBGV8yttZiQ4mXy8VcaTBEdMJF9Y
         mxzfaV3EdRixwlGPd+cFB2gzt9vGsIlRApszqPOFCuHoP4h3HUlEwcRirCqYRtzKMnHz
         quLnnEzeM3ADN+3DXAjIvVBuzliA0Aw73silcitwRh118OtxQDIIK6U3lJfJvUEy+1nR
         yROQ==
X-Gm-Message-State: AOJu0Yw9i7PfDO2f1Wa2EgOoVqXW6jpUmcny3bOW31FATg9F6vFAxmDw
        Up22MsZBzWcdbK5FDzVK7hFsN7n+CC0=
X-Google-Smtp-Source: AGHT+IF1kuAYwDpr4ZGaYh5iIfqReheBH7zwbmuRDoDz/CoicBiHAd84zxLsQkzl4PTv6NeD9KJ1fo7Rgao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:588:0:b0:d0f:cf5:3282 with SMTP id
 130-20020a250588000000b00d0f0cf53282mr43704ybf.1.1691777252197; Fri, 11 Aug
 2023 11:07:32 -0700 (PDT)
Date:   Fri, 11 Aug 2023 11:07:30 -0700
In-Reply-To: <12a72fb7-4125-c705-6dd6-733ec23de80e@cs.utexas.edu>
Mime-Version: 1.0
References: <12a72fb7-4125-c705-6dd6-733ec23de80e@cs.utexas.edu>
Message-ID: <ZNZ44ti0twIoXQqg@google.com>
Subject: Re: VM Memory Map
From:   Sean Christopherson <seanjc@google.com>
To:     Yahya Sohail <ysohail@cs.utexas.edu>
Cc:     kvm@vger.kernel.org
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

On Fri, Aug 11, 2023, Yahya Sohail wrote:
> Hi,
> 
> Accesses to certain memory addresses by the guest trigger a KVM_EXIT_MMIO. I
> can't seem to find a memory map in the documentation or source that
> describes exactly which addresses are real memory and which addresses are
> MMIO addresses (on x86, if that matters). Is there any such documentation or
> a listing in the source?
> 
> Is there any way to configure which addresses are MMIO? I hoped that mapping
> memory to MMIO address regions with the KVM_SET_USER_MEMORY_REGION ioctl
> would allow me to use them as memory, but that didn't work. The only ioctls
> that seem relevant to MMIO are KVM_(UN)REGISTER_COALESCED_MMIO, but those
> only allow coalescing MMIO exits, not changing which addresses cause them.

KVM_EXIT_MMIO is for *emulated* MMIO, and is triggered by a guest access to
non-existent memory from the guest's (and KVM's) perspective.  Specifically, if
the guest accesses a GPA that is not covered by a memslot.

Mapping a "real" host MMIO address into a guest via KVM_SET_USER_MEMORY_REGION
will not generate KVM_EXIT_MMIO, as KVM will simply map the "real" MMIO directly
into the guest.

There is no KVM documentation of a memory map or real vs. emulated addresses because
what is real and what is emulated is completely userspace defined (except for the
local APIC and/or I/O APIC if userspace enables KVM's "in-kernel" APIC emulation).
