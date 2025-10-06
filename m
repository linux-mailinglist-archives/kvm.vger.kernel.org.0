Return-Path: <kvm+bounces-59538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADB9BBEF04
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 20:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A38343C171E
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 18:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B97E42DFA28;
	Mon,  6 Oct 2025 18:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zMP98BbM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D917DFE7
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759775194; cv=none; b=pd0AW3MQTm+Szx86L9coTCz+Ai+1Wt2PX/JBweF6cj/L7BeRuEHaSfKWvuuxjljbpwhfO1YH9RCLNOSnY9Aj1Yd6yso/tF/678RigMO946S9BnKFD4N1vgdTktqdc+fCaXaLvJvr7yDO7aDLEkswWS8huyd5aG8M3WXeqDT2TuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759775194; c=relaxed/simple;
	bh=X0sOZMUaWSC2Co+C5hojmaTO19UZxe7xu+zvydubhWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gJOKHPTw1IFdAePMAOqgyGrO/xmHVkIjRyMEkMWBctsY7vDwuHVSErQTWzzHtFpZ4Bg2GFAzolQ1F3SbL8Z+DwoYB9ElrNyxJSWZ9QcssDqPJMMqxZJX0p6/IjBSMSbRPVVtlEXl1EXgTXHgMwp8VhtOyjVz2k6z1uwjdjfJDQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zMP98BbM; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2681623f927so47687295ad.0
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 11:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759775193; x=1760379993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YB1IXvHihFuX04lg6CIXT77vtdHIdA5ayJ1ljk1t0Og=;
        b=zMP98BbMe1abmCBRtvUEypDS7Q4bqC7Idh+wJ+i9UQJ5isoeW/DhNKlnCE0BQ5JzmT
         29ztmyBMeTEURPi9LmobIdx2N1jIcLF832g+1KhGhAeujdFZQwWwrPxOANqn5mdouuVZ
         xBx1G/ORJ00r9w352xtI2Nl5o9dXTy+XbSMHsDVO+tysQfR5bvYlZUYxdbp0/QfM3wpY
         pMZLbhtESQYWfzBPAjhGzKLXyTCXUF95d1OQcB4/z1Dbf0ZNeN1hd/jqxC8hF2wW7nvP
         B1J5CfNOGxOqx8AAosuUwfeHZcaR4zMN6dd4qrr+GHjnGvOv5c8YKK+aooBuoKUtH0qi
         ew3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759775193; x=1760379993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YB1IXvHihFuX04lg6CIXT77vtdHIdA5ayJ1ljk1t0Og=;
        b=IiZteqU6pOHkTBCcuqLnAd8tk+zhO0dGKbCPIZv80oKKbeH4QXHM+hX7CSgIIuJD4y
         Q/57sbZYFubWX60QSza7VgEbBQF5JVoPrSXebxTknOCeejIO+wdXep0+pF05qSIeYRiI
         ZNvy/PULZ/jH70fkD/6EkrHCti6oNKJYO9qPXCMIPrQNtPNPJWge4Xh6Uod1mtHYeJQr
         sTWqmMEr0JZYuu6Wv8/89Ty34J6yVbUFhwuQpGjSk5O9nUpOyFHjYMWRNqVx4Ia1QJCg
         cd6eqwjioAu6ptgS1fwr21INcQ6/u1p167Z+UAluoMLmlPuCkM07ycXC/B24it6+Rdu1
         ATbQ==
X-Gm-Message-State: AOJu0YykHqkRO3qJ2N1nsnPs4a00FqF6Y6eo75xHPLtxGZfuebkNmTX4
	uRgYNM5erW5N0ZUXd7XPHLVyO/OxvMOegtVeJhZl40Ae2MMbN37IoI7tcxpSb1vKh8+EeQ/nvlL
	nI8JfxAmFEox+XH/iZJwXh/SbiA==
X-Google-Smtp-Source: AGHT+IHElpwNO9rtmCU4B3pLi9Ye3Sml+4MFucjmj9yz1EOyW7YL1umfBBHW7wJ3NF91C2V84fTYHWw9sbHl+kVqog==
X-Received: from plsh6.prod.google.com ([2002:a17:902:b946:b0:269:ab8c:6531])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:c94f:b0:269:9a71:dc4a with SMTP id d9443c01a7336-28e9a648547mr152043045ad.41.1759775192854;
 Mon, 06 Oct 2025 11:26:32 -0700 (PDT)
Date: Mon, 06 Oct 2025 11:26:31 -0700
In-Reply-To: <20251003232606.4070510-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-13-seanjc@google.com>
Message-ID: <diqz347vga3s.fsf@google.com>
Subject: Re: [PATCH v2 12/13] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add a guest_memfd testcase to verify that faulting in private memory gets
> a SIGBUS.  For now, test only the case where memory is private by default
> since KVM doesn't yet support in-place conversion.
>
> Deliberately run the CoW test with and without INIT_SHARED set as KVM
> should disallow MAP_PRIVATE regardless of whether the memory itself is
> private from a CoCo perspective.
>
> Cc: Ackerley Tng <ackerleytng@google.com>

Thanks Sean!

Tested-by: Ackerley Tng <ackerleytng@google.com>

> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 26 +++++++++++++++----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> 
> [...snip...]
> 

