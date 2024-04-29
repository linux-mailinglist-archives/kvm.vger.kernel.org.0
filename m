Return-Path: <kvm+bounces-16198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE24A8B6450
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 23:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D381288810
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 21:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A388217F369;
	Mon, 29 Apr 2024 21:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cgKAzGaP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF2417BB37
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 21:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714424589; cv=none; b=LIT1ZCaMMcadjYASbP9KgzYM9bESlKdlAHxsohoEn7WDzD6iBGoRqELuyfGaOAIRxL9efP3mspuOffv4JZLfg47wN1MOucTmik4N598D5ku8P3yRJ9Bm9eeb1tWU/jtsMh8SrQ87IYB/snmnZiuYee4p4gWcJTggjcqBcRKsDaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714424589; c=relaxed/simple;
	bh=SK3G96T4aqZ9rwUi1oPJAY9W3TBSIlSx0r4F6GDwouM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QI+jz+DoYf+Q2NSHRZ2E61mQZ+4oxNwW73XJeECM7MdzZ06H5d23+vWY3k3aN45Z3KCsCgdm1C5FwDKytlZqYDrzN9SVVuYhtni0sJg6Cq/xdy9ZH80agmyFzdQU+TGR6yIbrvtnverEVGz1OlO+EjVYHavKMWM0A6Xr4/dRgq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cgKAzGaP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a4a2cace80so4954797a91.3
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 14:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714424588; x=1715029388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WPUCCa2Pl8BfWUCgilhIb1m2EInOqsTo96Ea33xypmw=;
        b=cgKAzGaPZ9ujApIH4Hcnxrqci3z8/11B1kI2+e2cgTpyDBcW0qqUwqDnOvAAXl1k7F
         NLectClbYdiytd3+VDYGtM/0OwRmTIUM86C1Z+7wQf2hguYCybrURfq/JdFudlr+aZPX
         BRzKD53xHf8XQ+pW2lY83bbAexyizNRgW2wPk8F2OSJd+4Bx4yhDSN+W+0DK85ZKJG7q
         X1gevqfdmAc6gqlNhBcxZ9W0ykCB5Y0DbZsxHCkWrS3QmedZ5IAa6xKnskdC7gEkKELv
         fWPKZ0rX5IF1f6qZDFZ1nmooUyu6tqQZJFdKcGjoHy/Cf5xK53n/UYQwe6O9ivIkBKUb
         YZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714424588; x=1715029388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPUCCa2Pl8BfWUCgilhIb1m2EInOqsTo96Ea33xypmw=;
        b=S9j/5kLsVwf0vChnNJ9OBQyW1NaRPLcLARY8zfZCSdA7nfbKMAFRKzNwT2m+RdjoA3
         hCzMf6V4+FhYIHnYKMzBUxzykBe/udJNrzM06NZ2ekhKP3PFKaN/6MTQBYFHCz3GLu2+
         aFvxzeGgISUSS48RTk7kyCN0S4vsjs37nCqI+lfP8WH94TcoyykJ7Cfs9zWJVxkV3RtI
         Vc4+ig+A4uoEZ4nUgjdB3Yjlgvl6wwfjI/hbzRufpXRvsytHgw/G0q/+sfsW6IdWP71D
         L1Xed7c8bFKBwmikAgYuiQkl1FRESyl6tYRgsOVPJn2R2+nAU9dcoV8wfKc6QKZCjzWP
         ZJkw==
X-Forwarded-Encrypted: i=1; AJvYcCUuVgjs7YUxoTG4MuoQwwJZgO2He5yFhdbILHdVk1PxCbXsdorrQ6rOLgz7YZPbKLk4hCxXAJGBwgTdT+NqUJCnsGQK
X-Gm-Message-State: AOJu0YwRwPHVdnL3femQ1X7CK5hwzvY/SqztoSNP/pKMystB1dAcOdZ3
	BDM9HlsIcZLQ0ezbOA0VP/CAjqtlNZKkiPsGJ8+T6iFzvnc/pGIqpCFcynh34/u/UaZl1pgLAiQ
	yVQ==
X-Google-Smtp-Source: AGHT+IEf5flitXXjN5u4Fo/6BuICYPX69sOUimUW4HLvgZ+EOzKzbDHisvJHvToaGifZKMFhjp1lvKfYuJo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8814:b0:2af:2a48:b458 with SMTP id
 s20-20020a17090a881400b002af2a48b458mr2004pjn.4.1714424587929; Mon, 29 Apr
 2024 14:03:07 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:27 -0700
In-Reply-To: <20240206151950.31174-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240206151950.31174-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171441840173.70995.3768949354008381229.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Compare wall time from xen shinfo
 against KVM_GET_CLOCK
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 06 Feb 2024 16:19:50 +0100, Vitaly Kuznetsov wrote:
> xen_shinfo_test is observed to be flaky failing sporadically with
> "VM time too old". With min_ts/max_ts debug print added:
> 
> Wall clock (v 3269818) 1704906491.986255664
> Time info 1: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
> Time info 2: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
> min_ts: 1704906491.986312153
> max_ts: 1704906506.001006963
> ==== Test Assertion Failure ====
>   x86_64/xen_shinfo_test.c:1003: cmp_timespec(&min_ts, &vm_ts) <= 0
>   pid=32724 tid=32724 errno=4 - Interrupted system call
>      1	0x00000000004030ad: main at xen_shinfo_test.c:1003
>      2	0x00007fca6b23feaf: ?? ??:0
>      3	0x00007fca6b23ff5f: ?? ??:0
>      4	0x0000000000405e04: _start at ??:?
>   VM time too old
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK
      https://github.com/kvm-x86/linux/commit/201142d16010

--
https://github.com/kvm-x86/linux/tree/next

