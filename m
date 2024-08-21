Return-Path: <kvm+bounces-24680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC2A9592F9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 04:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD1D5284FDE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332C31547D4;
	Wed, 21 Aug 2024 02:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGoJku81"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2CC1CA81
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 02:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724208359; cv=none; b=mXyrrtY3v+DrQocOY4k3MXItM0q3pxDBNXwWP5lnx71YKHT8q2V9mOAwJXDldLc73oHSDJ/4P79tWZvVDcPSgGktxIfOPfObWWHagtEY0MSrlljhXOIgqqqlHCB9zOVk7Zb9IXd+900uvCu7QleFzePxKjE0NcM4wqhPHaVRkOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724208359; c=relaxed/simple;
	bh=1tpxTosyO9oxG72wvXeOM17GOQXVSYOsZcA5bZgcwWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UhH7AgpXUemh5WvC+WqFeUDiHMnN4kc8upcjG8XFMP4+Zq4CmkBQ1sCevRRScXvJ8gkZK7DPx4oA3pz63rM9SOYMbTFQgHk/vHEM1ZcXAwxebGtJ26IyAOhwKXhKPoltKKdnm8MwxaYAuNq8VmfICq+a1JdEwykiz/ciIf/sGos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGoJku81; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724208355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnCB9XL+js96QTUnqcwBPZip9eUqUJSLO61FBStGX2g=;
	b=BGoJku81vTLYK9znEWBt7ATUj0FlK6bJXJgRzqk+tyWL/zSD+wZUb2hr5Y8XdKaLVYr/EY
	aqHGEBsSI3PXoZMSnQOV6SzDEy+Fea6k9/69n8l7QJnhp2dQnQ+MLSS0E4FylAFrh6vmHZ
	znsZf3mLofA3MSItn26a3Ij9ITYX0nY=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-EGdcZjz2PROzMTfyOREGHQ-1; Tue, 20 Aug 2024 22:45:54 -0400
X-MC-Unique: EGdcZjz2PROzMTfyOREGHQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-202088f100aso42340555ad.3
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 19:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724208353; x=1724813153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnCB9XL+js96QTUnqcwBPZip9eUqUJSLO61FBStGX2g=;
        b=j03cWFAECzEkIxRp9zfrIZSAXlf/4MoOm8USjDcmxcs5Gx1NmOrJt+FxsXk7DtIYhn
         XA1s8hjZkMKYYoW9aok2WW9SXDtbRfSu9FOLbs51qG6pRwndoK+Yb9KUM4lFwVhCZHDW
         jzf8+DhD0gX42Sg9qeCtYEaw9XiKeR1NyoLFBuIdBVZg8IBmNRuUJC4jFEfEyMwpdq8+
         7GlH4njrJv9fwr4of9bxigqE8SeG93kNfIq3gez1BbORFFAVDp9Po23O9tg9XL7plpXF
         5jfP3xvFAEJUQkAgfXk4d05kF0P3838rtpAf+516i3vnQoSSsx0BmGlGEsmqaBlk3eYr
         u1Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWNPYLaY3xoCHzaUmxZAcbCyeMlV85YOK6xMYwj40RlsTip49TLjsa0ak7s3je80U1KNTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrzhgJEcOcb3btXZawBC92lBSdnPxVafuL8KXjNmSGN0gkNfHb
	oExLykp7+Jlnvz3XxLzeIxKmqS7XVRUC6d+5CLjcL8+nrQaHpKpRBWVAq/fQSKhipqx6fY9/E8l
	Q+3cbwm7hnKITokzXdPQBbdXyy5FyvED1eEI8vtndFRmE9Rz0Zg==
X-Received: by 2002:a17:903:247:b0:1fb:8cab:ccc9 with SMTP id d9443c01a7336-203681e3d0fmr12418185ad.45.1724208352835;
        Tue, 20 Aug 2024 19:45:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLvx8xlkUZjlEq0KcUSI9PEcJu6+23cYjpsS4sKgWdxqVJexOjK6LBAMbnz8YDagYUZLFm8A==
X-Received: by 2002:a17:903:247:b0:1fb:8cab:ccc9 with SMTP id d9443c01a7336-203681e3d0fmr12417995ad.45.1724208352388;
        Tue, 20 Aug 2024 19:45:52 -0700 (PDT)
