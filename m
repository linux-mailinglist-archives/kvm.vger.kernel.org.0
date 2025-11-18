Return-Path: <kvm+bounces-63438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E5857C66C0D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 76A684EAED1
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E1B944F;
	Tue, 18 Nov 2025 00:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNeuOlVs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A8280A5C
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763427296; cv=none; b=P5TAQVExossjMzSwC3DVUlAF97pdAzfRYN1RgulfWTOCfvpL6YiQdY2XGsuyaJS3FXZdDI+rIKpAanOm+RzwS+rQwiaIarZARSyH3B02x5nzPcTzNZFbQTGK3NOTkhQHyQ+IBWPggwY5cHiu8pUTUU+XnJPk4BTk9x9U1jWiJ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763427296; c=relaxed/simple;
	bh=RtC+cud8CKuADACpgXwT8XgszrmdV3Le3E1v33sHlrg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WeD+apZGV86yvGsPtpIqCJFrl4Wax40OrvU1Y0f0G8CtOp0QOqFPEzEQ6EeOwAO2SFg9ebPR1oEPSuCBB/u+x1bBBg0gvaeaKHYoKAos7nw2e3CFCMoEDJILx1uZgBtYJ9bwtVgZlyLKicvnBB/52xLVA0TIZqpWbVXProqhQVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNeuOlVs; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b31c610fcso4314003f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 16:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763427292; x=1764032092; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPTc4MhdbyP296mRQoRJVw91qg1l0E7W92E7Wtz2zbA=;
        b=VNeuOlVsBV7wVhK/k8N/9lOjmyicbdTfIPewN3Mozfq8P2b2/K/C7MwhIMjwP95mst
         J8OpVLLvk25Ola2iryKrDOVwBPmyaIBjV1PZAETlyR5qmNPRwkkBywXY5x3B/FHL0y7b
         qoOol93qfrtpDBs5YLXINv3C0MMxjXtZMZgtsankt9WLXQ0XdcZBurjkFGpOfuhWiTkq
         xHVEAmHly29shwpmazHg0eMnaELtFv07g6BN2R4dAN0UJfz82qiRb5AGgEv4Z7OmL0sU
         62syDHZbUYZjQ4s+w0WLnhLzSyZ7RAtGpvtV50ZYTw8jCpY6lnodjkTscWAn3JtIgqap
         GACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763427292; x=1764032092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HPTc4MhdbyP296mRQoRJVw91qg1l0E7W92E7Wtz2zbA=;
        b=JhN9vrJi6YBk0OodNBkvCHafFtfWbL3ord72eJ+VIm8ZVkm6hHWsb2r3ybILlhteUK
         LVXqJGVt8sZkJbT6YNdidMlBPIjnhShfvt2tpJC3y4DK4aMRDjJNLOUCCfJbe0w9vz1z
         N+daLnuPcg/EVi/bq10VtF9MmfQ60Tpid4Vn3U6h3fM6bEhAH91iCVidEzqgbol+dZAD
         19XYPOX5VQptFCFMQ1vmrkxqliaq/X9GTLFNkqzCHSTFfWc2lu5xEMEIbosh62Q49k/z
         5lpc/dB8te915v1vnJsdj7Tk4asiSGcU3gxD+vKPlhmScT4K5LG6HtLRMDqaduE0KrSs
         m6ZA==
X-Gm-Message-State: AOJu0Yz9eBDXJtZYv0Kf6k2S+YIEjBIW7U0dWGxqqyt2FWaDCFomCFWS
	lMt59Agu4/NLKFkwPQvdxi2JKoHXoc3sPRhu6PHo559wc0vpvg8vKctvV3YvPb87pN+fthhDyiJ
	tkuPlmVp3nJNxauwWFAu8jWDSLQ7tm5pLRuo2w2Xe3j8zZbN0WQnqfk4iavQ=
X-Gm-Gg: ASbGncuD804StGWeAIypw2J1/F+82IYYx7hAR9bJ4lqVLNFLINZNZCqBu0z2M7aPmrG
	x7XoqODJ57lZyIaICfmshOG10mcRc53Ojx16AkLAPNd84h/np2YEav2rZfVcyssm/Vq8KoD1rxx
	NdlIC/VBDYxxbn03UHXeayEG4+hmpLMBdEMakNWBJT3LpEDBKCJkk2Ee0e4mknwgRrqjJtJFuAC
	mnW0ySaHoPcJV/KBq2dHAkCf71toggue9kWvuJpMIK2xoesxfO2bo+0c37YtNvEoI1DspHs76ac
	eftRmVPRKkHtT7lEvae6z9JhOcE=
X-Google-Smtp-Source: AGHT+IEbMUlSCXb80N7e8z5hJAd+Ysjb4wv7u+MOiYOiIwACPt+D+0av68csCWr8GVbZLR4ue8t1yc/iC+hrMb2CBR4=
X-Received: by 2002:a5d:5f50:0:b0:42b:300f:7d8d with SMTP id
 ffacd0b85a97d-42b593869c6mr13983674f8f.34.1763427292146; Mon, 17 Nov 2025
 16:54:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117234835.1009938-1-chengkev@google.com>
In-Reply-To: <20251117234835.1009938-1-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Mon, 17 Nov 2025 19:54:41 -0500
X-Gm-Features: AWmQ_blPw6W8UaaAjiarp-Q4xWhD7u6S0GOxLJy0gB-kxeI8k6TFchKvEtplmy4
Message-ID: <CAE6NW_ZG+M3+HcBQKuVodfteJJxU8BxwLXcPiiNAviRhf0CRGQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime.bash: Fix TIMEOUT env var override
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 6:48=E2=80=AFPM Kevin Cheng <chengkev@google.com> w=
rote:
>
> According to unittests.txt timeout deinition, the TIMEOUT environment
> variable should override the optional timeout specified in
> unittests.cfg. Fix this by defaulting the timeout in run() to the
> TIMEOUT env var, followed by the timeout in unittests.cfg, and lastly by
> the previously defined default of 90s.
> ---
>  scripts/runtime.bash | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 6805e97f90c8f..0704a390bfe1e 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,6 +1,5 @@
>  : "${RUNTIME_arch_run?}"
>  : "${MAX_SMP:=3D$(getconf _NPROCESSORS_ONLN)}"
> -: "${TIMEOUT:=3D90s}"
>
>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
>  SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
> @@ -82,7 +81,7 @@ function run()
>      local machine=3D"$8"
>      local check=3D"${CHECK:-$9}"
>      local accel=3D"${10}"
> -    local timeout=3D"${11:-$TIMEOUT}" # unittests.cfg overrides the defa=
ult
> +    local timeout=3D"${TIMEOUT:-${11:-90s}}" # TIMEOUT env var overrides=
 unittests.cfg
>      local disabled_if=3D"${12}"
>
>      if [ "${CONFIG_EFI}" =3D=3D "y" ]; then
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

Forgot to CC Sean

