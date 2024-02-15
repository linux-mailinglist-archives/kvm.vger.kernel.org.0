Return-Path: <kvm+bounces-8820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB80856DAC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 20:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E03AB289ECB
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F40D13A246;
	Thu, 15 Feb 2024 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KbQMmF8V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECE31369AD
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 19:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708025209; cv=none; b=c6KE9VO4SboGyVeZBl5h/qT6pNbSPCGzc5SW2BvIpbR16u6luKygL+h2BtuXJHAjxQ2egkM8vDFtnD9HTDyM/ITrt8usmrG2pPUHzau1USnqP0ZqWTgOyhrAcjQfYEBiW5SZlTjLUina/FSUCWEdaChAiESmhh0S1oBaJjefACM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708025209; c=relaxed/simple;
	bh=g4gXRysjrS/kTYtCYP5fJsXncbyru7gzlRYm/zwv35E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7/6UmzjaNX4FuXmkWr76WA+/JwGu2hOUvChw6i9qyxSZc6C/u2EUEhKp320O3C0v1L9Dy+nM74+DhQEZVXeYGhIxwa/q6CDX1CuL/O9IuOIX/XmrA9Vg6LxMhiS+WUXQ5Bxndq+vR54ECDNWh90+wXFkZH+T49mJk3LfHYzPhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KbQMmF8V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708025206;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=WSM2q6F8oVeBLvSk9HF07rvPb1zaTwpR9ptolNDGCHY=;
	b=KbQMmF8VgAHzNvgSHmytTtfI8ssbC5OC8eKTF+rV6RaVbf6irU6z21ATHdfVfz8FDub2Kf
	1rnxHQvcHPj7RBP9l6WKpMa8ElYUlIbmlfExXQUyTFB3wc8wWfqD8vsWL84aNAWikr0jC8
	lUIgFkcm6aEfqkCAT1nc6iwAq+ybG/g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-xecKsAMlMmyXGwzhHfmc4Q-1; Thu,
 15 Feb 2024 14:26:40 -0500
X-MC-Unique: xecKsAMlMmyXGwzhHfmc4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0783C1C05AD4;
	Thu, 15 Feb 2024 19:26:39 +0000 (UTC)
Received: from tucnak.zalov.cz (unknown [10.39.192.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B42E611D1803;
	Thu, 15 Feb 2024 19:26:38 +0000 (UTC)
Received: from tucnak.zalov.cz (localhost [127.0.0.1])
	by tucnak.zalov.cz (8.17.1/8.17.1) with ESMTPS id 41FJQZ3G1235764
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 20:26:35 +0100
Received: (from jakub@localhost)
	by tucnak.zalov.cz (8.17.1/8.17.1/Submit) id 41FJQWEK1235763;
	Thu, 15 Feb 2024 20:26:32 +0100
Date: Thu, 15 Feb 2024 20:26:32 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on
 gcc-11 (and earlier)
Message-ID: <Zc5laJzgwSPtHCTe@tucnak>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <ZcZyWrawr1NUCiQZ@google.com>
 <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
 <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
 <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com>
 <Zc3NvWhOK//UwyJe@tucnak>
 <CAHk-=wiar+J2t6C5k6T8hZXGu0HDj3ZjH9bNGFBkkQOHj4Xkog@mail.gmail.com>
 <CAHk-=wjLFrbAVq6bxjGk+cAuafRgW8-6fxjsWzdxngM-fy_cew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLFrbAVq6bxjGk+cAuafRgW8-6fxjsWzdxngM-fy_cew@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Thu, Feb 15, 2024 at 11:17:44AM -0800, Linus Torvalds wrote:
> but the manual addition of 'volatile' is unconditional.

That is just fine.  The extra keyword is not wrong, it is just redundant
with fixed compilers, where it doesn't change anything in the behavior.

	Jakub


