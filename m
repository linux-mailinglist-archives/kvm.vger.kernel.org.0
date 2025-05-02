Return-Path: <kvm+bounces-45217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2A1AA72D9
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B265A1890D98
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCDC25485B;
	Fri,  2 May 2025 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tYcEfitJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684AA24676A
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 13:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191201; cv=none; b=gIjC+OS6PR7XoHhgJOyMVrwVyfxw34ew8Cr+jnIbuRokvz1l8WSWxmCVeFef9RVMHiDCgLJmGFnb9dHyXx6kq4XhomZxS9hwWy+cDNh6DbZDCIxRZPJxkh6TGE8vAx6iM9n17ADlagBWt188PIoI1ho6hBIjDiLVFY0iy0YAMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191201; c=relaxed/simple;
	bh=H0xGOl62oeRL1d3OZ9xSH5+/9IIITbIuyvk5HOW0GR8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ps1RGglxVT6Gk1vLh2ehx34j4CIUgp3Le1bPEorPfNmZ8rAzZlmhZUY6jpJQXxaE8O0ASHL04DuSkv/qnpkPVlfQkr4rqYEIz+BDrUAdlLvytDWgAI6Q4OLIvPdmx8MoR9DCvnYlB845doucqtNtxguzVU3vdIBWjIAH1Bv+mhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tYcEfitJ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so1223298f8f.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 06:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746191198; x=1746795998; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x8cq0a7oGXKypIhWHfDdVPG2fC/JV8M84tH810dFsRE=;
        b=tYcEfitJTMyVWsdqZdrQHxSHuw1WoPQCiOwfleKPNPQ0n6MhZWN3lLGeC3FIqWCcIc
         Ko0DG6vtXS7y/ypoqdPFAHtFVGgnsfLfpt0B8NdNav3CcxgAA9aLKJ5IgMuzWyqiS/ae
         K34zFvfJKffbLCR8IHINVnhGIm1jUCRn9K2qguwry/VuuIMAlGhjpokOrm/wJw4bGlUb
         qOxJUiw2k9vdfjGQ0G023FnR0TARP6AQZFxc0d8VdWJrbTmOkH/VWnMrzidEdVOMAtz6
         XDksf6DXZxDp3amaNVIuFUnUyj6HFbcBqTJa+DbHXBarBE9cGOXoRLfS/RFH4tAF4yTy
         I6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746191198; x=1746795998;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8cq0a7oGXKypIhWHfDdVPG2fC/JV8M84tH810dFsRE=;
        b=X6CDKAzOwIuQeK3a4QniLqXsVO80Z2fDziBWAZ2poKD3oSOADgS8TqCaek7YuFO6T7
         gZaHVgGPPK99PsaxRvTbUfRvxjrwUeOr0H61jAODGrxenhLyJcdj/hmrl/XYjuuQwM0h
         krviXsUwJEcwJcOwY++yJ1zJO5/0Yo60xa4hs24DRM6Pgl6tLWvupunjg3l5NTazixKb
         XAHxcnO1b6aPxXzBrXnKytb+8zpM+jTWwYHi4YyDt2ZNgqHseLjMbUfrIjwNNlh3WYz/
         GyZMk3wOgRzqUnjcVWdJG7yP+lb0ezx2CbgzkF6IPT3v0Q/g8Kiu8hHU7IxFNjmRiKPW
         e+bg==
X-Gm-Message-State: AOJu0Yw3RzmVh4lxdgfdZRUMwxjZXJKUOSJcgpJtRuh/n3Nad+guS3WD
	yBzwnlhYRIut4iZEikagmfvpVjvRAtONWWUDlBjjdJ3d1/47BSaGZpUwrK9rCZY=
X-Gm-Gg: ASbGncv0ZfenUoBIXVSy/JY2gxi0anM0TsTNpixZGL579kkXCoXNtWev8WXUCMfPpKr
	uzJultCrCGP2ZxqHb46ewG+eto34AL9jQYKe2gZ8J9cEvxJDS7vzbg2W31t0326BhFcnx69x5+1
	PLRbOQQuA/dvECOx8+2x0de2wIxfrYIhK++6wP9OLauh4HKzND2BWGq9jBGrgrQQBMc7+fs7bw6
	e1bdhZM5GSPyjkrS5y/Sd3YRMTDD9Ib5tH/ZtWok1pSZFYn7ITE6eF0vREqCZcoRtaDP7jTcPfK
	f97ZuzsUBjixGUZljKVWFlNLJxbU1jFOGrODoLADQm/fJQ==
X-Google-Smtp-Source: AGHT+IGvv/Xi1vUrxxC7FmwtGtiq9GR0iLMrOtgQPTx4aE+Yc1xTk5D6JKFn3LncplsJaEPhFbBOzA==
X-Received: by 2002:a05:6000:18ac:b0:390:f358:85db with SMTP id ffacd0b85a97d-3a099adde2emr1882591f8f.30.1746191197522;
        Fri, 02 May 2025 06:06:37 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae0c25sm2154140f8f.17.2025.05.02.06.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 06:06:37 -0700 (PDT)
Date: Fri, 2 May 2025 16:06:34 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Nadav Amit <namit@vmware.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] x86: vmx: Comprehensive max VMCS field search
Message-ID: <aBTDWoL-wE46-GZ6@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Nadav Amit,

Commit 2b0418e4adf6 ("x86: vmx: Comprehensive max VMCS field search")
from Dec 19, 2019 (linux-next), leads to the following Smatch static
checker warning:

	x86/vmx.c:346 find_vmcs_max_index()
	warn: always true condition '(idx >= 0) => (0-u32max >= 0)'

x86/vmx.c
    339 static u32 find_vmcs_max_index(void)
    340 {
    341         u32 idx, width, type, enc;
    342         u64 actual;
    343         int ret;
    344 
    345         /* scan backwards and stop when found */
--> 346         for (idx = (1 << 9) - 1; idx >= 0; idx--) {
                                         ^^^^^^^^
idx is u32 so this is an endless loop.

    347 
    348                 /* try all combinations of width and type */
    349                 for (type = 0; type < (1 << 2); type++) {
    350                         for (width = 0; width < (1 << 2) ; width++) {
    351                                 enc = (idx << VMCS_FIELD_INDEX_SHIFT) |
    352                                       (type << VMCS_FIELD_TYPE_SHIFT) |
    353                                       (width << VMCS_FIELD_WIDTH_SHIFT);
    354 
    355                                 ret = vmcs_read_safe(enc, &actual);
    356                                 assert(!(ret & X86_EFLAGS_CF));
    357                                 if (!(ret & X86_EFLAGS_ZF))
    358                                         return idx;
    359                         }
    360                 }
    361         }
    362         /* some VMCS fields should exist */
    363         assert(0);
    364         return 0;
    365 }

regards,
dan carpenter

