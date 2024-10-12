Return-Path: <kvm+bounces-28695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2A499B76A
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 00:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51DFD1C20AB0
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 22:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715BC19AD9B;
	Sat, 12 Oct 2024 22:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtRrYcHV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E2216C6A7
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 22:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770899; cv=none; b=ctibEzEOuK0nQQ5ZCbJ9QmMnOwn3LPlQLlM7xjhtszxhQ3VbyR3qub1sPbeJbwnM4qP3alXIRBORrb2UGKBftwnsWfuQTHl8Jf/J4V9KCMCRILc6lBQGNHXby0K4bAB+AZ8oaobhHq7XJXX3iFO1wkvCUl8Y2njHgpOOqG7oC/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770899; c=relaxed/simple;
	bh=4p9zMCHyTvIHqWb+RiLLmYJIcUZSBcLyXxn110UCViQ=;
	h=From:Message-ID:To:Subject:Date:MIME-Version:Content-Type; b=no6h4onnOKqVG78FA0sgGWBhhiLJG1mHLReV2F1HOps4QutiZRnNmML0oGA6bPyW1u/tFzGcsmcTZLuNelB5ui+b5TheAvFJAfOgYU69GwOGzCiMThyGgzqwe4UIVWwGLco+HBzELmLnpViWjVrraerrOdR7S2ogxdy4t7Trxl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtRrYcHV; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-7ea76a12c32so310655a12.1
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 15:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728770896; x=1729375696; darn=vger.kernel.org;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4p9zMCHyTvIHqWb+RiLLmYJIcUZSBcLyXxn110UCViQ=;
        b=WtRrYcHVpB5v2aNmMEOyvz7kxrtG3XSwxLTrFnW0aDLjqdRAkiEjV/bTpaBcLC7Ja6
         UJVDfBNZq55XDLotgxgXZjhbGVroVUEwofK8cQ5L+qPiTDhlHYR9tBWBsa4x0lNg1fAB
         hoMAWSeDBdDL31URyfB1Pfa94Wo6gf6+VcHLTeT/G3qpTZGXQFbWJiwQtKXEvsa3Xn4P
         VKZ12/MlxggYcukZ3EmOGPmbeYZsxzfrANE98Dcxu/joXMUrp4jSiayQb8IbYFXOkmeH
         RtLodYfVCcyV0Z5ymfP8jWnpfnz9a5XYmGa8Zr+E4joY7s3QzScPysX4LUVY/L6IlgAv
         vxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728770896; x=1729375696;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4p9zMCHyTvIHqWb+RiLLmYJIcUZSBcLyXxn110UCViQ=;
        b=biUh72lzg1bwtOcJYSwETHRQZX4k61/Z4jGdOjyk9Tm1kP7Sy0BzHSYufhxaxNcyXe
         mBoU9nftCryQDXntxtD1V4O2gp92VElYA3EAxarCxHprM0+6+ystwtNsainLugWZTEZj
         v6/EAPa+27CbBFrTWq00OrOeS7eoYgW5d8SUdab/IPafqhfr8elYRVFvuhB4Ab38K8O+
         k1giI4FFBPq43oeVury8E3XOixG+g7aEGXixCmK684bM9jXDy5UW40sicT3WxpS6tp56
         YX6b9+SyI6tHq95RJ6pUVoWqmp5Mj7z4AgWVleaYews4CJ5hhuFEI7+6U0rEthEIDz90
         Et7w==
X-Gm-Message-State: AOJu0Yy2cnzTpXtDOXi6vKcwgNzRo/pde/EGumpJIv71P6Xd0Br+iXJ8
	vD1UW9BSnUZ0JVpg+RLN/By/O/uEgrCjKQN2phbP6oK8Xy8vN0F5Ulje+gV2
X-Google-Smtp-Source: AGHT+IEYqS7Osfr2P5vaqQF9xpQndow/PPwonh1PeDBYllKbX2e8Uhl/C5FKiRbuSRMOxwD92wmJLg==
X-Received: by 2002:a17:90a:e383:b0:2e2:c6c2:b3d5 with SMTP id 98e67ed59e1d1-2e2f0ad14e9mr8163329a91.9.1728770896217;
        Sat, 12 Oct 2024 15:08:16 -0700 (PDT)
Received: from [103.67.163.162] ([103.67.163.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2cd2c11besm3101484a91.1.2024.10.12.15.08.13
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2024 15:08:14 -0700 (PDT)
From: Josey Swihart <maclinadesuja5777@gmail.com>
X-Google-Original-From: Josey Swihart <joswihart@outlook.com>
Message-ID: <db3117971e4dd9ad44b23bee2351a7782eace346feed155f65d392ec63eab290@mx.google.com>
Reply-To: joswihart@outlook.com
To: kvm@vger.kernel.org
Subject: Yamaha Piano 10/12
Date: Sat, 12 Oct 2024 18:08:12 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello,

I?m offering my late husband?s Yamaha piano to anyone who would truly appreciate it. If you or someone you know would be interested in receiving this instrument for free, please don?t hesitate to contact me.

Warm regards,
Josey

