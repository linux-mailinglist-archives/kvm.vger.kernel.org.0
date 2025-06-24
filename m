Return-Path: <kvm+bounces-50540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0456DAE6FD2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2493817B8AD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021C82E88AE;
	Tue, 24 Jun 2025 19:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iLhfIo/l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE86629A9C3
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750793931; cv=none; b=Zqpe2tsH1EApsODU/RKR0VkPmkagTC8s/wvyxTxY5iV2BeGzk6GiNHyYN+ERSwkRlARwrxn81MqIkyALHOAGGYTqryS1RKvavHuvRWwCvxNZ8W1UvCAIy7Eht3F2N1TT6cZrScoeWK0LxbEyCfn//pLd9tUbKwUIBfaGvNVnXZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750793931; c=relaxed/simple;
	bh=XbP//jD/tK4JeJDluoh2Rv7JMyutjDChfHqYPbay6KE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YxdXIQx7BUbUnbwsGa4SV/wwUp/saZ7NQuId101xABjol/Ov8dpDyEDZZtjDdPc19Uqyig2uyl43z2iNmo+vJEbfxwPI/FS/jby2SN1EOWKHShu3LhnXWGbO1f1oBTi7HwLUMTwgJZhO75Az5zVYuMoTGTzJbTfhOVoqhFtbeOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iLhfIo/l; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115fb801bcso994124a12.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750793927; x=1751398727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KiSQctGpgu05ltgD74EvROeYrI7fKmX8SK3XsjWu9Y8=;
        b=iLhfIo/ljt5V2SUKvdCdfP8IbB9Utf2xlA/M+0sJJRW/z8Gl3rFpisQf6/o9/SDPE6
         sqY6c0hYYO42HjllB8A/JCk1f7dOor5chBEnk/TL66iTmJkD4KkkrPous0BQlIC2sWX8
         GDEO88PeyvZM7S3hiuwDQ7Jp+69XqmUa6ce2BGps1TWhiMm597m6hN+sZnEeErwpDdxu
         E3eld2ltDU5a3ZUJu3Ia7pza1ZXtncGpDxmd1wOEYyJyDBEAisPB3AEfD9j43zQ2Vuaz
         cl9M04hoHopR9qWY+uhbOCPIjn5jADawoGjNzKDiY28A39jWI0DWG3Jsl/b7MlpSUhk3
         bDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750793927; x=1751398727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KiSQctGpgu05ltgD74EvROeYrI7fKmX8SK3XsjWu9Y8=;
        b=dUhXgrWBl6ShaG5dCO3SFll7YDb+YxJrj1fdq86jSTKnuQRWk2pMnFVdVndyNL8kau
         MnYL8/UOOP4Y3B94Zd7vBpVYInhiJ22rGxzOU52TZXfBDKT+dl52PfU/utx4h91vrejs
         SVjKIzrHzuJL4qW6OMYOTR/6DyXHxH/FW507U2Hg2ppjyuNABiUVnwCuVWMkYb1yXysL
         LfCQS34PhPOMJZ8TqhmoCGM35Y6hh4OWxNIqnngzb5Oh+XBrJyLD0S238B/7S53wrSXo
         jjy8rSx+MBjH6DcXBubDZpv8ZXqmjEwFqkeFZSAmXOl9la0k5Dr/ngbX/XXqkE3lI2a7
         2NiA==
X-Forwarded-Encrypted: i=1; AJvYcCUgs8n+DGd6l2mZVZM86TVr51ZhKsf5Nnw3H7WQ/SzjVJ0SiaaBjENFlzHUB00WPQbDmCU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5HJNcPrE/AFuZIyTy2APlY1oiaIjbBH2YPa8fyN8Qs81axptJ
	jBLp5PkMeTxZYb+oaUVZ1m0/r85eozFG/HADUxg33/dHBTatv0Ra2TMa7m6vqGoK1g6euDyDjHP
	s62gJnw==
X-Google-Smtp-Source: AGHT+IFvLoRineByrtkXpx8W2INpckk4B00tWPHC2RXq4u8h/utilw6VW0msAMNx/qrytgz/7U/tpn4IcFo=
X-Received: from pffk22.prod.google.com ([2002:aa7:88d6:0:b0:748:34d:6d4f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4325:b0:21f:4631:811c
 with SMTP id adf61e73a8af0-2207f25de31mr285848637.19.1750793926883; Tue, 24
 Jun 2025 12:38:46 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:18 -0700
In-Reply-To: <20250609091121.2497429-1-liam.merwick@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250609091121.2497429-1-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079184957.513348.16096363492105624253.b4-ty@google.com>
Subject: Re: [PATCH v2 0/3] SEV-SNP fix for cpu soft lockup on 1TB+ guests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Liam Merwick <liam.merwick@oracle.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	tabba@google.com, ackerleytng@google.com
Content-Type: text/plain; charset="utf-8"

On Mon, 09 Jun 2025 09:11:18 +0000, Liam Merwick wrote:
> When creating SEV-SNP guests with a large amount of memory (940GB or greater)
> the host experiences a soft cpu lockup while setting the per-page memory
> attributes on the whole range of memory in the guest.
> 
> The underlying issue is that the implementation of setting the
> memory attributes using an Xarray implementation is a time-consuming
> operation (e.g. a 1.9TB guest takes over 30 seconds to set the attributes)
> 
> [...]

Applied patch 1 to kvm-x86 fixes, and the others to 'kvm-x86 generic'.  Thanks!

[1/3] KVM: Allow CPU to reschedule while setting per-page memory attributes
      https://github.com/kvm-x86/linux/commit/47bb584237cc
[2/3] KVM: Add trace_kvm_vm_set_mem_attributes()
      https://github.com/kvm-x86/linux/commit/741e595f02fe
[3/3] KVM: fix typo in kvm_vm_set_mem_attributes() comment
      https://github.com/kvm-x86/linux/commit/aa006b2e5159

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

