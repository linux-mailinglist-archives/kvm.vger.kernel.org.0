Return-Path: <kvm+bounces-68655-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJ34G0X4b2m+UQAAu9opvQ
	(envelope-from <kvm+bounces-68655-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:48:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D459D4C871
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0B657A4C801
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7D343636B;
	Tue, 20 Jan 2026 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCjeDEFE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55A93A9D80
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 21:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768945376; cv=pass; b=PmP2VBBERZRY+FHKdTLCWofM5fE0E09YDx1AfTAGnMxeIS7U/2TW5mqQbz9YZld0zfiMiCeenPtZ2yHbznyTgCvgTV8xkX37H9p2bCh7HNTPdUl/7YVEChA1dYP7+iu9rFkDzUVLrAFvEx4nY9/5/aDRgBZKRCaoK9TsfccKDvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768945376; c=relaxed/simple;
	bh=SODSzcdnKzZlOKpIGDXzo+xqV5iYMzndbaLV3+jv2BM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EY2AEBDv0FyqpQ1sN5o1bKQyYAa9zGberI7Cft2obxAaPyJo4LT/FTxX6PhpEqPVPXz3bO4ajPQQ8n5qFw3G1SMyvykchi7VhMx7hqRiqCVMaqrbm8vRfXfbXsamcLhgB2Luf2Kb7fdkY2P1WK0LuFHpv39u0LKNFhOMwIj95bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCjeDEFE; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-655af782859so9394009a12.2
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 13:42:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768945370; cv=none;
        d=google.com; s=arc-20240605;
        b=ZOz5Tgw7YGvtHtvKZFY3bH5lFgucBSZ8QGGxl4ES4sCz0hMIxL17l+V/7L0omrP5G1
         RGp+NyC26OgpRGvpiD5/KTK+z8jBaGG5lWG1QQEO9FP7RFzSCqX648hYoSZm/DRd8PUT
         w1IMYNVyr3e5kQ6D+2WJ+nM77PzBKYK3CIEE9xQUUUZ7KYLMIgMhcRhjrJmVIyLb50Up
         Qq4nv2yU3qWLqooMMyfnaLXw1lo8RC89wM/Q3AulUqt5ys2EmA8OTenKPR90C9c5NiTX
         9AsGUfIIye7hM7YWS4mvfbqUnQ9PoolfdsdpSMpqF7/r4QTzdX/d6OAzIzMCilK06lAb
         GWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SODSzcdnKzZlOKpIGDXzo+xqV5iYMzndbaLV3+jv2BM=;
        fh=Brjv5CQhfBuz5fsJDx5epu6Xw+71WQNh6/ChPwxOC8o=;
        b=ZxGKHMPF67dRTk25xvXvxEr9qPEpZpYBpFymH81ckhL1SIEiUn9FnWVLOmB51ry7Ma
         upPRmF1uL+/FJHFhfdl+1sF5U+sVSk2EJ4VddXScvcz+aqsbrUda2C+IDrkc1HVve0Tn
         WsTW4JiIRIpbcw/BQPeyBjJ4i0oWb1FCiX2VEWLEL1/e0Mw3ghwiD7Xll+BY0P4dCXmR
         33N+FGIbqW6YK3kRJRuLqWMCnSB+ABkMa9o9GTYR07vgf+juXk0bN7Toc2o/X9sIt/sN
         RAKJCW4LJHbtympYrvlUtA4olKoHoje/Qd1SC0ai3iiL284MpCd5Vm9VtrNq5lwI7BAp
         F9CA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768945370; x=1769550170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SODSzcdnKzZlOKpIGDXzo+xqV5iYMzndbaLV3+jv2BM=;
        b=mCjeDEFEUZ9cPdQy0ma0VAeKJLfVsSvtlc3pt/Fzwf0DBHJSj7VIe2fpAlkTO7HvkI
         haa7K8kUOVv2NBC60N/tkgo1njVoFxR5z/WMQn1TSbkBZN3VVSg/l5PTr7XAvvXpzxuY
         4Amm17elQSS2X4KpmXkh4iXMmWBTWj4nzhDW++o+TCOlDaTL4fMjRAeRRQOJGYSGEAKS
         zxTtj9RcyBxrFmkRfpiabyL81Hv3EYCwtVXzaOUxhOuUgrOWOL/j8h0dWrkUZ597ycER
         E6aBcJiH9l78BBNbLsiY5n01t0cHbLBHFwAvMkMeqwmRVUwkHAIGFzcDLSAil9yJu4LP
         thdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768945370; x=1769550170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SODSzcdnKzZlOKpIGDXzo+xqV5iYMzndbaLV3+jv2BM=;
        b=KJ5dXy8TDGxmrbkVABmnIuZzY+Q02vAdKiNO05dBpMODXgLkMSKX3UEo7lhbU4+OtV
         m95maUrONKM0Of3IpRky9iJmP9w8UIqVsQP6daq4GWlICs/fkyhqKvGQuFodH/AOwUpD
         mdtV7qps8tS1eWxdeD18OQqxoCtv4q9GrVndHycHBpmjjl3CwrRDjh0rueM2tWZm23iR
         iqIx3PN2vPxAQqrkvLw8AWp4XUeA+FuVeohfqqoY0/j1ZGrECtBMVqdOi5SvtT9SnlCf
         pkjEDKq0U5/nR5+FrYYFORpZaJS5C3+PH6YlhgCN+hcznxRkzPA0/OrkiHgyJMwcdHM/
         fn6A==
X-Forwarded-Encrypted: i=1; AJvYcCWbmKZRXb2cymRJPoTMoWR+Pub+LtnLuerEF6HSyUPANkWtNK3MBuqpLWr0kitu3T5YCHU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9i8ZVsvjoq0z0yjjwnf8PMLGc/PyjH26etbRFGTTLPGKGeW7r
	0Qb0M/SNvuSQQr5Q41xVkiBQbS9hBnCQcx44BszicAL+40MW5fC2Vm3Jvlf/zBFOm2xfFClvuBx
	UtZ2RT0TuXq0bDjw3yEq2vHg5AsMRZEw=
X-Gm-Gg: AZuq6aIIqRyT+GOhx4Pr5xAb98/v2FtrhNiEwo50og3kY32w21hVesgojX3Uhoa6LU7
	HFrWPfP7/Ai6rT8lgTORQI3AYQ6Dm1rPU9c37oXURj2EIbBvvTbUbqZrZVY39/YolVqB6mKL0Wv
	VvzgsJzQ4+cmd8Kvo7M9CWsh1BqedOC0VP1xscnRwasTLCs8P6BDafJnKyAQl6APGWt4LrAvUfc
	8XL7mOH33krcsZfW6aYFIuG5LFPEOPPzJAC8n25UfThd73Tjesauz834wRKCR868rxaXg==
X-Received: by 2002:a05:6402:2691:b0:64d:2822:cf71 with SMTP id
 4fb4d7f45d1cf-65452bcc4edmr11496096a12.29.1768945370201; Tue, 20 Jan 2026
 13:42:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com> <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
In-Reply-To: <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 20 Jan 2026 16:42:38 -0500
X-Gm-Features: AZwV_QjZkTqQV3H6_gNVkzSg1uUJilQZy4GcLXCoTgnlrVmZgQIgQs8X3slohxk
Message-ID: <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Thomas Huth <thuth@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	danpb@redhat.com, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, 
	Alex Bennee <alex.bennee@linaro.org>, Pierrick Bouvier <pierrick.bouvier@linaro.org>, 
	John Levon <john.levon@nutanix.com>, Thanos Makatos <thanos.makatos@nutanix.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68655-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk,nutanix.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qemu.org:url,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,mail.gmail.com:mid,gitlab.com:url,systemd.io:url]
