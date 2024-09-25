Return-Path: <kvm+bounces-27395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B8C984F76
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 02:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79B7CB22977
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 00:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0191C79F0;
	Wed, 25 Sep 2024 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2ZdHAID"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853344A18
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 00:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727224308; cv=none; b=iW7PI5+wylH/RZ1xjmiIo26cXu5mxTbMrrC3kQVxT7Lq10Lqx+dZsslgf8c0e6zNjoQYGodvxpaeanErRAs7i0nhoqfAmCIYlHGa80HhECO4L4RW0VxbbuHBta1CDGDiD7acZU9rEOHTWJZxZxDIAHHMZXiF6vJv00CA2wwVMuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727224308; c=relaxed/simple;
	bh=K/9pwGYPPYAs84vniTwGu/e23/s6+5iVY6/PDAAG4us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eWKx9jz4tqAzQWTJ+M8VXBvUSjRWvZnYmXHc5gJ+YHFb9b9qmcqz9/8CBZApDfLhVfR3eUsQrVFBBeJfULi2oI85C8WIKQ6C/0TDpXdty9NhVoV6pq0vDgdM4l/bmNOsaiNWcG5bvM9DqZBIpSD6TJ2rjl27N6K69ilrExi06UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2ZdHAID; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d4093722bso531442366b.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 17:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727224305; x=1727829105; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K/9pwGYPPYAs84vniTwGu/e23/s6+5iVY6/PDAAG4us=;
        b=m2ZdHAIDLyb5x7uaOq3Bxuh3yqA+jy+HiRcTt4+zbowFjJKug2eFbFc+6HQEF7oOlb
         RFMogPu730BJDiJ0vGSPgjRtLhiRPwkQtPUemMuP4oDlZYuWe3VRY5dyJw1abRLqkuJ0
         wC7ZPc8enAuHkgaB4WnUdfbqc/x99ny5KwlikPoV4UV6eQaU32CWcl0J07vjiV0mV949
         VOpx2KoWcX5frBW/Avj16m0Svgt04L91qlMlRpAcYsa0RDtfPXinZKBpZZ3FCjAoJ8Zi
         bcAbv0UaA4Sftf6Xk9S1eHGeiZvtQjurmzs9HLmY4YgcT77VBi58x9/jmGXX+YSJTDZ1
         GA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727224305; x=1727829105;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K/9pwGYPPYAs84vniTwGu/e23/s6+5iVY6/PDAAG4us=;
        b=IsI917i+ENUGwDGu6rwt7AYue/UzNubMj+w/QpCgSNzPT3ODGVp9lkOxlKplU667wZ
         mIBlFPWTl3bBHxhjr+pfWZH1CbwJ2lrZ+uvvo1/wxKuUpR1YQzkasgTIXqPlVKt26K2H
         GzRCWiIb+Xk15hRZeMtUpBci++JQpXuAdrTdM/QczHlCLcDhD9B0gifgNtojvk9ADOM8
         TxsPvWVSteWIyJMBBW0Nl27+BGF1O/IQU4IDGhrmTBvrOFehf9QU2NzsKjEjuT+HKShr
         mxKFJIEPnSOUHfHqlDCEb/Tu1OW9gbj503u8NDxXG9RInHkTeLKoT1nnZPjcpsgNv6Vw
         Dyog==
X-Gm-Message-State: AOJu0Yzb+K3hHDmFbS27N5DiZ+sZxNMD54ocYK+hXooDX50J77wbDkS9
	wjccdnd4KDUpC90XrtdyoDofkGiRcJ9nYKaX/THBEyE56RielyoZHIjZeBDTp5hXDi/f/Gowc3y
	EtsvSHh/jGVozVcPOqW+j5tQNgK4=
X-Google-Smtp-Source: AGHT+IES8mbAOSEQK03hCpA8I4gleTbb1OGNxfdrnBI54A5Kyh/dhdPilb6p2UktQA62b9ecz3ULt1rUmU4VtsfaVYQ=
X-Received: by 2002:a17:907:944e:b0:a86:96f5:fa81 with SMTP id
 a640c23a62f3a-a93a03e32c5mr81294266b.32.1727224304377; Tue, 24 Sep 2024
 17:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240922124951.1946072-1-zhiw@nvidia.com> <20240922124951.1946072-28-zhiw@nvidia.com>
In-Reply-To: <20240922124951.1946072-28-zhiw@nvidia.com>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 25 Sep 2024 10:31:33 +1000
Message-ID: <CAPM=9tz34jg8nD703b+iAzWQejjKKfKJgULt+sHAp_N2AYzZMw@mail.gmail.com>
Subject: Re: [RFC 27/29] vfio/vgpu_mgr: bootload the new vGPU
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com, 
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com, 
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com, 
	targupta@nvidia.com, zhiwang@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 22 Sept 2024 at 22:51, Zhi Wang <zhiw@nvidia.com> wrote:
>
> All the resources that required by a new vGPU has been set up. It is time
> to activate it.
>
> Send the NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK
> GSP RPC to activate the new vGPU.

This patch is probably the best example of how this can't work.

The GSP firmware interfaces are not guaranteed stable. Exposing these
interfaces outside the nvkm core is unacceptable, as otherwise we
would have to adapt the whole kernel depending on the loaded firmware.

You cannot use any nvidia sdk headers, these all have to be abstracted
behind things that have no bearing on the API.

If a new NVIDIA driver release was to add a parameter inside
NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS how
would you handle it?

Outside of the other discussion, this is the fundamental problem with
working on the GSP firmware. We cannot trust that any API exposed
won't change, and NVIDIA aren't in a position to guarantee it.

Dave.

