Return-Path: <kvm+bounces-11641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E18878EDD
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 07:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE7D41C209F8
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E9844384;
	Tue, 12 Mar 2024 06:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G200Sqp8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4443842A9E;
	Tue, 12 Mar 2024 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710225468; cv=none; b=etWp3Sr2oYiNj7A58SMXY5YrwdT+4xAqXbBOd+lt55sGMd5b2J13wKW5XQxBdqB8fU/0YPPkbzc/X7iuk+WSQ20IU/QnPA/u9veAJx7eM8TuPqCD9gbZg7tOsUn7OTo2GRHDcbcX6hTDhrFaEA2EA4EbhYPqNM0CTYMGLF4xbCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710225468; c=relaxed/simple;
	bh=v2KrkrpftKfDPO9+UcSDU+qSXkPFeilZEEHJ9NvpPnc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=lgs59EpR0jAAynuw0EnkCLijg4uZ1ACrc8Mw3Pne41tDVn/0+rt+9t5i5DoS2sx0xM/BhfHpA4o0hJaUoYefyVvxbSYkKl3fpDUfoHcDgxRDvF+3qi9vkBnwqhcLgzrAPX2pMkgcP4FXAqyvFUB9a1PdNGv1PRCjxSNVSDiHWiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G200Sqp8; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5a1d83a86e8so1308392eaf.0;
        Mon, 11 Mar 2024 23:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710225466; x=1710830266; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=luI7dyoDpScCKQdzlFl2LDpghDSrS4DAvqerJztMkMU=;
        b=G200Sqp8+suV7siWe5tqLQTk7r0RLGLvM7Fkta/hfsn+s0OkTX5y7xOa3p3OW+Cngq
         3eGlblHhzdCjzYiHywXRdEtSwQ2c8yFPMf3PfCW6IoDuvvr2rXl/w47pdyqYV5ZJJdPF
         XbXpPUr0Ntp0bpLPXVVn7rBMoj98kAWQBcd13+HQx48RqjZNj5YMiIg2Ioqy/RyeQvZJ
         XUptsKgFmFxnSAow3Nl2aJQB9saeT8eshLWB2iqvmQCrjYs7Av4y+OExTf40kW2Csjue
         Wo2MQkj8CIjDyDy4AeElc0sNoIvGNrRj4t7Xz78gEwU+tc3McqJDrMlP6nbeB4mvkN+M
         NIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710225466; x=1710830266;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=luI7dyoDpScCKQdzlFl2LDpghDSrS4DAvqerJztMkMU=;
        b=iNWuLIUxyUQ3yqt1EQSGgWH4m4qIp3yrB6C90/x/wxc1DXD+FxHzED2dEef0lTaXZu
         cnT/8s4Mg9eI2WZmoB1LoHn46IG4VND3YWemN4Pzc6seFcmcogjzZUIXFMkPURtag9OE
         DB4E7AJzXHySFuvuWNNn8dFrGC+BDJam2OLkMv1nF2NLBGJsQ5AL/iKFndpiip8pkhc+
         A2Fc9PNjZVxTC/zyI21RPKwRrJfEA8dJF9JswlXOOj3tiRRd7IU5u2IewY44TadlrZxj
         wCVsh+vkRsPgEFukfyb5EbQPwxPytR3sfvBn8i33DGZ2u8ZvrDSJ7vhDWiolzzp0UY+N
         vSaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMnHnYIHFQniJJR8ombw0F8+WUSRolSi1SoYb0p2i57C9/0Qk4iXjh85RHyndOBxbRTkk1zXd5pX3QDLWiZUtR2laa0l1C78Z/rg==
X-Gm-Message-State: AOJu0YySjExJ8CD5+9UgcITcux05t6hHvNqD0+dO7h1lnGv2V3OMZd1L
	Q2vmJg/HqIcBLICD/le6uc9L58RafOA1tsrJyTQUdhU/LwCQV8s6Rr2bcixbcnc=
X-Google-Smtp-Source: AGHT+IFVxETw5yA+xhiUiVW4kNrWB0lfhCjyGbdV9L3yVWw/DJDJ8cWKsOVsgwz9/e5JN8pKprif5A==
X-Received: by 2002:a05:6358:418b:b0:17e:7b0c:c5ef with SMTP id w11-20020a056358418b00b0017e7b0cc5efmr1328865rwc.28.1710225466195;
        Mon, 11 Mar 2024 23:37:46 -0700 (PDT)
Received: from localhost ([1.146.55.44])
        by smtp.gmail.com with ESMTPSA id q19-20020a656253000000b005d553239b16sm4648686pgv.20.2024.03.11.23.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 23:37:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Mar 2024 16:37:39 +1000
Message-Id: <CZRKBTZFFB9Y.38GVXEXZPOVK5@wheely>
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: Wait for incoming socket
 being removed
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nico Boehr" <nrb@linux.ibm.com>, <frankja@linux.ibm.com>,
 <imbrenda@linux.ibm.com>, <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20240305141214.707046-1-nrb@linux.ibm.com>
In-Reply-To: <20240305141214.707046-1-nrb@linux.ibm.com>

On Wed Mar 6, 2024 at 12:11 AM AEST, Nico Boehr wrote:
> Sometimes, QEMU needs a bit longer to remove the incoming migration
> socket. This happens in some environments on s390x for the
> migration-skey-sequential test.
>
> Instead of directly erroring out, wait for the removal of the socket.
>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

It's interesting that the incoming socket is not removed after
QMP says migration complete. I guess that's by design, but have
you checked the QEMU code whether it's intentional?

I guess it's code like this - in migration/migration.c

    /*
     * This must happen after any state changes since as soon as an externa=
l
     * observer sees this event they might start to prod at the VM assuming
     * it's ready to use.
     */
    migrate_set_state(&mis->state, MIGRATION_STATUS_ACTIVE,
                      MIGRATION_STATUS_COMPLETED);
    migration_incoming_state_destroy();

So, it looks like a good fix. And probably not just s390x specific
it might be just unlucky timing.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  scripts/arch-run.bash | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 2214d940cf7d..413f3eda8cb8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -237,12 +237,8 @@ do_migration ()
>  	echo > ${dst_infifo}
>  	rm ${dst_infifo}
> =20
> -	# Ensure the incoming socket is removed, ready for next destination
> -	if [ -S ${dst_incoming} ] ; then
> -		echo "ERROR: Incoming migration socket not removed after migration." >=
& 2
> -		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
> -		return 2
> -	fi
> +	# Wait for the incoming socket being removed, ready for next destinatio=
n
> +	while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
> =20
>  	wait ${live_pid}
>  	ret=3D$?


