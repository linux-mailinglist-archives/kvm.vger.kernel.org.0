Return-Path: <kvm+bounces-54007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5155B1B53F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01FCD1835DF
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDA9274FDC;
	Tue,  5 Aug 2025 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P/wq3biC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4675B17BA6
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754401791; cv=none; b=WzL0UqmpCPYsfJZxNUp1dr6HydhHYjOyl6hkxIK52Sf4EzCjpGOslESq5uJ3n9aDt5S/AxCo5oklRCiL2oMGOS9ySns9RxPcwPv74UaXH8wD1uDaX3cT7Jujsj8woUCzM3faxC7ksrMobN6ZOPLtJhbDqnlcXrtnfGoo9yLvzT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754401791; c=relaxed/simple;
	bh=xSf0T8NPt1UKhAqAic5exYt41gSrafSzFDLJUI/35cE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eooOqJ5i+6acPgj2P2PDbNI2Cq8vEnuYOAZKHGltEB6HFlRjnIUD23PfVhfZqo0E/5LhIMcbs8MaAJSeNP9kXHGHTUC00aClbTzcBGWUuVIBtTNBLiufrudFkvukATvIvFwLUSRYIv2DlS7/Ykwv4QhBP6DhHzJ2uf0GJS3Abyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P/wq3biC; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6157ed5dc51so9798491a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754401787; x=1755006587; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l1IiCNwMbxf65Gn0A5vCk3b++p4e2fX7StqpL55rBUU=;
        b=P/wq3biCizIr4QCgcKhVv/D2OeD9MHdyNWTcOL8m4OMtp4d8OMTp2SbllgDiKq/OD/
         bnywr3arVk3od4yXnVzODwmFTfSX7P/gZWB2GMu8iGXdNhLMtlBKfFkzpfIchxNNKfok
         Kdl2LVsYQTDRCnP+4XwG5+8WduV64m+Ke2CbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754401787; x=1755006587;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1IiCNwMbxf65Gn0A5vCk3b++p4e2fX7StqpL55rBUU=;
        b=V9D/FIFVrJ5RsHzVonM6i2aVNlT1W9FV20hMRNaaHL/Eq/2WNl+sP75CEY2eQl7dE4
         is5cvTbSzPizaCAjBJigqGY56AFh52LpXstqpQbGa9S9RLCze7z7Bc9lApj3Kdc1im3z
         ZO0FktfPabd6T6SSg/AytIf3QWHbatfZAS0fiUevqix9qyg478OxkRaX/JiJ2+OUBDYQ
         AJlzDoj3evnNzLVTVOXVsEQ92mZn1aCxms2yBDRFCsVbcpVcxQzu76MS2u4Zep0GnD5w
         2ACLrCsO5EhKdawZ0HQW6eUkNK5bzgikLym0BwzlvvvB3yxI1V2vK/vRh4FWeP7/ETL5
         YBBA==
X-Forwarded-Encrypted: i=1; AJvYcCXOmFghc7SeJbJ4qDOuPUaslKiM607ejdv/yo5nCc6UCq0ajG9l36pByj6G6mWz9sZMNko=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrH1Vk4+5zELcBRWssBp1QSeqA9JUwC098CkvR95lEQZuOg2uB
	HhTZnoWHO2aiTXfbJxAbTiywoERrYw55izYN1Aes22/jgWV6T3KSIdCbNHGKfgpuWOPRJlck1w/
	j6O4DwEcmGA==
X-Gm-Gg: ASbGncvYNciB7izxKpoldbqwlDUt556ElBmpysNUqPJV7lAcYaaVwGbh8+ZAn7uWxXt
	GZH1hYSMFyYHnXpUCsrDR7p4RlZ4GGkkcvFfkOO/HQbO70/OTq5DtsZfAdTZBwnPLfxtQqM+Gg5
	tEgWJdIMeGfBjJ9wHbvkHSXY7YMZidUIlTNQ9LBBM8SfFMrNZlNkE0vIOQ5yphIlmg75OKUenOy
	01CY3SdoC+P2BeYyaL8sWUQkYaiVGf2lMZ30747FXP0RVWRtE7kM2YQRsRPJ2cddPRoQqk3GZ95
	3EtiqR/KcufwKbSMmP2Z7XDa00sYCPsVUPrmxvIsmr3eT+TwQNdL0bMCGRoEstDV4I+PNEiFN+l
	D8DGL6CGlE24Q5DGmippRF2+SoKKkl3f4wzD64b7cuesIBe9ftnWVhnnVJHroZbV4ZYFFZu6a
X-Google-Smtp-Source: AGHT+IFrrB/LgrWHiDkSmeG1okoHMAZj74PW9YmcOhz+6bhJupEQbtlM9OlFL7I1lJZo0ad5ABQWjw==
X-Received: by 2002:aa7:de89:0:b0:615:bab3:9ee9 with SMTP id 4fb4d7f45d1cf-615e715b8camr10212318a12.26.1754401787310;
        Tue, 05 Aug 2025 06:49:47 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a911567fsm8237767a12.61.2025.08.05.06.49.46
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:49:46 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61589705b08so12031556a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:49:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWJDEn2l9DNcWHKg02qNDTtie8Y5Tf7K13QPsapnCoD9hurglwGYWPivfnZeyCtOF0FJf4=@vger.kernel.org
X-Received: by 2002:a05:6402:5201:b0:615:eeb4:3a26 with SMTP id
 4fb4d7f45d1cf-615eeb43e5fmr10589970a12.17.1754401785931; Tue, 05 Aug 2025
 06:49:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com> <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <7f891077-39a2-4c0a-87ec-8ef1a244f7ad@redhat.com> <CAHk-=wgX3VMxQM7ohrPX5sHnxM2S9R1_C5PWNBAHYCb0H0CW8w@mail.gmail.com>
 <623c315b-b64a-4bb0-a5d6-e3a2011aa55a@redhat.com>
In-Reply-To: <623c315b-b64a-4bb0-a5d6-e3a2011aa55a@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Aug 2025 16:49:29 +0300
X-Gmail-Original-Message-ID: <CAHk-=wiYLcax-5THGofwk-SAWYZ1RsP08b+rozXOm0wZRCE9UQ@mail.gmail.com>
X-Gm-Features: Ac12FXz3lI4E-j__TY4v_LJzzfEvCanQDsyxBrbM5v_ORnsVlB0ZNjSgcHSRh24
Message-ID: <CAHk-=wiYLcax-5THGofwk-SAWYZ1RsP08b+rozXOm0wZRCE9UQ@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Aug 2025 at 16:37, David Hildenbrand <david@redhat.com> wrote:
>
> Ordinary buddy allocations cannot exceed a memory section, but hugetlb and
> dax can with gigantic folios ... :(

Just turn that code off. Nobody sane cares.

It sounds like people have bent over backwards to fix the insane case
instead of saying "that's insane, let's not support it".

And yes, "that's insane" is actually fairly recent. It's not that long
ago that we made SPARSEMEM_VMEMMAP the mandatory option on x86-64. So
it was all sane in a historical context, but it's not sane any more.

But now it *is* the mandatory option both on x86 and arm64, so I
really think it's time to get rid of pointless pain points.

(I think powerpc still makes it an option to do sparsemem without
vmemmap, but it *is* an option there too)

             Linus

