Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6338595F16
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbiHPPcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiHPPcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:32:45 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDD13FA3A;
        Tue, 16 Aug 2022 08:32:42 -0700 (PDT)
Date:   Tue, 16 Aug 2022 17:32:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660663960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n4zdtnTMg/Nj0u62JjmBzedy558TEd0PMQVz2MXl/JA=;
        b=jX69LCaEZn5f8TYNbLo+3A+OqmQSfDaJ+6VXs6m01AdYhuBWmsz93qw3mCB4G9nhAHZsGb
        YxuOplEghsk1IsGe1Q4jvuUP3zon3FxfSWafscdgwO2qhzus0uk7p4dixihA9uzpLBUA8p
        ZA4Piyw07DUZfGw2dNkXr75ahf5DB68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com, vannapurve@google.com
Subject: Re: [V3 07/11] KVM: selftests: Consolidate boilerplate code in
 get_ucall()
Message-ID: <20220816153239.gvehm3wj2wat6pke@kamzik>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-8-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810152033.946942-8-pgonda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 08:20:29AM -0700, Peter Gonda wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Consolidate the actual copying of a ucall struct from guest=>host into
> the common get_ucall().  Return a host virtual address instead of a guest
> virtual address even though the addr_gva2hva() part could be moved to
> get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
> should return a host virtual address (and returning NULL for "nothing to
> see here" is far superior to returning 0).
> 
> Use pointer shenanigans instead of an unnecessary bounce buffer when the
> caller of get_ucall() provides a valid pointer.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/ucall_common.h      |  8 ++------
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 14 +++-----------
>  tools/testing/selftests/kvm/lib/riscv/ucall.c | 19 +++----------------
>  tools/testing/selftests/kvm/lib/s390x/ucall.c | 16 +++-------------
>  .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  | 16 +++-------------
>  6 files changed, 33 insertions(+), 59 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
