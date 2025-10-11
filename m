Return-Path: <kvm+bounces-59799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE08BCF0BC
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 09:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89EB6189E806
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 07:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2EF22156F;
	Sat, 11 Oct 2025 07:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7hBjeYA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD373D6F
	for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 07:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760166287; cv=none; b=tN8ThlXb1fJ5RlzKSdNhEAk4gABl+7lSFxRFIZGEXX3YWShQdz6Hlrx52jLqmCGQOWuXa34Rpu1IMKDd5oAXvi3IFvgtJAj7TMWPY9G0pO/a5+dKEz7zoOmwRF56WBu512M2gtAYpK2BwmTFFZme+83GFF3JDUvaz7rynqqiNaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760166287; c=relaxed/simple;
	bh=RhiHGKFAh8Z6wgLniyL4CLx+giSyiW0RLL65qJ0l6dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XL5yzipI/XB2WjchY5lZ2NfRVXPFAyfa6m3exkP0WaVhALDwIUCU94tei/ZKuRoVgNdjHFXAldk9Acx4HRE4ePoohUeULDCyv9BrQU8ozLHrzVRTEze9OnwRKRCtR4xkkX1UB5XuBSTVyxHvPiY6gMomfqS6zJC4qGJaEEKRl3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J7hBjeYA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760166284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhiHGKFAh8Z6wgLniyL4CLx+giSyiW0RLL65qJ0l6dM=;
	b=J7hBjeYAIXWAkPsTb/ias28AP+deA2JB6O7gCARy3mpyljaJyeIQ3Yvx+5m/eg3azk8CB/
	vpVWFXpZ7k2r9aFIQHklMTi04Ny8n78xj8yomJ+K3Jy6dq9dIJXuL8RMif4LM9fQ5OBI/B
	ifXIC1YIe/7wJvPH+Fw/fJ+dAFU7Qi0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-AlOmFoLwPkO0bcX4v7kYAQ-1; Sat, 11 Oct 2025 03:04:42 -0400
X-MC-Unique: AlOmFoLwPkO0bcX4v7kYAQ-1
X-Mimecast-MFC-AGG-ID: AlOmFoLwPkO0bcX4v7kYAQ_1760166281
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b07c2924d53so280420066b.3
        for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 00:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760166281; x=1760771081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RhiHGKFAh8Z6wgLniyL4CLx+giSyiW0RLL65qJ0l6dM=;
        b=C19DAPvRO965lmEoFeeJvkhhqHeLaAfBq9N77Sf8IWxr/raOs9lJX5c8oB5KoXTaCR
         ytwjMQkcExow0jrMRQmm6kwbdU0fpOA4RlPe/RS/1IteZVTapsVeBkL9nH2RU+Z/jBNI
         X3cFe95TYSFkc4hU+l8l/DpQgvLLGo6WyUroiMUimZMB+7KBWNZCZfkiroxsvcfhQQlj
         29C08bmdQwsM2Nwya416zh32VDsEzgFH+CIoHLdGMmlhiU/pNq/UnHIVshXYTcKvet0Y
         1Ei4+SZbOn2Q6NQtOVa1hpYTM6fkPBIRLhQHIwScfMWRTVUtQm8fqVT7Rn2VPtbl5Gr+
         Csfw==
X-Forwarded-Encrypted: i=1; AJvYcCUJqV0Vwl2ij1BZQ4QLC+zrv/wVze2sPfzUDzh9sZsaF7EoypTw2dnqFSZHArbSLanb110=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVBYWyu6FQj1nZIpWOVqj1MrO5kdK4qfuOwCw9CpVSswyrL4Ev
	xrMgnDfD+pkzi6gDZz3by+8WVCpkGaEaszm1dhTJI/qtyfNotI9i/hphgsTm9pG0ZTVKhaJCrbc
	GTDSM9J5glXwt/hPob6x1fKqk50ydOOoN6MSrP9EZ9hIXcrSnimx7iQ==
X-Gm-Gg: ASbGncsKP90NKNgXnlZBwVLNL82ZzsWcBnaRopxmfQwbpzEmBd9D90ZxxUTgzIa+9Oe
	PI+GYlljAsYB/VPj0KCD1InQbQHExBUopG86E+2q6ktVhL1d6azkDe3XWqpmTy4/2dPwbgZJh8b
	58div0lr4xbIt5zqywkLkJhLsR/tCJQlTGKBzJAeP758CS4vMuxfoK7FgnZatz3nUqtt5+7qTUN
	CYktbc1qYCv/t4gXtyNmdex14r6EzRWaaJKCP3Q4fF3xX4Fggo6Q+i+wau6Vhdv1lainKeHZJh9
	YjuXsz+SWc0CycnVmjJTzPR3KO0dvjUGqOtId3uloY2mJwb5rK8Nn2BcMQ7u1AK9dkQuI2WRNln
	nrnz82R9dKNFmco4EPvfoJr2afape3d7eneC+Z3zHPTAO
X-Received: by 2002:a05:6402:518a:b0:628:7716:357c with SMTP id 4fb4d7f45d1cf-639d5c4fe6fmr12208873a12.25.1760166281287;
        Sat, 11 Oct 2025 00:04:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9n3uqdrolOp0oRQFc98iGpAa9NnBDM/PKNZpAmtUcMz8AHOuFayZx2yD3ns4LycDHDbYs/g==
X-Received: by 2002:a05:6402:518a:b0:628:7716:357c with SMTP id 4fb4d7f45d1cf-639d5c4fe6fmr12208838a12.25.1760166280801;
        Sat, 11 Oct 2025 00:04:40 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.231.162])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a52b0f3aasm4013815a12.13.2025.10.11.00.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 00:04:40 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,
	qemu-riscv@nongnu.org,
	kvm@vger.kernel.org,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Song Gao <gaosong@loongson.cn>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	Huacai Chen <chenhuacai@kernel.org>,
	Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] accel/kvm: Cleanups around kvm_arch_put_registers()
Date: Sat, 11 Oct 2025 09:04:21 +0200
Message-ID: <20251011070420.864887-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008040715.81513-1-philmd@linaro.org>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued patches 2-3, thanks.

For patch 1, I think it's better to have consistency in the use of >=.

Paolo


