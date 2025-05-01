Return-Path: <kvm+bounces-45104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 350A3AA606A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F05CB7A47F9
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4281202F7B;
	Thu,  1 May 2025 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yYexDwAq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E73F1BE871
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746111817; cv=none; b=ji9SCzUuhpwuM92lANRjlL2pKnVjuRIBubgZ9nZBcqBK9Rk12nNOEYvz0qgzJ3UczuWCDb5gYePF3XctGqTaq4yopRo60/JnUxqz3UdSWwTLfSFw851VnxWkCw2ChVHHkxouUlT5gXBg81tbCO6g+y8GMLiDbOAyY4z2nlAYNUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746111817; c=relaxed/simple;
	bh=5I05M87lMsen1AVruQRQa7haeFtJa3I9f6fonpf0LFM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XMcXKpdTd0ToQSNB20hyRkaGQ8jCIo7EdtEVYFOn/+3pkVdXM8DkqP8yUaA8PyLVxDZTCaqnMvql+ysRFVNQUhINW/6Ajd4hWR5XofW9BRxjB5tZyHxsKOXCV0SE3lfGz8VrUDITwVKE7A1N/T0E+K9nNhQ7m2knubucos2pxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yYexDwAq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so7395945e9.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746111813; x=1746716613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cH0TZFJk2T1RX75J4QRephYBY3SFDgf8QsJqbeDrxmg=;
        b=yYexDwAqVIR7AZzE/cHQHeSNuozGHjrmXX6/MV9A5p6GpuqXVR9QCN91efOsHeF4gv
         G98Ji9hiNsJcK3i5YCBtbmZSdoBIL+sS0cxiQcY5WqNN3JPIHqX3L1MTmgvFQFLO/sdz
         hgEWlHG2jPHwaF0br1gefCAupeXR5HAn6ac592VfGg2DK2gzQXbDp/NoQQeI2DrXHRzX
         hf2u1+ITOjtE8EbDfUSjqjVXx4srSV0yAUQ5AwTRK+JTkdsQUT/OignoVd7utyCJ84D4
         ahsVvLPAKWB2hjJVYJdzbnMDlYQ42Qcu/wKGpf4RC/0TPzTzqtiwiPTAxmypI0ufOool
         iZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746111813; x=1746716613;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cH0TZFJk2T1RX75J4QRephYBY3SFDgf8QsJqbeDrxmg=;
        b=JObf7dJwGrHalIPuko7Bsxrmy/kKcvaD18KBvj6SpfF8dnGRHYoTVY1e4wm8OaIGkY
         b3gZgrzW9fyKaLL5mVITjq21WGv+isZQp7TbUCEfhGlWXES0GStG7G0Nqm72QOzoaiLe
         xSVtrcb/PxLnIcA/azJowo40vo395ABMYIpRSRwq9aOG5m4Bvg6HbaAt0Dyj4VYfAkk4
         XXr9ZWvFFks229427wsEVkeks7FNSlFzAt2uiOya8siCShcMxYYqeJuHsNeR2jhzBfAd
         bqK4EfqNxGW+IqPLiIT0s9bBqH8mOTWto/aQr2gCW9F4YRXZdnnnTCobHcnTG9r1jGZ8
         pEQw==
X-Forwarded-Encrypted: i=1; AJvYcCWLKSDNzk66ApdlEbjMjERCuP0FP9Urmh/Y14FX3zAtmFwntRcQV0SqqT2L6jEOdS948oE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAjD9nvLGcMoxxTVZELTMYU4dGnCY22hV5uUbceLdE94IrqWX8
	BWhUsdFxPMpjyqyW4WoKRhpHGNwed5Q1DOnIocQtjsqilZegLkBA3yddQMQog1F7ntfq7KMj30v
	gIOiHRBoclA==
X-Google-Smtp-Source: AGHT+IEoHar4kKZLCcwzgzPXKYmS3cfrlnjEoUXh4L1DN3kWbEUElUFiikgocxBnbt6mXNBc7VuzqYOZJrp/fw==
X-Received: from wmbhj22.prod.google.com ([2002:a05:600c:5296:b0:43d:5828:13ee])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d28:b0:43c:ec0a:ddfd with SMTP id 5b1f17b1804b1-441b1f2f093mr47352155e9.6.1746111813739;
 Thu, 01 May 2025 08:03:33 -0700 (PDT)
Date: Thu,  1 May 2025 15:03:23 +0000
In-Reply-To: 20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250501150323.2242232-1-derkling@google.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Patrick Bellasi <derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Bellasi <derkling@matbug.net>, Brendan Jackman <jackmanb@google.com>, 
	David Kaplan <David.Kaplan@amd.com>, Michael Larabel <Michael@michaellarabel.com>
Content-Type: text/plain; charset="UTF-8"

> On Wed, Apr 30, 2025 at 04:33:19PM -0700, Sean Christopherson wrote:
> > Eww.  That's quite painful, and completely disallowing enable_virt_on_load is
> > undesirable, e.g. for use cases where the host is (almost) exclusively running
> > VMs.
> 
> I wanted to stay generic... :-)
> 
> > Best idea I have is to throw in the towel on getting fancy, and just maintain a
> > dedicated count in SVM.
> > 
> > Alternatively, we could plumb an arch hook into kvm_create_vm() and kvm_destroy_vm()
> > that's called when KVM adds/deletes a VM from vm_list, and key off vm_list being
> > empty.  But that adds a lot of boilerplate just to avoid a mutex+count.
> 
> FWIW, that was Tom's idea.

FWIW, this could be helpful for ASI as well going forward, i.e. the set of ASI
driven mitigations could be different whether there are VMs on a system or not,
because the attack vectors are different.

So, having a first class and properly defined mechanisms to know if there are
effectively VMs running on a system would be generically convenient.

But maybe that's something we can work on later on?

Best,
Patrick

