Return-Path: <kvm+bounces-19699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 173EF908E7B
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 17:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BC711F2783C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 15:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA8D16D33C;
	Fri, 14 Jun 2024 15:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cfQITXib"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F8E15A861
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718378163; cv=none; b=uHsyl/huObyTV40BNcQCTy0l/iURMZto3YIGeZjSE0Kbx8hmHJ2ESpGfXnwjIFiX9zF00QNYerCpFTkKpbfQHvyiNoq1wRBlhPdU3cXDXJKxfiXOYgdCFg+i2hxgrEhSI03qABcuaqXeyxz2Ha3WMASCe8H4i0uvxUmEwuKdrG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718378163; c=relaxed/simple;
	bh=tB3nksv5OSh4yrXHNAhUFm7LpoPTAB3Ap17apW8jA+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AFOandrFfCRtUU4GC80w6zy10G6mztCwTy+QA1qYYedhK28YF1chcomze87Bw6wu1LMhtN6Vj2KlIOjLZhthhm0jyxPOp3F8rJYTQtKSCA6zblVDtW3o4rjW1G2rlwywuAseXUX1ZCI/u/TM3XcCokIOeof4rb2qyPe8QPL3Uh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cfQITXib; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7048ac4dcc5so1803833b3a.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 08:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718378161; x=1718982961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHPuM4ujkTNiXqDIHccUGDrfT6731iKfSe0PJxgTmiM=;
        b=cfQITXiblz/MpMhPFtmpmzerxWQcvsu/ptqxor5EUlNQxki7oZx48d6QjCEKpI+3e4
         DuTkvGDvIwKZfbJhpHIrdHtbs+QH5qZqMitfj4rpqdsKMJaMVmyNUmXF/bkaNWo4rUO/
         Mwt8vsUwAygZfIkv4PTYQwsdjeDJgZWOdGAwvI0Lc7JAmq1NNl6pB+I9+7Ad2cwSx4LX
         uVy4pRNtcPgwtHsKZRdySIH/5TdDZAUGINIumGl6rToeJ0ZLOK/j7jUuUd5qVzYVfP6i
         5WKScox0ouM6UdP4wd9LjKIjIMjh1D4NqAHQH2chrrs7bq/G36EmNF4S7vYspXk8zvMi
         9QpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718378161; x=1718982961;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mHPuM4ujkTNiXqDIHccUGDrfT6731iKfSe0PJxgTmiM=;
        b=Z1BFH8UajgNkQIAyZyK6uVgFDmCZZDpAmzDGRRtEzibH81b/DgcD+O/Qk4Kd4g3GkK
         EWYYBr7auN8sR6MBLf8F3JrUp6/cRRpdAnRiDJUS/qoQ69CyJ8YDVn9eVC3CDRvL0tsf
         hHD+KFbMHdRWFkl0HtwJadNHNX5eZ1srtK8naCmrlyqzaxdeabc63KLsPx46JU0ZRSYv
         bhq7ILWvZh52k4VJDroY0nlNniDE5Pdp29Ts5KV1oRWS5eoQCvEtCOrzN3abXUqsAOWW
         1flFbkvZDUHhraQ+GonYUygJ3Tq3NT6A9zclbQJ8QxGTLrdSRRFGkkVEjUvs5lvyZAOC
         9/Bg==
X-Forwarded-Encrypted: i=1; AJvYcCWrJ/qfrUuSny5s0nT0XFtTcyBG42ztypsHfKItYaKh/6JsJrEliFVhUe8M2kpXmOdGvUYzjszHQnzFhVW+jkqLnECr
X-Gm-Message-State: AOJu0YwFMdmNk4BTP9ToSnQe/UXbBsrwDfhOpVYUcNPzFAZrKRbJTO6u
	KU4G8I2uIQDL0afNE6WsE5yrstGh03giz9Jpx4es5I2uYQ4Rp02Oks0GUlLYdkuo7xuTwrDcb4G
	JJg==
X-Google-Smtp-Source: AGHT+IFKIvdPIamcWVj7sl1pHtgnxN9+JPMpgnYU9nJ0W82OOraRH92HNicd4LkutYUqaYREbwJdPrbFqAE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e0f:b0:705:d750:83f5 with SMTP id
 d2e1a72fcca58-705d7508833mr21600b3a.3.1718378160960; Fri, 14 Jun 2024
 08:16:00 -0700 (PDT)
Date: Fri, 14 Jun 2024 08:15:59 -0700
In-Reply-To: <202406141424.5053d640-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202406141424.5053d640-oliver.sang@intel.com>
Message-ID: <Zmxer_-PSqxisgti@google.com>
Subject: Re: [linux-next:master] [KVM]  377b2f359d: kvm-unit-tests-qemu.vmx.fail
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, 
	Linux Memory Management List <linux-mm@kvack.org>, Yiwei Zhang <zzyiwei@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Kevin Tian <kevin.tian@intel.com>, Xiangfei Ma <xiangfeix.ma@intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2024, kernel test robot wrote:
> =1B[31mFAIL=1B[0m vmx (65128 tests, 2 unexpected failures, 2 expected fai=
lures, 5 skipped)

This is a known issue, one of the VMX subtests clobbers PAT and causes subs=
equent
subtests to run with UC memory.  I'll sent a pull request to Paolo today.

https://lore.kernel.org/all/20240605224527.2907272-1-seanjc@google.com

