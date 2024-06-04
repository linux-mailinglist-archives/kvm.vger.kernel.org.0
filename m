Return-Path: <kvm+bounces-18719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 763778FAA04
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB6CC1F221FD
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6E313DDA6;
	Tue,  4 Jun 2024 05:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcKFvKlI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D013D2AB
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717479153; cv=none; b=EI0SWbw+AheP3UZJv8lUGDJJtHC5+OXWrDDUWwmp3zBb+Mo5gwK/Nmfm+55DEPHBjr5lawjApnUQ6uhlJytxxhJPW2lvjnGN+tTGISrC12SWqo1VLSHGfDtbkTO9cZd54PJ9o3f21jrrf5gRiYcagnBX3oe6VKMt9wpRfh5k46g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717479153; c=relaxed/simple;
	bh=gSkLZUbj+hY+zPitT1Z80EwzQFv54UajjQE4BIUsGqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCaSre8Q1Sz98aJiW5L+jtVoiLEmcuqJflSu13Q15bBK0Ix93a69QA3cOwe/u3dou74Py/b0EWgCGH3SBZAsWWs6NBTRnHWKI7GSrfMknrP3ez8UfOQCW9RnRVpqm94jY8xj0mUGhGv8lZ5IgZQ4EJNd3HLPXC/ls8Lo4i+b95E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcKFvKlI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717479150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iLcI+kyTAVcvV633tbUK4P5csgI4BduppvW67gAgjyQ=;
	b=OcKFvKlIwIkG5EV3Wg+S9hJiesd4q5awXSusJScweQdx69j5ceXv2IHC009pQk5ec3syAA
	HGmapgIMjXDs/HaZGppkDSHJ+X5rZkciGGr8V6l+p8MQ5x9Z2sudAvE9oBqY6EzMvfHr47
	J9geNfLyH6KZavn3itI+2+jUGF5NZFQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-sDcXcH9vOMiTziW33g0Q-w-1; Tue, 04 Jun 2024 01:32:28 -0400
X-MC-Unique: sDcXcH9vOMiTziW33g0Q-w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4212b505781so23109865e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717479147; x=1718083947;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iLcI+kyTAVcvV633tbUK4P5csgI4BduppvW67gAgjyQ=;
        b=hwxtW6dSWJoR71XzbNb9YSbRnstApZseuf02BrxMfSeonjIGIbn2uOJT9G04rPiC1L
         ttlIJFtJIQNvoLxkj0zfGXsSnyvMB1C8xDfdJbdTvnfMM5ooKONlH9Y0FkHKp8B36tMn
         RzTByg8pGR2M972xE6cbL0ccs6JsYv7WE1DNZNAjncCYOcgpSUcSxOCykZOTPrcjeVW5
         +F4lOC4xcMx2l0ilMvsjXbTvXTD/KTxgP8Ty0cA5RHAnkABySsR22Zac7oWaTHi8Y7e6
         fLuekgUsGGY1SQJlkljxohUjqO7IvuW2Qwss7xjJdZWmQHxs+tAKl1ziGgu7MFZVUM81
         44+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMdAhqd4xG7N/6i/3voJN7D2Fv2LoyJoMFfcWMJXKUgtmgKGNq8tnSR6GFHFs8JbDgsxwv0GOgwWOgKhMAXXX9ZGww
X-Gm-Message-State: AOJu0YxqCzZ36kIxJmGl+2BfiypyVyv8Y28kiLiSS6+UyLKJirTq2h0I
	MaY2li4lnMspI0cUjnPBcra1LYFXjfWzCmgFzb30vedrMxUrU4KnuOJFEc0v0zZ+EV+JKHBveRF
	0VpZo9fCDRnaTibwpKsJi8tQuwrG1fy5GJUzbvl8zSnxzoAbhLA==
X-Received: by 2002:a05:600c:3ba9:b0:421:2a54:2f22 with SMTP id 5b1f17b1804b1-4214511b763mr12634375e9.9.1717479147468;
        Mon, 03 Jun 2024 22:32:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnJ3KPRT7ng0O8UyK86E0pZ8h3l8VtU4REoNfIN/XcocGoazQCYg1AgHxvvzrvU7lxBBXCog==
X-Received: by 2002:a05:600c:3ba9:b0:421:2a54:2f22 with SMTP id 5b1f17b1804b1-4214511b763mr12634215e9.9.1717479147060;
        Mon, 03 Jun 2024 22:32:27 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4213f3abf1dsm44589215e9.44.2024.06.03.22.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:32:26 -0700 (PDT)
Message-ID: <0c987c3d-1fff-4eb0-a0c0-e710f06d47a2@redhat.com>
Date: Tue, 4 Jun 2024 07:32:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 0/2] s390x: Fix build error messages
To: Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, =?UTF-8?Q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 kvm@vger.kernel.org
References: <20240602130656.120866-1-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240602130656.120866-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2024 15.06, Nicholas Piggin wrote:
> This fixes some non-fatal error messages during build. I have only
> tested TCG with no PV, so it's not intended for merge before
> that at least.
> 
> Thanks,
> Nick
> 
> Nicholas Piggin (2):
>    s390x: Only run genprotimg if necessary
>    s390x: Specify program headers with flags to avoid linker warnings

Thanks, I reviewed and tested the patches, and all looks fine. Thus I went 
ahead and merged the two patches now.

  Thomas



