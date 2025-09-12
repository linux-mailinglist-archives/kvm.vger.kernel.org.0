Return-Path: <kvm+bounces-57441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 030A2B559C0
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95F173B4755
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 22:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B0E27B4F5;
	Fri, 12 Sep 2025 22:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i0b0MUqy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB54B267B89
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 22:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717675; cv=none; b=OZx1NMfXx2Jn8m2Tg/EFiUQfGAvt8onWs8I1x6raCBK/MJTDXLSzupJDMW0LQbchL9KIjCgSMMBeKZA7Sed1rfWakjYbypBxGs0PpHv5vxHT267nV1SPFP2brQQ8b8beYV96cL3s93PUXf5b6POFIxZUlc9myWGlqfl/a+JowVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717675; c=relaxed/simple;
	bh=5pRl92lFFcJVoQ5T6b46d1Pycmga4qyIv/qDSkFICYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WkAuFpv7w/7budKZYrFI4UTm/xyeH183Vs78isjLZ1o4O3gaqpeJ+sLKIIPIdkIo7kbv/W8eRFSvDHg70kO/C4Olc38kcSYRBy9e9Yyolb6K2TzwWF1B1IsO/Ivnev1SzOg1TipoBVYqbrii/rV3c0MRwX3G9wV9iKh/f4reQOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i0b0MUqy; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4e796ad413so3031924a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 15:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757717673; x=1758322473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODZNIHI7uoRaNxkDo0YGY9uj33hSnvyle/cQ5/e3oCw=;
        b=i0b0MUqyPMieyxDuCMoIVQjeQU6G20oI7W+vVRfurr9mQphdQ3FSGidQSlxmxhZxnd
         2zicuETC5a3D0k7UrTvOk3QG6kKvlr9OZBjvJinYlZOyXRDF3FjY127aMkOg8nHBVVcr
         7MmkG7SBsXvNaj43Nlm7MZWi09lIGM2NgEHxjD9v58ZCyj1xoNiDC/SSCz+I5LSaHAR9
         /q6jt0K+1910P0o/b0Us6wbj7dzycei6yQV6N41+ndgUYZN4BWDmq3ox+KB1tj2/JdUn
         N555FbhBYjYw95ArLG8UoKV9/upeB9hPgDJrbaKhdom9iHLs6ytJCr23F/1IK1zQW2x6
         DPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757717673; x=1758322473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODZNIHI7uoRaNxkDo0YGY9uj33hSnvyle/cQ5/e3oCw=;
        b=e7gaamIQ+5/01afo/Sy7OlQFWvgem/oiVd7PYcW0S8r9UyKmPK6dyTFWAhzb7RjY6M
         s0jN6FSTYLfuS7qHLWL02tYAalOb6Mk3IGIwlX5/w+a6SYYr6p2RBk7c0MCRV2VfkGAE
         JTi8Bm+cfzmiflttK3+O0LOSvyy3SopWIJKy28RewJQTW5hcRnHJ7a3Cun5Fm01qemuT
         A/5cofe9Arrad5oI9y+fqRQqFJ3gooZzMn6YcK2z5r4zB0TxAgbaErmmDkMqKTWh7cgI
         QdQK/b2gZ/YO3aEw+w87PeK47KsCrKGMPog9jIHlhAPrDa+LiKRSoUUKOAbzB+0IYY23
         ogUg==
X-Gm-Message-State: AOJu0YzTNW31ZBB2g4KWcB0nbKI6Nhw3sPn6y4+7yOGuArJjHCRtEr/e
	VyozWOAPkUrzQx0T/8aWfVVHmWQg0wGdCVWXBdpyUIcI3oNwi8hJNVn5X3aOD7iV4sowNJct8bK
	oPwnuIg==
X-Google-Smtp-Source: AGHT+IHNmsWXPLbWtTbgZq+sqARZVuvxx3wm1gpdTbkFR7qbec5YVVe7yKE0dmaJGA2oM/FpsMiuJmqv86I=
X-Received: from pjbqb3.prod.google.com ([2002:a17:90b:2803:b0:32b:8eda:24e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a1:b0:240:104c:8e14
 with SMTP id adf61e73a8af0-2602be4f2f5mr5564984637.38.1757717673116; Fri, 12
 Sep 2025 15:54:33 -0700 (PDT)
Date: Fri, 12 Sep 2025 15:54:31 -0700
In-Reply-To: <20250908201750.98824-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250908201750.98824-1-john.allen@amd.com>
Message-ID: <aMSkp7e7IryG2ZAj@google.com>
Subject: Re: [PATCH v4 0/5] Enable Shadow Stack Virtualization for SVM
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, dave.hansen@intel.com, rick.p.edgecombe@intel.com, 
	mlevitsk@redhat.com, weijiang.yang@intel.com, chao.gao@intel.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 08, 2025, John Allen wrote:
> This series adds support for shadow stack in SVM guests
                  ^
                  |
                some

I mean, who cares about nested, right?

Sorry for being snippy, but I am more than a bit peeved that we're effectively
on revision 6 of this series, and apparently no one has thought to do even basic
tested of nested SVM.  And I'm even more grumpy that writing tests continues to
be low priority in general, which is especially concerning for such a large,
complex feature.

Adding support for nested was easy enough (famous last words), but I really wish
I could get back the ~hour I spent figuring out what was missing...

