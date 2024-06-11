Return-Path: <kvm+bounces-19361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4D69046AB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B05201C23643
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22D0154C00;
	Tue, 11 Jun 2024 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pzfp13xJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BB215253B
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143396; cv=none; b=q3NzGu52OYDUITHgv1z10BJbPACztM/RLh5J/P8mfsnE4+yVMlFUuFdC+sISIyZRiy3IbLKHRli90le9wVNstenslVRURg2col7EpgFOEsYVfxJV2IlcDpVTvrp11NbRuhgMSvHQrPs3o117OGIltmlI5Qr9f0s2fd9a/n6JRuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143396; c=relaxed/simple;
	bh=Ey4dpn+f1UTvaOx0gUOY+eQ9wwdUJpZk5SoYV20o088=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ANWOZm6E8pQOuIzgaqoKqz8kZ9hUebvluepIWyT7yV4FP8BvPYYOWKMm7p2GmGatwNTf3xCTsAI6zsR4PorTkNlmitU1xV60E5oYa3U8TMhSOrygsxztnHWsXsd4fZldOXLI9iz5H2s8gIbz3ndA4BsFWpJBSISDHKgMhJapW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pzfp13xJ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62f46f56353so8373847b3.3
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718143393; x=1718748193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KeC1/70he5CQ79E8jYxK5W/LoMc72KfRPBd07uT+cuY=;
        b=pzfp13xJgS4PrMgr8eebFpdqon9XpjtuiiSunvsOv79NWb1mBwZL/k+sTbiz2FB6NB
         /X1X3LWw1TPj6w5qDUh8WVXnNvR265QOTBi18YzRyOplSSV0C/CVWB3SDsGm2u59XBeL
         CK/JgZVeh0faOENI/V7ZI/wdUQXf7YrJVciyplIgAnOisIgTsGYu1JUlalCTZZYAI4KY
         c/I+h4hb6zXubWue6dYhishxiqsCIr1PSTxdW6/cF16uBq8P5qZ+VAmHZ7bAzUClX4sN
         SvjLPvvxWPA5kPiFUvS1K33h2hBsePMcEqsdABwkE8HNsX3G5RPn9c4ThHVXPPw/M3i9
         rOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718143393; x=1718748193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KeC1/70he5CQ79E8jYxK5W/LoMc72KfRPBd07uT+cuY=;
        b=Z40OxTnHX3dbkxgR4wdzj++I/8yNb28iKJ863NmWgqq/EU/YEGpxmtBWNg35xdTXoE
         m3r1EZTH8AP5S4+FT3xNilhr+sBKZwRUftn45W1QvFth1bme/pGwCj+Adp4zaJHZPKuB
         wtIHX/g6OsnEmbhPO9vhq5dLtZiHl+4R+FcsKp22qRHoBpaGsJU9h8hObowsIV0wzxoy
         Tiy9xZLOwnXv2KqyvFe07lwgdl3BF1D+v7H364uDJzDxdiRLg+jjoKdVNWQRLTzeOh7K
         3QUgNOru9IpYLtQSj2wx1ngA9E6F5DJ2zViBeC+fDdyEyvPJ4wu3W6l+zQO/o1qYkSQq
         NkCA==
X-Forwarded-Encrypted: i=1; AJvYcCVctmjH8r4qR07yU6xy/MXHkn8qj9LcaNfZ7+4ionI5yUMBRzUGhb2iN2hxsF8M59nyX8+d9g9UeW6oFDkLNZTDlMr/
X-Gm-Message-State: AOJu0Yw9rxPQF1k2se0AYajm/4u48HIUyqRW4Cvap+NnOtegc4bYcwyC
	VeBkDTfrYGpXF3muVjyGsMcknl+rNRPvDGtm02FHpZfOrJDNeYu4Rj/srpBjLXEzY33EBWV1JLi
	DdQ==
X-Google-Smtp-Source: AGHT+IEgj86esgclw1q8kzIIbHibvWuASiwr8am2UV+qPS22vwZD9KxmZ6peui4uE5upeZ1rOL+uSOW+Dn4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c17:b0:627:a961:caee with SMTP id
 00721157ae682-62fba27ded9mr55487b3.4.1718143393450; Tue, 11 Jun 2024 15:03:13
 -0700 (PDT)
Date: Tue, 11 Jun 2024 15:03:11 -0700
In-Reply-To: <a44d4534-3ba1-4bee-b06d-bb2a77fe3856@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718043121.git.reinette.chatre@intel.com>
 <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
 <ZmeYp8Sornz36ZkO@google.com> <a44d4534-3ba1-4bee-b06d-bb2a77fe3856@intel.com>
Message-ID: <ZmjJnzBkOe58fFL6@google.com>
Subject: Re: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 11, 2024, Reinette Chatre wrote:
> > Heh, the docs are stale.  KVM hasn't returned an error since commit cc578287e322
> > ("KVM: Infrastructure for software and hardware based TSC rate scaling"), which
> > again predates selftests by many years (6+ in this case).  To make our lives
> > much simpler, I think we should assert that KVM_GET_TSC_KHZ succeeds, and maybe
> > throw in a GUEST_ASSERT(thz_khz) in udelay()?
> 
> I added the GUEST_ASSERT() but I find that it comes with a caveat (more below).
> 
> I plan an assert as below that would end up testing the same as what a
> GUEST_ASSERT(tsc_khz) would accomplish:
> 
> 	r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
> 	TEST_ASSERT(r > 0, "KVM_GET_TSC_KHZ did not provide a valid TSC freq.");
> 	tsc_khz = r;
> 
> 
> Caveat is: the additional GUEST_ASSERT() requires all tests that use udelay() in
> the guest to now subtly be required to implement a ucall (UCALL_ABORT) handler.
> I did a crude grep check to see and of the 69 x86_64 tests there are 47 that do
> indeed have a UCALL_ABORT handler. If any of the other use udelay() then the
> GUEST_ASSERT() will of course still trigger, but will be quite cryptic. For
> example, "Unhandled exception '0xe' at guest RIP '0x0'" vs. "tsc_khz".

Yeah, we really need to add a bit more infrastructure, there is way, way, waaaay
too much boilerplate needed just to run a guest and handle the basic ucalls.
Reporting guest asserts should Just Work for 99.9% of tests.

Anyways, is it any less cryptic if ucall_assert() forces a failure?  I forget if
the problem with an unhandled GUEST_ASSERT() is that the test re-enters the guest,
or if it's something else.

I don't think we need a perfect solution _now_, as tsc_khz really should never
be 0, just something to not make life completely miserable for future developers.

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 42151e571953..1116bce5cdbf 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -98,6 +98,8 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
 
        ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
 
+       ucall_arch_do_ucall(GUEST_UCALL_FAILED);
+
        ucall_free(uc);
 }


