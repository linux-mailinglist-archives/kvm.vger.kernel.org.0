Return-Path: <kvm+bounces-21417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AA192EB8C
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 17:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5328282F75
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 15:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AD916C684;
	Thu, 11 Jul 2024 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hvjjQqIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5541EB2B
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720711186; cv=none; b=iuk+h63uJ4dwxwgch/cKbACJnBKvudjPwS5XzBNpQUAwK7mGEYwrcN7fp+D4Re5MJ6JmTTzRf4baRvTnWuxQU0kuB8SfQ1OlZFnbTAgoiFtlIrWdKePHXTKIfJPuuoCdwimYBtgJ8g5rtcjVN+70FHqEACIUdiXSg7rsKGN2aXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720711186; c=relaxed/simple;
	bh=2+bb+QpkBtNT8cHJOi+ZnFpY17WUiJVy/iDMJg10GLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kmAyLA16T7Hnl0uVlIOssIRL4fsV1sMX7V+F44x+F+2FZi8shICou3Gj5uDoovx4b+TN80kaGBTqcTiQk9mSadSdNN/lXeovyBmwb7Cv1UVOHJrVl6TD4BHZIpspXoHSYOoCvksUzFMajR7v11j4GGX64bGQAy1374IVGWTg3ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hvjjQqIM; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57a16f4b8bfso17242a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 08:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720711183; x=1721315983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+bb+QpkBtNT8cHJOi+ZnFpY17WUiJVy/iDMJg10GLg=;
        b=hvjjQqIM97atANHLuYnpBmgnOsg/biOrQ1LurrY+jpDWksUQUJIO1r9iquhz/oFtN9
         9IGnvcWIJ2pksP3eDd67yUaa5chlexaqpsK9/KRAaJBXldEJBhDNzegj64nwE8/NMxC3
         iPiRJEG0a+5mi2Ppn/DIkTvmeJ9mKtgUhmkSs6zb4nzM+WYB3CCkvvPPEw+0H3QhILV0
         CrJPpS8v8tIgyMpexkgd38CvoBCefT0eHEG3E4WQMKlAVm7fHW6zsiNSx16Yeax/3Zb0
         eF1w4jV20I0v2+W2eeWjO715VEukdG++klVdRrsuZ6Olk/dANMF+/1sdBvH8g5MTcYxb
         AorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720711183; x=1721315983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+bb+QpkBtNT8cHJOi+ZnFpY17WUiJVy/iDMJg10GLg=;
        b=M7hVpATvao5RR3YylYy4FmiX+S9ykoXtlleUbnHi+O09+s2J2njrk0dM4QESe0la26
         0/h+rXfcpvKripkw8A6EvlGxAwWQmO1Hh4rP5fHwbynigQNem0JNenvxXXnjcCivR9Sr
         bAZmhR2HJLB3OJ0I/pvaIrHuYgzCPgWAqJ4guuwuUE0u5nhav18xX+LUi+cOinuCRD9/
         W3lrugSoLkpFaCNkIbt7BT3NnVzisArKJ82O2qm5sHT13PX4E+UGctBcf5pPKbq+5o6N
         jO/Ad+hIA/wegS3sb/zXbGJ3MmS4XQv8bbigJ6HTWNQKTwem6KImiALAxQ5WTWBy4GVI
         zctA==
X-Gm-Message-State: AOJu0YxbGaJtHSOXRVFv3rOOM9rJKo/nKLDT8acRJdee6GIBhYhgqw8r
	4zYwzIHJr5DileiloiPT6Elp7zOanxoR4utPTfj4lSx/u4/eihp0OvWAg0Rwl4gQMVkaY5nwwg9
	xXWvq4/MrHIHVYXWZ6to67PGs4TETtmJftt9y
X-Google-Smtp-Source: AGHT+IFUZHGB/MYTQ+AEtXTIG2MUpAJou7TV7BlhO3k/D26+Cr+yw9GU5imU9h/cKuxSPpspQWgJZ2uy19SIpgHSl2c=
X-Received: by 2002:a50:cd8c:0:b0:58b:93:b623 with SMTP id 4fb4d7f45d1cf-5984e8f5e6fmr182082a12.5.1720711182527;
 Thu, 11 Jul 2024 08:19:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com> <20240710220540.188239-3-pratikrajesh.sampat@amd.com>
In-Reply-To: <20240710220540.188239-3-pratikrajesh.sampat@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 11 Jul 2024 09:19:30 -0600
Message-ID: <CAMkAt6qtViYTx_xfxt=4VQ6TQG=53X-ZdEZ84s8UrZm3p-4brA@mail.gmail.com>
Subject: Re: [RFC 2/5] selftests: KVM: Decouple SEV ioctls from asserts
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, shuah@kernel.org, thomas.lendacky@amd.com, 
	michael.roth@amd.com, seanjc@google.com, pbonzini@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:06=E2=80=AFPM Pratik R. Sampat
<pratikrajesh.sampat@amd.com> wrote:
>
> This commit separates the SEV, SEV-ES, SEV-SNP ioctl calls from its
> positive test asserts. This is done so that negative tests can be
> introduced and both kinds of testing can be performed independently
> using the same base helpers of the ioctl.
>
> This commit also adds additional parameters such as flags to improve
> testing coverage for the ioctls.
>
> Cleanups performed with no functional change intended.
>
> Signed-off-by: Pratik R. Sampat <pratikrajesh.sampat@amd.com>

Tested-by: Peter Gonda <pgonda@google.com>

