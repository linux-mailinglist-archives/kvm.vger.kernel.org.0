Return-Path: <kvm+bounces-58782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D5EBA083E
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9E8817E925
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5F6305E08;
	Thu, 25 Sep 2025 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FzcBq4ak"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFE12F5313
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815967; cv=none; b=kLWov04QEp2VlcfeifT9sTw55oONY9/FmdvyWB/wf+m/o3Kn6wA8GJDC/1qDGvS66ZLnTxfoQ27XZxz2hna7oWQlA6clItFO4hlQi4i4kG79NKlw2Ogw3+Wi4NHGlB/qSh7dD8IYOkc0WAATE34zXjvFwC6FxA7qJNr6o+7rERQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815967; c=relaxed/simple;
	bh=brqAyFB7gXkQovCRr9PXifA1VpNR/jlFk6h2JRS8H/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SAEnJ5Km/jr1udtWqyn/XC4h0oP1tdYXYPukeDyVvRhC6s5zy+M1jQfFMQYQepBKKVrRntkGUizmejV2PI790p7rjN50ksr+IrGNYTizO2jVljCcDGvoa5zFDVIWrjumpAgLmkBmQ458h9SMdnGx613JwGuf131kZkEBUz4EHG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FzcBq4ak; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-635355713d9so736870d50.3
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 08:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758815963; x=1759420763; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uzASJePoYprN1HeknVxKlWJ+aJB92keRULtXdkBKq1s=;
        b=FzcBq4akfD33v1lLedSIQsAHTMQ3K1lwYzngVXgwrcMtqMAoFM+ehNp7BV++v7NNKS
         24an0P/Xs84Au7x2FwKduFCJHzDDLxL5dx8AQG26pbY91EXGxGbvfxZnbjnTPgqkb1b7
         +60/g4Q7N/A2IR1N3yjdx9EmUGnmBN2ifmNa0b3EOtpDeGxzYUwIK7G+u4hPKn4rHGj8
         n1GhQ2CszOqszTung0ONGVNtAtFB0rNi+uCclYNiWcGs70gTTP7zsk1T98LS7HD4b8SL
         cXY0vFOdb1YK1yNMJ0RN6xhUWF1oC2bWlN6EBY5+1TKkgnX4oCARlVw1QpEJWda6lzgI
         3chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758815963; x=1759420763;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzASJePoYprN1HeknVxKlWJ+aJB92keRULtXdkBKq1s=;
        b=fFBLyM9gQ4fSjo5FE0AcTDW4VlXajw7yXQ3lAUrptXus4zOFXf+AO05E1UD/wurqY8
         M366Q054Z/e9x7VXxERs7QJkPTaJ8YzXmqXb8wsIOUucqJQwZDurvHxwk00RgKoLlixy
         Ixtjo4K/CBCqyuy8+vtDjk8mFf0k+PCv+6bCkpNz97pDtvOPhFWt7hzTUgTgaedqaVOb
         fLxIqt9Vq2TdPGz1wdHvQ+B6g4T9tT5JrQYO7ZgyZQFMW3/1PQIRi03MWEUNIYENMwdO
         BVdGoDC73z1++CpPWX4VFcOgEpnDC48/sqaQcDo5H8Dr5J0r9TYWYUoCOggezDORj66a
         771A==
X-Forwarded-Encrypted: i=1; AJvYcCXrKgtGKaH+2N+1mFK/q7TKQP8gUSNDG8hmWXPeRes9FEdluOy1DWiJ6qYNNjnqVp4MSuE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+5dcP2mlxwxh6onm//77QsrbvYskuSH2Jt/WqX8hwtW60iiAH
	W07TNZ5FlbirVkC6xOFxNOnKIj7yJyq025GIHERwYMGR8pwVaHcatjhg43Nkz7QWVDuSplGGltu
	yyjLPWnZZOag92PBUy7j726u7yB1WWQy21AfbUWsjgA==
X-Gm-Gg: ASbGncsQ2DZlRgbvD+lUPB9PFyW4ukUaYn7MT3uPOrKGZDFSjw7u1UdLKZe8+lxdIPn
	cmC3bcNB7qLqoET8d0P+fE+aT5iMUfkKAGRSodvu4EI9vK/bhJx198ddeCId/SAK5cWmPWDIZ3v
	iq/ku/iXRDe4eUpfKs1LE9AX/IjkLUQ71ObdUhZLYxTE/hpIX8sCv+/FpdGP8UbpuELUb7eA9/j
	MRRCcW7
X-Google-Smtp-Source: AGHT+IFSPhwXk0JvVn3LcsH6qtiVAFaDSeMlxlAMOGYHS/Bpz5/ipt2MOWiRViVkhVj3++SEhbBiPd+BvNljo70N1Wo=
X-Received: by 2002:a05:6902:6309:b0:eab:9d16:f038 with SMTP id
 3f1490d57ef6-eb37fadbba3mr3248959276.3.1758815963070; Thu, 25 Sep 2025
 08:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250920140124.63046-1-mohamed@unpredictable.fr> <20250920140124.63046-5-mohamed@unpredictable.fr>
In-Reply-To: <20250920140124.63046-5-mohamed@unpredictable.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 25 Sep 2025 16:59:11 +0100
X-Gm-Features: AS18NWBVfN6et6UqDg1jE2B_lcNu6A2J_kHt6qeSd9RBy04PUlwbM-UoIWXBlq8
Message-ID: <CAFEAcA-cAt4q6HfS7--T4Qd8qag-+fMYu9PQh3SoEtvPbd7VpQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/23] tests: data: update AArch64 ACPI tables
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Shannon Zhao <shannon.zhaosl@gmail.com>, 
	Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Mads Ynddal <mads@ynddal.dk>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Pedro Barbuda <pbarbuda@microsoft.com>, 
	Alexander Graf <agraf@csgraf.de>, Sunil Muthuswamy <sunilmut@microsoft.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Sept 2025 at 15:02, Mohamed Mediouni
<mohamed@unpredictable.fr> wrote:
>
> After the previous commit introducing GICv3 + GICv2m configurations,
> update the AArch64 ACPI tables.
>
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>  tests/data/acpi/aarch64/virt/APIC              | Bin 172 -> 148 bytes
>  tests/data/acpi/aarch64/virt/APIC.acpihmatvirt | Bin 412 -> 388 bytes
>  tests/data/acpi/aarch64/virt/APIC.its_off      | Bin 164 -> 188 bytes
>  tests/data/acpi/aarch64/virt/APIC.topology     | Bin 732 -> 708 bytes
>  4 files changed, 0 insertions(+), 0 deletions(-)

This will break 'make check' during bisection. To make a
change which updates the ACPI table test data, you need
to do a three step process, as documented in the comment
at the top of tests/qtest/bios-tables-test.c, which will
result in three patches:
 * a patch which lists the tests which would otherwise
   fail in the allowed-to-fail list
 * the patch which makes the actual change to QEMU
 * a patch which updates the test binary blobs and
   empties the allowed-to-fail list

thanks
-- PMM

