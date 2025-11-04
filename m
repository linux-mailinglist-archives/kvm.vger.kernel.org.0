Return-Path: <kvm+bounces-61998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 890F5C326AC
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47B69420DFB
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6517733B6F8;
	Tue,  4 Nov 2025 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G6ql2ZHb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBE432B9A9
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278405; cv=none; b=QDPw89H6a7Qc7sPQrq5WIOuyhwn3ZcYPMlzI341pplDfkzqJpuCdFODRAr3XV+ksj/zZ1cNoZWQaRpS0/eB4Fsx+N/spo8amEDmfGMO27kCM0tM8v8Ud3nLZzAWXfJpGBD66B1kpOxZGaF1edz3T41hEKXjgAlMp4GPhaOTypQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278405; c=relaxed/simple;
	bh=yB3/nOCSolZYFw3NqOCpNhBq8JwPtYbPpdL4/GvIScU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nLh3nvAIuY4ofsz4gl9bLs9p1HHUP9CP4qYPhKbUJPfe4GNDHTpsF4pvmbF3UcvdzEQ5HzwHP6tbBL/6kxHWvW1DHnfC+VlzfV45T9wS90Ny6HPhohndWIs9dENriQbqsxTogCnyTcKdA5TFldtTCB15ubzahZMKqLu0OtSNjzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G6ql2ZHb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3407734d98bso6030107a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278403; x=1762883203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9zBNdPZyMQiDMIvVQuzjWZpTv+5WuzG3WL0fRvU8okA=;
        b=G6ql2ZHb3scuDi+/AcJeNTwDMAzSG1pCmV2PEgO/ruCKPwWArN8dpLLoBV8ZGt5h9d
         K2ld9UAb7GOgunAH6I0jcdcpq7dAOTUuDp96ij+HVwjO6ScOPKCmg1g4jwjJU7q1cAx1
         dsO8n7F3IRNjSHsxpGzQBKSBYvybTbkjhhH4Se/RKaAoezoVWaDWNjQ0bBaUnyylEkb2
         jycjuYHSzTPUTsvIbYpZZaXICNenoKq7N0/+SV4xIL+d+JhPlNO5rJ6nQWBP/TJcHykl
         D2PlCo4jThY3P+ql1QI/stOf6vJg3Wufe+7lA9JYwoYkypdD9hsnrmeKaMHeRNpLkKNO
         h6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278403; x=1762883203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9zBNdPZyMQiDMIvVQuzjWZpTv+5WuzG3WL0fRvU8okA=;
        b=M7P/o753hpQe8J/X3KgKCPRkPTj/4L5oyz5/to3zmtPXAQKAz+czvW3HBGb/wHh4R+
         biIz0oid07MgZxtJ03VQ1iPYfGcbAcRUKjL7M3DcYGIbV8tnvfKno49KcXCix4Ruzf0Q
         +RAnfCTaaGZ+EvJgAoZ+iFkoS6p184E5Z3vNZz0bpW3A9997vm4qN/5HsvHfeO5o+HGo
         bn5qqtwfoBmAzI3IBfE+IF4phYpHxB9cryTHRT9fXfAwjSttXEmpkig0abDrhiIUAwuf
         98OFK972LigXV+EmrSgUkzftYgqLuFazadkvphFfTLd1EZRgVw3gigJctGDoqI9wm1Fk
         fvsw==
X-Gm-Message-State: AOJu0YxKgcdcwD/x7Ronh63ykl8mS448WRoVqHnR7qiOFDhEyj8UBQbD
	Y7jJztJYel0vW0d5ab2YiGUFOdW+UqfM6NWncHLWWIYjGDWS9+J5e3QPcMEYe+qFdA1SJv+AXzV
	QkvB0Ow==
X-Google-Smtp-Source: AGHT+IGjNvNGh/Lh7x+2tqDDFgx64vRukJdu/nBZBUQeHayzMYjsqpnHxZxrhnzLZk7wroIFbYfjk7cXRdY=
X-Received: from pjbms6.prod.google.com ([2002:a17:90b:2346:b0:33e:384c:7327])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5281:b0:340:5b6a:5bb0
 with SMTP id 98e67ed59e1d1-341a6def359mr27137a91.26.1762278403491; Tue, 04
 Nov 2025 09:46:43 -0800 (PST)
Date: Tue,  4 Nov 2025 09:45:02 -0800
In-Reply-To: <20251016190643.80529-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016190643.80529-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227791321.3934009.13375648150137883983.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: SVM: Unregister GALog notifier on module exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 16 Oct 2025 12:06:40 -0700, Sean Christopherson wrote:
> Unregister KVM's GALog notifier when kvm-amd.ko is being unloaded so that
> a spurious GALog event, e.g. due to some other bug, doesn't escalate to a
> use-after-free.
> 
> I deliberately didn't tag this for stable@, as shuffling the setup code
> around could easily introduce more problems than it solves, e.g. the patch
> might apply cleanly to an older kernel, but blow up at runtime due to the
> ordering being wrong.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/3] KVM: SVM: Initialize per-CPU svm_data at the end of hardware setup
      https://github.com/kvm-x86/linux/commit/59a217ced3e7
[2/3] KVM: SVM: Unregister KVM's GALog notifier on kvm-amd.ko exit
      https://github.com/kvm-x86/linux/commit/adc6ae972971
[3/3] KVM: SVM: Make avic_ga_log_notifier() local to avic.c
      https://github.com/kvm-x86/linux/commit/aaac099459f9

--
https://github.com/kvm-x86/linux/tree/next

