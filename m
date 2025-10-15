Return-Path: <kvm+bounces-60087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1CCDBDFFCA
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:06:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2591F48472C
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E476B3009FA;
	Wed, 15 Oct 2025 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qm9fVut5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11442FF65F
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551543; cv=none; b=MyWJuMgcBksdTJlC1J7qrsazLWdsrjRoRSRgD3dOZcLElK4TlsURIUnOTTakeo78APo6iuTRfK3uUw2F8VBCJrs+NeMvE7ieQeRZopoAubkRDprvbNVCIbuQXCNZ4C9Q1JCNv34oNTTGc0yF+9dmAjKIK1n0x7DCQPavnQ7C24A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551543; c=relaxed/simple;
	bh=h9PXlzkSJOy4Dm8tF5Ylr2mGcTwNvGzCf+TbFLlkBSs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iw2YreT64EIDFyHcgaeM2oQ9/GNYjQ0s+Lw2LaojMFlFIjFgP0u+TLSBTp8O5WXGVNNkrWaHcTY9WC0AOLv0Mvo2Vhswtua08n+9g1ii811rmVQkeR6KJ9LHemyG4xkwUEUul5Mrh71SWn0GdXW7w3SwfUzMqYQkvzQHsLRix20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qm9fVut5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc3aso13061275a91.2
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551541; x=1761156341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yeqsxXV03bjxJ0PtvQpTsHAesA+CZuojY13FVTwL434=;
        b=qm9fVut5/GIZ1b1TnCrW84PRFgpC0emwuj7NsZzSn7fXYhPB9QdnFCUC8BDyt7is9c
         y6/qVVPAPkt8wgqD05ZEjFmGoLOuANzsUc79CFN5aXmO59DRWC335hQVZs9iFHhxmeQD
         B6GfFZbOnmnP1jwALXeKidFNp7Xd9n9nYDYZ1gTuJgRSikpdAZ8GcdZPIAmi41f4QfXa
         ub0JnK+486RGI6Rc+zQ3CZ1IwCk4JGZiQ44HIgMS3v0UzhPKwXCxENCOdgutfa4n0cIl
         ZzO06EqJfj8YRHahu/LfdS36FyH54MsqzcoConMffokxb4/dMGJj5eaBu9ESGaRvNKHA
         Whsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551541; x=1761156341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yeqsxXV03bjxJ0PtvQpTsHAesA+CZuojY13FVTwL434=;
        b=d3v+4kpKHFR7UCqYJSSwt9hfvekpXddbbMip+nLEPbCkdq8GjyJcKnpIhcaOBdzNHu
         8S6cDSxEaEWQqwiaZuVPtaegsZUBpDgk6xu5enphrn2lQY+s2+56hN7UdsxXSkMv7FoK
         vrkeoF/eJE77YI6Ozwi5c+XnFXQe3BeaHwjCmMxDqXDH+NSQgEGKLDFqWfycdF5NiYK/
         PhzT+5bbBCpvBQAaFniu6x0cdVwJBcAGgg3SudTS5MLcibyQCqPBdL+gw9H9hCvNbS7O
         GfHnWkFU92VIkABCuMTkzbPHmmvSQNx40DteNw1zT5e+W4egInXelSGTT2Q1ORIECabv
         vQHQ==
X-Gm-Message-State: AOJu0Ywj8UHLF5ABDpUyNsmx0+EEa/6L2pkH36iTir2dfX6o3pqykH+n
	V+4fKjntqUmbLY2nBsNBWlsh7GaMV4HplVNNIqxAt/N6b+Zse442XFm96zeTCs00clixKolmjDj
	jjP7aHg==
X-Google-Smtp-Source: AGHT+IGf6ld8MWsW8VFOSwnFwhE9xFYGbI9+lJkkZWaqxzTUBkv8fa1QeFtqGV9ZmEFB8KXjqbasfUazBvQ=
X-Received: from pjbsc12.prod.google.com ([2002:a17:90b:510c:b0:33b:9db7:e905])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:32e:5cba:ae11
 with SMTP id 98e67ed59e1d1-33b513cedbdmr37767056a91.28.1760551541046; Wed, 15
 Oct 2025 11:05:41 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:42 -0700
In-Reply-To: <20251007222733.349460-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007222733.349460-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055117173.1528469.2261818917462419157.b4-ty@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 07 Oct 2025 15:27:33 -0700, Sean Christopherson wrote:
> Drop the local "int err" that's buried in the middle guest_memfd's user
> fault handler to avoid the potential for variable shadowing, e.g. if an
> "err" variable were also declared at function scope.
> 
> No functional change intended.
> 
> 
> [...]

Applied to kvm-x86 gmem, thanks!

[1/1] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
      https://github.com/kvm-x86/linux/commit/c1168f24b444

--
https://github.com/kvm-x86/linux/tree/next

