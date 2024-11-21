Return-Path: <kvm+bounces-32250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2466D9D4B2E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 982D4B23AF5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474DB1CACE9;
	Thu, 21 Nov 2024 11:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqLZCtlG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C71D042A
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 11:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732186885; cv=none; b=QhAJ09fAXBnVHWHXahZWuXFi6KSzMjOW3YGXc9IE2uP4pvXxurPIfgciJZPQKeu5vhuZvtXK2mwPnowsMeP0akhzxhti2UG4KM8IrQSqJpJfoph8EQTMrOyE2AFp0H3gA/03uXcF1fSVRgt+ausqjZjF9QwhrNZOfeZ0UPbSe88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732186885; c=relaxed/simple;
	bh=tOuK6PhBFR67sFxNosi3HgKlYBFKqlwSZe2KlQVufCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1GqGTZxKiYKyU84PbahiUMGYa7IabM12Q9IxjS4K4VSzif86g4DYpD9F6tUzRJGhLyDB1SCBSFVTxa41MC2eNfLQ7rQIfGDpVPm2E+W+qRnhJZRRc1wdc33uVBi3XV33IgIbWVrDtAaWiX8QXg6+g7tVvJcmWO/86TGQMffSoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqLZCtlG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732186882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOuK6PhBFR67sFxNosi3HgKlYBFKqlwSZe2KlQVufCU=;
	b=OqLZCtlGtN21zIZyFY7WmUqqIWExPmz2+jaQGzPFUUz6FYn9s2P/Yu9mvCwixsrH0b53/v
	3/xDp+2lC8CUDE9qLlpQhgo6EQ1tssjB2lgCnwAYCAKf15h3ZRDWQAnEYfhSphiI5sE6lT
	SzBGvUY8JvjKq8H4C4fwdIUOyWo5MB4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-JMtSO_eJPu2MN0CftcjUbQ-1; Thu, 21 Nov 2024 06:01:21 -0500
X-MC-Unique: JMtSO_eJPu2MN0CftcjUbQ-1
X-Mimecast-MFC-AGG-ID: JMtSO_eJPu2MN0CftcjUbQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43163a40ee0so5243945e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 03:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732186880; x=1732791680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOuK6PhBFR67sFxNosi3HgKlYBFKqlwSZe2KlQVufCU=;
        b=kOadEfbhEeqJLdiXPnufGbQe5N0liD0EoKfwINHsmuoiw7zAMnQkdgGCSO+d9m78Ad
         jqSgeXXGb1WdEjYjJJQnFb6PeQ45v7oGi74k3o2RjypMjIaITXp7QMF7VHg1s9A1zJmS
         tcY/gVaCZngvn27fQKVqHZtbNavsKHhms1h51uKFihdwcZ9pzUCnby00FmSyQU4/JG2u
         MNXISGrmSLKfDu0YC3lPtKg/reNUlhlDL49ypj8uDUCJRsWE/lq2X3D1iOz0MwK66/Rk
         z29i5cUIbnvkx3Rj82O72jy2hwOFEnUfddDkMJej1rCMikjvb8hIy1ZP3X3gtWoqfmB1
         Bj7A==
X-Forwarded-Encrypted: i=1; AJvYcCWdytOI4vCbc7yAShdZUWiE+ecBXt3dogPy3aJ4xNQtFAiJ1xNhyTGqCQF6/4xjIYCjZeE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Ldtb4WX56pTfFitgAdAH0WdH1nfNlNKWTIqNIwKZxNTAIpBP
	6WFahmf2XtxE3gZhKUTV7htM8AffK6aNJ4uL6PkAVNwmXHh2KO5xS0CNA81waZXZdJwGktgnglo
	19jVAsOc8r0XKw3ZuHY2ultgTly13V0mlbhQsp8wUODsrb5/ctwkosiHacJ5FjocU820za2TMc6
	HKNwj082s6ZiPfGEjPDSFTgoRU
X-Gm-Gg: ASbGnctBCRhpLIOmAmPGhLrYlQ0Gc/QPB1WiJsT+/ZRqGVxVErs7L8xa5+HqZVjXzoN
	5X3FXb/IxNrlRK01V2k0yXHFmTWoIW6I=
X-Received: by 2002:a5d:59a6:0:b0:382:4fa4:e539 with SMTP id ffacd0b85a97d-38254ade561mr5527273f8f.2.1732186880486;
        Thu, 21 Nov 2024 03:01:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPsNju8DqEAsbUoBlH5FG7SPCdj1FPMazPqm9+bABcWR+xzSkUZWtpG5IoVakcOu1MFrAUc96srC1chIe7PMs=
X-Received: by 2002:a5d:59a6:0:b0:382:4fa4:e539 with SMTP id
 ffacd0b85a97d-38254ade561mr5527245f8f.2.1732186880092; Thu, 21 Nov 2024
 03:01:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zz7vLEbLFXuRSPeo@linux.dev>
In-Reply-To: <Zz7vLEbLFXuRSPeo@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 21 Nov 2024 12:01:08 +0100
Message-ID: <CABgObfb+P7xaLqiPBzshMQTfSRg8B7LSYswzipNTk6bzWkbuXA@mail.gmail.com>
Subject: Re: [GIT PULL] First batch of KVM/arm64 fixes for 6.13
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Anup Patel <anup@brainfault.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 9:28=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Had a surprising amount of fixes turn up over the past few days so it is
> probably best to send the first batch your way. The LPI invalidation and
> compilation fix are particularly concerning, rest of the details found in
> the tag.

Sure. Anup, if your second PR is ready please send it already.

Paolo


