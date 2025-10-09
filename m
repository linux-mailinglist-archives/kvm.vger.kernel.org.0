Return-Path: <kvm+bounces-59749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F80DBCB317
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D27874F6996
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082CA28851E;
	Thu,  9 Oct 2025 23:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eAh4yP9t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918122882C5
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 23:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760052480; cv=none; b=EJ0Trm931WC+E0KHcwk8DcdRB0MvUzEQwEwGSxeomH31kZfYKoxxhkjMKkAj0EVqlGhrhAxkb3ktdGiPs2+6JjrxlVD9ynHA02P63vEqM8mnP99m4gZUIFVf8MGoH1FenWYSbF793Rfe4NDKB8IlBW7Wh8/NelwB8ilfEVpasaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760052480; c=relaxed/simple;
	bh=9b3Zxgci+mKgnZhX5L7HtPaZQdIRtQaeOd4XtqfN0Z4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aw5WRYB9FvdQs9ytXssXuqemcMxvSho3sF5zKEbgNfbmzBwTaznsi4BECVtVo43IAoC3ThAdThG4/Th8L4zBXAyWBuEMC5wFmwxoeDpb/w1s5uMhvUm5xcHaeIRzUVgxJh4Olbj8R+FS9IjVo5PD15EcTf++ZEbwxJ+wL3oV1K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eAh4yP9t; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-633c627d04eso3870a12.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 16:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760052477; x=1760657277; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9b3Zxgci+mKgnZhX5L7HtPaZQdIRtQaeOd4XtqfN0Z4=;
        b=eAh4yP9t4/RJ/UrQt2P7ZDDhCBexG1Ya5AdEcUO7Y90w7ykSz5+Go5PlwYrfCvWOx0
         GBDa2Xiudr4gNFae0gY+qQU6PE5Ln9CkgkioA+Hr++QhGNJen9/jEAGxKZ3c4h7vK/kr
         eL/otxcESlK87LERTw9xsRaxk0CGu10+vHYm/fqkcteg1C6x5tVGZPjPoa+wu3u/4x27
         d1J+b4SW+7kF5RJiw7WdJrd4YaIopv7NKpQVPAMaJV0uKVput+7h8UNFSl63OOHIBJS1
         Ww/70bPKm04spa+LLAesMWlVH1BIDDdlpmgDxQfLA92/RURSurEob/cltxhZX4llgg/I
         ESEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760052477; x=1760657277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9b3Zxgci+mKgnZhX5L7HtPaZQdIRtQaeOd4XtqfN0Z4=;
        b=e36nRLqEALHCRGFTxsmfpgAqZTVWPP74O9Pvmr3STRzo8UpbrBYxIUeASlZ7RCZO3f
         crFzoaGe56nyo1duQ+E8lz/lf+TgCwrULCh0aP6FAqHNdfmIXs1TsYeuE2TcifhnEY/f
         rCT8ni4oETlo7bApPyk3t697w+0Rp+SqeJ60aRLV/Z8OWCMiGpscI385aWrNyorsw5Ej
         ZNiZrM6eGtzkeG7fEYEp/GOp9E2v8PoFNEs8bMpRd+kWtEuPQnsxbMlW139S9HznADwH
         MPPq/3qXVxTo7d3UFgjCmL1hiz6ipRlnkmio6QjPtEvKCnKQOHv7AiXvMbHDT4kjf3eO
         cNqQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/7ASTlQUXOBVRcSetiwew4Ek8BdSxRPhGUpxOylk1de7ntvqJJLI5bE0v4MYnlZsmQco=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdUC9sgNFBekOMe+A2Kz5xOYw5Eq/NI95VN0imytyTD24b6wYC
	la9R8DBXY3M6Ycx7oCX6RXV/XQrEhP3Bt1mdHA5tnkqQFyrAmmlIgV7Ij4PASNIUuglUjK0R2kY
	qe2f69LB2leSvf4lKCRd/pE+0MguN8EyMHZ5/ocEsg3F5n6juTQ2I3Mah
X-Gm-Gg: ASbGncviGvc4GVX4LFtwg+cA+AEE1uFPt+tNpLBpOCoMjWRwx17mIXNdaJf+sOmN3vm
	baLHCScGPP9Dxg5rLXlIi0nR8ZrouohuHOdjU6dBCRDw6QKmSAzFWgoNGHQUkQXTq87zwXWVvDr
	DYNBA7dAc/Ht1UiLsRGQ6qXZNucRMWkVLKbzjFFh/SPPoToAQIUfcqJyMyBATBRhvIu1bSc+/bA
	3rbFS0pOg3+NRnoFDVtKxMrKcvQO9CY4THNiwHbYkcTtP8c
X-Google-Smtp-Source: AGHT+IE5cTj29EQ60g5NA2LJo0NoCUMIsiGU6bW6OQpL9ve7upGwilWl79yHRPGcTpoLlvEyIYYTrw2ejMtgx/moUkg=
X-Received: by 2002:aa7:d889:0:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-639d52e9f0emr335679a12.7.1760052476715; Thu, 09 Oct 2025
 16:27:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-7-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-7-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Oct 2025 16:27:44 -0700
X-Gm-Features: AS18NWBk2cvpYkPkIOoV7BoxanaE72QhB_6V3q9DjGzblbZNPy2O9Oa2OARHAN8
Message-ID: <CALMp9eRMm-OX83djdRU+XdT=Bb6pHf5zZAet_fXYpAGO_Uih7A@mail.gmail.com>
Subject: Re: [PATCH 06/12] KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:04=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Add SVM L1 code to run the nested guest, and allow the test to run with
> SVM as well as VMX.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Reviewed-by: Jim Mattson <jmattson@google.com>

