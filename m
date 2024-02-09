Return-Path: <kvm+bounces-8379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC0284EE56
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AD2E282703
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 00:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC637FA;
	Fri,  9 Feb 2024 00:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QqU+Cbx3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5646364
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 00:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438185; cv=none; b=elb/hsjPWawQEwvQRkm2a8pWvrfU5+p6/uIb2C1ddiOatJiTnDFnqj40x/iiUsd8pyRwTaNdTZnYgqcrx/R7eTQjiPgomGjmPL4vvJNmbUvEsE8JqYINeVeObdIkTDBcF0JhTnocKbjTIeggREiu6TnEeWsIVX+aIOUypiVty1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438185; c=relaxed/simple;
	bh=IvsuJ7EMrN39WihS2Hj4OfJrXOBjvzJXlONmXuyLZso=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=izawK2jwsKzMVMA4i5/8kzxZxn7SzWpbf5e//vxr6s8Yb3yelaRFZS3VGlwRy/aqyQTSKJ2ShRqTurw3lz06h77y5t4KFNdVj8jN950jdUiaxo/8pwCiK8rrJzQsotXRi+1aDfFwS+tSaLJb/wMK4F2KsTD4c8hGJEtG4Qu5AzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QqU+Cbx3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ffee6fcdc1so9287357b3.2
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 16:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707438183; x=1708042983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vsNvehKq1ZDZ9aome1IoXssJL6mlGAzVo4fhtG5Pd54=;
        b=QqU+Cbx35jwdtDI93yaEVvqWN0tb5ca/mV7m93aO7Zjpc50YSVlyCeS8N1kl9Hblko
         dhskIKI7sUnmyWlGj9LHDYL0tAihusg/DG35tUXHbadio1SDx5v1Os/dy79P5fqofUeT
         tAu9qkKtiVReBiX3RuXXZKj3wsiLzT60wl7wB3LrxZqIKGEl9GO9qZ8tAThmf7KRRroF
         Mdh2h0i+mQ2ihGu4qwkFNEekYTT7FAktOksvIK2JCAr7eVNgAgM+YzLxkpnZiz+oQXVT
         JQctNqcxru1X3ZSTSx4QgWaxCHfFIzq1JEykMiGC/PeOAJgLg8gmYLEtaQe9pBR4oV5k
         SUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707438183; x=1708042983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vsNvehKq1ZDZ9aome1IoXssJL6mlGAzVo4fhtG5Pd54=;
        b=Bs2Huc0mZCln+H8UpG4sArX4yYmQ9mwkWjbh08+P4Snhf9rGNDWjUfOdyoq7NbcnLi
         bh3b+cGIPcm4Der8RyqcO/eybD6CaUQ2nTKqFRWcZAD1BfhEf6AcnJEj19rpwctmNHmq
         dGRyYqPBaLZeNrHSQiEnmcE+3dcDaeX6jI4E9jknEUAFvQeGlzd319FzX6AUYRuubZfe
         jnUgEEVWOMdBrKQZ01p6utnMhDsXWIm42aCv7Iu1+sNhNDl0i3GCTvfrTlOy6675brxJ
         aKmXVKQv943bTzYNGJDWKWCfFaG5FYSQ4u8I+DSVVAXVRjpDl5cBW+o0Pf3PEzU4h7pi
         WriA==
X-Gm-Message-State: AOJu0YwmZLwubFyAtWmAkMYMrUPFoxfltNMIcen80P0EIgJkC57A2bLR
	mmOix2Pxg/EvABsqrCvDwj8a4WZa2F8lTlDuWwnmLLdfukVV8G3ye9ezGWSb2BfcBqPhTN/kXsl
	UpA==
X-Google-Smtp-Source: AGHT+IELqJFN3i9C6MWS2vVCUe8U10QpxrsBQOijBr/Wz7r0TZm0Xn+/dKzNymNbMRzW0V714s4UREB4jU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:48c5:0:b0:5ff:82c7:1528 with SMTP id
 v188-20020a8148c5000000b005ff82c71528mr171ywa.5.1707438182818; Thu, 08 Feb
 2024 16:23:02 -0800 (PST)
Date: Thu,  8 Feb 2024 16:22:43 -0800
In-Reply-To: <20231212095938.26731-1-julian.stecklina@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212095938.26731-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <170743804033.201213.17136091550631405731.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/emulator: emulate movbe with operand-size prefix
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 12 Dec 2023 10:59:37 +0100, Julian Stecklina wrote:
> The MOVBE instruction can come with an operand-size prefix (66h). In
> this, case the x86 emulation code returns EMULATION_FAILED.
> 
> It turns out that em_movbe can already handle this case and all that
> is missing is an entry in respective opcode tables to populate
> gprefix->pfx_66.
> 
> [...]

Applied to kvm-x86 misc, thanks!  I have a KUT testcase for this now, I'll post
it at some point.

[1/1] KVM: x86/emulator: emulate movbe with operand-size prefix
      https://github.com/kvm-x86/linux/commit/03f6298c7cf6

--
https://github.com/kvm-x86/linux/tree/next

