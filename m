Return-Path: <kvm+bounces-60569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBD1BF37FF
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 22:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 374A334EF82
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 20:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A941A2E62BF;
	Mon, 20 Oct 2025 20:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FUGiufY8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C442E11DC
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760993477; cv=none; b=Dm1F3OtpMR+JYRK8219xKCd1MWTyJz3tPzNo0ABB2o0IMtuMBfKItbQRA43qNZOppDiKu9uPfxwv6F/jrxCiyNlu/k/Re09UbxKr9uEV2oUBmqZnrjSKmxSMIHMjuZ6UVrzzElEp9jRj9nhmV3xZJSfXZwx2B4cPegJ6Xzu2IHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760993477; c=relaxed/simple;
	bh=d/DNocr10We9+tRibfaGdS7+LWNCjniYedbAm0aObrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TsAeUGjGmFMqlHPd46MGOZ55og1+BsUREI0Fx8CMTR3bktEYE6QelejU4YD0ZNANp56O8plkLYLLUEwva3hozJ/rjLbD4C/GWS0sM1PtZOrqzkszLNhHHXer/y79Eog1FNJQQ9wDG/JqHTIc+YZ1Sg3atU0loKLzldFzxoYZHzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FUGiufY8; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-57d5ccd73dfso4588665e87.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760993473; x=1761598273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/DNocr10We9+tRibfaGdS7+LWNCjniYedbAm0aObrM=;
        b=FUGiufY83yAlygBhP4TFTjFNKd4/t2agmvIzik+ZTYI9pDcxMgppvelmm6v6+YdXk7
         hUkmPBIu99umbqZrqqNdT+rCkDffaSnuAcGjKwG2B/TryDqmvTPWAkdm6IKExPqInpzW
         Z7o5BKrwzSKavjm6Qb0GY29CwMids43H+cEGDWZlhHx0negGtFLCUTjuP5DHtA3KyTzg
         f4GD2XF7CpyLvrI1rXhqFcWkFAwafWYXd7b9WebJ6/vHG0YmsW1ynh7H160kVZkB1i5U
         l/zLciJkGsQ1EJqPZeczG2YQypSE9HTmRK2REJmlut/FJEn38uwGTEJrF9MivwqsGRCU
         NWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993473; x=1761598273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/DNocr10We9+tRibfaGdS7+LWNCjniYedbAm0aObrM=;
        b=Tc18IwGxP3u3C6w8ZQqvhi2wZbOJlZSHvPDPE/eVGqj6yLiRnu3tGW+tIsj4x+1woM
         0eqcNFhsQkxqNKI6/s4o1KVCRxqUZ9cUCptGSwWXB5J34p4Rw5JFeHJjQ+AJqvqJ8G5I
         qiPZTvBSeSI/U9SHIujzRB3YRAttVcahOGZ0pmXPksGAHa2a2Un6gpM5ZfM0qnp/OSkb
         bqcaU0F62Ql+ruwkWvONh1BAePeUL2uUp83c7Xu51V0v8ZuMID1HLq3CRpxKOXtSMWEZ
         6vdFhyqbvLaeKuRSZ12+6FffVGpjwIJyX4wllxcM5dDcArbXV8d7z0uly4lpv9A/dUxA
         Ox8w==
X-Forwarded-Encrypted: i=1; AJvYcCX0G1Ni0BnENmgiaJjB0nmH/BchbAdGqEma1wIkET8VwLkeQWwztCo3DXQi73vrPsy+dtc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq+yW8hQj6/gxavDr8hXiUr3qlqGbWOm5G4WdOXUKL5s9DriFw
	sckj+WUYPvBPM8hdwWFA3gtMBKKXmJC6DMwr/BdhOZjIxX1WbWnjZrYzPnkopxP4qj/xVRw0HZD
	ymXWlncw4RkXfdJSdSomqM11GVrDuk5gVzPkM+pnv
X-Gm-Gg: ASbGnctPVHAKbJhB4tz0GgJlqmD1hjX1RZjVvTyxzWus1IndzUhqGPRRt+aAhxMPVx7
	qCy58h9EZPAtPJ7sjGdPMx0/zRT2NF3Vq5jLTnQ/TXMP9nRDhrtcgp/AH82Nz3ZRcCig+tnNLMw
	TOi5ZwAao9unV4C4tvQtH6KvInJXJLoKeqitDtJydQmjyRemAfE8+FeSscj66WRUEmcF2IVgGQN
	fXemI1n0HiQ14gMvvHO74uQvZeQyD5oE9qFajDrPGlIAA5eKK7OC46euKBKaiYB67tUkTq9Hy4H
	f5jEmrg=
X-Google-Smtp-Source: AGHT+IFptH7lgeIQIF8Wb79g6w5+VZiUQoWjQkKuVLjC5A13jG0UM4rCDEn9XOnf7H7IQFGgZlhwFcy9kFCumyNbmPY=
X-Received: by 2002:a05:6512:3082:b0:58b:63:81cf with SMTP id
 2adb3069b0e04-591d8579843mr4495565e87.55.1760993473069; Mon, 20 Oct 2025
 13:51:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com> <20251018000713.677779-19-vipinsh@google.com>
In-Reply-To: <20251018000713.677779-19-vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 20 Oct 2025 13:50:45 -0700
X-Gm-Features: AS18NWDGxqhjIaoTQRNUFc91_bCzfrzvv4w3uLlEfEEIlUZmI_rVPec29OqIzHg
Message-ID: <CALzav=cD4WLKX0roP8mvWEO1dhLGLtopeLTmH=f-DeV2Z3mAJA@mail.gmail.com>
Subject: Re: [RFC PATCH 18/21] vfio: selftests: Build liveupdate library in
 VFIO selftests
To: Vipin Sharma <vipinsh@google.com>
Cc: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	jgg@ziepe.ca, graf@amazon.com, pratyush@kernel.org, 
	gregkh@linuxfoundation.org, chrisl@kernel.org, rppt@kernel.org, 
	skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 5:07=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:

> +TEST_GEN_ALL_PROGS :=3D $(TEST_GEN_PROGS)
> +TEST_GEN_ALL_PROGS +=3D $(TEST_GEN_PROGS_EXTENDED)

The TEST_GEN_PROGS_EXTENDED support should go in the commit that first
needs them, or in their own commit.

