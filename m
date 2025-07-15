Return-Path: <kvm+bounces-52404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6944DB04CC9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5EB51A6808E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166D815624D;
	Tue, 15 Jul 2025 00:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LywTBn4k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC110E3
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 00:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752539018; cv=none; b=GVC3OkScJd/7AERjM0LwMSUbWq3KBEmaM0W5b7sL6HO7pFkDTlUZSv/i+YBe+/gWNijqYCAjKXvCXQzLde5xA8G1NF9+h2qyo7Gjn9o9y0A6uZpqZJVxOty/I6kgC6ZuaJxewSjPiXYZgZTo/Mh8QgeAgMNbqZcVBM4M0+YHAj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752539018; c=relaxed/simple;
	bh=FoFxgarM91o7PNWeWxxkOFiYYgc9SjBMk3YHyF1te9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CsUmzTe0PbuJyyo6tUGstq7IYw3HFrYr6TvqSDdX44f/TYsr/IJsecPh/vP60ty/VX2s5hdIN9W4uxDD4Mf4CNSBlJbH1+PG6O9ndYl7sj/Ax3yivkq7ZNrEmK0OlgkT85PK/4tNGBbdPsklOjepjyrIzgZzjX1ubNg2DK8D+7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LywTBn4k; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso7821746a91.1
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 17:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752539016; x=1753143816; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1Sx8v8BkbI+tNWtOcPfF0dRwgRjnfx2k5f4KxPLm+o=;
        b=LywTBn4ksAzDrvRsEVrxtmb4xxA9KZf9RqFkBcO6NMTVRz3ruunFeRFDJNybUWrw0R
         ejFu5/lfoJkSqwoIxXtC+4zZD4dmUlqEKXwUDkGikDNiZCaLrERI2FbFrw9Y5bg+ytE2
         Q6zZO7CdGhr/L6FLartuFDhEnCpW97B+5izppYivysrn16tjl9zAGK8367Ciw67TNBU3
         KXgmbPlofs3KYMefCyFdIIHQDCBTtA28k8mng+zJYjtFz0qrvbxU29wcr4qTb3CiygHv
         eS5GTgjQnmnQOBLuy0ThxHipNfQFb+Pl050jSSN3xtXr6z/F+AJgKRoW6CZq2mfk1WsN
         hD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752539016; x=1753143816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1Sx8v8BkbI+tNWtOcPfF0dRwgRjnfx2k5f4KxPLm+o=;
        b=XEe/TFfg9aYIH93EFgNX3N7ayCy5rIrtm4/Htcazbz0DQBkj9s23r6RhI6l6E7cOlT
         /bkCvxGcqW0GwFZdUspRU6i4PbUrRlPnPoizj/ZM1mZtio4xmH6cMK25pQoil5Ar1G02
         QiRLu9kWpKgWOx396qHSL3R6/VaWOm5en5cvFFCECtSMDyLgDJ94qSrxk8eUDww7khX+
         oN7Jn0oz0wisnTOs0U9tIkUsVhLMVKkagY5m1qJcHiOByxkFXbUw3xXzui0YFwwEkc0u
         Ci5nDQEXKUmP7Ue/sheeBJYhD6PqJ+N3FowE1KRkUUKbV8tzAzPb8MuwUlO6fYZLN8jE
         dAIg==
X-Gm-Message-State: AOJu0YzRCjiqNdBdR7hxgyZ9UMQGL5G8qh3WCgrtnTieJtf2CAl7Y1JD
	BG39EwyiNupvOTklpAsQkkh5oRvzhcTP4tUWGO/WpIdRr/9oikcoAkM0fsImk8MinzQwCQguO1b
	FPRhTEg==
X-Google-Smtp-Source: AGHT+IEUSBnPd7eOM7GhtRPOwcoXc0WmiyIR3AaHeXO4VnbeKOpBv43O19pa8I27YDeCE1pK+yt2uXecf74=
X-Received: from pjbcz11.prod.google.com ([2002:a17:90a:d44b:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5645:b0:311:f05b:86a5
 with SMTP id 98e67ed59e1d1-31c4c973dddmr24995827a91.0.1752539016273; Mon, 14
 Jul 2025 17:23:36 -0700 (PDT)
Date: Mon, 14 Jul 2025 17:23:28 -0700
In-Reply-To: <cover.1752444335.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752444335.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175253196286.1789819.9618704444430239046.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] Improve KVM_SET_TSC_KHZ handling for CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Kai Huang <kai.huang@intel.com>
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, nikunj@amd.com, bp@alien8.de, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, rick.p.edgecombe@intel.com, 
	chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 14 Jul 2025 10:20:18 +1200, Kai Huang wrote:
> This series follows Sean's suggestions [1][2] to:
> 
>  - Reject vCPU scope KVM_SET_TSC_KHZ ioctl for TSC protected vCPU
>  - Reject VM scope KVM_SET_TSC_KHZ ioctl when vCPUs have been created
> 
> .. in the discussion of SEV-SNP Secure TSC support series.
> 
> [...]

Applied patch 2 to kvm-x86 fixes, with a tweaked changelog to call out that
TDX support hasn't yet been released, i.e. that there is no established ABI
to break.

Applied patch 1 to kvm-x86 misc, with tweaked documentation to not imply that
userspace "must" invoke the ioctl.  I think this is the last patch I'll throw
into misc for 6.17?  So in theory, if it breaks userspace, I can simply
truncate it from the pull request.

[1/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created
      https://github.com/kvm-x86/linux/commit/dcbe5a466c12
[2/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest
      https://github.com/kvm-x86/linux/commit/e51cf184d90c

--
https://github.com/kvm-x86/linux/tree/next

