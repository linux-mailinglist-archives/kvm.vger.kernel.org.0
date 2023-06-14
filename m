Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD6730812
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjFNTWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjFNTWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:22:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCA1268B
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:22:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5695f6ebd85so12392097b3.3
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686770522; x=1689362522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/rLVEpofQ0Syv4PvfDPAbW4A331iFXceGCzfBsi28U=;
        b=PL2iPrBfrKmXWEBz7vuBuxZ7qckazlTTOs/xfuGuY4nyuX0n5iZ3LQlNbqI01Sj3sL
         lH4BASGdKby+IjXBFsi2RGxfRbnrnTFv1xltUC4ljposNxP0zoLCavrmvD/U+ts7N39Y
         Mg2WyAebEctMEXgsbIK8F5BuVXiM/P4DVt9EgGOyON3H90vHpV3iWO/rRVjF/NEV7Tdk
         TGJW2DO1PMxKVO54DXFknrsvaH8usosUD6DLTl4/AyiNaWzV3g4jgInGaoHpBCozt3cd
         9B8Sfp2RR1sgdmTSmTllDOLRrY+6VvNxSILF3w6DBdjjZ75IYtgxnQ3GWfBmGQ1lUtHg
         RKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686770522; x=1689362522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/rLVEpofQ0Syv4PvfDPAbW4A331iFXceGCzfBsi28U=;
        b=ZPys8JxVgKOyy7n3qFFq+8SSTqWTZCfV2mf0eYeeam/1sTmGXVw7X9KaoCmzYpq/xM
         mK+7WqaF7PKq4QPqKI2tPxoUsIvx411NL98FuOBuD7YLFZmVyc1mkSa6x89at1jZnwHs
         MzSy1RknjeBBSA5TZP+0oB7x64WAae+b1kDhohB0/Y7bKLg3B7mONCl3LgBYbC6/Nq//
         FVrQ+kGJrN2xloo5028ZEq7R50+yp3sxkV3yVJPc9ss3TUTwKWMCOdAf2e5BbWm8G9Ni
         T0F1WarYBmYFkcgTeSX9+7HYHFn2DPtYbnx4rdF5FG182ie1oOcbfOEYodtT8o5s/ZQj
         8r9g==
X-Gm-Message-State: AC+VfDw9KVG6OWGARNJSpGLB3hFfkCj7kPXUi6om6foV4KpRkQwmonav
        iPfpZdZJfLTYB8jJR44EfLsmpYuTwpI=
X-Google-Smtp-Source: ACHHUZ4XL4je8bVAYp8sAYeHVrXp2XZS1qxkvwKba+fbhBkdCi0K0movi/2XR1PLhVUYWMzlpC7tHAxehGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4501:0:b0:56d:21a1:16a1 with SMTP id
 s1-20020a814501000000b0056d21a116a1mr1209862ywa.5.1686770522234; Wed, 14 Jun
 2023 12:22:02 -0700 (PDT)
Date:   Wed, 14 Jun 2023 12:22:00 -0700
In-Reply-To: <20230602161921.208564-7-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-7-amoorthy@google.com>
Message-ID: <ZIoTWOmM2a3iVDAi@google.com>
Subject: Re: [PATCH v4 06/16] KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures within
> kvm_vcpu_read_guest_page().

Same comments as the "write" patch.  And while I often advocate for tiny patches,
I see no reason to split the read and write changes into separate patches, they're
thematically identical enough to count as a "single logical change".
