Return-Path: <kvm+bounces-18653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8859B8D8423
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 15:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D81F28968C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7178D12D776;
	Mon,  3 Jun 2024 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W6f5+YUF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4415C3
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421903; cv=none; b=isc3X5VtxAuPKf39FFG1GEGlo5oj0WNmPGQEYWCi0V5P4McznaMhOCaD3DrN+d6Ohu9ixsWjp1ETgv2agbiHefnSixn0FD5KqnNmvEdsRQu6z0nazI/exSsGgs9kmwlKV1EKNrwsgFUgvMKz1oj69H8aYlW18vIOe3u2Yj8+cnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421903; c=relaxed/simple;
	bh=pjMv9CFvpHk7tfifO6Qm6g2Eis2FqvFOwC0BzsjHgnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nTsiooARroALD6RSdC9+BZqRBxWpV38oK2UbmI+HlziUuGuoLCuOJHployaCKnYChyVE8N5XseH3JfFzw9vtK98sg3BDkAlha6mjcBd5gsuGjg4UEQ4M0aBKJDU0+SViXT/VBbZMyAMmqzbpboDiI+G4yp5yAQ5Lu0iT6vqNPeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W6f5+YUF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717421901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjMv9CFvpHk7tfifO6Qm6g2Eis2FqvFOwC0BzsjHgnE=;
	b=W6f5+YUFLEJ8PA5XWD+F9obXPTN1y55XlBrrgZulqEV+dStfRUQyCFLyg5krRcpVHeiQwh
	ghvVqCkbrMZJq0TlQhwt3PTgDOjfi24vTV8WjrzaDLwbI8Dj2/Dsrtt20zmJW2O9XtI6sZ
	HN3dSp/VvkJlRdph3oph593XBU9WBJE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-HGo9q0A5NDeWb-i3Nk63fw-1; Mon, 03 Jun 2024 09:38:20 -0400
X-MC-Unique: HGo9q0A5NDeWb-i3Nk63fw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2c1a559a0e8so3572153a91.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 06:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717421899; x=1718026699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjMv9CFvpHk7tfifO6Qm6g2Eis2FqvFOwC0BzsjHgnE=;
        b=DzzTgsKjTaDPaxWUBkSAC3GjQAIqfk1lP9FpTTW401koD1bpfad+Aa1w3RuggKRcdM
         r5BY3nvAUpdMpaeR2n+AbccyWbQmR733PbbR3jmiTrqoEVR6yeB4WFoAY72bKllsoBXh
         C/1q0A2Fifgs/qhCUpOLSRatAXf9GBsFq2S6euWHDwMj8w/59xEpYvwRFxAkKasfezsS
         jUrulLSnqRgm46+jTBTKa6USKYcxZ0FDLP0jHpvGNFdVWf1kGc04UtKy74GvOzsSAjXA
         +oOE0ZHU3qFWTlIvUUcNockzmH8ECwXJshQId+pzfcgFmjpHpUxaojuMs+I91JB+mlZv
         3OXg==
X-Forwarded-Encrypted: i=1; AJvYcCXaeVyoCQ/GAAuvBTfCef2VhXDNj9sK8S5ZhVN0dh7TkViyt9y1EXX8mH3/ux1CrN9Hr61t+C3W3RI/aIlaNc5KJui5
X-Gm-Message-State: AOJu0YyuhIBo9p2iwQqTG7KWnTpjXpmWGDpmBWEZyz24iMx0z+Ldbh4Y
	5InaubaWUviyenNzc+xXRHpr3gKsqLK/ANyOd0Hq4gkZW1Q5Yt13pXvY2R3FqIXuG8CeL8QASL6
	fSSDzdlRUjaT+Puli43RMlAkCTCRw0xRFZu3jDQVZwqiiKIYTTILy6yz5Fsdwf/Rhicog9R/lWB
	Hk72YpV05wyBHTvqZZns9yBneX
X-Received: by 2002:a17:90a:d243:b0:2c2:53f:132e with SMTP id 98e67ed59e1d1-2c2053f135emr8436188a91.13.1717421898850;
        Mon, 03 Jun 2024 06:38:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IER4XLCvU+B4tTVK/M8kIPNe//eWnQO5yFMNUEPRxUbXBqnAJ6G0Q/SYq0FNt1Q54CXUqKiF03D6Ea4otyOXS8=
X-Received: by 2002:a17:90a:d243:b0:2c2:53f:132e with SMTP id
 98e67ed59e1d1-2c2053f135emr8436157a91.13.1717421898412; Mon, 03 Jun 2024
 06:38:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-30-pankaj.gupta@amd.com> <Zl2vP9hohrgaPMTs@redhat.com>
In-Reply-To: <Zl2vP9hohrgaPMTs@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 15:38:05 +0200
Message-ID: <CABgObfapGXenv8MZv5wnMkESQMJveZvP-kqUj=EwMszTkg0EsA@mail.gmail.com>
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	"Hoffmann, Gerd" <kraxel@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org, brijesh.singh@amd.com, 
	dovmurik@linux.ibm.com, armbru@redhat.com, michael.roth@amd.com, 
	xiaoyao.li@intel.com, thomas.lendacky@amd.com, isaku.yamahata@intel.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 1:55=E2=80=AFPM Daniel P. Berrang=C3=A9 <berrange@re=
dhat.com> wrote:
> I really wish we didn't have to introduce this though - is there really
> no way to make it possible to use pflash for both CODE & VARS with SNP,
> as is done with traditional VMs, so we don't diverge in setup, needing
> yet more changes up the mgmt stack ?

No, you cannot use pflash for CODE in either SNP or TDX. The hardware
does not support it.

One possibility is to only support non-pflash-based variable store.
This is not yet in QEMU, but it is how both AWS and Google implemented
UEFI variables and I think Gerd was going to work on it for QEMU.


Paolo


