Return-Path: <kvm+bounces-51161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 312A2AEEF01
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 08:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF81C7ABC15
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 06:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0115825C838;
	Tue,  1 Jul 2025 06:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxOoqMLc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D4626AD9
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 06:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751352106; cv=none; b=NMkQ/up3ZzAYcW/GrII4o/ZWp5n6kCAQf+oTRry1WsIjaTjtyWYvy3yLwVF6AJIg7lTtg02kGexAHgXGey6HUfT7d7ock28AYp4ydrc3AANEbvNybswbBNPeWc4Y/WmoWkY5mCg52C8Gsfe83LstgFEQ6Bz+Lcqsa3yl4KiQxDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751352106; c=relaxed/simple;
	bh=kGpgLRB+mp02Cl1q11HP6F3dDAhpnnUXWI58xYxcPZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYi8j7HLeBwewuSKF9i/smPR6NpK3MFVB45uhLX5YHdvpgkCkGqI40ObF8LY/8zEk1g2QNClymoG2aas9CT1ggJLCnS4DqvdciPOSNP+UWsF2dAicRvxDxR1xHurpeN/oDGZlUgheMZwiup0oAPa0U5cd2KMp0RjHNSSAeKgfDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hxOoqMLc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751352102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQYfrw2czgfVr+YerX7siCfmJocpn7Zqz18UhcgAHpo=;
	b=hxOoqMLcIVT1HQARS0yN6JLq1PINIlxGxo8olS8g7ndhsiMbe7CuboDjpU8ivRHZSP+a66
	3CnCH2l0FdvsZUt33BwI35th4KEBvKAennJQFuSeCnlKj4wZAlD+H6BiGjULNqJqiBe6UB
	hH4wKyxWfvuB5sb9IqN8wApCfLUG634=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-dOXU2tPNMJOLhIUuKI5hrQ-1; Tue, 01 Jul 2025 02:41:41 -0400
X-MC-Unique: dOXU2tPNMJOLhIUuKI5hrQ-1
X-Mimecast-MFC-AGG-ID: dOXU2tPNMJOLhIUuKI5hrQ_1751352100
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2349498f00eso50222925ad.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 23:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751352100; x=1751956900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQYfrw2czgfVr+YerX7siCfmJocpn7Zqz18UhcgAHpo=;
        b=k8SSmLJUfRoKoK2aTxSOojWgENkdOteagpw7dvoi5OidUMA5XsS8KTcuVXSrfZSOD8
         oYtJhS39fCKPr+dgvxVkdMrL0wstytbXiJxzGffdU0libehZArVxFDP4Odh7qphEKROl
         Sx0jAT1JJmMdLXP+PbicLwAMPRZle+3tUuK3LkIM17B4ZQptovRQtWyGvuoYomUVWmbe
         iaN21WD5tjvE6fKJrb0hzy7v+bLTYVH9n/ViFhaENJFEs2TCRQvCFvwWwThfyL1AdDYZ
         t9S5uiUEWplGfTtg/JOzMus59hmOpJ3Qo0z9da4BhyzG3ti7MurL3kzeuS+wxliD801P
         1eFg==
X-Forwarded-Encrypted: i=1; AJvYcCW59IWXgM9rfj/aYHCnBBDJy25nrxF1jfU5dGd3rwNkK/ac4NZbkMg3W1OUJU1tme39KTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzabqBnTVWYE+tmDHgSRq28G22wD/75FrQ3kkglP4sq7UB4HpU+
	CxEN1amy0tp3gTguYFgBsEYeFU2Kb+xVSJNy5llydGkAchHw8ImCS0GPzynYzbwLmWX4OTaqyPo
	MotQBSKd8kMNVJfVR670le6jC4I4oS2jtlw2lx6JklOh8TB3xD+wpPQ==
X-Gm-Gg: ASbGnctzwBQIktztloIBgmzdkB9h8QY7Z6ZuaIEz2JrutWKWjuu2SaLM0RxMLuddker
	rdazm0l0O8ww/cWmMfSi1+kvGg5tshFOEB+weZPdKnVmIeZuamEjQjRhX34GruvKECnKmnRp9il
	U5R1Pf6N2hmGmzC8ILB3p0oH8nHSGBxq+xJNufIYLkW6nLa67ui3Fh/Ho7K3mFUf+PjOg7tUHlt
	JBSs0X/kM4DE+TNhowKtqFTf3WiPw2UWWrPsrjlq5gjeydvvZZCJvqauir8U6XGmO0dJzkCP2QY
	A/pk9FkLz5APT4S1HoU1LuaZt1DiN2aH5BDVb9KYMB0RtmLX/Ixwx4sShrPm9g==
X-Received: by 2002:a17:903:19c6:b0:237:e3bc:7691 with SMTP id d9443c01a7336-23b354ccb5fmr48817365ad.13.1751352100097;
        Mon, 30 Jun 2025 23:41:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzRrkg75jFwfmHGPour3us0gMVNM40EjoGoGZlYrZyd2YrJY+nKplS2aGywWS1wb1p46z/mQ==
X-Received: by 2002:a17:903:19c6:b0:237:e3bc:7691 with SMTP id d9443c01a7336-23b354ccb5fmr48816855ad.13.1751352099716;
        Mon, 30 Jun 2025 23:41:39 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2e1b3esm96630595ad.35.2025.06.30.23.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 23:41:39 -0700 (PDT)
Message-ID: <5930a931-b809-497d-8eb2-076570738ef7@redhat.com>
Date: Tue, 1 Jul 2025 16:41:30 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/43] arm64: RME: Support for the VGIC in realms
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
 <20250611104844.245235-14-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-14-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest but delegates
> much of the handling to the host. Implement support in KVM for
> saving/restoring state to/from the REC structure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v8:
>   * Propagate gicv3_hcr to from the RMM.
> Changes from v5:
>   * Handle RMM providing fewer GIC LRs than the hardware supports.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  1 +
>   arch/arm64/kvm/arm.c             | 16 +++++++++--
>   arch/arm64/kvm/rme.c             |  5 ++++
>   arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c    |  6 +++-
>   arch/arm64/kvm/vgic/vgic.c       | 49 ++++++++++++++++++++++++++++++--
>   6 files changed, 72 insertions(+), 7 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>