Received: from [10.72.116.48] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f037903csm84174065ad.125.2024.08.20.19.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 19:45:51 -0700 (PDT)
Message-ID: <f423a404-82bd-43e2-a2a7-c0ea038cbbda@redhat.com>
Date: Wed, 21 Aug 2024 10:45:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] Allow userspace to change ID_AA64PFR1_EL1
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
Cc: Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240723072004.1470688-1-shahuang@redhat.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240723072004.1470688-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc, Oliver,

Kindly ping for this series. Welcome your feedbacks. I wonder if this 
implementation satisfy your expectation?

Thanks,
Shaoqin

On 7/23/24 15:19, Shaoqin Huang wrote:
> Hi guys,
> 
> This is another try to allow userspace to change ID_AA64PFR1_EL1, and we want to
> give userspace the ability to control the visible feature set for a VM, which
> could be used by userspace in such a way to transparently migrate VMs.
> 
> The patch series have four part:
> 
> The first patch disable those fields which KVM doesn't know how to handle, so
> KVM will only expose value 0 of those fields to the guest.
> 
> The second patch check the FEAT_SSBS in guest IDREG instead of the cpu
> capability.
> 
> The third patch allow userspace to change ID_AA64PFR1_EL1, it only advertise the
> fields known to KVM and leave others unadvertise.
> 
> The fourth patch adds the kselftest to test if userspace can change the
> ID_AA64PFR1_EL1.
> 
> Besides, I also noticed there is another patch [1] which try to make the
> ID_AA64PFR1_EL1 writable. This patch [1] is try to enable GCS on baremental, and
> add GCS support for the guest. What I understand is if we have GCS support on
> baremental, it will be clear to how to handle them in KVM. And same for other
> fields like NMI, THE, DF2, MTEX.. At that time, they can be writable.
> 
> [1] [PATCH v9 13/39] KVM: arm64: Manage GCS registers for guests
>      https://lore.kernel.org/all/20240625-arm64-gcs-v9-13-0f634469b8f0@kernel.org/
> 
> Changelog:
> ----------
> v4 -> v5:
>    * Only advertise fields which KVM know how to handle to userspace, leave
>      others unadvertised.
>    * Add a new patch to check FEAT_SSBS in IDREG instead of cpu capability.
>    * Tweak the kselftest writable fields.
>    * Improve the commit message.
> 
> v3 -> v4:
>    * Add a new patch to disable some feature which KVM doesn't know how to
>      handle in the register accessor.
>    * Handle all the fields in the register.
>    * Fixes a small cnt issue in kselftest.
> 
> v2 -> v3:
>    * Give more description about why only part of the fields can be writable.
>    * Updated the writable mask by referring the latest ARM spec.
> 
> v1 -> v2:
>    * Tackling the full register instead of single field.
>    * Changing the patch title and commit message.
> 
> RFCv1 -> v1:
>    * Fix the compilation error.
>    * Delete the machine specific information and make the description more
>      generable.
> 
> RFCv1: https://lore.kernel.org/all/20240612023553.127813-1-shahuang@redhat.com/
> v1: https://lore.kernel.org/all/20240617075131.1006173-1-shahuang@redhat.com/
> v2: https://lore.kernel.org/all/20240618063808.1040085-1-shahuang@redhat.com/
> v3: https://lore.kernel.org/all/20240628060454.1936886-2-shahuang@redhat.com/
> v4: https://lore.kernel.org/all/20240718035017.434996-1-shahuang@redhat.com/
> 
> Shaoqin Huang (4):
>    KVM: arm64: Disable fields that KVM doesn't know how to handle in
>      ID_AA64PFR1_EL1
>    KVM: arm64: Use kvm_has_feat() to check if FEAT_SSBS is advertised to
>      the guest
>    KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
>    KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1
> 
>   arch/arm64/kvm/hypercalls.c                   | 12 +++++-----
>   arch/arm64/kvm/sys_regs.c                     | 22 ++++++++++++++++++-
>   .../selftests/kvm/aarch64/set_id_regs.c       | 14 +++++++++---
>   3 files changed, 38 insertions(+), 10 deletions(-)
> 

-- 
Shaoqin


