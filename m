Return-Path: <kvm+bounces-60091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E588BDFFFB
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A403F581F52
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04E53376A6;
	Wed, 15 Oct 2025 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1B9298ss"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C60301495
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551585; cv=none; b=sqQG89xG7kwnqtoLG52204j7j5mfcg6Y9KrVr3qNHxL37aNMP4qnI3yAXRZCYgWhj5tOCKg5KKZqwxyJdFjSI2FICV5y3xWLacKZnqKqp0D+RxCgmEgT4KKpsVTZ5L/bBpjOhl/q+aGqs0GBRkoR25ziFVdG4hSJqgfLAIxJB8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551585; c=relaxed/simple;
	bh=ZhffbM5Oy55hVAvlvcfw64L9kMLT3DbEetoPXI/qz+E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jSC5/t4gE46uwnF3ckhZ7rOFM9K4vJnXApfKM60/ppOONm7HkQotgAdAN2lWeDF+jaVSs8Hp05s0SPv5yeTBp7LEzTnhgme9D8pcjhjBnxxx2+9bJ8mjzrPok4wxzF/MmXfHoYId1PGmCwfRE/voadYRbRzPr3emOxyygmpZXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1B9298ss; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-334b0876195so13085995a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551583; x=1761156383; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZzKX3ldXHR+9qOICKfXvb25c+drI08eBEvsn3KTsI8=;
        b=1B9298sssAF0c1VEdqRy5zXNw+I+CTbIC/BWyllX2tEQEMKMG5liMlAer8lZVL+74t
         9xInzTn+Tgp62yXBSiGvZge9sVkOq1stcwlS9H82RYk/WoJcYXJfJRIyoDUcHF8I1jwq
         DY/OQXEvWbr888anTUT/XLJ07GLd4xY29XjVHkArlDKMUgAgaoQjwFfKD0E8H9ql06oW
         qU5ThUhzcSV30po5vqQ3HhycrfDC4bcMvQH7NOQ2tmjrng431gH0vG3ntnxLbdW0dmFZ
         uHLmV1OmGIhAiHK+hqlMIiu6GV735k2RHSuyMIv81RxlHR1MKHJZscnobXl2AHoSazq8
         ZvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551583; x=1761156383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZzKX3ldXHR+9qOICKfXvb25c+drI08eBEvsn3KTsI8=;
        b=wG8KPuF9vmxBBU32INtu8dCj2C3ia9w/IJO0vGLzqNRXQXJ3Mm9Gx24ok61kaFF8yp
         5GEWAPE2eGJVjTZ2PY+f8YVeccW0nCJysW5dXB+dv0b/vdJZCnwtPLGPtNr10v6h1Ttk
         T6W0et7rYRBu2yYPmimH44ONNFXHR1v6vMBxNMvIqiusQgLlNmseXU9A0tvbslcCxUOr
         mX+dvBELcirIcB4IQm0bBRYs5J/HOOZYQAKvG54wLo/t9E1s8IPs7PIb3rgcxKtr8BNJ
         OMYJACqoiVG+xMMywBDkjHaYJffivXWYnJz9yoQnpywWZ0EojXf+YBOJAlm2/axr9ORt
         y/+A==
X-Gm-Message-State: AOJu0YwVke6dRmtOng/FMxMT71uUopEpI6ZxFL5thq6YwliootBrcT7T
	P0/BQcHBkRAYcMgOhamqLwX1gvEuTTKsvc8X6AB9vWHVKprFhfs18SbW6KR+j+VKboEh4CiXFdJ
	NkQkM/A==
X-Google-Smtp-Source: AGHT+IH5rZ5w+MLh5tVlPz5WgEpSIjx21CxmXhcVo1+5O5ehAtupb+0WKrzLmNpezKDm+Zs7msfk3enYseM=
X-Received: from pjzj22.prod.google.com ([2002:a17:90a:eb16:b0:338:3770:a496])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c1:b0:32e:dd8c:dd18
 with SMTP id 98e67ed59e1d1-33b51386478mr44366359a91.17.1760551583042; Wed, 15
 Oct 2025 11:06:23 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:50 -0700
In-Reply-To: <20251007-b4-kvm-mmu-stresstest-1proc-v1-1-8c95aa0e30b6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007-b4-kvm-mmu-stresstest-1proc-v1-1-8c95aa0e30b6@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055119471.1528900.16047808072294975428.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Don't fall over when only one CPU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 07 Oct 2025 19:12:31 +0000, Brendan Jackman wrote:
> Running this test on a system with only one CPU is not a recipe for
> success. However, there's no clear-cut reason why it absolutely
> shouldn't work, so the test shouldn't completely reject such a platform.
> 
> At present, the *3/4 calculation will return zero on these platforms and
> the test fails. So, instead just skip that calculation.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Don't fall over when only one CPU
      https://github.com/kvm-x86/linux/commit/98dea1b75186

--
https://github.com/kvm-x86/linux/tree/next

