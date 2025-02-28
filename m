Return-Path: <kvm+bounces-39747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9B6A49FE1
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E3613BDC47
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637E327FE64;
	Fri, 28 Feb 2025 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nkk3OyNF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CC2276034
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740762460; cv=none; b=sJZ2V6mzcxJYQFUREBuwNVevJWc3vKB22S9fnGaw0QDek1MZ5X21z2hvx7Ut7lmhSi8YbWpO9R6SgMxE0bbyLtiOGn88f5O8Jv8Z+EdDFEX/iOM7uS2JUXKI5KUR2bZyaoy4Ol8iFOI0XQNpmPjiziXGwr7jqvedtFOEBTQmqG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740762460; c=relaxed/simple;
	bh=E6bnhzdYglUEbw/3sjQWwWPsFClmseZJbB5AYtU15jM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VWumrBDA8q+VfRTyVMWCPry6fjfS9FB3A2BoLbxk0Gt7EV3gzvUowd2mhHWCwp3NQOvdSDzJ116CCS/eQSTRBlNg7DzFIYoEZXIcwKn950kakMhd0Hv+DiI4smKvk7VKtuTfqd+TyYPBM3GKRaxDIAZ/rnkB4JjLA132o85HPxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nkk3OyNF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2236b6fb4a6so35234095ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 09:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740762458; x=1741367258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAnLPa0VRn2NfFWgX/vf88o4ksF29qjxwagnBjCzxlk=;
        b=Nkk3OyNFIQUqzJFL1qlDe6WfYfYSMMYs+C0t5PVmlFtTTYYHGi1ipsDFERkc6wnPo2
         9uJPeLBqlJSaD1CfLmkr0/ilS8j/1QH2eUWngT9zcZb1eqI7oml7/mpgVriG00zSgx3p
         7DntxB7ANNZgrVwXQe0jdgc4PqA4Qlro8VTqKQcr93fkBYwGhsmzzdOHRg+Xuty2ie+5
         qaiStu7HjyHh0abpnItImUn/CCQf0947ABYz1+tSi2YSFwO6ofaKXJKIqHoMqTcJC2wO
         Iw/ILhpxoGa4dKyMljUyQvvlvLrPnColZdXDdVj5kLL0qQCiWbzqxrgjnL9qJ5LKRDyv
         lj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740762458; x=1741367258;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PAnLPa0VRn2NfFWgX/vf88o4ksF29qjxwagnBjCzxlk=;
        b=gU3v8rjLwTJOoJQOdoJFjcVn68Zc8LFCl82O7m6kUUGisnVfa6la7TO+MQa+mMHvrz
         QmLcf5eMyjGrBniTm9s4EX/BCYXZGmOvPOQYZalCJEEyvmRvYt5Iu4HYk8r93om6E/S/
         DZMw5yh4O6Pd4xBUJMftxlCHoJJPW6zV530Qufr5n87BX0+POvQ/zJLFMePlRJXmIGXI
         xMthjZWiv6hk2mAryutWNqb9erVxzU+xjIlU7ei11TlbxUts51Hay4bB4iJOpfE51P5j
         Joj4OsBhPQBOrpYTBPAqQ6tIEjuspHGyVqLhUDqjZIccWkiaW8xhqxU6EyJ71zEFM0sU
         YmQA==
X-Forwarded-Encrypted: i=1; AJvYcCX1TWS86jZT9jpUN8v4lplC2+7XD01ox7KCduof2JIe7ouiGW0nZT9RlgXdRArM9y2FB0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YznJrwnYaZBArrgOyOEJ4gOi2Wcp+tetbcy3mHU+zgpLEDBxiyh
	AtMy2kMh2o6QS6Swg0jga5B4GQ/yLX8hmnN117Quu/1bFEqPiM3Om7kDytdeTRbj16b2hJzzFJp
	ifA==
X-Google-Smtp-Source: AGHT+IFH9E/WNEfyobY199bM95DrwqzdXJMQ84WirnxX6jf0Cis+A+w0H4zAFNsKPYsxVMwclKIulMvp+8A=
X-Received: from pfbei32.prod.google.com ([2002:a05:6a00:80e0:b0:730:8d2f:6eb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:21cc:b0:728:e906:e446
 with SMTP id d2e1a72fcca58-734ac4694c5mr8152593b3a.24.1740762458320; Fri, 28
 Feb 2025 09:07:38 -0800 (PST)
Date: Fri, 28 Feb 2025 09:06:32 -0800
In-Reply-To: <20250128124812.7324-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250128124812.7324-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174052976390.2845556.13408799702754971344.b4-ty@google.com>
Subject: Re: [PATCH v6 0/3] Add support for the Idle HLT intercept feature
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Manali Shukla <manali.shukla@amd.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, nikunj@amd.com, 
	thomas.lendacky@amd.com, vkuznets@redhat.com, bp@alien8.de, 
	babu.moger@amd.com, neeraj.upadhyay@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jan 2025 12:48:09 +0000, Manali Shukla wrote:
> The upcoming new Idle HLT Intercept feature allows for the HLT
> instruction execution by a vCPU to be intercepted by the hypervisor
> only if there are no pending V_INTR and V_NMI events for the vCPU.
> When the vCPU is expected to service the pending V_INTR and V_NMI
> events, the Idle HLT intercept won=E2=80=99t trigger. The feature allows =
the
> hypervisor to determine if the vCPU is actually idle and reduces
> wasteful VMEXITs.
>=20
> [...]

Applied 1-2 to kvm-x86 svm (with the rewritten changelog).

[1/3] x86/cpufeatures: Add CPUID feature bit for Idle HLT intercept
      https://github.com/kvm-x86/linux/commit/70792aed1455
[2/3] KVM: SVM: Add Idle HLT intercept support
      https://github.com/kvm-x86/linux/commit/fa662c908073
[3/3] KVM: selftests: Add self IPI HLT test
      (no commit info)

--
https://github.com/kvm-x86/linux/tree/next

