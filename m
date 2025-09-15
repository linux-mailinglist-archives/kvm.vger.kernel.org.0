Return-Path: <kvm+bounces-57601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EE2B582B2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F9412026DC
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5039E286D78;
	Mon, 15 Sep 2025 17:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eZn8VCfB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7769272E4E
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757955719; cv=none; b=jyvXhq3jX0BUJnFFRvP1ORNJhkoNy17CzkhcED/VfIiPE8sclzdd4X6Z+xdquWr/s9cELRsrB4i+HUAVMhG1Nyw1yfuSfnwv186LDdiomGGjk9VH2MVO5JmlK8+9HpsfALOhNawLu/ke8Bm158CEDmzItA49xgdKRT2vMYXdD08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757955719; c=relaxed/simple;
	bh=n4vASe85eZy1KMZCjpCPLB0+R5aQYRJHMP2IQSmxlmc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=hrAotxhc26EZ367YRpnsRGDbQLeXo2eQucT16N0UVDrPUiE7XsR2kNhxOZrTal6xS6MyI79FgJC6pycTABstcAugk5y0yskDROVrB+98VszKJU00MnO2jtUk31s3kIoWGxnrhsORYZzXC7uFUiCTiuxnVbe0lIBtjEpmXthg9uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=eZn8VCfB; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45f2f9f1641so1139625e9.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 10:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1757955716; x=1758560516; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWHHL1s0psJfb//epbwV/zjtkXGJcyLhcOl2Is0sDa4=;
        b=eZn8VCfBDEKTZwke7bXWAQf55cyK6DZXnVN9WPzRSrzp98LIj0F2Z1Lnzgz0r4ghfE
         UWKtLfQH7Vo+20SQ7kS9+8Ei/dn1VxzGn18OvllnDBw5CUi0gHACWGr/EVqwbPLQRiJX
         3WYbSMSdHoT3GKw+ktHo7rHpraun6EMY/ejyKDhjSwXEuISFRrla0HbDjwXZei9wkdgw
         QMWfndUxGVN1l78ZyJGFWuaIL9ZT4pXxDn+Z19J7Yvl3ZsyougONebbLb+aDbhz6vmCe
         If4QBIciBdYsJ3JAFek2h0j+NpSYijHQBLDlPE5s0Nb/icoQ8svkPTPy4V+FihyCcvPq
         cB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757955716; x=1758560516;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DWHHL1s0psJfb//epbwV/zjtkXGJcyLhcOl2Is0sDa4=;
        b=eHXs7CJW1jgOisaTh1OBtHok8Qe9phqgzTtnolQYt7tJpHY/Bh0ZmpMes42xUuoIcu
         pRhsAwRyfDIN72kpTpkC/rWMrh/7EJBYDaYVsXfsW3SDI52uw2hEcm/hcHjiginFn+hV
         itBMbDe3KzSSjvnomsjm1uQ92/fIvfJ80uziE6BrTE2WLnUjKb/kuV0luiKCAUiTOH68
         vGc33GDm7wGAEdFZTLzoXg3c6sy9L04YGGNjXz06tCm593V/h44EUlIWqGoMKbwT79Ve
         dsod7YdTiD7s93z/xKYCO5i/sNZARu4rH48Ev1l6qsqL6oApNRSzObqatk+K20n61k7I
         xPqg==
X-Gm-Message-State: AOJu0YyH53Xha2xVpaOOCT2zV6dLZLJA9LkqFB1xG2yUTtE8wdrDd9X1
	Prc1b21CeGl27Sya7Nho0Q7/9U6E2Ho1RdFXxedawd9LhzdCjJzpl0USPFaysqNry0c=
X-Gm-Gg: ASbGncsfIC7PZdPWCDJGVIR3p9WyKolf8Z4H76ubf2UUE0q9BGfFQIsRFFb5gZvjAY3
	lTt4fmQlTwO0Ty40NRNOdLjJO8heV6U0Z3wjZl9LMhdc0eUhCgAA/58xwmXjoX/5KbDc9E8Bbas
	LjBQptDQ5CgYSOx5G2ENy7YIetrNpfdn5Rc2iC5rVLBFasRwjA22EGmijlfr1cvgAtVYz5B88fU
	fQX0eGqXteqexz5MQJ8MlyWaHPRrr+Dvkvk7R4eICFuNmVXZTTd/5brlEcALaSkiOdgbIdoY1DK
	hDpqhSeSqKK7X/I7L1K2kfGOgcNIWmd1S+WV5VG004Fs4FBzI11dIvRDaFkaMCywYGXdz9JtD4H
	pyNlpkRUo9mzQyq2hvLZ6CQ==
X-Google-Smtp-Source: AGHT+IFU1lq2Hn1rhnQ1PXztdy1u0/BZUM8rfqOS080uGF0cxwIiBohWrEivOXB1opFs7TzdP9qSMg==
X-Received: by 2002:a5d:64e3:0:b0:3e6:4b2:b9b2 with SMTP id ffacd0b85a97d-3e7659e936fmr5550562f8f.6.1757955715906;
        Mon, 15 Sep 2025 10:01:55 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::bfbb])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e9c2954b10sm7301300f8f.50.2025.09.15.10.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 10:01:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Sep 2025 19:01:03 +0200
Message-Id: <DCTJ9US6E4PG.1MA4ICDR21DS6@ventanamicro.com>
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "Tianshun Sun" <stsmail163@163.com>
To: "Jinyu Tang" <tjytimi@163.com>, "Anup Patel" <anup@brainfault.org>,
 "Atish Patra" <atish.patra@linux.dev>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Conor Dooley" <conor.dooley@microchip.com>,
 "Yong-Xuan Wang" <yongxuan.wang@sifive.com>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Nutty Liu" <nutty.liu@hotmail.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [RFC PATCH] kvm/riscv: Add ctxsstatus and ctxhstatus for
 migration
References: <20250915152731.1371067-1-tjytimi@163.com>
 <DCTJ3N8W4PCL.9XCHFVGS62SF@ventanamicro.com>
In-Reply-To: <DCTJ3N8W4PCL.9XCHFVGS62SF@ventanamicro.com>

2025-09-15T18:52:56+02:00, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicr=
o.com>:
> 2025-09-15T23:27:31+08:00, Jinyu Tang <tjytimi@163.com>:
>> +	if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(ctxhstatus))
>> +		csr->ctxhstatus =3D vcpu->arch.guest_context.hstatus;
>
> Neither should userspace be able to directly set hstatus.
> KVM should derive it from other userspace configuration.
>
> What isn't correctly reflected in hstatus?

Ah, we don't set hstatus.SPVP when setting KVM_REG_RISCV_CORE_REG(mode).

