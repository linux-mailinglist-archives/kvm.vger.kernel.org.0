Return-Path: <kvm+bounces-58575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E25B96D3A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4711016692E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E219332340F;
	Tue, 23 Sep 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pfp9xoB2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20CA25B312
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644893; cv=none; b=B+BXjVGm01l3q13+1oiqM8WXBR+ZWTL4YvWrMrYm5lxK7ncqElOoMxNm1JVhBHnNzXE5ekYXM38Kz9vgvM0yNOHYiG1gyEByvXI9P5p8SKX83RwfjxeGzP2o5YpIOndcv2mtWD3YqZv4ji2giyX8QUcuD1ozT+jjhbk8gmiCU3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644893; c=relaxed/simple;
	bh=4np2wkKDt6W/4syS89Rp28z7eGj165wxMzc3Q7oON+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=srbUb/vUSff2umTydBBsLv286JUGCLKifhuUjzAJJsd/oHPIyY2RqUxMeGrZbXBpmJSUQCRNBZ+ZJ36hlE0OIwZ7p1S9dFY8XA8Z5EUqkWX1ggxQZemz4ijfODqQ0OMAoEvT1RV8RNfSwwArt254QU7F6IZUKGMKhN9p1BWR9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pfp9xoB2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f2d29dc2aso1942185b3a.0
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 09:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758644891; x=1759249691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1HEmm25r5KcPTR3FBQDysGSspUbCRvEgX0AYHZ6q6E=;
        b=pfp9xoB2+nN7icBT0LceGNubIl1Tjl9w0fiTMsqwIZPAV/Vk5aTE9YUice9RAx5yY+
         7T2nngA6usb9TQl2f2XyEHsphwicAQrcFt+APxQoGIqpHZjxhxBl7Ria9VtXA2Uq1lCe
         GxCtY+5jhdZ5qQntNcSM3/cHhQbcY9lEDlRVyTOK+nTTMVW+10u/EigSpKlJT7Cu0FED
         KLISEfjeHYYDBI2Hr8DLK0z9kalQk084xA7irwb/CwVstplUxNKcvvz16YI+RJ6RrDnA
         CLdZeKQinStDGk5brgVyjU6q2S2hHJT20vTJcMnccgLi73d27iJ0oQEy2GqxP5dk4hsU
         zb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644891; x=1759249691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1HEmm25r5KcPTR3FBQDysGSspUbCRvEgX0AYHZ6q6E=;
        b=k1Bvy852WgRkaPdW5QJvIdldlOBAUbNZF/S3yaZ2k5KUsPun5lP3gbyhLBg/sGrVjY
         TdWfqlPIyohl7NgskKYC3pJ21jTLGD4SjUYyfuV0MmiW+YxksdzdLPQWUOZB0JUHoNvF
         GGJxIMBX92y7FBBLvP8XyGxGDCu2kexsUi/XQy/DM5/av9rDyO4qm7ikOZsbQY6LgUKQ
         pfIEzoYNarJot0ts3eRC9jpZnsX1m0lEnHTMejSnTJqrlLcY4WScWkmnxijcx4op5MbX
         OeY7xHbOtAUyeqFrA0fyUDbjFq4DIt6wOy7XNNK29bmhw9JkEJcZkh7NuVZ2/MnMpI8g
         k+8g==
X-Forwarded-Encrypted: i=1; AJvYcCWZ6NjX9TYLJbojoO1kgIwiE62bKGMP3EuXVvVksKTpMyypeQ4Dffhe9rmlT12t7fgFrr4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm+AwmoRRBRfHWWJ0Oaj4J1Lje0LzDGJZOVW37ZZuNh+4n+O4N
	wl5jgF0/sZd4aiOjPjOBj7wTTRijwm+7WQG9sw5pPwENxv52fMVWUj2n0fj7AXKD/qT2+pu15Tp
	L/7wwuw==
X-Google-Smtp-Source: AGHT+IHx1drcB+12ihwrtisk8JEb7Xi0YVN2JOPO9iiRooccULaIcDKSUw3kAKz9gcHuWZx5ErT2yAW0g/0=
X-Received: from pfbeg23.prod.google.com ([2002:a05:6a00:8017:b0:77f:606b:78ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1398:b0:77e:7302:dbe7
 with SMTP id d2e1a72fcca58-77f53acdcdamr4124318b3a.27.1758644890871; Tue, 23
 Sep 2025 09:28:10 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:28:09 -0700
In-Reply-To: <aNIJawIapU86zXZG@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-35-seanjc@google.com>
 <aNIJawIapU86zXZG@intel.com>
Message-ID: <aNLKmQ5VQsoArdnJ@google.com>
Subject: Re: [PATCH v16 34/51] KVM: nVMX: Advertise new VM-Entry/Exit control
 bits for CET state
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Chao Gao wrote:
> > 	/* We support free control of debug control saving. */
> > 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
> > }
> >@@ -7200,11 +7204,16 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
> > #ifdef CONFIG_X86_64
> > 		VM_ENTRY_IA32E_MODE |
> > #endif
> >-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
> >+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
> >+		VM_ENTRY_LOAD_CET_STATE;
> > 	msrs->entry_ctls_high |=
> > 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> > 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
> > 
> >+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> >+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> >+		msrs->exit_ctls_high &= ~VM_ENTRY_LOAD_CET_STATE;
> 
> one copy-paste error here. s/exit_ctls_high/entry_ctls_high/

Thank you.  I distinctly remember _trying_ to be extra careful.  *sigh*

Fixup squashed.

