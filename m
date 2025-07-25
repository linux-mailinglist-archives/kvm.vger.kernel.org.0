Return-Path: <kvm+bounces-53479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 358BEB1266E
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DA6C1CC4463
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B23253B7A;
	Fri, 25 Jul 2025 22:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NZjc+X4A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360F71DE892
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481238; cv=none; b=jmy+hme3P9VnMEIboWjEhhh4ZQ2HvXUbX2he09UORqCH1k17pFgyILdHHo0+BofbaZyXj/YLhH/lD3drxIxNzJoRquRq5nNN5Kw8UXFTo8JQZj4Z7tF1J9WhHa4OinQP+iVSjd7MbyhJjl/2WMbdeB2ZtpAmBO64pt+16wIN3/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481238; c=relaxed/simple;
	bh=P2rijM+RIYnmjzuZgBpO3jYQnTa55l7KM+MuAmQ2DCo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o3RUCibVWHijiFw24WvQsnF6WeeK1WWvYkUw3Shd9yCvXGiJLWquw1nHhUFnmQVxc7sNnygCqHWrjtWbLSqs8VYf+vZhTCVownGY07XpWTO3KpedObm1l1cplaEESzmqyE/juXovBBo8B2TZhviH/eCpaOloINS5MjYONuKFG5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NZjc+X4A; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74b29ee4f8bso2374819b3a.2
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481236; x=1754086036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PK3OXoVC6Y30TkvuLhsH5BMw/hZElD5D/2bg+WaQx+Y=;
        b=NZjc+X4A3VG8jGwG/W2PgQjkq4sTzfq7KSSHkdiLKpBQ/Cn9iIA2TvcGl10EViFa6/
         EuDMOIKLdTZNJTy29pygLyuXmoKQfBuj+WXkTuUXaZEzemCcCssm0tz7IH1Qonf0HnDQ
         vRlaMDXKkWSj4F97CLlV6RRr/+nU6iiOJUMX0g2UD+NYgPZLFS9AIYsCYjnxzGPAc4hU
         w3NJs+9mYjvB8/Cf3g3n2xt70vW+oiRxsf7fDXsWzK5v36hqlyZrAv0Z2wmlrC5BcwQv
         PTaIWq3yizcvZAp3tJvTqaM0tGCkX/9KMUeXTx3fYVNzMkq4MzXdlgV2QLqm0WcvCVg+
         3ptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481236; x=1754086036;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PK3OXoVC6Y30TkvuLhsH5BMw/hZElD5D/2bg+WaQx+Y=;
        b=l6PKgP1XPCgXzEk86Xt3JNxZ314xYdwXe8po7R6Wl5F1TgDm1x8luFetL+HrBW+8yi
         FLiWrwwWAHfdP3SJTL/6SZJkDbh7KLZ9cFRzGI//87a17SfR7+5Zb8ItUxrIE9g0fAxp
         4gz1baIfXTfRDbpVZSrbLMhxUvw7k3hlzUO1PhpNb79lRqbvS+VHVutrzY1OCo76ydCy
         uF+gxSSSjw/ojqLkoj5o+2UIhQsILodXPAqKz/NzFoLFuyr6AvHFcNc1no1tsok5HJYS
         x5gnNz/4dkZzWFqyslTzUNO53jOYDow3Hh5fLlh3HJLGVNT+d0SMEAxAu2PJ5S4SoaCR
         1TOA==
X-Gm-Message-State: AOJu0YwOjhRRl9dDb2lzUqd5sT6jrnsh2CUpFGxfLyUC2VNvB2BEp8vd
	/Tgb5wa+KbiMIyOawRUmmeJyTrHz1gnkhhfyH5o1bZ7F96iYUDZPzdmPzd0v8eccebTwCSaMtPA
	g2JdA/w==
X-Google-Smtp-Source: AGHT+IEb/v+QFi37SiPhuxE5/aZyhho+I//HVjXW8/6nMGuMNYtt9bgpJXuWt6SAZ3STbR+sxren7hgzvnk=
X-Received: from pfbdo3.prod.google.com ([2002:a05:6a00:4a03:b0:746:2524:8aab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d21:b0:742:a0cf:7753
 with SMTP id d2e1a72fcca58-763344d1933mr5438581b3a.3.1753481236476; Fri, 25
 Jul 2025 15:07:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

As promised, the storm has arrived :-)

There are a two anomalies this time around, but thankfully only one conflict,
and a trivial one at that (details on that in the MMIO Stale Data pull request).

1. The "no assignment" pull request depends on the IRQs and MMIO Stale Data
   pull requests.  I created the topic branch based on the IRQs branch (minus
   one commit that came in later), and then merged in the MMIO branch to create
   a common base.  All the commits came out as I wanted, but the diff stats
   generated by `git request-pull` are funky, so I doctored them up, a lot.

2. The "SEV cache maintenance" pull request is based on a tag/branch from the
   tip tree.  I don't think you need to do anything special here?  Except
   possibly mention it to Linus if the KVM pull request happens to get sent
   before the associated tip pull request (which seems unlikely given how they
   send a bunch of small pulls).

