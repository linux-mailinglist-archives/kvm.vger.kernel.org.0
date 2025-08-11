Return-Path: <kvm+bounces-54440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D573DB21619
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 073B8626265
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9589C2D97AB;
	Mon, 11 Aug 2025 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DgxlaLgX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5210E244685
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754942458; cv=none; b=Dqrn9Cmm4ijI4qkTx5PUxI7pGV7o4j97ls+yuRvI2A8S96kMqysFdb6vsbzObeQ8esaXwdr7wUd+RcTUzMwc0/T+q0N6RSKps6I21lonw38PDmsLY1683UwYSPEGMMWta8GSrWDAR3zxoVwSZIRSARNJC/SH3f0JOXwcfAcSExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754942458; c=relaxed/simple;
	bh=L4YXtkQXfZckaIdKwKMsKAjJ8efy4VJnuMEL0sTzy+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pz7Mckz6EMrgF/e/BuUioxWLeuee5kc0RuihvnNr2kcuykj0Fw6loCIMxMVCkJoT2LRF1A3Aio2VXGBkUc9YZuTCGQ2NyTrXPq8zPAG6QH+N/I4JGbwKNzfq2iRm+osaBqICermu9vIIE1mDgeggw3euGBeKbKfXnR5WygiygmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DgxlaLgX; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b0bf04716aso13691cf.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 13:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754942455; x=1755547255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDMpYVLhya7xt6pcJRlpQYegHBJR2O2i28Y3lt7//0w=;
        b=DgxlaLgXDcC1u6N2FFVYN1yXqsox0157FBS4OKEO0tTAspWIzkUrhqlyLeI1ZCqQ1I
         +Tj7446UyOzMirvnAD0/n18KOrTJc4GstAZkmLOGJT+7Vx6hD44ciiD1lGIhgSXxnyX4
         I4P/EDEDfVFf8cYgw4nyBbbINRHgkZve/OyCVNY7IdceOs7ziwW8+uyQVdRJuFtrIVOm
         5/vQzwUqqBYfa3I3+Wkl0vyZjfOYcQbjG95RtarOp26tpee07snDr+DFnkF4IYOJx3HS
         If1h/CqYlQnbAoYsTtWXXGgShYMiFUzKRBYX7nSpKIKkH5GpYh/12wu6qnMl0YbCS6IR
         B4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754942455; x=1755547255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDMpYVLhya7xt6pcJRlpQYegHBJR2O2i28Y3lt7//0w=;
        b=RMq5zYtaPzzFXLYRtLnheHa+AaDXw7LPHGQFYlkL6nOrRygxEf94Q2nJLNXMpQnDFT
         bWFj+VXPuYqfOqu6AR2clSlqNaE/2/n1VV6Oa/v58KH6TaEgYuKi2pRsLbUzZmuS63cC
         nDwvF0YU5gQZqLr+DRpKiEPKcp+1tMXotoFz+K4nkJZZNJ2sOTBE6J4ISu+UqZodzXoL
         YGmTgMMpW3Ii3FXHpl/vCiVD7J8akuFH5HGjSm0yNMBtobr1/ZRn/UacLCAZN21026bh
         +DqbW9WLoQzAR2cdIZbFvVBYjTCaKQ5mHWDYkfhk5SZeg0dGKLhvAbjwfzpkI4Vq1nCw
         qosg==
X-Forwarded-Encrypted: i=1; AJvYcCVTC0O3ufZfWPuWoXdg62ajekaZjM2TFYtdnUHiPxBdejavU4uh06vberxLI9nOCUgfTIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyEVgloGW+OIPlQIjJ57KxHFlK4hRCNzOTYlTkDpYswEWDtiJL
	JhI/WyzpBDbdfHOfb8QOf0scKEnij3YQwSCudlxjHvIsnxDgWxIWPkpcZMGI6SpR+aj/BzP2ctw
	fpMSgq/2V7+lmuIReIoyMfYeGaPENjJZpinmVl4jI
X-Gm-Gg: ASbGncvWUPqxtT2PTlnvZzrkg5wG3WfOv8zpqp1IAv9ReORTAHHkdh+rHN/RPx0/ji+
	GFhxdmdvutiqHGnzUIZl0zQX9N85pmnbNDlFRZ1RA6PLonE44YmraHEiDkeU5Jp/r1+IFi1tQjm
	WjuIGzCWhyyBZ6R6XgCn2risgdBQJa2VA9m26a+IqRjY9ywGP3fdZyVys2MaCzpnGxhcSR+TjIx
	STDKImtasPxXr1OjmuT5rWEy0fNrhfSil6jSet4lsxyiFSAWw==
X-Google-Smtp-Source: AGHT+IFnZ7fy1xwedpAUaDyXANbyoUaCqbxMXnRugbDvj2BgwPIs5z0a4CpRwliBrgHuoskcDuY4uhxOKTqPW4PVJ7o=
X-Received: by 2002:a05:622a:155:b0:4b0:82e5:946b with SMTP id
 d75a77b69052e-4b0ed6f6917mr1098121cf.4.1754942454725; Mon, 11 Aug 2025
 13:00:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <aJoqqTM9zdcSx1Fi@google.com>
 <0976e0d50b1620c0118b8a5020b90f3959d47b4a.camel@intel.com>
In-Reply-To: <0976e0d50b1620c0118b8a5020b90f3959d47b4a.camel@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 11 Aug 2025 15:00:43 -0500
X-Gm-Features: Ac12FXxtecFo3JBHw9Xp-7a0InhBFaCf7hmpSP4xc_TquqGEkQU-IMkjUJoXAjY
Message-ID: <CAAhR5DEG=Z_5DRGXcdoL0cxcSyuTqRGjixsGunDqtV=YtraOWw@mail.gmail.com>
Subject: Re: [PATCH v8 00/30] TDX KVM selftests
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"Afranji, Ryan" <afranji@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"Chatre, Reinette" <reinette.chatre@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Wang, Roger" <runanwang@google.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 1:12=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Mon, 2025-08-11 at 10:38 -0700, Sean Christopherson wrote:
> > Please make cleaning up this mess the highest priority for TDX upstream=
ing.  I
> > am _thrilled_ (honestly) at the amount test coverage that has been deve=
loped for
> > TDX.  But I am equally angry that so much effort is being put into newf=
angled
> > TDX features, and that so little effort is being put into helping revie=
w and
> > polish this series.  I refuse to believe that I am the only person that=
 could
> > look at the above code and come to the conclusion that it's simply unna=
cceptable.
>
> We were talking about this internally. Behind the scenes Reinette had act=
ually
> spent a pretty large amount of time (the majority?) cleaning this series =
up
> actually, to even this level. This was some code cleanup, but also functi=
onal
> stuff like rooting out bugs where tests would give false positive passes.=
 But
> the plan of action was to have some other TDX developers start reviewing =
it on
> the Intel side. I was also wondering how much time Sagi has to spend on i=
t for
> follow on versions? We might want to think about a more direct process fo=
r
> changes->posting depending on if Sagi is able to spend more time.
>
> But Sean, if you want to save some time I think we can just accelerate th=
is
> other reviewing. As far as new-fangled features, having this upstream is
> important even for that, because we are currently having to keep these te=
sts
> plus follow on tests in sync across various development branches. So yea,=
 it's
> time to get this over the line.

Thanks for the feedback Sean, I really appreciate you taking the time
to review the series.

I do have time to work on this one this week. I'm hoping to send an
updated version by the end of the week.

