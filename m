Return-Path: <kvm+bounces-52451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3008B0547D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193964A4DEE
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A9E2749DA;
	Tue, 15 Jul 2025 08:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9rZmRKn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C922B5B8;
	Tue, 15 Jul 2025 08:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752567379; cv=none; b=RFWow37ef+DzOqss8ihG527ooBzN0bTCFJqND2+Ik26ZsC/MfGIoEHNtNE4b2+wmZ/X1VP2VobSgjMNH1geklN1A6XMDAlUbZ0KFK5MkX+IV8Ajpzt67XgL/CWcFvlEbUFGa8GoGuy1buBWPaegjM+elulk7YwMRMfVxbYx53lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752567379; c=relaxed/simple;
	bh=EdqRBqlNb6KThG5Ft3HFD9HiaaQqBh6gQJ4rzgmpONg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m4xh51uMvchMmiiq15eup+NjP/YlAZrnFJV7qRzcC55TotE60CuT651mHz5QkjcWqtzypzSWMQqifTJmvOFl+fZsiEaWgzweS6JIM/CTkBb9EJmT0WlXfY2lb3y1agh9gx23PReIIa2lZ8K4GJwIg326ltlHV8L73xlF4z3+hPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9rZmRKn; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234f17910d8so52505925ad.3;
        Tue, 15 Jul 2025 01:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752567377; x=1753172177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6M+Wq4I3UbTcseRLoOgjPxH3AnkKILZWmKWLoUgNhDM=;
        b=A9rZmRKn+BbDoeacIRxEpR0e8zSUhBf7xusAf0rcl124PDDEU5zj+sNE0D+5jMyJNf
         1Txg9OBe0DU5WMS867zQ8fLafPxTefqxxEP4i34Df6TLMNf/NhvnZd1FEMfI9yS3x+bi
         HUsyq8So5PgDd6ho9AjVkzrtjqKM6OcRCC/s2vf7EOJUvcf9A5KO0O+UV69xZ3mNZOxX
         E645Z9bi6GtzHG6IIiQuLZ5s+tMxF1o3zNpvsGcBojMWg0ii3ryajyk60ikV2lwf4Cao
         CBSdVnxTOibl8gzEsQ52FXMXX2++fQhfef2PYv3Irs5DtpwDHYREG/EeZi/XDhkulnNi
         d6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752567377; x=1753172177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6M+Wq4I3UbTcseRLoOgjPxH3AnkKILZWmKWLoUgNhDM=;
        b=FINv9if8cRPHv/VQls4AWGQBxA9xjgDVc207qJItDjI/jl8+yVuCX1ood11dC77e2V
         4LT5E4VXMuwm71DZTFLZ5fWUvPDOUeU7QO23TKRvvWMy81jq7MXAlKTkPXp5k0vceoq5
         Sym4kEfA04kk/2tyJQQPbxALU8MsfXg7QM7stOOhdnCL1bQJbWhSZ/1J3yYLtWIeaGcl
         S41tD9msDDjfPAKcpITpZUi7Fp7jg1d8IJFj5zRmKIVwTPPBbCTmXM8dcTRoa03efNff
         PlFqEAjDhEOQyJznp2KV1EOZO8TIDbqEc+hZgVR3/NCTFmm9qU2Qm+e1hs853VHdJYox
         ARcg==
X-Forwarded-Encrypted: i=1; AJvYcCVU/+wR/tMegUMSRHs//XF1OtB28IUEzkTR91q4qG/bqo98AvU8dBXx+Jb3Vr1GLun08bg=@vger.kernel.org
X-Gm-Message-State: AOJu0YybyeqHMeWFWqsaUvWO1yh4jn28oajR4IDinsoVD0xnDZBGFo6O
	+WxC5zxOcRKV+CcN6cErEpSUrx6h1ZeKtVJrjr0W4bkfZSP9X7BZeLdRAz/C9s37HRG0XzSwJL1
	9VCSOvQbHGnT8HQEDNlwpQ+IsViAdROo=
X-Gm-Gg: ASbGnctKK79fGo3rI9pM09alBkMXDcKIwhRuRXM0J+TEmkqIsBj2cXpBKh6sIg3izRG
	9tqTkHR2E52p0lyVW6LU7SELUNIKX2VS1FvjXfuwYuMBeihohlQ94HhyGLzwX4mAWMoHimlQYfI
	tJlwm5o2LPmyoU4BbG9Ne6UJt5pSYq0ac4F7jKdCq/yt1mhoRZ50doVcCbyojucr9dDD+GWpBcF
	ikq
X-Google-Smtp-Source: AGHT+IHriterOPD9Qupmq+qudDIs3lX0hEYmQnAcn5/ydpzgAlJ2/vmYB4mF9qSntvsAqaJGcsCAgwtspg2vcdcWQyI=
X-Received: by 2002:a17:903:46cd:b0:235:655:11aa with SMTP id
 d9443c01a7336-23dede92f44mr255478385ad.39.1752567376701; Tue, 15 Jul 2025
 01:16:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-21-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-21-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Tue, 15 Jul 2025 16:15:40 +0800
X-Gm-Features: Ac12FXwwngu-P7YkPKj3RPXnjWAGOV3pJHB2VxbIGQMRr41V44LUEyvWThpEouI
Message-ID: <CAMvTesB0bzdgEsqkKVxZW8LvzQg==Wjtq8Y08PmHjf_A23YwtQ@mail.gmail.com>
Subject: Re: [RFC PATCH v8 20/35] x86/apic: Populate .read()/.write()
 callbacks of Secure AVIC driver
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:40=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Add read() and write() APIC callback functions to read and write x2APIC
> registers directly from the guest APIC backing page of a vCPU.
>
> The x2APIC registers are mapped at an offset within the guest APIC
> backing page which is same as their x2APIC MMIO offset. Secure AVIC
> adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
> within the IRR register offset range) and NMI_REQ to the APIC register
> space.
>
> When Secure AVIC is enabled, guest's rdmsr/wrmsr of APIC registers
> result in VC exception (for non-accelerated register accesses) with
> error code VMEXIT_AVIC_NOACCEL. The VC exception handler can read/write
> the x2APIC register in the guest APIC backing page to complete the
> rdmsr/wrmsr. Since doing this would increase the latency of accessing
> x2APIC registers, instead of doing rdmsr/wrmsr based reg accesses
> and handling reads/writes in VC exception, directly read/write APIC
> registers from/to the guest APIC backing page of the vCPU in read()
> and write() callbacks of the Secure AVIC APIC driver.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

