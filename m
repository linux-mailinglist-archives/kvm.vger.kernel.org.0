Return-Path: <kvm+bounces-19417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB4A904CA2
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D654B286353
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E28016C685;
	Wed, 12 Jun 2024 07:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="CSpD9dy4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353816C86F
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718176959; cv=none; b=nybgKUw8lAYM07xeKWS0r4D5hWHMB0inaDWUMmCO01UAWqVAI9dQl57F+ksJ4a+/p6UXex2pZ20DuZl+TM36hkodkPbWZ+nSJYgFWWsrdlq/8X+pW2jk2utd96bviWS7MRX1vZtWiAgykc1AYlnojdyUPAlUSMTP7jhewBf9Dr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718176959; c=relaxed/simple;
	bh=wkDVA2dK3+U+cA6W49NHBtQ20kiOyRc5qnKumZI2mZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDvrpgcCrUdfA6vq0nl0MZXoRTzEw/dKQsTyyfnSKGQwCsUUw98YWG8WfsLnCr15Y1T1aZuSZOAn6yhkoMlY6GT6wQRLOCEBQufoEStmjBS6oJ+JxPHLDHMdrbd8hLuDBvBtIhESbHL2vWX1xroZ810PK8wCmzjcalGsGZFcJx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=CSpD9dy4; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ebeefb9a6eso18802671fa.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 00:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1718176956; x=1718781756; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XyAaGEtFFwkdm/QpmeEncAmUxjsc5CcFkHBcrT1qbjY=;
        b=CSpD9dy4uJ1tvwuowHkLQayntpGdUohvr6xueFj/D1a/5fGv/mkoMcJYpzNmOozN00
         u0wDdD+sB/NBft7PmOBci04IC+o6gcrWG7oi37w2mBErAOMEwW/VAGHWq+UPWd3HHcR4
         W10/OwPBm7W3VNWvF486v6ekdHcp2UFZhw3G7c65/WCqjtJW6mfCkoz/DcPijtn2qK2F
         1uWZwNs0O+qoKc920WjLetOHDH5omM4TLjFLe6P+HiBjizp95UfpOhZjz/6squ8T2/yV
         G3gu6C0GSyzo5gikg2NISNJOtVB6r9Oi+mt+cRmAPoUl0X2W8n0lO5gaBW37l3ag0Bww
         zFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718176956; x=1718781756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyAaGEtFFwkdm/QpmeEncAmUxjsc5CcFkHBcrT1qbjY=;
        b=VbMa/knZ/LzXD2j/H3FEDp/zbltV1MZJgZF2nnkVwP/0iLCVgNUHcmeUDfEFjesvbb
         btx7ikXkfKgqZbVeHTV/aNyamOfYqkfwDUUJ+oAaPpItONHah7AxxXdGa3WSN3p6QJA9
         cpiqlvZhCo1WmLlu4lBrrMrad4W2XO32r0qkoLD2MFIN8whtWXeTDcMmqhNcVEwcge1Z
         lLPyxIboHhbYyIAAfZrQuwPhziXJT1ZbWYx6olSwYc6NN5Yywe9eSgRe+8vXXRixTkGq
         Zn22V71j10H6Or5H8uGdYebh/lwopThKfibq37tgeNcEKu2kkRtBpDGv8IX6fxcpEKsD
         j5OA==
X-Forwarded-Encrypted: i=1; AJvYcCUIYGHJv/EtxbfRfQnbHcHt5KedL+3kTKruMe5M6RQvbs1xGzm9PX9NF5dmcEnyD2zy44STH2Jfh1ApxwkVCqjWXSt/
X-Gm-Message-State: AOJu0YzG2nlePxud8vecK0EczgOmL3Tf6FNeIg3QJ2Pf8eA/8XmqlKi4
	YSe4xGfgteUgMHfjCuMwswQTSz+HaU0c8FAaBZ7/uVtUwy/rn3wRxJWQU+PqTts=
X-Google-Smtp-Source: AGHT+IH7lMBz0iqDSWgr4Qo//hA7IRWAfAG/YjDjdEYPujMcic/KlfaHdqUt7roVwGJmVDixv7uEJw==
X-Received: by 2002:a05:651c:8a:b0:2eb:efff:7729 with SMTP id 38308e7fff4ca-2ebfc8ffa4bmr5282021fa.6.1718176955743;
        Wed, 12 Jun 2024 00:22:35 -0700 (PDT)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f1c958f9fsm9730922f8f.38.2024.06.12.00.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 00:22:35 -0700 (PDT)
Date: Wed, 12 Jun 2024 09:22:32 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Cindy Lu <lulu@redhat.com>,
	dtatulea@nvidia.com, jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <ZmlMuGGY2po6LLCY@nanopsycho.orion>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org>
 <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
 <20240612031356-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612031356-mutt-send-email-mst@kernel.org>

Wed, Jun 12, 2024 at 09:15:44AM CEST, mst@redhat.com wrote:
>On Wed, Jun 12, 2024 at 08:29:53AM +0200, Jiri Pirko wrote:
>> Wed, Jun 12, 2024 at 03:58:10AM CEST, kuba@kernel.org wrote:
>> >On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
>> >> Add new UAPI to support the mac address from vdpa tool
>> >> Function vdpa_nl_cmd_dev_config_set_doit() will get the
>> >> MAC address from the vdpa tool and then set it to the device.
>> >> 
>> >> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
>> >
>> >Why don't you use devlink?
>> 
>> Fair question. Why does vdpa-specific uapi even exist? To have
>> driver-specific uapi Does not make any sense to me :/
>
>I am not sure which uapi do you refer to? The one this patch proposes or
>the existing one?

Sure, I'm sure pointing out, that devlink should have been the answer
instead of vdpa netlink introduction. That ship is sailed, now we have
unfortunate api duplication which leads to questions like Jakub's one.
That's all :/

