Return-Path: <kvm+bounces-60651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E941BF5B72
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 12:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D266F424FA5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BF12EE5FD;
	Tue, 21 Oct 2025 10:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JkBTlwHp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0129F2E7185
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 10:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761041538; cv=none; b=iwXnCA6Q5+yiTB7sQdwmpb+Mt1/e6sT9Z7WpW2aQQQapzIpTLSS5SJeO2bOvcA4wtMAdrJhIXdvrn8gAo+N743lz7dzVvtVFHXW5vmIhfyZif6dGerpYTXfbm8RFDqr4+vpmKhrBlMqqFlhOXzCf9CW+9unlp6/gydD7MrIas38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761041538; c=relaxed/simple;
	bh=lS7BlA3ltA1K+OuXFELUMAx/9ayEMieaqVJ6yEPITIo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=NdtXvqu17MThvw8gtYFePLxhQ7RzT2LFd5NAM7PrFJB5lxev/sHqBDQoPLDKxKXFRQMJr9lk7SSIOSyh/mZ87IQH04tjuISji9ME6EEnNf6iiKI4eEghDxGVLDZvhrqtijISdfyx5cvBQtWJei/vwplU7dkAzMo9zEQyl+rLwx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JkBTlwHp; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4270a072a0bso564186f8f.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 03:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1761041535; x=1761646335; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lS7BlA3ltA1K+OuXFELUMAx/9ayEMieaqVJ6yEPITIo=;
        b=JkBTlwHpyLZTgYHz/IdzEveZvpMBXSz6i+qrRCjp6QqKa25oaBZG99U+6DvsJBtoqZ
         EoXT1iTsTmhOQn+eG51AlLpGYoOqrWLVmGj6827ZqWCSD9Gss8uKHJ5z+5usqZNDbktS
         J9hcPMLkvVNWe2Oq+isq+1yKdoQWEKjh666waZjKK4tEfAn9o5KESXN124aun0dLjTSf
         WFJsqdNm1dkXGgRphthprzTPW3Wu2+pxn8kTvoqf/Gjz0PtN9WFwu0bGPg6jbK3rB4lM
         kA3pQUwLeqbX3mouGEPnCAHYa+7WASNeKzkcXlIn4PabuMUEGqnabZIuobJA8swAR6KA
         H+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761041535; x=1761646335;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lS7BlA3ltA1K+OuXFELUMAx/9ayEMieaqVJ6yEPITIo=;
        b=UAK5B1u9OXL1C2BIxqFsNqm+CBnbR3v01FRnVoHVNgW30MvQ04VTXMHllgahdeWRGi
         ev3wWPqXMQMO5jTP+A7fObvhpTwFA9YbvxnOyF9Pxf7uXC/n4Tt+Ak94Rhks05N6C1DP
         yUCy1Z+IeQKGAWhJ+2+sxOoPveWZPnfLabhwFNEVyKNhMAgRP5ZUJyIc08e1HYk8CIvc
         W7VSR5g9qtSdU+pN2iJp8/EArV4LpxWKP6bJd8jgSeBtpzVCqUywk6BjCn+BoeNXAC8f
         sAWh9zC8k4mx26pjewDsGHMjf/BhGarAphBc3BAAWxu+rn5xs/sOuzkKoUsJaYIDEeFC
         r3fA==
X-Gm-Message-State: AOJu0Yx2hLcaIV1h+SB8A3OQAP6Uqpv4qc5HycIpcIDFY2FOFiQNS0ur
	0yNEbALI/B4r1DvZUJUVpFvu8dKpFpnFZW1BnAGN45F/0B4ATFQAkgQIA9RumWJhxoQ=
X-Gm-Gg: ASbGncub9Maxi5ICBF0au7DYK0XiwVav5Q2noS8iYZ4H9Ni/t7G2cW1BenSlZuWurWk
	YWaAxOJgUjN/YQLAeo+j0s867NXfQt6TrUjsXhhu93rAyl4Rvy+fppNcW4nKy4cZArLgWYAkndq
	DFs1lQuXuCLf03jqHGr1sBY6Npw2AAPal9v5DuKFpekwvkMbnWbfvyzrH2bhkUke7S4Wqzi5FhD
	o2akmlTXLVLke//8hPjJHAQ2HEi7CJAbhTpXZlFPqN0QsJ9qK67OjE4XQyqMX3Gc/4ifgyv3Mbd
	+RmwIcC5Kkk0GXTr+/STsnTM0E8+RwYGIO/IvJQ56WCX6NeOwp3w2qY1cq/MZLHwPBqoKnV2+Dv
	XFLhHKmgxiRsyZ0xRPDzKERD0CW/YpY2OxwvY89vYm9xeBcjtVKsnjRP21w9K8/eGTZClwj2TYn
	w=
X-Google-Smtp-Source: AGHT+IGMp04zmiOU/hD8LCGYBTUQQCGASEAZAsC4+kzM41lFqGtljB8ajxnMiIjuotYviMNMQl6Bbg==
X-Received: by 2002:a05:600c:6308:b0:45d:da49:c47d with SMTP id 5b1f17b1804b1-474941ec4b9mr10454745e9.0.1761041535023;
        Tue, 21 Oct 2025 03:12:15 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::bfbb])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4715257d90bsm189405475e9.2.2025.10.21.03.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 03:12:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Oct 2025 12:10:47 +0200
Message-Id: <DDNX3CCBLWXK.3KMVX9AKL162N@ventanamicro.com>
Subject: Re: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration
 to prevent stale entries
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <tim609@andestech.com>, <ben717@andestech.com>, <az70021@gmail.com>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Hui Min Mina Chou" <minachou@andestech.com>, <anup@brainfault.org>,
 <atish.patra@linux.dev>, <pjw@kernel.org>, <palmer@dabbelt.com>,
 <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20251021083105.4029305-1-minachou@andestech.com>
In-Reply-To: <20251021083105.4029305-1-minachou@andestech.com>

2025-10-21T16:31:05+08:00, Hui Min Mina Chou <minachou@andestech.com>:
> From: Hui Min Mina Chou <minachou@andestech.com>
>
> If multiple VCPUs of the same Guest/VM run on the same Host CPU,
> hfence.vvma only flushes that Host CPU=E2=80=99s VS-stage TLB. Other Host=
 CPUs
> may retain stale VS-stage entries. When a VCPU later migrates to a
> different Host CPU, it can hit these stale GVA to GPA mappings, causing
> unexpected faults in the Guest.
>
> To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
> G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CP=
U.
> This ensures that no stale VS-stage mappings remain after VCPU migration.
>
> Fixes: 92e450507d56 ("RISC-V: KVM: Cleanup stale TLB entries when host CP=
U changes")
> Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> ---

The vvma flush is not necessary on implementation that have a single TLB
for the combined mapping, but there is no good way of detecting that,

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

