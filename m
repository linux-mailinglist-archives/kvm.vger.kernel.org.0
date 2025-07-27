Return-Path: <kvm+bounces-53521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B31B1313A
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65E767A7BD9
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A84222578;
	Sun, 27 Jul 2025 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZtZUQDbV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035FA2E36E6
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753641348; cv=none; b=jMeRDGpqtdvu2S4jffzlTuCtPywwAzSd9oer4KkHZyYbPPN2JDJV87qQDKRljuG3hTlsOK/uvQWcIMlMtQ5dyubpNgvwcC5AEKovRFUWodhWL5/zuit5SKZBd+BfDqFNTMp8wrpMBOo/m8+krr9ENDSId60HyBNa2/lnxpoDNvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753641348; c=relaxed/simple;
	bh=lRWebuCHfhC3EA9F8aR9Uy1nviB0RDQp6XGjfycJLQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpsCqdAnlqQUJsINWeUNLyNPqwaRQuG/yO5hXMZ8R6yUswEj5Let+UmjvUbMC9HHrRvrlsOLuNTfgYS8kIWdwIwlHOzLakeEPX2VhsjrFTVyHxbvztEupywqCq24p7svw8PQHCybNpilRZYaSbKqnGWXu0P1PVHtkMxG/u79KJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZtZUQDbV; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so76725e9.1
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753641345; x=1754246145; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EI5bz2yIGc/UhL5Tct7RuGWJMjZkcGUlgq3IqRTP+YI=;
        b=ZtZUQDbVHpoYL6zDEaaGJ8VNQtxoA4o5B/nM9eng5/UxSJ4opla7ZgCftb8rhrfbTr
         Y+EHU7yAD2fP4T29LbbT//zTHUAAxZZbdDF1jlTxogS0GmS1MlGhgd4BML6lKgr3FmbT
         JcIjwrtiSQIKUzoWwMgmF1gO0nUAj7YoHN4NRWhH8ryu6M6ttbV2Y5ni13YuZN2xd2GZ
         dlrb8jt7eYyZfxjqB9xQNWHWiGK3lNW2/g5xr2lSwfAm4lUJOyv97ME8wbxCM//e6Fpn
         uM/jh2lMpBqnEeZ44TM0Or+D5lD/lHjbbSgZn4/PtIl0hdpJSv5XOmJabCrit9KQIAlt
         eiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753641345; x=1754246145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EI5bz2yIGc/UhL5Tct7RuGWJMjZkcGUlgq3IqRTP+YI=;
        b=YV53rNAWyEJl0G2r99j0XYpKcHGd45n+A3MepstMqD+2uFZJX/lszFAW2Y7deBkJ7g
         gG99TbpUW276ZozMGIiz0Vt6SQvvpTrxzV5ftxzt7lwABIH3fDEztsh/8EBnT+4mFYA0
         ixOQoEva6QKvTpn8BG5M0AWGHsV5PsFchbtfxr3tLRH/5djAmbIwNC8GYSMPbXf+I0qa
         TKFPKOLipjOM8q4hVwXfMlMCbrUJVXXvxfGSQz0jKVctKG4hJnFumCvbyX34vB5TVttG
         fd0ttDSgznVwKlDYy6vnrwvev1x9T7Zr/DzGP2W8ILJIrTq0fM0c/cML5t/CTetA/Try
         qLVg==
X-Gm-Message-State: AOJu0YzILrCrVvN+hGn/0dttXzt41Ae3Ovn7RMvoHyqKwN6HSNwKuft/
	GCFoxJoEe287RIMAW6Rg7JYzHWeA8z6hLM7pnyowBtqUNekF+EaRo2Tc8SHcFRNOkw==
X-Gm-Gg: ASbGncu6zu5VVH74i/BtAETJrDefiWLLrEKy1sOR4uZqVuqxy3G5cbyjeBA5u1TngE0
	2ON7VLCw4Z/1XZwqMwcxQJXr6JETdKScS8Ml+wklY8AkHLRIkwGrWPYDbzWD6K99q6dWGRbvYLZ
	nxuw5lec6yXaZXj/7NIyf/4Sec/6Jbck3k9mgOrAjazi8GdR8GNAj1NAZFTeyVM9sBIGtJ/z1qJ
	lKEFrPigw2XAG8z/vr86cEhzIQbXhe0QUQCPgfpN3LFwt1vNLyWW1zekBrPHo0QpFknH6a89m2U
	6mYosfPjcjFAbh5dK/cO7J7hyGgbvZKnvbthXGkNWcvp1mCikd+O05ihUGBAXvfCSQr//RTs0by
	IVlLhOrLa3kuVjVL3UVX/NskbQGBrtpOUN1UsME8Z1/a/TU15lUDtsqtjoUi2
X-Google-Smtp-Source: AGHT+IEwdCqvwV1W+vmtv77dGZartws8GGzZUIWfwbByvObdHBKz7gleUmwn8efRAjd4l29AUulDUQ==
X-Received: by 2002:a05:600c:3ba2:b0:456:e94:466c with SMTP id 5b1f17b1804b1-4587c99264emr2418315e9.3.1753641345057;
        Sun, 27 Jul 2025 11:35:45 -0700 (PDT)
Received: from google.com (232.38.195.35.bc.googleusercontent.com. [35.195.38.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778eba2f1sm6421471f8f.28.2025.07.27.11.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:35:44 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:35:42 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 10/10] util/update_headers: Add vfio related
 header files to update list
Message-ID: <aIZxfojT5mFhZ8OE@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-10-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525074917.150332-10-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:16PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  util/update_headers.sh | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/util/update_headers.sh b/util/update_headers.sh
> index 789e2a42b280..8dd0dd7a9de0 100755
> --- a/util/update_headers.sh
> +++ b/util/update_headers.sh
> @@ -35,6 +35,13 @@ do
>  	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
>  done
>  
> +
> +VFIO_LIST="vfio.h iommufd.h"
> +for header in $VFIO_LIST
> +do
> +	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
> +done
> +
>  unset KVMTOOL_PATH
>  
>  copy_optional_arch () {
> -- 
> 2.43.0
> 

