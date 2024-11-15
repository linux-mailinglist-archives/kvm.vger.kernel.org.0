Return-Path: <kvm+bounces-31945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8C19CF2DC
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F27F7B35007
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 16:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31211D5AC9;
	Fri, 15 Nov 2024 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ASBh0v9U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A212847C
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689953; cv=none; b=GeicHy/3j4HM3+2PRUKTb0ZL13vkeetOhl9J4C1VF2NF3MxpVZO8rIYZyiNYlJyd9iI9HfFzVc7q896vVomZ/J02aqguzFvYxITCpfFQ6fJ4dWnwqAokTrwiMaSQEd8sOMuSlHbZnyrq67prp+j41g3yfKus9GURK7/ed0NcKZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689953; c=relaxed/simple;
	bh=yHOMbE84YtfH5uC+q9caQcOf+DY/ybChcSTqNATeIQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YycABBCchOhrmSQgrv5EWn6jCXhia6qlzr9du7Mll9e5MkO5mAAD1mRoIj9/FVaZsghI504nYH5bh27jUgjNElkyKUdK/1iZd+GupkLhpWDUhq7X/mjxr1um5zeWKB0Yy0DKMSjUPDPqPy0Pxa7tfQiWsZabwQ4TydWUy46xVNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ASBh0v9U; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so9052341fa.3
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 08:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731689949; x=1732294749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aTgs6TZBBW/K4G459g2+GAIO1jZq9pvrwSvsxsKJTe4=;
        b=ASBh0v9UWDqMVQxXlFERHecAM7vBX+dj3m5xV58SP2fio8ApBsoJR8WD9qb9hAxKhU
         AUfagJ/11h6GUQgFPobS7gAk9QKSwmhTQ6PtjW17x8+2VPpamFRqAFxAYW500ROCbzIQ
         L00v+34jw8PBjga9d2H7fvo0FgPs3pZBBCxNWwlZOPwLAeyAtbSV2gllGF/ZhJWGNsuB
         fJDC4+XF54btSV3paPrwgRRF3fu7Rtps0fwg7sZ+E8dHS+5nP0rzaT1m90+Kde1wFqlv
         6MCOBmCRadI3EcGy5vQpC2iHHVG5jMNwMyPNh9KBrzkamLRsOiRq2eqfDP3QNu/YIusm
         OUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689949; x=1732294749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTgs6TZBBW/K4G459g2+GAIO1jZq9pvrwSvsxsKJTe4=;
        b=HtkiLW9NNhiVupeAYnaqegsSnHrIRiEBPeY+IosDI37IenpK44kjA9v3iuk9/ilP50
         7H/5d3+Dx6tos+fWI5aQUZ+EyQn0HP+x8f0jjrPgYYLWgktWofJDEKBOeKR/np3uVenI
         34eqQfSsj3/PS4tdnEylbdZeraYgc0mZGH3xSNq3+J10byqtWy/70hpbYkZ9oMkjcMMp
         ZJtOnX7quOaXJaTCTfgqjEscG1g9O5IbcUJjZ05xKDYnEJoKBFyX1H90dZPJca8t/CG4
         rTiSYutaSu2HYD0/oEYWIYZ4O85TDLLgTBnOEYmelvZv4TxNBSIEB/Xe42ULUSof8vo2
         H1AQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgT64OMxPS9h4w2cdkda7O5T6wPBwu6IP4xPM34Siq+KNDZ+I7QaNc8i1qHFr2O2krW/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV/FjunUrgkw5H4KUPFkVi1BvLkhGDmhhcpNv4kAsmA07ZQtKw
	B+snmuDx2kmbmD9IayTNFYw12oV4vINmirEKMs6WLg/J1c/bjtxg3aeiMxedPBc=
X-Google-Smtp-Source: AGHT+IGtHvkZQxyNHW5vvtvrdH78obaDRIKxfmQKkuiMNoCQMJrT7GFgCHyX+vc9p/jfB9gLvRH6IA==
X-Received: by 2002:a05:651c:90b:b0:2fe:e44d:6162 with SMTP id 38308e7fff4ca-2ff6070e052mr22040961fa.26.1731689949282;
        Fri, 15 Nov 2024 08:59:09 -0800 (PST)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da298a41sm63691485e9.38.2024.11.15.08.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:59:08 -0800 (PST)
Date: Fri, 15 Nov 2024 17:59:07 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <rl5s5eykuzs4dgp23vpbagb4lntyl3uptwh54jzjjgfydynqvx@6xbbcjvb7zpn>
References: <20241108130737.126567-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d2tiinorxtz5cpzu"
Content-Disposition: inline
In-Reply-To: <20241108130737.126567-1-pbonzini@redhat.com>


--d2tiinorxtz5cpzu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 08, 2024 at 08:07:37AM GMT, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Since the worker kthread is tied to a user process, it's better if
> it behaves similarly to user tasks as much as possible, including
> being able to send SIGSTOP and SIGCONT.

Do you mean s/send/receive/?

Consequently, it's OK if a (possibly unprivileged) user stops this
thread forever (they only harm themselves, not the rest of the system),
correct?


> In fact, vhost_task is all that kvm_vm_create_worker_thread() wanted
> to be and more: not only it inherits the userspace process's cgroups,
> it has other niceties like being parented properly in the process
> tree.  Use it instead of the homegrown alternative.

It is nice indeed.
I think the bugs we saw are not so serious to warrant
Fixes: c57c80467f90e ("kvm: Add helper function for creating VM worker threads")
.
(But I'm posting it here so that I can find the reference later.)

Thanks,
Michal

--d2tiinorxtz5cpzu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZzd92AAKCRAt3Wney77B
SWFPAP9dPqCzcXL6RlNlluM/CfPHLz5sv1Jmpn502SqVOAetLwEAlNXghQXLJed+
v8hEXumZRnfpYF2VtL9rRKeMOx60Tw0=
=UK3X
-----END PGP SIGNATURE-----

--d2tiinorxtz5cpzu--

