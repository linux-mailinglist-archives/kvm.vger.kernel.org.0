Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094E5772D77
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjHGSEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 14:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjHGSEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 14:04:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E32FA6
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 11:04:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bc0fc321ceso34133945ad.3
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 11:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691431490; x=1692036290;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OExYOOf8M1CpNU2fJgIYRywdcLhFkzkukKiV9j1xays=;
        b=jQIlcBumk+cFSXohMvN9lg2D+elmWJ3TBAgGENXmq2Zc/QKsZwAn6n/dtcuIav+z53
         qvFmhT6r7avNTnMIBrsQsGuXxYETHaXGCK+d40JiDxP9jodrVn9kec1G4yH1R0jylyGS
         GHU6zqjPiOasRdl1NgO0wbCYw5sBcR3wGrhc3cPieHO6Jryx9X9g3rFc7/PeNoTd6eO6
         zr5i87Ui+U7H3rlFeA94R+YFUDByoYh6BF3IordnnrE4nI5fgI8WqUrpz4UBKKPsyw6N
         dFhrCpn9CXXdVE7e4zQ6jmO3IEj8mHCN0uWMipXLOSC1oRybrRGbTfMk8pUdWAm2BtlY
         CVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691431490; x=1692036290;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OExYOOf8M1CpNU2fJgIYRywdcLhFkzkukKiV9j1xays=;
        b=OAR7mwJghG2AnhUVBLb+gfkuQpW//DcTI0nKTEQpEyh97nWkNOktOHeoBwBx3l/Roj
         6V5T52wVP/Mz3oEXC8apoLOkbsiUS/h2ATGhUSSXUy1pRImm7qymYhhEZdL+2cL/Myy1
         M+GuekCKNdgjXpNztGVmPC62/vgiDOGL02+e2DacKTjtEvQWdbKWXc5AznQbKHUfkBkP
         9/ug98+jbSPLNMBzFKMQd21hXNXzkseCOI5K9ZSxtH2E9F6HnsYGTvdr66UAE+9Q+jfF
         jwEzv6iuDvzykoOtvdczJUpBeEEX89GxSpWe9ZPE9DypDTbj/97DGQrzSbJDXO1Ww1Pz
         CSoA==
X-Gm-Message-State: AOJu0YxXOtvcfLS1JO1AkBYrmn8MdamCkXklVhi1IUHU1eOsfdFG3GT5
        aSniMnL3K74Ee9+K9hGqHzagowIZI2I=
X-Google-Smtp-Source: AGHT+IExiQFiHytMd/Auc5RNpEglghE5+NWd0DaggG8keL2Ib6PWkxMHonl0QgyMzWAdYLlef56zu9uL2mM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db02:b0:1b8:95fc:d18 with SMTP id
 m2-20020a170902db0200b001b895fc0d18mr40862plx.8.1691431490364; Mon, 07 Aug
 2023 11:04:50 -0700 (PDT)
Date:   Mon, 7 Aug 2023 11:04:48 -0700
In-Reply-To: <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
Mime-Version: 1.0
References: <20230807062611.12596-1-ake@igel.co.jp> <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
Message-ID: <ZNEyQM8CYSAcyt9F@google.com>
Subject: Re: [RFC PATCH] KVM: x86: inhibit APICv upon detecting direct APIC
 access from L2
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Ake Koomsin <ake@igel.co.jp>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 07, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=BF=D0=BD, 2023-08-07 =D1=83 15:26 +0900, Ake Koomsin =D0=BF=D0=
=B8=D1=88=D0=B5:
> > Current KVM does not expect L1 hypervisor to allow L2 guest to access
> > APIC page directly when APICv is enabled. When this happens, KVM
> > emulates the access itself resulting in interrupt lost.

Kinda stating the obvious, but as Maxim alluded to, emulating an APIC acces=
s while
APICv is active should not result in lost interrupts.  I.e. suppressing API=
Cv is
likely masking a bug that isn't unique to this specific scenario.

> Is there a good reason why KVM doesn't expose APIC memslot to a nested gu=
est?

AFAIK, simply because no one has ever requested that KVM support such a use=
 case.

> While nested guest runs, the L1's APICv is "inhibited" effectively anyway=
, so
> writes to this memslot should update APIC registers and be picked up by A=
PICv
> hardware when L1 resumes execution.
>=20
> Since APICv alows itself to be inhibited due to other reasons, it means t=
hat
> just like AVIC, it should be able to pick up arbitrary changes to APIC
> registers which happened while it was inhibited, just like AVIC does.
>=20
> I'll take a look at the code to see if APICv does this (I know AVIC's cod=
e
> much better that APICv's)
>=20
> Is there a reproducer for this bug?

+1, this needs a reproducer, or at the very least a very detailed explanati=
on
and analysis.
