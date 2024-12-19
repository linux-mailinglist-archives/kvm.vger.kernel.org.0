Return-Path: <kvm+bounces-34106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B93C9F72DD
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FD5D168455
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B992E19E7F8;
	Thu, 19 Dec 2024 02:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LePb9dWG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612E19D8AC
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576171; cv=none; b=FBYDGdfI9CE8RAcHYVo4CriO9MSYlCV5/RKmiv/heLV7qhLJ5vmiDxpLVl1m00HQoCV9Yydp/0HiA90LBlpPLK589xxv+QJQz30aq2BAWhKYn2DgXwNjzzJwta7vqG1c2xXoL7lMbi9Gg4j3MjDby+MInGTwGVQ0eVIh9M9IAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576171; c=relaxed/simple;
	bh=LxXbH5f3h4PRJiVUHsxPzQgteJf+DMDYOHShv1+JTb8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GNb4idhCZaebtaixWH707EJeDOHE8NpQaAK4Y78JOhkZx0QZUHnJqEiqZDHKxREf6pjfkD3aW/3A1NSy+Cr4MJDj8ykF+TZQNA7PwERHthocJayEyDTO8NQb4Pgg271NTjnbBZMHGmoYrOr+cfXIdyoeRMYLjDCt70JMzwzmvJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LePb9dWG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216387ddda8so3100345ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576169; x=1735180969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIYGiv5DaA/0XRyx3nZgU80HwBa/oLiccayQGifN5RA=;
        b=LePb9dWGWmBITN79Em3/+rio2Akka0Rr3rax8OQY2oQZijj2Rew7Zej4N70liFQF0u
         l7fq618PfJj7xxG1QRBJEaT+ir+gh6fkGGw3h7Ut+wKcEzZGjqr/QitdOXwAq/E2JzXI
         +JWeRci3jd40z5Ucu1fR07PeDF6w+tw16m+VegPRUQPfxHaxae5kwxOJW2EafaSBf2fc
         ZeGoM/Tr2OzQtfJ/ItfNc0DArSek3WF0yXeGiv2OrTvb0sO+dQv+XEhr9YolxwUbwU+4
         fxL5ig9BZH5XnYrG4kp4C8e1UciuuCH4pgNFtynn6uMvUSkyowW4zjDClKiZ8jahVKPV
         sN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576169; x=1735180969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QIYGiv5DaA/0XRyx3nZgU80HwBa/oLiccayQGifN5RA=;
        b=ffNNz57WDZdv21Oiq51H4SFJjzXYvLeHR2ftGvBI4eZDuw3eJFPLQxN7enfXJA7msU
         PfkO9t9MBgj+l7O4ewX0RDiVw8b1WODgzHtVLAv4QbmN3A/7A4iUROqWRY21g88dznzp
         xZr2n2CxLjP/0L3QrvQKkFb4qcZF8IL2JpdKp1YxW1Z4TxMoGgWY1o5WdiOcN/1rknNR
         pt1fHK5VCScJex9fj2iND4unTXGEbSOKmDHuDxzrkJ5YdLaxsDDxI7HiRbBrF2U4q44i
         KU+cJuaISoWPzs6iR9Lgj4M5W0bgLr/FksWOvFS2aY1ydr10y0cTbSpA3pyBSTgJzq+p
         2hMw==
X-Gm-Message-State: AOJu0YwFFAmCf2eQ2rFl+oD9Rx8DJZoQWGSsGdzeRlFAEqn7d+n4hhkZ
	LV/vpb/dnoYVx0u+9rMZ2ebUo4ex1rhZmTu7dci6NRfAMjSLDWPObxqCaBW63k6lCGXkWVfhPDU
	d+A==
X-Google-Smtp-Source: AGHT+IF+mwNeoNKaVpmXAqA3BPkjzHttO8B0iBTkIkT3jkgvEUbIMU3sV1dg9hKlskxDl893AiSkk4l/YLw=
X-Received: from pjbta6.prod.google.com ([2002:a17:90b:4ec6:b0:2ef:95f4:4619])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c4:b0:2ee:5bc9:75b5
 with SMTP id 98e67ed59e1d1-2f2e91c2df0mr7443398a91.4.1734576169016; Wed, 18
 Dec 2024 18:42:49 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:56 -0800
In-Reply-To: <20241127235312.4048445-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127235312.4048445-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457546228.3295022.11879746560606212523.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Remove redundant TLB flush on guest CR4.PGE change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Nov 2024 15:53:12 -0800, Sean Christopherson wrote:
> Drop SVM's direct TLB flush when CR4.PGE is toggled and NPT is enabled, as
> KVM already guarantees TLBs are flushed appropriately.
> 
> For the call from cr_trap(), kvm_post_set_cr4() requests TLB_FLUSH_GUEST
> (which is a superset of TLB_FLUSH_CURRENT) when CR4.PGE is toggled,
> regardless of whether or not KVM is using TDP.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Remove redundant TLB flush on guest CR4.PGE change
      https://github.com/kvm-x86/linux/commit/036e78a942b4

--
https://github.com/kvm-x86/linux/tree/next

