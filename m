Return-Path: <kvm+bounces-30999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0551A9BF30F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31A7F1C21FCD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA88320493C;
	Wed,  6 Nov 2024 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkohO5bJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4442201021
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909861; cv=none; b=GVTy1wsNDoZ0IhcMrFTx0GkytbBHyiZZXSwDbgJzt2KCzcgYUNJcLancZ/91Vp86cEMBNqRl6/UKTb4wcnh/GNpYkbcZLcnV3OkvRdQw+Vf8RowrNFvJLJVaQkHp1JT+jMGZ8/P6udjZtsRzZqmkurJg0Xoe0pwZjwxVryr65gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909861; c=relaxed/simple;
	bh=fedLJeFnx53tF8ytv9N7sw3rQkKfQ5/ZXz2jxAZZFQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SNMMOo/Q8AVu+RtkjzOWR58+giNyPMzJYYAzzqlUqv97FiK8cDYW9R+0Q3yAiVgaQ2r3Lz4Ukf4bkoU2LH9mQsXXWCqI8dZ1ARhZLlRmUL7K0BmQHjfhYfQetsMj6954Ndsv+rRJBmmlSHgZmWrPZCZDgoLJHRDgctkuUbm8Tn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkohO5bJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e4ece7221so839457b3a.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 08:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730909859; x=1731514659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7gX7J5OfXehl+QPtww/mhm3dQ9/mVzO2E9r70KgS5Q=;
        b=DkohO5bJqXwWzFac5zoUiJ5rhZvfi9P9GYhc5ewv0BEa8pmOsTlugS0+kT/mNvw5J6
         U/ZDPZW7pRXgXroRXimlCADokrUoLACSO7Q5RDumcWy+Xy9Gk0TSaP/bc2n3NdmGvqjj
         3pHEnulgbiGoEuZUsCcgNZdmKZKQaMezXWVm+GqkVQ6sbx3rxBG8k21SU9GksRtfXoho
         K2byjFta4/p4YA/3KgvkDpx5NOUaQMixEvya6SbQQQlOBfZhbvRflHFCMnkWJ1hczucE
         iOk/0y5EPFZ48WZXH4vjoUeCQBjdM4bU4E+SQCR6K17kh70Crt4PG4MvMYihRqj41Hqb
         ejeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909859; x=1731514659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7gX7J5OfXehl+QPtww/mhm3dQ9/mVzO2E9r70KgS5Q=;
        b=cBeOKfatsHSC06wLq1jQhm/P37Lde55+yNNySGK21iShOZ5K4CVI8+/3DLiGTBs1ie
         w4XzhWlKpkz0KtbnY+/40jA7xDwo1dIaqNHlo9RgIJZVhVt3hIVeO6+PF+Wtv4ywI1Cc
         1hcDhaUp+XAje94rdvfnwME2HMIvMvMFA07EgBUcYCvwwBX7vn5gTk0m9bLDegTYaBAQ
         MOCliC72xvapb2rQG/YqcZKyLALf0txMHP9qfHF4QVth7/YVZUxK0bAegnSogzuzdWZO
         kpPvem1wGefO9egm9pheWP9wVn7X+/EpzgAPoOsTa3G2KWE6owzaT7ZjOQPKS5dXCZCH
         Inpw==
X-Forwarded-Encrypted: i=1; AJvYcCU5jySY6HsYpNfYuZs1yI4UtfVs596eEpaPYhQhI/VkbdAaCTkLQpBAI5ecNIXS6mYUA18=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWx90XNXPst5haqSa5beEGBi4sohfSHCZoMrlfgw4hAHoYGvsK
	iIDZxyYRmWPN1VcKLnCGnztRC88230IukgBmwFxUZTspQpsYh3if88YCca6oI+aR5FVmJfOKqyS
	c5Q==
X-Google-Smtp-Source: AGHT+IH5+RHugGjNIyOCE03q8z+Pnhir0c96MdXDK12iPCjoXlkZZlPPOs48lMhm932hF8zhCzkzRWOqcX0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6514:b0:71e:6a72:e9d with SMTP id
 d2e1a72fcca58-723f79ca4a4mr64927b3a.3.1730909859150; Wed, 06 Nov 2024
 08:17:39 -0800 (PST)
Date: Wed, 6 Nov 2024 08:17:38 -0800
In-Reply-To: <20241106161323.GGZyuVo2Vwg8CCIpxR@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZyltcHfyCiIXTsHu@google.com> <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
 <ZypfjFjk5XVL-Grv@google.com> <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com> <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
 <ZyuJQlZqLS6K8zN2@google.com> <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
 <ZyuMsz5p26h_XbRR@google.com> <20241106161323.GGZyuVo2Vwg8CCIpxR@fat_crate.local>
Message-ID: <ZyuWoiUf2ghGvj7s@google.com>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, kvm@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Borislav Petkov wrote:
> On Wed, Nov 06, 2024 at 07:35:15AM -0800, Sean Christopherson wrote:
> > You didn't though.  The original mail Cc'd kvm@, but neither Paolo nor I.
> 
> I think we established that tho - I didn't know that kvm@ doesn't CC you guys.

I do subscribe to kvm@, but it's a mailing list, not at alias like x86@.  AFAIK,
x86@ is unique in that regard.  In other words, I don't see a need to document
the kvm@ behavior, because that's the behavior for every L: entry in MAINTAINERS
except the few "L:	x86@kernel.org" cases.

