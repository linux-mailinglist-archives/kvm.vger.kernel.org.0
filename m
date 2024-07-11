Return-Path: <kvm+bounces-21430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A224392ECE3
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 550EB1F22A21
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 16:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2AA16D336;
	Thu, 11 Jul 2024 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x5NLKWQg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836B815B11E
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720715838; cv=none; b=RDg3fJ7es4Mvr7A+NDaRaj30rHk5qmQOS1n1Xgc0m1jX63HGqb+HATPQK41gGVpJnveAlmFRJ3/N3mdhwqSwBmicEgHWmPfGRa3rAnxwIqOe8o8w+lYnjO9AsuTsqyisLlazKavDUwyvVKZFKWHd8PdOi65MkS5cHGCKQxEYFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720715838; c=relaxed/simple;
	bh=sw6NFyAxPQG9SgoQi7ntnSGcBxWYo5n661eTkWI4QWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCj+0CpzJeOpRuLZKeRApwcbJf+jTk1pSC/BjTAEak19vFYqQfDrgm1y/hDc9Clrm7WEL9CDvZ8PnoSLKbh6qk0omdPrup6SYNWKit3gYhBqf32kK76rswM5w9DlUoR8KWJwVgG8tRkNVr6YEWx2iQouJuqKPUul+0wZILZovPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x5NLKWQg; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-58c0abd6b35so17174a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 09:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720715835; x=1721320635; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sw6NFyAxPQG9SgoQi7ntnSGcBxWYo5n661eTkWI4QWw=;
        b=x5NLKWQgdpI8BU2lMvIZR+YefWmDNXiWA18f5pJ/BFVeJry/UwipyQBna+TI9M478P
         D8l9AfU6WgZ9eZA1cvvKNzw5bgf/6NYKYlTL+AXN5TbRtKhIKOM6nrso7kli0PJgmZDI
         3B3hb4yyjltlN/VYC8LN5LxGKR1EV0DaYiFJDvVDqhaqUS3Pq0mwWup8gCPV+M0Z7jna
         s1IXdReJCjmnjn8UHIfoBSXJmZD2yNwSNuUyNCaHGAlVOS2QOArBRRAOL/Am+HHC5iYo
         XFppMX8Zegm35v04L8ZBSptCh9P6BcIftIvNXJFiJcY2HSHPd395yEgjpflx50ZyyRhC
         2HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720715835; x=1721320635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sw6NFyAxPQG9SgoQi7ntnSGcBxWYo5n661eTkWI4QWw=;
        b=HCxX/1JVygngn0+/1bckokmbZ69VcZrNhM4RL4rGOjDGSNpUEXniERwSuo97BWjxZO
         kC8uYhdvEfUvxL9y2jMS0+yEY/z9eSPD8o/Q529DxByQ0vySP1z7RtJlhIu35RPxdFAN
         jlFf8tYSUxfLmH73CnLFlO5B4pJsEBIdZqowE68cHjMKF/NaUQvXDSZsiFVfxHWwa18f
         Tbv8sphSeDRZ3n4SrCV00qS/b++yNbguXxr5nJ/1w/OtWpGyKj21s98VwtSyjdjk0wNr
         PKGmKeI4v+4lPApUmb/V1iMsjYn4Iw45CAhoanHcpUshBdQz7eWqzG9fGqmGJbudTc5u
         b7Xw==
X-Gm-Message-State: AOJu0Ywp+IrMjSl2qamagnkPpZXDeXpKpo4lfjbBFKWkoPhWqhRslJtA
	tud4DCj/VPyeZjVqKCYzWL1Ut4NXzU1pjSldcGVMaRXZxTzvGZoKyimV6Fpqmys66pMPYUCE7pf
	IhzOAeGa6epqEf16UhAXAgynF80Xy2sknWoQn
X-Google-Smtp-Source: AGHT+IHtiJy6OQLBWRW4yKIdGNf4hW68cJ0U12QD5JO4a+6PpsB8/9axlkrzIp2dh9e7/SRf3uk+kBQCmt5TOrC2LLw=
X-Received: by 2002:a50:9eef:0:b0:58b:15e4:d786 with SMTP id
 4fb4d7f45d1cf-5984e518b37mr207048a12.5.1720715834639; Thu, 11 Jul 2024
 09:37:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709182936.146487-1-pgonda@google.com> <c0faf3d7-2589-4c51-a3c7-4e4a33c3baf5@amd.com>
In-Reply-To: <c0faf3d7-2589-4c51-a3c7-4e4a33c3baf5@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 11 Jul 2024 10:37:01 -0600
Message-ID: <CAMkAt6rk3r4gdoynEmOhZvsQXav05VNzg1G1WJFBvpOJJvsD_w@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Add SEV-ES shutdown test
To: "Sampat, Pratik Rajesh" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Alper Gun <alpergun@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> I guess this case also applies to SNP. So maybe once this patch is
> queued up I could spin another patch in my SNP kselftest patch series
> that parameterizes this function to test SNP as well.
>

Thanks! That sounds great. I plan on sending a few tests for the
sev-es termination codes. I can base that on top of your SNP series.

