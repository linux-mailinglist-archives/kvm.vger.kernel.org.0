Return-Path: <kvm+bounces-34022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C7F9F5B29
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19BE77A3C6F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22DD224F6;
	Wed, 18 Dec 2024 00:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5Ix8pLP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBF3849C
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480548; cv=none; b=JLCv1W17UAbtkfPJanMOu4t0Qq0LmfcjTcZiPXOH2OC+EHCDeI+m7gIzZESDHVoMF5xbddtWizQUt9uJghP8G9Wj7RXd6lX/2CtNqOej9dzBhlgQKtrWg4YbYrP9ORdxnC3+H+yfD4JFB5U7QEhdWrmI+uNuaiNbgU3NmNbBZqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480548; c=relaxed/simple;
	bh=maz6mAWvYwbk48P3WA8V/jv5oEub8t4Ectql27nwmdY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ltsSbWFTJRuLPZMWX5wKcxdw/x4qsoWZrBIdpVQq0CfB6eRdoTwgEpiQkFfBH4pS0KDywaqwLPZebA4bWlwqGqTKmN+d7+8XW+FSu0YqVbqQn9YD8lQJrKyN1bg1OuwhDxq6NhPJ5oJLQHBTKcphH03gaXRbncx8KV24IqIjMG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A5Ix8pLP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7MtW9s2teTuFDUxpDTdJ+zYSenFvfd6pGdcA6rRzQ+g=;
	b=A5Ix8pLPnerkcHMcCfVWvbD+yZPOPlk8Y0woRA8+7bNgMKMt0zqjID7//C6ZWw/rVhHkiR
	WI7jiPr9KtdFBeRQzN/0ztmmo/zlqE6J5N7L3LgpKvem/l+atXxcdN0m3KVzSLOkePI5RF
	SxHdddbQpRUr4rKxDgu9xM5PIg+r8yA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-nckD-X_SMZaR5nF-Tu8z6g-1; Tue, 17 Dec 2024 18:59:09 -0500
X-MC-Unique: nckD-X_SMZaR5nF-Tu8z6g-1
X-Mimecast-MFC-AGG-ID: nckD-X_SMZaR5nF-Tu8z6g
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-844e6476ab1so853863239f.3
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:59:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734479949; x=1735084749;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7MtW9s2teTuFDUxpDTdJ+zYSenFvfd6pGdcA6rRzQ+g=;
        b=X/WJpmshVlMxIGdPt1thXEYxUofELXvRNgZJtMtWmdlKfxjzVqwHxFZLTSY2zPKZ4U
         EB7bQyandOsweNqUxSknJ4lv5KWTEpTgujuFkwj1kMleaPBUWfdp6v1ZDaZc7cZwmEAs
         qOYMpjOFPWq/5Q3r+GZhu9Ob3kqhDxekgK7pqMCTnJLJGEmFOyRCIKhg8uygjmKJ7Uq6
         6CvvMEUxYuX82TW1tfMgtQyQQgi2fxtG2FDVtS6+j8GEIJBTRvtfDtIliovSmBzT9k+I
         601QuNUNWCMVYq6q4+qD2kx3AEnwHGDGNVxYElh1veC5s47mPKB8f0Xk7MrW3op7/lQe
         wmoA==
X-Gm-Message-State: AOJu0Ywj1Q5l7G+OF8aSA/ySWZ0LfU+R2QJR6a0FB4VUvV+D1NrUqLSU
	JdCS75lP95aGdGp5eCHpsQ5vcuOOCNqoXcQgz2JTccCGRcuOxMzOebGagwuJib123rr2IWgZwbz
	aVV/XEuZ0OXpnJpx/cAGFAWILgCzPydGlvtVBvrdOYLmbwHTG2w==
X-Gm-Gg: ASbGncsi8o8+k0Sx1kwL897pYYNg74Ykc7UK8QJ9bz/MZscu+7FYa2mJ8Fx+Q1/c3xo
	YokP3bPe1Hp0zFXXtPxJvuJVivYUKnJZHITv/B9p49a399Fte/fCFoG3BOFoWauLcdETRdbpVAO
	OtiJrxoyE1a4lvk1uH2ugdH2+PVd9eobw2hzOguDWRazOFK+RJuv42jRPbDbZah9YeghQSnjNxS
	YvX8/6yrmF0HIARKQplA7z2sL6KGf5LUnalfGQGvYlMhYNmvLCwytST
X-Received: by 2002:a05:6e02:1561:b0:3a7:7ee3:108d with SMTP id e9e14a558f8ab-3bdc51018e5mr9386235ab.23.1734479948958;
        Tue, 17 Dec 2024 15:59:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFpN1YyVZPKQZ5RHk5t/Y7Jo6HBbN5WILfiTq4LU4xsteP9+pjbAR5fNG1UiXn/IIZwsLEQQ==
X-Received: by 2002:a05:6e02:1561:b0:3a7:7ee3:108d with SMTP id e9e14a558f8ab-3bdc51018e5mr9386065ab.23.1734479948679;
        Tue, 17 Dec 2024 15:59:08 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b2475afae7sm23823745ab.13.2024.12.17.15.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 15:59:08 -0800 (PST)
Message-ID: <3b843cab5ec50f5c1c76c84f36e79fc3ed37b492.camel@redhat.com>
Subject: Re: [PATCH 04/20] KVM: selftests: Drop stale srandom()
 initialization from dirty_log_test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 18:59:07 -0500
In-Reply-To: <20241214010721.2356923-5-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> Drop an srandom() initialization that was leftover from the conversion to
> use selftests' guest_random_xxx() APIs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index d9911e20337f..55a744373c80 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -891,8 +891,6 @@ int main(int argc, char *argv[])
>  	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
>  		p.iterations, p.interval);
>  
> -	srandom(time(0));
> -
>  	if (host_log_mode_option == LOG_MODE_ALL) {
>  		/* Run each log mode */
>  		for (i = 0; i < LOG_MODE_NUM; i++) {

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


