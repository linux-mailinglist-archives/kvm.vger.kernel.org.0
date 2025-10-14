Return-Path: <kvm+bounces-60024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5F8BDB0C3
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 63AB034C313
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C612BE650;
	Tue, 14 Oct 2025 19:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="obYExmlM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB11E7C27
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 19:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760469775; cv=none; b=VmGU8EPH2IEDWnImiyiIHBvO5CwL6Bwoz48l8Op1eoOll6U4dyE71Gyq+/jYXIXTg2Uk3u8eEQkOJG72mlNG8W3Mh1/zNzMNb2XZUzvcVEpAyuwrt7E/8Hdn8uuA/0AijoQGRryIBbhJGmreBZUn2Yxi0aE+AwftJ4KrfPy089M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760469775; c=relaxed/simple;
	bh=l6juafGELsVObwsxqbOsopDkLJ6EE8TwmjE0qsXHS2A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qThuvHgugXQps6HfUScrnUFDdCiYSYIFNbKqFZbEvPd/tLKMmA9yVTL3CDnozQt3ELTwooOLqVlDLAKXHzzCTIGilep6jxMisQV6leFvejxuAo4PTd4J24F76RgsrCixY0usRAXGbXDplfjVfAqYW6IzvZweTytfJgd7FyVWgfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=obYExmlM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339ee7532b9so26338611a91.3
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 12:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760469773; x=1761074573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ty45We9EhDsxty9VpPsw+pOMgMD/LR+AXX3ZKgkWc0=;
        b=obYExmlMfxn/JlcPweA8nHm1sxQI3ZuERUdss7YcvN4pIAbRKHVcneBrt7QoAZVRLs
         tMnnS5LppZmet3AVYJjhEtDPMSyoM047rRMHiEcp5FabjnKKxewkoN28Tw0m7RaWrMhd
         FpmgcIJLfLS4EUpvhmyyYr4cfaJxpXFiaPVEvLvIqQ3A7cELOqapziC/wlxL5ZG9ku2+
         U2bQ5qYdSICXN/2x9FAenkY/ZBkTFYZiAcktNa9UjBN63UMdI7CkUu25tDKx97cXRhOP
         ztAjsM7dNIeuHNcS2+NMvx6BapNcs/1E/NjPkqiC6blG6FNcRd+qu86mcqc4G2l+ARUR
         ykGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760469773; x=1761074573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ty45We9EhDsxty9VpPsw+pOMgMD/LR+AXX3ZKgkWc0=;
        b=gcOzh2+ICbMLF4bBgCo6N9ip4SBHi4Xu33S3W7nKECFO8lpR68K6W8p9Hb+R8vWQwh
         HaYebqxhMWBjDvCio06c4sbYueUmb/8fjjlQdEQ5vc3S1TpQcOjnlmjjpwB0Rv6fQjb1
         F20xWj6cUvL08Ko7e6W/NPU8KR1K7+U1joiHGyfqEqL0nGhoNJLsGEhY0kFIW4n/AyaJ
         6AYKETPeN1ijuXGHExdWiDTdU4uaveotwhIsXjTiFHndgGj90R8zkuuaghpEA6S5zR1r
         FLyaBFc00VDFBe0WeaFO1CpcY3m/XImbf6bQHaaJ/H79aZOcHzTYDtChKHarnnb51AhV
         ZpxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl5D/EoES3yDpfnsID1bZnDzqKnesYGfg10j8TKyZ4GHpwyzj7h5XWuMFJ1K7cTyGP7Uk=@vger.kernel.org
X-Gm-Message-State: AOJu0YycWmhUl+yT0WXLJbRyWdTfsqndnq72kc8BiN0a4mYB6LBGaMQy
	QpZrK5P6mCWkhYJBLNqLy0eTDl2k27vyz6igOji67gBqb5Qv9jbT9Y/klRfAvf3+1mJ5C1EKS4d
	xyAiOtA==
X-Google-Smtp-Source: AGHT+IFmN/oYYMYFuZcILsz+CJNyh/Vn0uL6/R9I0iRCsCYGOyrFRSINxR7t4ozioFZ0DWo1I7BMqz8w6vw=
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:334:1935:56cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3911:b0:32e:7512:b680
 with SMTP id 98e67ed59e1d1-33b51106b22mr33845034a91.1.1760469773096; Tue, 14
 Oct 2025 12:22:53 -0700 (PDT)
Date: Tue, 14 Oct 2025 12:22:51 -0700
In-Reply-To: <c6d0df58437e0f76ce9bdf0c3b7f5b53c81989a9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013062515.3712430-1-nikunj@amd.com> <20251013062515.3712430-4-nikunj@amd.com>
 <c6d0df58437e0f76ce9bdf0c3b7f5b53c81989a9.camel@intel.com>
Message-ID: <aO6jC_UEH13oWIs0@google.com>
Subject: Re: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86 code
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "nikunj@amd.com" <nikunj@amd.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, 
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 14, 2025, Kai Huang wrote:
> On Mon, 2025-10-13 at 06:25 +0000, Nikunj A Dadhania wrote:
> > Move the enable_pml module parameter from VMX-specific code to common x86
> > KVM code. This allows both VMX and SVM implementations to access the same
> > PML enable/disable control.
> > 
> > No functional change, just code reorganization to support shared PML
> > infrastructure.
> > 
> > Suggested-by: Kai Huang <kai.huang@intel.com>
> 
> For the record :-)
> 
> When I moved the 'enable_pml' from VMX to x86 in the diff I attached to v6
> was purely because vmx_update_cpu_dirty_logging() checks 'enable_pml' and
> after it got moved to x86 the new kvm_vcpu_update_cpu_dirty_logging() also
> needed to use it (for the sake of just moving code).
> 
> I didn't mean to suggest to use a common boolean in x86 and let SVM/VMX
> code to access it, since the downside is we need to export it.  But I
> think it's not a bad idea either.

Ya.  At some point it might makes sense to define "struct kvm_params", a la
"kvm_caps" and "kvm_host_values", so that we don't need a pile of one-off exports.
I'm not sure I'm entirely in favor of that idea though, as I think it'd be a net
negative for overall code readability.  And with EXPORT_SYMBOL_FOR_KVM_INTERNAL,
exports feel a lot less gross :-)


