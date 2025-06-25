Return-Path: <kvm+bounces-50762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C522AAE9110
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:27:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 455374A02A4
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0E52F3C05;
	Wed, 25 Jun 2025 22:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UoikHTMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DF02F3651
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890430; cv=none; b=Y8aQ/7r2iDTYu3riKRZRwP6N+eaZoepF2k20LxaWVNg+A6dts/gpBN6O043PHzgZ+/7UlkPi3Sw9I5tT9YscGolf45HgeJ3MDjM6LhElU8UoOerDTGdX/Cj+YB6qt8EIPMyjUWNLwvxsBMyTgcuUa7GzIrNU9DodVYVL1UXJEMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890430; c=relaxed/simple;
	bh=AgMIY7/alAyOVuvx/XYCb5AKG/9HuGSDAcN7JGIYOTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CzRQwL5/90H/JTQ3tdEgQwwQp74WqI4b6l5mcChJqSSboOdhXHygCs6wWt/mPbVUBURVKsGRokF7L2j+gqUVBf3KFDV3ffjoW8FZGZxaY+Iqpo+28zmOPn7ofVaW49bf87uUtphVIoB68BVpkNGLzEM/LnpB8ZhNy5BIQjO8Q94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UoikHTMX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740774348f6so280470b3a.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890428; x=1751495228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cAq5XqUsWKP02wGqBYM6J6LlRfdkCsvvuKjaBBLj1lY=;
        b=UoikHTMXlX2MFngXNgI1+SVPlgV1qdSwmAZnH/4+j3AHNxBmy/Ux6mZAcV3UU4jUC4
         VQPTFuiEo7rIrdIsZjKLli5TTgxvTtDL6VirIT2RsDkKYBB6dsN2QbSyPEu/4bnbjhx3
         I7fJ6vCrk3zVi+OUeF03uUowk3lFdU+ll5iN+HosI+fAzzS/llMhIBImLijyQBrr6yFf
         TfrR+GZC59kge07+7zb+SrwLMQLpwxcvAZ+z4zD41IBH63lJdnZx0f2CnpM62ksj3Yll
         eU0dyygAxbxOZdmt6ecuOjUDKZ8mc3RDdi67na1wwaG/zDnkA/Xp67CQbnIFKiA1704x
         KGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890428; x=1751495228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cAq5XqUsWKP02wGqBYM6J6LlRfdkCsvvuKjaBBLj1lY=;
        b=Ln2jxdvNemMqoOmIz5VzMHEEQNp3weErWz1nxjA2p+AgwTLvFi5fOsNGVbK7b6IZPf
         L9JAF2TQBVovHKHJm4+iFVUjjtLDoXsXMuoIXdGmxuv+KtFIHe7RKYWUF7al6QuL8z/i
         683NiiVXrmpalgKd6Qw9RqkWiiuBQOIdQ6fcqGIK2fZM87wmx580LFp/rlI+5XManmJ5
         tOX+n7kbCsycTXvMuLsZwkzNlW4J7b9gBtRdLR8Y5sTtH6X7C86+lkcxD2dECknGGtBB
         rHBLd3MV33Ij5rJd8UMTAKcTvUG863QdsgxWUhxx4Am9AsKIU6n3Woa4nTbZazec33tS
         HMvw==
X-Gm-Message-State: AOJu0YwrrF/z8t2OUJD/JzgyYkXA5fiJH2fKtSV86rRVroz7MESf2/BO
	6XiSw1l05xVjiiKuyF2M7K9l0xUoJHjuYBIsFh3HUT5gMI7PqS+khH8J8Y+eaMoYPvrV4beKCUB
	PkkuY2g==
X-Google-Smtp-Source: AGHT+IEa0LkgFKcL8sEPMtIemA3Ri5mNboFwmG0gnQyI/dNtc6popjMDMK9/SnJHlAcJLEXmS6VTsJsNduI=
X-Received: from pfbho11.prod.google.com ([2002:a05:6a00:880b:b0:747:aac7:7c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:729f:b0:1f5:8de8:3b1a
 with SMTP id adf61e73a8af0-2207f19c614mr7678920637.13.1750890428199; Wed, 25
 Jun 2025 15:27:08 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:39 -0700
In-Reply-To: <20250611075842.20959-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611075842.20959-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088941294.719342.11558920055184165961.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Verify all available GP counters
 in check_counters_many()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 11 Jun 2025 07:58:42 +0000, Dapeng Mi wrote:
> The intent of check_counters_many() is to verify all available counters
> can count correctly at the same time. So an alternative event should be
> picked to verify the avaialbe GP counter instead of skiping the counter
> if the initial event is not available.

Applied to kvm-x86 next, thanks!

[1/1] x86/pmu: Verify all available GP counters in check_counters_many()
      https://github.com/kvm-x86/kvm-unit-tests/commit/525bdb5d65d5

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

