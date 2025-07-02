Return-Path: <kvm+bounces-51235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 899D4AF075A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 02:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB3341C047C1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F3A22318;
	Wed,  2 Jul 2025 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LVr41hJl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42A418E1F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 00:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751416926; cv=none; b=VvVzjNojB92lGA+IphT1biwKd7G4kuhyi5um8RY+DQqmL2D+4RMZrbt/6BdQZPqnkhEWpCtfBi0oTOlZFkCs0v30RSB51wrVF1ZYj10vDfX+L9ylmJqS9vw8OIa6T1Ya206lUwhKacrPg5yi9kx2WqCYwTxRopiRmjBsUFvb6jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751416926; c=relaxed/simple;
	bh=gQML4Nlb+6BLGU4vZy0wmRSFYntLR4PR2oVZTdDZp88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/ny0c0zr8AlwoCu+Mpg0xQIe+MNyIj9251FURUdgUmXprfcCQOqy7fnCEz7kTtUySGvjp8lJbjN2G1O7jVwz18ZDk9bE4Bo9WBi2tkHe0MsJT+qYD8lrWLcqOv0BhDrm4oZYTxNxFiahnZnjxQ/6aG88oeKIVUd5OldLgSWCsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LVr41hJl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751416923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IS6DmHZ/EPn9vNNwu1p5P0DKnu56R5jJnANztZV8U2U=;
	b=LVr41hJlXdHYqVf84FWe+ijCk9mCDfSr4AZbhs/QYypsT+mXRrpXP0/DUurCl1IxZ3AakU
	eC2hdOejEtH3CVAL/HVG7d5PBQMcTE4hp3iOGSzU05Dl6gIN1sG3Bjs3/N++A259pXNVsb
	7mqCAqdpmsOWpX5Ea7IzFb/kHMc8NmA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-6lyf9TY3MF6lVisk7pixBQ-1; Tue, 01 Jul 2025 20:42:02 -0400
X-MC-Unique: 6lyf9TY3MF6lVisk7pixBQ-1
X-Mimecast-MFC-AGG-ID: 6lyf9TY3MF6lVisk7pixBQ_1751416922
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2363bb41664so46837795ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 17:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751416921; x=1752021721;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IS6DmHZ/EPn9vNNwu1p5P0DKnu56R5jJnANztZV8U2U=;
        b=sqxDXDoi7DTHnWRE2Ve5S+5J01exgFS/yQO5GWdiJj7LefAWJjINU8vUR+hWQJM3nb
         MFraBUFCArx7Q3WQn8IWkJr4HkSI6CSxMwpdq8PIMqUuTcf9dktbfNmW+N/lBumcgEpf
         39sju+HGCuys6fSySDxSxK0UjEbibWuVQMctHLqH7+K9uXKH1fznojKZl1QRW2nuFzyo
         SpfNyRnyi3EJnBCQI9MiNiqZXdRb8AAQG+6rgsjbW4QUq+w4+JntSsrVbWg4iOgpYH0S
         7a94I2q6l9MwXkNSqHr8qF6qNyMtOpYFxUmSG+oWe+tCWiVhR7tame3fjqqat5teoYW1
         c9yg==
X-Forwarded-Encrypted: i=1; AJvYcCVomc3KORqUJjv9E84J+a0isC1CSvBCTTMSTtcr/VF4ltlkUo4frOtvzf4JMgIS24LCJiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFj18Zepb5C4WLJTTEB64pCv9e1rHTlttpe9sfz6RdsSHXTOSR
	L8IwdPYmd+gPSpU26K2cL+OmAVMo3m0AQAob87Zj8KK+5YWTo/navDz+xitqZQEF7tEIrBraGPh
	piWYcKl/ttJL/LULQ0l9W9Sy/+fxzLmCMT+FERDcLY/CONZkBZZWI1Q==
X-Gm-Gg: ASbGnctzeUcmDyD4peWGo9BMmfP5sI13fWgmX1dRxuJc8GBoBS/p5oVcCoi7OW7boeY
	alFolqK/yucDDEQvai/k24vOblnq3JYOf6PAxz8WcfPwxJ8cgZOFSvnoxjnm/sE+LJ/UlpLJKkg
	5RiUqs5nZFpF+ZBR8JOEHY+a/YHY3YdwrHEm8Xgw4WaUB+J5TA+YuR8v2f6gtB13XwuxP1GaA5V
	XOuzrXPTtq9o9GMQd07xf3ovNfvZ7h7Fxoe9Pn8Xm6SSvVHvZOe94YBCeBYiTlpHF6AS/EQHGnz
	AX1cW0HeTnkgrcfdej7MsosRrr6fC9iZUS9XmwWVGPCvlesWkCsJZvWOTyolwA==
X-Received: by 2002:a17:902:e809:b0:21f:5063:d3ca with SMTP id d9443c01a7336-23c6e81e812mr10088075ad.16.1751416921651;
        Tue, 01 Jul 2025 17:42:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLaYwVOFkrc3uXeDo3lLBdt2ODjpAZgoQY+FVxCUbATRGn8q8nteuTtaLiNL9kfSpsCG8Ldw==
X-Received: by 2002:a17:902:e809:b0:21f:5063:d3ca with SMTP id d9443c01a7336-23c6e81e812mr10087595ad.16.1751416921150;
        Tue, 01 Jul 2025 17:42:01 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31c2252sm11480507a12.49.2025.07.01.17.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 17:42:00 -0700 (PDT)
Message-ID: <d092bb97-d552-49f2-ab93-bb2bd7809c3f@redhat.com>
Date: Wed, 2 Jul 2025 10:41:50 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 16/43] arm64: RME: Handle realm enter/exit
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-17-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-17-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v8:
>   * Introduce kvm_rec_pre_enter() called before entering an atomic
>     section to handle operations that might require memory allocation
>     (specifically completing a RIPAS change introduced in a later patch).
>   * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
>     HPFAR_EL2_NS as a valid flag.
>   * Fix exit reason when racing with PSCI shutdown to return
>     KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
> Changes since v7:
>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>     been read (although that can never happen in the current code). Tidy
>     up the condition to handle any future refactoring.
> Changes since v6:
>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>     vcpu to the error.
>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>     this exit type.
>   * Split code handling a RIPAS change triggered by the guest to the
>     following patch.
> Changes since v5:
>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>     change on next entry rather than immediately on the exit. This allows
>     the VMM to 'reject' a RIPAS change by refusing to continue
>     scheduling.
> Changes since v4:
>   * Rename handle_rme_exit() to handle_rec_exit()
>   * Move the loop to copy registers into the REC enter structure from the
>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>     where the handler exits to user space and user space wants to modify
>     the GPRS.
>   * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>   * realm_set_ipa_state() now provides an output parameter for the
>     top_iap that was changed. Use this to signal the VMM with the correct
>     range that has been transitioned.
>   * Adapt to previous patch changes.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   4 +
>   arch/arm64/kvm/Makefile          |   2 +-
>   arch/arm64/kvm/arm.c             |  22 +++-
>   arch/arm64/kvm/rme-exit.c        | 178 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             |  38 +++++++
>   5 files changed, 239 insertions(+), 5 deletions(-)
>   create mode 100644 arch/arm64/kvm/rme-exit.c
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


