Return-Path: <kvm+bounces-13458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA66B896F3E
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A2F1C255C5
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 12:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33920146D65;
	Wed,  3 Apr 2024 12:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3OEi/Wl0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52101EEF9
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 12:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712148506; cv=none; b=ij0R+py8HU7MzPanjz40hMUBcfCWl2iO3Y6JL88cwblXrKzbrYjVu8fASMrKQ+3dAaXcD6NwBNqxJ3pUyuJfG26Y8EH1UqM4oGtKBbqPqxbOzAhQaYKZsMfWotnhe4gAwAXwP4xy5DN7cbRQ7V1YLy/IaR0a1trGUvODBvFk7wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712148506; c=relaxed/simple;
	bh=4fa99bxCzTQ+aNnZyVhhNdM2BDVJ2tsP+qybvHGqaKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GxdIYyGnteCNKCKmF0gAbKCE4yJhVOBlVWcWg/gU+cwf0Vgp7XXi8GXmH6Q2bjz6zAgSfTH+3eJBabiowIRupf0WtE+fVMi2HnUl6GW0ddeDVEmltFSc9OtndtYrJt2EPaifWHJjKEagT6R3Sp/cZtHzexqdpV6ArOhPAQ4sG1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3OEi/Wl0; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so10052991276.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 05:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712148504; x=1712753304; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+WTH0q5GpZ21Z4ilfFX2mq/pwBVpJa04vjJTZDZifhs=;
        b=3OEi/Wl0Ii6hwwI588T32CXWbyWiDiED+UtV+jHJNsq0jtrYcq1IfYusxJaiO6x6He
         sei4tMOIQ0psJ3aN+OanjaMcs3GqqHvBVkuN/I+ld9XiqLQxw+huWdQwehIhNHcHqfXr
         7/yq5TPsQOaOtUMU4cGTxLsuG0A/ZtV7fYve9emuRnYR7Rqs7OSqKAeYOSog4LR+UdeO
         Ukw3iQ1GE+hQHcigK3lUc7+HFsWxb8Pbxl5wwnJ547ax+EAP/+pUkBHOoe5nD2j0tkCa
         ZG4WEsBu8E+lVz2n7WIOQj1Mnkj/fNW2bFk4BCFwxG7nqj4L6UpITPpxHIwvpOfTDYzl
         XNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712148504; x=1712753304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+WTH0q5GpZ21Z4ilfFX2mq/pwBVpJa04vjJTZDZifhs=;
        b=o0zxjFK6kLQ5Kt6Gii8Xfnza2nJERQSouw9oiN6JHe8vVI5GkRTQrBiRGTw8bF4aRG
         cGIMOHYuC0/cZUrCJUAYYSOEQm9Ie+AKHnVt1LXWH20sdz/vm/DiF1Hg66SVi8U4v9mS
         DHiy85rbaczBpZsRH1oa+b3XthoOBh/b70Hg8cU4z/haHAdohYohvTt7w5IOvo/xXCVQ
         Zgmzgm7hO1jn5Mij+Jn9btvKGcSEt9KKDchIhsUqoNgW5bRNdTbeFYxTv1FXozs+t98f
         /2+HvHaTC7o6eiFmyUrwEwblNEiCHp01hb7mz08102NP6gB5/7pxEgCJReioXkGQckZ5
         Vm+g==
X-Forwarded-Encrypted: i=1; AJvYcCVwMK/YojjMqOp1Hnd4wivIMrfaRka+Rc6coNGYYuIZv7/1Yg2OpIJg3I0ryYhkaEUR/utly0q81sHjZsa1iuCAdPTT
X-Gm-Message-State: AOJu0Yz9FXD70X/ju0TzOvykEAEQ+lmjeq0alJ6Uguqd7GvxQCFSClPC
	ufJz82OAjPOP9r93RorNVYmzsVWeYGoSPT6F9z3DTIYGuOnd7UXHPNCa5UPpmi0dv7cMJccLjKo
	4hQ==
X-Google-Smtp-Source: AGHT+IHzFSNyW912YO220dObmsVmcH6kZMbX/Cwr83xihFVbO6C+uvXA4mxpDrUftZoKCYJjCYYgrpO5rM0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1586:b0:dcb:b9d7:2760 with SMTP id
 k6-20020a056902158600b00dcbb9d72760mr4816449ybu.13.1712148504099; Wed, 03 Apr
 2024 05:48:24 -0700 (PDT)
Date: Wed, 3 Apr 2024 05:48:22 -0700
In-Reply-To: <20240403121436.GDZg1ILCn0a4Ddif3g@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
 <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local> <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>
 <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local> <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr>
 <20240328123830.dma3nnmmlb7r52ic@amd.com> <20240402101549.5166-1-bp@kernel.org>
 <20240402133856.dtzinbbudsu7rg7d@amd.com> <20240403121436.GDZg1ILCn0a4Ddif3g@fat_crate.local>
Message-ID: <Zg1QFlDdRrLRZchi@google.com>
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched return
 thunk in use. This should not happen!" [STACKTRACE]
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, Josh Poimboeuf <jpoimboe@kernel.org>, bp@kernel.org, 
	bgardon@google.com, dave.hansen@linux.intel.com, dmatlack@google.com, 
	hpa@zytor.com, kvm@vger.kernel.org, leitao@debian.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, mingo@redhat.com, 
	mirsad.todorovac@alu.unizg.hr, pawan.kumar.gupta@linux.intel.com, 
	pbonzini@redhat.com, peterz@infradead.org, shahuang@redhat.com, 
	tabba@google.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 03, 2024, Borislav Petkov wrote:
> On Tue, Apr 02, 2024 at 08:38:56AM -0500, Michael Roth wrote:
> > On Tue, Apr 02, 2024 at 12:15:49PM +0200, bp@kernel.org wrote:
> > I can also trigger using one of the more basic KVM selftests:
> > 
> >   make INSTALL_HDR_PATH="$headers_dir" headers_install
> >   make -C tools/testing/selftests TARGETS="kvm" EXTRA_CFLAGS="-DDEBUG -I$headers_dir"
> >   sudo tools/testing/selftests/kvm/userspace_io_test
> 
> Ok, thanks, that helped.
> 
> Problem is:
> 
> 7f4b5cde2409 ("kvm: Disable objtool frame pointer checking for vmenter.S")
> 
> it is disabling checking of the arch/x86/kvm/svm/vmenter.S by objtool
> when CONFIG_FRAME_POINTER=y but that also leads to objtool *not*
> generating .return_sites and the return thunk remains unpatched.
> 
> I think we need to say: ignore frame pointer checking but still generate
> .return_sites.

I'm guessing a general solution for OBJECT_FILES_NON_STANDARD is needed, but I
have a series to drop it for vmenter.S.

https://lore.kernel.org/all/20240223204233.3337324-9-seanjc@google.com

