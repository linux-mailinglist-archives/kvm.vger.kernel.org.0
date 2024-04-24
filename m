Return-Path: <kvm+bounces-15760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C24348B037B
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 09:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E32E52842F6
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 07:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660A01586C1;
	Wed, 24 Apr 2024 07:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Hptc5V2+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A71581F2
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 07:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713945032; cv=none; b=gbS+qp4aZegfpxKr5x5EAWPKD3gAAlE2RdwKhJLPrXKWUBHcIaMHP8Xk8fiFxURnllpD8fGHbbeVjvf2g229C/GvIqIaalfLNg51vmQJmfb4s320PnCQvaN9aKLjzK+UQeiO2beu5jd8yL41Zltq8kH4AQfXtVFuYnx4bmEHqco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713945032; c=relaxed/simple;
	bh=g/Er6GYXVGaNH7JDBFXh3LSSvzcGk3gWsJG0AOM4CTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfrNygCd0ZH/C9V1uc5wNVRlYofp+IAXHVvGbL7RTY8k6eIsULmh+J5z4mJEKrLrRuqI50iY7puVs4D20ZT4usXckCHx7vSL3cxp8Zg3SkDPZL3QSGC1O4Emi7mzZtOQEfY/z/bpuCwlBvvnts6FK197a+LSN4k4TKhV/VUtPAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Hptc5V2+; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5176f217b7bso11016298e87.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 00:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713945029; x=1714549829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g/Er6GYXVGaNH7JDBFXh3LSSvzcGk3gWsJG0AOM4CTw=;
        b=Hptc5V2+rnXXJTqWm5x2+cw4imBiLFVePvUqflhfHQ8cZF1sfv395V+XBa/xs7y3kg
         v+7r8jKZXa/hoyWrRl+ROXH9O6LWDyCtWBnKlIBSVJ0gv4VxlPuxf/g/xHoUXOEgX3iT
         y2wqeV74cy0r/R8GD5JSO4qHrwoIMWsYv032SHQwkahIXm9mMf9aoFcvzmXI6QmglkZP
         EHTsTrQnqxKFdbXj3AJmv2kboJUQlPkb6t5c5GHQ7OgZsb1d45HdAlLcjRVMVhiZqvgl
         NK1sJTr/yYf6K0Xn+GpyY/07ebCkkurUSMkF5GQd38vS8FPC/oUzOCQFuTPaza+Qto+v
         znOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713945029; x=1714549829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/Er6GYXVGaNH7JDBFXh3LSSvzcGk3gWsJG0AOM4CTw=;
        b=vDv8HoAr7wM1aI7YEaWdSYxGwmXfqLOn7Bjsr0ktp0h9g27Ba2nDJgCfszooEXJcaQ
         GmjpnVF0GGq5uJgvAlx1DFmiernS/dfLCP3kQEBx9pbp7IJlOozwKqev/gAWMSwtLo2I
         pEoqwd/WlVVrxqT4QBUEvUugze0F6JDD/PNh6SYPDtXEHDjRsj56/woKOLI6IlhOfTh/
         5vx61THe0/VYxrNIfYub8RTD7OvWIQ+quu8Ocw+pet138tZeQInBH+jr0GdUkiNtzr2k
         xw2P4L7k6D9GamqOL2V8AdRby5WPTDEe+MpfWlYYJn5CMRN08NBif/t2JYxIp9rbR+Sq
         n5NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB4I2YweLxldBeADpwln9TpwJWSY/RELRnwt04twY/tY1YIKBGYPQm0e0VoWLzMgbKRzMvRAp5HZGaFCcqQeYZaZXg
X-Gm-Message-State: AOJu0YxWyvNSo3QbvARKeQGP5ucjUv6Dk4HpYJRBc1/X3sfGQwe/PTBz
	qmKHMfK9R2VIhG3yr930LnIUDH94Ind2d1AjGs9M6maoIU/hLbuCPIFbp6t8X2A=
X-Google-Smtp-Source: AGHT+IHIgFIs/HtMioD9CZgIp71sOpN4oVb9nF69ng3WYESdlcm1/4O4CiXzS4QWI0WKmvheznXTlQ==
X-Received: by 2002:a19:7413:0:b0:516:d09b:cbe4 with SMTP id v19-20020a197413000000b00516d09bcbe4mr1517679lfe.53.1713945029369;
        Wed, 24 Apr 2024 00:50:29 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709066b1a00b00a53c746b499sm7957520ejr.137.2024.04.24.00.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 00:50:28 -0700 (PDT)
Date: Wed, 24 Apr 2024 09:50:28 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, 
	Kunwu Chan <chentao@kylinos.cn>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@collabora.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Kunwu Chan <kunwu.chan@hotmail.com>, 
	Anup Patel <anup@brainfault.org>, Thomas Huth <thuth@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: selftests: Add 'malloc' failure check in
 test_vmx_nested_state
Message-ID: <20240424-e31c64bda7872b0be52e4c16@orel>
References: <20240423073952.2001989-1-chentao@kylinos.cn>
 <878bf83c-cd5b-48d0-8b4e-77223f1806dc@web.de>
 <ZifMAWn32tZBQHs0@google.com>
 <20240423-0db9024011213dcffe815c5c@orel>
 <ZigI48_cI7Twb9gD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZigI48_cI7Twb9gD@google.com>

On Tue, Apr 23, 2024 at 12:15:47PM -0700, Sean Christopherson wrote:
...
> I almost wonder if we should just pick a prefix that's less obviously connected
> to KVM and/or selftests, but unique and short.
>

How about kvmsft_ ? It's based on the ksft_ prefix of kselftest.h. Maybe
it's too close to ksft though and would be confusing when using both in
the same test? I'm not a huge fan of capital letters, but we could also
do something like MALLOC()/CALLOC(). Eh, I don't know. Naming is hard.

Thanks,
drew

