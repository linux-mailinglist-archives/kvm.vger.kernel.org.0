Return-Path: <kvm+bounces-46146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1942AB3215
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 10:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 721427AA154
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 08:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B05B259C90;
	Mon, 12 May 2025 08:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HTCD0SBS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86275258CC0
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 08:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747039604; cv=none; b=HAaeVAj+fQeoVnprs/6oW74YWmfMTYpQobbl7BhCb72i31H9AQL0ThfA0ET1wDYfxOFaXYQOSChhqiSiDvS6VPpDiP3wLEBu63l2zOn6E7ssr/XYtEGIjKDQHaMSH8O16PPxmjc48RxpNltP+H1uffUlaOhvp3MSTcqix9WSdcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747039604; c=relaxed/simple;
	bh=N2NVw1vctpw4VdxjsSRvIp8qR1FQioY2MoaReGDEb+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KHS3m7nUPTe0Xfl37c2RyATPvptAjDZ1PfB6H8JAkkEXqATNDX5nPQ1440gZAmr27mtRCm+sTIM8xlnMYKpBaoYk6j27UBBsHFZUIYXANBLyWyKnZHwSVFYfHxm62D7Xjz8XebPZ9Q03DDZF93Z1MAwTx9U4EUihuu1rjVOCXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HTCD0SBS; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7091d7244e8so37917617b3.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 01:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747039601; x=1747644401; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N2NVw1vctpw4VdxjsSRvIp8qR1FQioY2MoaReGDEb+E=;
        b=HTCD0SBS0JYQcOssEzSLXu2ujkGB8BN1pD+h4neMX/6P57XfPqSRJlM9+Bs5avUpQY
         4ay8Cl0KYG4pxqIFQ28geveny7XZVNeN2XqAUW66YFtBdZPGW4iD+YJzF0RGjchSBusx
         7GFwUPYw/aM5U1G1o19e8rtzfmgOWcnGgR3268ETpBMItUd6mwCjG8+XcFpzYob7sUR/
         Bh6vshQFfR+B+ysGW4fpPoT9IGsIi5bUGb0mnGO63ekPlv5JlytAYuREI2SM/K3qXRgG
         1ZMjIJ7ajKpmXrupwsXm1faNQiZsug9QRAWcy71p6iNsoU0lQasgH7vKA7OuN7Tehk+Y
         roHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747039601; x=1747644401;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N2NVw1vctpw4VdxjsSRvIp8qR1FQioY2MoaReGDEb+E=;
        b=kKi/3IdXicjH9z5oABjhWZcmePc3jKM1+1UPo3LFgktOlSywi6HVRTmUqotPC1Z8dZ
         4+Kehc9XVBZkn1jWbEn0D0XOkyh7D44cSE2/OmO8qdEXmkmB6dPCRpHNbfBTAFVYMRGQ
         qTjBKR821s3s0pAmI529ilq/f35qkalJ8lVWmbx1xiK8mur7CsSfijy931gP/yMpO+e9
         BggdMTtNy3RBRGoaV33HJQj2WSTZmB2MKG4PR1GEiZAzIyK71nWmOwI8UkFeAW7x0tFw
         nIp1GTzj+ZV2vK5cxGewZLpKZV2uihbCm7S1nrLAl5KFnBKUMPKxWd5/lHQpHvRMTO06
         1wAA==
X-Forwarded-Encrypted: i=1; AJvYcCUFDcjF+TKfTV+yaJOe5YWMe+T604pL3kvhXlDfBSTa6uD+6jlmjXULP3u4Eeqfp8aMnrE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5F8V8J7HZ0pPQY2F52DPAO06OWUOyMlG/Ia+9g9FLhI9jQK+e
	7Pk1mpwnvwCtYepiLQgZ/F8zQBqD0OiYiSn4YWyoZbiRLgelNZipJb8RCZ4cuz2WWotkHyCnaJX
	99bcr2fSax3V3qDN58SXqHGwP3+it3hl6niEnMA==
X-Gm-Gg: ASbGnct9sw5ZvDttiogUOXxxzqTPDSyCHmSipk0ysDPTTf/6mTBIs5Cra070p5rmz1m
	8j45dExwH2epk6zUHxRcD58/eiuVuBxdVQIOV3DGiSaZa1fR7cPtrrRQjK1MoGV/2795lq3Btjm
	PYLOPk1F1uGaJtU3c6WD9uTSnqNoYKVgRmnA==
X-Google-Smtp-Source: AGHT+IFm02z/RgZm6/IfSP9b2A9XxMjlo0wxyKw7bnZQK6m8s/qL+dHccy2NAQdA8QpgNSb5VC5Y3JZobjE8cEMedto=
X-Received: by 2002:a05:690c:610a:b0:702:5689:356e with SMTP id
 00721157ae682-70a3fa255f7mr147088147b3.12.1747039601406; Mon, 12 May 2025
 01:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508133550.81391-1-philmd@linaro.org> <20250508133550.81391-13-philmd@linaro.org>
 <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com> <aB2vjuT07EuO6JSQ@intel.com> <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
In-Reply-To: <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 12 May 2025 09:46:30 +0100
X-Gm-Features: AX0GCFubIQGwUvsBeO1JqHfag2JXE624Dj7DHFCn6wFHtrkPbrfp4Ge8KnLAUwc
Message-ID: <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
Subject: Re: How to mark internal properties (was: Re: [PATCH v4 12/27]
 target/i386/cpu: Remove CPUX86State::enable_cpuid_0xb field)
To: Thomas Huth <thuth@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Markus Armbruster <armbru@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Daniel P. Berrange" <berrange@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org, 
	Gerd Hoffmann <kraxel@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org, 
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, 
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, Fabiano Rosas <farosas@suse.de>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	=?UTF-8?Q?Cl=C3=A9ment_Mathieu=2D=2DDrif?= <clement.mathieu--drif@eviden.com>, 
	qemu-arm@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 May 2025 at 11:04, Thomas Huth <thuth@redhat.com> wrote:
> Thanks for your clarifications, Zhao! But I think this shows again the
> problem that we have hit a couple of times in the past already: Properties
> are currently used for both, config knobs for the users and internal
> switches for configuration of the machine. We lack a proper way to say "this
> property is usable for the user" and "this property is meant for internal
> configuration only".
>
> I wonder whether we could maybe come up with a naming scheme to better
> distinguish the two sets, e.g. by using a prefix similar to the "x-" prefix
> for experimental properties? We could e.g. say that all properties starting
> with a "q-" are meant for QEMU-internal configuration only or something
> similar (and maybe even hide those from the default help output when running
> "-device xyz,help" ?)? Anybody any opinions or better ideas on this?

I think a q-prefix is potentially a bit clunky unless we also have
infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
and have it auto-add the prefix, and to have the C APIs for
setting properties search for both "foo" and "q-foo" so you
don't have to write qdev_prop_set_bit(dev, "q-foo", ...).

thanks
-- PMM

