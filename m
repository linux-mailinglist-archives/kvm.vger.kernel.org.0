Return-Path: <kvm+bounces-26443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CBD974771
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F6831F2693F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2CFDF42;
	Wed, 11 Sep 2024 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PmA5f2pQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB8FDF5C;
	Wed, 11 Sep 2024 00:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726015154; cv=none; b=Naodgph9jCZHv0vhQIvtmIJozGiXaoMm6oFYMEqssQuqmKYFZc2RxzYPqPKu87ibKk5es7OjrsEQC3m8lZZhe7C84UXwFVkQii1hBg1J21HzlbBifsagP07duHYuIgVjPdwwy8X03HaOlmrJarm6xFknjaYDh5aQr8cUfDvafBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726015154; c=relaxed/simple;
	bh=ZnBdl2cA4ztUKelTqdaewmKZZClVReaKhYlkQ6TOZVM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=sVyHZJW92xij/5MpevDchPQrZiVU5Fp7x0DLZLy3e2RemLrbBjYVIXE73e4I/ySv1EFUY6CLOvM0yrpjtqhrsdTcaSymyabVdyIU1tXK0eOsAZEoRWNhiM+oy4mLieiFb82yN6oXUJT6h/STkevz4Z+pqotFQr3w6o1eADOSZj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PmA5f2pQ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-717929b671eso1229605b3a.0;
        Tue, 10 Sep 2024 17:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726015152; x=1726619952; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aU2W8CjkecEHnTcSi2eLdxjM7yES0Dfnh45fYE5GR5I=;
        b=PmA5f2pQ08v5INxNTeErgGxqUwVCoHlNvVY1h4AqpbbBOh38Tdq2ygJ8RTRR8oSRk8
         GM2wSNQdNwUXh3h+7jFlBphQW+AZDjGE3e01DAxhNgqQ9jBOdeWAF2zL9SopGDrchbAR
         G8TBSomdS8Byyx+ptC/TZAyvv04HBfL2chPsDX89VdHgr9DV55b7rUC0EGWkpUrNdaH0
         FlNN7DKo9OTcHusgJNeRTM2lsQNB+6NV+vH4AevePfHeb1b/Wg1u8X50vpnvf/+xNs+Z
         DQKOLZpCgRAo9ce9BiD+4Eq8gkEjpI+5oM7vcAkN+zD15poTuuU7YE7+hNXbPoEnnKwk
         wDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726015152; x=1726619952;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aU2W8CjkecEHnTcSi2eLdxjM7yES0Dfnh45fYE5GR5I=;
        b=I9C9Caq3+mJB3TCilDF0RvxRHihIIDhDEX9NwA/wK1CB/IO1X/KQIoU4iezSHlW2nD
         6iawNhOIaYGAGlzTJMoQfRLdC7OS01SwHcWJsBF1ZfkE1fBbNpTVI3asjTviwF9kUj8Z
         7dtKUvWP/8eDiikzGEVrTi3cW5a1p8mDiZVMNfnnpEGQ6O7thxFYJCAjFlUBmnPrvsSX
         4avmcI1/ukuiQogEPTj2Iq1vHit6Uum37taGVklm/cnWWG7FEX/P3HOXJnGDT/WxYtth
         q4XA6bidkjAbe8vJIdfw1mSy5LJpMb3GX9L6xT/FkWSDAYpiXGWAkHLCB83iziEVUD+M
         EUcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtSK60CwtUOL8Eh5HwFJzxCUE1CLGqhNbDXeoDkzQQR3MQTwIVYH/znhzeO2aS+ybdB6YatL0UUxFyzA==@vger.kernel.org, AJvYcCWAku6LLH8Q/syalRhc3vEosTjZmzYfA0Yzx+hkxWB7kYz9JV9zJMrJAcooLnX7cEhQfSA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjkNMsxeuXx4eNhdiycjzEbs+rHUkDYzsuD6E5tTytmS1IWrqx
	YhfPy7xITp17XgRnLQ7xqoc7XHK0Jt1FWjpXhUoc/AMyFUAe7I5m
X-Google-Smtp-Source: AGHT+IHRKKq+mrn5RGMG8qqoe7SoGI6xTYPwCUO1y//ca3K0M+pW44jdvdBPQb4Ae3YMIwaUEIB4lw==
X-Received: by 2002:a05:6a00:21cd:b0:714:1bce:913a with SMTP id d2e1a72fcca58-7191712345fmr1713499b3a.21.1726015152432;
        Tue, 10 Sep 2024 17:39:12 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-719090b038bsm1909998b3a.152.2024.09.10.17.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:39:03 +1000
Message-Id: <D431AYECDJV3.1AVQCTIRV2J4G@gmail.com>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] configure: Introduce add-config
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.18.2
References: <20240903143946.834864-4-andrew.jones@linux.dev>
 <20240903143946.834864-5-andrew.jones@linux.dev>
In-Reply-To: <20240903143946.834864-5-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 12:39 AM AEST, Andrew Jones wrote:
> Allow users to add additional CONFIG_* and override defaults
> by concatenating a given file with #define's and #undef's to
> lib/config.h

That's a horrible config format lol, but probbaly the simplest way to
get something working. What if you included the user config first, then
make the generated config test ifndef before defining the default?

Is it better to have a config file than to just add more --options to
configure? If we had thousands of options maybe, but so far we are
getting by with configure options. I think I prefer that for now
unless we wholesale moved everything to a .config style.

Thanks,
Nick

>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  configure | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/configure b/configure
> index 27ae9cc89657..7a1317d0650d 100755
> --- a/configure
> +++ b/configure
> @@ -64,6 +64,8 @@ usage() {
>  	                           no environ is provided by the user (enabled =
by default)
>  	    --erratatxt=3DFILE       specify a file to use instead of errata.tx=
t. Use
>  	                           '--erratatxt=3D' to ensure no file is used.
> +	    --add-config=3DFILE      specify a file containing configs (CONFIG_=
*) to add on to the
> +	                           generated lib/config.h. Use #undef to overri=
de default configs.
>  	    --host-key-document=3DHOST_KEY_DOCUMENT
>  	                           Specify the machine-specific host-key docume=
nt for creating
>  	                           a PVM image with 'genprotimg' (s390x only)
> @@ -153,6 +155,10 @@ while [[ "$1" =3D -* ]]; do
>  	    erratatxt=3D
>  	    [ "$arg" ] && erratatxt=3D$(eval realpath "$arg")
>  	    ;;
> +	--add-config)
> +	    add_config=3D
> +	    [ "$arg" ] && add_config=3D$(eval realpath "$arg")
> +	    ;;
>  	--host-key-document)
>  	    host_key_document=3D"$arg"
>  	    ;;
> @@ -213,6 +219,10 @@ if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
>      echo "erratatxt: $erratatxt does not exist or is not a regular file"
>      exit 1
>  fi
> +if [ "$add_config" ] && [ ! -f "$add_config" ]; then
> +    echo "add-config: $add_config does not exist or is not a regular fil=
e"
> +    exit 1
> +fi
> =20
>  arch_name=3D$arch
>  [ "$arch" =3D "aarch64" ] && arch=3D"arm64"
> @@ -502,4 +512,8 @@ cat <<EOF >> lib/config.h
> =20
>  EOF
>  fi
> +if [ "$add_config" ]; then
> +    echo "/* Additional configs from $add_config */" >> lib/config.h
> +    cat "$add_config" >> lib/config.h
> +fi
>  echo "#endif" >> lib/config.h


