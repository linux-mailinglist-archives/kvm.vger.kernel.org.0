Return-Path: <kvm+bounces-67697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C13A8D10C6F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0581305FC45
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 07:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FE1325709;
	Mon, 12 Jan 2026 07:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCmxcPbz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071C325717
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 07:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768201230; cv=none; b=sBsHyKWq44UOqoM4z/fZD57XEl2utgbeMdzXPG1b3cN7W8T0pdgIf5eKVea7cAdEyD7l2DWOJYV8TPGP++jT4M54ToJUS0bHvTqGsWQ8ZIjNhs9XXvEFSYlPYWVsLbCaMq+3iuVqfmlusLqruSlHk8LkunV9V1SyaYfFUW0ho3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768201230; c=relaxed/simple;
	bh=JNoMwc7u7GwNrMSVEKCavBxmiGAoNPo2tFDEa7seL3Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rfKBwJfBbRy14BO3l0wVZN4wSvOIk5K+W5Ra5rk0Dq/6t7LtnxnOah7mOBhJCm1oVXMdQeQpza8LTqSj3f++52sDvRPVvDGo09IKjpIpZn9d+TrrikrMAX5WIw0qt8qNTa2IGgiutvYxNniTKBnDitNWpycVNWPl2drKd2b3Jpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCmxcPbz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768201228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5lPuVsPyv1xwEPYso965xgr7n58gl0b6Ie4iaRnmdE=;
	b=VCmxcPbzrx0MBrx43aAkTqhBNPDKOpr/z+AHdIXqKrLzF/da4GdSuhdgZ89ICaadTP0SKg
	16k+8bLhpVV/ZLHe4EFA7iQ+mRmbGGx/NbLYu7C1NLoZl7LHUfUTuHLxxWzkuvgn/k638I
	yxZ2X37U4R9F2ipNw34jQNnYHlTc+MY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-Eh4OOc84NAWH6hua5Yl5Pw-1; Mon,
 12 Jan 2026 02:00:22 -0500
X-MC-Unique: Eh4OOc84NAWH6hua5Yl5Pw-1
X-Mimecast-MFC-AGG-ID: Eh4OOc84NAWH6hua5Yl5Pw_1768201219
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFC2619560A3;
	Mon, 12 Jan 2026 07:00:17 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94D3A1956048;
	Mon, 12 Jan 2026 07:00:16 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 2255B21E6683; Mon, 12 Jan 2026 08:00:14 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
  qemu-devel@nongnu.org,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>,  Richard Henderson
 <richard.henderson@linaro.org>,  Paolo Bonzini <pbonzini@redhat.com>,
  qemu-riscv@nongnu.org,  "Michael S. Tsirkin" <mst@redhat.com>,  Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Zhao Liu <zhao1.liu@intel.com>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  Laurent Vivier <laurent@vivier.eu>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Alistair Francis
 <alistair.francis@wdc.com>,  Weiwei Li <liwei1518@gmail.com>,  Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>,  Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>,  Yoshinori Sato
 <yoshinori.sato@nifty.com>,  Max Filippov <jcmvbkbc@gmail.com>,
  kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] monitor/hmp: Reduce target-specific definitions
In-Reply-To: <aWOvk527PkZzLtSp@gallifrey> (David Alan Gilbert's message of
	"Sun, 11 Jan 2026 14:11:31 +0000")
References: <20260107182019.51769-1-philmd@linaro.org>
	<20260107182019.51769-3-philmd@linaro.org>
	<87jyxsczyk.fsf@pond.sub.org> <aWOvk527PkZzLtSp@gallifrey>
Date: Mon, 12 Jan 2026 08:00:14 +0100
Message-ID: <87a4yjiadd.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Markus Armbruster (armbru@redhat.com) wrote:
>> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:
>>=20
>> > From "monitor/hmp-target.h", only the MonitorDef structure
>> > is target specific (by using the 'target_long' type). All
>> > the rest (even target_monitor_defs and target_get_monitor_def)
>> > can be exposed to target-agnostic units, allowing to build
>> > some of them in meson common source set.
>> >
>> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>>=20
>> The only use of the ->get_value() callback I can see is in
>> get_monitor_def(), to implement HMP's $register feature.  I can't see
>> the callback being set.  Is it dead?
>
> I think I see that being used in ppc;
> target/ppc/ppc-qmp-cmds.c
>
> const MonitorDef monitor_defs[] =3D {
>     { "fpscr", offsetof(CPUPPCState, fpscr) },
>     /* Next instruction pointer */
>     { "nip|pc", offsetof(CPUPPCState, nip) },
>     { "lr", offsetof(CPUPPCState, lr) },
>     { "ctr", offsetof(CPUPPCState, ctr) },
>     { "decr", 0, &monitor_get_decr, },
>     { "ccr|cr", 0, &monitor_get_ccr, },
>     /* Machine state register */
>     { "xer", 0, &monitor_get_xer },
>     { "msr", offsetof(CPUPPCState, msr) },
>     { "tbu", 0, &monitor_get_tbu, },
> #if defined(TARGET_PPC64)
>     { "tb", 0, &monitor_get_tbl, },
> #else
>     { "tbl", 0, &monitor_get_tbl, },
> #endif
>     { NULL },
> };
>
> those monitor_get_* functions are that get_value() aren't they?

You're right.

target/sparc/monitor.c and target/i386/monitor.c have more.

I prefer .member =3D initial-value when member is optional.

Thanks!


