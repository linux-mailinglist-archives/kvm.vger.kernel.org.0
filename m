Return-Path: <kvm+bounces-55060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 608CCB2CFC7
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71D631C4634D
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD0A274B32;
	Tue, 19 Aug 2025 23:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0jiiniF5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622AC274653
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645357; cv=none; b=JSyXF2s5L/s13F/zVPBIf6C0AinBAuOcVPUhXtXHbY+BF+5Ew/fS5Z0iMe+Za5IvAPaHb/eg72n5IFu5HDteDJE1PWLyIwpX5/kSpAosSLOlEmm+Se6y80ap3EZvEH1+82alPcX+UCGJbRexe61NucG+Aee0APnRClTk+eXg4do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645357; c=relaxed/simple;
	bh=NO69rq7d5HUh7N31HaJu2N7TJPqjMuDJlwxFXJM/PEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=muBOeTBCy6NOZ3x+DrLK255zvEvX1uVWR7AmdQutmEr28xX/UMOAPoNiOz12LjA0D506xhNZKBOaMY8YIqgVkYC0HipIs98VsjMfpra5r2UjHuHp9MxwJjt88fJ0ZAUkeHv0+YjTH6eqrbySmb4PSdkY0ESt53MoA7GvfYZLPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0jiiniF5; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47538030bfso1354539a12.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645355; x=1756250155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0DUi8ibOczq1f4cubQAD/UGcZ0gSQdUjEwCmiQNclU=;
        b=0jiiniF5PNQN+L/lP5Ij4gxIKdLW1U0Jk5/76Yr3aaKa4rtgr+3Uu9L1ynNV8yJnJv
         PYImhFu8DxueJxyXym9MgRdN5WSd+r5pdDQmT6RQkY6FwHhoidaxU9pntC0oI9DnhjxL
         7ivOFo7QvUANISrNdyxyYz5Dsr5WYkYuZEMVguROyZelVP4Vx2QPG8vGbiTkOiTH/81z
         10Veow0tt60uzpwr+pN+bsBA3YWVQ1CCwMzP9SFhDn65y2lqawttkepwZ9Kw0vw3CcYo
         H55kqftKYcb20Gn8pgz9Rkva+5idxiLO9rOtrKUsEv2Wqw++ExNMUQiSNpKFu4dlsiVq
         ax4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645355; x=1756250155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0DUi8ibOczq1f4cubQAD/UGcZ0gSQdUjEwCmiQNclU=;
        b=vpJ9pSvh0+AFBx77yfI2xq7cZuBMx+o2ymVWcIhOWBRcK3fSDrLi/36USMUT4Wrohr
         1I4nlP90giR3p7GB3I94UsaMpT08W850Lm2PTjhqtRdR+NOfbdAlmundcTXJ5GnnpNHp
         gB7jLis70Ty5sbtmKesR9Pt+UHWMZyjPMHTu2+yWoJ9LyB6CHfCP8aOStjSQWDLgtGAZ
         CuHzJCxA9tWKyjb/X8pWyu7QKEVMlAHniOj+fluGE94IQonr2ucoxV2jU7OIBOm8jtvp
         tpXkhppqIWlc7oHQwqdO6SnTWZcsExyGlfiS55ibDjESF7+5g53e3mk1SxC18+T3wFh5
         C0sg==
X-Forwarded-Encrypted: i=1; AJvYcCW6TNDskV7VVkTYBnKA40q1PnwIErpxPz9wb/mOX6PapdKiF/3sXuGRsJAn7hMrKGMVxBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsmOaT8WtT2LUe1vqXedmuTsWXWI40kG1dnCjCSNqWk95d3RVP
	/vPRdNQxPkDd16BCPCxu6B+pxLza/l8G+VQQ5c/DjXIG8P+FQg6O0iYDF+rEPe5vxBi9NGXhCZA
	WT1Ey4g==
X-Google-Smtp-Source: AGHT+IHcf88wRiO1+bkleq0IuKOV9laDBxE+jirJg6ycDufA1xP3QL4fw1Og2N36QTHGeFtGqJnDCCaMSGU=
X-Received: from plgq10.prod.google.com ([2002:a17:902:eb8a:b0:23f:efa6:2e49])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecc:b0:234:cf24:3be8
 with SMTP id d9443c01a7336-245ef2341bfmr7178255ad.28.1755645355614; Tue, 19
 Aug 2025 16:15:55 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:07 -0700
In-Reply-To: <20250728152843.310260-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250728152843.310260-1-thuth@redhat.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564466081.3065897.4757741827876819544.b4-ty@google.com>
Subject: Re: [PATCH v2] arch/x86/kvm/ioapic: Remove license boilerplate with
 bad FSF address
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Thomas Huth <thuth@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-spdx@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 28 Jul 2025 17:28:43 +0200, Thomas Huth wrote:
> The Free Software Foundation does not reside in "59 Temple Place"
> anymore, so we should not mention that address in the source code here.
> But instead of updating the address to their current location, let's
> rather drop the license boilerplate text here and use a proper SPDX
> license identifier instead. The text talks about the "GNU *Lesser*
> General Public License" and "any later version", so LGPL-2.1+ is the
> right choice here.
> 
> [...]

Applied to kvm-x86 misc.  I followed the conversation as best as I could, holler
if I picked the wrong version in the end.

Thanks!

[1/1] arch/x86/kvm/ioapic: Remove license boilerplate with bad FSF address
      https://github.com/kvm-x86/linux/commit/49be82d4ad2e

--
https://github.com/kvm-x86/linux/tree/next

