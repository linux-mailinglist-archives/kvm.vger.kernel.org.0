Return-Path: <kvm+bounces-50755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06066AE9104
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF295189D6C3
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384432F3C05;
	Wed, 25 Jun 2025 22:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lXOLxEJB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1335280
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890350; cv=none; b=AP8FsDkg8p7+TNkg3pyVwYncXifGbsVn8TysyOniSslJPN6b8DlebA4N0H+2YG4oGdUbwlgvvVjAOuvQbfkhgrXc/Jguf1XG+S8bKUUrnDZXGwE5tCPh4V0SnaRhz4G0YWuyAqVejecZdxjQv53Zauz7jxBGOGWlHR7AlXym7sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890350; c=relaxed/simple;
	bh=ZcdoOQwxU3CyDjJeNeZEEN1pVlwH2SOB9r0ExNTnb5I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=imy5lX6e45CBK9I9xzrmnDEP5rV9KcYRvfXzUIhdg/Q0+AtV+FWkGBjyQGWIPRe/13u18tZyvwWR6yjP7EEeYrYmsB7Is0Z+f1wLDYaM5419Kw2NUepWtfrmghsIfnXG73hqc5E0EUyKDkB+bc81pHlMcF7uV95GKLr67kmmV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lXOLxEJB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2382607509fso1944435ad.3
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890348; x=1751495148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5pLNzxxeBjc6JUZX/DPJvwEcneL7Rpxq1mf//0ev+Ok=;
        b=lXOLxEJBQryHT4LNVSZsuTyaiDf91QoP7vGZvMbYfeHOMXWxuOpcFqUIU58e6rCf4A
         N6SZF9gqfNH7t5hXBo7peWtQ9ss7pYxWx33jghYig9U4a3YnS95uM+wEbbiRHGjNLQw4
         pJcYVBk9Xw6860dWIoONga/Fwui265U2UeD/3lkWAJ4rdKMUzYzO/NAOBxiZFPqM65xe
         2FYUTpj9LCyKXlQHME8JscnCyJwhFcMzcYagdQi6e2ssHYjU3mFUXAxmXWpnEhNsMhlP
         1RPGJe+ebpKOArgfu7J1hbv6ko2X3rFQ64gTIQQRWIhQUXyw/54RGgtSNBQl3YphYJ7O
         PpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890348; x=1751495148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pLNzxxeBjc6JUZX/DPJvwEcneL7Rpxq1mf//0ev+Ok=;
        b=ZCNVxeb4yYZqGJXvRizet3lAje87T61EBKO91MYut03QUGHM0T9OGIPGav3r0PtR1D
         Pb58sE1t3vDw4iWcaJu49rQzHmEE53b08q9CWuhlN1smACfrudhXokAGBKcpnJecOBux
         ExNTcoQrcN9paW9ez1FXkjxg/53po0QPSKOYg9iN81RyrWjaT6+0wCm2f8n8n+8/daQV
         clAL2bwVz5UzrDPfDsdQZ15QalCvbp6G0Qt2giyKBfj3egMxkPOycO040IM1UHD6yjx+
         JJQoGZlAq1+RhxdxxWRQNSDk6dtft6s1/tholElLYT/yu5BUU8L9/rz2nuwMkpzzYs6u
         OuAA==
X-Forwarded-Encrypted: i=1; AJvYcCVz9aOPPnTr725db41pgndKphKxc07rpwA+8iAb/rzWlnokITjAm6q/aMCegCx4zC4xZMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YysoIro6hsVHXjXNdao5HoVP+bBadF3numK0kQCPi2NmrbhGyra
	z/t3D1ME1LtCNUISfetKqB4wsq5/U/Is9zri5NMHOomxtsoNQsibdR7vu2R4wdrTst75H0JI1Lm
	HB9i4BQ==
X-Google-Smtp-Source: AGHT+IGuZn7pr623L+iySvz0JPQq0RwUo97Ncwcpf9CRRSz7v1+SZ3zC/cCqj+R0ROv4T2ZbAMIBF8HWc+8=
X-Received: from pjm11.prod.google.com ([2002:a17:90b:2fcb:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ecd:b0:235:2e0:ab8
 with SMTP id d9443c01a7336-23823f879c7mr59561265ad.6.1750890348479; Wed, 25
 Jun 2025 15:25:48 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:23 -0700
In-Reply-To: <20250625014829.82289-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250625014829.82289-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088967862.721202.10079126901672236105.b4-ty@google.com>
Subject: Re: [PATCH] Documentation: KVM: Fix unexpected unindent warnings
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@linux.intel.com>
Cc: sfr@canb.auug.org.au, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"

On Wed, 25 Jun 2025 09:48:29 +0800, Binbin Wu wrote:
> Add proper indentations to bullet list items to resolve the warning:
> "Bullet list ends without a blank line; unexpected unindent."
> 
> Closes:https://lore.kernel.org/kvm/20250623162110.6e2f4241@canb.auug.org.au/

Applied to kvm-x86 fixes, thanks!

[1/1] Documentation: KVM: Fix unexpected unindent warnings
      https://github.com/kvm-x86/linux/commit/0c84b534047d

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

