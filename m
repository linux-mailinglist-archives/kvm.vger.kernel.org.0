Return-Path: <kvm+bounces-43317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38882A890F9
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 03:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4983C16DF51
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 01:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0D8136358;
	Tue, 15 Apr 2025 01:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ikx/jtPk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C985A927
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 01:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744679027; cv=none; b=otGYbJ2wKPc2MuTr1W0OIFj8XndXZgXWcb4XYORmjaw/qZrHeo1Oyzor8eamVf0VbYCrL3hQUynJ2hry3j/uJBD+bx3FX7ZFhT6AFdUOph7SrPqR3EfWdYS0y46xqA9yBfduRPyUOxxDZWES2aCkUtTy3JOaE6H4CnLpKQEFd7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744679027; c=relaxed/simple;
	bh=pB0n3LdfP43WeFXriy07YW6KzlCi6N/LwuUGRkNfbLo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dkkEE/Qev2zDjuh/E2GnD+oh63Z0gioHnD1LrVdheR2a022FPpntswLHr6lmmxY6KhGKB3ya0KqIuOFCkmXexZgtP9P6+oW45ClvobvoiNGBLAK3N+RhorqKGHlU/plUXXb1GHCKf5VVtFMJ6tveiaSSXHK8ccq+51BxSoA3oUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ikx/jtPk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff4b130bb2so5198539a91.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 18:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744679026; x=1745283826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YzbnsAfv5+9Y/Ffya+lNPAXS6cmkCNbPVuwmvW4EBG0=;
        b=Ikx/jtPkblQ5yuLUsNJ5anPKo4hr6tcxbGkm3Zmlh+WdE+ZySfnlpJvpLIku1DytHr
         RwaCt0fkZrl/1vC8V+aOzEVz5NtzN1H75z9Fvj2IUBAdRbyS/XwjflSusFJBKU8D9tf0
         RGa6Ihrfr4yXFwBNVaYdwjut7tv1Db0lUawEBpwpF9QEnJziYpKx/OsKoJIysoclvls4
         rHe7XWZyYxW5jyzF3Vb9iO4jLSHw+5WuOXicrScb1U5XihqZ3NZ0ZzFovDN6OLqwA+b8
         +Kv8KI6HwrvRy5Dv383WjwEiDB2oYwXt9ScBntVm/gC+qY+V9Ykgghz1Xb3jxV0XCcZ7
         mCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744679026; x=1745283826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzbnsAfv5+9Y/Ffya+lNPAXS6cmkCNbPVuwmvW4EBG0=;
        b=bIYiv0b9Goq/cjG4osF4ho7LSEnuR1RF5Y6bq9rDC6FgQXxaK9xhgUg+CCZIyNxunL
         L5QyDYlNQpESvb8R3gaWQy5pBiGozzXpDBAb1sdabE5yFeXyskQJH7O2uDBfOn7y7AHK
         0i8nF3yjztSfyq8u47ZiMRbDR/18FzSqgEJM6rbMcFcsLX7bdLdsipWkhrld9tVzdNOV
         4UOEeDw/0/h+YFkuSPZ76rw0MXH8hOf2uKrLaLSOvMuba9aOHciBYjbOXXbpdZFQ1R1/
         xEXhYBEPK2m2BDEIS3x6jND+Hg29eBWa829QVWcr6+l5tjU3wOIiSzdJBNEduTWLwaV2
         qFzg==
X-Gm-Message-State: AOJu0YzupSi80mEbQmdihcRV5mIjHs3Hzfg3pswL3i3bSV/unVWPEfMB
	IDyGuRyna5m41n4FBxFQ9SkV5NB91+2pcDEbS+/DBbzUvAatlL5vvatnBtwVoo9bmlEFkaijBEr
	j1w==
X-Google-Smtp-Source: AGHT+IEdiPfi0RY+jZvT5ThALgaqd0aYUVddYIjm3GUKPqxvv7TDcAONTr/QwVKwhaZ9NmtAwwSxAyU9wQg=
X-Received: from pjbqn4.prod.google.com ([2002:a17:90b:3d44:b0:2ff:6e58:8a03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582b:b0:308:5273:4dee
 with SMTP id 98e67ed59e1d1-30852734e83mr689391a91.15.1744679025608; Mon, 14
 Apr 2025 18:03:45 -0700 (PDT)
Date: Mon, 14 Apr 2025 18:03:44 -0700
In-Reply-To: <Z/0LJTnNCsQ3RIrR@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324140849.2099723-1-chao.gao@intel.com> <Z_g-UQoZ8fQhVD_2@google.com>
 <Z/jWytoXdiGdCeXz@intel.com> <Z_lKE-GjP3WQrdkR@google.com> <Z/0LJTnNCsQ3RIrR@intel.com>
Message-ID: <Z_0XCXwptNhtI_A_@google.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 14, 2025, Chao Gao wrote:
> A related topic is why KVM is flushing VMCSs. I haven't found any explicit
> statement in the SDM indicating that the flush is necessary.
> 
> SDM chapter 26.11 mentions:
> 
> If a logical processor leaves VMX operation, any VMCSs active on that logical
> processor may be corrupted (see below). To prevent such corruption of a VMCS
> that may be used either after a return to VMX operation or on another logical
> processor, software should execute VMCLEAR for that VMCS before executing the
> VMXOFF instruction or removing power from the processor (e.g., as part of a
> transition to the S3 and S4 power states).
> 
> To me, the issue appears to be VMCS corruption after leaving VMX operation and
> the flush is necessary only if you intend to use the VMCS after re-entering VMX
> operation.

The problem is that if the CPU flushes a VMCS from the cache at a later time, for
any reason, then the CPU will write back data to main memory.  The issue isn't
reusing the VMCS, it's reusing the underlying memory.

