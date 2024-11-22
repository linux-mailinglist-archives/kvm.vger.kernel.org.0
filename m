Return-Path: <kvm+bounces-32332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EBD9D5710
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 02:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AA6F282CF5
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 01:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18921F949;
	Fri, 22 Nov 2024 01:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z07jwAmN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7D42AE84
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 01:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732239188; cv=none; b=hfw5SK2OkwtBwAyeV6Rii9vou8hOyRSNnqhMpioyXQSfwGN/1ASrW6cz0V8HKywKaKlSoHNvBAupN6UNAGi+K2pm/LIOqDA65EBknH+rQ4uSbZE+fuCVcklR1gq/0ky7KmdUi04FyeKQ2LQ1onsZGWgfRvr5k6hH2Oy7GXy74ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732239188; c=relaxed/simple;
	bh=Tm9pvQ9VlB4tTkg3wVWWSuE/8G3iwy3Gz0q891mLijw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PwvoMWewN75DL+Fy0spUxazuBTLcqY2iUyPV/l5zqiHD/EyYXWuCW25mPJr5di4++cbuSGK2GVY/tTqcWvHjBAu+9/XmorBQWbwQob+uiobOlmUzmHEUz6xNQwQnjQ2fnIMePdBR3PnycjZ7U1/hroaZ15yoNl1sl23rZzytUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z07jwAmN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732239186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SZyAAxD55Qxmw0H9YOdPWCnB4EHiww0mRBxwAsYwXKs=;
	b=Z07jwAmN2iAYsgxfTttDHtSxzTWg0StbDfVf5jyFE9CE+5Q69InOS4W2YrG27aPnmzcTtF
	p9TnNfGe0zf/onarhg+xtyeygUsFXiXrzs2YoVVsFKFuH60j+Ip+Q9/naVZ7TXi+XAwzER
	+392rB6Gkk/R3Bns82hkgCkVdFO4bXw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-M2qbeA4uNYyQK3FEg28Y0g-1; Thu, 21 Nov 2024 20:33:03 -0500
X-MC-Unique: M2qbeA4uNYyQK3FEg28Y0g-1
X-Mimecast-MFC-AGG-ID: M2qbeA4uNYyQK3FEg28Y0g
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d40cc92ff6so20855606d6.3
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 17:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732239183; x=1732843983;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SZyAAxD55Qxmw0H9YOdPWCnB4EHiww0mRBxwAsYwXKs=;
        b=t/r52KiwnSiqJsXvx9OF763kKDzuzZ6gd/B9BSzS8sj04ewrg5BPTLTDcNedUdRjs5
         xjfK/gSC4CMhw2yC9MHxVX/nfvN78XKUH8dW8IY7yStPewjlCG07eaOKp3/nUVtvQWlP
         PjQMNFyaESA6zvIbNWenq2Nxo4tDsDhlTYXXw7lrq+PLtXoMg16srDh5hDOXu4HCHpht
         XqZ6WYiC1laNWv69HbjXrcEOeQJ/fxJje5vW5uZlyrIidq7g25tKwOz9uDwn7OKGdI85
         lAj7xGq6+eZY37vgm+nqK29YlB26Kwg1EdEsVakSB3nSuilrfQiD5IYdvzWWN7glgFwV
         Ap6w==
X-Gm-Message-State: AOJu0Yw1Vz5Q9nh9wvtEAlkIVnjqL4rsMvEf6IQcJACtxn07iGZOEl9A
	9IhGixxknRpLp+zptBBqQ5RxDF3fQsGao7yv67NDqPiOWjNFXKODhZSAuKi6U/H30TguQiDSLbA
	16s6FgZXxYmNGOAUXlpp3ft91YhvFl6SS+YiVxKDp5dGmuaU2CNO2qlpTpcGIfg85J188A0jqFl
	3gjbOXNWGQNo28eTlFt1EOMMClOPLAnbffEt11
X-Gm-Gg: ASbGncuOBkxrGnxXix8HdUCwQnAf8RAD7pO6YTJjWvMC/2zVAUu3C5KbkC/LV1F8WLf
	dIaNzPnUxUOFUwbKQxZIe4YW4lcya/Q5cNoUkVLjfk+aApJqbCKxbtEbOY1Uj26z3zNii/8xG4X
	7y9aiGVGJdOhYcHBb2iay3RsuFHG+EZVDV3JmFjnbmnqY8DoewPMKRwp22uQ7F1bE3XjuIPp/le
	Nb5Bs1MsmeP3zkvtIGZAGjr8cPrznWGaY8AebNb2fR+8zOsdA==
X-Received: by 2002:a05:6214:1d0a:b0:6cb:d4e6:2507 with SMTP id 6a1803df08f44-6d450e871f7mr17001246d6.22.1732239183103;
        Thu, 21 Nov 2024 17:33:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGC+Nvhmfx7OYR/Fp69qK/172stztDel8eu7IrOBjCAQax7SG9oOc9omNv410PRTVdVlNrOfw==
X-Received: by 2002:a05:6214:1d0a:b0:6cb:d4e6:2507 with SMTP id 6a1803df08f44-6d450e871f7mr17001066d6.22.1732239182768;
        Thu, 21 Nov 2024 17:33:02 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d451a9a9edsm3909566d6.53.2024.11.21.17.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 17:33:02 -0800 (PST)
Message-ID: <e8aff39851876ffd3a555dea6bd8157833c2a336.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 21 Nov 2024 20:33:01 -0500
In-Reply-To: <3956ad6d2261105c479a68c55acc87bd94ab202d.camel@redhat.com>
References: <20241002235658.215903-1-mlevitsk@redhat.com>
	 <3956ad6d2261105c479a68c55acc87bd94ab202d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sun, 2024-11-03 at 16:06 -0500, Maxim Levitsky wrote:
> A very kind ping on this patch.
> 
> 
> 
> Best regards,
> 
>         Maxim Levitsky

Another very kind ping on this patch.

Best regards,
        Maxim Levitsky


