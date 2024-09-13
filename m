Return-Path: <kvm+bounces-26850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E486E97870A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8ED191F217C8
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6108984039;
	Fri, 13 Sep 2024 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lo51zDP3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341EA1C14
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726249347; cv=none; b=WpoJY648XgJi7wNvDEfNYKT+ZVgaqOpX1kEP7WNhxNbYYDHNaBmK62a4cy72430xYZz8m7Z34PV45OrRmGSPAeY2C6QznV6W/DH2P9YhH8w0LrSFNuE/nW6s6bv5s8qLvJHLxAoxJBkLzhuv1UHLUNyVVIoHaCz2L1Mu74h4bcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726249347; c=relaxed/simple;
	bh=173AQeyMDaJ45QZOQirS7+SDcWgIwJyD7RHQE/oNyVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rztzdu/zmmtgu8nTLqnfSO477Qt6N82HVXMgYt34Kmi6UxH2LCjZvX/U6EK66dslRNIptN34yvgZ/wg1Fxz+0HZxrbLASAEI1cWHgALUnK9FQdjMz9WtQI/GksFIiBF2io+3VGRvYB6m1cMeGg6S+bTDl8iGZ9iEvJfZXBHl+hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lo51zDP3; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a045f08fd6so14795ab.0
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726249345; x=1726854145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8W5LH9MX3hMkElj2Z0bxV+YjhV0sKkJFY50QdMlkH6A=;
        b=Lo51zDP3IUE12e+3hFs0NO/gHeNnl7/YLpzALvCUZAUOqJKXXK4bfwtVWVp7uP3vtD
         FJa0qOaIeRsdEa/qUA/QMbER1sHx/VmwODFjfa99De2b+CVosLnWoLqEjdK1BSojmnr8
         7XNzqdhv7sbQEd6d9VxXZgoYJsmrwHRJ8uUhVMobbf2Zw4K6e0Ojtrax/+RLra6n6Osl
         qLvk4cu0OJ+v5reI5smhmPT2Pgzjkf34iV/a4PBdbYfp0pp27p2NhSZ/tC/fIaae2YXe
         yBHu1mHXZhX8+Ofq+6UfvyyJin0aeTwsIUh1rUZEYcNGgV1tIdO9Z6er3mT779BgUKa8
         vN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726249345; x=1726854145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8W5LH9MX3hMkElj2Z0bxV+YjhV0sKkJFY50QdMlkH6A=;
        b=jhaPBFgtRwQYm5w+oLFpFwWO7Vyb0Okka6dP55qOweDW32AATw1P9AFAaRIeO7ofv0
         ruvzX8ETmEli3o9wQFVRMjqBU6u9B1pcGA3a24gIiOQNrqN+WDQysdIWADW2r+DLzKeG
         6MCb8BfIQc8rWs2UR5xB8xprFbH6/6+rDROZRyfCF6pj5U5GKYAgdRSMIqaBptbxNN2L
         ePs+jbq5zyg+qc8KIPMkNd10DN+3NicVqjmN/+hNBoacRYDQt0gnfQfU8LvC9mZbGnl4
         EcpQ9avulleEKUNEUpz/NdLzoiiGA1rbDxK4SmgwqBgeCwrPBWWkO7rEEeX3mVINl4lF
         rDXw==
X-Forwarded-Encrypted: i=1; AJvYcCV5UHrIGh4v0H/ypIY2Hmz88zvQkwxMDILSAqOjvHeP/rD3XeTzaPjz6RUWUheEYYjuzrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI+CWgwkn4JIexPaGjYN2IZ0+7rPLbaGGYsenBOn+EU8XazZCU
	SGECNod1oYVcS2pA3ZiCwQcOxmbfvmmKYgoI4NBemiKPhD/+jlHNJBR0pUkQR3uZKiZw0nHkkKn
	v9U6I5lHZ4zQgi4V7BABs9cYBW25sjQOqwiHh
X-Google-Smtp-Source: AGHT+IEAfzEpcAH80+98bRbDt00y7w7gSufYRSYoHgdXgSwFe329MnxAcBG0lIP7pS5hRLNyP4mhgzWnfrVP3m8JQig=
X-Received: by 2002:a05:6e02:1aab:b0:3a0:439b:f610 with SMTP id
 e9e14a558f8ab-3a0856cfd7fmr10007445ab.15.1726249345097; Fri, 13 Sep 2024
 10:42:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731150811.156771-1-nikunj@amd.com> <20240731150811.156771-21-nikunj@amd.com>
In-Reply-To: <20240731150811.156771-21-nikunj@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Sep 2024 10:42:13 -0700
Message-ID: <CALMp9eRZtg126iSZ4zzH_SjEz2V+-FRJfkw7=fLxSoVL1NTp_g@mail.gmail.com>
Subject: Re: [PATCH v11 20/20] x86/cpu/amd: Do not print FW_BUG for Secure TSC
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 8:16=E2=80=AFAM Nikunj A Dadhania <nikunj@amd.com> =
wrote:
>
> When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_ed=
x
> is set, the kernel complains with the below firmware bug:
>
> [Firmware Bug]: TSC doesn't count with P0 frequency!
>
> Secure TSC does not need to run at P0 frequency; the TSC frequency is set
> by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
> Secure TSC is enabled
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>  arch/x86/kernel/cpu/amd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index be5889bded49..87b55d2183a0 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
>
>  static void bsp_init_amd(struct cpuinfo_x86 *c)
>  {
> -       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> +       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
> +           !cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {

Could we extend this to never complain in a virtual machine? i.e.
...
-       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+           !cpu_has(c, X86_FEATURE_HYPERVISOR)) {
...

