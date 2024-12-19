Return-Path: <kvm+bounces-34100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0099F72CA
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCC6018916E4
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D06155335;
	Thu, 19 Dec 2024 02:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c/GVSGEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1E314B087
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576091; cv=none; b=Pu/REly+iCxMLT2XC6X7PU30geeg937uimasE7Secd53d7GDAJQoY9ztDtfAt0mQ9BkaPi1mYefejE8r+VVSZXP7qx4N9VLMR/6xe8q6MK0niqtGGQx79zrelFsIUVVbySoYdLsNdyC+VeVU/ZPHylxq1I7kdLLRAjLSUKfqE+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576091; c=relaxed/simple;
	bh=y51lWHjqn10A9EizaclLfL5x8u3NICj3unsTjD9vKkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LdnLPxzrb7UEbBuPq1weCm/Jro+ePJK3WRo4VomZ09yL/afmHXf1gOT7VfsHF9aURh2NfiCjChjnYq1wJZJ+Vi/kA00vXlvM/LRDIBpqZD2Gi2E32ioNnFZ/zouxGs/NCDIXlhTCBiC0KzVkP8eiZq5arIcbQUN+e0qRCvkXdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c/GVSGEP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-801c27e67a6so272648a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576089; x=1735180889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uOdMCzFP35aXzslXNf2M2ddgY/th/cvScy8jnULg4CQ=;
        b=c/GVSGEPrZWrXAcKTgt7z/OfP3o++0jt6KctWDi/F0eceegZxNLXyGc7sAZ+Scjiw5
         JZGoXmak1Vuy16kUaDB3CuuQRpAXc+tycST3Y5z1zsHKkUyyi/lnjFA9HERYHTd25NrE
         jBOgMNQ5b+Ifod2FikRs9yf/W2nc6YhsDvpCFYjwP00EEE1TynftERintjLBlKaPDnE9
         VeJ933UGFm8OHI1VWXSft2BHGiiQAtGKI1zuMPmJtSX3tgjbbdq1qfSpOGsVhyy586Hr
         yE4xHlHFsml0qOwNyHltmcf3/j2YtswU/3ffnilHX4D0nv5mjIZkKCviznQFnW13lx/b
         pHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576089; x=1735180889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uOdMCzFP35aXzslXNf2M2ddgY/th/cvScy8jnULg4CQ=;
        b=C/daikCxcYcqPDwaMzrF2OYYM0G03OWm3XeAcyIDXqRgOM7eTMzg8lwimXkYQLokOO
         PV7dnQBGcMyUYSf+tpsAJheFVmB2Sx/oOipcGoCCNyEyguPqOMs5J+mDykJWD2mvy3ts
         85sswtnMAvIpz2FdYKCxNiauYzT3bBcI/xQngLEXGfy3ykTNAdPYEi9ouZjJSNi+2shY
         HztVQ44jxKPnYXXsKlp9hBqZwtpnswV1tJRNz2OKTIw9JcTdx8C2wNKqIBHaLKITbka9
         oxv2yHZtRqs0fcZP/MYQBzEYC4STCyc8rCBT4x4T18csurceuz6TWBJ9cDlxioNw3+FR
         uB8w==
X-Forwarded-Encrypted: i=1; AJvYcCVELCYguYXbmVAekxNnSzG1nYPk9oZQyffAEt9MSqiL3u+oStIf8rrO8GZFcvqvxtDJZGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLnhKtFJsniKKydEhVdNjFepmSUjrEcY75DHw17u8TKIE9oRKs
	3PLum9G9Ez2s0Gr+vPZgUlBRIqoXCeKLa8gKktbdXIBMGnhh74u2XgU2MSduErQ6p1RL0VzrtAP
	S0g==
X-Google-Smtp-Source: AGHT+IFQFS9ySenXteRUWvvcLXqvQ4q0cx245AOLHk/ZvCHoeLf1nvRFD8Kkae5jWIjT3UkhJzc7DJgq92A=
X-Received: from pjbso12.prod.google.com ([2002:a17:90b:1f8c:b0:2ef:85ba:108f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37c6:b0:2ee:9e06:7db0
 with SMTP id 98e67ed59e1d1-2f443ce963fmr2278856a91.11.1734576088909; Wed, 18
 Dec 2024 18:41:28 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:44 -0800
In-Reply-To: <20241104075845.7583-1-suravee.suthikulpanit@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241104075845.7583-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457536569.3292855.6833130316497808355.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: SVM: Disable AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: pbonzini@redhat.com, joao.m.martins@oracle.com, 
	alejandro.j.jimenez@oracle.com, david.kaplan@amd.com, jon.grimm@amd.com, 
	santosh.shukla@amd.com
Content-Type: text/plain; charset="utf-8"

On Mon, 04 Nov 2024 07:58:45 +0000, Suravee Suthikulpanit wrote:
> On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
> the guest is running for both secure and non-secure guest. Any hypervisor
> write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
> will generate unexpected #PF in the host.
> 
> Currently, attempt to run AVIC guest would result in the following error:
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature
      https://github.com/kvm-x86/linux/commit/df7191833f7a

--
https://github.com/kvm-x86/linux/tree/next

