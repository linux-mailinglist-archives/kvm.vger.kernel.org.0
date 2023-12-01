Return-Path: <kvm+bounces-3046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D377F80014E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 113311C20C4D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E9815B2;
	Fri,  1 Dec 2023 01:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQ0cIKx4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1CFA0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:55:58 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d33b70fce8so21089347b3.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395758; x=1702000558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7uQw1Xga8qZEfqzLKuXAMWv3VxjejvcUh7YPXL4BS8=;
        b=LQ0cIKx46c0IZdvH9zrJtgeENUIr+PCpcBi3+7+Ge47SgLG6vVEeLesQIXoxToeu+7
         GiX77RS/DKaBIgG/BjTtH1m2E6+aiy/oFTEwh892Y/z9d19si0IgYCj5YYyEfpEdboKV
         ybeTkBb3lOJQeRiWcyD6HF4g3/CAHnEqgSfiFhPZ3ZH33HZIXV6Fft3LZ6IozlcDZVry
         AdEw9cyLEBECjWPCz9mrA0323AHFkVOfmosYAOq0oFVsDa5L48pb930IgaoYYMoSm2fP
         2+FMGlfJeQuRpdJOYvWMqyeg8XV5k1h7oqk3HFzlLsQQFnwCoBTVQHOCOu9xvrDYHcsv
         5XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395758; x=1702000558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7uQw1Xga8qZEfqzLKuXAMWv3VxjejvcUh7YPXL4BS8=;
        b=cO+i/2BSGv9/KTI16hU0VTpbcJlfTFz+hN8J+VPLn77nX4BZiP4g9iilIt4CgRQUYw
         MFNqLO78mHo7ST8c6kU+CvYgNHXgdmkbV1MBTf5l2DMv0emcRDUt007a2+M0gItLcduC
         +BvmQE1XC8luvgU9rX2PUNJMUtFopDlZLNmHRksB+oKfAYEvFpbpxCQVTxGF+AuZTkmz
         C+fCX/jkyOVwUOpgWgnB1LfREwwoYaNyRvgP+eDJjS5CZYMjlwXDYz+gPgOH5V4zTJPl
         EIoV1GVWXXenAzxBXHWSeNQNVT7wN/E+wMHni7yaPLA+V1rwh/0m6AfRK4Ku4/2N8NJU
         xJMw==
X-Gm-Message-State: AOJu0YzhcrA8ftnCZ0q503J8/BWi8RqW+tQtFhyd0+H9QXk/ZlnSRTP7
	Pxza0pio/4RePAMUtCwOxI5rq+oj+jc=
X-Google-Smtp-Source: AGHT+IFSIHKIPXugZeCNVRV4VNTbeETLPe2EqqAg2VCRRFOgDavSs8Ky8b+WyqRSCuRCA1SDsjla3GViT+c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d811:0:b0:db5:4cf4:c689 with SMTP id
 p17-20020a25d811000000b00db54cf4c689mr38296ybg.3.1701395758248; Thu, 30 Nov
 2023 17:55:58 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:20 -0800
In-Reply-To: <20231027172640.2335197-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137684236.660121.11958959609300046312.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: Performance and correctness fixes for CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 27 Oct 2023 10:26:37 -0700, David Matlack wrote:
> This series reduces the impact of CLEAR_DIRTY_LOG on guest performance
> (Patch 3) and fixes 2 minor bugs found along the way (Patches 1 and 2).
> 
> We've observed that guest performance can drop while userspace is
> issuing CLEAR_DIRTY_LOG ioctls and tracked down the problem to
> contention on the mmu_lock in vCPU threads. CLEAR_DIRTY_LOG holds the
> write-lock, so this isn't that surprising. We previously explored
> converting CLEAR_DIRTY_LOG to hold the read-lock [1], but that has some
> negative consequences:
> 
> [...]

Applied 1 and 2 to kvm-x86 mmu.  To get traction on #3, I recommend resending it
as a standalone patch with all KVM arch maintainers Cc'd.

[1/3] KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
      https://github.com/kvm-x86/linux/commit/7cd1bf039eeb
[2/3] KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP MMU
      https://github.com/kvm-x86/linux/commit/76d1492924bc

--
https://github.com/kvm-x86/linux/tree/next

