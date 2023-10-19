Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88AD7CFED0
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346328AbjJSP5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbjJSP5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:57:12 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D138D183
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:57:10 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9c83b656fso68285255ad.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697731030; x=1698335830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+Nzjdqi6hUnxFgEsoy4miCeVGRYpBdCWRExTpoLOZI=;
        b=M/A6Wv1zw+mrTlRT9rP4fbEc5i301B+AEHaGWs4ltiIItqe8VtiIq0hVS+RVrhAwFM
         IlizYeMDgAnhKowcGcCkZ7yrfBM8W14BX1uB3lkptaldCcI0/SDy2yZKrboi1STM7qYH
         nHt5XaBjJikb7RkGkR5It97GICf2ISKvhqyFGMFeBVhPwsatfNG40g8h8oGPOYaT0nxg
         4W/91GHeJ8g22vfpOyywbm4sC3FBvI0wdjH+uz/kk62J1GGyMF3rdiL9ihnrlu39g9y4
         NKi1dnL/Rv3Du/tuyd8khutwj1PJhy4f1euEuc1rk6B9F0ETJ0ZYmYQqEjLOqJu98tek
         F2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697731030; x=1698335830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+Nzjdqi6hUnxFgEsoy4miCeVGRYpBdCWRExTpoLOZI=;
        b=jdEoBSFBZG5owOaMftJfMjKd7O9LeiZ+9dwRv9NhTmffT0EQmfH5YgyBZ5/243IsFT
         3J/bzqejEm+oa+he9jxVrBYnFVyKm40ZCbI3so0LKn35Fsy5w36CF9fQWbStTSTK3fQd
         BqmS9orNWNVM8Hd6aI4ksgUoUAAZVk3Fb8I1z7hftBj5J88ZlbAYm4RitfS9TFkz3m6O
         +P2IUi4NEMLRauZtElr9om+vA02VWaQSXrsjAL0AdCZVOUrpQ/8cBMNJgiatKrgaJruL
         cMj9DZbm3umCWDgUKgskpTR45mayzamIWp+DJvtgD2GteSNXYu+qcGZs/TEN7IojwgKm
         6+mw==
X-Gm-Message-State: AOJu0Yw0IyMFZVafp1LWloCI8vuoOItycPf5uTKas8J8enV/IW7ro1mt
        UGLvWkrI0OvN3kdSu4TruWRwAyg8efA=
X-Google-Smtp-Source: AGHT+IHtELrPIAJmWHmZp1X+bY65FmJvI+yMtiLzDapWCyu5b06ltZldaak2VBNg1hwDtnv/LPZwQwNtJHg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1002:b0:1ca:2ec4:7f51 with SMTP id
 a2-20020a170903100200b001ca2ec47f51mr48182plb.10.1697731030260; Thu, 19 Oct
 2023 08:57:10 -0700 (PDT)
Date:   Thu, 19 Oct 2023 08:57:08 -0700
In-Reply-To: <87wmvj57hk.fsf@redhat.com>
Mime-Version: 1.0
References: <20231018192325.1893896-1-seanjc@google.com> <87wmvj57hk.fsf@redhat.com>
Message-ID: <ZTFR1HLRoNdYxVa4@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks
 iff HYPERV!=n
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Oct 19, 2023, Vitaly Kuznetsov wrote:
> I can take it to my CONFIG_KVM_HYPERV series but it doesn't seem to
> intersect with it so I guess there's no need for that.

Yeah, I checked before sending (I've had this patch lying around for quite some
time).  I was quite surprised that there wasn't any overlap.
