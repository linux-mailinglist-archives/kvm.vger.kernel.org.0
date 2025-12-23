Return-Path: <kvm+bounces-66618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F17C0CDABA4
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B4623030DBD
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 22:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D6C313534;
	Tue, 23 Dec 2025 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sXgIMUl1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973F1B4138
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766527300; cv=none; b=AheT2Q+/PB89QNPEtiFYDjPu8svmGx85bxqT5mXctO2LGGXP2aTnx1Ur/OI4itkwqNwoDbIZjhH/Gx7O524GkEMPsvFP54GWNL8wJdLwZaWTJ7N2FlivhA+u+hiTcHfpmKrCGpUcsJ4n9lETgRGeRx6pLwphiEET/WNgrxxNBU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766527300; c=relaxed/simple;
	bh=9F9eURGFOff3cQlZn9grvIFNpql1OT9WXG/ntwKjl8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cIRL3Ci4/4A1qalW8CK9SoNtz5aawe6JNtEdL537siWggs2f758unk4WY8pCOhzrJbONirS7Azu+Gpq0JL86wc6ERVV1QbXQ6k1AUXzi+GTUvV2NqSk7Uu6T/xmobo+GKr88aVEJ5I5TfgH+cZPiOsO6YgnL3XE7IQHrzTrwKMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sXgIMUl1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso11360347a91.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 14:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766527298; x=1767132098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GGZpgMhK64OWkQYZhrJen2ci3XNs4FYonnkegJ6vLSo=;
        b=sXgIMUl1kr9MrborXEj06rAsa+lX51LSj9LgzCHD/QNzY2oTCZ2tfaNJiZ8hd7JifX
         6rcPaZ10pEcnzWHePaCpjcBfVBFN0y8LUXiKdjSC+sR8YO4GsKB+YkWDRu/IAmpOCHiv
         P4RiJwsJKIQDJ5Lysg0wYYtiM7TJkDHPejjQrzzGCVF//kqWipnk9R0x6T9BTRvh2qeQ
         0pHLJm65S2099W7uS2ytxDPcey5+Z/Dudd4+RoB6+CDQ4S9HEXIJvCcbBkuVMCSE3o0q
         HGCTyfYzlplvTr5QnhBlo742gK3Z4IE+1QGOPAr++lTEKjm7nxDXFUOXDoFwGk2Id7P3
         Av7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766527298; x=1767132098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GGZpgMhK64OWkQYZhrJen2ci3XNs4FYonnkegJ6vLSo=;
        b=VcuVuV1QzUHIX2OU3sYmztelRg+kEgwtTqtjvXREUYP6qqbPOyyiPIXAdMSsK4c2dP
         VpFSyz+fGiVgUIKh+n8Et2RKAwUuwTh99untHI22EGqxHTgOJjmv7zELO1fswALtkFUQ
         oqlMPiDkI7x02Sajf0IZB9x/IJoPGjrnkH9HEPyIPZQmD097ftixbgZwcZJIlOG3aD3a
         8Br6pkbLpJ8qztgC9U/aylRvpg9GwX3w9Iwer9QScgrR0pFIfzu9xadbtyzOcSTsyVu3
         4YmBV+ExCAX4IE1CPkoiSq4IGAf8ozhbgLvE9hJZoylT529eTF8Kk3dBVvOYJx/k9T7T
         KQuA==
X-Forwarded-Encrypted: i=1; AJvYcCWUGeR50dhkz0K6iIplbhy8xH8PJ7g+xT5k0i9hMmQYPs5fgAwJ3LGBfwDwxU8jiH8Fpgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYLExXJhc6VC+RiRXypmo/LbLotV1EPi2O7nymEggQyiB6f5h5
	CgIrFSFcrwB4Ji7BGFv+/iyfaM6XzR+y8Lsx9Zx7IomWu+TnTxopFkOcOknzbsmaTZhWIEFuJPN
	f+5IVOQ==
X-Google-Smtp-Source: AGHT+IFFx6Y86IQ/E0DR1ky5lBLtwAEFuu9yxgTVHqoBjxGymqVjYt3upCZoqmHRap9JFPIz4oR3FDiIrJc=
X-Received: from pjqo14.prod.google.com ([2002:a17:90a:ac0e:b0:34c:3cba:119d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c5:b0:34c:2db6:578f
 with SMTP id 98e67ed59e1d1-34e921b05eamr13823089a91.19.1766527298272; Tue, 23
 Dec 2025 14:01:38 -0800 (PST)
Date: Tue, 23 Dec 2025 14:01:36 -0800
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Message-ID: <aUsRQMYwmYOUCXvp@google.com>
Subject: Re: [PATCH v3 00/16] Add Nested NPT support in selftests
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> Yosry Ahmed (16):
>   KVM: selftests: Make __vm_get_page_table_entry() static
>   KVM: selftests: Stop passing a memslot to nested_map_memslot()
>   KVM: selftests: Rename nested TDP mapping functions
>   KVM: selftests: Kill eptPageTablePointer
>   KVM: selftests: Stop setting AD bits on nested EPTs on creation
>   KVM: selftests: Introduce struct kvm_mmu
>   KVM: selftests: Move PTE bitmasks to kvm_mmu
>   KVM: selftests: Use a nested MMU to share nested EPTs between vCPUs
>   KVM: selftests: Stop passing VMX metadata to TDP mapping functions
>   KVM: selftests: Reuse virt mapping functions for nested EPTs
>   KVM: selftests: Move TDP mapping functions outside of vmx.c
>   KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
>   KVM: selftests: Add support for nested NPTs
>   KVM: selftests: Set the user bit on nested NPT PTEs
>   KVM: selftests: Extend vmx_dirty_log_test to cover SVM
>   KVM: selftests: Extend memstress to run on nested SVM

Lot's of feedback incoming, but no need for you to doing anything unless you
disagree with something.  I have all the "requested" changes in a local branch,
and will post v4 (probably next week).