X-Rspamd-Queue-Id: D459D4C871
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Marc-Andr=C3=A9,
I haven't seen discussion about the project ideas you posted, so I'll
try to kick it off here for the mkosi idea here.

Thomas: Would you like to co-mentor the following project with
Marc-Andr=C3=A9? Also, do you have any concerns about the project idea from
the maintainer perspective?

=3D=3D=3D Reproducible Test Image Building with mkosi =3D=3D=3D

'''Summary:''' Build minimal, reproducible test images for QEMU
functional tests using mkosi, replacing ad-hoc pre-built assets with a
standardized, maintainable build system.

QEMU's functional test suite (`tests/functional/`) relies on pre-built
images fetched from various external sources including Debian
archives, Fedora repositories, GitHub repositories (e.g.,
qemu-ppc-boot, linux-build-test), Linaro artifacts, and others. While
this approach works, it has several drawbacks:

* '''Reproducibility issues''': External sources may change,
disappear, or serve different content over time
* '''Opacity''': The exact build configuration of these images is
often undocumented or unknown
* '''Maintenance burden''': When images need updates (fixes, new
features), there's no standardized process
* '''Inconsistency''': Images come from different sources with varying
quality, size, and configuration

This project proposes using mkosi to build minimal, reproducible test
images directly from distribution packages. mkosi is a tool for
building clean OS images from distribution packages, with excellent
support for Fedora and other distributions. It should be able to
produces deterministic outputs.

The Ouroboros has finally caught its tail: QEMU adopts mkosi for
testing, while mkosi continues using QEMU to exist.

'''Project Goals:'''

# Create mkosi configurations for building minimal bootable images for
x86_64 and aarch64 architectures using Fedora packages
# Integrate with the existing Asset framework in
`tests/functional/qemu_test/asset.py` to seamlessly use mkosi-built
images alongside existing assets
# Set up GitLab CI pipelines to automatically build, hash, and publish
images when configurations change
# Document the image building process including comparison with
existing tuxrun/tuxboot assets (which remain out of scope for
replacement)
# Migrate selected tests from external pre-built images to mkosi-built
equivalents

'''Links:'''
* [https://wiki.qemu.org/Testing/Functional QEMU Functional Testing
documentation]
* [https://github.com/systemd/mkosi mkosi project]
* [https://gitlab.com/qemu-project/qemu QEMU GitLab repository]
* [https://www.qemu.org/docs/master/devel/testing.html QEMU Testing
documentation]
* [https://mkosi.systemd.io/ mkosi documentation]

'''Details:'''
* Skill level: intermediate
* Language: Python (test framework), Shell/mkosi configuration
* Mentor: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> (elmarco)
* Thomas Huth ?
* Suggested by: Marc-Andr=C3=A9 Lureau

