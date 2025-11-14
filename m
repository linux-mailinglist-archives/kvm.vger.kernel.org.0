Return-Path: <kvm+bounces-63161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1648BC5AD93
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 73E094E92D2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214D53E47B;
	Fri, 14 Nov 2025 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HuU6s2nU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC93163
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081207; cv=none; b=SLjOKe+2LAZmBsufgzbQwCfXkY9Ac0gfsGzD6KV2gb/BB2vnN4UxyEUEEcTIJgNlZsQq4vuCjjdJZELypeuJ0W4YD0nliQIqleBBasnySydkb5uRjQyHbYr/fIQkgtKvqLeOfY9fPvyFG6OJ7lPY6VsRIMBkoPflJyxzjl53Ifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081207; c=relaxed/simple;
	bh=bQKahWCdXYXevLlfyKh9fvcys7f8DPlggTDqAYH0XcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t5QJNwi0m1QfgDFa0lIzDmnaXqh7LLqOO6bA2g4H+tZRTZ4CrkP14EneD3DOuTmNDXEe6kRuspJUgU4pH5ZyN6EC+tRTsx7/IYRi92mHNX4Q+AzrYOEfU/FwtEMPvJy0S8Yn+GlFnwJxIKM4ufDlPqCG5HbSn7NrTccZYry84AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HuU6s2nU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2958c80fcabso37413625ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081205; x=1763686005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hUcJn5BKZQxm9xKzfC4Gud5iYysRqHEVlZl7JJeLEoI=;
        b=HuU6s2nUijYu6NvypApB4dykJHm8rJlkU2cB7bZXlA4/u6EX5z/sjbjBYtBPwNnXUz
         8PXLOIzNNFkiG+qQkxBpUTxK9JGfyOgaTPJxBBOX3CwT/LGmukIO/hm4UMeDBdk+F2YP
         6vuELY2h1QaB/Dbez9d36E3il0nXNU+pvaLu0khY0g7u5Q+ShNc+7wAenunQ+ANos3eV
         0E+jKbwF+jxx7oOsBWA8vN7p2+b2Jlc2Lc76HO71XXN8waowrs43f2MWGbr5ZO8EaTxy
         zODAVaiQg7QLK9aHogE0Wzl27Pz80XQcpnQrMNcYV2qnvGDToqvTf6hfcNLbXAXettHk
         lokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081205; x=1763686005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUcJn5BKZQxm9xKzfC4Gud5iYysRqHEVlZl7JJeLEoI=;
        b=CE1dZmA3xN3VNnIYkCB/U1twIgxvkLg35wXWPjtEr5Z6wq8YVHAWhP3VbSfyZUDrNq
         pTBa0re5MmfNr6aIXsNHgoTyx9wYrhc8Qhioro4yJSTeQ3pmiwI4jN4BWo8JOIBcw2BD
         W9Nv+pv389h6rfIyvK6tELWkZ8Dd8n74UA/ZiINIox6s8IkV+DmIRNTz013ypqMVqUKP
         d0B5n0erSas7jTIb+a12FZhKZRO/pXg9LruXVTGdOMtPuN0BPIZFwQz0uSOFRx0+Z1Xq
         kN+kt2T3u/nKj9PraBybBYqvK6bJnShfxTdgJt/St2CxgqKaou2BdEVhVI/KaECBfvBs
         E8lA==
X-Forwarded-Encrypted: i=1; AJvYcCXB0xn1krB2lQYQN8QGXg2dKnu86SAY+AGSBWAb2Dyl0IUZb/OIZ5PRibF0Ly/Kh0UuZ/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhPOef42EXAAWN1/9mUNJXo8JtfMiDumQPX9EswtnjLTYJg/9J
	SKOkld91vVlomXl/Iar0sj7wic66tN7+q8Y3aSLPe6q/vwj53/nlWFETbQFyRSNx288Cf1V2/xL
	hbm2zEQ==
X-Google-Smtp-Source: AGHT+IE/GdDLe2IICgwk6ub6VLBNQe47v2jSz3RKLrgOJnZCuZLQIivrAxbdkjdU2SDlfQfLkjuNNoJJLuc=
X-Received: from plpw4.prod.google.com ([2002:a17:902:9a84:b0:297:eca4:1a62])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f687:b0:295:395c:ebf9
 with SMTP id d9443c01a7336-2986a76f97cmr9476745ad.55.1763081205150; Thu, 13
 Nov 2025 16:46:45 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:05 -0800
In-Reply-To: <20251030073724.259937-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030073724.259937-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176307967119.1720248.6237559160280051496.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Fix triple fault in eventinj test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>
Cc: minipli@grsecurity.net, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 00:37:21 -0700, Chao Gao wrote:
> As reported in [1], the eventinj test can cause a triple fault due to an
> invalid RSP after IRET. Fix this by pushing a valid stack pointer to the
> crafted IRET frame in do_iret(), ensuring RSP is restored to a valid
> stack in 64-bit mode.
> 
> [1]: https://lore.kernel.org/kvm/aMahfvF1r39Xq6zK@intel.com/
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/2] x86/eventinj: Use global asm label for nested NMI IP address verification
      https://github.com/kvm-x86/kvm-unit-tests/commit/3f6c1917e53e
[2/2] x86/eventinj: Push SS and SP to IRET frame
      https://github.com/kvm-x86/kvm-unit-tests/commit/8d7d3b44d055

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

