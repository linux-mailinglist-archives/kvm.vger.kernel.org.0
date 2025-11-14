Return-Path: <kvm+bounces-63164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F844C5AD78
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0255434161D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAE4246BBA;
	Fri, 14 Nov 2025 00:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtoLyqgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD53212B0A
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081229; cv=none; b=aZDdqvK5vkG2sCRX1Z94V01kP1LigyCnqzOnPV9s/TgbFZGCv8OSPvnU0F4zjWE5K/eoc/D9BfbAFp/LfB6k9TLskXRizgPFBuL/67xjjCZv6F8d2KIXH9Zk1XzJepciZb8JCzNBYwIijrvgV1h4mjkg+xpiqTdYoa/g00IHT3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081229; c=relaxed/simple;
	bh=CIufkXRLONXib6fu5gDZXdB+j2ftfrvv9f06e1iT43E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o7XpMgUWyqfFeJIzUa9OEkyTXxazvhheMc2ij+tVHN0y9qkvpwbUwa29grjoaUk1MfljO2HC1I+i4s2+S05WdWlaiKb/z0h9u6jZMotr6YWsUZMUJt0l/4F5O7FKqwsacT370ewutUVywmAxauptklOWkwx9ykaWT1u4uFLZsI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtoLyqgC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso2035620a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081227; x=1763686027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uu0f+8FT098XyFBWGKODIVkOPsA0MWGmtKhUFD0Zpmg=;
        b=NtoLyqgCF2fis93GrN/zR2RM9T5aMCAXPLgFJRqpPkgCqI6tsNtohHQShC3+IvCpny
         9Vcr9LtHLkot22GWqNXJZ5YbTHgfHo6SnSEaeN86yTZGlElcpjx/xwN/QpeuW/CBdcN2
         Mrl3OugGVDOHOSJawRLRRr4tAoVZGdYQsLKsFKog4/ifxpTUkvKKmRFZN52sJqOXHkSt
         4ZtOFpftoHMEfxH8AMCuptECvlcel/1aEk0gvAIDkU8eim4CsrfpIWjtwmLb+FXnMZ1x
         50f+uS/xW7GnMf9sBRcTuxeNSNdmBrvpVuP7fZo123ewhAyPzSgRa8Y6zZpqdvrqDRzo
         kYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081227; x=1763686027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uu0f+8FT098XyFBWGKODIVkOPsA0MWGmtKhUFD0Zpmg=;
        b=kqZz0ElPq4R6rXgkzmm6gdJDD73npicZzYFBVGVYSaQMkoiH9zNcRyeqfFWPSMuVZJ
         hNbB5ernu+Eu5lpEl/CTciD9bt+TFTjCvPIrbKYSkW3rSr/MuoKu0AIHr1+MgcYrtQSb
         yn/8t6TOSOfmhGa1FVCp9tujFir86RrH5X70x9/X+NZ0S+VPQU5EljWHQn82DS2igIUE
         h4hkON5RUwaEaotSXdgzgUwy3mWitaxF1GfcAnO+XVf5YjCmgc2TPpa4IGBS6kcsMOXI
         9G/KZNwa6sdL3zONaSncwA1VwBzGPuQ7EAWcM8EGRwVYvNueW1k4DM0/FY85oS7E8c51
         C5zg==
X-Forwarded-Encrypted: i=1; AJvYcCW6vM2KUIn1ITJM33YdW6gH7njHYMpMgi8OVkqGsoSWDBTLep9Jq4zVOd73AY3o0f6ZhfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW4wtMPonhc1mbU0CRAxbUch2GhIr6k1EFOxLb5zaPzLDgX1jP
	Duz84T/1y1oKlGLEzA9Gp+cVTxCSpwL3vWq9VkexKCI9sOTZCaJx77W/V4e7XnuWVW4VPoofERr
	sV098Aw==
X-Google-Smtp-Source: AGHT+IGrg/S/0/FUzu5qltFW2gVx60cteLEDepe2vELZC5gVE6TbDj7UaMEe/ZGCJ/cJ3eEMVS8ORVgVq4g=
X-Received: from pjzr16.prod.google.com ([2002:a17:90b:510:b0:343:a817:ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258f:b0:341:124f:4746
 with SMTP id 98e67ed59e1d1-343fa638f09mr1145356a91.31.1763081226986; Thu, 13
 Nov 2025 16:47:06 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:11 -0800
In-Reply-To: <20251113224639.2916783-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113224639.2916783-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176308087438.1726686.11210735704370607564.b4-ty@google.com>
Subject: Re: [kvm-unit-tests] x86/svm: Correctly extract the IP from LBR MSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 22:46:39 +0000, Yosry Ahmed wrote:
> Currently, only bit 63 is ignored when reading LBR MSRs. However,
> different AMD CPUs use upper bits of the MSR differently. For example,
> some Zen 4 processors document bit 63 in LASTBRACNHFROMIP and bits 63:61
> in LASTBRANCHTOIP to be reserved. On the other hand, some Zen 5
> processors bits 63:57 to be reserved in both MSRs.
> 
> Use the common denominator and always bits 63:57 when reading the LBR
> MSRs, which should be sufficient testing. This fixes the test flaking on
> some AMD processors that set bit 62 in LASTBRANCHTOIP.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86/svm: Correctly extract the IP from LBR MSRs
      https://github.com/kvm-x86/kvm-unit-tests/commit/9a7a0e188bd7

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

