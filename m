Return-Path: <kvm+bounces-13947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2A889D024
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E0DBB2154E
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A99C4EB3C;
	Tue,  9 Apr 2024 02:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="js+/vL6f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B884E1BE
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628098; cv=none; b=Dqu+AIqjyJoGP/g7ZZwT8HNOTvdjhrd0e/VmsvooqH8NWu/QgPDcwMoXWp/6YI7f5FnUGdR56V9peTyotAGcGOSC/FsSPGufFtzpHRwdg05QCL355S0hpSx87v6gLSLYDzIq/gqEzUj2oc6ZcC8SmkrtDllqb/oHCIzwLZSluLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628098; c=relaxed/simple;
	bh=sm/kJHlwnGkxq+r3r+WnQ4vu7gf2HJ259P+aphQyMUM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OJb+c4GKOH8tIeZM7RAoI8UL6wAND7mUR4f15A0JOS3se5pmzXlpo1SUWwFV6CM8+qsBjUX9cWqr1p08JNAZ0XQyXxrOVPnSWQaB4sumnPmajvKpV0sinOO/FyVGWpAdNpOxEN8ozKCXDmPXCqQFepRKZ+7s9BMxF93Z0qKyDFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=js+/vL6f; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed613bb4d1so712920b3a.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628096; x=1713232896; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSUZDkTRN8Lf9eVIN9/jjFC+upw3wKsPHOurrDIqp1Y=;
        b=js+/vL6fmf+wlZL4Bfxq+VxSWwYSUeQCdiTrgNFNV0rG5tptzKbFAudqE3ktfg/rOT
         cjuQdtk3e2g/BLAZrZTThTq72OgQVgsyJw2tnp6B8+koEpypDHx6Kqk2oYgAwHPmDDPe
         8Q5W0dUWEJAK+IL/xuwWglIsOfQbf5I+WEHQbwebELsqqoioMuQ31JUaJEvsk0qaok+Y
         N9vbxGJR8IvcF6WdCNQZO0i0T/PKIcnM+NBrGJ/rW8v0t8JcRbd7uWEOtEbyL64OzqOz
         nUHw3F8jaP6DjJHIaRjpxZIkzPi4ldLhDkR90OG4KvAD42WL1TZG51x2AtCxqgTaO7eq
         PUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628096; x=1713232896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSUZDkTRN8Lf9eVIN9/jjFC+upw3wKsPHOurrDIqp1Y=;
        b=aC3OsvbxkhyAkkH3/awZl6MPH2K1kKRIs0FFJkGuw/3bMFlMNOJh1TW9hb+F+aaNiU
         LKvwXe7ZNbwqsuw5He/mIA1ao6r8P10dCGXUvJpy/zG84O7ok5uVAYm4DgmVt8d4mq6H
         YXdM/smVvQcavIXkkEgYD3Z6Y08XuNbX9qeFmuJRA2t4GHw7aEpFpMZDqr0OR+dxGRWV
         wzip5jINbrrE5CVBJ440LB0dOxgYgvGWmFNaBfyB83Fbk2rYfPqR813iIM8sJmLsBNL/
         n8C0mKSbjkZvdMhRBBzT9ISWAkr7I7ZEPICQNm4dYJM06ogJNfGAbEpEYPseGX40qn9r
         7kqg==
X-Forwarded-Encrypted: i=1; AJvYcCUl+74a22d3T/tSGr+2G9eMdEiGEEoyORwQceq+6PsIBzrl6DkKW0VnsDa7n/HXm+Z1kxN+BzOc69uMBJyoyEMewajM
X-Gm-Message-State: AOJu0YzIZTIZIOx8lJ/DujT+EuppQyakyNVvoPAe0Ax3BaCYPXZMqPua
	oaucpH//e2o6Kh5zJ6K49jXuYbHpbII2mqTm6WSHqonc0ylCxt8EONAvAHKSNL9kViFWgkoc/rH
	huw==
X-Google-Smtp-Source: AGHT+IE6nR2DC5wdy64yV/43loYGn3aGmMN2LEIwaDNnYU0U8x24E0N5tzdwMWkKyO5QuQqHxkxQHk1i5Vg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:92a6:b0:6ea:b073:bb60 with SMTP id
 jw38-20020a056a0092a600b006eab073bb60mr1084247pfb.5.1712628095580; Mon, 08
 Apr 2024 19:01:35 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:23 -0700
In-Reply-To: <20240315143507.102629-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315143507.102629-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262713897.1419961.5139969748119275014.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: fix max_guest_memory_test with more that
 256 vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Fri, 15 Mar 2024 10:35:07 -0400, Maxim Levitsky wrote:
> max_guest_memory_test uses ucalls to sync with the host, but
> it also resets the guest RIP back to its initial value in between
> tests stages.
> 
> This makes the guest never reach the code which frees the ucall struct
> and since a fixed pool of 512 ucall structs is used, the test starts
> to fail when more that 256 vCPUs are used.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: selftests: fix max_guest_memory_test with more that 256 vCPUs
      https://github.com/kvm-x86/linux/commit/0ef2dd1f4144

--
https://github.com/kvm-x86/linux/tree/next

