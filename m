Return-Path: <kvm+bounces-3779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A5CE807B46
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 23:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA1DC2821E6
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAF16F60D;
	Wed,  6 Dec 2023 22:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rDyHX45r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0F0D46
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 14:21:49 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso1614a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 14:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701901308; x=1702506108; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V1+2VP/wFbYzasrbqfZWyaWxSqng1qwhzdOg/39SQxE=;
        b=rDyHX45reXp7S4s7uMXOdXhrQqv+IV3a+HG37OnVOVtC5pv+7rn+q5AaZB9jcyCpG/
         2RT9LLnqxm8wOLz2JjBxx4iyRC9DbUqDq/7pFSF30SfIg0k0bOJo5Ym4gOmTcg6b6wvL
         IOv5X+2bSDOK/vUSMTtv3nL8eT+0fRjdVKhYx3RC0Azx2F6S+kfRdC4aogkFkrECwDDM
         wXi9O7JORrVybX5ev+z01oPxwseUw3EeWPRbW9gW9Jh4jdP0SUdCHaPaGSeRgccTLMNt
         keyHKCphYXvGWeiIWB1+ghx3vb3cHTaIUPw3eAnTPvmkw6ckSKCXExYNzFB4QY8IGZBI
         r+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701901308; x=1702506108;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V1+2VP/wFbYzasrbqfZWyaWxSqng1qwhzdOg/39SQxE=;
        b=ZG1QBOBL5T4pjlZNuGNOrDtDkfjJLKXHNq16YYZED8Vr7ppra1yZdvyXFNXgUMm6EB
         sCzserMh39Rn1qYqNVeWw6cjpVcOlacCVBFBmgxb08lGwskV8AqDEi+iK2Hegxx3C9DK
         PvgiJNC+tx2DJCk2sujsn5iJwBDjeX89He3AWEd/4C3Xipwuzp7EwKqQg7XllEqBr49k
         A9NmAMWDdX67q4ANi5JLjEt3mcxrFCZxTpNKShwT/fgBxnIoJ115oA5MaO+duF20z17C
         zuJa/3JyBFoDMglOc+EhD5unD/q5iEfj4xrRC47XgY+sDXDXVAdgOGABb68Cf5yo9s75
         VLrA==
X-Gm-Message-State: AOJu0Yyl6umUNs4ExMtZlPozpOta3nqTprd/UmUGZNNVJiVRgC96M6rh
	3ljGMdLqaNi/5hmJyuhFFsnkhTVKRgy3tUtD4Tgh9YTSyaFxlq/fdT59EQ==
X-Google-Smtp-Source: AGHT+IGzMRLtgB4wQ1v5jCsfc6jBdJJXze82uCu85GqXCz1YiMep4yTLPkTMw7hh/R5DN2wxBEAqHmnBe3RIVlzWsqI=
X-Received: by 2002:a50:c35d:0:b0:54c:79ed:a018 with SMTP id
 q29-20020a50c35d000000b0054c79eda018mr150424edb.2.1701901307626; Wed, 06 Dec
 2023 14:21:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128125959.1810039-1-nikunj@amd.com> <20231128125959.1810039-7-nikunj@amd.com>
In-Reply-To: <20231128125959.1810039-7-nikunj@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 6 Dec 2023 14:21:33 -0800
Message-ID: <CAAH4kHZ0fQJDiZaAhVQ31KXths5n3g1dYdfivyR-HEXcOFOY5g@mail.gmail.com>
Subject: Re: [PATCH v6 06/16] x86/sev: Cache the secrets page address
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

>
> +static void __init set_secrets_pa(const struct cc_blob_sev_info *cc_info)
> +{
> +       if (cc_info && cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
> +               secrets_pa = cc_info->secrets_phys;
> +}

I know failure leads to an -ENODEV later on init_platform, but a
missing secrets page as a symptom seems like a good thing to log,
right?

> -       if (!gpa)
> +       if (!secrets_pa)
>                 return -ENODEV;
>


-- 
-Dionna Glaze, PhD (she/her)

