Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B883E6D6C91
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbjDDSqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDDSqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:46:46 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1773C1FE8
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:46:44 -0700 (PDT)
Date:   Tue, 4 Apr 2023 18:46:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680634002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6CCFZGbCbuQhOOVHvrtx2gWbSjOe3K33umxalnr28II=;
        b=iF+v2Q68XT8lGFaQ4gn2l9SacXhFLr07nAJDyI5xvBIPSL79kEpsGE78SUdsCLk2SYEpOH
        gNbkgNenyyOrqioed/7OY2lIcm+le6m6u0QuxKJDhvHEj9Xw6GN6Ra+PNeP5zXqchAsBTF
        60qSwNES7H8nO1iMtQr+iEogRX+FYxU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/7] KVM: arm64: Implement
 __kvm_tlb_flush_range_vmid_ipa()
Message-ID: <ZCxwjYf+EjuB64iH@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-4-rananta@google.com>
 <ZCTe5koj8fOgbrYO@linux.dev>
 <CAJHc60x-ZHN=ZQemZp0wkj5jp-Ys8024YDQmWhmKn3NgZ0HHCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60x-ZHN=ZQemZp0wkj5jp-Ys8024YDQmWhmKn3NgZ0HHCQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 02:08:29PM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Mar 29, 2023 at 5:59 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Mon, Feb 06, 2023 at 05:23:36PM +0000, Raghavendra Rao Ananta wrote:
> > > Define  __kvm_tlb_flush_range_vmid_ipa() (for VHE and nVHE)
> >
> > bikeshed: Personally, I find that range implies it takes an address as an
> > argument already. Maybe just call it __kvm_tlb_flush_vmid_range()
> >
> Hmm, since TLBI instructions takes-in a variety of ranges, VA or IPA,
> I just thought of extending the '_ipa' to make things clear. Moreover
> it aligns with the existing __kvm_tlb_flush_vmid_ipa(). WDYT?

Like I said, just a bikeshed and it seemed trivial to eliminate a token
in the function name. FWIW, you're dealing in terms of the IPA space by
definition, as a VMID identifies an IPA address space. Range-based
invalidations by VA would instead take an ASID as the address space
identifier.

-- 
Thanks,
Oliver
