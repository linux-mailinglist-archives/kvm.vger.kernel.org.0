Return-Path: <kvm+bounces-65891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 949A5CB9C4E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 21:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BF5C5300B680
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 20:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626DA3126BE;
	Fri, 12 Dec 2025 20:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EmiD+Q8F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DB730BBA3
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 20:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765571404; cv=none; b=mix2oz8ro65L6zo87QSIApXH+/FUxwC9XOB7enBca6J8h/piU3xYwUNGuWjhM9qOAB8ru3ZkGl2Uhla2pK5BL8T1ATY6fKI+0axOlQQo/tIao9ggINXn3TWbrepqj5qAkGOsOroDSWeRXl+KelF1MeYzr6bZqPqHV4OryW5feJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765571404; c=relaxed/simple;
	bh=ovPDDBDay26a3+eGDiFu4QvB1wANKfFVQsCpr8lljp0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=R27XVmWQTe2I8MuUI7lNcaq8WxdTOugCITDX0OeYZmRnuehWZXxGlxwFbn0aQUB9sgcRGXRZsyjCMQnVmOEtuDA2rhDQDwFB/iVFZ4do/j3+kFR+MelJllDMHt4iQzG5PPZUmFUtcaZL8G4+67HzeXYmYFI0XcoXk/ZlLI8CSwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EmiD+Q8F; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c6d917f184so1321188a34.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 12:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765571401; x=1766176201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IMNyF6rnk7IasEWeVI8MWH21McRpJbckeB5bd8oSwWI=;
        b=EmiD+Q8FMvn6GGdxf5U9UR6Uo4mYeMEpbyNqXHgWZoIr/EXJPqGo/aZavdgcT/7E0L
         UNb6jMIa0VQqwRa3WicHt+3JuzyzLr2N/NvF95WLRMXXdAyd+vfowNW/OFUiVoHFozMi
         kEBbZKmvzS1GsZ/tQupy5n6crYEbM7wpPZZZQDEdcHSqa2vq7uu2zRp7AXDBgKO9DDdP
         uprEQJAfOY/b7cMjDfGktcGO0rIc2pOf+37AZUSZFFHxAdh201pq0aweHQsnozH3ZA4u
         MZeRNZ04C8MYOi2mYpNktDk0HYssmG4aesuMnSOtDrdRfudIsUuACRsImO8UxhSK51HH
         mz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765571401; x=1766176201;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMNyF6rnk7IasEWeVI8MWH21McRpJbckeB5bd8oSwWI=;
        b=cQvaFrhPBcpjDSMepzlZm80JJJtRhfQRjD6jM/2Nt1sldTqlfB79z9lHIuOB6GqMg7
         qLvZ/B+q8Fx6FNqb/xni7x7o7ZqVg+UWDF3oWEqP3s9w2oFvd7MtL4D1mHiXh2odeoQh
         MnY13QAuBIZkS/ln2mr5ztbn40gcticp0oQPxZXm29Y1NLwnSSpoW7sTlu97fRFlqttQ
         3lKdhh8uutXBsXH8BsQRYIXO0R2/ljHs9hN7IQC2KvL/2SZT7ZGmfbf/lAym2pdjxExl
         O37FHALBbA9naggsf1m51jbf3M7tTQ5loPCTPLYAbT8hIr9wxT53esCwm+uei7OmkE2k
         780g==
X-Gm-Message-State: AOJu0YwGuTtKTS/I+tRMiZxx5dLwe5E8RKjjRs527f6XcANIJNjfYjsu
	ROe7NidUkKLCPI/+QJJX3dLIij0eSAHN841QqGiawfPlonWd2d7J6uWpY0ciU5u3fDbYJjUZ+h+
	EHVDaev1pc0CbnPm43Yh/4a/J5w==
X-Google-Smtp-Source: AGHT+IHCc2P1hnQfNfNIerRNuvTcLdQFAWD/TzzhCNvUPfhQTb3KYPRTL0VnqSzv7pNym78BlH1sW72DFgyhEDe6qA==
X-Received: from ilbbn5.prod.google.com ([2002:a05:6e02:3385:b0:438:15d1:5e1c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:178c:b0:659:9a49:90bf with SMTP id 006d021491bc7-65b451e95f7mr1599664eaf.62.1765571400768;
 Fri, 12 Dec 2025 12:30:00 -0800 (PST)
Date: Fri, 12 Dec 2025 20:29:59 +0000
In-Reply-To: <202512110439.UXwb1Qh4-lkp@intel.com> (message from kernel test
 robot on Thu, 11 Dec 2025 04:21:58 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt1pkz4f5k.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 09/24] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: kernel test robot <lkp@intel.com>
Cc: kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, skhan@linuxfoundation.org, 
	gankulkarni@os.amperecomputing.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

kernel test robot <lkp@intel.com> writes:

> Hi Colton,

> kernel test robot noticed the following build warnings:

> [auto build test WARNING on ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d]

> url:     
> https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20251210-055309
> base:   ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
> patch link:     
> https://lore.kernel.org/r/20251209205121.1871534-10-coltonlewis%40google.com
> patch subject: [PATCH v5 09/24] perf: arm_pmuv3: Keep out of guest  
> counter partition
> config: arm64-defconfig  
> (https://download.01.org/0day-ci/archive/20251211/202512110439.UXwb1Qh4-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build):  
> (https://download.01.org/0day-ci/archive/20251211/202512110439.UXwb1Qh4-lkp@intel.com/reproduce)

> If you fix the issue in a separate patch/commit (i.e. not just a new  
> version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes:  
> https://lore.kernel.org/oe-kbuild-all/202512110439.UXwb1Qh4-lkp@intel.com/

> All warnings (new ones prefixed by >>):

>>> Warning: arch/arm64/kvm/pmu-direct.c:75 function parameter 'pmu' not  
>>> described in 'kvm_pmu_guest_counter_mask'

Just a missing argument description in the comment. Fixed


> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

