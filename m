Return-Path: <kvm+bounces-6880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA16583B380
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 22:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ABDDB246DC
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC961350E7;
	Wed, 24 Jan 2024 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OAAEEf6N"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F96E1350CF
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 21:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706130101; cv=none; b=E2VD2YKsJ1GjaQtqdgmE01DIMejcLFk0EefgFs+qwnJt/qVtAdvcmybXycy2orTXbGHyKRCryfXfWqxZIvU+6NChiahi3REuJfGPuPF7NEci8E33DwOZTzn+CjxJQCD7/qPThWcPFeCmxB40BPteqKXOKRR9Mof3UaET0DIfiuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706130101; c=relaxed/simple;
	bh=uJwu5fFVAMZ6ZaSFNo8zKd2EOxE9LJ5JbBEY4Nr2jYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2V8eKxMted8CDPlyQNI3hJMZlbuFjUdgLBhIzStBKC/l+s60nH89OsaH/BvPpaLH8GtlFmv7ZMYQCfBE48C+6L8bJbnLVqh2ai5qbdSvtcRxzJZrNUtWq+I0pR0e7C5QlbgDGE+dOWz11gk2IZqcp1A99EL5ZLbyypAahQLOmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OAAEEf6N; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706130096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vppg9qJI7AD03wh9PpDgAouPG9vz7u0UUejSSoel6uQ=;
	b=OAAEEf6N0PQJFbc6Y4csIfXG7WzBIPzd+fgFyBe6iE43FpyBmiGsRIXZcBepIEfcuraoRE
	NIsBlmwFamqaNKZlqHT8H2sGof4pnHSZb04AAjmSmC0SX9Vz6h9OAH0+IVpF9DDZ0cMFD1
	zAQUH8kweaVlg8R3EUMI3WCf1b5YjbM=
From: Oliver Upton <oliver.upton@linux.dev>
To: ARMLinux <linux-arm-kernel@lists.infradead.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	KVM <kvm@vger.kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Itaru Kitayama <itaru.kitayama@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2] KVM: arm64: selftests: Handle feature fields with nonzero minimum value correctly
Date: Wed, 24 Jan 2024 20:59:48 +0000
Message-ID: <170612997432.109327.7730932953409830369.b4-ty@linux.dev>
In-Reply-To: <20240115220210.3966064-2-jingzhangos@google.com>
References: <20240115220210.3966064-1-jingzhangos@google.com> <20240115220210.3966064-2-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 15 Jan 2024 14:02:09 -0800, Jing Zhang wrote:
> There are some feature fields with nonzero minimum valid value. Make
> sure get_safe_value() won't return invalid field values for them.
> Also fix a bug that wrongly uses the feature bits type as the feature
> bits sign causing all fields as signed in the get_safe_value() and
> get_invalid_value().
> 
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: selftests: Handle feature fields with nonzero minimum value correctly
      https://git.kernel.org/kvmarm/kvmarm/c/1cd2b08f7cc4

--
Best,
Oliver

