Return-Path: <kvm+bounces-56165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E7E1B3AA51
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8126C17D79D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 18:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B23B321434;
	Thu, 28 Aug 2025 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NLLMsTcy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D85278E41
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 18:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407054; cv=none; b=P2YdM5lMCdUMknO1JjQqcvMUS/n814aby79d5zZ5M3klLBF3x7X3w4uw0+qgkWtKrpUIGLw7kyBfmjTXOoNTPvbfWclmnTny+frMwa1ehF1trz7Y62af6kzdFqthiZ88YXK0Y/eJorp9dxuzKghe1TWE5tB3qb143QOup8l5BHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407054; c=relaxed/simple;
	bh=uMprsLdlUZHVQH3p/izRIbHQDv3IWlBF+WIzCbkppXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=boSEaLDcS0ZqsE+FfH6EKX16VwuxBTrFsedMiD4mlu7VYJfTqIKwf7ePygAGKggUwUIYY6x2BnbTWVMAfTBKvumSN8F9kF1iaTZndwfEyiC5cSrb1LLHyfM5CbfVU5pL1hErrv8nmrQnQE1NKQgirvh1nfgmY3HuC0vXJPNH23Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NLLMsTcy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806b18aso14711685ad.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 11:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756407052; x=1757011852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1rw97Jv7WO8rIxCRP/6iXIaLlr9MH2m86cuFa/MXV0=;
        b=NLLMsTcyMWs/HOIzSJ6XuaKXxtIyr0SGVrLBq69kueRBez0WcwQvAZoG9WmODTOIzD
         xiZkTXFn3OeOOLhH5Ef1Nqab1hal1v+lCOMJOq3UTVkqFtCI58Icq+/mfr9YMJINy4RF
         XHM2dZVv+psUwCzO0yWOOCmP+YTWtNc1D9N/nSfd8eOoDEJleBKr3u7hYrC8ip1U9PWz
         KBdDXh+y8cUy/phHeRGEp4hlYhrGxSbrCj1i/5Lhul5JhEATTUZKLKUmNtCEuDQQhQs9
         FWmM720MHRy0+QQSbMev7ssXelo4HSA7yfo2x7dwcfyDpsZFjWYOHzhbrvpKNORFQLln
         mvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407052; x=1757011852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1rw97Jv7WO8rIxCRP/6iXIaLlr9MH2m86cuFa/MXV0=;
        b=pxon/Ob0xZ8bOBI9l4LqB1WDG0Dns6Lg+C9IsUKjSMa/IIrlgcuU7uNtEh/n6Ps6rw
         H+0rg9tIZeSjc4U3alEsP99LgNazwmx3n1pe1zofHbAxqDTOezfugG3tHaIZO0yqS7Zt
         9oJEHsUCYUe/47ruFxqOvilF6nYuYH0UVZgWloms+0QveihagQ0e5buOtu8nw5DE3G06
         EV32JoNKIkARHPcggGqy6cVCc8yTOTrPpeXdqxa6oZk/tWmicTqiRlkso+UPEimsXkpa
         +9qg532UXvQ4n0wdWfOsGi8X0i5sf8ZrsE6rbqw2Lwya7NaSgrhcy3+m4rwjwJIr4MZB
         sLPA==
X-Forwarded-Encrypted: i=1; AJvYcCWbHgUhRgqOG2WXbXz3iW1R5FCJY6sgxxqVfoaEg+FCZnXr7Gu59NtiUOTs4X/JbqylTlc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiFXymrWR9zdad3dSPxkchwFd9Axc2wi2ZNx98R5J+4k1dEwzL
	FK0fE1Rl5zFcaRHuJ1JdGF+/hik/j30ELq9Prt5INgfuf4kf+jihus1O/mghzkUpE9yr2rUQW5C
	dDixOQQ==
X-Google-Smtp-Source: AGHT+IFZtOIBWH5nMa6NGPW/i9RAPDOqQQExWvsrON8HpUDCdiJQCG7zSV6Pl3SHf9QVpQqLPeYiu0FYvRs=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:327:be52:966d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c410:b0:240:3f0d:f470
 with SMTP id d9443c01a7336-2462ee50129mr348989685ad.20.1756407052469; Thu, 28
 Aug 2025 11:50:52 -0700 (PDT)
Date: Thu, 28 Aug 2025 11:50:51 -0700
In-Reply-To: <953ac19b2ff434a3abb3787720fefeef5ceda129.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-5-seanjc@google.com>
 <953ac19b2ff434a3abb3787720fefeef5ceda129.camel@intel.com>
Message-ID: <aLClCzTepEk7bczL@google.com>
Subject: Re: [RFC PATCH 04/12] KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_prefault_page()
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-08-26 at 17:05 -0700, Sean Christopherson wrote:
> > Rename kvm_tdp_map_page() to kvm_tdp_prefault_page() now that it's used
> > only by kvm_arch_vcpu_pre_fault_memory().
> > 
> > No functional change intended.
> 
> I realize you are just trying to do map->prefault here, but "page" seems
> redundant once you have "prefault" in the name. Why page here vs all the other
> fault handler functions without it?

kvm_tdp_prefault() feels a bit ambiguous/bare.  Many of the fault helpers do have
"page", it's just before the fault part.

  kvm_mmu_finish_page_fault
  kvm_handle_page_fault
  kvm_tdp_page_fault
  direct_page_fault
  nonpaging_page_fault
  kvm_tdp_mmu_page_fault

  (and probably more)

How about kvm_tdp_page_prefault()?  Or kvm_tdp_do_prefault(), but I think I like
kvm_tdp_page_prefault() a little more.

