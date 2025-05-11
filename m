Return-Path: <kvm+bounces-46121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FECAB288F
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 15:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853361892FE3
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 13:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE64A2571BB;
	Sun, 11 May 2025 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nghPzRIy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86C2571AF
	for <kvm@vger.kernel.org>; Sun, 11 May 2025 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746970823; cv=none; b=QPajpNBo1nuzjTWbYfIg/A+o3vfwZLs5Oaw34dD8ABBvkZ8vnJe6LqSj2+LikgZt91/S+06dj1pXiBz+9h/yeCspBbO7gB1EX/N8kX146Eo8XQ7733zdmp63cYcCECNPrBvCrL1yqbnMM6ayRTyds1lM6s2UCvvnoM3gTfRQcfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746970823; c=relaxed/simple;
	bh=tQYCAYnSnMLVlXmM6Q3dpe1j9yqTGHdnD9s/TU+XfR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iH1lqPcsEVqp3BdxrpRARt0IrQ1vKomzdIqgISp0hOdrFmRN4NTm7I7sSEtLibrQisrREuiMJaGW8/29t4DSD0TMMc8NPJDzAodX+ta2QsuSLGREjJ7367PIf3Q2GunbsMNzj7oKzq8Ksx8dVMDk8yM7A7uY07vBbisKpVWx07Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nghPzRIy; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e733a6ff491so3575127276.2
        for <kvm@vger.kernel.org>; Sun, 11 May 2025 06:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746970820; x=1747575620; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tQYCAYnSnMLVlXmM6Q3dpe1j9yqTGHdnD9s/TU+XfR0=;
        b=nghPzRIyMV/yjuSA0R4nFD18MsUDZpLEiX1qswiXrz1y105YeEZ5qhpzHTq+h4hI8a
         0XOT2UcoSHJvoDE/YZTO2tw5bLd8Pveb/beDCr1YSs4g1zETFrn0I2IJ8teDLj4U3+KR
         Ou4N/trzNEaBINi9rqh2+FikVCcmfspEVvlF9iQ6G7qbvsZF0nO2emaOkogLRLONfb87
         Lgv1AX0smSZCd/YYAsYo1FquCjZelh7OzNM1AXE2ZUs2W5IwdTZdzEkwgRnVWR9i8VPZ
         SNJCvWSyVr4VivLPAw6AIa1VkAdMXL3ZZNKvOQ6v95NDXhs5TFMMk2kG2p2KnrEH2WzQ
         TL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746970820; x=1747575620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQYCAYnSnMLVlXmM6Q3dpe1j9yqTGHdnD9s/TU+XfR0=;
        b=cmhm81JMa7xvRnta9T7JFXmOiiwpNmYsfOAyC6qPcflP9u33I0IupTz66sgeZlKCwI
         Gy3KpaKcSKo56+J7gXWyQmMyj7XtvCN599LWwCv7stooKEwkj+dHbQqabIbsSnpaLIqs
         bgyifaq/pOH0ttyjPwLAgZmGydEn7JNhOnaPFkde5YbG6Qa9RmwOgHdQ1iTySa8EAQzN
         jSEdynXB6gD9rb0o8sowRDUW00wNcdSI3wsP+/XLbqoILK6gEl6w0k0aDbangs4XpWqg
         JHwz0sYwAHKzMUS66cqJe5DDv0KeF+eoUJMDHmdWkgFp4fbl8y6cU958pBDOvYvd+y4n
         hHbg==
X-Forwarded-Encrypted: i=1; AJvYcCW8WV9/rss+2N0/NyKXYi7hpYjHj4heE5W3/28DuFQVZNjl/QW+nfj+JK0ciJhPB4Oe20A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmhihPbN+ZQM5bRiA4kENZ8uqW2M+GQGcAkte11os+i3eDNfW+
	L1zcvXXa3yaqYp69vxU7/a2SK9ktFshs2e0t4IPnLVedT1gcknhySKb6woxDW9FNzTZ+6wN9MIq
	2Mb5Vt6Ll7jIt81W56QgEGlkZbfJntcOU0mNzxA==
X-Gm-Gg: ASbGncupDPL4FS1THxg4Cg4uyOnOQveuPITLEFdlOSV8KeqOo8E8SqFs2eJdtoWtVrq
	H90tayuNTK91Y40ppIEqj1sgnO7TCbGtoPxtphdEfMvryGXUbd4MQZdrdkWMQX17st6FU8QyKQU
	CMKCHnA8GbcMRryQz4OSOcfiRg4oIT2nFFcg==
X-Google-Smtp-Source: AGHT+IE0KyLbfrS2S6y6k0L5Sv5Y/BL7XPKyq9u/1NkOPd9IMbHcYOljv/+I7+C94CfPc8CC+GuYQ3cEH7yDPqKhrqM=
X-Received: by 2002:a05:6902:2503:b0:e78:f4df:8441 with SMTP id
 3f1490d57ef6-e78fd9be186mr13405339276.0.1746970820155; Sun, 11 May 2025
 06:40:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 11 May 2025 14:40:09 +0100
X-Gm-Features: AX0GCFthFJShMwduZaRe8unlmupmQOaRCZ993P7xtVVqY51NCVV1-mxoKOxg2B0
Message-ID: <CAFEAcA_NgJw=eu+M5WJty0gsq240b8gK3-ZcJ1znwYZz5WC=wA@mail.gmail.com>
Subject: Re: [PATCH v7 00/49] single-binary: compile target/arm twice
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, anjo@rev.ng, 
	Richard Henderson <richard.henderson@linaro.org>, alex.bennee@linaro.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 May 2025 at 00:42, Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> More work toward single-binary.
>
> Some files have external dependencies for the single-binary:
> - target/arm/gdbstub.c: gdbhelpers
> - target/arm/arm-qmp-cmds.c: qapi
> - target/arm/tcg/translate*: need deep cleanup in include/tcg
> - target/arm/tcg/cpu*: need TargetInfo implemented for arm/aarch64
> - target/arm/tcg/*-helper*: need deeper split between aarch64 and arm code
> They will not be ported in this series.
>
> Built on {linux, windows, macos} x {x86_64, aarch64}
> Fully tested on linux x {x86_64, aarch64}
>
> Series is now tested and fully reviewed. Thanks for pulling it.

Do you/Philippe have a plan for how you want this to go into
the tree? I know Philippe has been taking a lot of the
single-binary related patches. Let me know if you want me
to pick it up via target-arm.

-- PMM

