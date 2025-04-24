Return-Path: <kvm+bounces-44217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D389A9B57F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 966B24A6101
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC5028F53A;
	Thu, 24 Apr 2025 17:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OrmfHhf4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811B428DEE0
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516218; cv=none; b=vFVE5vhtYGI8sxU1cRDO/nCV3gem/Z+D8gdgvg2pADVhYYHLAc68N6X/j1qxdP5aEwH2VsiKIywqSADo8iK0YtdUsKIxq2JKmzOcHqxka8hQAe3xEM2uUGhv6hzjlhezIR62WBf5YOKcCDqmk3QJvTMVi9Xmdn/3jqfPSzmDiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516218; c=relaxed/simple;
	bh=lZoZzIu4SzmOx9ZR8NQErN8IG5FsxE1ZcCH+9ijYP7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DgWai25UelhMdXoFQjBZ7/IJOpkvZRyPY7/X6+aPMVJBYaXBWvi0zhuuO2zg/5SyeTgOxJTWG/Wg4JpbHkjyC/uOGWBbFHQRYr93jEBbZBq0gthpxxzuY3PhZITdgmye8ae+L8GeZnTJOwriOR7uLoxzXGrYzzPRx87MIe31fAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OrmfHhf4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745516214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBqK9fMqIBSDESBuCvkZEwLHI6yCeTSX1Y6Z0m9j4Sg=;
	b=OrmfHhf45oq9ppBKjuUBMxCRkKGkngGb6rCacLZ8/Ie50ZfJ4i+WshqKzGPUmvK/Z3CfKK
	KNZjPZLtNSUvdkSuGRLhlV14e2vgeEGCqeYDPHYAc/MmtBfiFm0BOnDQb8ZKO2LUM+/TXb
	DXPdIn9tCf372QZ+MbPH8aN+E0QIdtA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-crteZePJNRGltAgLmlqnkg-1; Thu, 24 Apr 2025 13:36:52 -0400
X-MC-Unique: crteZePJNRGltAgLmlqnkg-1
X-Mimecast-MFC-AGG-ID: crteZePJNRGltAgLmlqnkg_1745516212
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3912d5f6689so674467f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516211; x=1746121011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBqK9fMqIBSDESBuCvkZEwLHI6yCeTSX1Y6Z0m9j4Sg=;
        b=DOtxPDz3RnIIjBtGwnvYCf4JJTLGG/3imcltBzxCIqfHMFnyDa/wHoE+r5VsPYe2tU
         iZ9L3oOcMTY0HBXb6zByjtYtNVShPuNQw5aB0r/76BYQ5LfMAfihUiGJRzmhj8RtUQDy
         9BegxYeRH08ffA0BnnG7vlUP/ljGQc7D1luicP/tFN8EH6cW6E61ArIaCKxDCS4mF/YB
         jV8hlgTXWX5BnPnC9LBy9i78njmaUZYp5ScNVx6Uz/zDDCe2Qp5Y+qL3dr1/LOOkKauo
         Ps67WmEoYYQmmmf1zabS6x9bQgJ/ByC09jYRlJikQHrX98ViEHwWVn3aAzV+QFGRDFGd
         vOAg==
X-Forwarded-Encrypted: i=1; AJvYcCUGHN0DQYcPtYS/f53t4DAq58+CyrnG5QR+10ZfUfNVdLSSmHizddHpSEnk7GlxTqAP9mE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1bl+6xzh5P+nj5w3h3PvvRgAeJID8WWL6Ngt5ibc/qV6djvFt
	ce7NpSN1O7vkwT9yhd+I8uqCxLJfUkVwmktpa44PVujpfQijBlhyXLKK3IXb7JzibAmno34OM3Y
	QpmW6IQI5SUhW+LiWrG6NjQpIaRvQigfSNq4rNEw3gLtatjJuN9jDvE+5vF3yBGX5yHr+Vd0hY8
	4XoTOXHBqXnvv+wmgzHEXP/8pV
X-Gm-Gg: ASbGncs7iuRJFShNFfPvcK+zXTI2pn026QtSCSVAJQzj60owaZbCJIrD/MKUVN+GSRm
	OlYyRnQBaSNDQvDjDK3EvSkE4Taw+zHxTUi0Ti79rH29qKf8T8p/jHHdltxEXVUaUCi0=
X-Received: by 2002:a05:6000:430b:b0:39c:1257:cd41 with SMTP id ffacd0b85a97d-3a072c037c5mr182220f8f.59.1745516211577;
        Thu, 24 Apr 2025 10:36:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHU+QW9NBnJ+gaooLF6UkTfbCZ6u5CpxxIqFOeklcv47T+lKysC0aQ9W6aokAxSAY0FX+NSTDgLkJoz96SvQQ=
X-Received: by 2002:a05:6000:430b:b0:39c:1257:cd41 with SMTP id
 ffacd0b85a97d-3a072c037c5mr182205f8f.59.1745516211195; Thu, 24 Apr 2025
 10:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aAK9xg9DMfCsCPux@linux.dev>
In-Reply-To: <aAK9xg9DMfCsCPux@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 24 Apr 2025 19:36:39 +0200
X-Gm-Features: ATxdqUHk1jfhP-87m-tPcfs6H_WLbPj5OnJMOLQCc-HQymmwOLcmUKumm3-4lBc
Message-ID: <CABgObfZvEgABLG420ofjH+iyrVEihhX0D9giCMfEC0SFQDjwDg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.15, round #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 11:02=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Paolo,
>
> Here's a single rather urgent fix for 6.15 that addresses boot failures
> from the PV MIDR infrastructure. Catalin has reviewed the patch and
> asked I grab it since it's the end of the working week for him.

Done now, thanks for your patience.

Paolo

> Please pull.
>
> Thanks,
> Oliver
>
> The following changes since commit a344e258acb0a7f0e7ed10a795c52d1baf7051=
64:
>
>   KVM: arm64: Use acquire/release to communicate FF-A version negotiation=
 (2025-04-07 15:03:34 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.15-2
>
> for you to fetch changes up to 117c3b21d3c79af56750f18a54f2c468f30c8a45:
>
>   arm64: Rework checks for broken Cavium HW in the PI code (2025-04-18 13=
:51:07 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.15, round #2
>
>  - Single fix for broken usage of 'multi-MIDR' infrastructure in PI
>    code, adding an open-coded erratum check for everyone's favorite pile
>    of sand: Cavium ThunderX
>
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       arm64: Rework checks for broken Cavium HW in the PI code
>
>  arch/arm64/include/asm/mmu.h      | 11 -----------
>  arch/arm64/kernel/cpu_errata.c    |  2 +-
>  arch/arm64/kernel/image-vars.h    |  4 ----
>  arch/arm64/kernel/pi/map_kernel.c | 25 ++++++++++++++++++++++++-
>  4 files changed, 25 insertions(+), 17 deletions(-)
>


