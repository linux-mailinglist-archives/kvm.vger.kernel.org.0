Return-Path: <kvm+bounces-27017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0256A97A845
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 22:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAD0C28989B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FB31607B2;
	Mon, 16 Sep 2024 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AC3q+ryq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D302628C
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 20:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726518125; cv=none; b=LlfFS0u9641iOnD5FursKbJgReFhYR/P4SuFzAi7AATkdQ8I5zVAgAZSfpcF7/Lep1Afv0o9bfGO7QGe50Y0JokuvZo/hq8JoPLDGQowlzWP9yurMi2vpUnUFG9Z1FldKrQxra/IawrRgXH7tilwuMZoOdaJMAU6H/N0VRdaq6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726518125; c=relaxed/simple;
	bh=YmvTSXeFpvg1WiuPNN+DU79epp+KvBjGoefbthLwZos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aIjNND1QGYLOs8z8H68Awg//WYnNkYIJsNJ0Ea6HWHZ4AUQAk/fVUTzQab20qLoPg2tykVBY7/6zzNlEcv3Cqlr25h9ErmkVdhzwjrWka8yE8OkMVwKg6rWi3U8YkStyu7Uy9Uv5VEEBSl2f47aYgQDoFJQZdQzhPnTDw5dH7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AC3q+ryq; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a09adec1c6so51615ab.0
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 13:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726518123; x=1727122923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/tWU9dYH0Wg588rEdTckjBcZ0hitcl6WMmt+VKANOBg=;
        b=AC3q+ryqUjohN9sQjFo0XpN4XAMcw2G/1ax3xUNETGn81ySV4Hc3ijoOSki0MklzyX
         ZGJc2IcKZ7vpLUi5i8uxPGiYY4whecGArv15+qjrTb8lmwDgTI6xQD3/MIRpX7fWZvFI
         yMu/wpE0k19IgKiNMsPkOyUX2PJ7MvG+FLl391lfvnwL3Vc+uV9TNYUZuMAxB30LfqsV
         Uw1MNF9STTjFWoDm7YBEDVDpVsXY1bn5854v98QwlQz+50iUuCt0zbCJIb/UjLFxfXjN
         nFEqS3/IBgyOrIPnEQqpWpW1Vd0r8SY2d2JedTinibVz6Mea6vpTxr4/EHt6L68nRLLn
         yizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726518123; x=1727122923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tWU9dYH0Wg588rEdTckjBcZ0hitcl6WMmt+VKANOBg=;
        b=RJyaTFaNwCf3Ofwk+g16qowyGROF5NSyzYXAuxT2sB0Frxu9A/1d9qEuToc5rlEvcZ
         c7glfHf8mxtEU2O+EMRITo0UFYYExRiG/uy3MSpkJR0gYsuVYaBMBk18Cqgalo5VGZT4
         e8p06zyyHOLstb69irAXJreLNx7mokJNhSy18tPCqICCyNCtcNQJS+y5JNk6DKYfIblq
         uQCbOqi6+j6klJOjmzvKYjVgqbKfl/tTmWHbJNroH7ONND60XLKLNosI3F3yK5URWdaY
         lLQ+O+AUMC5G6WVLYxgfgTxi57Tl2F1v5Z2fFgdoqT8eimBk8qZ9yUjFx1JzfUTPl8eS
         0KCg==
X-Forwarded-Encrypted: i=1; AJvYcCU9lKqcsZ651614P3BpbAqHPlgJ9yDgEJhYI2MIVA+Q+/R9F+3IrjgYA/s/jg19MJqksXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEDkUSQ/MUxywP8gW+xv8TPkK2RYjdl6VjvgCc5v2Z5T+LAr9H
	3+PDSW9uLOYxyw5G+m5vwYtZp1WUCk90jIJ+AplgXBtwxA+7wg0riQw9G0Q53q8XKNhPEv17qkL
	GU8xgKzEEXLGQSFhH1zsSzXfrnvDLthd3sOt0U3xX7MjfoflNVDQC
X-Google-Smtp-Source: AGHT+IHRhtIj7Meb+xM9gMbaLW0KsjhV9BlWquFJg3yGPP749YUK4dUV+I53y7tBSsOQZiylyGsC+uGU13MPsAYC1Ik=
X-Received: by 2002:a92:cb46:0:b0:39d:1b64:3551 with SMTP id
 e9e14a558f8ab-3a0b1581565mr564545ab.19.1726518122934; Mon, 16 Sep 2024
 13:22:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731150811.156771-1-nikunj@amd.com> <20240731150811.156771-21-nikunj@amd.com>
 <CALMp9eRZtg126iSZ4zzH_SjEz2V+-FRJfkw7=fLxSoVL1NTp_g@mail.gmail.com> <7fe54097-20d8-fb9c-e79d-b62910b50154@amd.com>
In-Reply-To: <7fe54097-20d8-fb9c-e79d-b62910b50154@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 16 Sep 2024 13:21:50 -0700
Message-ID: <CALMp9eQGdwun8NSgJC07VpN_TRMWZ=hsMLO1F7hojh5vz4bquQ@mail.gmail.com>
Subject: Re: [PATCH v11 20/20] x86/cpu/amd: Do not print FW_BUG for Secure TSC
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2024 at 4:41=E2=80=AFAM Nikunj A. Dadhania <nikunj@amd.com>=
 wrote:
>
>
>
> On 9/13/2024 11:12 PM, Jim Mattson wrote:
> > On Wed, Jul 31, 2024 at 8:16=E2=80=AFAM Nikunj A Dadhania <nikunj@amd.c=
om> wrote:
> >>
> >> When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007=
_edx
> >> is set, the kernel complains with the below firmware bug:
> >>
> >> [Firmware Bug]: TSC doesn't count with P0 frequency!
> >>
> >> Secure TSC does not need to run at P0 frequency; the TSC frequency is =
set
> >> by the VMM as part of the SNP_LAUNCH_START command. Skip this check wh=
en
> >> Secure TSC is enabled
> >>
> >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >> Tested-by: Peter Gonda <pgonda@google.com>
> >> ---
> >>  arch/x86/kernel/cpu/amd.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> >> index be5889bded49..87b55d2183a0 100644
> >> --- a/arch/x86/kernel/cpu/amd.c
> >> +++ b/arch/x86/kernel/cpu/amd.c
> >> @@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *=
c)
> >>
> >>  static void bsp_init_amd(struct cpuinfo_x86 *c)
> >>  {
> >> -       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> >> +       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
> >> +           !cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
> >
> > Could we extend this to never complain in a virtual machine? i.e.
>
> Let me get more clarity on the below and your commit[1]
>
> > ...
> > -       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> > +       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
> > +           !cpu_has(c, X86_FEATURE_HYPERVISOR)) {
> > ...
>
> Or do this for Family 15h and above ?

I don't think there exists a virtual firmware that sets this bit on
older CPU families. In fact, before my referenced commit, it wasn't
possible.

> Regards
> Nikunj
>
> 1. https://github.com/torvalds/linux/commit/8b0e00fba934

Something like this is necessary for existing versions of Linux. I
would like to have set HW_CR.TscFreqSel[bit 24] at VCPU creation, but
Sean would not let me. So, now userspace has to do it right after VCPU
creation. I don't have any intention of adding the code to qemu, but
maybe someone will.

