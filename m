Return-Path: <kvm+bounces-64941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81933C927A3
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 16:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5947D4E2E27
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 15:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BE328488F;
	Fri, 28 Nov 2025 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REIDaUaU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3F2236A73
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764345063; cv=none; b=ZkSP/hGm9dTcYS/nTZEadbs14AbUvZCmUjdYJxbWhmLd5iudZoFcFGg83IAm93YVD/WuWbSogUF93Juk7vpp4IFpcYX5/BYtrkoo/d8YudfaYacfpLg/0nBcQafa51yaEQXu1/3aIm7yZhYY04hoc/9q/S9YJdBpWMe/Z6i/DfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764345063; c=relaxed/simple;
	bh=MGtL6DfpEfB/mkAXzLzzie/i+p22c/hsHzJYktd8RzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGAkZ+UGflo7qoitY5/N9044l6oiXOt4ChAhlazFFK9YDBrUh4qRb3xbhUq+avhONaWnDv8YrJGYMxBilXXvd/dPoJc6RO8ojNP5OZzyzfWgC+AXL++67s7Oa6Jm4PwKiXiFnalusEElILVA/MEUeV54YIjUVd7LrxhLql617Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REIDaUaU; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-29555b384acso23559725ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 07:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764345060; x=1764949860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P61WKJnqyh8/Q+jWB9OZ6DHYmVs1u+jLgIH+gZ1ifWY=;
        b=REIDaUaUqcK9gN6uRpXDMYDFlBZZbLmjufKjW66gKJ+MMbzZXG5CLtLhxHdNRa2skM
         GSXkVjt0N0jjNw/1KXhSdQrr5IzFF1/Hkn2Vjg8xYLCKGGg/48uixSAQM5Lq+1o/o8Ez
         c/DWKqFYACOVxHrI6Hq89HKclWHmLMAzvzFpMBGWACG67LchHc28TGf92tN/2PxhMVu3
         KUWKrE03pd9n2MgH7yOmOoOjr2VPMRvQTSj5NBj3tOcrbezAj4BuX7/P4mgpSthsg+ii
         xNNKnMu5r3kzFGjqKfGGWA3utyAeQtSUrxVKJ22hG2drr9Ky0AC2HaN101sydM/PQ/Dw
         6m2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764345060; x=1764949860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P61WKJnqyh8/Q+jWB9OZ6DHYmVs1u+jLgIH+gZ1ifWY=;
        b=hzLR7yfQhtkrJKQ51mU52PSMomdnl1o1DBVg9BizzrmQjBufOtRHRV8cYngNcAEJMz
         KllRdg8aU8E5Ha22ZidMkB91s3y4s+5Gjuz3wufZMmnXWRRXI+q1l0xWKPJjOqzK8RzE
         vafT9GeN4aUIygcB77Xphlr6VlzQYjxucswazJ+WbyoV0SeBW8VB8nm80TLxHRg72Ony
         NBuAtsQtLgfD85uHcsRlmVV/arPCUfawSqZAOBw/svpQgtGWLDYlYeu8szRUc3ntsSJy
         WUVGh1uNogc6Qro0GFQ9PWhRKgCHZ/i/zF6WcsBGudlbpdiOjWdxceZi8ADRa2aRkT+2
         jyCw==
X-Forwarded-Encrypted: i=1; AJvYcCUpeIj6327aXZia4l2YNuETIa3DQoqnati3GjJhSCoKQzxWpI1n/FcgGpEmq/vRhM+HIY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YydN9lmZUYiz3C+BKodlNOBWzcarS6mGQ0OWEXy+kx1jV+Udc88
	lSIZMb69VLs1Om4Uw3YDPU0ozvMkyj7IvSsZgO+HXRc7jZJfI6NS+l4Z
X-Gm-Gg: ASbGncuKREHJGeYe+AGHKzAovSICmTeVOa5J8IuhrwJwNK3wjUKGXmI6qu6sER8YBeb
	7e9CW2cQVrmfQUlSzhNiGT0eRjyj526J17jB4FveK9CiRKQuytqeA9QkIakY9v8Hp6hVqFE5gSS
	v1Zip2qKVAL7mGBQmTIKUWEV9WEcPHjqqVoSnvrUJ9N505Bbj0sJKKW4baM4uuqaMutBnlMp5yG
	pqYqQI9bkV1ZIijuxWy99JZboWVMG9NDaQG/aHs9/G9hC3Zp0ctoHryr4/33iH+bo+Qewa5yKkR
	86hEIwFzsxw2s8IKlVf6dZoGyl5HwfxMASq6Qu+u94dBsPTMwHkeKW84B3PAOpYPSBwCDj87YyJ
	HCBD9gq07A9SWkDHU79HByVxtD4cEBG3n9Tl5Z5Jb0PvBWWcZI4tneFTOEgNqMtzTuhXkj6Yosp
	A6L79avAN/gaK3Mk97vbkBBSeXWyGhTA==
X-Google-Smtp-Source: AGHT+IHDXjnEWiD4Ij3Aoqmu0wuirePC/DePO6Ksg/pXsaBSBRnUOru5vuneh2uWo3PUFH/miirhXQ==
X-Received: by 2002:a17:90b:4b8c:b0:340:d578:f2a2 with SMTP id 98e67ed59e1d1-34733e4cb74mr28454632a91.6.1764345060177;
        Fri, 28 Nov 2025 07:51:00 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be6ec21e044sm2533746a12.12.2025.11.28.07.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 07:50:59 -0800 (PST)
Date: Fri, 28 Nov 2025 21:20:53 +0530
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Include missing uapi header for *_VECTOR
 definitions
Message-ID: <aSnE3Q4kDAjIrC9Y@fedora>
References: <20251115110830.26792-1-ankitkhushwaha.linux@gmail.com>
 <aRs6EbV2gnkertzA@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRs6EbV2gnkertzA@google.com>

On Mon, Nov 17, 2025 at 07:06:57AM -0800, Sean Christopherson wrote:
> That means your build is picking up stale kernel headers (likely the ones installed
> system-wide).  The "#include <asm/kvm.h>" in kvm_util.h is what pulls in the kernel
> uAPI headers.
> 
> Selftests uapi headers are a bit of a mess.  In the past, selftests would
> automatically do "make headers_install" as part of the build, but commit
> 3bb267a36185 ("selftests: drop khdr make target") yanked that out because there
> are scenarios where it broke the build.
> 
> So the "right" way to build selftest is to first do "make headers_install", and
> then build selftests.
> 
> Note, if you build KVM selftests directly, tools/testing/selftests/lib.mk will
> define the includes to be relative to the source directory, i.e. expects the
> headers to be installed in the source.
> 
>   ifeq ($(KHDR_INCLUDES),)
>   KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
>   endif
> 
> You can explicitly set KHDR_INCLUDES when building if you install headers somewhere
> else.  E.g. my build invocation looks something like this, where "$output" is an
> out-of-tree directory.
> 
>   KHDR_INCLUDES="-isystem $output/usr/include" EXTRA_CFLAGS="-static -Werror -gdwarf-4" make \
>   INSTALL_HDR_PATH="$output/usr" OUTPUT=$output

Hi Sean,
Thanks for pointing it out, i am not aware of these details.
Will take care of this now onwards

Thank you
-- Ankit

