Return-Path: <kvm+bounces-3041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BFA800143
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8D431C20C4D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0844A4426;
	Fri,  1 Dec 2023 01:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qUMABBid"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2985512A
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:52:51 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d1b2153ba1so28766117b3.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395570; x=1702000370; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VmMRiyNlWj7E7DgTlLHv9EXBHs71X6661FunQt63Zuo=;
        b=qUMABBidryf5/55E1JgDs6QBRarLv17hNYabXoUbaxIbgfg3ryD1w7R4iuaYBxVBrC
         mwq+y+eeCNesQJZKjb6hvj3iuP8bCm2uUfyKMTV61DWCv/jH1/ScbeA8B6mTe7gNbKea
         OqtAkRnJgcpxqRsqueNn/WaR5NcReM86aZvHjDnepcy2DYaurpfJz54lemSgsOQyJxS5
         sGoW8Lt85oacUiOmZH17XobH5gGjBlPAHFPJTF7sFk3dojLPO/x+dMsHe9JRFJFpGt53
         gspAuiD1D7DXYfTATT3q+cs8xMrkf5kbSJzkf1rMhSqmGjqxyKhc8oJm81E0RkJp2+tr
         MzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395570; x=1702000370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VmMRiyNlWj7E7DgTlLHv9EXBHs71X6661FunQt63Zuo=;
        b=QnzITS8QvzPqQmVK3caCTU+t26IX/bsFu53vejYbK+tFH3T7lTZYFhaLKTItz1ugrC
         OusUFTi4/IZaJt0l5JkGruiHY9bGrKI2UAHr5qtHYJU+uoYOXz4wPslWYuBp6I0cZCPE
         G+uMVjNjyEeDQy1gnUOu44bjZV0Jlz+/eqXTpqnDWRqWyqBDljKrlTWtnNII2a+fbrSp
         q1oxhoSn1mWAvtPijSsdWI10SlTo3YTMdFVT2LXxZrBXKoZKf+0lrI2xtE234RMeA8sg
         MO4iarmsrWACf9/YUIx5jloG/BmCzen9J70D0M3aTcuqJl0ui3V7hZTY88NBV7G5kRzH
         xXZQ==
X-Gm-Message-State: AOJu0YwVhnvZhtaToILtlbXnWfxXdZRWX4S+4YB35NTgVEtJtTWnxKdN
	PVTKq7gzcu1rRgGD7zc6LB12ginFUTM=
X-Google-Smtp-Source: AGHT+IG0csC5MDjPOHcU6NEDOuOjQZAIXLHGqiPVTff1eLcelFsQF5L6YdMrleiiyf2icf/uD20FIF8jycU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:99d0:0:b0:5d4:1835:afe0 with SMTP id
 q199-20020a8199d0000000b005d41835afe0mr17243ywg.10.1701395570360; Thu, 30 Nov
 2023 17:52:50 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:08 -0800
In-Reply-To: <20230315101606.10636-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230315101606.10636-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137868908.667071.11420459240927661184.b4-ty@google.com>
Subject: Re: [PATCH RESEND v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Wei Wang <wei.w.wang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 15 Mar 2023 18:16:06 +0800, Wei Wang wrote:
> KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
> framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
> KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
> 1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
> For example, userspace VFIO implementation may needs to create
> KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
> checked at the generic code than at each arch's code.
> 2) KVM_CREATE_DEVICE has been added to the generic code.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
      https://github.com/kvm-x86/linux/commit/63912245c19d

--
https://github.com/kvm-x86/linux/tree/next

