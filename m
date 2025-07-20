Return-Path: <kvm+bounces-52949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A80BB0B3A6
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 07:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6793C3C172B
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 05:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5881B0420;
	Sun, 20 Jul 2025 05:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+eME1NM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646DC18FC91;
	Sun, 20 Jul 2025 05:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752990611; cv=none; b=cBLZsfd068VFxj9e4xmEXAFltLrTAaI9vjqwgBqp8uC8cx4NKD9WxvrvX9kJcr8O7EcCwIPK+OMHIZAf0lnVu7x6DVnhWAY1qyHe0NCMgs0HUH23TA/2xNLdf0q6ydpx/ajeF9V0R9y+nbOTGm373nMsBs62zc68MsKvMrqv6+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752990611; c=relaxed/simple;
	bh=3U6UxsWky3dahjtmkmt2ApoQswLk4/FsImCKSI7EuI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yl3YnzYwb+03XbaTDEX5e2mY9JSxDsRrqIhhXYYB84WYw+PB/LvSlnj8z7vDjZ60vdTD+/85nLZl9zp2Obl8ADtzhcHBbsLb0NzQSMonn0mtM7Xwdo8vdqN8bKCxJZXNynmlOuZl1G1lNrpnnj9Y/woEN1Q1vCvUe9VHpGbd7L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b+eME1NM; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3139027b825so2625974a91.0;
        Sat, 19 Jul 2025 22:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752990609; x=1753595409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RItHMLVgJL1j/S3znZFuA/rLavbPRS5U0ohgaBq2gAo=;
        b=b+eME1NMbKiCTS7aFy8IzMLZ7E7sDNubLlnU/jUNZ4MWXCCgFVfughgKmT0iW8tCrF
         AtLAgYh0ODPM7jWHBhK2Zn1NsU94VqtqU3u2Abn9j1DFyGAY0dqTlFC0cminWzE16oXH
         8NJ+JJ0CuhHhU5MGrKzR7sJbkwKDLZc/O1yBsuJA6n9IQDhntJNt5saiFY8JI5tcYGmU
         8h8JEK5b/SlsDFoc/gXYf6McXCuhcnX1ValiQFFPM6/wEup626BwfkxK/sfmJ1aAuQ1E
         C8zAylKKPoL85nmN7wUtUZi3bJ7mVAqDOoG2MZc1x36lS2cxRz54JnEh5DQWG0GELNJL
         IlxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752990609; x=1753595409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RItHMLVgJL1j/S3znZFuA/rLavbPRS5U0ohgaBq2gAo=;
        b=bx8UcByC6ICX+KC6njtyPaa5MArDkfPko1TzhbCVg9nNYs1J3XrdoPIjaeG6L8JSp3
         JYNbzaQLw21e1W37e1pdokAa+dXX3Hv3iSVcgP8qK5kDWB450+JUqYrJG1w51Fh1Rtkh
         Wt5Ev+j9ZR9XzxJJTt7AlzltEkPhASgRDVaeD+zyYXz4gcJhryGk8TzrwWVb0YBnYrL4
         kK2l9xRcCb6Vnhg17LorY4QvGrt/lqXHHydIUQWGk3oR49uLXgjEXjl22BV2DrszkA38
         bvCLL6A3Ov1EdiokgRESRNQtsRbkKJOHy/0DVPqE329zcTICzBnvk2qNjEJvzpHxa/E7
         KLDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSMjvZ2Q1ChlgluCEz3mya+ER0JWfm0EK0P1w+/aIEkWamjXpEPBuT4CvJziBa0TOVf+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGjuoyZdegzn0hu0ReIjxgdBxQZ1cFhNsTUFsy+kwB7HOUTjQ1
	FVS4JRskxrtaJnlVoYk/ECmkvavH8z1d7OI7twFVCySMHF0QhE/2SEYqC4Svl8YAWpz3P/D/K6T
	tASb3LYIeXqS/aRZKeK2vNQz2f5yQtdU=
X-Gm-Gg: ASbGncuvXGhuuHmGMRuXgTktQ1Sy7uHFHPNnTL0QcMZXi+lCHWwZExmi5n2qnSycxaS
	G3QtbVtSoDUNpou25SDNnldDSOwWqTPcZUPifT1LTHPU8yw6BS36XruwoXet85QPJHFKLlCLUYc
	iLEl/TFJZ0GiDJRZP34RxQM3KBCFPHRTDC2zRuvpfBZXx0r55R1V7mb0mCt+YZPU/3PRvXL8U2a
	qwr
X-Google-Smtp-Source: AGHT+IHcjGGV4gYhksR5wBuYn6dSEtWgaAiKy1vlemWMF+3fAuzDMa/U6eALrEVWhdV8ChQjwDa9ez+dAEVRQCt3308=
X-Received: by 2002:a17:90b:1e07:b0:311:9c9a:58d7 with SMTP id
 98e67ed59e1d1-31c9f42e8a1mr22952797a91.19.1752990609559; Sat, 19 Jul 2025
 22:50:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-36-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-36-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Sun, 20 Jul 2025 13:49:33 +0800
X-Gm-Features: Ac12FXyLuwSwZuxmIf6tMACoKGRhsl_cIyPsVf5-zrvZOqW8lxaUoPJzMndgeXA
Message-ID: <CAMvTesBRE2oWxByrj6eztstOBF1t2MjukAfU3+Js1bJH-JRtxw@mail.gmail.com>
Subject: Re: [RFC PATCH v8 35/35] x86/sev: Indicate SEV-SNP guest supports
 Secure AVIC
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

On Wed, Jul 9, 2025 at 11:45=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Now that Secure AVIC support is added in the guest, indicate SEV-SNP
> guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
> enabled.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--=20
Thanks
Tianyu Lan

