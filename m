Return-Path: <kvm+bounces-58033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D00B85F5F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2D34583D28
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F8D316196;
	Thu, 18 Sep 2025 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BH8+S/hr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25307220F29
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758212478; cv=none; b=K3nFnFSKyIL4Z21Qz9BzSQk8yaO741keIGWL8e0usw9R4Q/mlFpcGo/frvwTyBOqTf4mncD/dwhvDJhaxtKpar73L2PZYcJdk85KyJ7WHkyMbqLx82GuiYMx6SDHNnlZERkeQ/zGpE1h/VEO0ls1lNjvbV99c5ec8AxbZS7ms1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758212478; c=relaxed/simple;
	bh=+6DWJ9V2/s86NKsZVHhjQHyxMst7QlpPf4TiS4jwR7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hsPf1tysEoBfPta3sHT17JxGcf769I9oClz/byim6CajQAPwB/1zftsbnQnUzm+NJp3J7bwDnZ5GIyh1RDck7GghMxn9nBse9TN+F473UHNJHbRBTlvHK0LJnETUFfCDq1pa255fwt56iWf0/ZC+y7L7fVwYeLNeQ6xbMitNGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BH8+S/hr; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b07d4d24d09so205440166b.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758212474; x=1758817274; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QBudDRqq0+IaBsPdP5gcYH9xINBuKzncv21Vz7DKv+k=;
        b=BH8+S/hrrTxUiX3MC1S6d7HVVPrpM37Z9+StAGHka8NsJkpMwCXrt8eSS0MfQzT8R/
         gM7g6GGTaQVuYgj+J4LS+ry8uCJ/soQsR7+a6hKWV22xoHBh7NCaeirmMO02l43uuOg+
         w0icgadUhO4EZjrOqiZBAmZhbrEDWCEpgNrkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758212474; x=1758817274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QBudDRqq0+IaBsPdP5gcYH9xINBuKzncv21Vz7DKv+k=;
        b=Rt6BbF9iJmGHhyjA9iTrQB8y2lPN003zPN9ym3ddBt0303avoJxPfvcx3gHPiZGIXb
         ydsyjd2KTuDlHdKz/L+P6J6Dq+NFpWU29CDafx8f7AuH5p6XsOdKAGjzX6klvun4jJuZ
         6vJKFWyaI3aVIGgfkUie4wWkBAubMrWKj8x/ptO/zt8fqICvWDi8xKQhfbneyZj3bBJo
         2Qez77etbGzfU0IVHZVTpbqEsYFMJEpnKXPjtLLYAnQz7D8v/pbtFpQfX7mtAtCGcYNV
         LpFI7fE+fe/OuARD4BdK/9ZUexc7cB0cOc3fFBino+ws37Dfe13wDIIjUhWQsAOip/Td
         fCSg==
X-Gm-Message-State: AOJu0YzAK+hVq1w9K85PJQ0BX10DK3mEI04TPLbW/NhGNr2gdDzxER7T
	VGnpE8eCfV89vHO6auKBgu4uKoaKcGo8/n1t2HLte0d/aFt4Cs2SMcXXa3fjXL5GLvXepUbKWPc
	u+gnUoJu9Rg==
X-Gm-Gg: ASbGnct0cAD69qeq+PpxbqVYkGjza+8j20IaKnAjzJPncaldOWYjg4RRIhX4NdP5rSm
	GhYVLB9n+C94LGAB+WTCwW0ZAeJ5kJNkVtvJyq9Bwr0UnLEpSrRGtrPUd4I3F5By3L0XXtkaKkn
	AX2T+8z4wZv5d+TZ+LxQ9B23341UtTZ2CjnwB4ll+KjESQhLpcOI5Ni0wPWzYF1uPQoClRfpOWo
	wpybtYdLgFAIPwim7ck12QXnrMRVmnQo+Y8OF8jdXI7hWFyH293meunGhtOcxCoXunJocexzFFP
	XwWqtErtpPW2Epl2LKYrrZ02FcSQODrZMG+3rMCKhWpu+dcybkNZOsaqEa6dvUqEI2b8z64XdXP
	F+LVwLOlwxRfEpAy5h6ihgJs5sGAYITdhV0/fLTET50NNr1EX0JJfJz25+xn3OTzcdu+CWmfkWc
	5i6JJYWLTCADa3FZE/Sgx6JysWzQ==
X-Google-Smtp-Source: AGHT+IEb67ycFZe9zCl6jAoSHAu9wiA9yjXExXkA+tOcCOgLpxU/GrM/G6xCvbEaT0DTNkTyhYO40Q==
X-Received: by 2002:a17:907:94d1:b0:aff:13f5:1f0 with SMTP id a640c23a62f3a-b1bb16d4928mr725238966b.7.1758212474258;
        Thu, 18 Sep 2025 09:21:14 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd271eaf7sm213888066b.100.2025.09.18.09.21.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 09:21:12 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b07d4d24d09so205430266b.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:21:12 -0700 (PDT)
X-Received: by 2002:a17:907:6d17:b0:b07:c715:31 with SMTP id
 a640c23a62f3a-b1bbc545b7fmr610549366b.65.1758212471806; Thu, 18 Sep 2025
 09:21:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918110946-mutt-send-email-mst@kernel.org> <20250918121248-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250918121248-mutt-send-email-mst@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Sep 2025 09:20:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=whG45CvbpxG2dtWgAG31uPSRZ_FPw9s2tyH_8enuxYE8g@mail.gmail.com>
X-Gm-Features: AS18NWAmxo1DLd_bNcF9s-ZOOAwZnodu5o6p8OrqHir3EF-tNoG8mT_VioNWcEI
Message-ID: <CAHk-=whG45CvbpxG2dtWgAG31uPSRZ_FPw9s2tyH_8enuxYE8g@mail.gmail.com>
Subject: Re: [GIT PULL v2] virtio,vhost: last minute fixes
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alok.a.tiwari@oracle.com, ashwini@wisig.com, filip.hejsek@gmail.com, 
	hi@alyssa.is, maxbr@linux.ibm.com, zhangjiao2@cmss.chinamobile.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 09:14, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> OK and now Filip asked me to drop this too.
> I am really batting 100x.
> Linus pls ignore all this.
> Very sorry.

Lol, that makes it very easy for me - no need to be sorry, and thanks
for just reacting fast enough that I didn't have time to do a pull and
then have to revert later.

          Linus

