Return-Path: <kvm+bounces-27698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFD798AA97
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 19:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9BE5288D4E
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 17:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1BC194C9D;
	Mon, 30 Sep 2024 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="AF5JwnyZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC8A193070
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 17:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715895; cv=none; b=dhBDqOjPu+k26VZ1PJl6HOl19e7p88CF6GgMK81JeW2FEJ6lclVE+LbyqJnL976B9x/0onRQ79zTDBo6Xmg4+Y0KvBrUnICLd2zcoXIwq+fsiRPfQsgbo224d4uPENvBconMLjF0CSNFDVs4oMeHKNLoV3HWcLZHZYa48nYJBwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715895; c=relaxed/simple;
	bh=DsFjvp6V0bUt3fQrlC3zZfx5v7AY6PiaWkupBsGfwY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hW0j5OZ0qx+mP05uuKm43MYjao2CYy//ufpcBA1GqGm9mMffGQgGQU/0xyML9n5aUXPoQcc9IeTI6ejfSZbdbgguk8HW+jQ4eLIhS+4YyYl7lnKxbr3faLzEGr0cs98wgcuNjXf56Lhxbt9zQ6znW4CUe2pqdGi5YxuAFcyBI10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=AF5JwnyZ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7191fb54147so3320278b3a.2
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 10:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1727715891; x=1728320691; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xz+bkfejvthPlgPdQSvVCfDsoTn99Xm9hmAjc8LPyr4=;
        b=AF5JwnyZEVz27AkN3p7pLqlTxziQ0D9gti9i0xwRA56sfE00p2KLl4Bg50fRFG627e
         /e9wPXVkGHYBEe4RMiyt/H0GFqHlXrD/wIA7oCNUHv6V3/YF7HWZTHRJq/ATePIV3wat
         BuOMV3qYDVJO7M1LxfnBhP0C3KzVY2ZnHTHPbiFv+3dsQs6c+xovgtZc+nBJaRDQmw7r
         IA3Z0wY2QbuR/smOalu9YSzz/8DVGN3AjcMIyPd13eWJxJZbwx4CP0VYjepzafUZa9DF
         pSgBcbQmshGRHGQJk0WSs1OqX/lbIw7P482GvWkzZNkPCpdh94GhPsg8yH+orLS/yqHI
         I6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727715891; x=1728320691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xz+bkfejvthPlgPdQSvVCfDsoTn99Xm9hmAjc8LPyr4=;
        b=Hia77gvdwi8V/ylf2Gecuw6JR/SMvjGv827nD71Z+ym9jMtbfsyGcI6TCAQdi4gkN6
         8ZNCCMKMx03ei5wlWCXykfP3+0m0BjD70sULGyi5OD+c8+MvUQEnv36j/+ang+fTYJhN
         9dJGoa0ita5qsrHo7PATycZc2XhnSTgV4KD0XQQrAB+Of377L7j70o91BVOZ+5TSxsVr
         rV+qKGe9lM8omP3oc4zYh3Oqh2p+p6bFu/1lRs8ECXd3Xv7q6+9LpwEhNTpOM3oxhjcL
         U5VA95nlqH3i9BYDbTxz+U6raW8YXmrr4GBbgPjIaYgeSd8/+Zob+uTnrivRt3fCTR64
         Oihw==
X-Forwarded-Encrypted: i=1; AJvYcCXN/Qr+kQk5FdEHZFe0+1fFaVY69k8TQIXmoER7Qcz3G+fdFi7XWNvdVTr8KszxB4wsK20=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF/wTCTFU6xNC2cERm9ibTskPmD7+uel+e2qPt+RYZeEKRIZDt
	j+bVRqoO3I6iUY7tdK8ZEx1UlgI3e+psJycjSlCUDFzJ2RORmxPOxOjXgzejPN0=
X-Google-Smtp-Source: AGHT+IGj3wqkwReKg8OnHSxdCc7zaYOfFfaOE8qXpsQ0EjTy/gbYQvbdblFQ+sQxStUGKpCkov+09g==
X-Received: by 2002:a05:6a00:4fc4:b0:717:950e:b589 with SMTP id d2e1a72fcca58-71b26049452mr18911436b3a.19.1727715891519;
        Mon, 30 Sep 2024 10:04:51 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6db2cadcdsm6784562a12.56.2024.09.30.10.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 10:04:51 -0700 (PDT)
Date: Mon, 30 Sep 2024 10:04:49 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Max Hsu <max.hsu@sifive.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH RFC v2 1/3] dt-bindings: riscv: Add Svukte entry
Message-ID: <ZvraMdZa8Shs/yyQ@debug.ba.rivosinc.com>
References: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
 <20240927-dev-maxh-svukte-rebase-2-v2-1-9afe57c33aee@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240927-dev-maxh-svukte-rebase-2-v2-1-9afe57c33aee@sifive.com>

On Fri, Sep 27, 2024 at 09:41:43PM +0800, Max Hsu wrote:
>Add an entry for the Svukte extension to the riscv,isa-extensions
>property.
>
>Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
>Signed-off-by: Max Hsu <max.hsu@sifive.com>
>---
> Documentation/devicetree/bindings/riscv/extensions.yaml | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
>index 2cf2026cff574d39793157418a4d4211df87315f..9f730e3aaae949debc18396183b989b504dcb899 100644
>--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
>+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
>@@ -171,6 +171,15 @@ properties:
>             memory types as ratified in the 20191213 version of the privileged
>             ISA specification.
>
>+        - const: svukte
>+          description:
>+            The standard Svukte supervisor-level extensions for making user-mode
>+            accesses to supervisor memory raise page faults in constant time,
>+            mitigating attacks that attempt to discover the supervisor
>+            software's address-space layout. Currently under review as Pull
>+            Request number 1564 at commit 81dc9277 ("Svukte v0.3") of
>+            riscv-isa-manual.

Reviewed-by: Deepak Gupta <debug@rivosinc.com>

>+
>         - const: svvptc
>           description:
>             The standard Svvptc supervisor-level extension for
>
>-- 
>2.43.2
>
>

