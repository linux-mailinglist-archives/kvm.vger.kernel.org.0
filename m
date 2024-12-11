Return-Path: <kvm+bounces-33488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF20D9ED263
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 17:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 095201667AF
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 16:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFEC21DDC22;
	Wed, 11 Dec 2024 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dpt8QJ0r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC0619F131
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733935376; cv=none; b=djGfCL/09k1+srS5fi3yRcjt39NaWQ1R3L/l3z8/AwYHjzcKOpSAKDwZAT6SA8GTpJBwKClCQbMofbm3tEwMkUJ/DPN0T2yr2GI20r0zE10FHovV+iVNj5L4K5tLCjHKUlR+OMJUklHTdMubZqS86wnT+dPjkE7tqJJPAm8jHd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733935376; c=relaxed/simple;
	bh=+IJL5ABy4FXfBSjS+ZC2D7SmHKapNA3892pbPXLw9c0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=p7AaMdP1e1sAz95Dat5pD/ItOLisQ1jkQHr79AvwVcNdT++mKwgYNtOgr8NwZ1A2RpRIwzZMBrdYrXPxWq6/zZq1Y3DiJK3BeFue1Aey8THF1vDYdcJMcGGQRVRMzgqzK+KEBTxdOcTJW5mEPnqEomuDaP2HqYIK1zTIVfH9FP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dpt8QJ0r; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so3594067a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 08:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733935374; x=1734540174; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+IJL5ABy4FXfBSjS+ZC2D7SmHKapNA3892pbPXLw9c0=;
        b=Dpt8QJ0rZtSNfNfpZYIp5f52XkHfKGQHnB4GHiZw3M+dMvWDJn8zMVo7TpXmgp4L8g
         vrDk7v5djdXUZppg3QGBlxYmTdKiFpO++UbYv19WWShdDweE8wlI5xvxEooz4KhI/wYa
         l1K4c3A4xwatbHJaVLmYNkZNYRNzKQb43JcBurktjxXeA9WFpMrLmHV/ubk5IZgd5Xt4
         EdWiCmbV2jdGSwHVNObb7AdzLEd1PDrBSdzmwRw+t19c5YF8vAocFscJUJFjCfw3X1yZ
         NZvDauubjp9FFZTXd8mckiZ+32//axDu+lbcipfS6dRW6tR1iBJLywxAa02He58EBanr
         C/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733935374; x=1734540174;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IJL5ABy4FXfBSjS+ZC2D7SmHKapNA3892pbPXLw9c0=;
        b=w0/5Xv+DYtj6r1v5ED39zVTh5Im/W7A6bEGW/BI+VWdPvA7Z6M9XVHqli15kKPF/xu
         HCTEvCGWHw80OrVHWyzGND75ZkJMlU8QLLV9w1tNTPWjNShqZ/L8yFSlC+PJoa4jOfVs
         SoJxEfNEAnun77gXc9bEWuGyZKB7qnTLvnjSxbd9wKkKMQp+YHxpXH6S3Ho29FncAwC0
         AWchBZqwlYKxD3XQzVclaBu95vBgKkzUdwjezOqEF7TKyMjpLpGKFTa67YJY+ofdiLPi
         W+SLh8lwW53r09zHuuU00RrUxW00P0X7pmozo99jjCMFQJC7YKQZ3zug6BhwsuPJMpuy
         o5Cg==
X-Forwarded-Encrypted: i=1; AJvYcCU3/2XUwhadTQoq1vgZNkYa2L6CqUjt88C5N8QSAIWeBkuweXIJwSKeSr9k7PudQWADocw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI+lcOHI2Opd6SmozdFlsP1b/sbUCJXhxkwHs0iSyZtmMvH8rW
	2oE+h4bWW90mDfJ06PHxMh2HvtYJi9+s+ONKdnBFzTjuseoT+6cIZnxcD94LdEMjtvRn7L53Qg8
	Kng==
X-Google-Smtp-Source: AGHT+IFcLyF450FdGbFytuLxC3VtC4irjOelUzQ+tfSBiTLeGly2Al7QKHOvKwAGWqA/hARZu+PeJih5gHs=
X-Received: from pjbqi13.prod.google.com ([2002:a17:90b:274d:b0:2ef:701e:21c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c48:b0:2ee:d024:e4e2
 with SMTP id 98e67ed59e1d1-2f127f565bbmr5844007a91.7.1733935374078; Wed, 11
 Dec 2024 08:42:54 -0800 (PST)
Date: Wed, 11 Dec 2024 08:42:52 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
Message-ID: <Z1nBDDidygRil1vG@google.com>
Subject: Re: [PATCH 0/5] KVM: x86: Address xstate_required_size() perf regression
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 10, 2024, Sean Christopherson wrote:
> CPUID is a mandatory intercept on both Intel and AMD

Jim pointed out that CPUID is NOT a mandatory intercept on AMD, and so while the
code is correct, the changelogs are not.

