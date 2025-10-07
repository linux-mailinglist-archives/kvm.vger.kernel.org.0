Return-Path: <kvm+bounces-59592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59EDABC2525
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 20:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13A013C4741
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 18:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6C22571BD;
	Tue,  7 Oct 2025 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4WjB5Zx3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504F221255B
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759860407; cv=none; b=ib4Z7ZzcnPFfd/U0P6/b0cap3Ic5YRapqUawlZMtc6yoX+O2NDmrchSvQ6rFuE4kICQxb7nqXE2CDbbdZ6BVhAgUN2HttmsXBhBs6XFv3PLUuDzff7tNywjEDQaMySIoF/+lC1UTO9J4ZUe/nEC6NC5dp/Pvby2yiDaEmHkqEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759860407; c=relaxed/simple;
	bh=q6J61bs7L3ujukcqpOfn3PO8VFKDKO+odJmf7OZwqE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DGE4dtzonfPrzwpHL8IznacnMTISs0sef+d8Zltyz2RTQkDXluGflUaO+6bomsBitmfEe5SypSkGA0QdealV5oGkCnxk5uUaRV9w5GrRfVjg9zD0pd+sJXf93AuJ70ezf3cd722JAPfoDyV8yMdOoJL9GFozrzatSpM1dESLFwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wyihan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4WjB5Zx3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wyihan.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7821487d16bso11706996b3a.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 11:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759860404; x=1760465204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jy9uoa9n7CiOeOtHRkWJVJ718GS54wk/TvFhgvjRAGk=;
        b=4WjB5Zx3PWSn2EIrhSL5yvD4QblGhEl3eUBlngvYpz8eOaY/SU1SNEIN1hw5bUrlmQ
         rNqjnHz5YhQm0mZpXIZmTp3Av3Zb5Rfygjt4aQqCsgLz/QYNLuCVkwRyxD6CDcIuL+Yc
         2iEN0BauroDWgcUe0ScyEFVwaTyDgvoqa3XTsDsmG3/2WYkxAhpb3vpG77sru8uQBwb1
         c+avHlkhaON8oQ3JhJROrKeUzeWnYsC/qCze5wSguIjQofTze2TYZXzvOVsBqve1VBx8
         KE/+8UGQ9f1k3zEvYaoNbTQa1JWMbkoGtnU8BzxkmNv8THAMsQ1pFNoud1PX3wvDIgQS
         q06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759860404; x=1760465204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jy9uoa9n7CiOeOtHRkWJVJ718GS54wk/TvFhgvjRAGk=;
        b=fNd7EZtZ4Bn0a/myVJu6BvQM/Ukjo5XNvWtqwVG2DxRVvhAg/ZUsDcDa12X0grbrsF
         J5AeDTZhmnbKCwS4lIJBYJZrGEHQUyEfi0jPKhqM6jGKGzf/f1ZdfmbXmKwM/XaGs9oo
         jK4IeOAvuBBPGkqUVtJpGpZ1BBKwiGL1CKr6ewtjds1i4TyBCvBvJdvtk5YzfEa60nM3
         5MasT4i0AXKwO0uYsl3dPGmJj7BLz6uEBLrTNA0wh4kNVcza7fdyREeknmIqzjpUP7Id
         NZ3R+qCDVW5v5rRRcpS1v/tOp7W4eKObECLwCozfXG1m9MY+c4ooYNM3pjE3xM2WIM0O
         xg0g==
X-Forwarded-Encrypted: i=1; AJvYcCVa2xub8YFWehMmPhoZ0gHOf7+LJ4KOWDq0/eBpDSsuAVIgr14KZTmrodwiVRETiPuWmJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZM8w4bzHj8U+/cEgC50TYg3ecFE8KFyIXr3PMyqilG4Taces/
	4GSSMyZjrFC8PRkRiCVczKtSZePT2hPL2y53T2ISj+EESaI6B8IT5yaJ5gz+YaBXg4EVd2d3Htl
	6FN/6uQ==
X-Google-Smtp-Source: AGHT+IFM0FyD52n4COlTUfeE1w0IfmK3uQQePrMvE9YP1sa7uKjBgBKdHuInhyl0TsFz1oW0BpvBogVlPbg=
X-Received: from pfms2.prod.google.com ([2002:aa7:8282:0:b0:781:1d87:4584])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:891:b0:77e:cac4:446e
 with SMTP id d2e1a72fcca58-79387e0539cmr513966b3a.31.1759860404519; Tue, 07
 Oct 2025 11:06:44 -0700 (PDT)
Date: Tue,  7 Oct 2025 18:06:06 +0000
In-Reply-To: <20251003232606.4070510-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-14-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007180606.940219-1-wyihan@google.com>
Subject: Re: [PATCH v2 13/13] KVM: selftests: Verify that reads to
 inaccessible guest_memfd VMAs SIGBUS
From: Lisa Wang <wyihan@google.com>
To: seanjc@google.com
Cc: ackerleytng@google.com, borntraeger@linux.ibm.com, david@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, tabba@google.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Expand the guest_memfd negative testcases for overflow and MAP_PRIVATE to
> verify that reads to inaccessible memory also get a SIGBUS.
>
> Opportunistically fix the write path to use the "val" instead of hardcoding
> the literal value a second time, and to use TEST_FAIL(...) instead of
> TEST_ASSERT(false, ...).
>

Reviewed-by: Lisa Wang <wyihan@google.com>
Tested-by: Lisa Wang <wyihan@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/guest_memfd_test.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index f5372fdf096d..e7d9aeb418d3 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -84,6 +84,7 @@ static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
>  	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
>  
>  	TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
> +	TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[accessible_size]));
>  
>  	for (i = 0; i < accessible_size; i++)
>  		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> -- 
> 2.51.0.618.g983fd99d29-goog

