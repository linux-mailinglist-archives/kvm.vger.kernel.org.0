Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B88582807
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiG0N4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 09:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiG0N4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 09:56:10 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CB7BC27;
        Wed, 27 Jul 2022 06:56:08 -0700 (PDT)
Date:   Wed, 27 Jul 2022 15:56:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658930166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R7BSP6lgLmU+GFwcCkarvv2oJomnIPaQ62Slz1uYejA=;
        b=CS8tOTTw8N//Cwkjyu3Urhp4VM7oxbSFgmPiPyOswnYJ1k7UlGTDdvPQftFPfgEprtdtlT
        qm9XXfe9hVhaCgCThgl6EID6ZzdbZ955wU6oL/ycnNYMWECsdc3NPmzSq1aDwGWTzGZsR0
        3v4XtZflhTMRtDLCWwBIQDDjxDdgy/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC V1 08/10] KVM: selftests: Make ucall work with encrypted
 guests
Message-ID: <20220727135603.ld5torjrn4gatjb4@kamzik>
References: <20220715192956.1873315-1-pgonda@google.com>
 <20220715192956.1873315-10-pgonda@google.com>
 <20220719154330.wnwnu23gagcya3o7@kamzik>
 <CAMkAt6rFO6J5heuwocmvb_wstOOwsf9WooXu9iEUOvK0wEDAhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6rFO6J5heuwocmvb_wstOOwsf9WooXu9iEUOvK0wEDAhw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 07:38:29AM -0600, Peter Gonda wrote:
> On Tue, Jul 19, 2022 at 9:43 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> > I'm not a big fan of mixing the concept of encrypted guests into ucalls. I
> > think we should have two types of ucalls, those have a uc pool in memory
> > shared with the host and those that don't. Encrypted guests pick the pool
> > version.
> 
> Sean suggested this version where encrypted guests and normal guests
> used the same ucall macros/functions. I am fine with adding a second
> interface for encrypted VM ucall, do you think macros like
> ENCRYPTED_GUEST_SYNC, ENCRYPTED_GUEST_ASSERT, and
> get_encrypted_ucall() ?
>

It's fine to add new functionality to ucall in order to keep the
interfaces the same, except for initializing with some sort of indication
that the "uc pool" version is needed. I just don't like all the references
to encrypted guests inside ucall. ucall should implement uc pools without
the current motivation for uc pools creeping into its implementation.

Thanks,
drew
