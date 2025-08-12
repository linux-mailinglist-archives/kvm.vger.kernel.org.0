Return-Path: <kvm+bounces-54539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90636B2315A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2498016903A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925C72FF16E;
	Tue, 12 Aug 2025 18:00:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63802FE566;
	Tue, 12 Aug 2025 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021637; cv=none; b=RY2lkj3HL4KRjttvWoKoeuYh6x/IPvDZBBZDd37+uQNlaee76HSL+m5VjQoLdCI7g0ZY3qLTVjCG9ofFJhGtzgXQyBnavhaa7XworD80RqoMZxZvCGNaMB43aEGxybPy6fLycYoiQMLWgiq0kxk0eMgu3uUrwEtMw+PSjGhgcfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021637; c=relaxed/simple;
	bh=s5HtP8zgPfB8LKfRkpw96pL5pDbdt4mOdR/STsv8WgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zu0KCDSGoD1sbG0mmFb2RirhVY0Lq0SbLy6xBISVEnkKhrFoppRhJFnwsiN0peD9quJLKe7aKv//Tm6lyKLyMAxp86f4E0YyV4TKE5ofhx01l1+sKrW0/nhuiLRZ7egyPYpyrd6AaQg8VoT1smrg5nSrxlKW9nebLOnY2yz4GcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3219ffcada9so2026050a91.3;
        Tue, 12 Aug 2025 11:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021635; x=1755626435;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5Ko3ZCMWMZkG6/L2zPaHNNIdKij+I5lWVdC3qk6HiI=;
        b=qstecwPQrfz85+lAgls+ZmKcyHSasIQ99+GQxUKifMhCR3bEy0/xPvfUF8pg0/qWVc
         qErMLspqAWcwLw/7DkGnvZ2Y5EYhYs+sHXm6xVnwDaVVy/iGK+B3vn2waewodSh+NgXD
         ch++cxOB5L/VE/z5QgtR7McoWqWYSIws2KZXnCCp7wKLfRRgf9kYRM5Dpj3xt0ruXo1d
         baUjB+brYSixopVPMChZLY3zOr/pCdPhe9Tc+8h65mbscISO5zHLq3vOhYg3EnWAgpVE
         z6i5XavgE1D83VMk6LPvOJM+GU7XLLHwOU0hqAQV06NJ50Ok6dwky4WOowhdGth6YVwR
         pRow==
X-Forwarded-Encrypted: i=1; AJvYcCX01WBq8E1KTHnUKK5pDOQAoX+g4Txrteypre5MBggWl/9LoW269ijOSYxRgEL+hRTHXBo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywodcgq4q364d7Be3KN04DoJ52ZzN/RZm96E3/IPjLBj45q/8OQ
	M/Zuhyp632g4lRkUoSDmSX2y8O2fMMw7o780wPQMNqnJdPuvkBfvngJuuiaJHpU2
X-Gm-Gg: ASbGnctmw7XxC4SwjR0y2Tr62uSuCoLP3spGBjsidkYK4+QgPf8O6nc4VbQJnKiVvHM
	zwjwjA7iheKDJ89c5BDct7kxmiRBUUrkH4QbHlsDVN9f7GU0Ay8CNHU7NSatIfZsT2AjTahNUa1
	mdjLQBgJenpmtUFASs8fxyGPvv1azpT32iytliUUaSZS6Gyo6UxfdNggm6PFQ4YtiPtN2szr6YG
	CiMfzbZ2e51jx8sgeh4mM2OfZo/erhWXX+CkhvjNl53NYK9fWWsp8lJ1FwNBc0NDLuiuNVzmZMA
	rQ78dipypqfMvJbfn5z8h7X+XDhermSOKTh+D1f6XHeiASLAP7lTyThXy7ni6MPQkNweggmPMN2
	cE1vxXbtidjdnHmWJnE0/h4iSACv5TN659cr/jB9b0R7xz8ZygSxwV6vGwQ==
X-Google-Smtp-Source: AGHT+IGUwKjcxYIQjXRjsgyfhPfJbPlIzcS8JQODwmaqlP1k+KdKPRhYL2FuhDCZiKF95kOWUmZ07w==
X-Received: by 2002:a17:90b:5543:b0:312:e9bd:5d37 with SMTP id 98e67ed59e1d1-321d0d6719bmr718a91.6.1755021630632;
        Tue, 12 Aug 2025 11:00:30 -0700 (PDT)
Received: from localhost (fpd11144dd.ap.nuro.jp. [209.17.68.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-32161259329sm17810958a91.17.2025.08.12.11.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 11:00:30 -0700 (PDT)
Date: Wed, 13 Aug 2025 03:00:28 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To: Linux PCI <linux-pci@vger.kernel.org>,
	Linux IOMMU <iommu@lists.linux.dev>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?B?SsO2cmc=?= Roedel <joro@8bytes.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: The VFIO/IOMMU/PCI MC at LPC 2025 - Call for Papers
Message-ID: <20250812180028.GA4020767@rocinante>
References: <20250812174506.GA3633156@rocinante>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250812174506.GA3633156@rocinante>

Hello everyone,

Adding Jörg using his new e-mail address...

> On behalf of the PCI subsystem maintainers, I would like to invite everyone
> to join our VFIO/IOMMU/PCI MC (micro-conference) this year, which will be
> held at the Linux Plumbers Conference (LPC) 2025!
> 
> The LPC conference itself will be held this year on 11th, 12th and 13th of
> December this year in Tokyo, Japan.  Both in-person and remote attendees
> are welcome.  See the https://lpc.events web page for more details and
> latest updates.
> 
> You can find the complete MC proposal at:
> 
>   https://lpc.events/event/19/contributions/1993
> 
> Plus, as a PDF document attached to this e-mail.
> 
> If you are interested in participating in our MC and have topics to propose,
> please use the official Call for Proposals (CfP) process available at:
> 
>   https://lpc.events/event/19/abstracts
> 
> The deadline for proposal submissions is late September (2025-09-30).
> 
> Make sure to select the "VFIO/IOMMU/PCI MC" in the Track drop down menu to
> submit the proposal against the correct track.
> 
> Remember: you can submit the proposal early and refine it later; there will
> be time.  So, don't hesitate!
> 
> As always, please get in touch with me directly, or with any other
> organisers, if you need any assistance or have any questions.
> 
> Looking forward to seeing you all there, either in Tokyo in-person or
> virtually!
> 
> Thank you!
> 
>           Alex, Bjorn, Jörg, Lorenzo and Krzysztof

Sorry about this Jörg!

	Krzysztof

