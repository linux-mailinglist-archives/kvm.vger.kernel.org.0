Return-Path: <kvm+bounces-58197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4E8B8B4EC
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70CEE3BB13B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D542D3ECC;
	Fri, 19 Sep 2025 21:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5N+wFrq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6172D3727
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758316549; cv=none; b=Y03ApacGk7p/jR2pdQOyROaVlGDZEBd96BjjC7Vq56bHBtXa3PXyFk1wNQ2UEtXQNzHM5FxkLOikxaEORJT04Gv4fGqp8vhm+KsaaxLK8jUzbJScjDtH/4SAYX/IbOEGMUAtqGiiKBWB2DKORlzi7blabQ3xsErhbvrsLSpK6lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758316549; c=relaxed/simple;
	bh=75+xMcEBZ4CCJG3zy2Fp8An358EsjOFKAwpWo1duVAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NxVeVpurf/s4Sv0JIbLR5iek3jh0/OxUNZOUAJpqmwfcegV5DGet3TQzPJxT9tJkgkkBkTDhACSlm7LlPUXLB9R1B3OTW69HX+05DjR1vB4u3ZzvGCthjHzrI5e9uylVl5thIc3/pgmDYFroDVDIr9EBgHmswmMejwFujOgY/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5N+wFrq; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445806b18aso30368555ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758316547; x=1758921347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0+Liys18anQK6gRZATENTJbkZzHDkR1/8jEpmQV1kk=;
        b=V5N+wFrq6fqFRTC7AmC26PUcdxAZ8h9bG+e3cZ21ID4LzXmZfij2HTgMAGmOQc0rhC
         Ar+nVd4C5vdVvBX72hAvTyoBACMM7MjTNYUolzviG/e2E+cHlIs2iJRiOgbDCcAm+D40
         P3mwCkKBKS9IFUW464zmiarb5QrJEBcvN30aMgL6X6BrzFv5S6EBDZgzR82f7zKZ2tid
         RSO7h4XwwMRP4h+uHWA0QyXvtc+liL3LDpwl1GAJtCG+TNIrt8RES0FkSsoqRCSNhQdR
         Tpz6uTgQv6uN1VO0eqx7vpZDygwXapnfhuT+cMKG3L0mZ/GKZstsZUAmo/PzpS+drzah
         HTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758316547; x=1758921347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0+Liys18anQK6gRZATENTJbkZzHDkR1/8jEpmQV1kk=;
        b=I2/Jzhme4uLqcYOIy7SQqL3RcVgZ95wOTm8iZ0wYfcP7XWBcUw9QoyVv1mH5PDVCbz
         3sAxIsaj3nR2CUupyOZkty6pWs/hZjJSxSx2+S2u9HyOEc2edDpHBxEzE4Nzld0c0C9j
         IKm7Ck3tm9y0jh4p2Xn6880ad6HyBcebMmnngIhwCZiGWPMFHAQRXjuOsfOygap7k0hA
         7kFY/tIYj7wtTsXI56hXLargd0NAg4fzpQyVh0DG2e9UuR/O0hF5fj5bKXfuKcFmDPXW
         sPKIoW3nGc8M8bpIctpypy573Bvb9pfUa7AEHB6N+gYV9BBiDHoWX6INu1Pi+vCa7K5F
         7VJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWwW36CWqOGOchXLe+WNkszmVW0c/chJRpCqXMMgIcTAe4wg+s+h0onrkej2T7BTFjn8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Cbg27Em5pSjjvRRVRSfaa3qlGKyLdfAwH9payBOCe/enONSF
	9V5j0mfkQgSL6+FjnwXfMZ0D0BddfQ8WEaAz5fNQazoG44l3oQvOgDySvitRgYqsyie91evbhP6
	imiiFIA==
X-Google-Smtp-Source: AGHT+IFdtQnkscwGqsgriF6C5QkossH14ZthE8OI9NmQ2k9LQwcIhxPc2sZV4JW/RFjatX5u3z54HnLVEKs=
X-Received: from plbjh12.prod.google.com ([2002:a17:903:328c:b0:269:96fe:32ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac2:b0:25c:e895:6a75
 with SMTP id d9443c01a7336-269ba4f020amr59534475ad.28.1758316546890; Fri, 19
 Sep 2025 14:15:46 -0700 (PDT)
Date: Fri, 19 Sep 2025 14:15:45 -0700
In-Reply-To: <20250918181144.Ygo8BZ-R@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com> <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org> <20250918154826.oUc0cW0Y@linutronix.de>
 <20250918120607-mutt-send-email-mst@kernel.org> <20250918181144.Ygo8BZ-R@linutronix.de>
Message-ID: <aM3IAaCVx-PDeDsi@google.com>
Subject: Re: [PATCH] vhost: Take a reference on the task that is reference in
 struct vhost_task.
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Sebastian Andrzej Siewior wrote:
> vhost_task_create() creates a task and keeps a reference to its
> task_struct. That task may exit early via a signal and its task_struct
> will be released.
> A pending vhost_task_wake() will then attempt to wake the task and
> access a task_struct which is no longer there.
> 
> Acquire a reference on the task_struct while creating the thread and
> release the reference while the struct vhost_task itself is removed.
> If the task exits early due to a signal, then the vhost_task_wake() will
> still access a valid task_struct. The wake is safe and will be skipped
> in this case.
> 
> Fixes: f9010dbdce911 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Closes: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com/
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

Tested-by: Sean Christopherson <seanjc@google.com>

