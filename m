Return-Path: <kvm+bounces-12149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6213788002A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18AC01F22EED
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24CB6519E;
	Tue, 19 Mar 2024 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ugTTsSRI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADAF1E861
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710860455; cv=none; b=JbcQ1CYefHn4bBOQGcHpWarIFN4VGT6Ye8o/HX4X5s08h7tYvP/n3IDYYhxDxkG8SuW9Ut2SU7ZOpJhqQHfhyo9wqSZoQJfPNKalpiaAbdXNO8I2ZW2ySoNXpBdiTSDktx658NHQhvXBXla/mQ4JmYiYI01uiHQvKvS+FfLC4o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710860455; c=relaxed/simple;
	bh=fZqLyluTsGJJhdPNFECXibPDvD9MpYTWMqyUQCKVBpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dRoCoQGL8OFT0cki8TnLnERd3xhZ8bamMsKxP9rav9deJir+WDUlEUfqy1JXgr83XOHLe2XfGHpqIzaWjVwW8yCk3QCqMlLCEUAToqEvtoyWzURsd5n7kX7v2LoKVjjhVM2oOqTd1DbFUeFgNTQUPaSmtq5fb0Qz9AgBGZr4uPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ugTTsSRI; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so6488169a12.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710860451; x=1711465251; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fZqLyluTsGJJhdPNFECXibPDvD9MpYTWMqyUQCKVBpo=;
        b=ugTTsSRIEI5UQ4f6wmb694FHRhlpxtjXba0xaR7bOvO7Z/JbiDE1NkbCajUfTs8FKO
         A5ZadPgcuBtB9y9GHvlwNMAyo3i/sAOF6VLOYvtXK3W5s9aFc4AWkv30d5miXmnIQmeV
         9X8coZIl+oYCIYcN2I3RJ54QvObd0NhgIAG56Gio/adP3x7VDkxHVhQnkjCqO1OruYVq
         5tyaEkYyu5NU6jwYoxkAlRen22Yx73VerDbVs/Z6BO54aleV7qrth8qhMZSmKcvJOsfB
         6h9HIVWG/Y13W9x/No/Qa3aOcfW4jI53yF9efEPsb9/qVHFb8eFPjAJjOxVb/iILCdEK
         CWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710860451; x=1711465251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fZqLyluTsGJJhdPNFECXibPDvD9MpYTWMqyUQCKVBpo=;
        b=PtfhgXAxy34462l2o6n7Cl4lRNOwDkRzy7BePmV1Z52kZz3/yghrSx10BaPEZj1EK/
         nziIbIDVJW9uTGkknGSIVhDtx+EYn2dMszmfpqi9hJBRyM3aztkeM3ph0PvthTycG8qI
         +c5iOtLIanf4uOJpNC1cqaLyEm1cn9E6d5vLNiGKDeNyWrZzPjhxLgaYOd+asq6TWiF3
         SOsAcdNjxQRDjYb7hMHOPD4vpCUTwGsst2nO3bQR0Ka8rZMovcGZ3HE10AnFClDWNcmw
         7SgZuzR3J42r9ZVBP0ddAo2SnPLetWUB/TjXbjAnHxdPaEFsSyKnwQ7rSQiQyO0XDcrg
         16Mg==
X-Forwarded-Encrypted: i=1; AJvYcCWzOU05hofCbSpBaNonbIK+/HW5NCEE5pgoBFxH+oTrya8+5Ee+IMBm6Lwehxewc23cAT5o/rLEuEC03bdpUKnsISvv
X-Gm-Message-State: AOJu0YyN3P/VG+pCjWU9IiNixql9f36BXNQZ+kWkRiptB5bbaHrYLkYZ
	FSatuBrz3SUZPIdcYZA3HF5cDMAQl0wUz399vN+gE+kfUcJxFJQ7/Si7Dw1e9zsw17qLczQaJoe
	pwPzyU9jMdSGKAoKB24B3RzIAbPnJ+w+Tlr/fTg==
