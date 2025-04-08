Return-Path: <kvm+bounces-42954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB428A81350
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 19:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B60C21745C2
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC8723643A;
	Tue,  8 Apr 2025 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kI/HtAgw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613C92356AF
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744132418; cv=none; b=godTmGJZOqDNvzpdz4UJo9C+rqrzGMQ1gL3O9viN+p9T8GG+0x8AXON+WIT0hWG1pCV79RiS5f3SgWcGciwOXpkEFiiK2gE8TR+qyoDRU5Ud8QLcJlgQ9wKQuRBEXVzHFIBIdLLCkgLjamBTfOVT7kz2NVEehnqR1WuJqyTXQ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744132418; c=relaxed/simple;
	bh=nnw9eJ8KOGN5QlUkiDoYliONcmf9ltltrlpJBMq/rPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFftBj9oNV+h8zpMicoZJGHiKK4ptQjz6LcIOWSaHjcyAw+sHzErCyce0kKVD/Aj0dwbxnYyobchnQEsE+Ik6xAKIGQnugjCPKN2iQJx5IRpqhg4d7+Np8v1L1t0/qozQx1DcwpQGGBYp/INvoB+8pigLSK05PzzCRdFElscBUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kI/HtAgw; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-549b159c84cso3761812e87.3
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 10:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744132414; x=1744737214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=st5xjw/A21tQtkt6th/OJeKKznmds9c4r1pftIhJsuU=;
        b=kI/HtAgwIOsnmQnLkr//6XQbruueUKe4xMIixkgkwSRgiFXgDQ63tb1W6NUmV9pvVa
         Q42g66MCuhlxaM3ORiJTlx49xQz4+kC3btZ3CPLJiSVd+bfChpwKL2kXlPuZvDbR4ODR
         h4E8uIbcW1tvKhysLknPq3XcDmB6sTScn3Eokc0fEoKIfTv/o504GWLLnz9PlPYjaVqY
         xNZPB06LYp2IoNCFSYcl/QdpTKZ4Go67xMwkLytO12IMeBYsS4fwx0B1Wn0yXNE9pJ9Q
         na4Zs5Qd/heScTm+tSSDhqDsTLLmyyHHvKqrZYhtAGMub4/roLJ4lwaNcjmMyXc92y0D
         ZNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744132414; x=1744737214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=st5xjw/A21tQtkt6th/OJeKKznmds9c4r1pftIhJsuU=;
        b=FCXsXclqKTRIRQHs3sCbiJTR3l52ZJLjUox3dKMe9L1bYz3hebTgnnU5bKJNnA5xrf
         hWOId8Kw99p0wXHL0lfS+gGI1GsdFFwlov7e6d23YTJT0qt7lTequ3qvLfvhfhZzK9l+
         uGoiMykicgFfeM5xxkg/KA5WhYWg/dEOpj9NfPGUkXTZb0vkNwvSPYtlc0Jao0Gz6Sxf
         VsBfd8wVQl2yW6XzbLKNpDsKXfWa/C6zOi4h/MPtyS43cHHc0alTnTP8i/O7HiZJl2Ct
         rz4ApGmM/6YVOROnL4wvDAwm8nYhSAEHGp/lwOH+eQj1nJ6Opmq4DtKoIPWdhRwV1SRc
         5zGg==
X-Forwarded-Encrypted: i=1; AJvYcCXg6yfzhuIJPwLdH8PxThhB8euNlB4xBWz3aaCLYsp8fLXhoG4RnrPwvnNcZnL0cel/exA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpXRAasoqqH2Da17SgzJ5EiEH/R2/OjA4ALCoscJW/acC8cLHG
	r+mVv2boLmTHSQI9tCzNnmQqxxxwOUopfCbURTj2NxOQJ/scXb2+IC29VrhXXxyD+zVZXyZznmF
	YzvHQ1O8nCb9F7kS4eYPsGb53gp7TdJsHI/TX
X-Gm-Gg: ASbGncsFE5sbMz6F4M0mi7htLqczBLW18ca7BEnv+Le1MatbWCIuddgUBsEpjHJEEM4
	TYA3rsVh/rM3jaz2IFCiXQOw8yTaVtaMLgne/cwzdX1+18N+g1WPGC6Ine7wuDF4CgHQME3mI3U
	aSXzuB7cy6VzGBKlEIDSgblMiN/Q==
X-Google-Smtp-Source: AGHT+IEojOGt6jWAwX5Gcm/P2e+H5jOlOGkH6KU9klaguOraWZfMNwVU/6kY9rYk7qohNkpmZ9j0DjdTIdgt0Ju7HmA=
X-Received: by 2002:a05:6512:118b:b0:549:8f01:6a71 with SMTP id
 2adb3069b0e04-54c22808c0amr4933383e87.51.1744132413969; Tue, 08 Apr 2025
 10:13:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 8 Apr 2025 10:13:05 -0700
X-Gm-Features: ATxdqUHtXVL6zBbBDHxkUQLM1RAtccgSreGFrNU_ZXaEoEaE0jP24eQuxtxkag8
Message-ID: <CALzav=dMSLy7kt6sJtRqAK8tOZwFz9Ktp3vzqggdD+J_aPVycg@mail.gmail.com>
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 4, 2025 at 12:39=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> This series is well tested except for one notable gap: I was not able to
> fully test the AMD IOMMU changes.  Long story short, getting upstream
> kernels into our full test environments is practically infeasible.  And
> exposing a device or VF on systems that are available to developers is a
> bit of a mess.
>
> The device the selftest (see the last patch) uses is an internel test VF
> that's hosted on a smart NIC using non-production (test-only) firmware.
> Unfortunately, only some of our developer systems have the right NIC, and
> for unknown reasons I couldn't get the test firmware to install cleanly o=
n
> Rome systems.  I was able to get it functional on Milan (and Intel CPUs),
> but APIC virtualization is disabled on Milan.  Thanks to KVM's force_avic
> I could test the KVM flows, but the IOMMU was having none of my attempts
> to force enable APIC virtualization against its will.

(Sean already knows this but just sharing for the broader visibility.)

I am working on a VFIO selftests framework and helper library that we
can link into the KVM selftests to make this kind of testing much
easier. It will support a driver framework so we can support testing
against different devices in a common way. Developers/companies can
carry their own out-of-tree drivers for non-standard/custom test
devices, e.g. the "Mercury device" used in this series.

I will send an RFC in the coming weeks. If/when my proposal is merged,
then I think we'll have a clean way to get the vfio_irq_test merged
upstream as well.

