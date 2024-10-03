Return-Path: <kvm+bounces-27849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7727498F15E
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 16:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2683E28230C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 14:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE7B19E981;
	Thu,  3 Oct 2024 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="knFd9KyH";
	dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="ths0gdK7"
X-Original-To: kvm@vger.kernel.org
Received: from mxout1.mail.janestreet.com (mxout1.mail.janestreet.com [38.105.200.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB2519DF9D
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=38.105.200.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727965675; cv=none; b=OLchkVsEQbAwwYbPa4X9KA7jjhwFWF7jNa4dgmkmWBK5W5WfDZr3+qA3OLhDN7nrzqHmtEaY7YL2chFMkN5rB9H1MGqDvgkX2D7r+BLLY8sRzLBuVO8SwY1KOkXa8Zwrer2yC8aZvp4rGI8EFx/8NrysRw9mLEfkoK7n+QUTxNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727965675; c=relaxed/simple;
	bh=JJchZexMF27wJMphbhmFZ5MPlbEyOkzaxmqwkFWCpW8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Q/DO+k4JPfEn+oxqHXwkQe0yGYwsRaO2fznkdPI4N8GNUhg+2ahhwOim314cGbYLByqC/1T4i/wmDVUfg8jXD+6PyPrRw4mTzhHWrbtFIjIFcrIITMqb9B6zmv6AUyisyuVYRBe4xwf4mykqe/Tv+OQ5pK7KBWUlomHYUEirQk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=knFd9KyH; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=ths0gdK7; arc=none smtp.client-ip=38.105.200.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=janestreet.com
Received: from mail-pf1-f199.google.com ([209.85.210.199])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.98)
 	id 1swMiz-0000000Bju2-0Jtr
 	for kvm@vger.kernel.org;
 	Thu, 03 Oct 2024 10:22:37 -0400
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-718d6428b8bso1229073b3a.3
         for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 07:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1727965356; x=1728570156; darn=vger.kernel.org;
         h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
          :date:message-id:reply-to;
         bh=JJchZexMF27wJMphbhmFZ5MPlbEyOkzaxmqwkFWCpW8=;
         b=knFd9KyHns45dinhVE7340bAUQLNodIohFmkDx+P/7dJFuz9eFo5E+txYGqKBimj9L
          0PUwWB2kkEPmsm9aM9tV4FPjsT/nYuI3y/WLJHuD1zr3szle9Fb5/BkJ0+kLS6iLPPdG
          edYaYt5V7dqVd5cCuPFszX3DsMGcJNm3E66z4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1727965357;
  bh=JJchZexMF27wJMphbhmFZ5MPlbEyOkzaxmqwkFWCpW8=;
  h=From:Date:Subject:To;
  b=ths0gdK7XRUsNb6HyHF3ijS5kldf+L7DhWa4iJLCHRSqHNebM4s7jgnNOtNWW39YD
  Rw/jM+ZvwgJlEl/mPF4g+Svyi0ipTnLaAQE8YbN1morSrUdlFG9NnSDLGCfM9pxdIe
  CA2Ce2z8MtLL4Mghe8Rmyp3C+7P+I79pOkhTkc0VMDsmlmrdy2oHWRAsywciE/bU8T
  L+UwMRcY80fTvYuKs58Oj8J4yN3XOHELlPH3agptDlqNeKSLPlQkO4rGtNGiEnfNO9
  kKsyU1Ul/piR2yqHSfqcJuiAVeQDYKNz9c2RVNsJoe597Su6sJE+vfMqnw5D7huZFu
  EHboZ+iATQpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20230601; t=1727965356; x=1728570156;
         h=to:subject:message-id:date:from:mime-version:x-gm-message-state
          :from:to:cc:subject:date:message-id:reply-to;
         bh=JJchZexMF27wJMphbhmFZ5MPlbEyOkzaxmqwkFWCpW8=;
         b=chLUeS+0N8AV2g80EcQni/pjCgyFlLkUdqxvP4y/Iar8BQxBPSZO6IrZ03e0f3nVzB
          wv38/I6gZENMAlSjdck8nX1wq0gliXplvRGEQzcIwiAqOtH3mlWgkenOFubAy2Nk4VzS
          xtODnHMf5YK24l4LPG9BroG4yb634pPiO8qWWJrx/kIwbwqWd2kpKKKwyMsiuIGN/hl1
          UlSepXOtrDkN9Q1LWG9jnQjCvTNG4OBTk7gMYDUk+dSpM/BihJJQcFPjRxbbxeMmfRLh
          k0fJkAF+iCumvucOKQPlT28oimD50iPhMvbpnd4tW5zRI92mNH12C+itbZCRIBEds9BO
          Q5LQ==
X-Gm-Message-State: AOJu0YzzcPsRP2SvYfyzrLAvxSxTwbHa/lZqmno6en5eIuxtA76dvoia
 	T4B8xxwoJ83Iay4Xyh2ir0MiY2LsavcTTC5eHcDa3u0DR810bAzBBagIDSo/Qtl6lcnDR3vM9r5
 	yv5iV6sdFLbT3+OgBUHyIi1gNR710Txu8D9ygyRtNsu4MJd+wH8sxgNY5UclHCQCMzl8YdsXHbO
 	cVU9piZ2yo2fTGXojM6tdl1zxcnOeh7wzh2g==
X-Received: by 2002:a05:6a21:6481:b0:1d2:e78d:214a with SMTP id adf61e73a8af0-1d5e2d2ff91mr9415586637.44.1727965356463;
         Thu, 03 Oct 2024 07:22:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEczVAQaB/LHYU+G+FgI/GX/agMOvxhpfxBzu1bRhYOaETI/R5Kjc4dbFyy1eYJYE64GcL8Ua+nEeK3CtIvSE=
X-Received: by 2002:a05:6a21:6481:b0:1d2:e78d:214a with SMTP id
  adf61e73a8af0-1d5e2d2ff91mr9415553637.44.1727965356141; Thu, 03 Oct 2024
  07:22:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chinmaya Mahesh <cmahesh@janestreet.com>
Date: Thu, 3 Oct 2024 10:22:25 -0400
Message-ID: <CAEjex8LjEsxS=PX+-6C_CLqiHbt0YRVjQLStQHoP1BHoaqABGA@mail.gmail.com>
Subject: Live migrating L1 VMs with nested L2 VMs on AMD
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,
I was reading the KVM documentation that mentions live-migrating an L1
guest with a running L2 guest on AMD systems results in undefined
behavior: https://www.kernel.org/doc/html/latest/virt/kvm/x86/running-nested-guests.html#live-migration-with-nested-kvm.
However, we noticed that this documentation hasn't been updated in a
while (last edit of that section was May 6 2020 according to the
blame), and notably there have been some AMD nested migration
improvements in June 2020:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=039aeb9deb9291f3b19c375a8bc6fa7f768996cc.

We did some stress testing of live migrating systems with nested VMs
on AMD and noticed that they seem to be running fine with no crashes
so far. Do we know if the docs are stale on this? If we have tested
this and it seems to work fine, are we taking on a lot of risk by live
migrating VMs with L2 vms running inside of them on AMD? Are there
specific workloads that are known to result in undefined behavior more
frequently?

We have tested 2 scenarios: KVM running in KVM, and Hyper-V in KVM,
both on AMD EPYC CPUs. Both seem to do fine with repeated live
migrations although we are yet to try this long-term.

Thanks!

