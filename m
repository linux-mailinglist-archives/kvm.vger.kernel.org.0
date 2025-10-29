Return-Path: <kvm+bounces-61387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8FDC19DD8
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 11:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8684467879
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 10:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7EA32ABF6;
	Wed, 29 Oct 2025 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3DBtGnp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1940E2DC76B
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 10:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761734626; cv=none; b=YntwrmlHyOcpLpS1VILaEEgYwPkvoxRjbMMosSGzn4win1sxH4zxrf52pKRx/1TW9/nm41ppe+oNbEB2OOCSk8/6B1qMvjHEO30QTNW36le12Z0YZQqfzWlTv9ioXoOEKu286uaULVZ1e3PBcEzw6fUzaVH3Dv5b8PLzK8RbN80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761734626; c=relaxed/simple;
	bh=2oXoC0z5iX1QVctIx7be9YVECKd3qVj+JpFkjgooT/U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VRLOuKTIyDAu9mzKoKO1aqa4hLwY+QeLd90m9mK/OUAdNkSjb+KsotUKVpAVcSQNpAA3pZUJI+Z7laBSSqDoIu0bJRjPakwhIcumFqgGa1AZcFBQM/a8rUti+XG3TgdhRglf4xYH6uWufHL0ulYik10SafXf4RAIhkK0geLYrcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3DBtGnp; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4298b49f103so2502487f8f.2
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 03:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761734623; x=1762339423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcoHF11ENhR3RrvSYHkD59wUi5AUsDEUQzjKh8Eb0i0=;
        b=U3DBtGnptuySBoVepvxKVciNuLzjA4f+SKmg7g0BuvrqxoloHXBwdNA4F5FVVCuN+m
         1OwQBQa5qhU0MeU+d76nXZSnLq7PB/YuyGIP1pJXy3iyX3gEx9MEnemTqtUjKhN49EN6
         DasjY9uQPLGuNmoirYLtOW/dJIQWucjbtN9CTAueSGTy0ndPvH1XxEYwVbSmXaGhu2Jw
         hHBpgJ5xPuM7HF21x+HBYQLeUR69iT/pj3Uo0Gmopkrz2U1yU9aYn0d7dQFocRu9MR6I
         oHNmYdf0QkWCSgXT3avcBe6Fu//CH4fk198qQ+d448V0TzqNfY/CZ/cX8jsIzAmOJl/o
         GptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761734623; x=1762339423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcoHF11ENhR3RrvSYHkD59wUi5AUsDEUQzjKh8Eb0i0=;
        b=HaGkMfqNwIVmVXjwIt+q4WT28bTdUH76nVk3z9Ajb7GWwWnCys7NyDVOsElAfB/g/Z
         0PPsmQkhhWP+UKlAG7E3l/x48ndpwCOdo8bcHdH5GToJDdjPEzqcXI6RRVoRxKnBXho6
         F21y/qCihBx6bDgk0b/5HNj6K1Jp90fPKTq99DD/AZ3D76x/cji4ICEFxDCR6ia+aJVg
         GBT4p9eJFMVLG0vTQedNl2+sO39l6Xt7mcxKTKId/aDLn54d1S6EieJA4MwQA8XAqNh7
         gjyavjfBIN0ouVPmER7a1biu+pnXGSHJsepUMUoXxBOL/VA/SYG/iwpjPCFMUC5akYrA
         tTqg==
X-Forwarded-Encrypted: i=1; AJvYcCU1npYADmmjRFh6NWhDwa9volsLnTLi3hhoiVoeuO/N9dZ0fLYn4ATtKPAgwKi8gXlMEBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcpnzXU3dZEpng4mN4IR7e4TZO3wEkFaiUQ7hNokX723i1F6WF
	inDzKdozzQOIAcyBfGeiZOc1RgUm2Ga9pmMO2+QRI0cE4TvmxTqEZtjj
X-Gm-Gg: ASbGnctDflXQU9Gq1Knm9CjgmLxW+eDY/iiwuhxTR+g41tNfEfLt3M2fkvjLFvHBXem
	KxrG6vxfuegr+l5dFxIqYaoS8rnQOV+RIILWI6R9fBAKHNLYGNLMBzMU5+lfgvxZ9PrQdg2REE1
	TKEwKi82cZDUjxNZt58GURz/cZPtdIeBjw7uRUg3V3Xe9PclTufLCHuLnwmNYUxUYt8+PZlIIp+
	W3X8fEpCX4frXzbWjBqBXPeZXBl8df/l9px6dqqEh+XHIqaJ7xl4cB8rgogS4jXS6p7M+vEfZWO
	tv7SBrTzXhrlpj0XZWwPBHJlTgeEIihF/ehkIl4/XYk6jmaXWmm/3b6Sdkp5qhE4hr2ctfuzLKc
	yaEnfhYii7KwHXCupksciKXH0UykKAAoULYnRCohfpWBi3vjjMf1IzxjJlUrJiw2FA3n1BPhziz
	MP3+mi
X-Google-Smtp-Source: AGHT+IEmRI4Z/M00oieKbPxeIQldJKpH25/9dKm0itRMgfx3Wj6z2aQjBwr5JnK2lV2Z2mKsh3XAaQ==
X-Received: by 2002:a05:6000:240f:b0:427:a27:3a6c with SMTP id ffacd0b85a97d-429aefda93bmr1775484f8f.63.1761734623193;
        Wed, 29 Oct 2025 03:43:43 -0700 (PDT)
Received: from vasant-suse.suse.org ([81.95.8.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm28137267f8f.45.2025.10.29.03.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:43:42 -0700 (PDT)
From: vsntk18@gmail.com
To: ashish.kalra@amd.com
Cc: Sairaj.ArunKodilkar@amd.com,
	Vasant.Hegde@amd.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	iommu@lists.linux.dev,
	john.allen@amd.com,
	joro@8bytes.org,
	kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	michael.roth@amd.com,
	pbonzini@redhat.com,
	robin.murphy@arm.com,
	seanjc@google.com,
	suravee.suthikulpanit@amd.com,
	thomas.lendacky@amd.com,
	will@kernel.org
Subject: Re: [PATCH v6 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Wed, 29 Oct 2025 11:43:42 +0100
Message-Id: <20251029104342.47980-1-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com>
References: <d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

   these changes seem to have been overwritten after
   459daec42ea0c("crypto: ccp - Cache SEV platform status and platform state")
   has been merged upstream.

   I can send a patch if that's not been done already. Please let me know.

Thanks,
Vasant


