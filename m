Return-Path: <kvm+bounces-60554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90039BF2761
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C1BE18C1866
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F196292938;
	Mon, 20 Oct 2025 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mi7zAvOc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDA424168D
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978049; cv=none; b=Cz3uk7rV9RCTh05FJHRGJKpb2S96qdWRBqAT+nc5g+SSctIxdZnK+n11gvxAT+AY9HfXjuubuTniXWeX+SS6ffsFMGX11XNIiVjxOiQG8v9wWuoNcXqR0Udgg9QS/cR3trRbavX6VQ53wQSeGEmngSeBZShYdgBh+oR6/UJ+y24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978049; c=relaxed/simple;
	bh=xiWetylhX8aIUbKWVv+lOup7Ov4PSijKXTi2mzMocEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ry3g0nf7WJPgWkEXdyJU79iZIjO9DWXK0Ts46ms2ptb1d3CGSc6jA9nJ6Bk5bp9VjyHQK8WYJMRrBTGp9zookRJbzLKyrF/D7Pl0WK34Ne39rd6DzNamX7ueitvZ/vvXXp8QW7UNohW5qpDoUOnPKYn+BluF0ch5tNEa68iBmmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mi7zAvOc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b632471eda1so3860850a12.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760978047; x=1761582847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9NLkKkG0rJ/zH6pfyu4oN0Lt2d/eZCoAWcxhtat4F1Q=;
        b=mi7zAvOcc7P+6s3xq6Quf7oq+JvRsfk5n+o0bMEeGDAN2pz8liYLIQRtqSW7IaMoiK
         B8Zo/5JQzB54huzKbwn0dpDT5QV+/i+ww5xSr2vVnqkz/U5mNDxfCdqXfqUAo/eDYbQq
         RiCYZzdTvlBvGLc7IBrVda7dRXSDfHoGpmVsqoRhPa6BnuX3EZ3roF+NSSNxYJ2gwiUM
         O7ZPyi6+CYBxCln1Vxx/Nb0oQbxv6fRtYeekoTxnn5HRgLuO9FNR0+oc1rOY5ZbI7UiS
         YJuE/ZZtm61eai7j4pqqqqIJl0ol1ewfm28jsMpW1gzICzv38GWzMcOtFKbKAlCVYiLV
         MygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978047; x=1761582847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9NLkKkG0rJ/zH6pfyu4oN0Lt2d/eZCoAWcxhtat4F1Q=;
        b=qUTjE0Uwitz5HH3p8yqc2rjKSRz9gqLJEycMuUlL1ikH+AVc8CXSLXtXVTgTQU89AZ
         ZchOgMk71+o1NZLtOqYNlqmh/47kUZlHnbWpiqSIjCmaIzM56pCv7Bft2wgUij6Vv0KG
         OxeAjoGGFBaviz1oY3roUVjpkBg6Pfhn1crRdVXoNt8Xj8uEEWcIq6wY9/TNY9Rg5J2n
         zYdqiUlf+a9lQkB5dwxRgOZqWl78dFHdSKrzY9Vxq+7CQ4oIE1x85mViIf+FZsDkXTkw
         8HSBTUOn9SF0LOTtHcrQrVAzz4BTpXj/0/QeiUrDx35BAlSYXWNpF93pnDaT2eoiq9LW
         y2nQ==
X-Gm-Message-State: AOJu0YwCbZ9tT/vDbUKb44RMDpfx95daSzLkmveWtdzaI/GXOpQbomEm
	zHXKW11W+pVDnbxzpsUQG5ky7x8FBLz8F1cxvT0G+UWUs3g3E2nmqQ81Frj5FRdgs+QobMUnB3r
	n46l9iA==
X-Google-Smtp-Source: AGHT+IEJv6yeyeoTe7I8mAefhCPoGpckkYVmGUCQNqR8Nia0SCK2k2ra2USQ3kI6crqyFEHerkAOacWrfno=
X-Received: from pjzn11.prod.google.com ([2002:a17:90b:d0b:b0:33d:acf4:5aac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52d0:b0:332:1edf:a694
 with SMTP id 98e67ed59e1d1-33bcf8fbbd3mr15270833a91.31.1760978047179; Mon, 20
 Oct 2025 09:34:07 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:33:03 -0700
In-Reply-To: <20251007222356.348349-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007222356.348349-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <176097601867.439156.11041449627994730588.b4-ty@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Define a CLASS to get+put guest_memfd
 file from a memslot
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 07 Oct 2025 15:23:56 -0700, Sean Christopherson wrote:
> Add a CLASS to handle getting and putting a guest_memfd file given a
> memslot to reduce the amount of related boilerplate, and more importantly
> to minimize the chances of forgetting to put the file (thankfully the bug
> that prompted this didn't escape initial testing).
> 
> Define a CLASS instead of using __free(fput) as _free() comes with subtle
> caveats related to FILO ordering (objects are freed in the order in which
> they are declared), and the recommended solution/workaround (declare file
> pointers exactly when they are initialized) is visually jarring relative
> to KVM's (and the kernel's) overall strict adherence to not mixing
> declarations and code.  E.g. the use in kvm_gmem_populate() would be:
> 
> [...]

Applied to kvm-x86 gmem, thanks!

[1/1] KVM: guest_memfd: Define a CLASS to get+put guest_memfd file from a memslot
      https://github.com/kvm-x86/linux/commit/0bb4d9c39b76

--
https://github.com/kvm-x86/linux/tree/next

