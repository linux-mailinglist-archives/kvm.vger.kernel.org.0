Return-Path: <kvm+bounces-14778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 345718A6E40
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3428281483
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045C812C491;
	Tue, 16 Apr 2024 14:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eT8Ltiaw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F2212D1FD
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713277728; cv=none; b=FNBFoi5/LjY6wqEh/CjZJCqKRD0uu8ypBrIf2FJFWYyjKznEIL7NxxY2idOByLICDJ0ztfxNrEEe2vPaP0AVI72NHUvYmbRX0pqVCN6JB90A5eoaTx3T2nz7JtvtWYiofiHPeCZAJkglGg63J3kPx9fQZXUUFuiF7Bu9ndxwSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713277728; c=relaxed/simple;
	bh=Jns8AmEqmuJmtroLiyJfBw+gt2Dkhup/lrHLF/M5PTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIchVkKO9fl9THi9N713opsaHqYWYIrEMI/sYSbn6ciLzPl9br2Yrzu11jPzeaU/o6wBTN+S401RqZEpH/HvOZMvQ8aqSXFrBvhb3ln0K6AFw38phvzQnk6LGj1kHkwa4BF/kYxmPz4dRYYkPqcRsexj4kBSZxwqY6JheqtYeHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eT8Ltiaw; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-346406a5fb9so3471403f8f.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713277725; x=1713882525; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODh/R4bfK57i1Jc+tcGcRXOngX+xxVgLxwYp8nV0YkU=;
        b=eT8LtiawQsF1HpxRjP2RJBAioQYeR5+Ps1H/k3V1BxkJr+0oCsqvtYwoYDQO9zE4Ah
         4fOq0p58u+Zya8d5hhSo7F7Os9PkEiSD21OLBAgl/fRv+A3Sfh5T0prUyts8/FovK6Fa
         2ydsxK3oRpxgIiHK+1Iu//dua8YQMNxSRouYLIh73/02HBH0Nyn9zys3T6XO+dJQA+m5
         WGt7Yn8XOz9dF7pS0md2Cpn5XbVqhz2QTJgPTPUBV/gdcldBosjdIaC/L8MqN1zYBMoP
         xvpxVfm/ZOli00QS0/F0nJlE0X4Yos2EGHuTO/wi2C7o3u0ipdNKeP8dfkVumoVnvVYT
         HbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713277725; x=1713882525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODh/R4bfK57i1Jc+tcGcRXOngX+xxVgLxwYp8nV0YkU=;
        b=oV80gnNdgaYHywOzR1wwXAEIA1Sv7tvu+ORbYn8W7mHXwhpSZP2C2lUypVZuCuFAUh
         LVR1E3La8qWZTbyZajM1TFviMNAfH2fxr7iA7j3ovk7gsXVSq3TIPdIzKbbTnW/xoLTc
         hPw/51dHND8qmKcS/pswtz4kdE8OyoqbMUMWydpmhsXkxxDFpZmWjoDyb5K1Trsffrqc
         ciKDd7M/2m47ZjC7BJRIDURQpMdDqwhXRJHNXnRRpj28DuJJZcWTsTRnFyLkmfdaWnra
         CRxjre4agAGZBxjpBiRk1vV/i9jDKOtaQf0rhRa/XaAkLe03Ix1JMUL/UIdqiIdn6+ub
         LnUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQmzrXBHxw8J7IUQkk295M/LCzlCwzX8LsfbEyxv4+0VsQsb3Ro07TAVV5RcsS6wla21/wGplqylJZQmNDTLV+BG2a
X-Gm-Message-State: AOJu0YyG+88jRmk4HPbRMaygUK+jOUbnq90NzF1AnfqQVD870W3u9p8Y
	+b7cFO5JflOtGCqq2siMRhY9aOcnP24fCvm8NrQCl4ltyxZtHOb4Lz8XkLPdxpM=
X-Google-Smtp-Source: AGHT+IGBEcpM41oq6+uqCwJlNZfyCfSFjAcPSTPtMeeIgJSTr98uSVszWwBj9GJB4rj5Lkx3xI6IhQ==
X-Received: by 2002:adf:f4d0:0:b0:343:7cdc:458b with SMTP id h16-20020adff4d0000000b003437cdc458bmr9656332wrp.7.1713277724914;
        Tue, 16 Apr 2024 07:28:44 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id v17-20020a5d43d1000000b00347cf86dee6sm5769662wrr.71.2024.04.16.07.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 07:28:44 -0700 (PDT)
Date: Tue, 16 Apr 2024 15:28:57 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com,
	james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 00/33] Support for Arm Confidential
 Compute Architecture
Message-ID: <20240416142857.GA963176@myrica>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>

Hello,

On Fri, Apr 12, 2024 at 11:33:35AM +0100, Suzuki K Poulose wrote:
> This series adds support for running the kvm-unit-tests in the Arm CCA reference
> software architecture.
> 
> 
> The changes involve enlightening the boot/setup code with the Realm Service Interface
> (RSI). The series also includes new test cases that exercise the RSI calls.
> 
> Currently we only support "kvmtool" as the VMM for running Realms. There was
> an attempt to add support for running the test scripts using with kvmtool here [1],
> which hasn't progressed. It would be good to have that resolved, so that we can
> run all the tests without manually specifying the commandlines for each run.
> 
> For the purposes of running the Realm specific tests, we have added a "temporary"
> script "run-realm-tests" until the kvmtool support is added. We do not expect
> this to be merged.

The tests can also be run with QEMU, which requires one more patch to
share the chr-testdev DMA memory with the host. I pushed this and
additional tests here:
https://git.codelinaro.org/linaro/dcap/kvm-unit-tests

Follow the build instructions for QEMU:
https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU

Buildroot supports kvm-unit-tests but as standalone scripts. I prefer the
run_tests.sh script, which also enables comparing Realm measurements
between runs:

	./configure --arch=arm64 --cross-prefix=path/to/buildroot/host/bin/aarch64-buildroot-linux-gnu-
	make -j
	# copy everything to the shared directory, then modify config.mak
	sed -i -e "/PRETTY_PRINT_STACKS/s/yes/no/" \
               -e "/ERRATATXT/s/=.*/=errata.txt/"  \
               -e "/HOST/s/=.*/=aarch64/" \
               -e "/ARCH/s/=.*/=arm64/" \
               config.mak

	# Run all realm tests
	ACCEL=kvm MAX_SMP=8 ./run_tests.sh -v -g realms

Thanks,
Jean

