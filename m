Return-Path: <kvm+bounces-11577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CC987862C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43FA11C22232
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A974D108;
	Mon, 11 Mar 2024 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="OgbHhtDy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DD729A9;
	Mon, 11 Mar 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177345; cv=none; b=lC0lz3C7jSir1EgpdI2qfiiPp8x5QJJiKZZAneWa3QyAxbgqCw5m2L7It2MCulUbs9nqriQXK01AeMsLW3A9P3Y+5ChAU4aKReN2qHIApxtiXEMXNKc1IJxaCq4/hSlyeU775hZHn6rCPkZ0NJMtWh3jjBiuY0waTtTazJSkf+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177345; c=relaxed/simple;
	bh=iVIU6NFyJNWSLU77UYtdSmBL6fAO1vYpAxCZgvTdLS8=;
	h=MIME-Version:Content-Type:Date:Message-ID:CC:Subject:From:To:
	 References:In-Reply-To; b=GcBKrOqSF8G/ngyWSV5QtWArG3gPD6lf6FzIJZqjlQHu919jJCQTcp1NqY6sOTFJ9/DprCGzMZJNcwrLT01LtBVSAwBrk/wfUaiodd4iqOE3rrrozqljm3ttZHMnT9VI+JcH4zc22nRR81ys+iBD4j5savu/19yh8HzFQw8Bz4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=OgbHhtDy; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1710177344; x=1741713344;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:subject:from:to:references:in-reply-to;
  bh=iVIU6NFyJNWSLU77UYtdSmBL6fAO1vYpAxCZgvTdLS8=;
  b=OgbHhtDyMDj2FADfMOCJiGRWs13qJ9NY/pDHHEpaJgRDQ1wzhiUy9PPk
   HbC1/Q4CxVJMILHPbIuq+6xCIDJmW9G0i4RN05u4lxL7KIFuiqddi+LLw
   dxoinm/R8fwl2SQH0VmA8yPC1c3LSYgX7S+QRrdcGrq+J536b0XZN6tB9
   8=;
X-IronPort-AV: E=Sophos;i="6.07,117,1708387200"; 
   d="scan'208";a="403096272"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 17:15:36 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:19422]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.37.30:2525] with esmtp (Farcaster)
 id 8ca03e87-99df-457e-b513-eae1e534586f; Mon, 11 Mar 2024 17:15:34 +0000 (UTC)
X-Farcaster-Flow-ID: 8ca03e87-99df-457e-b513-eae1e534586f
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 11 Mar 2024 17:15:34 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 11 Mar
 2024 17:15:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Mar 2024 17:15:26 +0000
Message-ID: <CZR39LW50A9F.1DWG2FYJ3OZP8@amazon.com>
CC: <jalliste@amazon.co.uk>, <mhiramat@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rdunlap@infradead.org>,
	<tsi@tuyoix.net>, <nphamcs@gmail.com>, <gregkh@linuxfoundation.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <paulmck@kernel.org>, <nsaenz@amazon.com>
Subject: Re: [RFC] cputime: Introduce option to force full dynticks
 accounting on NOHZ & NOHZ_IDLE CPUs
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <frederic@kernel.org>
X-Mailer: aerc 0.16.0-127-gec0f4a50cf77
References: <20240219175735.33171-1-nsaenz@amazon.com>
In-Reply-To: <20240219175735.33171-1-nsaenz@amazon.com>
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Hi Frederic,

On Mon Feb 19, 2024 at 5:57 PM UTC, Nicolas Saenz Julienne wrote:
> Under certain extreme conditions, the tick-based cputime accounting may
> produce inaccurate data. For instance, guest CPU usage is sensitive to
> interrupts firing right before the tick's expiration. This forces the
> guest into kernel context, and has that time slice wrongly accounted as
> system time. This issue is exacerbated if the interrupt source is in
> sync with the tick, significantly skewing usage metrics towards system
> time.
>
> On CPUs with full dynticks enabled, cputime accounting leverages the
> context tracking subsystem to measure usage, and isn't susceptible to
> this sort of race conditions. However, this imposes a bigger overhead,
> including additional accounting and the extra dyntick tracking during
> user<->kernel<->guest transitions (RmW + mb).
>
> So, in order to get the best of both worlds, introduce a cputime
> configuration option that allows using the full dynticks accounting
> scheme on NOHZ & NOHZ_IDLE CPUs, while avoiding the expensive
> user<->kernel<->guest dyntick transitions.
>
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> Signed-off-by: Jack Allister <jalliste@amazon.co.uk>
> ---

Would you be opposed to introducing a config option like this? Any
alternatives you might have in mind?

Nicolas

