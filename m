Return-Path: <kvm+bounces-62248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C4CC3E020
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 01:45:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FDAB188B12C
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 00:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E762E62CF;
	Fri,  7 Nov 2025 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d+E/aN7x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C272857CA
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 00:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476293; cv=none; b=G2cjqoOeB78ARdGZcK2Cs/DylD7Qt6tM2zSx3Q3yvzcnXrFO/jQ72AoI3EyXEx26FzaYUjTtVR7RP/CpiVrGkXpumJVuKTj3rGSqN+2txNwSI8SCfLiIHHZ+YWDwiwJv6+3PXV7zt7ZjzCafPRwo43Cn5PgP00zYI97hi2BGXcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476293; c=relaxed/simple;
	bh=5K/96wvWgT/tr739PKgS2vReih0PG6EAGbybEdDCOR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBTpNL4qd+utm5VDWVWPsk7jK6oTW8pYRlnohJo2z9a7OgPiTh3pPmhl7u026TtfU18iea4DM3JQVZPIX9yU9BNuCHCkp5cjezSIR1o63hQVCE8p+j3peD48y5CfcBvnvACJoHzwjOjxZ2KktseeSW/r3sliCiw3mVktXMypqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d+E/aN7x; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-33067909400so187746a91.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 16:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762476291; x=1763081091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZxEQwudOCfHw07Q15hA7q5sXo7hmUKvy1motLcLA9I=;
        b=d+E/aN7xR1CBxaDfpAuvvkx3wbLDObdGuJZpDPCeclf5jaNu9azZLt6duTlKqB38ds
         X7YiimNEL1SjxOFq7sCmWBgSWavyPFR9eViRLn4xTGmnscDndRjbBb1vON+Nri6ntg4o
         +Uku+1IoeAv61Q58SzH0mMCVlssX0EgeMxM7zV8Ete+DXWUayVZro0SXsH4SmhvEB6mj
         6mfBbqB9FUdncIMv/+kVAJhfc1fBtJ1NId9+EQyWLsubB7i0UevutVRsHlrzQ2M1NAZk
         JFA3AE8RpP4M1M1WYiAhQJUgrALR/btrukl6Z9STEeDM3utIodvfF+pQS5KmB7tWBurn
         tvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762476291; x=1763081091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ZxEQwudOCfHw07Q15hA7q5sXo7hmUKvy1motLcLA9I=;
        b=XsMfoVXJITnmxLex5DllYqZl9GKP6lqKuJk5NvjAeSzDIoyAQbuO4p+8gT91JRu1pC
         BB1hdYNWnTWLS0a067xrxlDjRYZiQ9GOGe1Zwj/+A/GgaOIzIfMyrJXOxKgMnXdEVchf
         FMvX3DnfvnFGrYb0DOevn+wyzkVbW6WlZlaXVC/dF+YgADQkm9AHkt7ARnspMbOXFYqG
         nHfwLziLB3DqXy3gbkhRJOiWYnT/RcEOiBkMdHG9PDL0qy6wfRsQ6h6dxzC6sh2alL6x
         eE1foZ4TbcYoamjqB+G/+RPjsErMJdR/p97fxWla7qLVGOFo/6+Gdh/mMSiAUuHgAfn/
         6r+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUc8g7uYF2yTW9GidoccXNPmje6/aTCqC07twL7S8lEFO2Edx+SaZZxVGBqJZXRwglcO38=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdIDUApoMmyDzQh8jj4rk+vzTKxKQelRL/icE8FMrCv/78J49H
	ByfhfbAloSi76jOW8Wt+k1dqamYbKW3CZh1mogw/x9jepm+IdDQ5xu/wE5ApLUKfLA==
X-Gm-Gg: ASbGncsIVYZNtTJSHaf8fq/BqoSjQMLP8DF0fHNgi7orlZcD+qU3rSNjmn7p/qQ+Mfy
	6Z0x+lv2zIK+wzllDqZz2j4f1nQes4vkMECITVOOyDc89xLttL6PII+vsIC/95HiJ0P+USdGina
	0SkZee7lmF1rEdIcLOPsaR5HCVWPsj75cyk5yUO5sMihQainbcUx4dpVzeFiHtMtwwG5FXloO6G
	gYE40ilIEKKsA7V0hg+MDxGyiHUXivzD9pwGjfwayFGaV4mYq9CuFqUesyLVGvpptno7G2t9F+Z
	tT4BooKnHF6VEVyzJrZ+QUfKNokxWhFq8MEDvmqp9SjWO0To5kCV1lFliUS3yKur2BbJfJpH+oa
	qDiRh1YdeUl0kesKGLlPxlaDZm9AGbF52WEA0fdJKKN6PdYoK5JxFmCCsmSnSVwjI7FiessK7Wt
	jnaVRRVTSczHBO70saVvgRU0U3MuIlBbWqVYdrIpW1798UGNNmecYd
X-Google-Smtp-Source: AGHT+IHSAzcRTzsn4152VkBYv6RCsQ83TfDSRyvlGR+AZG6R3bypq+4AhiefhHJKc2IDulPKmb5IZw==
X-Received: by 2002:a17:90b:3512:b0:341:8c15:959e with SMTP id 98e67ed59e1d1-3434c54db8bmr1473740a91.17.1762476291066;
        Thu, 06 Nov 2025 16:44:51 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341d1375e70sm1870285a91.5.2025.11.06.16.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 16:44:49 -0800 (PST)
Date: Fri, 7 Nov 2025 00:44:45 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aQ1A_XQAyFqD5s77@google.com>
References: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>

On 2025-10-28 09:14 AM, Alex Mastro wrote:

> This series spends the first couple commits making mechanical
> preparations before the fix lands in the third commit. Selftests are
> added in the last two commits.

Hi Alex,

The new unmap_range and unmap_all selftests are failing for me. They all fail
when attempting to map in region at the top of the IOVA address space.

Here's one example:

$ ./run.sh -d 0000:6a:01.0 -- ./vfio_dma_mapping_test -r vfio_dma_map_limit_test.iommufd.unmap_range
+ echo "vfio-pci" > /sys/bus/pci/devices/0000:6a:01.0/driver_override
+ echo "0000:6a:01.0" > /sys/bus/pci/drivers/vfio-pci/bind

TAP version 13
1..1
# Starting 1 tests from 1 test cases.
#  RUN           vfio_dma_map_limit_test.iommufd.unmap_range ...
Driver found: dsa
tools/testing/selftests/vfio/lib/include/vfio_util.h:219: Assertion Failure

  Expression: __vfio_pci_dma_map(device, region) == 0
  Observed: 0xffffffffffffffea == 0
  [errno: 22 - Invalid argument]

# unmap_range: Test failed
#          FAIL  vfio_dma_map_limit_test.iommufd.unmap_range
not ok 1 vfio_dma_map_limit_test.iommufd.unmap_range
# FAILED: 0 / 1 tests passed.
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
+ echo "0000:6a:01.0" > /sys/bus/pci/drivers/vfio-pci/unbind
+ echo "" > /sys/bus/pci/devices/0000:6a:01.0/driver_override

I am testing at the tip of Linus' tree at commit a1388fcb52fc ("Merge tag
'libcrypto-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux").

