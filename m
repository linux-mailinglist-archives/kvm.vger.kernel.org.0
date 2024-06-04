Return-Path: <kvm+bounces-18711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8971B8FA96D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 06:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F5C7B25FAC
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 04:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F249713D516;
	Tue,  4 Jun 2024 04:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vp2lWNtS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DC928F1;
	Tue,  4 Jun 2024 04:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717476619; cv=none; b=C1Blxt6+HrdYRI1iPPyUS1VOLyzYKkd2/ZpT72louXmiszZmZOwzFs8fzqFOYJMb4pnuEckHE5Tbh1PR38NMAC2JyuSB7o9CVwdUA91yTzMyvU/N7QNH6dwOgQVFMifM4e0XIAnSsqGWqqVNaaBgUToXUOJkRiPZzuEljHYzrKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717476619; c=relaxed/simple;
	bh=DudRRgoEa5jHJRY3IN/CW9D5ii+dbxYVCVLrA1F/ib8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ifJ+N4p+GJlhPNraWpYiCGOowK8me/yujzPLWZ0DFd9qznw4/EhzO33d0+Zc/0cYKkum2ThQEZ0iiiViiX86mR3ubNQ6N6D3pzgplLS6BsB3q1ITsuJBKh1R5/j9BOGREgpgVCknKpvoKq/xMCpOee5D3hrqjdwWJpi5pRYbTyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vp2lWNtS; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-702447766fdso4109423b3a.1;
        Mon, 03 Jun 2024 21:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717476617; x=1718081417; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+F7nF+doqarEoPywuAW2Gy7h9rHleKMNJkteWHh22os=;
        b=Vp2lWNtSYCiFlltKz80X3DoJnrH3Fkt5gysHe3uzsbydhdBS/fQmwInZqufw8vy4mM
         PFCk87zKe7vuH2jLfd5jZ3WNbYnvdwfr5j3lkdZaADijwV6GoQC6bMLob9W4gludUqg5
         fQznXHYFWk4xTWjqrIda4j0+YtsVZTCt0+SGyWN9MQC3odSJf7xDkQl91FWNLymvrV5B
         RfpG5exdbr4oSgeuqvvjsePGUCP2cSAq07te3b/7E6P8UEZC/BYUiGcJr9z110FAx18n
         xWvuXppCFWWzls8Y5hK7ZKgCqKxJoDGF9SWHcSTi+VxmmObPpq+dfk95i64ZgjFpZkrH
         JVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717476617; x=1718081417;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+F7nF+doqarEoPywuAW2Gy7h9rHleKMNJkteWHh22os=;
        b=GeQ8IKF3VtC3ojeLn5TUowJwSKkMFo+6hPV7758/RTtwmWtEFPcxGvV7UleY9a8E3X
         vwJlDE4V7JtDOl6v8UC6W5BQFCfqysFyNHkuJIv2yXPgBFYm/b5ZkqjXt1v2FOYaaEFH
         d+gdgRKsbwm5u/I3iB+nvIak1aDOhzPf277rcSHMXaNPBWqvLGB85AM5kIqP7m49M7E7
         nsEp2YDvst9k8jerS1aNWx1LwBeTj2nbCfvZl5o3nhrqVe6uETOncGqy1QmvcI+nchYN
         4CUtlmmGXOwpQI24H5gO1pUqhUSVBNu5jCXOVSmZA5Vnk7eMqr7pzd9rr95CI1RzTwYg
         suuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEgv8i9JZ/WCGrTSo3JqVeAmd4SFO5Giz4PMoJSGsEjGBKQzsJgzCl7MFuvMiG5l1gWcYZELMcsy3CPqnLxLOdaABQFB6i3Yu0JHwajXyyzeP4DxXNu8mFrAbr02dWQQ==
X-Gm-Message-State: AOJu0Yxn19/RYhzxV01cNjlbNmu/xGQSzFjMn4ylMrYxrZ4C6Y+Mq/pH
	UEz1C+ah3EbJUs2cYBUy5PlTP3wxdvxYQT7JHK7ikZJ7GbbfoQSf1bO/zQ==
X-Google-Smtp-Source: AGHT+IGxVvJ2CSSKYh/WvReNMuJdAPJ7oNeNW1yNouCBe7KpzIvIXtl2khNyBS0BJVOf8JHCQ7e1mg==
X-Received: by 2002:a05:6a20:5a81:b0:1af:7180:494f with SMTP id adf61e73a8af0-1b26f2cc183mr9715496637.41.1717476616956;
        Mon, 03 Jun 2024 21:50:16 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70255bf1f29sm4536615b3a.94.2024.06.03.21.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 21:50:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 14:50:06 +1000
Message-Id: <D1QYN902JX0V.2DJE0WMU5DRFK@gmail.com>
Cc: "Janosch Frank" <frankja@linux.ibm.com>, <linux-s390@vger.kernel.org>,
 "Claudio Imbrenda" <imbrenda@linux.ibm.com>, "Marc Hartmayer"
 <mhartmay@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/s390x: Fix the execution of the
 PV tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240603075944.150445-1-thuth@redhat.com>
In-Reply-To: <20240603075944.150445-1-thuth@redhat.com>

On Mon Jun 3, 2024 at 5:59 PM AEST, Thomas Huth wrote:
> Commit ccb37496 ("scripts: allow machine option to be specified in
> unittests.cfg") added an additonal parameter (the "machine"), but
> we forgot to add it to the spot that runs the PV test cases, so
> those are currently broken without this fix.

Thanks, this is the one you already found? Looks good to me.

Thanks,
Nick

>
> Fixes: ccb37496 ("scripts: allow machine option to be specified in unitte=
sts.cfg")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  scripts/s390x/func.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index 6b817727..f04e8e2a 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -35,5 +35,5 @@ function arch_cmd_s390x()
>  		print_result 'SKIP' $testname '' 'PVM image was not created'
>  		return 2
>  	fi
> -	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$chec=
k" "$accel" "$timeout"
> +	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$mach=
ine" "$check" "$accel" "$timeout"
>  }


