Return-Path: <kvm+bounces-14068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A751C89E904
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BE341F261A0
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE5A168CC;
	Wed, 10 Apr 2024 04:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBd4oN3j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21288F44;
	Wed, 10 Apr 2024 04:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723768; cv=none; b=OvoBK1yCGWk5DmKCxCL4Eto0YC1h/SU+pGsR5PQuZjIYiAKNumk1IMbiOLw2i+u3gFppRYUlDCQjEgZP7OJ8tZ1pr4ubLptIep3U7tA8VdgzSkkGk5xN5dH+KjRqdv5pXfXsRHr4J4qN1JDfe9wm7xjMqAGNQd4+di5UWNcfivI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723768; c=relaxed/simple;
	bh=RfURxwAblei/HfC1RD9i2u89aEUSTGWEaR5/5uBs/Os=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=uMfMaO0g6RE9PLP6O6wz07TtOaXnVlY7YTZkE+1LIcp6d3jDoxXR+0HNgzfTccU+SynNUztthW3e5Vmbxi8DNFS1xIYdCO0f1DoogIyd9PQP8EsZNg6YNbO8iOYdDR7HO9bvu0St3hQSYaDBcKhsWVcFwcXzEoIyrdNJz5KjPes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBd4oN3j; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5f034b4dcecso4279184a12.1;
        Tue, 09 Apr 2024 21:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712723767; x=1713328567; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RfURxwAblei/HfC1RD9i2u89aEUSTGWEaR5/5uBs/Os=;
        b=JBd4oN3jNwK98PrIPapJFaowshQkNfbM0erdIoZElFJAn/rumcT+YPoxy1frjn2ido
         4fJXASECph7+jCM7iWhW43JZMNqjitwJHX98ckaAPK5rO5qwh8wSYRUn+HwpBLk2wdXq
         Wwn9cM1gGQVME85nVOT4CPfDFqyTNYw6gNsSJ7VVURiIWXeSpqn2/tNc3mFg+vSIs/58
         PPUgJdVmGy99ZZ3GRub47rJ8L7nJ7/tI5uXF+d6kQiNGFBmjwFzxk5trd5qKMg4ssZX7
         tkUGv0fitP34nnI3vbbNFQthMfz7SETyIsg8wsToSdnkFnsaRWT8mUAZi83ULmiWhBBP
         Zv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712723767; x=1713328567;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RfURxwAblei/HfC1RD9i2u89aEUSTGWEaR5/5uBs/Os=;
        b=iH+ck/8wqu3icrvVeUQ4KuWcAPSnKSOoWK2wXj71XQjoVhgFKU6RJpYw46Tl+SId+x
         bng389QX9WNaHRVfB7+5CFgq1VLfazcn3rcRL2MBc4795dGHAwCw803xeLNXY4S5BM4I
         FV2N6+J1dTOD8/sPCPX7t07Agx/wR+VieuQ28TrrRtZyQcDDquqvnT6hsnEMjWrnyqmm
         ki0GNf+Fr+iyshZyr59wB5swUEMNr3hVxnqvI2MeJM3pcwRn6B8Rp6w3HUzQev/cFWH1
         BqDO46v/WvMNJTArhuw7vSUGfX3wqeppMYcqdFaplbUn19CEOCDvSeu0HD0qU1+ln0dy
         D08w==
X-Forwarded-Encrypted: i=1; AJvYcCVPjcqIfqQoli2USDKK0WKJZbLHqSn/PDrdtKox1FGFnXxrwPfkHIZgocwy+cRwFRkqgVM7cxy3DPybY1y06PqpTP22UJdHbpCjf0o4hrq2ZQS0BaUsaXouBA0qTktK8Q==
X-Gm-Message-State: AOJu0YzNOFR55gvwY5aEis2rambxNsY+otRpD87R9TRQcz1rp/L3WinM
	H9s+HnKxE4GtCu/W+YDi1rxVGpgczw8LZUzfHAh9x9e+iSNn1vWB
X-Google-Smtp-Source: AGHT+IG/mDK9KY551uVRKhSBG9YjsODLj1IVe3xn7Pwh8U7sV03kr/uQe9v/3iJiXcxmW3o+5PNxrw==
X-Received: by 2002:a17:90a:ac0c:b0:2a5:575:c58d with SMTP id o12-20020a17090aac0c00b002a50575c58dmr6378183pjq.16.1712723766778;
        Tue, 09 Apr 2024 21:36:06 -0700 (PDT)
Received: from localhost ([1.146.50.27])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090a458900b0029bacd0f271sm456404pjg.31.2024.04.09.21.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 21:36:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Apr 2024 14:35:37 +1000
Message-Id: <D0G5W6ZJ5ZBC.33NKLB5X3DIK9@gmail.com>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linux-s390@vger.kernel.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: Fix misspelt variable name in
 func.bash
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240406122456.405139-1-npiggin@gmail.com>
 <20240406122456.405139-2-npiggin@gmail.com>
 <e8ea1c30-2211-4060-9cb2-c57364c80ea8@linux.ibm.com>
In-Reply-To: <e8ea1c30-2211-4060-9cb2-c57364c80ea8@linux.ibm.com>

On Mon Apr 8, 2024 at 9:59 PM AEST, Janosch Frank wrote:
> On 4/6/24 14:24, Nicholas Piggin wrote:
> > The if statement is intended to run non-migration tests with PV on KVM.
> > With the misspelling, they are run on KVM or TCG.
> >=20
>
> It's not misspelt, is it?
> It's in the wrong case.

Yes, that's the right word.

>
>
> I'm fine with the code though.

Thanks, I'll take that as an Acked-by: you

Thanks,
Nick

