Return-Path: <kvm+bounces-58811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD61BA0F5C
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04BA11C24F0F
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45E43115A3;
	Thu, 25 Sep 2025 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kEMfcTgF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC413064B2
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758822903; cv=none; b=ete45xoMP+ks4heNhmfsEt79s3cy+mHh4f5nhBdOpQpOOBHP9QMRLJqCmNCfqXfFoRvyBPPe6Wmz1vlOhBLpuCbveBANeHwTFGE5JyRpQ1gNKtS/8k6Q/cxgFX8pS2swfZDgZThw4USChuT5GifOIJE21a+UbH8e1qqNIWpoflo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758822903; c=relaxed/simple;
	bh=nbPCHfJ+LLlBruT2Jb9S8w0HTGCja4pN4K+XH7Xc4jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vdp71nU/vK6K2AwE5uRe0Ksa+moLJh1DGUZNaeRhqyZvcrOYnrSZGFF0xosGQ0N7MNxLWkvMGjfyq5/JAn33dKpaoLhq/nXfbcV9CBm4M+1ldhDRtJAkCygR59YOPNKyV3TCJ6VIfTOuo+wnkxVTVNo4k2omcO/Sj77Te6W1PZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kEMfcTgF; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-62f9089b957so1223a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758822900; x=1759427700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbPCHfJ+LLlBruT2Jb9S8w0HTGCja4pN4K+XH7Xc4jg=;
        b=kEMfcTgFw0ltHu13Pg/EWgspDruLGxYnWDotSauAa0ymcDoC7rYhZo2VSJeNOQ5kIQ
         LlC2q+nwS+9KGnZpJVaNQDUa5832bEfCI/mi9112eUGc0wW5DbYId0q9ihqqk5qXK5ns
         2xOSrdVZL/A0nO/8W0RjjpEBhp4Bvpfqu1HzqWbgQbZl8rO5CsjN/FU+N1ARWupbKEyN
         oARaFG6DQtcEgjtGAaFLpGeybf042tOS7gKYOK5i2PGr6gVS8OeRJ6o2VILm4rqDa1VX
         oBuTe4LRdbFCPfJ/AFIw29DiwggAIXndAYHwcN6Xy/IDUFgm7iIPkY2Mi9i+GIwzo1jg
         fGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758822900; x=1759427700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nbPCHfJ+LLlBruT2Jb9S8w0HTGCja4pN4K+XH7Xc4jg=;
        b=ZkW0goGhgpYxhoEcDZxyVRe0eQuUiuB2C1ylNx/i+n1cDzY1XEMAAIfSzvIRkIVfIp
         4tAN+hwS8BsDGsvDtsz8d0Sc+2dGAzJiXnTDyFmutJVPGUNLIyb+NfidMKxz+/zNH1v8
         Q7BKO0W+OLx9tKb2g0/sROR6nxNaOcrvQwMQBhRLjh47h1s5rdR7dkeiWAzUAQGQh8vX
         XuRIZhW+8CDajaU7fFQhaYjYrX04+CqnWGnBF7zEQ36ZzAZidQ94q+EnOXD1Fxice16n
         jjVNAPljfMAt1NvPyyDczMrMd9ej6LzRUkAJeuIKK+3JpIrE6Bq+6jIzHQ5D30IG5Z5L
         qiDA==
X-Forwarded-Encrypted: i=1; AJvYcCXGFRizN34LCrhaMy/Bt6IID9AK7PBUT5S36OfIM7j4256djd2dwZndqE0H0rk0Fz0hvFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuThTWafScJvzdpKksQYjKetycXk9TsJo1ze5cSVsfnXzE07NM
	MJVAso0cZly6uRSGKtJi/XTYmiYEuwinTbjTNKe228F8drmE7/ll5f85GRxtmVtxNfWN4qaGzvj
	683FjDxB4iGmsCj4vC0K75f203AMLgSe+XnQkBQgC
X-Gm-Gg: ASbGncu3VHN6BcxAtjn9XHOFiYIQZycSKumBqV9wGNvAUcmHJ/v+rXTn182l+VQLhWt
	cS0EDps4vVo9T+vyTdSM5MQ2fhsMBnO3JRvehTDNsxAeH3GsTas7RoFvbo7c8LxllUkGFXds7i2
	D27wpuYX92KuIyIsGPGcapwwvwCL0LH/wiNdSULnRn5ouTBvNBsORvxKyc6oUf6AjqstxsmyUjq
	0WOF/dRdYyFvA==
X-Google-Smtp-Source: AGHT+IGtWrFCQ7mHkGVN8nL9J3bywwrPeWB4MitTqY1IKv2q0yoGPb264XUgeOr7c8WslC5vIz11r/IeITZc/CAugP4=
X-Received: by 2002:a05:6402:703:b0:62f:cb1a:5c43 with SMTP id
 4fb4d7f45d1cf-634b63b6099mr7603a12.1.1758822900121; Thu, 25 Sep 2025 10:55:00
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com> <20250924-vmscape-bhb-v1-1-da51f0e1934d@linux.intel.com>
In-Reply-To: <20250924-vmscape-bhb-v1-1-da51f0e1934d@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 25 Sep 2025 10:54:48 -0700
X-Gm-Features: AS18NWC5T26-RT6cIjgQmdeDLluP8Y_82To_ggt5vVuXe4Ii6oC9sC1vUudwIWo
Message-ID: <CALMp9eRcDZoRza7pkCx_fmYZ9UZDGRAXQ_0QP=v+pMMBKx4gfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/bhi: Add BHB clearing for CPUs with larger branch history
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 8:09=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> Add a version of clear_bhb_loop() that works on CPUs with larger branch
> history table such as Alder Lake and newer. This could serve as a cheaper
> alternative to IBPB mitigation for VMSCAPE.

Yay!

Can we also use this longer loop as a BHI mitigation on (virtual)
processors with larger branch history tables that don't support
BHI_DIS_S? Today, we just use the short BHB clearing loop and call it
good.

