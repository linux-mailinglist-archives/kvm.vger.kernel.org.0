Return-Path: <kvm+bounces-18836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFCA8FC105
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 02:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C03151F23C0D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 00:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD3F4C85;
	Wed,  5 Jun 2024 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRgn4l16"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651647464
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717549007; cv=none; b=I92GXcYz76y1s/YkVQXfDMtD4wqVMxOk3Mqk/nEy3zD4CJz/IB09iKg9S+wRsWAzurjfVmA4JyrVcqA/z5BY+OgN93nJhiziVDoKgban2eidzsvL5hfHyTIuSm62VdVc+mGMH3gq5qU5e/oofcLofJl29ZIf7QUgPV+2AgdKgHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717549007; c=relaxed/simple;
	bh=bxiHTvW4fLj218sfZgJiWyyM2cX+ZQCrleLdQL7F14o=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Fq9yFRodxbHxRYl1aKqRxS8Tbb79M1xQwGRKxZMXkt/wQqUkqLQwOUBqzrZ5rARQZ5IUaas5deDcwpZXAOjBL403zWQOFuFz2xl83cdtThSgX3LMBVoT6IsQMAG5Vf8qbfGLISCYDw7jfIrnrNnh/1GVy1f8f2PGdsPglFQYg50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RRgn4l16; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d1bdefedc0so993244b6e.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 17:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717549005; x=1718153805; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxiHTvW4fLj218sfZgJiWyyM2cX+ZQCrleLdQL7F14o=;
        b=RRgn4l16SyWuUYWz8mficyiMmenm8uadfi7LP5fwfY7QbENMrzGstUsQjNc8kL3dl2
         fpiX0O0FUdSgcfNg3k05YimqKqZLZf1XVT8BZ37zbEjVIIBPgzTXp1KCRbnwiYZcX5ET
         h/Xn3kP5OeKaQrHQ8V/SN/CiThNT3/RdhMeKaDbtQqpdCZUqpTwnQ3rQKQZezy44ILRv
         WJZje/lTKbjGdPJVlI+rmlj3nyQJbunAxIEZuQfU/APyVV/chE/1F1HaVinGJefI06zc
         Mc4fp8HbcBkfUH+/uKnmNXZ/kGHD1UwSsaPTHoD252/to0MCP65z3eocXZkgcfOkAElc
         67jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717549005; x=1718153805;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bxiHTvW4fLj218sfZgJiWyyM2cX+ZQCrleLdQL7F14o=;
        b=OQjO1NrAaRkH/Uj2ocU1imGa0R10dGsoICH7QwUjdf27fSDtU+sNUWfmuJy7hXBpsq
         yOJTDxw40taRd1YgrNBoNEB756TCS3wa4uSR9cAzYj1CmkSzq30a/F3+sPMV7qhUFysW
         S/kiyP7xt59ikHgICEE5hLWWSJ8s50LF7LXFsnjSckVuqKIqO0Rkm7vCo1AOp+Etjenx
         DABNLEC+eYSv7qHqDsXN7yEqHTlOX5lF1DQVlw5DlZ2IfijSenRRXdAIyrMD/E33W44i
         7UHSGye+6NLwQynFGB/O0ndQ8nZr0nwIDPP9Q86LCpYNXkeWFXmpARfvgJxMEuquxUtW
         hh9A==
X-Forwarded-Encrypted: i=1; AJvYcCU0pV9igquoA0CBENpFgq9K004St2XzvqSesQ1rMTVzw+xkCEHlhxA0cltKpnVz7ZLMSAAhcuAvYhoVdxBW1lHyv6xS
X-Gm-Message-State: AOJu0YzrgkdeyOmT8ojVE2kqY5X6w/CUtwdicq6o5c2+LbXZPURV+PhM
	hMCS5EJCWDmrVhIlR3/8ScRVCN3pflsQSXNd1ZfaDx2WSynpJHHGk+MRHw==
X-Google-Smtp-Source: AGHT+IHZf0KMvKkEQxVk0jcPkbXTYisvbN1p0JsOySwpkK3+k5sAwhsFJ8dCrfGyMELfpVfU0S+dzg==
X-Received: by 2002:a05:6871:7993:b0:250:58b8:bbe2 with SMTP id 586e51a60fabf-25121d1ef8fmr1386345fac.4.1717549005250;
        Tue, 04 Jun 2024 17:56:45 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b048desm7873342b3a.143.2024.06.04.17.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 17:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 10:56:40 +1000
Message-Id: <D1ROB25JV89B.25ADSPGY2NS9E@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 20/31] powerpc: Add atomics tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-21-npiggin@gmail.com>
 <f559f65b-a0ac-4810-bc5e-11edf46b693f@redhat.com>
In-Reply-To: <f559f65b-a0ac-4810-bc5e-11edf46b693f@redhat.com>

On Tue Jun 4, 2024 at 3:29 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
>
> Please provide at least a short patch description about what is being tes=
ted=20
> here!

Will do.

Thanks,
Nick

