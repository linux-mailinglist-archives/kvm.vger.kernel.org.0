Return-Path: <kvm+bounces-18342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C13908D412A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1BE91C21028
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 22:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED9C1CB313;
	Wed, 29 May 2024 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gsCkJM17"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB431C68B4
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717020638; cv=none; b=EOrvxxM4Zs6TQqDiZXBoSRW0tvnIhWWHC+f4Jdi+RT6b3vrfkZdrONyJg63hxSsxvHwt4mL6yKIgnSCqz2NAk3+isFaFp9+XdEEbXv1SmkMoTJKNUwZ3OvWVSW6qPCdRaA4pFlJYsgZFzZKdhKwaIHlEi91yt2R5DFwB0BKS1X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717020638; c=relaxed/simple;
	bh=QuEnVBRxaxmVOCS92xgH+2N6PGcTBUbaO5iCtxsNXWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eton2d1TSO02/WejdqBSmuGhH9vBmkeWrdtajE//HfvJ75aM2tVJQrUB+dR8pdoZk0iYj84VN7p6C/kSj3vzxMQm5JqIA0gxTaqvc4g/PCbmg1cbcQ/2/nM4vJUjLAm1kkgHWVb83BzRWKYl5ljPopTqlTG7dtwdvu6snM1jT+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gsCkJM17; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6c023a9cf19so12415a12.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717020635; x=1717625435; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e+fbNuxAx3WZmFzqMqAqWViMBWTStqdh1s3mW/5wrdE=;
        b=gsCkJM17dTeR4HLzJEl1hY3G4Za79ziIIH9UDG0/LTJieq+lvLhOtnNKJhKYNVCAoX
         ya/Xgpiu645VexBKar/ZqGQbwo7M1+mCTxGepOjY7tE9Gt3ZSp9DIQMTy6mdukjh+SII
         I2IWVHJOmVRVBsQ1IbwAPPdFGuN9STcC5lB1l/3iyjYazazpG0Eb6MSUbbO9B3yGLcAz
         M3ImXgAFaH3bZhKSGj0VTPrnTGwozCRQolbkyu6WxNWHiB0dKeeAh0kDGQsDWf/5rfYY
         P0u7PdpjYgrdne0pUVWdOAuFPBszSt0LIuv7yURgTfCfWmxes1JZfH8TYxtweZpmPqHE
         lCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717020635; x=1717625435;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+fbNuxAx3WZmFzqMqAqWViMBWTStqdh1s3mW/5wrdE=;
        b=KXhF7IJz4+lDgI0556q+ZgMZzw8CXJTBsdo8k+popW9IeHXL9KKsV1ghWeyTJ8SxSa
         lJHKeso6AP1LyUUdJMtHs/bo8z7bFP4jHsL2Mmuhu4xgYr3MpBxW0bK8aLDaWK4UU3mT
         vlOVNTMS0R0lCSc7wMbZ3v1KzfmYhtq1OAEYwfl+crBvB0TzoY3yq5ciGB0I25gD0Hx6
         UehWNCoLvtCVVH/OwSwAANY5KjbxWZ+4g+hQNygUjX5VG6u5F2IGpFc+PXNOgxna+pav
         lm99MvhmzC0LgQr6tGjZbRpukXHAImcdWy/4guxQrfbljwtlLJbihrgzckNQ8NHbL7pr
         GTUA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ3LU+fRHX2EstvRn6ZDGNVgpwgMuwpGC1E0Mp3GnmNAIHb+NKPKi6t0Z++Lr9PjAQMiLEbe/85sFHehtoGUiJG/u+
X-Gm-Message-State: AOJu0YzZJsnxgKisTxAAe/zoXoJOHuE+CJulbi/YubUOEPQhwuZNoPpd
	xbCrbDciRlFI+iyeOW8MY5MtbxWXEaCp2B8tKGdeHaqrkHPSZwHLJNBFaDV4vxo=
X-Google-Smtp-Source: AGHT+IGB2IuW8qeBair3I30nTxYXl3h2Wp+x/ksnoaod2z/+/aYYn9Gy8Js/qgGb7n5+xXapJsQdmQ==
X-Received: by 2002:a17:90a:c798:b0:2ae:7f27:82cd with SMTP id 98e67ed59e1d1-2c1ab9e39a3mr414491a91.7.1717020635249;
        Wed, 29 May 2024 15:10:35 -0700 (PDT)
Received: from ghost ([2601:647:5700:6860:32f9:8d5b:110a:1952])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1abebfbdbsm121966a91.55.2024.05.29.15.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 15:10:34 -0700 (PDT)
Date: Wed, 29 May 2024 15:10:32 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 01/16] dt-bindings: riscv: add Zimop ISA extension
 description
Message-ID: <Zlen2LmttEdaqAGm@ghost>
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240517145302.971019-2-cleger@rivosinc.com>

On Fri, May 17, 2024 at 04:52:41PM +0200, Clément Léger wrote:
> Add description for the Zimop (May-Be-Operations) ISA extension which
> was ratified in commit 58220614a5f of the riscv-isa-manual.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index 99d2a9e8c52d..b9100addeb90 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -363,6 +363,11 @@ properties:
>              ratified in the 20191213 version of the unprivileged ISA
>              specification.
>  
> +        - const: zimop
> +          description:
> +            The standard Zimop extension version 1.0, as ratified in commit
> +            58220614a5f ("Zimop is ratified/1.0") of the riscv-isa-manual.
> +
>          - const: ztso
>            description:
>              The standard Ztso extension for total store ordering, as ratified
> -- 
> 2.43.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>


