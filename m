Return-Path: <kvm+bounces-16562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E81A08BBB01
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 13:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25AD41C20F53
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 11:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF246208A4;
	Sat,  4 May 2024 11:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7fCeg1+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8A74C9D
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714823919; cv=none; b=jUPw3fZp21qOIcWGWqsz+dUDqeEsx3NAqw422D2A3ZWB3rq6Eu7qp+Jfhxhs+7EA1ZxoqfR0dFVhkAv4B04a++nwIXXOI120Ymadcascw8Wp4iIso6QhcVzU9Isl9GiakC1RH6Bs0mYV07PJcxxpfKU8ksTbGOTn3jW91T0W+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714823919; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vyxn27Xc4F0/NzR5Q+IWcuGkgq2xPzXPLsEdawCQjtpZdzQ0S3DQBwEuBhG5Y8kuP7Ac42dao/8B2wjAiobHoE6uXEiL0ytaCti5ihZcEvIB7OpgYPtY2OMq5kfCS9Vm/HQMKMt2KSD9OFyO3FwBvadFaQStVPslHWGL+iOfo1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7fCeg1+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714823917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=A7fCeg1+Ek40M3BJsieCA9BHKyNmGasglFjwCSmTLoo4VS68gBze2V4r9hUk3cRQioLXLO
	SkPYJ1b08SxryzvM8vpt/igns/klCWccbqNuUc0EfW1VMZrovH6alLedCigVRzyg+eV0HG
	UywyEuD7nmiVXqvw/tloTPEldmg9mTc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-KNaYEzDTMR6rgYckyGnDLQ-1; Sat, 04 May 2024 07:58:35 -0400
X-MC-Unique: KNaYEzDTMR6rgYckyGnDLQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a597c1ce52dso26820466b.1
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 04:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714823914; x=1715428714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=kCaFCfp7mgXBaoNI7fBlJMMg+ynffDgNK7I7YPSLeKYCiDWZZpOLZKjYdJedkoxjOR
         865j3776Cwh+M7/2+df1vkgTurry9jjmLfsN2jQHnL5YCix/nFEx2B97jdzzD4U+OBcq
         Nfh8aGo/zlpfqH1vgPcJz1ENOii3D4gqyF/qO8YfM692KutwxjQkWK4eGzCPMgfa+9Xb
         UChDtlZ1SDe5cc10DnGWQJknBQBKXXju8AYO5MDyBJiqiWL+iU+gBPWDO0K6lIxJmK6I
         5oNkc4J3t3aSqM9RGpuBVXtIAzvA0muVqPqkYSWRRJQapB553RgLgaKjEWA451eMLS/z
         lKVg==
X-Forwarded-Encrypted: i=1; AJvYcCU+dsf8HgFxmqzPW8h3gyb4jjEcSBj83ijjqkvFhbxEysxZtf7kL3Fn8oOCeFtSOvmvlGncjeHzi8OG1bmtaqc9u9SY
X-Gm-Message-State: AOJu0YwtDnvqOFX8GeeyjDJcI2Huyqc4AIUVWya4XuCqRJWLJa62CQGY
	O3JlO0O9J0VAOxvGW8xX0pOWp7UGzoqDDt2rx1/ttcgDYOxT/BXTQyU+V9l/5PTvR7tHXn774+I
	fXGlLwP4Pgzeog5Tbzj13nm/Serc8EG8/WS3skKLmW8hioV4RlA==
X-Received: by 2002:a17:906:b798:b0:a59:a221:e2d4 with SMTP id dt24-20020a170906b79800b00a59a221e2d4mr1220951ejb.8.1714823914275;
        Sat, 04 May 2024 04:58:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHivvYPve3H8clYR5gbenwCsFp6g++Cb1wD6BiFPnCfzvgcvVOgLA5NWdqm9kKtGlzhIjFGmw==
X-Received: by 2002:a17:906:b798:b0:a59:a221:e2d4 with SMTP id dt24-20020a170906b79800b00a59a221e2d4mr1220933ejb.8.1714823913871;
        Sat, 04 May 2024 04:58:33 -0700 (PDT)
Received: from avogadro.local ([151.95.155.52])
        by smtp.gmail.com with ESMTPSA id jt21-20020a170906ca1500b00a526e6f5cbdsm2850731ejb.47.2024.05.04.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 04:58:33 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com,
	richard.henderson@linaro.org,
	weijiang.yang@intel.com,
	philmd@linaro.org,
	dwmw@amazon.co.uk,
	paul@xen.org,
	joao.m.martins@oracle.com,
	qemu-devel@nongnu.org,
	mtosatti@redhat.com,
	kvm@vger.kernel.org,
	mst@redhat.com,
	marcel.apfelbaum@gmail.com,
	yang.zhong@intel.com,
	jing2.liu@intel.com,
	vkuznets@redhat.com,
	michael.roth@amd.com,
	wei.huang2@amd.com,
	berrange@redhat.com,
	bdas@redhat.com,
	eduardo@habkost.net
Subject: Re: [PATCH v3] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Date: Sat,  4 May 2024 13:58:31 +0200
Message-ID: <20240504115831.290599-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <0ee4b0a8293188a53970a2b0e4f4ef713425055e.1714757834.git.babu.moger@amd.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.

Paolo


