Return-Path: <kvm+bounces-42509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B648EA7963A
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCDE37A4D93
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2291EF38E;
	Wed,  2 Apr 2025 20:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h1xng1FC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DC41DDC00
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 20:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743624389; cv=none; b=q8Q3mf3JzVWLCfogC1FLwJx89BE4y0lGf0dmuhjB6BSgoqm3Ruz8JG3NHjuSDfTvJ0BgohemUjlin2kvvhw4orfGMI0FAvZEzWKRNBpvs+/zoWzyjY8/O3TIpmffy2nTNWX7HfWOKu1B7UuSO5/H5AqKJ50nlOvWeBkpN51TO5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743624389; c=relaxed/simple;
	bh=Z511ExWHOkpvZkTUAIF1xEmNqB2nN2j/yYIsjlignuM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FFWwe8BQxPyyuXBmdr3Cujfnzil5nzUj/lWFavrs0Rxa85itjvYVpMU5p4DBjq5JZ+yxG8x9XVjV7AJZV4Xua7qERP4qOVY7fcTrWvKIxSrF670+w3Hqf8SF3WNYj6anqe+EOHSljLkXKNf1tRIPetolRjsQwS3RSidGSB74zaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h1xng1FC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736cd36189bso252140b3a.2
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743624388; x=1744229188; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g1UYmbv2w3yc5otQhqEJOM+obYGjt1TtH6vbyo6igyo=;
        b=h1xng1FCB5bcFZFPigHj16SQv/F3Rf8cjsL/7m4Hjlok8Tccoy1P7E2CxYrsBtS+WH
         6cHmwyXhtdOA7orUHxlrf0+ZuAF/ZECnX8adufj5g51qC3715bx/oYv3rrnhKdl9QOQd
         MieUumLqvhKzqzbmRlF+dzqtTNjfKrZpJkqwAzph9b62OTQYXC6J30lj9wwEl4UII3u3
         OppA7DLrlM+O0Ot3xxDzFqyVsA81Qz93UEEGQea+LOlKHnmrty6B16wo8tVp42c/JwoA
         t8266EV5lbJWhm7yS2vW3+G+K1+kNQ5XV1qU0vSgN4aM5OJv9tA9Kpx17V7qeewNosyj
         5mkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743624388; x=1744229188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g1UYmbv2w3yc5otQhqEJOM+obYGjt1TtH6vbyo6igyo=;
        b=qA27RhRBBNkzb/i/43M3BvmUH3GQnsXUiRF1g5dX1UlVVK3naiAy7EgeBvl+kM1udI
         grrwHvLRo2Z5kncKo1PGWTO7PBZjkwDOFSwf7BsEFJH2Qu7i56un10Qn3Qdb4rkqoj3w
         Ff7s9+aeyoTnuKeyNx1Fk2eKemghkPwlBe3ZjUE93w5XV6sgwjjYARi9l6UWoUS3aqUE
         M/e/4TN0k7kYB3VNX+3vBd4rACzrr18ErcUXwRzCUqFitHR0l/qvWXfE+Uvt0YOxnim2
         tuiFt1H73IGoJjlNWdMKpU5XKuZQ8Qrmdbr3yc/SBL0VLpO5BuoH+0qws6CJ8Vf2hoYl
         Byog==
X-Forwarded-Encrypted: i=1; AJvYcCWPYfjcz29uIzlJjACARPl4Wffdrl9l5GuUFi19GoKVioSsSOap0eeLDSEAHvGnYWP0Tbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQco5CY2Y9N65cU58UXy8iopMepdkhcrSFwOBa/IB6h2ZTCNBJ
	VMSTFdHkOrwejwFaq9eigbgQVF71E1nejJddl3NvEqiTkLPl2VVvXGG7CxuS55nN/X8VUqQB16D
	9PQ==
X-Google-Smtp-Source: AGHT+IFdwlbNUEhA5drbsYbULq/4vEQIA4XkJbgogx/Nxg/eRY8AIsO1wKjgM+KvnVOXc9haiiqUOh44YzU=
X-Received: from pfwz37.prod.google.com ([2002:a05:6a00:1da5:b0:736:3d80:7076])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a5:b0:736:a77d:5412
 with SMTP id d2e1a72fcca58-739d855eeb1mr62511b3a.12.1743624387693; Wed, 02
 Apr 2025 13:06:27 -0700 (PDT)
Date: Wed, 2 Apr 2025 13:06:26 -0700
In-Reply-To: <Z+ymyiNlzJtM50gF@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401154727.835231-1-seanjc@google.com> <20250401154727.835231-3-seanjc@google.com>
 <Z+ymyiNlzJtM50gF@yzhao56-desk.sh.intel.com>
Message-ID: <Z-2Ywg6UK8lLYklA@google.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Use separate subclasses for PI wakeup lock
 to squash false positive
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 02, 2025, Yan Zhao wrote:
> On Tue, Apr 01, 2025 at 08:47:27AM -0700, Sean Christopherson wrote:
> > I.e. lockdep sees AB+BC ordering for schedule out, and CA ordering for
> > wakeup, and complains about the A=>C versus C=>A inversion.  In practice,
> > deadlock can't occur between schedule out and the wakeup handler as they
> > are mutually exclusive.  The entirely of the schedule out code that runs
> > with the problematic scheduler locks held, does so with IRQs disabled,
> > i.e. can't run concurrently with the wakeup handler.
> > 
> > Use a subclass instead disabling lockdep entirely, and tell lockdep that
> Paolo initially recommended utilizing the subclass.
> Do you think it's good to add his suggested-by tag?

Sure.

> BTW: is it necessary to state the subclass assignment explicitly in the
> patch msg? e.g.,
> 
> wakeup handler: subclass 0
> sched_out: subclass 1
> sched_in: subclasses 0 and 1

Yeah, explicitly stating the effectively rules would be helpful.  If those are
the only issues, I'll just fixup the changelog when applying.