X-Google-Smtp-Source: AGHT+IFiWNwH6XuqKeHGG4tD9CH7BW4gY38AfHIAyYdDprd0X0UL9RqvdyNtqbXp8sHG7ZtytHMVS93WuJgar7smzg4=
X-Received: by 2002:a50:ee04:0:b0:568:a4b6:9828 with SMTP id
 g4-20020a50ee04000000b00568a4b69828mr1779194eds.30.1710860451616; Tue, 19 Mar
 2024 08:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221063431.76992-1-shahuang@redhat.com> <CAFEAcA-dAghULy_LibG8XLq4yUT3wZLUKvjrRzWZ+4ZSKfYEmQ@mail.gmail.com>
 <c50ece12-0c20-4f37-a193-3d819937272b@redhat.com> <CAFEAcA-Yv05R7miBBRj4N1dkFUREHmTAi7ih8hffA3LXCmJkvQ@mail.gmail.com>
 <0f8380d9-bdca-47b2-93d9-ee8f6382e7f1@redhat.com>
In-Reply-To: <0f8380d9-bdca-47b2-93d9-ee8f6382e7f1@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 19 Mar 2024 15:00:40 +0000
Message-ID: <CAFEAcA_dQGfBDiFCm7PUmvDrQtp1UK9HqkkV0-5x8fb-svYDYA@mail.gmail.com>
Subject: Re: [PATCH v7] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Eric Auger <eauger@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org, 
	Sebastian Ott <sebott@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Mar 2024 at 14:57, Eric Auger <eauger@redhat.com> wrote:
>
> Hi Peter,
>
> On 2/29/24 12:00, Peter Maydell wrote:
> > On Thu, 29 Feb 2024 at 02:32, Shaoqin Huang <shahuang@redhat.com> wrote:
> >> I was trying to add a test in tests/qtest/arm-cpu-features.c. But I
> >> found all other cpu-feature is bool property.
> >>
> >> When I use the 'query-cpu-model-expansion' to query the cpu-features,
> >> the kvm-pmu-filter will not shown in the returned results, just like below.
> >>
> >> {'execute': 'query-cpu-model-expansion', 'arguments': {'type': 'full',
> >> 'model': { 'name': 'host'}}}{"return": {}}
> >>
> >> {"return": {"model": {"name": "host", "props": {"sve768": false,
> >> "sve128": false, "sve1024": false, "sve1280": false, "sve896": false,
> >> "sve256": false, "sve1536": false, "sve1792": false, "sve384": false,
> >> "sve": false, "sve2048": false, "pauth": false, "kvm-no-adjvtime":
> >> false, "sve512": false, "aarch64": true, "pmu": true, "sve1920": false,
> >> "sve1152": false, "kvm-steal-time": true, "sve640": false, "sve1408":
> >> false, "sve1664": false}}}}
> >>
> >> I'm not sure if it's because the `query-cpu-model-expansion` only return
> >> the feature which is bool. Since the kvm-pmu-filter is a str, it won't
> >> be recognized as a feature.
> >>
> >> So I want to ask how can I add the kvm-pmu-filter which is str property
> >> into the cpu-feature.c test.
> >
> > It doesn't appear because the list of properties that we advertise
> > via query-cpu-model-expansion is set in the cpu_model_advertised_features[]
> > array in target/arm/arm-qmp-cmds.c, and this patch doesn't add
> > 'kvm-pmu-filter' to it. But you have a good point about all the
> > others being bool properties: I don't know enough about that
> > mechanism to know if simply adding this to the list is right.
> >
> > This does raise a more general question: do we need to advertise
> > the existence of this property to libvirt via QMP? Eric, Sebastian:
> > do you know ?
> sorry I missed this question. yes I think it is sensible to expose that
> option to libvirt. There is no good default value to be set at qemu
> level so to me it really depends on the upper stack to choose the
> correct value (depending on the sensitiveness of the data that justified
> the kernel uapi).

In that case we should definitely have a mechanism for libvirt
to be able to say "does this QEMU (and this CPU) implement
this property?". Unfortunately my QMP/libvirt expertise is
too low to be able to suggest what that mechanism should be...

thanks
-- PMM

