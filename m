Return-Path: <kvm+bounces-34941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA90A080C0
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13BE21650A8
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11F11F9428;
	Thu,  9 Jan 2025 19:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jmwdko+A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FC31991A1
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452080; cv=none; b=B+QIfVIWWOjYaww1kgvRAMLPIDovDvswLyWTK9yMbJnSsQTQST8zMlEVBXJrVCos39XUF0Yg0BLm9R1TGiPCFBAaFlpOmx3Rh5xhkjCUO//lVwPzmT5qHWojzWZ3dSYIp+/uKBZyHw/pXUB5mrdL5mkBQ9ICp4ax7ZUQJOSTDRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452080; c=relaxed/simple;
	bh=4G5KOGfyI1W0W+ESTWGPRTsIZpX++5YDvRwegRcrWZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCj2b76AJMkPJHUu1z7P0/57dAQzcP/CMytB7Qf6RZlOTInCVaSQbn7Ur1jBkt3o3ApKuQ5hfm0XdRgzD2tiKisd+jG+iieblWUyYDK7XibvuSZOhs5PfYIEACAtgSYGMNF7LdsTizOcK+tyICdWAMWJk5nRwzCL5jxoSWAD7jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jmwdko+A; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so2322949a91.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452078; x=1737056878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtZDgWcR5BTPffyrCA5vpGVMGGdsrnvXv0W7Drd/iAg=;
        b=jmwdko+ABgzsukTZyZUUfcoDp7aruy6rtSIbgFdrpK4oGkNRxObViiKdZLJjk7RU1U
         UA77OPgwYsEcy8c55bAW9Ndy5n1IaaY1ShAIRAdlFzdXbwPbsoQAY9l4NAoxctMJBHy3
         gJ79XPgLErjAGbCZzDY6KTh6xLAA4TjRAoSiBCtLbRL4LajG0qYCUx9xzmGKqBgUamxq
         nzb3CwLnYiErXhrh4PYygEGAdjM7mllnplM+eeATjmV4z7ngdV6Cu3NEhJHch9AG7/aT
         /uYzp6sdhWOlC5O6Jf8kLTF7Q7uqbyaPCnL9ClZBEIDIi0OzEkub7BwbdynCvWyJ+0f5
         R6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452078; x=1737056878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gtZDgWcR5BTPffyrCA5vpGVMGGdsrnvXv0W7Drd/iAg=;
        b=ID0B7H2Y5VyHDpHaVi5DFe6oEsWlyt3tsL0CEY3tYF2/qe6ZmwabxJAtRE7eFpPebp
         lEt86u5dGLDlOkd4hFo/87btGBfwcwkNNW6eOF/wVhDarsAXDNzQvStOtK5TZt6KykC9
         mya3BO1r3ckNVYDBc6GwLUunp0OR+Y0CraZoduc9gP7xehhusLzcMl9HxPkEs8eGZ/8i
         xv5WTZlmuGnMHz848IjDfMZA8z/RfFdKMMr6qiav/k3ireI5IiMjCReBSDo3aMOKHEI7
         SzRDrHyzDqP7ntTWkfsw1x9sxM4P29nLAaVvYvo5adJ99K4V4De/nwDOu7e9bWj1vARd
         r70g==
X-Forwarded-Encrypted: i=1; AJvYcCWCo32m7ls7ySEMZsMsFQ27jgHw+hBC7oWNFW8CvEotqkFDPXSm/Yy5bn+5OB+skbmACNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNWEWE+nEsy9cfzGwQ7k0OLrBBmOJimSg/iRVCH68CYKLyGiYH
	M7apTHtnNtIZblq5XkabNYVfhFLigDl+9zg6zBtAILCt8pc1whjd+3p2muHDAVmJhKCqd8i4m5M
	Cmw==
X-Google-Smtp-Source: AGHT+IHAdB8TmFSBg1BojPtAS8zkyJspipKBZHemqIP+a1ITsYpE3gEPS1+ctCKQv+9HebxZGXTXqOzAEn4=
X-Received: from pjbqi4.prod.google.com ([2002:a17:90b:2744:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a0e:b0:2ee:45fe:63b5
 with SMTP id 98e67ed59e1d1-2f548e98716mr11254063a91.3.1736452078080; Thu, 09
 Jan 2025 11:47:58 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:05 -0800
In-Reply-To: <CACZJ9cUY9ovqkazdcNCtJf=JPbwOO7+sqL2Xp6rBi_Jn1kx1bQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CACZJ9cUY9ovqkazdcNCtJf=JPbwOO7+sqL2Xp6rBi_Jn1kx1bQ@mail.gmail.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645146811.887246.17460857836499712646.b4-ty@google.com>
Subject: Re: Subject: [PATCH] x86: kvmclock: Clean up the usage of the
 apic_lvt_mask array.
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Liam Ni <zhiguangni01@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"

The shortlog scope is wrong, this has nothing to do with kvmclock.  It should be:

KVM: x86:

On Mon, 30 Dec 2024 15:44:01 +0800, Liam Ni wrote:
> Clean up the usage of the apic_lvt_mask array.
> Use LVT_TIMER instead of the number 0.

Your mail client is broken.  The subject repeats "Subject: ", and the patch is
whitespace damaged.  I manually recreated the patch because it's a no-brainer and
trivial, but in most cases I won't put in the effort for patches that don't apply.
Please fix your setup.

With that said, applied to kvm-x86 misc.  Thanks!

[1/1] KVM: x86: Use LVT_TIMER instead of an open coded literal
      https://github.com/kvm-x86/linux/commit/d6470627f584

--
https://github.com/kvm-x86/linux/tree/next

