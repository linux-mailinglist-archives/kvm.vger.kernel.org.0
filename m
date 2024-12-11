Return-Path: <kvm+bounces-33500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A1049ED4C1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C31D41691B2
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D17208967;
	Wed, 11 Dec 2024 18:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYAAUtxX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDEC24632F;
	Wed, 11 Dec 2024 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733942058; cv=none; b=slIpMx71e2YjjpixnRWw2NMQZ0bOHv3jeWBbjVSGe/rpBuDnFBS1zWjj6V4KlOW8gWC2YdPxcjUMpQI7w6doEr9sWFPqNf0ytRM3B+VIwqLYIDH7oLkcHtu4rkEaohlGUiRa8pmRHL+1EQNNjKFUnCz8JoJcLwWHt4HLZRzKcE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733942058; c=relaxed/simple;
	bh=/TaoJdfvFhwTAQjfbYZdIm0Vywdm28jJi5S46WIRpCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YdBrxbxx7kHkid/jfVZWUA6WnhUAuWuN6Wzwfk7oXwA3uxD+059YyNoOzW8X4+HY3F24zjRoU6G4Avn0A0zGipanMR6dTbewYOV+RGXKffgVj1M4BYt09u9sNC4YeBLAIBoCsnwcfC8itgtjqoDL7nKYUpNk9+/KldxnDeIE0Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYAAUtxX; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-725f2f79ed9so2925137b3a.2;
        Wed, 11 Dec 2024 10:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733942056; x=1734546856; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rk/fxlEH9BCZY0Alvd/M1BO7urypX5QFhl3cqisfidI=;
        b=UYAAUtxXcQIA3XfteDCn+FUYIjx/Q5GTcAlrceQRoq9VjS1JQYn5HAyO8MTKqi2VWt
         Vo2Yx6ZV6K5kBspnrOYXc8RjnkBUqYss+u3rvf3vTPyt0oaEQLsU7DENk+eOsS+mSKWA
         CKFn1aYdZ+T6LSLz8EEau+vP+kwOOM3Y5COVQxyZF3z2IX/OlOTdVLwFhb4UcOMIUCN9
         utp+JS/DuVrO11u0Y8S9xvJ4W1EgxItCQ492UjfAz/qZrUYp62Ca4LSqNa3tdC/VQyWa
         befx4FhWp3hhLnDBrBcGAVDu5qJj3re7X1/27tI+ZI9Q31D8iZTjTv+9N/EHUIFJeUmE
         zHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733942056; x=1734546856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rk/fxlEH9BCZY0Alvd/M1BO7urypX5QFhl3cqisfidI=;
        b=dgQVhgNP4T4epY4rqz3CZQOaOVkxkkZVVPkbRtytuvEkuhaGL+Xz2EVNyzrM11cKxv
         9Sy7dFichP5yfSf4cbbtmjXiq2Mn9IXGc6h9DBo/vdq5QUVbidmhl+LJW4WiIF8qfvsK
         9zzkArNJUvgR5elH51AWyjBNGLTeKivgPXeYWRDylRyva3dM6Ur0ynAgO2yqfo4UVfft
         wNoUTUmVNXfuLzmzgUJ0DS9ayq6GkXX8g5ZAeDujmsydITNNZPIlnotIhzUHwAldZsZR
         dLb17Asj9HctHjBZboIfqPUepezsv3LJP/fAd9S7nWQ3lBRrfh9AXlLKtH59YQZq/bYz
         MXJg==
X-Forwarded-Encrypted: i=1; AJvYcCVfpVfa4lbo5/8YSNdQk+L7jr4YiJoqSLLCeb+m4byXl42ha0jMQtdfzO0/IVzCaPUaF4/II3eQ/br3XsU=@vger.kernel.org, AJvYcCVlVZNVTn2aJyX7pf5EsK6aRxEiUogIibQrfVEqsyhDGfJoLFEldMFE/BVnFfyljwbQ7Zbd+7WHNtGWRDRO@vger.kernel.org, AJvYcCWK7qRKcx93SMrVRwNdUDyIOxV0zFHwV+5Z8sOKbOPnX3iqLjvfvwES/cUSsvVJ04PQkmZAkTAT@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb1W0GORmoBwwhnU/OKrGuzk9rNbY1q1HKBEayVlZf8Y25ogWD
	n7FwbxUkz/pvmUs/F1wvOEpZTDMwnOdV4t4czRZ+MyTSpF8un798
X-Gm-Gg: ASbGnctaoTdtgix9HQIeDKeTduSs+Kp17T/XjMYrjC0D+0kh6ndF7//cIX2O+j066XU
	U/jw8sZPvL6j2SDEbjMGoPsxM7CqE5h4qGDBrcgYoips1QYIEYzJISiNUdtHhzLyoy1qOwZGITd
	GpMSDoxa/Vk3F3TafyLjsK8ayByEyCvzcZOx6fETXuJKq6wAbi9TtyBWEaTF0+RX3s/eWyvCxaW
	cx8UQNowsfXkBwAApCA474+0Te9baLtWm62y0mYSS8dIGzo//uaFQ==
X-Google-Smtp-Source: AGHT+IEH5l/T2i1ylcugW4ACfynX26ff/6uP1bdDxE3xa15KOwnDbL1Kdr+JCiIfZIOEb7i2xD8vWA==
X-Received: by 2002:a05:6a00:1256:b0:71d:f2e3:a878 with SMTP id d2e1a72fcca58-728fa9b762bmr556129b3a.5.1733942055956;
        Wed, 11 Dec 2024 10:34:15 -0800 (PST)
Received: from localhost ([216.228.125.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7282c0f5bb0sm3752892b3a.59.2024.12.11.10.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 10:34:15 -0800 (PST)
Date: Wed, 11 Dec 2024 10:34:12 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>, Long Li <longli@microsoft.com>
Subject: Re: [PATCH v2 0/2] MANA: Fix few memory leaks in mana_gd_setup_irqs
Message-ID: <Z1nbJFNwFGwE3xbN@yury-ThinkPad>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209175751.287738-1-mlevitsk@redhat.com>

On Mon, Dec 09, 2024 at 12:57:49PM -0500, Maxim Levitsky wrote:
> Fix 2 minor memory leaks in the mana driver,
> introduced by commit
> 
> 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")

Reviewed-by: Yury Norov <yury.norov@gmail.com>

> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (2):
>   net: mana: Fix memory leak in mana_gd_setup_irqs
>   net: mana: Fix irq_contexts memory leak in mana_gd_setup_irqs
> 
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> -- 
> 2.26.3
> 

