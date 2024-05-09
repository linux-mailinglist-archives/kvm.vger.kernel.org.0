Return-Path: <kvm+bounces-17123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 093BB8C116C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7ED6286D2C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162EF3D978;
	Thu,  9 May 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uDGC6/hz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505921A291
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715265798; cv=none; b=koQvruorHCbxCgfs+rX7QwDu6cFcrUoxxkgUGqnOIS9StyKaqox64bRafL3bj3NV0O89JKRFpIN+gSbrMbiWDshDNHCOLz3O4CQhTbmBT/U4D2E3ibV2ulaGNxxu1iTEGElBSHUPBYjWJydWsxVIkZbEaeq5QsATTdDIQ5Fej2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715265798; c=relaxed/simple;
	bh=lsUjb9xo93nD+F+SnRLibRuo+thoOc3hPW7jengNC4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CULOUhRcjTUCiQQWf2ktMfXZ2iJiIjAbbDSW708Urr3iEPtqst21fVy3Ah2Q3pDCIEUcl0/F6vgQNui1rRGhKrAY+xDPkTLY1g2Me3vJYgpxVcviIxBUykGB/JQpABqx2RJETA2bJItV8yNbzmv5biGdN+gn2daDry0vjOmkWik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uDGC6/hz; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a59a5f81af4so239913266b.3
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 07:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715265795; x=1715870595; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xItJVTxRC2HAx2c0rev0ICaC+r0RtSUTHfo/BY+v6xc=;
        b=uDGC6/hzpKnNq+djavOJstOsXW6AD6KGkdycgaCBZ83j8DjfxYxWLNeCUsDgBR7Pq0
         ejEdZUWJ3/2m1DnWYGoBCVMaZT2Bit6iuUI76HvCRD06NnT3IkWpqx+VaXMtrUlBHx4a
         chAtw3wSqxOcg3lxjRFP1h4EmDCN7mevJtqzlSeQgOuImA4RSqXV+gXCxQCw5YXWUnHb
         xiVIz77FPnP8SpFuOBiqhdCxAkzegH2RbuWOAqNwAa0C9of4IekyIX/rJjgUpAa76n0R
         D0Wjhl8HgmAWTzC9KTnoVzgInLUDUs9PDqTNg9Mg1C6pLQi+xZXG+J5isCUT4c8A1LX3
         2SUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715265795; x=1715870595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xItJVTxRC2HAx2c0rev0ICaC+r0RtSUTHfo/BY+v6xc=;
        b=LbYk5kgJOshxBkQjPrndtQxCo193u9xpnhRF9WN+lU5Q+qW9CQgyOmC1UJ3ir6Gy44
         sd9eMQtbeLPKshPVXicKOOacHz5XG+U/+6j+TTkAORcU2rlpZznrXP/DlnFHgLY8AaoW
         SrVUClLQkvwE5IS5pKj1VJKSLoSK1ddhU2jZFGrIrrq60EfI2qPleQ1ONPG5vuffnh8L
         mlvXAHROBoFqD+PCCPPYpaxPndYvbh8LPWRK44hDfehSG3ORAf4TK/fWb+zhtIqFe0cL
         vENg6+2K6OQ5R4bcbOrviSsSrR/kFC+w2WZFa8Wts/tBm0Nz/BmV2Mqc5bh/M2FGJoLU
         9F5w==
X-Gm-Message-State: AOJu0Yw/r18ZuZ3wXNf92Z+Kd1dgjCTnelBBQjPE5J8s7GswXrSWnvBg
	5zseaGTobmU4N/v1qSP+hxMujBzIeSg7CT8lE3gk/2wQiL9wfpGxDUM/s0xb4do=
X-Google-Smtp-Source: AGHT+IGEUWEM7LCkrDzeQuG2qzFlMFm7OkXpWbrTMVlMtAfEmlHpH+uHHgS8nbGcfs8x0WBFy/N1mw==
X-Received: by 2002:a17:907:3f92:b0:a59:bc9d:a0a3 with SMTP id a640c23a62f3a-a59fb9f21bdmr441716066b.75.1715265794451;
        Thu, 09 May 2024 07:43:14 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b0163csm79246866b.163.2024.05.09.07.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 07:43:14 -0700 (PDT)
Date: Thu, 9 May 2024 17:43:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: kvm@vger.kernel.org
Subject: Re: [bug report] vfio/mlx5: Let firmware knows upon leaving PRE_COPY
 back to RUNNING
Message-ID: <29c68173-934c-49e1-8a20-1aeed0b99d9d@moroto.mountain>
References: <3412835f-4927-4c9a-830d-4029fa0dc7e0@moroto.mountain>
 <cff7ba09-2437-45f5-93ee-e5d941e550f7@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cff7ba09-2437-45f5-93ee-e5d941e550f7@nvidia.com>

On Thu, May 09, 2024 at 05:04:43PM +0300, Yishai Hadas wrote:
> On 09/05/2024 16:36, Dan Carpenter wrote:
> > Hello Yishai Hadas,
> > 
> > Commit 6de042240b0f ("vfio/mlx5: Let firmware knows upon leaving
> > PRE_COPY back to RUNNING") from Feb 5, 2024 (linux-next), leads to
> > the following Smatch static checker warning:
> > 
> > 	drivers/vfio/pci/mlx5/main.c:1164 mlx5vf_pci_step_device_state_locked()
> > 	error: uninitialized symbol 'state'.
> > 
> > drivers/vfio/pci/mlx5/main.c
> >      1142         if ((cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
> >      1143             (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
> >      1144              new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
> >      1145                 struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
> >      1146                 struct mlx5_vhca_data_buffer *buf;
> >      1147                 enum mlx5_vf_migf_state state;
> >                                                   ^^^^^
> >      1148                 size_t size;
> >      1149
> >      1150                 ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL,
> >      1151                                         MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
> >      1152                 if (ret)
> >      1153                         return ERR_PTR(ret);
> >      1154                 buf = mlx5vf_get_data_buffer(migf, size, DMA_FROM_DEVICE);
> >      1155                 if (IS_ERR(buf))
> >      1156                         return ERR_CAST(buf);
> >      1157                 /* pre_copy cleanup */
> >      1158                 ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, false);
> >      1159                 if (ret) {
> >      1160                         mlx5vf_put_data_buffer(buf);
> >      1161                         return ERR_PTR(ret);
> >      1162                 }
> >      1163                 mlx5vf_disable_fds(mvdev, &state);
> >                                                     ^^^^^^
> > state is only set some of the time.
> 
> The 'state' will *always* be set in the above flow.

Ah yes.  You are right.  Thanks for looking at this.

regards,
dan carpenter


