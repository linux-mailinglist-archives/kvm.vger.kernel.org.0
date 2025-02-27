Return-Path: <kvm+bounces-39585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 052BBA481CF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99EE919C1F30
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84FD2356B4;
	Thu, 27 Feb 2025 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tlDrLlQP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9971232367
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666662; cv=none; b=nh/TcOgcJ49HWp1Nagh5jVjAytkUOy88cZSULBY5mTHGAnlbbIgZ13P4jaK9n5sECH6zzRy8iKK5OBegkb5XCRSKBEa1RhxEa387bEwzeeFfxlzH9WiYduQz9Ba7BP6kIKyLKQA0fKeEnCGnvy0TkcEPHuxunf2oTOmKGupgB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666662; c=relaxed/simple;
	bh=TcY8I0aBWWwbvIhRVEZCFrgBV1txXYPMWwRUkY95OSk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DYD5/KYjDeFGeGeRM/6NlwtHf2BAJjV+Kh/eWntwuvITvSzSceszgs2/U7d3YfXnGsGd3h8SlOOZ0/j2YBCwkQxhquu3dc6OvgOwMQv9AW5944F6YM6WuMLjAwr5RD05x0RG1ZJEE+MIv1JRbYZZUY/W+oJHyc4DV032Df0FZYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tlDrLlQP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01e2bso2242000a91.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 06:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740666660; x=1741271460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/BYwe2IugO2DWfvdwgV6MhO4KxmKJ8dY5lREV+02bg0=;
        b=tlDrLlQPUVhxO08hEnSFOaGmTIc1oRY+iicheqSGCS7Njfy+zeR4KPvgUhw4N3XvCv
         PcE8h30crGcx85lsK/0ZvbLhhzmhuBrrz2xPbCmoeRqjN+PKg20LpkJSPEse/hiuw9vn
         +AiaM86Yw6xiL9gy+07bQq08rQDsxVkpmNgzFvxQmg8L8Rx9o4uJg4hnuBZaykr1xjCU
         qBsiY+m/cNg1LRGvnkXYL2Nm85wbXkvN2kwOjAjYcVnI1WxTwzD0H4PpmVP1d5dzIoSZ
         PecKoke0ZfPBQUqCXa7OF795WBMY8zhz+hThu0E0v4pRH+BVxhR3NaZ/bELTdso1/ddc
         77sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740666660; x=1741271460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/BYwe2IugO2DWfvdwgV6MhO4KxmKJ8dY5lREV+02bg0=;
        b=bDYOxJvYsZG6UHuF6wApvINdcCMQLNqt44BynOsKbwjEeVjMHgKpmz7vD+Wo86qmjf
         VpFcSuW9yppKn/0usQBkQsGZzDfim4NkSqFpCPzqfaJvzSvFnPeF260xjfA1kzAKEK8Q
         Ght9UgyIXfRcVdRwBIG/P4Vl3Q9zDnBOQIH6FasUlePnQM3qFpqjtNC5G2TKHtGsMj6e
         Txb2I7V0s+IfLoCn3HWTpXLpnXa70fuIu9ZlrX+DjwPVsO58SK6ARtud9+D6amjJPnpp
         0jxuigxBaGm4ypSROv9xbuo0jqjDAfJbqV0oWwDW3WQIb2wEH04HkNbT1fOQzv6qTOdB
         GVdA==
X-Forwarded-Encrypted: i=1; AJvYcCWvGIWpYJQfVNmKgDxhBMkf4oBtdXc7W3NQzJOjuNWYCnSaHX1EIzR7C7AfErl3PSuyo/U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4wGktjyzA/HIHyDCTc1wrxvjLA28azkx7Uzboocf17IT+BoEi
	oezdjrJWeYKYASYJyZ4mX0RYUONmEGrshQ6vMHcFOjQjiwi+ZgC4zkMrg/GGJHP3MllFYkPyzD6
	7Zg==
X-Google-Smtp-Source: AGHT+IEHXMKLhKy4AekC0miRv9oCxzQ0iAUerHTQpPQKorolelo+UjobEgU72Wcwpwa0Yjm+cH9EclQbehw=
X-Received: from pjbsg17.prod.google.com ([2002:a17:90b:5211:b0:2fa:2661:76ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d87:b0:2ee:f076:20fb
 with SMTP id 98e67ed59e1d1-2fce86cf0b7mr46370564a91.17.1740666660022; Thu, 27
 Feb 2025 06:31:00 -0800 (PST)
Date: Thu, 27 Feb 2025 06:30:58 -0800
In-Reply-To: <1fe17606-d696-43f3-b80d-253b6aa80da7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com> <20250227011321.3229622-4-seanjc@google.com>
 <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com> <1fe17606-d696-43f3-b80d-253b6aa80da7@amd.com>
Message-ID: <Z8B3IvwtGqz8aCHD@google.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, whanos@sergal.fun
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Ravi Bangoria wrote:
> > Somewhat related but independent: CPU automatically clears DEBUGCTL[BTF]
> > on #DB exception. So, when DEBUGCTL is save/restored by KVM (i.e. when
> > LBR virtualization is disabled), it's KVM's responsibility to clear
> > DEBUGCTL[BTF].
> 
> Found this with below KUT test.
> 
> (I wasn't sure whether I should send a separate series for kernel fix + KUT
> patch, or you can squash kernel fix in your patch and I shall send only KUT
> patch. So for now, sending it as a reply here.)

Go ahead and send the KUT test.  They two repositories evolve independently no
matter the order, just put a Link to lore of the kernel fix/discussion.

Thanks a ton for writing a test!

