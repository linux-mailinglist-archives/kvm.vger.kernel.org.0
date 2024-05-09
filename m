Return-Path: <kvm+bounces-17115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859B78C1073
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 15:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6D801C218D7
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 13:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34137152E15;
	Thu,  9 May 2024 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G8qKz55u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A155713AA2B
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715261789; cv=none; b=I6v1bK3tIei0KDDDau5l9vJVklDgvGNcCrFop4K42kPpETaxp5KD9vDwPqAjzoLRhSOoDdgAC4njxliLrsVSQ42E6sFV8qJcMcKT5qE8ck5FZV38E8ZdZgIksqLIkBrB2ynbzue+dG5jKvTwQnXI7A0cXKrxEM65J3jc1xA4rHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715261789; c=relaxed/simple;
	bh=s9BLHc5Ra8sUt0FSkcIfUa5IfMmCosNR1gq0MDDY3ug=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l+B/KPgfnihWnHhZKN2lfMMk7qGIx+pLYHf6vNyL38aaFT8Eyh2MChlPVPQdA+PTta3VGxyZO55vbwpqmkjHBNRPpARVnwB4KJRYBVm/3XYYxTvtLy7orJmpNG97oK5OEzpsGYszVa2wj5t2p6+EbMTss5CHt7Axsa21wBqI6P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G8qKz55u; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a59b81d087aso213564966b.3
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 06:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715261785; x=1715866585; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u4YakzUxN6dCfUP+LMhbQDEMB36cSquiMJntyv5Eo30=;
        b=G8qKz55uRTSaidJsQibxoot5xVJ1uD0f8VKemPqslp7v5ZXoBY+rC3RGeHyyLnYJdt
         6D0N62YqFRb/EB0tUrUMZukhC+TJZF1ujvDbKUkwciRYsYIxkECWWTxyGCxo5w9IsTyT
         mYP8VYjlPcyML96gMmuVr1pbFAZh5kbgDeZBX9u3YwNcVkYXezstZ//vBjCDrYfMDtws
         vlNZZ2KRo6yyejo0YwkO/y6L3moakJ3pcGrvQEaSDWDVoDsmrObiSgelccMVFhDLi4zH
         yjhNwTRz3Ijt4roPvkE3t4Xz/oMf9aaAxYilRN4Y/nIy72OCYirJ1BRBJ1/z7Di8LWHN
         ywkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715261785; x=1715866585;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u4YakzUxN6dCfUP+LMhbQDEMB36cSquiMJntyv5Eo30=;
        b=bVOgoEoLpOPxMORQDvCild7cLjvI88uHJ0QN9mZ9dCRumScEC9hg/00YgdeuVjbe1H
         5aEZZNvag8sN/Ft/fq7yYtnKPTS8EkIOCbSQOjKSXtXbckiysZBRqeetGJF5mEXIWS7s
         MLLyXYU+Vq6GLO/qs+ygGYgqTHVK8ec/xwwifjt3qXIG4xAKmsbfpreDCwLAKK2d5sXv
         dJvZs9pJQd0pHbXWqc+nL0wPzgXuhUfx2SaBd72DY1DLxA4FQNfSnRSTIrw5DNbGiR2i
         rRFVpequvIPt3gKrzVkI8DFn/DkLrZxsRnZt2qP4flBjOFqDBZTNzwOTJRm137dO3bWO
         r0GA==
X-Gm-Message-State: AOJu0YyrQXuu90k2Xm8vG7HmIreiIJiFeCQhkRIumZ74QKhi0MO/Jcf1
	jmH2VivuMjf1PobLoS0zn8lQrdxUhDmGBzZlPdVw1E1vZ28BhLNzPCIz/lxcC/I=
X-Google-Smtp-Source: AGHT+IEm8ZRldPiMKRedOQZPvO1z098qU79oSeeTvcw1HNEv4PstT60ioC94VtMwF8rnGa03Vur6Tg==
X-Received: by 2002:a17:906:ff52:b0:a52:6159:5064 with SMTP id a640c23a62f3a-a59fb9c6dd6mr448798166b.52.1715261784704;
        Thu, 09 May 2024 06:36:24 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179c7d70sm73933066b.125.2024.05.09.06.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 06:36:24 -0700 (PDT)
Date: Thu, 9 May 2024 16:36:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: yishaih@nvidia.com
Cc: kvm@vger.kernel.org
Subject: [bug report] vfio/mlx5: Let firmware knows upon leaving PRE_COPY
 back to RUNNING
Message-ID: <3412835f-4927-4c9a-830d-4029fa0dc7e0@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Yishai Hadas,

Commit 6de042240b0f ("vfio/mlx5: Let firmware knows upon leaving
PRE_COPY back to RUNNING") from Feb 5, 2024 (linux-next), leads to
the following Smatch static checker warning:

	drivers/vfio/pci/mlx5/main.c:1164 mlx5vf_pci_step_device_state_locked()
	error: uninitialized symbol 'state'.

drivers/vfio/pci/mlx5/main.c
    1142         if ((cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
    1143             (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
    1144              new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
    1145                 struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
    1146                 struct mlx5_vhca_data_buffer *buf;
    1147                 enum mlx5_vf_migf_state state;
                                                 ^^^^^
    1148                 size_t size;
    1149 
    1150                 ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL,
    1151                                         MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
    1152                 if (ret)
    1153                         return ERR_PTR(ret);
    1154                 buf = mlx5vf_get_data_buffer(migf, size, DMA_FROM_DEVICE);
    1155                 if (IS_ERR(buf))
    1156                         return ERR_CAST(buf);
    1157                 /* pre_copy cleanup */
    1158                 ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, false);
    1159                 if (ret) {
    1160                         mlx5vf_put_data_buffer(buf);
    1161                         return ERR_PTR(ret);
    1162                 }
    1163                 mlx5vf_disable_fds(mvdev, &state);
                                                   ^^^^^^
state is only set some of the time.  We not just make mlx5vf_disable_fds()
return an error code?

--> 1164                 return (state != MLX5_MIGF_STATE_ERROR) ? NULL : ERR_PTR(-EIO);
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Uninitialized.

    1165         }

regards,
dan carpenter

