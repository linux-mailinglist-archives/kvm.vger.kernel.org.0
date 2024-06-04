Return-Path: <kvm+bounces-18724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E74178FAA35
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82DF4B24833
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BF213DDB2;
	Tue,  4 Jun 2024 05:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/l1CkJy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEA9847B;
	Tue,  4 Jun 2024 05:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717480106; cv=none; b=tA2zDxJjvfl8WlQZerfn+9jQw4c6aJ8PkYKokykjVRtnB9idG/YcftcTdVlTT1EhC3KoBPD7cVvytEnZFkobKpyruVm/jHtuZ79rp/HJ83+r2GEQ8auRA9btud9cj2UOA7pN1XAIuHqvf8xqZ2ye1pB9eEXJNDL+u3XGefbd0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717480106; c=relaxed/simple;
	bh=FMtX7htPgOinKnxYoDwQBwCdcQiHAtR+5gF31h9Oy8c=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=EjGx0ttMvOn73iPYILu1fedv3477LWK65axI648KH/1gq0QmW7pEyQ/sPYpNjKdsQDSFYQODA1pyDp+R0klLVP1ebPvxQbQiEctYNorPtB4QAdYRWMIdUc2lVjYAoTcJpw+ITmlqejCM9uJ+qpRLv3mxi1MA8pCAqu/tgOxBx0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/l1CkJy; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70255d5ddc7so2200488b3a.3;
        Mon, 03 Jun 2024 22:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717480104; x=1718084904; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p61Hce8IkWwKux3VG8miwDHGw7bU+KFjOmsb4t+oZQc=;
        b=E/l1CkJy8+/wWN2b/fd5rd2Zd45+oq/a+IQ3U43TeNl6+o+A+FQfGMDZWBhsW3U1xW
         b+2xYAlgzjcCJKTdjNnVYz7P3iqZvPNvbs48960HwLJGXokTEH7mIAKijzVzwrmVr/WJ
         UKR5tVUbPZugdxMObjyFsVsZIFWw7+KVvhxVOfMOsIgiiW7ChktwPSxFMkrkNfIZiLNv
         noHqW6QcyrkUHli0opLAu5oxwmtG3hh5zKnIIpOkE+3ipl8JJGF3TI886GkEJZxYccIe
         UdQlNOIpTiqhR7adk2yErOwJ1LJgEeo594eguZ6grnWh2U5Vg+yfLmyYpCYPSQwlzoOJ
         d2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717480104; x=1718084904;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p61Hce8IkWwKux3VG8miwDHGw7bU+KFjOmsb4t+oZQc=;
        b=OordmMwMgONFjRTzuwYxHHw7npeTUdXchKcBd3iMtLXOoMDeTH0SJhdBlqzthlyZqL
         Obn2zsZR3e3HdmZRTeSSu0u+X4JHBNqRMN5mbTUuvnMxURLyADgc342GIk3sRXCtw7Xg
         wATNNrSjjk97nJ6E5EZRZRGIO3QCdMldikrpmn5I5AnNBdINYPUgQw7hTBL363cX3IB2
         0tqS2C6H0kNN/5sXKejYtOkCjgfbAVNS/GH8/Qo5klTdpBKz3vR1ni8/vbeB9sTmh0da
         6+2/JvizJ7iuOftNQmLHUDSGCiTnGKLaMSvHJ+odItvorELgO0FBKygJfb3PUhFIqJ+b
         aM/g==
X-Forwarded-Encrypted: i=1; AJvYcCUYu3X+S8RZbA0U16wGRteBLO7kx/TPDoL17oFOE85KxgJF4cL3FHOgqct+Tlt+P8um5JCHSG44BWAzHPxo57eYrrgIH1K5iFz9hEeLvwwJh/mJndiE3dpOQfhDXhYqX7EV2E6i8StZdalXTKlQ1B8pHDgpdd4fNJX0WKuW
X-Gm-Message-State: AOJu0YxuWq16UaCrXV1yPHJgB/bg5rfcFVpdzgHWpS8Rdh7K5/kTCQl2
	pe3V8I53XOeHI2WMVst4u8AlYn6j22/apctBtm6nbkyyFwkaLMn0
X-Google-Smtp-Source: AGHT+IEerX2qhhDnie48IrgDghI2cbk0LGDGIPJRG6DPWms4QfaexRHMPMrgovshUNKM5LzZTnLjaA==
X-Received: by 2002:a05:6a00:23c6:b0:6f8:d51b:1ccf with SMTP id d2e1a72fcca58-702477beb2amr11602978b3a.6.1717480104182;
        Mon, 03 Jun 2024 22:48:24 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702425e2c23sm6395956b3a.85.2024.06.03.22.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:48:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:48:16 +1000
Message-Id: <D1QZVS0ZCVBX.2UISITKQZRZHU@gmail.com>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] KVM: PPC: Book3S HV: Nested guest migration fixes
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.17.0
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
In-Reply-To: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>

On Mon Jun 3, 2024 at 9:13 PM AEST, Shivaprasad G Bhat wrote:
> The series fixes the issues exposed by the kvm-unit-tests[1]
> sprs-migration test.
>
> The SDAR, MMCR3 were seen to have some typo/refactoring bugs.
> The first two patches fix them.
>
> Though the nestedv2 APIs defined the guest state elements for
> Power ISA 3.1B SPRs to save-restore with PHYP during entry-exit,
> the DEXCR and HASHKEYR were ignored in code. The KVM_PPC_REG too
> for them are missing without which the Qemu is not setting them
> to their 'previous' value during guest migration at destination.
> The remaining patches take care of this.

These aren't just fixes for nested v2 or even just migration,
by the way. Good fixes.

Thanks,
Nick

>
> References:
> [1]: https://github.com/kvm-unit-tests/kvm-unit-tests
>
> ---
>
> Shivaprasad G Bhat (6):
>       KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
>       KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
>       KVM: PPC: Book3S HV nestedv2: Keep nested guest DEXCR in sync
>       KVM: PPC: Book3S HV: Add one-reg interface for DEXCR register
>       KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHKEYR in sync
>       KVM: PPC: Book3S HV: Add one-reg interface for HASHKEYR register
>
>
>  Documentation/virt/kvm/api.rst            |  2 ++
>  arch/powerpc/include/asm/kvm_host.h       |  2 ++
>  arch/powerpc/include/uapi/asm/kvm.h       |  2 ++
>  arch/powerpc/kvm/book3s_hv.c              | 16 ++++++++++++++--
>  arch/powerpc/kvm/book3s_hv.h              |  2 ++
>  arch/powerpc/kvm/book3s_hv_nestedv2.c     | 12 ++++++++++++
>  tools/arch/powerpc/include/uapi/asm/kvm.h |  2 ++
>  7 files changed, 36 insertions(+), 2 deletions(-)
>
> --
> Signature


