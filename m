Return-Path: <kvm+bounces-64235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2113FC7B6AB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E7343A71BB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55132FD7D5;
	Fri, 21 Nov 2025 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R2aANKyP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0C52FB625
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751410; cv=none; b=FWMepWCvq21HcDzbx+ayV4yVAeMa0OdVd+KGpstl+4/uAC8FPg+RLjwiJRxWiNTEJ1CRuEHmeP+RnVnMNDARqVjqHiwt4N8U8m6U2XJ0pJbllZIPMedLIYiST/I9NjCI5D0jez3Z5MKX9n+xFpyJKy4aKVypfyGWGKfjQS6TA0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751410; c=relaxed/simple;
	bh=vFsersr+KZyRzyZQj7BfyS4uix7mvrAgFue+x7up0s8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bG/IHGMzMG4cFUe8fAc47QDSZDuO8uzpnLNjc9dpdmyZ8qPc3G80Sl07gXWwM1o0CCgX5i//4uBbdg8V6UODyo1VUaBuZDNe2coPqjvNa/cCAHo4Q0xuL+dhPBGg0umZoJ7q8rVXoZiMBn/6a5AEGCUUUw7O2VK5aZ73i0fgFxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R2aANKyP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9208e1976so5200495b3a.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751409; x=1764356209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLhLrehbaRtL8p2Pwik3WRxaVaMyA1WS6mffbYquIug=;
        b=R2aANKyPUDCMqU6iOinXpECzBlHdseE7/u0695piIArjfVWwM9MYP+r60Gg2CkO4oE
         L9Mft4FRahKt79qNiy43eoeW5doikfWF+gBISOqIGEUT3mgi9WJmcxCmBUVxkjrTRQde
         S/jKJiHZuB3l0xZbwg50IpvqWCSaMyVu6rbKXGZ5yQNUpV5aylYSFpK+vumLgODPDNQd
         uF+efivwCWgzsTwHmWkKKKBL6khDrZ72Ts/p1peZuUszL5fFKCEjKh7TwtdjR8TgzdPs
         Fa84IkpoWKtciZnMA5XtwxSx0wU4/431sy1v3m6OuJvz1GPT+UVj7UW+t35PlGjSaooT
         9dEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751409; x=1764356209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLhLrehbaRtL8p2Pwik3WRxaVaMyA1WS6mffbYquIug=;
        b=ExscToD8MqsNolXacX8BTgYtbz8+0/Vl++8QnzZCiUiTov3awTeXlqrNBQ06iHgYGx
         LKvRjJFw7SoeU6JkuEkbf0sCvNLQ0nAHOHmd/RZ/vrZn+2I39vb5YiGS//mx5vrDFak0
         lWI6nMe2uUTHVCQM4P2CLr07gXjYBTCQgGYDLrGHf+rughyqn1PbBNmmkNmebN2GmFzT
         wmj8YoSWb9zaQoOR77DqxO9DkiJpCGB0oiMjiKbePjctI+F8d5aG4KMhvMuS4CrJzEWt
         nQZk+Wden14Avv0GnDAcVDClZP4k5ibEWAelWpdtOhgp7Hl1mYWkxxugRRzSw+Qh8cC7
         FxZw==
X-Forwarded-Encrypted: i=1; AJvYcCVeoaVefIGD+O6T/qMBxkX984mVX8+8wKadF2XpqJfX0j0/WI6Pbu7gSxfMNhFUskaoSGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFpDJgQ2euQ8Mc4CJ5RK7ReeyWsf+gZC0DtLoieoYPbfHh+o8B
	NWlIhZMeJq9GKs5x072A/bofldSca7u6PyEee5p8oaJY0+fAm4Abt2EpmWMntCG0IODi0N+gVYr
	ZRLjZUg==
X-Google-Smtp-Source: AGHT+IGgcjBAF5ydvY7dlX6lE9EpleQpiEn9XJLQ449jNuI5NxHwYeyEq5ofeiH0uPmXXIH42/LyqDX7jcY=
X-Received: from pgbfq6.prod.google.com ([2002:a05:6a02:2986:b0:bd9:a349:94ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a4:b0:35e:8b76:c94a
 with SMTP id adf61e73a8af0-3614ed95c4fmr4214134637.45.1763751408767; Fri, 21
 Nov 2025 10:56:48 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:39 -0800
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375113687.288529.16692886824986000315.b4-ty@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 21 Oct 2025 07:47:13 +0000, Yosry Ahmed wrote:
> There are multiple selftests exercising nested VMX that are not specific
> to VMX (at least not anymore). Extend their coverage to nested SVM.
> 
> This version is significantly different (and longer) than v1 [1], mainly
> due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> mappings instead of extending the existing nested EPT infrastructure. It
> also has a lot more fixups and cleanups.
> 
> [...]

Applied 3-11 to kvm-x86 selftests, thanks!

[03/23] KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
        https://github.com/kvm-x86/linux/commit/0a9eb2afa185
[04/23] KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
        https://github.com/kvm-x86/linux/commit/e6bcdd212238
[05/23] KVM: selftests: Move nested invalid CR3 check to its own test
        https://github.com/kvm-x86/linux/commit/4d256d00e44e
[06/23] KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
        https://github.com/kvm-x86/linux/commit/91423b041d3c
[07/23] KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
        https://github.com/kvm-x86/linux/commit/3c40777f0ed8
[08/23] KVM: selftests: Stop hardcoding PAGE_SIZE in x86 selftests
        https://github.com/kvm-x86/linux/commit/28b2dced8ba4
[09/23] KVM: selftests: Remove the unused argument to prepare_eptp()
        https://github.com/kvm-x86/linux/commit/ff736dba478c
[10/23] KVM: selftests: Stop using __virt_pg_map() directly in tests
        https://github.com/kvm-x86/linux/commit/1de4dc15baa1
[11/23] KVM: selftests: Make sure vm->vpages_mapped is always up-to-date
        https://github.com/kvm-x86/linux/commit/d2e50389ab44

--
https://github.com/kvm-x86/linux/tree/next

