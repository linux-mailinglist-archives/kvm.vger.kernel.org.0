Return-Path: <kvm+bounces-24963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA87495D9D9
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9881C2830BA
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9E71C8FBD;
	Fri, 23 Aug 2024 23:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADoCk1pm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8170179AA
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456882; cv=none; b=u/e8CW4Od7UohxuybTWukSm5Bt/VEOfQ+yeZFWrErnB3FMquQxUt26VTMrfrB8s/cqN4gS8dsUJCcn84/b2RbS2TWY3SgyEXN55aaHOWBan3564qPr5MBL9BeJeVgrrs3/fpr0H+o8rjpk+tSKmqcPKsgksjbO9yfT+blYizduU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456882; c=relaxed/simple;
	bh=5XmtJ+ttxT4Nha4VWrlkTnwO0YvxeSg3ElrNh99k48A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dFjbw/VXxG7wbN2Xiyqga6lwxP+KNGuKrfQqnq47rvaw2DnvBIrtPGbcvGbsgeZdUZ5AUfu3d7IwqdMrAy664TDRn2XlFaF/tqFeh65nodKqexs29iMTj59OotCqPiKp+615ilOj8pYqNTRAICOGzK2PoqetfQqOItk3vJrtZtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADoCk1pm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7b696999c65so2244584a12.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456880; x=1725061680; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QWl9TNT1aQv8v1R1jPYvMONnU3dZkO4ks1eiFaeIIxQ=;
        b=ADoCk1pmFykDiyfEwtbtYxu8PtoAB6fP91J+Z2cZlUoxMSiX2yvxxQ3LzKEyVWx0ip
         9j83cOpmW24VjGvsKhGN+G8/ITLrHVndg4f2uZ4gFGJ7/JiQpTOm4Na6oJrZXWKuMk2F
         c1ENcOKg7eZ+Ekxm9ywtTN8Qx0n/AS1QhDqp8oQlvtAujvddX08OpEWTap/JzsoqRLH6
         PtRaIsSbxRY8P5bFa2HTCFGurYZYiRlYDaqAFMEmodf6IbhBGDCBvGEBeZF7pKG9/AGB
         w8VmrjhQEaCG7dhEGw649ayunTLBN1UDWSoppbXsyIoQ2MMTDYnNinGwNXiaQ1jRbu5G
         AqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456880; x=1725061680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWl9TNT1aQv8v1R1jPYvMONnU3dZkO4ks1eiFaeIIxQ=;
        b=sRwzelYwgUayToHBlCY3W1K3xzDSckiNJfreIdS6To+fYZkXsiCuMer15Eioa3B+3/
         A9llL6jVf2+MbLHblOjK9RhYsuLlu1XjwIrnWUpvA2amRubMTP7Lr8mvhw2lPo5tYc5F
         n5DGRZ/ANZzz70+v1+jfH3s6IT0vxBnrYEKyjkwd5HGw52qzh2AKlVWg+JkOgU2WGPZc
         RoVc5YJyB1xl0ITJPLld1S5jIfnBQ1cLVgPESSy1Bz9EULpd5iG4Y8jefzymR8Vt++fR
         ZsgKuuHr1A3PPM0mfQpYdVJymH2qsQldnTIir8jDw56Ox9J/LRXNZDlr9ogJq24o3z3H
         jpYg==
X-Forwarded-Encrypted: i=1; AJvYcCUEGfN+mXjlxSC/XqyYYYZXFD8XdKL1eIMXjp/aaxOv4TkeKtq/bE1jXwoICsMJIzsG5L8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcQuP9htARMTQOlBMb+noaVIZ6+ak2spV7HqD+mDoOhnXr2ZsO
	gMONh94SFF7pdzK6xcMccpM96BR1vYwQSoJXljYTjdTtv+Qt4Fey7TTT32rilCLcFT1x/FkAXIB
	LHQ==
X-Google-Smtp-Source: AGHT+IF2N1obNYfDZfwu5m+pmo9znzxpNwbLxyRSQf9o3PYyvEV1svuRtClslNgdxG2L20PJVpMD0UgmoPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6910:0:b0:7cd:712c:b65c with SMTP id
 41be03b00d2f7-7cf54eb7a3amr5875a12.10.1724456879752; Fri, 23 Aug 2024
 16:47:59 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:35 -0700
In-Reply-To: <20240808062937.1149-1-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443900380.4130468.16617420818094069311.b4-ty@google.com>
Subject: Re: [PATCH v4 0/4] x86/cpu: Add Bus Lock Detect support for AMD
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	jmattson@google.com, Ravi Bangoria <ravi.bangoria@amd.com>
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org, 
	james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com, 
	j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com, 
	michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com, 
	manali.shukla@amd.com
Content-Type: text/plain; charset="utf-8"

On Thu, 08 Aug 2024 06:29:33 +0000, Ravi Bangoria wrote:
> Add Bus Lock Detect (called Bus Lock Trap in AMD docs) support for AMD
> platforms. Bus Lock Detect is enumerated with CPUID Fn0000_0007_ECX_x0
> bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
> When enabled, hardware clears DR6[11] and raises a #DB exception on
> occurrence of Bus Lock if CPL > 0. More detail about the feature can be
> found in AMD APM:
> 
> [...]

Applied patch 3 to kvm-x86 fixes, thanks!

[3/4] KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is missing
      https://github.com/kvm-x86/linux/commit/54950bfe2b69

--
https://github.com/kvm-x86/linux/tree/next

