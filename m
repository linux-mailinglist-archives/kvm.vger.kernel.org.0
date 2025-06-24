Return-Path: <kvm+bounces-50552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A23AE6FFC
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B323C17BD43
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F492EA142;
	Tue, 24 Jun 2025 19:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uCHsAVsO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB252EA47E
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794145; cv=none; b=SAKyRVNVgj2fj6qCLjRDsznnlqqtzrZQy1yMoPfWWw4rNEJRfsAC1yzLxT+KU04ZCyS+g6tc5fobp58ZAkRiaxK8vBnuIpmdlA7XFLCozwP4pHgDHZKAFj/N2aY/x3FknKeNTUOxkPnd7WUrcBin/Ov/iXzTeOvDhe+Nxo4S4jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794145; c=relaxed/simple;
	bh=v88psYhC4Xlq9eWyn2S4RG8kNy1savvZGH23Z4vHn5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s8RJ/NkqEqFPAqEZHYp7jI7o451IXCoyg2U4mLaT0ajbzdJrKNu6hsrTFe0UFEo73635H8MY4ixrzmOIcLpcN0WBz834YSrNuGs4RT0FjAvem1zNHqRjLViYZ7cqQYY8Hjde9gEcMKEp1pKba/wiNvekPUlr3la/gHxnEfy1nE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uCHsAVsO; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7391d68617cso81027b3a.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794143; x=1751398943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yjMaO2ZHYgUWaqMqKniOnU+Hc55RnjP49wr+GC9QMd4=;
        b=uCHsAVsOM1wOILxseG7C/SppSc4l2yommCexZis0OeYo5W2Eo6JYrSeWIP7NwU6yBy
         lF77+ye6JMlhOWB+YpE09NHMVVioR4BbZJOfDz30ivI3HAin9P9UtXsFmjCphSymb3Tu
         NCMoyirkwxI4xl0vxeG+fYIKFsgbsM9Hmj6qxNHKE2Bm1blBiEJEyDD1PrpHPpVwpc0C
         2SDr8h77bBtuUQ97mTdwoQyHG+TUgCjHgGMdK94BYBeqHdF9qG6RVKPNosglDqyvtIVv
         DN+x2WK4CTYGF7Fx33sdZBn9Q6YUJIRbZCc8pOPVoKPsZUvLpN60rrKJBuwTO7FeW7dk
         3d6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794143; x=1751398943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yjMaO2ZHYgUWaqMqKniOnU+Hc55RnjP49wr+GC9QMd4=;
        b=ooo1nlW8UlX1I1REpFTcSgm6mknWTkLzXyPBdOOLpO0/OWnJUI575hW+k5bmzetmqE
         qPAaoUdgC81U643+igIq65f47MQModAINA02IRG98/+ys/TpZ/j4p7XmRXXKEyrYGh7i
         V9Vx4h6tcPPbv+EvBhUHQEMeOGeKJnfQdrkvpF2eOgWvhRfG1fRt18StzBrKqDldIIIO
         XVgiCvkDu6gahYrp26UCtqemmqIHZQZIX875Q/8LvunODB2WB+I8OWEtV8fInevMcN0h
         vkrSrT0SukLUcQsroQScZqSIrwfdqBjAZuSW5dYWkFyQwGoxdzsqiXvOzS8oXBJbO6JZ
         7/fA==
X-Gm-Message-State: AOJu0Ywsdy/8wDSJcqXJWVIBTSUob6W64emJaTqQ4keG6BL0r42iZeLR
	lGjRgwc2gMRAWj9yeAxRRMDlJu/TZfYDkDEfptj5r7GI71XNAaObATBAhYjDgIPUKDdSQD4hrD1
	mZTEIWw==
X-Google-Smtp-Source: AGHT+IELqzwrkH6ayekw/v07G4muYW0xcxjhWHO/BVt/+UPZ1juGa+hX/I4JPrYPJvEz9xpMX5yGSYKDGc0=
X-Received: from pgbcp4.prod.google.com ([2002:a05:6a02:4004:b0:b2f:9bf7:7145])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:438e:b0:21a:de8e:5c53
 with SMTP id adf61e73a8af0-2207f3067e5mr300077637.12.1750794143030; Tue, 24
 Jun 2025 12:42:23 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:43 -0700
In-Reply-To: <20250516215909.2551628-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215909.2551628-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079223259.515104.13388521699200936285.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: selftests: Improve error handling when opening files
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 16 May 2025 14:59:05 -0700, Sean Christopherson wrote:
> Improve selftests' error reporting when opening a file fails, e.g. so that
> failure to access a module param spits out a message about KVM not being
> loaded, instead of a cryptic message about a param not being supported.
> 
> Sean Christopherson (4):
>   KVM: selftests: Verify KVM is loaded when getting a KVM module param
>   KVM: selftests: Add __open_path_or_exit() variant to provide extra
>     help info
>   KVM: selftests: Play nice with EACCES errors in open_path_or_exit()
>   KVM: selftests: Print a more helpful message for EACCESS in access
>     tracking test
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/4] KVM: selftests: Verify KVM is loaded when getting a KVM module param
      https://github.com/kvm-x86/linux/commit/fcab107abe1a
[2/4] KVM: selftests: Add __open_path_or_exit() variant to provide extra help info
      https://github.com/kvm-x86/linux/commit/6e1cce7cda1b
[3/4] KVM: selftests: Play nice with EACCES errors in open_path_or_exit()
      https://github.com/kvm-x86/linux/commit/ba300a728f6f
[4/4] KVM: selftests: Print a more helpful message for EACCESS in access tracking test
      https://github.com/kvm-x86/linux/commit/71443210e26d

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

