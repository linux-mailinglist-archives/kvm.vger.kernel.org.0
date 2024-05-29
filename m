Return-Path: <kvm+bounces-18270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 897288D3185
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA8B01C22BA4
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 08:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A970180A94;
	Wed, 29 May 2024 08:29:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2C16A386;
	Wed, 29 May 2024 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716971379; cv=none; b=cyaHtMzTjTyGD/o39n4xwY9tHdGdoBM17fR0kgMTZuVY6rCPLpbqEIst2l+N0r5o0cVoGz4pE8Aa/DoYTQQ42eib/LXO3+lLWWhhOOiR7E4XBE/0SECR2Ypsybjs0Y2Ma11/z42mqz6SvgAJNOiSk6arDEVKzX1bqF7G3xZK92E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716971379; c=relaxed/simple;
	bh=8SW852+Vfnp4PsENYXV4X/Claa09p9DB1Fs1huwvNrM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dgG9cwA65hW1XW2/C3yGVa6c2r/qkjlvkRIuoo7VpHTTk8d39ElHiJ5KpldovWuDULCXyTDCglpSg8aI/XfgW82eqhpcBR5wQ7vKybdRzqSpMt2QyxVRXA2DIXG29Vhbe9bOm1CSCs8OzYDcNOq3Aiyg9Cev7jFTm1oOjBbmfAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Vq2Xc1pxLzPkf8;
	Wed, 29 May 2024 16:26:24 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id DA2E2140FB3;
	Wed, 29 May 2024 16:29:33 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 16:29:32 +0800
Subject: Re: [PATCH MANUALSEL 4.19 1/2] KVM: x86: Handle SRCU initialization
 failure during page track init
To: Sasha Levin <sashal@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Haimin Zhang <tcs_kernel@tencent.com>, TCS Robot
	<tcs_robot@tencent.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <x86@kernel.org>, <kvm@vger.kernel.org>
References: <20211006111259.264427-1-sashal@kernel.org>
 <0fd9f7e5-697f-6ad0-b1e3-40bd48a8efae@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9acccdfe-b7d8-b59d-7b00-d5a266b84d36@huawei.com>
Date: Wed, 29 May 2024 16:29:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0fd9f7e5-697f-6ad0-b1e3-40bd48a8efae@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2021/10/6 19:23, Paolo Bonzini wrote:
> On 06/10/21 13:12, Sasha Levin wrote:
> > From: Haimin Zhang <tcs_kernel@tencent.com>
> >
> > [ Upstream commit eb7511bf9182292ef1df1082d23039e856d1ddfb ]
> >
> > Check the return of init_srcu_struct(), which can fail due to OOM, when
> > initializing the page track mechanism.  Lack of checking leads to a NULL
> > pointer deref found by a modified syzkaller.
> >
> > Reported-by: TCS Robot <tcs_robot@tencent.com>
> > Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> > Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
> > [Move the call towards the beginning of kvm_arch_init_vm. - Paolo]
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Sasha, will this patch be applied for 4.19?

The same question for the 5.4 backport [*]. It looks like both of them
are missed for unknown reasons.

[*] https://lore.kernel.org/stable/20211006111250.264294-1-sashal@kernel.org

