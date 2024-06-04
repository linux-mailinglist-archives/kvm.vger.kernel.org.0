Return-Path: <kvm+bounces-18822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBF38FBFFE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1D1828618D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8877114F10E;
	Tue,  4 Jun 2024 23:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuOSeUJZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D508F14EC66
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544308; cv=none; b=Dr6FxW/e/yHGALQtEl9u5RYnXdxVZrb8kmMO50dJgX2OjuG8wGE89YaplhpyNzvtqnC8aJ4WY7PnZDj1gRkpk8prpSBDQX8ArsSNcigC9TwB+g/vTMpZAQP9vG+5XZSQFt3miuHFLBM/Nxa2nm7RJ+q2O6HPNCIQUiwCQxm9rZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544308; c=relaxed/simple;
	bh=BwM/Os4KBTmVspcHVSCHvte4rPtpmmrdzsSMdfB8t54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NQ70UEFQjRuoBC5O8cdJov3qg7mdPVK2JraM54sc+pTarl+WIXd4OzXcHu+sBhBHs6Zh7Yu1VRB2UBIKM71m2i6NWlbbksr4ipWZmDYZNZWr6mUWzSjLfauw6BmZvfXUcCftDQVi8NsAQ2mv85kfuB7HEuaNyDCUtELrJdR3d60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IuOSeUJZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f6174d0421so27337715ad.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544306; x=1718149106; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ErQRA4AMy3XWNUVtztRHO4ECy31oAB3jfpLBipdw7ZE=;
        b=IuOSeUJZWZLs1rZM7UGBAWvyrYtiqqK29uaXyOVxhzSr4bz/ZKW/owGBaCYc0x3a78
         PcCfH1JEMCXVIiBuGQzmcnZ4G0wo+W9eUD3JVRH53njLrVlM5HAPVgS26dYq0r/ZZyla
         AZWGstH7cGJueRCVITVhCIUzuLE7nVPbjYEsVYGJ2KD2cM0NWtDXa27OX6qG8WuKIHUw
         dCFUEXLC/FhzV9pOsm5oNNCMJPILS48913GL6POCZAZmd3GNKsMWLwofqKQfhHyWJWXk
         mO81JECfCyjgHf6fGmwpKIRRdVwmFkiwD4lkB3n9Axza6mdZXctpLMG8UFuXKlZ4M8A+
         Rl5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544306; x=1718149106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ErQRA4AMy3XWNUVtztRHO4ECy31oAB3jfpLBipdw7ZE=;
        b=Is3yq4LJTYXagqzWmGKv8BG0q7Ats7ndv27e9vlwmWGtdM/FG4kYbSGGz7v/cxQ+Lt
         A/glpgQg+MDjBETAWLdDKOHMkg5lfyHQ8sxplsH7tvHG8WejrjR7XcuCiGSg4mqljUBW
         xqHLoYqeKeUjQWjgeXap9lH1wm3IN9aqRPIrwPlPyEK3ehy0mjL3D03I7uiTYw+7BD0g
         9R50RgJeNDmKjS2mLT2NPg8vvkDa0Nxu4O3H0MK0GIk++/G6ghZ4CQPsZZFtIDMkhTFr
         Z0njH/6RL42O0Oa1uo6ds1ZlOGqqZO2SLRW2f6wz48Q4mIe1rtb7T4i+8L7/y2HJexTQ
         53Wg==
X-Gm-Message-State: AOJu0Yw8Kb0V5RfawixOGLz9p9rBrVxppUiz94eRYne9Vq+4BtAiz08e
	eKxhclr/nHUurIPFKi93WRT5bWT+ttk8onFpMn+BsMWZgnRet4LhUVkrY9eWFXOFIBw7NrmYtva
	PRQ==
X-Google-Smtp-Source: AGHT+IHN3cqzNcnm3C3UZ1Isf/IVeA2/aICMXKNKfdksQ1tq7WWRpJ2J61he5DBCW5Wt08nJcw0DRAMYOyg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec81:b0:1f6:8033:f361 with SMTP id
 d9443c01a7336-1f6a5a12dcbmr287285ad.6.1717544306034; Tue, 04 Jun 2024
 16:38:26 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:35 -0700
In-Reply-To: <cover.1714081725.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1714081725.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754361450.2780320.9936421038178572773.b4-ty@google.com>
Subject: Re: [PATCH V5 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com, pbonzini@redhat.com, 
	erdemaktas@google.com, vkuznets@redhat.com, vannapurve@google.com, 
	jmattson@google.com, mlevitsk@redhat.com, xiaoyao.li@intel.com, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	Reinette Chatre <reinette.chatre@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 25 Apr 2024 15:06:58 -0700, Reinette Chatre wrote:
> Changes from v4:
> - v4: https://lore.kernel.org/lkml/cover.1711035400.git.reinette.chatre@intel.com/
> - Rename capability from KVM_CAP_X86_APIC_BUS_FREQUENCY to
>   KVM_CAP_X86_APIC_BUS_CYCLES_NS. (Xiaoyao Li).
> - Include "Testing" section in cover letter.
> - Add Rick's Reviewed-by tags.
> - Rebased on latest of "next" branch of https://github.com/kvm-x86/linux.git
> 
> [...]

Applied the KVM changes to kvm-x86 misc (I'm feeling lucky).  Please prioritize
refreshing the selftests patch, I'd like to get it applied sooner than later
for obvious reasons (I'm not feeling _that_ lucky).

[1/4] KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
      https://github.com/kvm-x86/linux/commit/41c7b1bb656c
[2/4] KVM: x86: Make nsec per APIC bus cycle a VM variable
      https://github.com/kvm-x86/linux/commit/01de6ce03b1e
[3/4] KVM: x86: Add a capability to configure bus frequency for APIC timer
      https://github.com/kvm-x86/linux/commit/937296fd3deb
[4/4] KVM: selftests: Add test for configure of x86 APIC bus frequency
      (not applied)

--
https://github.com/kvm-x86/linux/tree/next

