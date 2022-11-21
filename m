Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EC5632928
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 17:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiKUQPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 11:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKUQPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 11:15:01 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33DAD32BA;
        Mon, 21 Nov 2022 08:15:00 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37C0B1EC072D;
        Mon, 21 Nov 2022 17:14:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669047299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xS9RbzkZ1j+3agijHPw89UTLp+Ah5M/Hztpd3/8xgBg=;
        b=pGMq56pITX/Vz6B5Vtn4pOJ0ZnfV6yvarzcjPzxxiR16Tp5+jPUZXF0wRskEm13kHLXbUl
        j2z9D7yHvJ3zfCpqgsdstglB7fNfkD7znw+FJHhxnan2Dgrz1jT9KR5cnbltM19sVp2Ly2
        jIk3LtBD+EFjteLH/pZHClSzDjRb0lg=
Date:   Mon, 21 Nov 2022 17:14:54 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org,
        "Rao, Bharata Bhasker" <bharata@amd.com>
Subject: Re: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y3uj/gb8i4koG6Jv@zn.tnic>
References: <20221117044433.244656-1-nikunj@amd.com>
 <Y3YP5FQ6OHzVFKbp@zn.tnic>
 <7e224da6-6b02-2972-1334-bc8e7894cdab@amd.com>
 <Y3YuxGO8Kycymxg3@zn.tnic>
 <4ea6e1c3-fae5-a64a-9bd3-f9ea0821fc67@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ea6e1c3-fae5-a64a-9bd3-f9ea0821fc67@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 18, 2022 at 06:58:07PM +0530, Nikunj A. Dadhania wrote:
> No: For feature flags that need an enlightened guest, older guests
> should detect and fail booting on any hypervisor that sets this
> feature flag.

What would happen with such old guests nowadays? Wouldn't they explode
anyway?

And how is this supposed to work in practice?

I'm guessing this is supposed to address a case where guest owner goes
to a cloud provider, boots an old guest and it magically survives
booting and then it runs with some false sense of security.

But isn't that part of the whole attestation dance where the guest owner
checks for a minimum set of features it expects to be present?

Because if you do this and the cloud provider updates the hypervisor,
all the guest owner images might stop working all of a sudden because of
this check.

So what is the actual, real-life example where this helps? At all?

> The hypervisor can enable various new features flags(in
> SEV_FEATURES[1:63]) and start the guest. The hypervisor does not know
> beforehand that the guest kernel supports the feature that is being
> enabled.

This is not the right criterion: it should be more like: can a guest
still continue booting with a new feature it doesn't know about and
still provide the same security.

But see above - you need to think very practically here before even
considering such a thing.

> While booting, SNP guests can discover the hypervisor-enabled features
> by looking at SEV_STATUS MSR. At this point, the SNP guest needs to
> decide either to continue boot or terminate depending on the feature
> support in the guest kernel. Otherwise, if we let the guest continue
> booting with an unsupported feature, the guest can fail in non-obvious
> manner.

How can an old guest decide when it doesn't even have the intelligence
to do so?

What you're doing is, have old guests immediately stop booting when they
encounter a new feature - even if that new feature doesn't impair their
security.

> +-------------------+----------+-------------+----------+
> | HypervisorEnabled | Required | Available   |   Boot   |
> +-------------------+----------+-------------+----------+
> | Y                 |  Y       |  N          | N (Fail) |

This means that you need to know those features which would fail an old
guest *upfront*. Like right now. And I hardly doubt that.

> PREVENT_HOST_IBS will be defined but shouldn't be part of the 
> "Required" mask.

So it doesn't need to be mentioned at all.

> SECURE_TSC should be part of "Required" mask and once secure tsc 
> support is up-streamed it should be added to "Available" mask.

So when a guest owner gets a new guest which supports SECURE_TSC and
tries to boot it on an older HV - which is very much pretty everywhere
the case - cloud providers won't update their HV kernel whenever - that
new guest won't boot at all.

Which is a bad bad idea. I don't think you want that.

What you want, rather, is to say in the SECURE_TSC enablement code

	pr_warn("HV doesn't support secure TSC - your guest won't be 100% secure\n");

or so.

> Guests need to check for features enabled by the hypervisor that is not 
> supported as well, so that we can terminate the guest right there.

That needs to be done in the feature enablement code of each feature but
not wholesale like this.

Anyway, I think you get my point.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
