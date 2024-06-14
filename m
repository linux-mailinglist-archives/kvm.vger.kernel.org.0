Return-Path: <kvm+bounces-19703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 207FA90910E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 19:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495781C2171F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 17:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B6C19B3D4;
	Fri, 14 Jun 2024 17:07:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD225190477;
	Fri, 14 Jun 2024 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384836; cv=none; b=hggx5W+oQQgorIOqYi5FoyStpZEJFHd8ymyzaLPFP0ngkpApZitV9dfDH9Zn3i9zcZTe+NVZG7QvlwBX1u1BnWahsbqp5Rn1WxyNZWh3S0+F5ssaJ8Zd+bDLd6H9yTjqi0w9pJNf+5glWpp8m9FEq6j8YowCigT6N0qX/F9wsfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384836; c=relaxed/simple;
	bh=Q6U/TdZ2CTp4sXiVMsx5KpxiGQwk2iooiwW5HAl94pM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aZUCXKNpS7ctDLeZm7Rd5Qa21LjjBZ8toWo1NrXP1TBeU3PhBhrpNXJiWWP2FjD7P5n9ylzP/QyyMhsx2krybQbhe3XXEr+1RV2U4mQlJvgujll6Te1v4E1MyZo/210usiroXVX1Lg/JIkk90G59HE7OQ09qgnpb3NxB782ai+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-6e9f52e99c2so1828521a12.1;
        Fri, 14 Jun 2024 10:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718384834; x=1718989634;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIflfkviGH+bFJjeADGjhBwgRHGZW0prdlPc1tZ3sB4=;
        b=lvNFCF9PfSJPvbAUxH1mtEu6Nqy/24RaJCQx4LHFIpf0Ecb+QJecoKTn66VdGHHfgT
         o4pWnYRK3Kvc3v+4JDcAAFgucirpSYGNnBDIdwbF1hvbMvM0CT2Yn/++GpQkr0CdEPzV
         OULUthwXikosDL2L3o/CvNHD89PsCqO4LZR81EG+0QEZAeVRb8Jeavatl1Mq6hzo/Vtl
         96YTJTHme9NSzOhUldmAkKVU5pGPKmg0a/QkP1FvqQgKDIXcHI2Glkd8iklOSs8xYtBl
         7pMlR4vhxbDqhgE+iXCsqkAA6NxWu39OAS1T+6wU6VYtqYD358Wwj/vTl1b/YzmgprdE
         KYWA==
X-Forwarded-Encrypted: i=1; AJvYcCV+xtEry3hEgHm7//2/6QrZG+CVRVO+NBrZ7pDXKzfvKei8OY4AiKHcAkG/e/thgCcZ3Z+h0oapEU22RECsyez+GGFX
X-Gm-Message-State: AOJu0YzgPaVidhP09hGa9bQE2t1sa13yzuXGL1Fp9K6npTSdU57qmylz
	dXHfV/WY02eMfN+B/B5H+Xc45KmBZVgncTA8y/mPdvX5bWUnRJoMANHq8U3f
X-Google-Smtp-Source: AGHT+IHkKzAS1OVpoDPONGBYFKBJxXpBXklCrLiSJ/OEEAJOTdRGDyQUz2ZqCb5TSjox76It/J/lkQ==
X-Received: by 2002:a17:90b:692:b0:2c4:af82:32af with SMTP id 98e67ed59e1d1-2c4db449cd3mr3149185a91.22.1718384833367;
        Fri, 14 Jun 2024 10:07:13 -0700 (PDT)
Received: from localhost (fpd11144dd.ap.nuro.jp. [209.17.68.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fedd21591csm2817902a12.14.2024.06.14.10.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 10:07:12 -0700 (PDT)
Date: Sat, 15 Jun 2024 02:07:10 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To: Linux PCI <linux-pci@vger.kernel.org>,
	Linux IOMMU <iommu@lists.linux.dev>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?B?SsO2cmc=?= Roedel <jroedel@suse.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: The VFIO/IOMMU/PCI MC at LPC 2024 - Call for Papers
Message-ID: <20240614170710.GA1796784@rocinante>
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

The Linux Plumbers Conference returns this year and will take place in
September in Vienna, Austria.  The conference registration is open, and if
you plan to attend, make sure to book attendance as soon as possible to
secure a spot for yourself.

More details are available at https://lpc.events.

As it has been a tradition for almost half a decade, the VFIO/IOMMU/PCI
micro-conference will return to this year's Linux Plumbers Conference!

That said, I am thrilled to announce that the Call for Papers (CfP) is open!

If you would like to submit a talk for the MC, please follow the process at
https://lpc.events/event/18/abstracts, selecting "VFIO/IOMMU/PCI MC" from
the list of available tracks.

The deadline for talk proposal submission is mid-July (15th to be more
precise), so only a few weeks are left!  Remember: you can submit the
proposal early and refine it later; there will be time.  So, don't
hesitate!

You can find the complete MC proposal at:

  https://drive.google.com/file/d/1-1bJHnWCQOLSjhzTU9_bLLLMhX3Tj4hG

Thank you for your help, and see you at the LPC 2024!

	Alex, Bjorn, Jörg, Lorenzo and Krzysztof

