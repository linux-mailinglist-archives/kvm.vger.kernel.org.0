Return-Path: <kvm+bounces-23228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A91BE947CE1
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53E3B1F2340C
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 14:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158EE13AD33;
	Mon,  5 Aug 2024 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBPEJZmB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7AA139CFC
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722868359; cv=none; b=WLRrvKba28xUjP1FnxDCpryu5E+n8GQqH8MqvlKWUwCkktiZlfOlZd2tTG1U22rtWdn5a9gRy2OB3JlRLrfTXgoolJdl26wWq+TjqVmSZfYlpiQ8j1lj/ZEeYu0PCb9h67ugfankAPetS1CtpaaOpzJM5Xq8qY8a5he73IfTsz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722868359; c=relaxed/simple;
	bh=sRV3gNGKH7pTjZDg3VbBocrQvihX8mBkN6lBnuSXmCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X2+ylGcQSmGoq/1FnEWahAo8EsisfsND22J5ByoESzcttVVHYxBc1A53FDcjejUGhOw6dA8EwF1ANWv5aX4Ea2YkNExcaeJpG9p/8Gi0GVLeR0gWeYCGjv0rYgJa+oE/terxTotVlu1wtEQqpcWDM+4ch0TjIE27F2oTzpU/f8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBPEJZmB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722868356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JdhTzHGWfeUcTZeTuwS9gAaX+TnljxG1Ua0SsTOdngA=;
	b=GBPEJZmBNA9VQFJ7AbqGa4rKGOG2bREIOraMiqPV5LNV0RRFQxSl6UUcYZZHALkv2/jj7h
	QjSB6op+lyvWRojUOrMGqnfYLDsLOzurEHHN20txBiAFEFsn78GOCUcw2s1XygupeIQtaz
	vWw3RpTlL7+2UAUf4ZbBIOnrAqgvpDU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-TemafozvMBywnfnmeqZLKQ-1; Mon, 05 Aug 2024 10:32:35 -0400
X-MC-Unique: TemafozvMBywnfnmeqZLKQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-36878581685so5451891f8f.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 07:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722868349; x=1723473149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JdhTzHGWfeUcTZeTuwS9gAaX+TnljxG1Ua0SsTOdngA=;
        b=JFWdQkEHKaqc7mTcxz4hRJq9Gpuum071npAUDASXgKTTw4b98KSYrh1WwGUaN3Kv1n
         G13bUp066EJODGCu0cpPNncHSdfn5yR4m85AfbhSGmkRfWrojXXMIlROOfW81KDtNFIi
         tEIm8YdZILhD/5EAzQFkO39+J/JNqoeKf/9JCO3XGObBJs8A4/4ypPoIXnIj5SXff4z/
         35Tx61f18rLFtvh4LsWd33YYEy6uC+ZnjSqhtcDoaNo6Quij2+zDe/lGbVn4Hvtm+ABO
         554NinIc6lAQI7AaUqW1acP7IZ+0gC3ZB3y37ZZlwW1PyrKaWUH25sSxMqzp3GpuGu5f
         NVfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeUZ6JKcfPF9VVCKl0OkOsXn61PaHueHNWlwkecy0UUns4yMaJbLdKu5s/EwW78U5ccNiZ4LhpdiULpcNd4JT8tC6W
X-Gm-Message-State: AOJu0YysvPPxY4a+lH8WWkePUl1qtBYt22H1i+jhrFZeIJTHOCAxU6rT
	MfDJscxSQOwqAgihFznEDQX3LvVtFwcZ4dN+bc+rH2jpmGKoAYsgJEaNTlNkigTt/EZyeW39vl/
	z7+oV9fuMMF4bbcDPh3e0Lp6u8+h64sX16FJxoJ8m9ldiZEejoSDdAFATNcZJ6VyMiKyJmhVrGq
	5Bw1V7lfU3vi5H7EOGkI/LlPLh
X-Received: by 2002:adf:e411:0:b0:364:3ba5:c5af with SMTP id ffacd0b85a97d-36bbc1c34e2mr8371252f8f.61.1722868348831;
        Mon, 05 Aug 2024 07:32:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC4uxjlocGuHRe7VMvIPg04UbSdKvFjwtiJuSX5OhGJwtx+TNuYq7IjhpmnKZKsaje3hiJN6zXGMH2DXCKuGM=
X-Received: by 2002:adf:e411:0:b0:364:3ba5:c5af with SMTP id
 ffacd0b85a97d-36bbc1c34e2mr8371232f8f.61.1722868348409; Mon, 05 Aug 2024
 07:32:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801235333.357075-1-pbonzini@redhat.com> <20240802203608.3sds2wauu37cgebw@amd.com>
In-Reply-To: <20240802203608.3sds2wauu37cgebw@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 5 Aug 2024 16:32:16 +0200
Message-ID: <CABgObfbhB9AaoEONr+zPuG4YBZr2nd-BDA4Sqou-NKe-Y2Ch+Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: allow KVM_SEV_GET_ATTESTATION_REPORT for SNP guests
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 10:41=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> On Fri, Aug 02, 2024 at 01:53:33AM +0200, Paolo Bonzini wrote:
> > Even though KVM_SEV_GET_ATTESTATION_REPORT is not one of the commands
> > that were added for SEV-SNP guests, it can be applied to them.  Filteri=
ng
>
> Is the command actually succeeding for an SNP-enabled guest? When I
> test this, I get a fw_err code of 1 (INVALID_PLATFORM_STATE), and
> after speaking with some firmware folks that seems to be the expected
> behavior.

So is there no equivalent of QEMU's query-sev-attestation-report for
SEV-SNP? (And is there any user of query-sev-attestation-report for
non-SNP?)

Paolo

> There's also some other things that aren't going to work as expected,
> e.g. KVM uses sev->handle as the handle for the guest it wants to fetch
> the attestation report for, but in the case of SNP, sev->handle will be
> uninitialized since that only happens via KVM_SEV_LAUNCH_UPDATE_DATA,
> which isn't usable for SNP guests.
>
> As I understand it, the only firmware commands allowed for SNP guests are
> those listed in the SNP firmware ABI, section "Command Reference", and
> in any instance where a legacy command from the legacy SEV/SEV-ES firmwar=
e
> ABI is also applicable for SNP, the legacy command will be defined again
> in the "Command Reference" section of the SNP spec.  E.g., GET_ID is
> specifically documented in both the SEV/SEV-ES firmware ABI, as well as
> the SNP firmware ABI spec. But ATTESTATION (and the similar LAUNCH_MEASUR=
E)
> are only mentioned in the SEV/SEV-ES Firmware ABI, so I think it makes
> sense that KVM also only allows them for SEV/SEV-ES.


