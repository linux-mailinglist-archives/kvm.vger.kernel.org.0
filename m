Return-Path: <kvm+bounces-3406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A00B803F0D
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 21:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E76E41F2114D
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 20:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619BD33CE8;
	Mon,  4 Dec 2023 20:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wvoe5OiG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59896113
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 12:11:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d8d3271ff5so16916297b3.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 12:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701720707; x=1702325507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YpOU2ooCLv1IE731eabYKj790tbuwogyFPv+sco5TvQ=;
        b=Wvoe5OiGw4HQ7F6yUVfx7qJgDOLp+aQv5LrxmttJAUobmNUzzLmY9Urvh/qhwwzJjw
         YpgQ2jX5Lbx7JshLTOvuZXyI6Sb/Mq0rJ4cs+tvn2SoOJ9JltkTeyErDITl4qPjmzv/M
         cam8CpLEWDbqFDW8WndKsAbz1CAdKFdxhHtsyTd2Eae9kh8Azpm8pBtJZFFSlXgvKnw0
         HLUCoe6+pPC39vppJHkxdjg+0QQJaKXAVth8HZHMcF1AkNErcWQkWWnO9h6PoikWSOCD
         ZFbgNFz7v1+5GaABRYqswq/6Dc9kNsxA7c0D8eepFDFDwGvRys+JunVJCJ25II/yglEi
         JdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701720707; x=1702325507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpOU2ooCLv1IE731eabYKj790tbuwogyFPv+sco5TvQ=;
        b=KBARxjyRkFxcU+rf8I+du/uvsjL3nKn47zw56j/Ka0LzgvMoYE5gwj6JYvJQ16ayow
         4sSyDV4bFz0mS++nDUOeSVUGhJQmAtX36ePC1DZTnyPh+PTMBDxH2DRCVZxawYi5CPvo
         jbKtnjz+lMCJWWr4OEL4kQUAgX7HX2MDJTAd1ntmn0TnYRqzLU26E+rBm4agBmOqm7Wm
         xhlXc7EJRRJuLn4vpGiJ2qgbf8jAMKkTbMU+IRqgM3hK1WbeGyNix1etlftE5WfZBPFu
         PVhByw8k0IrLphRZcVdIu8q65UuHvAMOPuutCL3cC0RQgUgqNdGEpEf3L1OpC8mY0iqK
         jNyA==
X-Gm-Message-State: AOJu0YzuxV9viZtbmUOgFNclFi9UWVKRHLG/t/Jw4MiG0OXWD+da3HQq
	9HKxTvtpoid163LtMx2D6O12Gbnfm30=
X-Google-Smtp-Source: AGHT+IHLvL7F4SnML9BnJOEYkMPzq+JUrdFdxVVPR0p4zxv+RrWuH0X6xOW9Hg/+32yf5Zr0Hl4RQumsq8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b650:0:b0:5d7:3abb:1424 with SMTP id
 h16-20020a81b650000000b005d73abb1424mr169600ywk.6.1701720707487; Mon, 04 Dec
 2023 12:11:47 -0800 (PST)
Date: Mon, 4 Dec 2023 12:11:46 -0800
In-Reply-To: <20231204195055.GA2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202091211.13376-1-yan.y.zhao@intel.com> <ZW4Fx2U80L1PJKlh@google.com>
 <20231204173028.GJ1493156@nvidia.com> <ZW4nCUS9VDk0DycG@google.com> <20231204195055.GA2692119@nvidia.com>
Message-ID: <ZW4ygoqOq2JpXml3@google.com>
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com, 
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 04, 2023, Jason Gunthorpe wrote:
> On Mon, Dec 04, 2023 at 11:22:49AM -0800, Sean Christopherson wrote:
> > I'm not suggesting full blown mirroring, all I'm suggesting is a fire-and-forget
> > notifier for KVM to tell IOMMUFD "I've faulted in GFN A, you might want to do the
> > same".
> 
> If we say the only thing this works with is the memfd version of KVM,

That's likely a big "if", as guest_memfd is not and will not be a wholesale
replacement of VMA-based guest memory, at least not in the forseeable future.
I would be quite surprised if the target use cases for this could be moved to
guest_memfd without losing required functionality.

> could we design the memfd stuff to not have the same challenges with
> mirroring as normal VMAs? 

What challenges in particular are you concerned about?  And maybe also define
"mirroring"?  E.g. ensuring that the CPU and IOMMU page tables are synchronized
is very different than ensuring that the IOMMU page tables can only map memory
that is mappable by the guest, i.e. that KVM can map into the CPU page tables.

