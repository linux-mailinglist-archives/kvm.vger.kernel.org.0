Return-Path: <kvm+bounces-60089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF870BDFFE2
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA812580F6E
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05C3303A37;
	Wed, 15 Oct 2025 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="be5aD5Ke"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCAE3009FA
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551568; cv=none; b=nNHkcBl/fTozqSJvchzXWQSuvM7v9B4cWBfZ5MP1rTSGKINZSSmusrLvfcJ9C03inlQvmBfBK0+t22ITlHpLcOQN4pvTRoDusB/Y1O3Yd1o2bsuE96UZVVXbEaPzcVvkSnE/oLR0YZE65XFoYJW2f5umSI4oIhGaGug78lYS33I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551568; c=relaxed/simple;
	bh=1bryxJOQhO864UsC08x2e4pfQ16czs/w8bPQoDXjSjs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ta9vtcyzYXxVtloF84ttg+Dy7wxosGupDrmNMGDhCOhHzzyiSEXecO76e8oviijgp9NOzqb8JK9hcW4GrraiZPVKFoUY7wNZCgZgB/Vgc/F5chk0jAVW826umK6DhubH3tkljSvsap8rwwT3hLDKsL/9PqTOtOZk2y5LkNKAmFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=be5aD5Ke; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28d1747f23bso114194315ad.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551566; x=1761156366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QOeXfPOI+VxLjQAjtdmu4bcvJNLddQyhHNA73veAbMM=;
        b=be5aD5KeqN0lSOHe35epmbsGlz7X4WYY50IGmLfXKhgG4aj1Qk1EwJLqHPIv2C/5L+
         eR9UzdzhLQIBCGGK4IbPI1HrKoGy7M2rmbFKrfl++9V3/hZUcKL/x7lA6CUCppONCv9E
         HubyVtwd6ZWvoacTbUo/CQjRac0Y6Dy/Nbhy6c6YHa2MqgUbaB5NRLBJI2WIu7qOJD9R
         vHTTET4SPaYbanWAab+pGbboDIsiXluK70YYwc7357BH+Z+A649f21ajFyih4bBbiVMy
         jZPEsEcgih/8rwZKC5hwqVwJsBcuYZzQGSehRi+16rWREdASgzvbDfvw9iEQX2syn3pn
         A2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551566; x=1761156366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QOeXfPOI+VxLjQAjtdmu4bcvJNLddQyhHNA73veAbMM=;
        b=n72JLVXwfhWUp+3om41euQKAB02GnrCTYAX4jOAlUxhJzT3Y3Fnd/s3mFN5THjopzk
         7o1EPNmUSB1bQOU8a2VXCEg1oUUMs378vQm8q2quCPrrTLgKaGGls2An/YmNOYaFZnde
         3rT7CB2MQKU6MjGlJkcEw4P7fRQgOBkAmArpRjD88iC/M/6VkGhO4lZYias3OitXw0uo
         2qEAZ9mb2YA+by/7DBGXMeU6R8LzWV+g4QZ3f21QwtrewWP5NKWEPGSnS1i+0oXnNAq+
         qmia8OOzd61jLR3Udk4iYdcw3SqAqwJU8OosEL7CD64YduEqdjt5lODKS8wxz0/5qPvf
         owQg==
X-Forwarded-Encrypted: i=1; AJvYcCUqrKn4CAcr+4r0N7IzdtdcnTSgGi2NTcJzaQm1SnS4VB/hvlocMYcsOIk5MqcTLpEpYz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGh4vyOeSm6kjmzu0gCukZSa4ftxYDChe05IpwwXCI2ubRzgYc
	idBcAwas1icssE9WkInulTNhGzrQ/80923RnHYJSjDZ0qWsjrgoUm76w20CEd7WHaO9vlP2/yqa
	+viIteQ==
X-Google-Smtp-Source: AGHT+IEpOVmIF0rT/UXzrfG/ESvOYXUtPYXGtAYd1hVrzdqGcp2E9cP1LU6PudKUBZvyIZJcbflHrLgmriY=
X-Received: from plty8.prod.google.com ([2002:a17:902:8648:b0:267:ddd1:bc97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a8e:b0:24b:1625:5fa5
 with SMTP id d9443c01a7336-29027356c0emr348628335ad.11.1760551565985; Wed, 15
 Oct 2025 11:06:05 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:46 -0700
In-Reply-To: <20251012071607.17646-1-shivankg@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251012071607.17646-1-shivankg@amd.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055115910.1528299.15660583671377559341.b4-ty@google.com>
Subject: Re: [PATCH V3 kvm-x86/gmem 1/2] KVM: guest_memfd: move
 kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Shivank Garg <shivankg@amd.com>
Cc: david@redhat.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sun, 12 Oct 2025 07:16:06 +0000, Shivank Garg wrote:
> Move kvm_gmem_get_index() to the top of the file so that it can be used
> in kvm_gmem_prepare_folio() to replace the open-coded calculation.
> 
> No functional change intended.

Applied to kvm-x86 gmem, thanks!

[1/2] KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
      https://github.com/kvm-x86/linux/commit/6cae60a1f507
[2/2] KVM: guest_memfd: remove redundant gmem variable initialization
      https://github.com/kvm-x86/linux/commit/54eb8ea478b1

--
https://github.com/kvm-x86/linux/tree/next

