Return-Path: <kvm+bounces-59931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FAA8BD5BCF
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 20:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 061664F28E3
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04512D77E2;
	Mon, 13 Oct 2025 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nIkWXCbO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385612D73AA
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760380475; cv=none; b=KidT3JLkosHRI/mJ45ZGu/jaxUud55A8nyyqbteAlWiSaZqN2hhL2WJkpCq5skVVbUdvUUIv9as2EMWgHxWs6dAdQbMFszdpNg+aXJTPKB1ZvyLDxx8J0TMoH5hcOnZZVOXhQiJW1LjeNsCgvZ5mtIHPLvH5MvGiZCq4Mi4jLeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760380475; c=relaxed/simple;
	bh=Afq6cNan9t/2gw+te4XV8ANY20V5fsOBm2d4w/26+qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8N8X3IfIjt8QxzcYhEe0V8jyd7Wq/ThWYk4E2P5GwHEVunsjGO2m+LfKo3UprDLM6u1JDautMpjiKlzZNFy2Tli2mkgQR+OUv6zkQjzxkBFw7QU01JQDAJcGGpYtXVviOYgnskKccD23k0t7CbEKUK7Wi9ddyrpvcrjR6yThtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nIkWXCbO; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso15213a12.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 11:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760380471; x=1760985271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Afq6cNan9t/2gw+te4XV8ANY20V5fsOBm2d4w/26+qg=;
        b=nIkWXCbOHSMGaBqWWJJmrgsAOXnOGgEiGblZlskaHZzFrQfFQ7My8Y2pljgDsLo61J
         K1bpH8xUPqLhwapCb7r0SuD3oQDkVReBl/FdzbtYkpcFCLjPc0PMiYHpWnplt1Ckpnj8
         b1g0OTjNB4LpNcb+NX8lRvMgWTwSHlg8XEP0LPkcnqGUG58bG9TLQec+1OuaPrxdWvzP
         rHdTyhENX4Bpr+OoUl+wKntoEUpnjwWb0lTRQZXi34JvHMB8rFITJ8SaDZclYdCtb72n
         +ot0KRy3lKiFmqGKYrUzTwDBUBg4WUs+Te/4EC5nmeEROXoNaf5cF2mJUMC1kH8+eZZU
         cQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760380471; x=1760985271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Afq6cNan9t/2gw+te4XV8ANY20V5fsOBm2d4w/26+qg=;
        b=iVUy6YlwtcEIYhVQmBmWmaL51106IRIWpeeWYj3q8ch7svgUJYpgbaEAc3JHfxhek0
         lkHMo3b8Z1cIZQUZFs9jM8VX7S3m0GiGZ5S7q8Lm2lHQEh9uCHIWcgys7yiFKMiZnAOH
         m4SxOhkLYEuYkljdfuHS7RD0iy0j6uuA5i4RUIAm69qpxO2/3MKcpITtsYsmq/Vd+FVf
         qf1a0o1HIfD+2IwgmcsncWFXBlf6/uVqUqPwZ0UfiS3AB77iE5CfXzmeDRZqpx9BxxJI
         eovdfhA99i7BQ0W6j8R9m3o0t/KYLpayUTk4HvOBEygZDLRIGtozGUBEezS3I7P4835S
         F5Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWxHL2M7dPON6Uwb6jGgkOUqUcclJG93++eXy63GZBciZ7evRI6Zs9hpUtFMKdUUkHLnBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQzSe9TobjP4cNYRX/znVOusSBLKvgcnjgczcO530AjvW7qV1l
	SOgBIMxL0duAtS8SSm0QHcaEZ4efA95QRUwkF2CKmy6MB/CryO6BjgzyZyK/TasKGrvpjHyES6W
	X/6eySjatnU60uRhPcFBnjcyon+GaKHiJvnPXXzLb
X-Gm-Gg: ASbGncupR9Kt71JCh0/hCVZRduxDfh5r98TiaoGi6RFmCN18UoDTog5WQz6A8ZAGUnJ
	MusTZcaaBPjUSkvf/Mf9QxCq/wo+/x7f3BJo3TmOHNGcV35lxFYsah2VZDvPq0mKvHKd/PLn/Gn
	4xi+shDGpU7EHpaSvSachz/dk2PXh0JvZ2FtZPSZA8Q8FG0C9MkwDBopRkvx/zstqwdYUt2b+gR
	+jfdQn2VChV3XsDNIG7j+DjTKNidFjO9wHk8/RlnuLB3U07Ttco0w==
X-Google-Smtp-Source: AGHT+IFRwNFRw95/PZ4giLCn1mM7Nqj94TnRmfK/bODb4e+FbWoWD5Kzjyueo2VriuqMV3KAw8pFMMhjt3TSmvoOwWM=
X-Received: by 2002:aa7:c84e:0:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-639d53090admr609561a12.7.1760380471100; Mon, 13 Oct 2025
 11:34:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-9-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-9-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 13 Oct 2025 11:34:18 -0700
X-Gm-Features: AS18NWBIFyEjfltOcvssGoqGJAnQhP9wY-GXD3bDQRorIl3BP8PPFn-W1mHZQBM
Message-ID: <CALMp9eSwzYaRVa2eO-o5oyfK5Cj=0kscCPQhCxZGQ5WWYFgN-w@mail.gmail.com>
Subject: Re: [PATCH 08/12] KVM: selftests: Use 'leaf' instead of hugepage to
 describe EPT entries
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:05=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> The assertions use 'hugepage' to describe a terminal EPT entry, but
> 'leaf' is more accruate as a PG_LEVEL_4K EPT entry is a leaf but not a

Nit: accurate

> hugepage. The distincion will be useful in coming changes that will pass

Nit: distinction

> the value around and 'leaf' is clearer than hugepage or page_size.
>
> Leave the EPT bit named page_size to keep it conforming to the manual.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Jim Mattson <jmattson@google.com>

