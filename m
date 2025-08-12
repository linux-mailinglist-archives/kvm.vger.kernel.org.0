Return-Path: <kvm+bounces-54537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C45B22FF1
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8161E566028
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14F02FE570;
	Tue, 12 Aug 2025 17:45:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBB92E4248;
	Tue, 12 Aug 2025 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020711; cv=none; b=NuJoo+yhRDWFMPvlD7xoJXH3UdLIaAouWdGm0jhc+KP9kN44o2swV3jQTkQ8wiYuUBKA8VXzJH50VQxHekTxW/xKPzTT1WmBnBNy/29j/7vXJ8KAV2bH2IKe8CgTy+UD6/LY3gh1ulKYVJZJj/FMsazt/H8oJuItV8LgdkycOPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020711; c=relaxed/simple;
	bh=eySWvu6D2G+rUPX+8K39gjMe9CUI5RHiIFd1y9r7B6k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HUey6N760VfuCpmaduwJPaG59sJEIi0SAnK84GMA6OnRNlQiKtmm1FF5Sa9kHC1SRVZOSyTuELSQgJezEsua15V0B2jzrdqABMsL919Wy9C2PSsEH5kzWW+HARSI5G84iiRHx9q+AyVTC7AXgIAeKZtVMMbgF13YawPe0k0halI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b429b2470b7so3815606a12.3;
        Tue, 12 Aug 2025 10:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755020709; x=1755625509;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmYFxaQaG6Ge1u212H8n0v8lC5zbtgjVzdaqY71rvgY=;
        b=i68RXk4FemB1Rgpe4S5beyDnhw8czxBgcFMgWdSH6E1mqQWLndQLo+fp6TouH8MHWw
         sPHYd5lfppX2gnoHNQRuw/hQxUgS3oz4nNq0r+PJA5Z054VMEdx2VELxjsiROIrz59Gu
         S37GeVfLyRVvxBwCz5jyOZTLhyhNhifdcltHCuB+Wi9R/gfNF5suTtiglPoLu0sWc+3f
         dtlsUvdSdy75M4mclsWzn9LCzoCU1YP4XtsY/oP6i9/QB00hlHDy8m+DLRKiLPM8hgrV
         nanAtNjlGJ+QjMBxZbUhbmOr1vpY6nQm9nuU+XYi8luYwFvpWIWiq1qIjnN1Zzrw9Jwc
         UHQw==
X-Forwarded-Encrypted: i=1; AJvYcCVjuhJOKY0dFkDtIvAYioy2QTq7Bnx7U4JyDHaONOGDPYFj8ZuCged8ny7W4Xj/MYgOlV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYlVdWYOP/bKeNOr53GoDsYmtuy6ZqtG3a0r8BjMB88GtveT3/
	rULe9nzRTyVWjCCvtIvgfnX2A6RaqetztIQxDuDPjMOBIGtL6tct1f4fLjYNPeYv
X-Gm-Gg: ASbGnctyTGMHvDMbK1JhiJUGsnEwGlurre0r4yMc2vSE4V7NJHV2UTFIGzhjRxojht6
	Ds6YCFewemP8NM9MXVwGQyC8+lOTLRrDPnoWbZQS4GBWPdhjXRCYV372huL2f4qmOYUlpkI1UdK
	jP6i5lorUnktzUH01rA98ibFluYEQsYxbiOvxmIh72wbweh3mXhvdjSy0o1qu4f8AfI67abwLL8
	PtvM/8l7CTSyU8ZqSbbHanl9KR1kyrnKWj36i2hf9tjm/sHOuRqadFf7qm5mc4wBtE74B2l/VXz
	Lz10dEGySAfrLoD6+BwVMjGiGzM9T/XkZM7Ias+L2FqI/T86aOK83l2k3CHa5Iq9E2RWfn7XlYn
	ayPcXbOKrJfXsfwv2pW9KnrJTOnEKiHRsl1CnPyVLMCzijuAqD6N9m7W3ZA==
X-Google-Smtp-Source: AGHT+IFmpr89BCHty+5y7Jx5cKjOzvj7jSGWi9gqY9TLJzLs/GRC8uzyhVcwbrBQipVlogt9TDUHqQ==
X-Received: by 2002:a17:90b:4cd1:b0:312:f2ee:a895 with SMTP id 98e67ed59e1d1-321cf9e87dcmr552975a91.31.1755020708889;
        Tue, 12 Aug 2025 10:45:08 -0700 (PDT)
Received: from localhost (fpd11144dd.ap.nuro.jp. [209.17.68.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3216125b7b5sm17519891a91.20.2025.08.12.10.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 10:45:08 -0700 (PDT)
Date: Wed, 13 Aug 2025 02:45:06 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To: Linux PCI <linux-pci@vger.kernel.org>,
	Linux IOMMU <iommu@lists.linux.dev>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?B?SsO2cmc=?= Roedel <jroedel@suse.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: The VFIO/IOMMU/PCI MC at LPC 2025 - Call for Papers
Message-ID: <20250812174506.GA3633156@rocinante>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello everyone!

On behalf of the PCI subsystem maintainers, I would like to invite everyone
to join our VFIO/IOMMU/PCI MC (micro-conference) this year, which will be
held at the Linux Plumbers Conference (LPC) 2025!

The LPC conference itself will be held this year on 11th, 12th and 13th of
December this year in Tokyo, Japan.  Both in-person and remote attendees
are welcome.  See the https://lpc.events web page for more details and
latest updates.

You can find the complete MC proposal at:

  https://lpc.events/event/19/contributions/1993

Plus, as a PDF document attached to this e-mail.

If you are interested in participating in our MC and have topics to propose,
please use the official Call for Proposals (CfP) process available at:

  https://lpc.events/event/19/abstracts

The deadline for proposal submissions is late September (2025-09-30).

Make sure to select the "VFIO/IOMMU/PCI MC" in the Track drop down menu to
submit the proposal against the correct track.

Remember: you can submit the proposal early and refine it later; there will
be time.  So, don't hesitate!

As always, please get in touch with me directly, or with any other
organisers, if you need any assistance or have any questions.

Looking forward to seeing you all there, either in Tokyo in-person or
virtually!

Thank you!

          Alex, Bjorn, Jörg, Lorenzo and Krzysztof

