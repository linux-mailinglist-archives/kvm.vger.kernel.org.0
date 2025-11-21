Return-Path: <kvm+bounces-64231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D92D3C7B677
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1556B365AA8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7905B2FFF92;
	Fri, 21 Nov 2025 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WhKJwt7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD982FFF8E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751376; cv=none; b=AOdhHEuB+BXPhN+5JVrPAVm59/oFXwsHbxP7AGFGzPUgh9c2M9W7ooEDzKeiUedLnuvpZY/B6H7DDDdFhnbnixUgbJtjE6nd13HOXr50EzhUhi9fb2Ck0w/1jaJmHeUwLhaLe9HZvV6CUct2eUdo8I6fzqUog+rqSfPUqfl11AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751376; c=relaxed/simple;
	bh=pA6HhH8cYu8tFmUOKlzpU3Wp08scGDLJ7KsfyRnftss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nk/FBj24pQzMN/oz5/EWXh+Wp7UeDAjmMPGjdxX4AKj+DKPmtiNhNGGfJ83RF3Ds99zEejenGXo/11D5aVclIvkH4l9DPewMQ6/8FLOgy/MYHMWf18XCs48lX/dY7xOXV5iZVlIfJ22DvmQj43xQIQQvtdAGv1wKOO+KGJCjopA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WhKJwt7Y; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295592eb5dbso60319965ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751374; x=1764356174; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dyfHUqL6df9F6XiTb90JYkfND1n7NtpKe8YZliaM9OQ=;
        b=WhKJwt7Yi/tk83E1p5vgoMJAtxBtfjJLaq3FfrKLBmhJPbR+1+tX3SF+TfRuez6PZq
         FTOLSi7EJR/rO4Sh7y2cwNsY0WlZbvo1Ag6QZi209K58YQoGzFKb7tht+86y4IuZrY0F
         B8ytTiZwgn+YXlytd8c6GribZKFjKnqdzrDrcth5oQ9c2oN6xHuvm+aM1zBQc/QgROl0
         M/yFaEz14HoNnHp6gCilL+lgr0idCe4lWwKApYbarxACX4H5RFHhtGIgRkXaxNKdpGA1
         WsFA2mALZalPeCDRhvoH2SoM6LxEKapoVdu2r5UwwF478D8sUV5y8U8TuwJG4luboEeI
         1fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751374; x=1764356174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dyfHUqL6df9F6XiTb90JYkfND1n7NtpKe8YZliaM9OQ=;
        b=V4+XLddX5I5lD+gVnFohzNaVW7fNwAs4fR8602wb/7BhKcrKGrgDsfpjAnHD9QQ3i2
         5QD7gabwudMtckMz5Y7PmrLPc8vkp6U3o2pETLnYsylDPBMDwURZyeZiYNydqgqv4EDh
         /9biCL/GprbxVVA7ZmMx4P1gTVmur/WVAOmznkOgUmm7KDEO6U03P0rMH0nbjpIWtRwy
         puKPw2NNBmWF0oL4J2dndfHbzf4jaik3Vbbe9smn0MtkvNBe7iLMk3ny0ofXdyFPvJGJ
         i04N8PHaFSKHldE5q8MdNB8V6ESJFEGiOiRS1jB7vnNMH7oIiJhOyH9H1rYcS0Ypgisu
         8a6w==
X-Gm-Message-State: AOJu0Yxk3oGF1VmTZTO5htoE16uScqLc0mAoQKyXQIVMsQBXCcQdshMB
	/MfOgIjYpO7DSSw3t4gSF0yA6im/sVRPpQtOIHidb3K5t/Gp4SgBfH9073JHUd8QMhvu3sOrNmJ
	tdXKddQ==
X-Google-Smtp-Source: AGHT+IGGb1aHI5E6UaxYSqn4n/1r9BCGdlieziJtcx6wMic5y2PJaDDWne0NG5Ox3KhGZrA49vtPf+i99x4=
X-Received: from plhy6.prod.google.com ([2002:a17:902:d646:b0:298:1181:af51])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:46c8:b0:24c:965a:f94d
 with SMTP id d9443c01a7336-29b6c699252mr39885405ad.46.1763751374581; Fri, 21
 Nov 2025 10:56:14 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:31 -0800
In-Reply-To: <20251118222328.2265758-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251118222328.2265758-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375129628.290245.2248166569099413567.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Jon Kohler <jon@nutanix.com>, Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 18 Nov 2025 14:23:24 -0800, Sean Christopherson wrote:
> Optimize XCR0/XSS loads that are currently done on every VM-Enter and VM-Exit,
> by handling them outside of KVM's fastpath inner loop.
> 
> Context switching at entry/exit is unnecessary behavior inherited from a
> hack-a-fix that papered over an egregious #MC handling bug where the kernel #MC
> handler would call schedule() from atomic contexts.  The resulting #GP due to
> trying to swap FPU state with a guest XCR0/XSS was "fixed" by loading the host
> values before handling #MCs from the guest.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: SVM: Handle #MCs in guest outside of fastpath
      https://github.com/kvm-x86/linux/commit/ebd1a3365500
[2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
      https://github.com/kvm-x86/linux/commit/63669bd1d50f
[3/4] KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run loop
      https://github.com/kvm-x86/linux/commit/75c69c82f211
[4/4] KVM: x86: Load guest/host PKRU outside of the fastpath run loop
      https://github.com/kvm-x86/linux/commit/7649412af3ea

--
https://github.com/kvm-x86/linux/tree/next

