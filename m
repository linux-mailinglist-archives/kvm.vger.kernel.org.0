Return-Path: <kvm+bounces-51985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 712B9AFEF40
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 18:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 577E7189A3F5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8E9222585;
	Wed,  9 Jul 2025 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UlpUDOES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3EE21CFF4
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080114; cv=none; b=QBo1YgJpH9sUqz/BNX7VAT4U0FKZhesKySVsNUMcSkNa3jlKVN5CdwOWeIXzGjW5YABJUxOPjzXw+c9rVhmxXarSwAuf6S346BzzWFwgnHxtHa7I8xRFOCzEj19cBd2Pn7pCHA+Y258stZQXpLQWOTzAQp8VbTZPfdUS5kEj/jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080114; c=relaxed/simple;
	bh=vLzbLdb1U5XClidkLMNM7JnUKFZel/V2OLapIrBbU5o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=G0/XLa0nMD0TUJu6v3QcQpCQIROSkKDGuj98qKLqs93WYt1FWaWTbS+eIajSOcerIy207NTnfhlQLpkVWT9G6kF1pFzVe5mRAAmFKQVSh2iZ0gIIhTpSUQQUdPpzBNxGgyTlCI/mPK6lspsqX96O/EqH9SfrHZCDb40F4DksB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UlpUDOES; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-553a66c3567so160e87.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 09:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752080110; x=1752684910; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V6LeSQHYUwsCDHk/q0CXvTAidWrzxxRxH53jdjxgKos=;
        b=UlpUDOESePShYUuRnvnVhu0Fl+tMQFmT9wHXwrqM1wye2cW3Um9uV7fPDzJlUrFEbU
         Eu/emY6GFHGtgxTnclh++CbRozwBUt0qf4HOuTiEqiB28V4jOhkJe1SbXVeFyzJjYazF
         ZBsA44NSer5XCTYwfJQnyKIzXp4BHT8LKuAMUQsgfrTSigQ6Vcsgb8umQlw5d/rOGrqR
         YE+CCl6BZgJwsD7Gry0ghms46P/WD0LiSe/dUwYshZQ6TxFtXCn5P+q2bE9An7vVKYoP
         i95c+W2lvnBZk2cvqfRFm+ShqCenttn/75SWGNMH5iiaBup1rvk/Xm1DsDVkpUuSHOxF
         MGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752080110; x=1752684910;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V6LeSQHYUwsCDHk/q0CXvTAidWrzxxRxH53jdjxgKos=;
        b=QB+Um958jPokfDctwfGLDAl8kCjmwYU324gTWjC4Z6tGGXAXGH3oafzHYqiBc7l2gm
         tLjEEJ4b1f+LdEhybiDiJatuL0/2dKm7NhNek60k8iebMz3NTvnn4kBu3WXUz8+lNqH9
         BDWU8eM26MUCJBBqNNY5GH07yhIrJ3LsvVSG96lUXwFIOjnchmXGF/120qgyUNRmqEK7
         eyumVQ2iip7+pxxzpWeg7vx7FYAr6m5Cwuv74yUyFOXA+osgul4MuNnLHZnqtZ3wSds0
         bYFyDO0+TeRgp4BGsab2ZMykxbV/lUj3JRF1mxh57PmSO98d/9K9JrLvCV1C6bIWhMgX
         I/ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUy0IqWLrEY7mzcgBzX0zd5iSk+Aj1/9QRIgiopxd2hDAAoWQhHncklhZMk1pO0ZhbJGhk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEss2kWSyFs5XAauMr2Rk5t+ASCqr8baFoCjD7JaWvcBcw/8UR
	T/gojx2OhC8u1sd9mt1BnY3ZjQDE8OBS4hvb5v4YNL98vXTyvbgkuGOY+MeC8tLnHupRlBRbpvx
	tIkdilUqistCMExErsFnc0BHsMp+cn5efCZZrWWCv
X-Gm-Gg: ASbGncufKZYHx5VmL+pbS/Jynefn5+cNnT6c5khJGgJ/HmsweIoPFkzOIkztxMYhqid
	wZ5KUji32xLOQzPteGIIX+fzuKiN535b8lIKVctQrsUZF7UFSCPmyObk5TwBVANED/v4fAPu3q9
	VXmzXAhnNV345l0MaIfHlOOAEFSov/u0nLBccuKRYOPx2M8/dMVdPReg==
X-Google-Smtp-Source: AGHT+IGT9okQqPsrICn/X7FUpzA1ZLzGeBqb+5MaAmCxIsAJb55shFjxBxMb10S9EL6aXbkegpCt3f5GqNGlkep1/Ok=
X-Received: by 2002:a05:6512:15a6:b0:557:eadb:253d with SMTP id
 2adb3069b0e04-558fa988ed4mr305929e87.1.1752080110144; Wed, 09 Jul 2025
 09:55:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jianxiong Gao <jxgao@google.com>
Date: Wed, 9 Jul 2025 09:54:57 -0700
X-Gm-Features: Ac12FXwaVU09T6hqP7ML5TAzYqCMnAihwqTx1BO0dyOj4qWUTT9Mnw_kDwS_y4k
Message-ID: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: binbin.wu@intel.com, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dionna Glaze <dionnaglaze@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, jgross@suse.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com, 
	Peter Gonda <pgonda@google.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

I tested this patch on top of commit 8e690b817e38, however we are
still experiencing the same failure.

-- 
Jianxiong Gao

