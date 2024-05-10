Return-Path: <kvm+bounces-17234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CAC8C2DB2
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 01:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 486C6B23B7C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E108176FBD;
	Fri, 10 May 2024 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jkcXlnEA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6140918EA1
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 23:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715385060; cv=none; b=l7yQJMEkfnZyCYG5UBgI/1HxuRZnBmE2JD9yn1Om0mQLB/EICQ0gV7AW2Lf/S3EG2vhbs806ujx1ncuZ5Pp7C8cXeTmMnyrvhx0s0AvFfyHhfmNATtHA55x5S6Zrk4tPvRqP/LopZIEbtkD9mjD4X/yw9TH8nUUeudf63XbsV0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715385060; c=relaxed/simple;
	bh=XIArHrhr1h67TzOs3SLB/eIid6Ie6Ur1aeDIB7wF8vY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Buv7q6sUGiJlapMvQq6s9LHmFK69EnkA52WPhowi5PTvEtQwJdyUhUITMGmJFCHDcZxA78chHbdP9G5/hKhqCQbsF5OLHN80v9x7PtEjJdclkyO45Bq7uUIPq4TzopkGEzvpNParlAbNM3OvgmKLJEZNQml4g/q0OgoxRL0yZpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jkcXlnEA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-613dbdf5c27so2160814a12.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 16:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715385058; x=1715989858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIArHrhr1h67TzOs3SLB/eIid6Ie6Ur1aeDIB7wF8vY=;
        b=jkcXlnEAIOPfBWJPuZw1XKl1CqYyBfHaXj5YQhLEk7cPLCDNcXHzIC3jBgcGeSXIko
         5v/O/q9sA9Uzv3Br9XMls7bGaYMz38dL2JYlXdHaM7eRDoaDrMoa3h/SlPozteBQfMUF
         av8bFcFZino8fN+Wn7mfCP9GcgHY4P1/cylc5JmkwmTSIBXTgT1bzK7qgyA2fSR1ZUnH
         XoaN/gfF2OkIVffa9L2f8YUvC3E8fpP42fElz/OEoiQ3wtady0OWQlDAEBKuHAJAFyw8
         RXYBVux0hFJ51WN7vhaC/fVf9fYtpZr4GSQkQ7/ZFXXz9IoRXxfgZZS2qh5SJlLv7GyG
         ewSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715385058; x=1715989858;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIArHrhr1h67TzOs3SLB/eIid6Ie6Ur1aeDIB7wF8vY=;
        b=w54kWTHU4l73078Blb/BqzM/CEQP3/4xFVyCQO5mxrw01BRhXx+J4o+P3m2lSF3AqP
         4tWh1j+V+WtuX72kMxkzp80TaJ6OXX5SWw+07uFXLHxZ6v/BdEqHjmVsespf4OFvqfQa
         zbWkEOvZ9fkLOhkeHsQiQ/JqLRHeRcgJxIdbjmGV0zz3ir//CQpMSkUetL2sxEZGe0Kn
         CeMGne1Ds3ktVqEn1CSRIeu3AN3jCuRLmvs2SpS4vOJNLzAv3HOk5B5wFWn/R1kQYHan
         R3zn4uzx+Dy4c3j1tocHgROYHA2KRZJ9V0H2UI3Rb2dOiSIGzwNwSqfwbcejKKLNG8J/
         NmIg==
X-Gm-Message-State: AOJu0YzTDew0dGEiSJ7KXQ/V+lrUW/UBzLjUO+188N6i/IVWKiqpfdu1
	UBvmCKSW5IkTR8mUDhzYIRwbS6Wfc63Xq543TKtFz6qLpoKXF9RWPz/2IjU1XZTcF1jrS1V32on
	hEQ==
X-Google-Smtp-Source: AGHT+IGZDlLw97xSltLghqnuxWqKTMuyuG6MpY/UBTcl8qV1ZiOHru9f704DSjljZlFGzlFhUHQ3fTTBgmw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3f8e:0:b0:5ce:13a6:3c36 with SMTP id
 41be03b00d2f7-637427aa267mr10046a12.11.1715385058206; Fri, 10 May 2024
 16:50:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 May 2024 16:50:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510235055.2811352-1-seanjc@google.com>
Subject: KVM: x86 pull requests for 6.10
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Nothing notable to say here, this mail exits purely to be the parent.

