Return-Path: <kvm+bounces-60008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC1DBD8575
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 11:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5B1074F8B73
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 09:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D968E2E62C4;
	Tue, 14 Oct 2025 09:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aRg56eGe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C46C2DAFC8
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 09:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760432561; cv=none; b=qVm/pXbq+jVQIu2jkh/BHtxSN/G1uknHibzcLtdDe4dpvJHX+c/ROc0M/emGMM5uu00QcDQvQfRUtqdsevDOx+GgKqUcuVIJI0YF9KEGUM77hiyP+1LF675ZLjtG+YsladJi2cqm8oslzS8RU/UUx5DAcM0TS8vc1v3mY0vAsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760432561; c=relaxed/simple;
	bh=3DxPdjB8O0rEb9x+9kTSM/qDo37eqb9cY6rmjgwvPBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbOnLHv7hywDboY9UMM013GEVDBRxo9H6t5PZKBjhhx3DjrWoqwA8zUJAxa2eMmesnflQgfaFBFa3WY/z6r+UJyYeZRaeLfPLI6EcHoJWKyoMA7aPfSlNGcd9The6U7LY4r1dfyg9ih5k+VnWFTTAL+M4Pi59zOIDc0Q3AXDEPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aRg56eGe; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-426d3ee72f5so2371283f8f.2
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 02:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760432558; x=1761037358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WFy/F3Efn7AI8ZrVeO392LWuUGHpTkVCPmtJlwniUuA=;
        b=aRg56eGesDGIiPSsK8ohkwanPeP90J36N5tdf4kNYli5tv7zA8ddCaY9KN4J58rwnH
         ZBlvbDWyrEraMpNtZH9eRaf2s6HPKf47Q06sK+0MWOsjgdKoH8+xQFUnx/psK5KTeE58
         8ngpSGvpZSmFBsXMC9918s7IOsaOVhv9v3PCE/aUif6KbPgWXlBKRYcv4MUftxdc6uRI
         iReuGgFRRUF+7fWAfAvOwiGOmzQaDDVQidpH0BsajMCWJT/GcCElPuofp7qso/7or4fw
         HNW5b64/ABWyF/YbMYTCYvIRJgRe3LTwe3lb2pWC9EwhTbykKlgOpBg0i8nkO+5t7+Qi
         wDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760432558; x=1761037358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WFy/F3Efn7AI8ZrVeO392LWuUGHpTkVCPmtJlwniUuA=;
        b=DcoFAHTa4fITSlJG+9udmWezza9PF3SFcZKoK9i/hSRcePLlwd6U3pZoHI4ZYpNbnZ
         EcTVunGPX8SFgPzDoPXrsa6nhoHhJ/oxjD44TVuey9tCmWW4hX9rsK5vVsZMXeq0v1we
         4TsQ8gfzCp7lGUsJoB07gS2uEhwbAZ5PzX9bYVLv2+omn8vxFzTVPW4AqRPCdINviaCu
         9adhaEHUwzB0Q6ddcndZS9BHTBCi3bAzU/ASX5HOzcbeWQ+JbtftM+AqOreLQlN0uP0x
         ZoJpA7OvXkdAcxqdCcezFahIYCmSPD8o9X5pDW/2eK2GQMd+AyRz09yCcm3HoMjai+4D
         Hsrw==
X-Forwarded-Encrypted: i=1; AJvYcCVuQ8kju8pe+lyaiRO9Bw39fgr3PVlbsjYexAVD4svWhUq+HGpESwttInTgoTpYdxjm3/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyElaEo0WLf4/yybSOJBUt4QkrdcKZJuXwqOo/0JmoKOgQZtE3C
	uUC2uTbDMLM2TlThbU50MRC5CV9hTkj6PGzn9hwgWmHRzbBqubqvfQRQlh1bZ1WX0hbmgJCtpaN
	rC7j7Mt+JD20mGw==
X-Google-Smtp-Source: AGHT+IHXHqt3lzNbZ1Z+WmgocqXfHPbEfJ0BjUewzHFNlW7fihzTRZHXdjzVwfd8KIAJC4Tk2tsQ6+sU+2+Wvw==
X-Received: from wrpi10.prod.google.com ([2002:adf:efca:0:b0:3eb:a52a:8d03])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5c8a:0:b0:425:8125:ac79 with SMTP id ffacd0b85a97d-42666ab97f0mr15284902f8f.25.1760432557738;
 Tue, 14 Oct 2025 02:02:37 -0700 (PDT)
Date: Tue, 14 Oct 2025 09:02:37 +0000
In-Reply-To: <202510141438.OMSBOz6R-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com> <202510141438.OMSBOz6R-lkp@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDHX9C20UWUQ.2U72TLVPB31EQ@google.com>
Subject: Re: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: kernel test robot <lkp@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: <oe-kbuild-all@lists.linux.dev>, <linux-kernel@vger.kernel.org>, 
	<kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue Oct 14, 2025 at 7:24 AM UTC, kernel test robot wrote:
> Hi Brendan,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 6b36119b94d0b2bb8cea9d512017efafd461d6ac]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/KVM-x86-Unify-L1TF-flushing-under-per-CPU-variable/20251013-235118
> base:   6b36119b94d0b2bb8cea9d512017efafd461d6ac
> patch link:    https://lore.kernel.org/r/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a%40google.com
> patch subject: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
> config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251014/202510141438.OMSBOz6R-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251014/202510141438.OMSBOz6R-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510141438.OMSBOz6R-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>>> arch/x86/coco/tdx/tdx.c:471:12: error: conflicting types for 'read_msr'; have 'int(struct pt_regs *, struct ve_info *)'
>      471 | static int read_msr(struct pt_regs *regs, struct ve_info *ve)
>          |            ^~~~~~~~
>    In file included from arch/x86/include/asm/idtentry.h:15,
>                     from arch/x86/include/asm/traps.h:9,
>                     from arch/x86/coco/tdx/tdx.c:20:
>    arch/x86/include/asm/kvm_host.h:2320:29: note: previous definition of 'read_msr' with type 'long unsigned int(long unsigned int)'
>     2320 | static inline unsigned long read_msr(unsigned long msr)
>          |                             ^~~~~~~~

Yeah this is essentially just another symptom of the kvm_host.h abuse Sean
pointed out.

