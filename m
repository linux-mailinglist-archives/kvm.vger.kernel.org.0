Return-Path: <kvm+bounces-55129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D20DB2DE2C
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28F1C16DC3F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3631D3203B7;
	Wed, 20 Aug 2025 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbt4OfuY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2F531DDB3;
	Wed, 20 Aug 2025 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697367; cv=none; b=gAL1xLtU9pNvB8KsRrZYotWAGV6OYLX/LUSzwJseU4y38ORZqbpDSQ1OAs3jdksdXbw1k//HvkmHjR8G2azAaIirSilZiV9WqO97SbOuMif/ZDWcxsBLV8U8t3KvUjjK4jiutSp+d/EYJZ9OYslvN+by9T76YNm9iSFWVtCGxgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697367; c=relaxed/simple;
	bh=BJpR4+2dEY058fz/TysSP2l5ClOOJ/4EjTupVVdTWu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JV1YFG9bvydsDW4qGKUtaxFgCUXGS6KDjaA5Y3fTzPl/Nha8srX2nUCfS1gEMCMpGxJv3mOidBwcPvhRNwsF4mrfIBLNFgkZhfEZCtXuXmBCIL2tTVJ9STZPtlc072WrrNqnM1A7TAyy5gE1CJSaHifhzF+HUWhJm2efwsKipe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbt4OfuY; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24456ce0b96so10499795ad.0;
        Wed, 20 Aug 2025 06:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755697365; x=1756302165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4HJMfkk7KfG7pCM/eCrer46W2j/6fCWLFDAIs6olyc=;
        b=jbt4OfuYHMmUwkNJGLWncG1dNeTrkieiWuhPsUOIoVOCCUrceqdZK16RaaWPAkqb3F
         2pXgN3C3auC4r4jF5N3WNeSordeP0JZnETY5l0ZsPbtHIsobvX2qIGx+aWPA5+s3NTgD
         gNRNOuzpS2WXOVsRkAk9rPWB40ZKZJgR5A+dKh1UTGMsG6mzZPJGmB5NtP/IDJHIdQIC
         c+SUlhJBF8SA/c0LG28+8Q09R/AbZLEPfo7w1ddAVmYNP34Y4eSDQojHQC0zOgsuOu2L
         5KaBBYkaKTgaWITO1/g02UDPzUtKVX8TaErYrEdRrj4rEhSfxj0dbzRULCH8wCToYy35
         pC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697365; x=1756302165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4HJMfkk7KfG7pCM/eCrer46W2j/6fCWLFDAIs6olyc=;
        b=SI/grFNKY5R945P3pHfJmUVGlLowXOWQKazaVuYol29hbxKPbp2uI4xl3Nylce/Qs7
         /rRLnhl3vGZ6+ULcIp7yzasAvxOXETjPwfE/HU7VKSgORzzBmSLpGYWCU5ocQ1IyJOUi
         APxAqRdm6uJLQx1tlqMSTemPgGKSCUiE0fWKa+E64OHmeyYkuCG57vvVQXK97B/vbiLb
         yQQyXG/ZQu8vQqpQ38WRGrFtOC4uTqWM5ZY6lHL8acPly488I9PvbEfnxnF4okBCKgEf
         u8Q8yd39cvDixGb1AZ8DL2cR40+J3IN1HFiUWk9KzDJxoXSav2Pmph0qJoQ/qGrmtyED
         OSyA==
X-Forwarded-Encrypted: i=1; AJvYcCUog+oPIJhEoN8X7ECWD11flLDErUD0/FZxRtbSANyHmJtd8r9kE5o7tA5rbg4m8C6xOy6XtdopZevg+24t@vger.kernel.org, AJvYcCWcMJJT239OJkxT/rFLqXSzuJ8bQZTz8vQdz39NwU8KjwMWNtpolUlOoBLIw/oCgsI1RAc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy57EsHqgxUMkrG3wnMfqTdV2uSuF6QTwEuEsyshSsMCxr5XG41
	EEA9/kBPb7ZflIARcCAgRE8RB3U0goXmLYsOwywA/gZ2Qtjh4g7/eynz
X-Gm-Gg: ASbGncu7W4txZKAXbLVuOcilgi8HDLahHUBcQzEXoxkjuvLW3GCAjh9MUiGTLTtvIK3
	CchLMUsniofz4JwYBunSpJ5eYgcZJgDBvPo1jER6nGdllgwJ0JFfIt9ghaMGws+KfGN9TuIsSnX
	IUV81Ng6hW67Jkv9WvW+3hkdCTyrnj8aUQj7KyoVAwzkzxMV9fif9Thzyqtk6JLgT4hNNAqoLXG
	d9B6lRn9Xmq1b3AHaPIpX+08advmsRclxOESgGQ1g58IoPDAF1+v0AkQ5aA7LGPIVp+hW/EFr/P
	TduzezeMMtMvNPyhNthdrhp3nGMOyxrN191UfnxQvB4ux+TfTkZ4bXehgt3oKyiAXtXgFdbYjTy
	3iOlVV3LI4QbRerE2RWmPCA==
X-Google-Smtp-Source: AGHT+IHA7rXRRnhAmz8+D15MEbDYIgERNhxCNCWamJeiXomnEmGMJVe5kcblPFlrGXqwHCCeV8gqjw==
X-Received: by 2002:a17:902:ccc4:b0:245:f860:80b1 with SMTP id d9443c01a7336-245f8608e29mr13810195ad.11.1755697364554;
        Wed, 20 Aug 2025 06:42:44 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed377843sm27689175ad.57.2025.08.20.06.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 06:42:43 -0700 (PDT)
Date: Wed, 20 Aug 2025 09:42:41 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: simplify kvm_vector_to_index()
Message-ID: <aKXQ0Z4T0RzVnjI8@yury>
References: <20250720015846.433956-1-yury.norov@gmail.com>
 <175564479298.3067605.13013988646799363997.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175564479298.3067605.13013988646799363997.b4-ty@google.com>

On Tue, Aug 19, 2025 at 04:12:11PM -0700, Sean Christopherson wrote:
> On Sat, 19 Jul 2025 21:58:45 -0400, Yury Norov wrote:
> > Use find_nth_bit() and make the function almost a one-liner.
> 
> Applied to kvm-x86 misc, thanks!
> 
> P.S. I'm amazed you could decipher the intent of the code.  Even with your
>      patch, it took me 10+ minutes to understand the "logic".

Thanks Sean. :)

> [1/1] kvm: x86: simplify kvm_vector_to_index()
>       https://github.com/kvm-x86/linux/commit/cc63f918a215
> 
> --
> https://github.com/kvm-x86/linux/tree/next

