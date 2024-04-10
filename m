Return-Path: <kvm+bounces-14069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC80489E906
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEC371C203D7
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A034C2D0;
	Wed, 10 Apr 2024 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ho6iRtCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465317552;
	Wed, 10 Apr 2024 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723774; cv=none; b=Hj3MxMrCdCLU160TxhZ2H1OqvPkHiahyNHzQURLD9wZAieFuicbyEWtyWYSLsGs8wosTCThM4vtPcSK+gK45dKvDcZpD8GKhS++iKLOWubb6uXUFrXY/KJ++SYDA/LXIc02XvaisnN90k6Qrb3rzRwXe1HLl3XgscyASWSE+BvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723774; c=relaxed/simple;
	bh=ro+sOnBvLDHRbfi78dhOX4EHZIAZUCGDHP43waHZGJw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=pBK9vlZBXgIgYJ4F6wqVjdxqDo5dEBWdENwE9+9NtvHuUrepV15s14MGOFb4P0s+9k2EOExDycHHzYR/innVakFOfwv9RA+hOU+l0kZUz9cwFKnwFEQE88JxBd93wowVvZ1uBC5gdR6POMGeU8ihf2JlfSvALiQ1Kl2pzSdprQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ho6iRtCJ; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6e9e1a52b74so1179207a34.0;
        Tue, 09 Apr 2024 21:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712723772; x=1713328572; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ro+sOnBvLDHRbfi78dhOX4EHZIAZUCGDHP43waHZGJw=;
        b=ho6iRtCJWdXjcvEQHD6NgiRbL1chhYlGZ/Ma/KwpieqT726gsuET8kGrXyyLv51b9T
         ohKRAQtT2FAd8vTak+wRGZVv4FP5WTTl/f6b9I7HuQ96C0PtygdJdVDxgPmy0+qs17wm
         sqX7TULkY7wahfZGbMOkwCYH+CDp+AP4V44pkf6XXrCQpZXRHSMhMIXPqA8F3xOI+vA/
         yC5J88YnfzUmuYHUtf4Uo0iaM2kVVPYrYnrIb3Nw3XCrV5nI7KdMFB23QVGw5lykK+a0
         wNs11i346rG6hJDO7H9EiLZM6yyr/4N41ILTf/USE3xlaLUb+6m67lkmOfbDVe+FDPMw
         p2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712723772; x=1713328572;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ro+sOnBvLDHRbfi78dhOX4EHZIAZUCGDHP43waHZGJw=;
        b=aKaxK0+62iGmSBlRvrofi6fqN+KGKfyPC4mgBvOtxoZmWeVUWra1EWTLFwu+mYwNxe
         XDPXgcXpNJB1TaSU25xAVlU4tzbBlBMBYcdFi4cE08udVCOkIDb2OMGesqIz4p6Yq3Jz
         D7u82C7cAramkVFL2JCaR0qxxlsrYWwpPSfDUFQLyeageVki8Dl0PTY2he9TZL6mr923
         sSvhNLTPALYpQXMYv8bi2O8NPaGQRtASUkPnJmBP9FF5usUEq+6Wl/n1xplVMCpDCjI9
         MPGHhVSVmYDCHDHSoP+8338dx5e1B2nFF6v5uVL0hMlkPjh1FdI6zjmnJYj/BcHX5hQG
         pDzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpjT+sDldyPS500GUPOpsqzd8HGRy4DDMSU1UUcNV+L+szKP3Sp5Ht70ZP6XNEoJV/6c08URN/UhpKs9Eyxc1gGOY6jOiSUt4c2saLR2+URkGXum1qIekAO/OYJ+4Lrw==
X-Gm-Message-State: AOJu0YyQtTVihucqjx71I875OhoJr+SFKBgd/tQXMmBT3KH1N1Nh9Dis
	hb5HE7C7+yGMlAnDNpGLzE5RbYwPo3+QX+uj+aHWVqMBkDR7xHlS
X-Google-Smtp-Source: AGHT+IGhSPXm27dnXVfgSG625LDcyRQ8nYRBSxzxIChAtMwkU71eYgb0mZ/xOFtDqSbVqRYzQurG2g==
X-Received: by 2002:aca:1309:0:b0:3c5:e551:2770 with SMTP id e9-20020aca1309000000b003c5e5512770mr1407949oii.31.1712723772303;
        Tue, 09 Apr 2024 21:36:12 -0700 (PDT)
Received: from localhost ([1.146.50.27])
        by smtp.gmail.com with ESMTPSA id z6-20020aa79e46000000b006ed059cdf02sm8245522pfq.116.2024.04.09.21.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 21:36:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Apr 2024 14:34:56 +1000
Message-Id: <D0G5VO2EJDMG.3Q6W17DPX6L86@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Fix is_pv check in run script
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linux-s390@vger.kernel.org>,
 <kvm@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240406122456.405139-1-npiggin@gmail.com>
 <20240406122456.405139-3-npiggin@gmail.com>
 <d7832c46-4542-477d-b746-7d7132d29dcb@linux.ibm.com>
In-Reply-To: <d7832c46-4542-477d-b746-7d7132d29dcb@linux.ibm.com>

On Mon Apr 8, 2024 at 9:46 PM AEST, Janosch Frank wrote:
> On 4/6/24 14:24, Nicholas Piggin wrote:
> > Shellcheck reports "is_pv references arguments, but none are ever
> > passed." and suggests "use is_pv "$@" if function's $1 should mean
> > script's $1."
> >=20
> > The is_pv test does not evaluate to true for .pv.bin file names, only
> > for _PV suffix test names. The arch_cmd_s390x() function appends
> > .pv.bin to the file name AND _PV to the test name, so this does not
> > affect run_tests.sh runs, but it might prevent PV tests from being
> > run directly with the s390x-run command.
> >=20
>
> The only thing that changes with this patch is that we get the error=20
> message from s390x/run and not from QEMU which complains about the=20
> unpack facility (needed for PV) not being available (because TCG does=20
> not implement it).
> And that's likely why we never ran into any problems.

Yeah it did look relatively minor. Thanks for taking a look.

Thanks,
Nick

>
>
> Patch looks fine to me:
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


