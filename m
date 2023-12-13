Return-Path: <kvm+bounces-4361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2B4811A3B
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEBC01F21C85
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAEA3A8DF;
	Wed, 13 Dec 2023 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pabpV9GQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED569C
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:00:23 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-daee86e2d70so7864776276.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702486823; x=1703091623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YEIp+Z98yah8auU1WQuG3cH/nZbC2Dnq/ftG5xnWKuA=;
        b=pabpV9GQ33XaJUu0cFxJYTthfk/k12oXgngcGxkd2E2o4vQmo+PVJVu98CSUO6uTzY
         JZI+H2fK25uy47Y3ySDm3HWseXcs9Qw+rPGj1L7xiE9pL+nhlsNVEv2jo1FyAnihI3PA
         hX0AtvGQ//+/TGyQSobqW8Wuu7ZAaW7gnEb5Q6uq0jTV4usn4pbNqf0ef26C6b6wecsb
         hu3XDXtYRJ46hXalik1Frc8Mulmx1CcE5QFa7C/GFbUQq5QkUGszp1WRBRpknZgcxA8F
         57mbDVNNI284CUUWq/9qFfYPSWfaeU2DB3Kswq/It6naFLNs2VFxAkTgDmYhCbwBKN6m
         U7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702486823; x=1703091623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YEIp+Z98yah8auU1WQuG3cH/nZbC2Dnq/ftG5xnWKuA=;
        b=dpuGC/Lq7DJzX153xTmb/B5TXbxmieHNgL5UGGOXIrca9yhtc8mr2NRvPClmuRtnkl
         oS7IQMveicjCDnRDsSJgv1roEhiPYHlkShUZBxQ8TvMikDUMoqFEBfqju/ufM98rQezo
         B4latR4gug3/VOLEK/YQS9Prglp5JNBny24GqA0/3IOyPFGXCalmShRyX5Vi5O8YefQs
         H1pz0GkkZQ5CTzHI54Sc5WiWCfq31UAbNosuTaP095EIyiUTyepuAqteoVY4BFvK3DXb
         N24tfYkcFxCJRez/+fGD+8323LbWy600X64o5kiF5h+3fC8flp76sjlHty9g/hD9c8dG
         7cxA==
X-Gm-Message-State: AOJu0YxN2ixTYYlHS0LopiskqcoXSHe+Wckz9CzL5VQHAzUCVa+5Gm3r
	ykygYLZ6o9siXuUEziEfaMRx5twfp2c=
X-Google-Smtp-Source: AGHT+IF9nGp44wo1fB5QlYX1jS8q2Y2b6Z+/0mKZHg5AzynSBFs1zE+w6qIuRVPL6VJg68r1XGw+2t6LnJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1782:b0:dbc:cfcd:9ad0 with SMTP id
 ca2-20020a056902178200b00dbccfcd9ad0mr19392ybb.4.1702486822942; Wed, 13 Dec
 2023 09:00:22 -0800 (PST)
Date: Wed, 13 Dec 2023 09:00:21 -0800
In-Reply-To: <bug-218257-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218257-28872@https.bugzilla.kernel.org/>
Message-ID: <ZXnjJYpkYWxETPVU@google.com>
Subject: Re: [Bug 218257] New: [Nested VM] Failed to boot L2 Windows guest on
 L1 Windows guest
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 12, 2023, bugzilla-daemon@kernel.org wrote:
> Environment:
> ------------
> CPU Architecture: x86_64
> Host OS: CentOS Stream 9
> Guest OS L1: Windows 10 Pro (10.0.18362 N/A Build 18362), x64-based PC
> Guest OS L2: Windows 10 Enterprises (10.0.10240 N/A Build 10240), x64-based PC
> kvm.git next branch commit id: e9e60c82fe391d04db55a91c733df4a017c28b2f
> qemu-kvm commit id: 
> Host Kernel Version: 6.7.0-rc1
> Hardware: Sapphire Rapids
> 
> Bug detailed description:
> --------------------------
> To verify two nested Windows guests scenarios, we used Windows image to create
> L1 guest, then failed to boot L2 Windows guest on L1 guest. The error screen is
> captured in attachment. 
> 
> Note: this is suspected to be a KVM Kernel bug by bisect the different commits:
> kvm next                                 + qemu-kvm   = result
> a1c288f87de7aff94e87724127eabb6cdb38b120 + d451e32c   = bad
> e1a6d5cf10dd93fc27d8c85cd7b3e41f08a816e6 + d451e32c   = good

Assuming `git bisect` didn't point at exactly the merge commit, can you please
bisect to the exact commit, instead of the merge commit?  I.e.

  git bisect start
  git bisect bad a1c288f87de7aff94e87724127eabb6cdb38b120
  git bisect good e1a6d5cf10dd93fc27d8c85cd7b3e41f08a816e6

and go from there.

Hopefully it isn't the merge commit that's being blamed, as that will be far more
painful to figure out.

