Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D917B29E0
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 02:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjI2Am2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 20:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjI2Am0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 20:42:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60100199
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 17:42:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c61aafab45so102500175ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 17:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695948143; x=1696552943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LHnl2CsLxrfQz4bzbwJAj223y7XyxSn5JpaUfYsfSDE=;
        b=rC1/WGQGD7SZLSycCz9NRY4e71edtsK2IX3bbn6OuMS8KtS3xBBxX+YbzEBoQx+WWI
         yR1GtfF2TV8Lam5xWApyMqRy4O2Nec4K0Fyj+wWl5C3UcAaK7UtYRVvQBgInXGaHIon3
         LMcwIF99+jHB/C1fChwXUfLb6EGQ3KC15/SI1hSs1X+T+tUYLVzY4DIk1JHnghsNlSts
         qEL+AMNKgEe0iXvO9BKE3NR/in/dEvc8r1Zeof3kNcgyTLV1Ivi6w+RrCiIGOdZ9uKhu
         4TSH/YkeswaD1yWzlmgZGIghpoW58KEC2rJKv6ye9+OcLcvCVNuEHFjTan+/Y8jNUHHs
         PTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695948143; x=1696552943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHnl2CsLxrfQz4bzbwJAj223y7XyxSn5JpaUfYsfSDE=;
        b=VE8Bp9s/iQMFsAj3AGPilpYmj26osWUllvoYPJZb6y7NPr4a89j/i2aYuIsf8Z07mf
         NrecnvvnMWrBv/FppcGas6iLC57CDBxnWC1gJIxIplHpdac5lCY95cEMvgU309KGDVMP
         A3muPMY3Pi6NlVyZfKl+m29O+Fv3qzMBOrzL57tC/7OR5O0bLLHEvOqUBPg+j5V4ayzS
         JC0xvcfAWxScIQi7rnE43cROi7cjXmkMRPVp+FN6pFFpCYvGZC0O9A/FsoXWbLWkanX2
         fPjkTow1bQh/3Z+G9ig7FbJ/IlBcoZcyxF8XQec3axPeUkFmK/Tf5bWnzCxsSUoVto9y
         i3LQ==
X-Gm-Message-State: AOJu0YycJyCFij4mkbZGMnaLPvXDKqotiQ4MYV2v86fLDKRjtxnzFj9w
        WMjG2AkxcfJX+dN5cjCK+OSDAKlpINc=
X-Google-Smtp-Source: AGHT+IHUEPW3H4eE8hL9x01DrF8EV6/qXIdYZHJV+3Ch6SWg/Ia5upLk5S9Kq+TjsAHT50edQJbCK+giAKY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e851:b0:1c6:2b9d:570b with SMTP id
 t17-20020a170902e85100b001c62b9d570bmr34467plg.7.1695948142799; Thu, 28 Sep
 2023 17:42:22 -0700 (PDT)
Date:   Thu, 28 Sep 2023 17:42:20 -0700
In-Reply-To: <20230928173354.217464-3-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928173354.217464-1-mlevitsk@redhat.com> <20230928173354.217464-3-mlevitsk@redhat.com>
Message-ID: <ZRYdbJNY3ldYKgEk@google.com>
Subject: Re: [PATCH v2 2/4] x86: KVM: SVM: add support for Invalid IPI Vector interception
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> In later revisions of AMD's APM, there is a new 'incomplete IPI' exit code:
> 
> "Invalid IPI Vector - The vector for the specified IPI was set to an
> illegal value (VEC < 16)"
> 
> Note that tests on Zen2 machine show that this VM exit doesn't happen and
> instead AVIC just does nothing.
> 
> Add support for this exit code by doing nothing, instead of filling
> the kernel log with errors.
> 
> Also replace an unthrottled 'pr_err()' if another unknown incomplete
> IPI exit happens with vcpu_unimpl()
> 
> (e.g in case AMD adds yet another 'Invalid IPI' exit reason)
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
