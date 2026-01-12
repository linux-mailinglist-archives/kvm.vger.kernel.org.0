Return-Path: <kvm+bounces-67698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4C0D10CE1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF66E3063887
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 07:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B01F326D63;
	Mon, 12 Jan 2026 07:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VC3g7yaa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5232A3161A7
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 07:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768201611; cv=none; b=tlLjn25fsm4xBXzC7ZjuWorJEB7ft0YTa1/MZ7pdGS9GC7Lx4BzfRvoZDoePC/RcIzRPRgGpjQw1Dn8yNxhiHYIonMI5vMFRaFX/XjPbA19PcFSx1l6itoiGu9cah9pLi6OGLLrA3VlUPUM8xYeAA6SbNhNz33j54Qo+YyGh8AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768201611; c=relaxed/simple;
	bh=OYdWZwv7Z3l2W/6fbqIsB9pfYnSqj71IEtjS+go7wdY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FQxAqv7IXylzMed7mcD9Kwm++SkTEfQwhVID+Ss29vzlsnWePjkm1m/UmP+tOC8XICkeLSO/e/9xDb0Qr5ObDPn1m9uScnUUpjJXyTfTxLPloskCbD4/k0eMAxkbxAtPvCDBlh2k95m3v6xeeJBfpryJL1BtKifUAJ6pBvGd7Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VC3g7yaa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768201609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=92C3yHxeYvHOLFJEMSNqtc2Gy84JWmMyd6P+9QOrZcY=;
	b=VC3g7yaaSRdhD2IAIYxZpiybfkN5ONZuUz/bjD6XB+orvviMS92qAVV4tGIpdttI0Cohjl
	zPYVPceGL9Co+PQAyezQCGIQR35N0LQizNwSGR3IGbbL8tpKlGRyVGaUiOA1+0sMFCI3UZ
	yMPRxzemteSAQKxK/Yu3Ir7vW3NH0cM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-XqKedLBoNYm_wlt4slVB4w-1; Mon,
 12 Jan 2026 02:06:44 -0500
X-MC-Unique: XqKedLBoNYm_wlt4slVB4w-1
X-Mimecast-MFC-AGG-ID: XqKedLBoNYm_wlt4slVB4w_1768201602
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B27011956071;
	Mon, 12 Jan 2026 07:06:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A60A61956048;
	Mon, 12 Jan 2026 07:06:40 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 2982021E6683; Mon, 12 Jan 2026 08:06:38 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  "Dr. David Alan Gilbert" <dave@treblig.org>,
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
In-Reply-To: <20260107182019.51769-3-philmd@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Wed, 7 Jan 2026 19:20:19
 +0100")
References: <20260107182019.51769-1-philmd@linaro.org>
	<20260107182019.51769-3-philmd@linaro.org>
Date: Mon, 12 Jan 2026 08:06:38 +0100
Message-ID: <875x97ia2p.fsf@pond.sub.org>
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

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

>>From "monitor/hmp-target.h", only the MonitorDef structure
> is target specific (by using the 'target_long' type). All
> the rest (even target_monitor_defs and target_get_monitor_def)
> can be exposed to target-agnostic units, allowing to build
> some of them in meson common source set.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

target_long is only used as return type of MonitorDef method
get_value().  Its only caller is

    int get_monitor_def(Monitor *mon, int64_t *pval, const char *name)
    {
        [...]

        for(; md->name !=3D NULL; md++) {
            if (hmp_compare_cmd(name, md->name)) {
                if (md->get_value) {
--->                *pval =3D md->get_value(mon, md, md->offset);
                } else {

We store the return value in an int64_t.

Change the return type to match?


