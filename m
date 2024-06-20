Return-Path: <kvm+bounces-20113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD175910A4E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57039B23C0A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDBC1B0132;
	Thu, 20 Jun 2024 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoPLcVPN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BB71B0125
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898292; cv=none; b=l115azIlg3sYzvJn7YjuyBixulQzs7iKBkbghFJHbQTpdbmj1JAapsW1hvAtefpLpgztHq0z3/zrPilW+RiHnUGXyFZsba5ArcIkHz0V7BZ8c+MtDypM5kenGFxPgd+rjS9gX6DwupPhSnfCUftrNEuxYn+MmjEEiUmWa7jFpEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898292; c=relaxed/simple;
	bh=T5peMHLH2/lvV5zPTywsO9a7/KHjr91Ck01nEMXty4M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=L8O7k0NH+EM27z3oupjYHXY+g3g70Bp1XAfWJTJrhymfguc1f4bfOWzPfEJZ9W4Y/yj/vmiXImRViorpKBmFNP532Mh6qHLfO5LkoeTa4kaKhZ8hfXUdda7FlRzyZTR9g1VSXmscsveSuGrvXIkFxgT4rdIWZJPCSxrjjdcC0z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YoPLcVPN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718898289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T5peMHLH2/lvV5zPTywsO9a7/KHjr91Ck01nEMXty4M=;
	b=YoPLcVPNN4ubwUyYAf3QO+3BGjKIqmiXuGrwXaV8dN+mN77bcVn8CbwnI+xtxw832bBMdV
	HSigW96UP9zi1CPFzdqY91MPzuuCVH5dZjhAY2MmIF120KdjUOfQk7blEoj8enkONQO2T3
	SmdwDW7Kz6yrv2R8TgMxLgsl6f48uXQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-NC-nedsAMMWCOcTr0cmZxw-1; Thu, 20 Jun 2024 11:44:47 -0400
X-MC-Unique: NC-nedsAMMWCOcTr0cmZxw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b518e27978so3182686d6.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898286; x=1719503086;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T5peMHLH2/lvV5zPTywsO9a7/KHjr91Ck01nEMXty4M=;
        b=XcsmI+uTpV60xAIHKgXbj3dmtePGzZiV0rq0PynFPYA88kgaelrB6BDV1iRncgKhen
         CMaybTDTb9EN+QxSeDzf+/edM1jItx91t4kSAmRi0RmAEA04G9PFMvexxZCKSjTMI1Px
         ve9dMH//T4fXyACUghONbhvuQqcFBbGsDIf9OfdBJygDN+eoLDJxAKSJ7xpxwnmAJz0E
         LHGlgnh13Dw9kz40esyF7g7P9etMPcD+1CoioqiEzruNwgEakaz2/TKHUQEEGkHbdCP3
         jgdKtpxu1BZMibKDgrtCSRQigQzBnRXmSzdGPXkDzD3xJgcYQTnjw4CaXze1iR1Svlpb
         vFvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqM6PMEnUZsg+si9WDYQagmt+YuiTgRyZaXB+VHMOi9HV82UhZnoW8mAlGDOdNTztozfS2Rb2k1Dv2kZPfb3VC8QQk
X-Gm-Message-State: AOJu0Yz1IEK7K84yNh8Yck9Zoe6VB2sM7+KlTfH8oOgwWtv8X/Qnlsda
	AODoJqXNOFX/KCeKGyzv59cBl1S0vkZd+wdJGp6BjUMENmIjhSUnxuXsdNrrefNQb5gUHAcklGK
	LkFJywTPv02SBlNYBp56yTJE+Ku4qpIbSjfVi7Sl/9FhCM5Sq2g==
X-Received: by 2002:a0c:da0d:0:b0:6b5:81f:f14a with SMTP id 6a1803df08f44-6b5081ff707mr52685016d6.36.1718898286639;
        Thu, 20 Jun 2024 08:44:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0D5QNE+vRsG3anb4CDlhzXD7xleeSKu+MYv+Clx7k8Xx+s7A3qB3oJAXsBuJ4oIJUVnKc6A==
X-Received: by 2002:a0c:da0d:0:b0:6b5:81f:f14a with SMTP id 6a1803df08f44-6b5081ff707mr52684896d6.36.1718898286381;
        Thu, 20 Jun 2024 08:44:46 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a9cf8257sm86445916d6.56.2024.06.20.08.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:44:46 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:44:41 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 03/10] KVM: arm64: Use read-only helper for reading
 VM ID registers
In-Reply-To: <20240619174036.483943-4-oliver.upton@linux.dev>
Message-ID: <6367a0c6-e1ad-41ae-709e-be3746b6ba3f@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> IDREG() expands to the storage of a particular ID reg, which can be
> useful for handling both reads and writes. However, outside of a select
> few situations, the ID registers should be considered read only.
>
> Replace current readers with a new macro that expands to the value of
> the field rather than the field itself.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


