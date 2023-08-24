Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1A7874E4
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbjHXQIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242379AbjHXQIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:08:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161BE1996
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 09:08:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58fbc0e0c6dso726187b3.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 09:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692893297; x=1693498097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ixXU2vNex2+1id+8Rly6dixara1UC2RdpyLH0XPBAg=;
        b=A9kEnqI0HK2memtoFt706uJhZM7N7xDMbtmemAHGlIm1eOkCLsGNXiW7FLVvY05J9P
         ETqLsxun/tk+RXvLh23UQjYbSRYhEZ9V510uNVjG4RPv9cv4eptel9Vj9R8S0ppxD/06
         Qizu9c+eNq+u/3DNdekU3zqsmJ5hgJ5j1LfpzhY194N3i9fEDEKwrKYAWCJkmxyzfe8S
         WlY1cnwQ0g1wwGxWShGOEFCCyOo29vjonYFnOfP8D7/QTuvNz63vBwXZ2yOGkZwZwvbe
         O6UtspFl1MPBJMtRckLSd8drpEIIwXtqNKt87ZmVxsrxCytOSLhhQrE60MBCe4t6acW5
         Ko7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692893297; x=1693498097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ixXU2vNex2+1id+8Rly6dixara1UC2RdpyLH0XPBAg=;
        b=I/HIPciBRCmeXUDIIJHgsEbHBnwj36WBjSLdvMSnl/4BhXrw7gDcs0ERC1887Jbmq3
         WNCbRwRksmsXK1vh9kK1FwnRJmMT1XYuhq0heKf2KdkXgAwykPKIlA0YqMl8rsAh5j7G
         5ViWj9InVuTA5wKfv+82Aumveha3bdP5BbQSFI6CBCjLVp7ioX3i7FfrUBnrxtgKeaHG
         9c3KY+3U/qYU058/3Y9v80mE0GxeMT9L8nOKP2MlYyDPHbnyNmRdNjUV+2xXIGNYVkLV
         BmcgS2VQBu8U7VrUozIGz9KU6UwP8zGsnnjim0rJg2xv6fTADX1jteLBcw933Fx5N68X
         n4NA==
X-Gm-Message-State: AOJu0YzQTzOa/0Px7B2/Q1B60QN/kBi0+JDUSNBEM5y/Ty8crIbXq6qH
        t8LqhpUAoOWN/fJ7J8ph5FWcvIMVF58=
X-Google-Smtp-Source: AGHT+IF4tuSw46JD7qw+5gQdRlBrlVirqCEscZWNprAlepko0RaD8sLBVYb5gppzeZaW50s9t8fpYJ9q8Ec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b71c:0:b0:573:8316:8d04 with SMTP id
 v28-20020a81b71c000000b0057383168d04mr227266ywh.4.1692893297340; Thu, 24 Aug
 2023 09:08:17 -0700 (PDT)
Date:   Thu, 24 Aug 2023 09:08:15 -0700
In-Reply-To: <ZOZ2KqCIcleJxrTz@google.com>
Mime-Version: 1.0
References: <20230810234919.145474-1-seanjc@google.com> <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com>
 <ZOTQ6izCUfrBh2oj@google.com> <d183c3f2-d94d-5f22-184d-eab80f9d0fe8@amd.com>
 <ZOZmFe7MT7zwrf/c@google.com> <bc6a9c1f-d41e-ef81-3029-04c2938b300c@amd.com> <ZOZ2KqCIcleJxrTz@google.com>
Message-ID: <ZOeAb0ccVjdw3Gvw@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023, Sean Christopherson wrote:
> One idea to make the original bug repro on every run would be to constantly
> toggle nx_huge_pages between "off" and "force" while the guest is booting.  Toggling
> nx_huge_pages should force KVM to rebuild the SPTEs and all but guarantee trying
> to deliver the #BP will hit a #NPF.

Mwhahaha.  That, plus a delay in the guest and disabling THP, makes this 100%
reproducible.  I'll verify the fix actually works before posting v2.
