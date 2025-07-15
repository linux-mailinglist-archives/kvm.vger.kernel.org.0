Return-Path: <kvm+bounces-52508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A52B9B060CB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27C8D1C816D5
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 14:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666371DED40;
	Tue, 15 Jul 2025 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/QNfehJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBC31D86FF
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752588065; cv=none; b=OHXI/yFD5Cu6DXXKYG5SNFyR00Vtp9hQm7ViveyywUk5tYqS6h35zLFStX9SWEdoGUJoxvb9zCtrebehkUjB1QrSpGUfX+YTpqThNAxPztZMFAODfCZF0rWpM1tsGmSVxRgZ/yT5E0rzKkDof36Bky3KnRnFlCKpJlueeyHa8rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752588065; c=relaxed/simple;
	bh=TrnovlFvN9Zd+BkP1HH/ZUQYJ9eJy+bV7Q1OsXxaEj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iB+8Ag15+uAnHBMjmD202+d5TuCyPA/CiPgDzoO3dnXG5tLHOTDs4TtbeZbo7aw241C2bWz51VQJ7gmoAxLQIDn80DsEfn5aVCIJCvRBpvs4/oLBn5MSbhWbTV2xQoykhCe8eb6sMxycPWaPgrNYdTd/6VjvZBGkt60KgKEAaSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/QNfehJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso5305829a91.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 07:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752588063; x=1753192863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=An8FlwzirITNbBr0qyU5frw+U6I6QNI3+OjkL8lhnTw=;
        b=M/QNfehJ0AuVLENN9wW/YrJX2uXXrRacEOQMxNkI4ZT/42DvFFrmYPiZctLQTFWdVX
         7VsTgFddrELGJB72VeSmprpIsZq6YPD9mdcrBKf/U8xC+tU/nLaL+lvxODg74MZfwh6x
         h6O+Q6PL59p9Y419sCSRv/tgGKbqWcg9pQqL2zUdt9TGB4uN9qVVv2U6A9eTypdc3CsF
         Gc7o3f7EkCT1wVCE1JibzLugTiR5gDCqTL5bmCKibw7tv20fJ7cdyDl/UB6TtAKZVGWK
         xxMDGXezPG3wrbdY3sshNqto4iVEu9wXGzi+aS18gbIOf1ESc7Uyh4llbcPqkeVReqJD
         SybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752588063; x=1753192863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=An8FlwzirITNbBr0qyU5frw+U6I6QNI3+OjkL8lhnTw=;
        b=sGcuCKY9qIq1MLlbiWJ80+Z47nGEJ6ZommmKKoc+hDZs0kGH5awb2GS12hmDIdOel7
         x1jJC5s3zf3qvCwxXy1vfTu9xK0t/gfDnt0DxNRxuO/TXLo6NjrZSJqyd6K3RKszrZLs
         1s2gD9ris6XTdoksRJpmPEsgw1oOu36ba6XXO/CetV/IecZw5phL+JGULDcJSGE7En6t
         MZfuTRiQv+KuaYkxYNCyl/fts7v6mGpl0y1ymhceqbOPaMz8J8t/JjJXOjxpJzogRIw/
         2/PKpPm6jwXSO3NyBTvXYEHxs5QS7MPjE/Km6aQ56RKNj4+PBa3e2t6eOYyUJa1Jmm3B
         nTRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4IuXWhMClELgT7woW29DnhTj6srxQh036DQw44u/cp7B9c0BWVAcPFxgEMGM6dArccdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxznZvONDsTbXMByr7jkvHiRxtW3Z4PENaa+NxXipux8MkQYEF
	jU+qd3y+tSgIQtq/v2A2CPEwVm8rxjs2mq7RUUVNnSUlnMXFnzJICdnsIJBEFRlb/2ykuAdlBv6
	czLlqgg==
X-Google-Smtp-Source: AGHT+IGw0SjVGVK2JASNvhRI2hQZzMIFRjE0AK9+sp6bRe6KtNKNJpueU9J9XmAZCXadJk7v7N9P2NDvbf4=
X-Received: from pjbtc11.prod.google.com ([2002:a17:90b:540b:b0:312:15b:e5d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524c:b0:315:6f2b:ce53
 with SMTP id 98e67ed59e1d1-31c4cd8b6b4mr24938091a91.25.1752588063607; Tue, 15
 Jul 2025 07:01:03 -0700 (PDT)
Date: Tue, 15 Jul 2025 07:01:01 -0700
In-Reply-To: <aHZM1ZhTsET5AE91@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250624092256.1105524-1-keirf@google.com> <20250624092256.1105524-4-keirf@google.com>
 <aFrANSe6fJOfMpOC@google.com> <aGJf7v9EQoEZiQUk@google.com>
 <aGwWvp_JeWe9tIJx@google.com> <aHZM1ZhTsET5AE91@google.com>
Message-ID: <aHZbyAIoyJZ7c__9@google.com>
Subject: Re: [PATCH 3/3] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Sean Christopherson <seanjc@google.com>
To: Keir Fraser <keirf@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 15, 2025, Keir Fraser wrote:
> On Mon, Jul 07, 2025 at 11:49:34AM -0700, Sean Christopherson wrote:
> > For all intents and purposes, holding kvm->srcu across VM-Enter/VM-Exit is
> > disallowed (though I don't think this is formally documented), i.e. every
> > architecture is guaranteed to do srcu_read_lock() after a VM-Exit, prior to
> > reading kvm->buses.  And srcu_read_lock() contains a full smp_mb(), which ensures
> > KVM will get a fresh kvm->buses relative to the instruction that triggered the
> > exit.
> 
> I've got a new patch series ready to go, but thinking more about the
> one-off accesses after a VM-Exit: I think VM-Exit is a barrier on all
> architectures? That would mean the changes to include
> smp_mb__after_srcu_read_lock() are unnecessary and confusing. Maybe I
> can drop those hunks. What do you think?

It's not.

commit 65a4de0ffd975af7e2ffc9acb875b6a8ae7ee1aa
Author:     Yan Zhao <yan.y.zhao@intel.com>
AuthorDate: Fri Mar 8 17:09:28 2024 -0800
Commit:     Sean Christopherson <seanjc@google.com>
CommitDate: Fri Jun 7 07:18:02 2024 -0700

    KVM: x86: Ensure a full memory barrier is emitted in the VM-Exit path
    
    Ensure a full memory barrier is emitted in the VM-Exit path, as a full
    barrier is required on Intel CPUs to evict WC buffers.  This will allow
    unconditionally honoring guest PAT on Intel CPUs that support self-snoop.

