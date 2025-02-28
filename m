Return-Path: <kvm+bounces-39725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB736A49B2A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 15:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F151C1897945
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 14:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A8426D5D2;
	Fri, 28 Feb 2025 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J1MqU4Ty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924102557A
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740751248; cv=none; b=mQgSs8z2TePFy2TupwSDtksMNEjJeqyXF86P17dnbcr7KIPP3RddFRv6P6P3Py/yMpVTdSFkxNk4RF3W8zX7o7/WtDKpJMSEipiXE1AYBsh1MDGAwEeAgzHJaF1hIAKGKNmZh8VHJY1Z86C8HhJfJbh7sFomhGHwLzro7vCLyi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740751248; c=relaxed/simple;
	bh=nLsYFA+9Uq+V/E+xYSh9uoNX7fENRkgSpLxOK3Ox7Hg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mb/8TIbakCVLXtM7JjdnF6GRT66La9OS2xPB6StZEbkafBPqhx68pQX8fQGJzllC3rgiJrpslQerCwarHVjtbRmSPl9XneM9uaKGm3sjzq342ZyCrj5oN+98rl49bEkDD+OKF7PJegxP+YE5Yfi72kslCmHoUB5LZ0imRnuJDZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J1MqU4Ty; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso7663063a91.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 06:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740751247; x=1741356047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DyKtF19JR26GWiT169e8Z3znTSlUX9yl7SG7SduZ39o=;
        b=J1MqU4TyxbDhntM51vCssY8ewuGrhEL7hdKW55QihLbZwOkkDbZDhg1KPRbsqvbrcl
         RJRsKU+/hD8uvmc5bslED4fDRY2Yl2NtaulFNVvmbDxOZSOV213yD4uGl5+Ar6M/Kdo1
         UR6pS01xzwTpvWumnzfBBFLXfYVPX2gu+cjcm9tiKhvbHQLE5y+b8Qm5glNUqzp8YGzR
         ZLOudi9lkCP0FXGZr309KfRsn20fWyN0Rs7/ZKGfhOsRneniOqc6Fm+hVuKT7q4T4BxL
         xahw+8ErKjtFwVgSSxM17j8Ks3Hq6qBSYkzd9+KZ/doDNGJqkEYTJaggW+PDpZ9IRTDl
         opyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740751247; x=1741356047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DyKtF19JR26GWiT169e8Z3znTSlUX9yl7SG7SduZ39o=;
        b=EnC21bJC4Tkq+LrKvtLMU+M6S0SmXsY74XNEV5FJOWR/v/kuYkffFvtsGT54yAU6gW
         dXbD1nTDj/fTwcH28RaO6ln98vMlIxVFj5Tl61QCtH2j3qEEqDc8bogrFCQXp7tL0fPp
         zry8P//qpeg8g+K3SkF5IGcYZ44hSysml+hs8quW906nwakO+8EqKBW77q7fyu5NOMqL
         js48parve8eM7WMajTyqg/TGe0BUOzC45zEubx0MJi1zEU6p+TqKTL3wytWejfszjchT
         s21nwzHUYiigD95M5MEg0J1BHc1jVu4inaWnQI2x9QqqurQbIP3f0sySaHKvfpp0tQ4Z
         lH8w==
X-Forwarded-Encrypted: i=1; AJvYcCXTqHj5aRnnj56CzzVyfkgy+BT+OrbYTYKStiGvncRPrlbpZbziV3nU2ptWsEiHWldtdAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXe152zLKATHkmNxZUqT9j+KLUa0fr6QgDPm1pYd5XgVnd0Eap
	Ei3tL/NSO6yve/UMjzdPECsgONj7kr2vjHPuYZ/nt00uJCMgk0uYS9zDjk9bZsa4PohSlU+vnvK
	+SA==
X-Google-Smtp-Source: AGHT+IEwF64TMkso0dQJEFb+wyg3aT7hGwiirxJOIpxtqZPpJrizTUlV9LHpZapcLsVpoJixPPP1NIe6hRk=
X-Received: from pfoi25.prod.google.com ([2002:aa7:87d9:0:b0:730:7648:7a74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3287:b0:1ee:8520:f979
 with SMTP id adf61e73a8af0-1f2f4e4c806mr7311947637.36.1740751246899; Fri, 28
 Feb 2025 06:00:46 -0800 (PST)
Date: Fri, 28 Feb 2025 06:00:39 -0800
In-Reply-To: <Z8GWHkpSt+zPf+SQ@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250208105318.16861-1-yan.y.zhao@intel.com> <Z75y90KM_fE6H1cJ@google.com>
 <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com> <Z79rx0H1aByewj5X@google.com>
 <Z7/8EOKH5Z1iShQB@yzhao56-desk.sh.intel.com> <Z8Dkmu_57EmWUdk5@google.com> <Z8GWHkpSt+zPf+SQ@yzhao56-desk.sh.intel.com>
Message-ID: <Z8HBh1WR3CqcJkJQ@google.com>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 28, 2025, Yan Zhao wrote:
> On Thu, Feb 27, 2025 at 02:18:02PM -0800, Sean Christopherson wrote:
> > On Thu, Feb 27, 2025, Yan Zhao wrote:
> So, I think the right one is:
> -	} while (!READ_ONCE(mprotect_ro_done));
> +	} while (!READ_ONCE(mprotect_ro_done) || !READ_ONCE(all_vcpus_hit_ro_fault));

/double facepalm

You're 100% correct.  I did most of my testing with just the all_vcpus_hit_ro_fault
check, and then botched things when adding back mprotect_ro_done.

