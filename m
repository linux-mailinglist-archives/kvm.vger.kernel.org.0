Return-Path: <kvm+bounces-42426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91240A785A2
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F341E3AED99
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0C523A9;
	Wed,  2 Apr 2025 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OTIwR5Hp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8ED802
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553361; cv=none; b=OwDLafwqSnrErWZrY4c8SrdOLlImGIJei4nHmRVojgw1FyD4olI7KAjWMOrM2C5XsJ572xDJBG0dDHa6+AL1wFphRUBMrGJai7Q6V+x8AFYz/iVUzo1aDfXGveYRMQqQfoRIVLkNsm9BDbify7RIguyTdVuC+0/4a2SxFp9g228=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553361; c=relaxed/simple;
	bh=7LQUr9cYtT493Os8VKVvc/dUD2Vy7mRBmB7VjZEMhcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPH1QnxX+/NAsao+cdZ9yQKG+9EUOCj6oPXEO1F1DdgEbbtN5+nzvjl2xGFfCLQLGACpqxPf1k4yy5JnsoWyT/3voFXIlwA9NyfX9BzsEFh59687+tJSgCERWUoR7uii26ezTxEGOf/vFci5AJY0k1UvnjvtVzVx0tWgW3dEe60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OTIwR5Hp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff798e8c3bso10124772a91.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 17:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743553359; x=1744158159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fC1QWZ9KoK/zZAyZRqOHikGby9yYJOZ3JWxM+rgHSzg=;
        b=OTIwR5HpCxB+f4z/EYc5f8DtzhMlW5vldosyCKD318YFOJiVBHQNYS4o5rcrzaJuAB
         KhFLBvJ8MLUytfJ8R3IcmpF8h4StyFE/ZIJSyEuPzwPLYkCALpZSNrEe+cJQ4Ln5czKZ
         dHYv+wSyQpv4mCWullHzOiGalIb51cJp7bXL5QDNAPQiuArO63mrIyhNqkcFuKvUgeeu
         KbYQGGNyP172r9PPT79G3AIqqfhj8qPqJCQRLsSiyj+nCdhXcS24UrQB+UPI22l6HU7n
         K03njjU4M8VYxeXb95sRavQA5slAILyYOnbRkzd9ZRBvqjtUF+2Q7EJ7BMK3lCKqQLC4
         Voog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743553359; x=1744158159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fC1QWZ9KoK/zZAyZRqOHikGby9yYJOZ3JWxM+rgHSzg=;
        b=r1JyTB2pQ6If5nTGHbmxD+HWia0TRyAXE4s8ll8fqkqXUL/GeKrA1mNQ7Tj/RPLW83
         PcpmZsQWGrcoX5pYAVE+jc68CFMtPFnTUhImi5C6HxkQKwd+nvraSqxXXywDKWGt5rj9
         g8NW7TcIoHO8NP1rNlojRUxNOcotZ4DR417Jc2CXonW0HSDYSvjsW6n7vjIUgF9b84S7
         1oQCTIVkLKKF+rQTZZ0rXyb5WS2eVUqVL9aPICzho5MNucOymSel3z2/c0WoWf/iRR8T
         RrRrfkpCibFFR4WquEnBL5sLPrqTmnTR3jaQLWTHC7DE1/OhKxRyco47jaKK2pc//z8p
         QbYA==
X-Forwarded-Encrypted: i=1; AJvYcCVmbJ/ARyagalyENTOjxLSd/pWHGqcgK899CTL78fd7rZsOmxvFJ4dXuv9xC8WgY6tjppQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyZo6LuLChyZbYvs+HvSiW5h0SprcuhUOIpkY5S9gMPCBWN8rT
	hMBacnNGlOT+Op5j2LxNg3tJVDhf94ynU6CKSrxDVGgNL41pRf/ANqUKvzZbFvflXLXlkVqv3Yk
	ISg==
X-Google-Smtp-Source: AGHT+IEI2FjqSQlgyOXVWtopCKGmKbmg8oOBwTnVpB+jnl2r6bZ2xGzFksatMXVNA+xjFscEpYN0ZcT+Ikw=
X-Received: from pjbsj10.prod.google.com ([2002:a17:90b:2d8a:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1347:b0:2fe:dd2c:f8e7
 with SMTP id 98e67ed59e1d1-30531fa4d65mr23357949a91.10.1743553359450; Tue, 01
 Apr 2025 17:22:39 -0700 (PDT)
Date: Tue, 1 Apr 2025 17:22:38 -0700
In-Reply-To: <Z+yBGgoqv3dcgfg6@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401221107.921677-1-seanjc@google.com> <Z+yBGgoqv3dcgfg6@yzhao56-desk.sh.intel.com>
Message-ID: <Z-yDTv-T4PTm9uHU@google.com>
Subject: Re: [PATCH] KVM: VMX: Add a quirk to (not) honor guest PAT on CPUs
 that support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 02, 2025, Yan Zhao wrote:
> On Tue, Apr 01, 2025 at 03:11:07PM -0700, Sean Christopherson wrote:
> > Add back support for honoring guest PAT on Intel CPUs that support self-
> > snoop (and don't have errata), but guarded by a quirk so as not to break
> > existing setups that subtly relied on KVM forcing WB for synthetic
> > devices.
> > 
> > This effectively reverts commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
> > and reapplies 377b2f359d1f71c75f8cc352b5c81f2210312d83, but with a quirk.
> > 
> > Cc: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >
> Hi Sean,
> 
> > AFAIK, we don't have an answer as to whether the slow UC behavior on CLX+
> > is working as intended or a CPU flaw, which Paolo was hoping we would get
> We did answer the slow UC behavior is working as intended at [1].
> 
> "After consulting with CPU architects,
>  it's told that this behavior is expected on ICX/SPR Xeon platforms due to
>  the snooping implementation."
> 
> Paolo then help update the series to v2 [2] /v3 [3].
> 
> Did you overlook those series, or is there something I missed?

Nope, you didn't miss anything.  I have that series in my TODO folder, but only
glanced at it when it flew by and completely missed that it quirks ignoring
guest PAT.  Not sure how I missed the cover letter subject though...

Anyways, ignore this, my bad.  Thanks for the update, and sorry for the noise!

