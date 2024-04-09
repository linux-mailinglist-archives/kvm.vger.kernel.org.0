Return-Path: <kvm+bounces-13972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E501B89D387
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 09:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 950161F2264C
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 07:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1487D3EC;
	Tue,  9 Apr 2024 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3caKv3E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F8E7CF17;
	Tue,  9 Apr 2024 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712648743; cv=none; b=ML0ZDBtxNESXoqkhvrpz2J8SVmY7mG1zWZma8Fxa8nuBn6uJ34yNq53Y8/HxBcKcamrSx0iMnWME9EXnXzgG170VEFP4N/W890RJ9NqCbA5oZOaaATPjtSABY3NKbcJ+9Nk1N0H8KHFtDA8k6f1e33meq3/QXeQ0Oo3tFVQ4h3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712648743; c=relaxed/simple;
	bh=uKzsCnq7HhUiyxC/58A4bs+5O3t7G1g0XOiZw9VxCbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhVYZrqShhw25EPaf3XffcjvUTIDisrhmCKRgGUmkxpfC/wCPM3fmEFwzlYLv360OaKreXhoWcmhXM0DoFV5wcsj8W22Yxt7zMX2ECu9NJr9NiquIG9uznl6g4LVDtrQDuw+tZBhSzspSVJom3vUd8MgbRM2lYLDpEdxcWj3PvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3caKv3E; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56e6f4ee104so920389a12.2;
        Tue, 09 Apr 2024 00:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712648740; x=1713253540; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0oJpUXIpDVMfnwpnaBHprCGzL9aiB50P8YLgzgVitTA=;
        b=R3caKv3E9rDJvjDM/pS5nGKQEu8dS5ubcrJazmpP9EwFtZODy8WYVv+sJQ6e5XYF6u
         jXkK+LH+41mN6eG1RZV2qgGlcmsnQIgXK5BZ5+GwB8MkEyF7T08teeQrSWRqrj2tJ2ys
         0JscB8BxzNGxQcLjvHU2q3Qo1wTPgh1x+ty5q5NY35+J/GZ2ohIAGnfK865YqAHBFbVp
         M/ZbdMjJERWYwtRNKiIhbY5p3sCjsQcMmUOhPnd3s7lAFPfQYIj0gs2oASis/TDEbLXR
         nX66uKfqWm9cR69U2sRXcUqeBPeCPno2QmX263ev/Ca8ReB9VKsOZ5WGvBVCXuNBbTIi
         KJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712648740; x=1713253540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0oJpUXIpDVMfnwpnaBHprCGzL9aiB50P8YLgzgVitTA=;
        b=XBnIycjoGVZ+qZpNvcTYFsaGwrPK6/Jq0FpqdQgRef+fnX3fhT5v6grlrNkF3t9b+p
         EF94hvXoEsJVknjOliS2Cs1jb0pBTWtO5aPiIxJilFOwqb+Wj99vom6qNQ8D8xAb1nx5
         Xqx+OSajqqdrV+Y8an6AUiFSTqr3QtaYQiJmUXicYLiz09GH5hWcaVEQMeafkTy9HJg8
         sdQELvYNOwKlomvU2RY7MfiZ8ZkjWZBfk0Pu5OLmVmAEIWC604umXDbZvaLSYHHcbfuZ
         JsvKfL8F8yWZp39o1DxTuvx1Fd7T19shMxuUkfUmkQaYMkQRu08NAEn4uD6vseul6P5t
         OrAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBKPIlz8dQxAVdvR3z+Q5MQt4cUnBG6MSQbJO2E/9Lo734sU2YJxUuSukE7uavwcyH8uAbW5dyOaq1M13p0MMztPVbtMEwvx5iBHjzAtzus+2vcllJo5QcKrOQwhxT/8I5
X-Gm-Message-State: AOJu0YweAz3eMCM0u7jlVzoHDetD89GMNYBagE2BcfwMXslqmmrPPf33
	RC6JOcHjGNh7BmX8iEIGn5PtDieE+q4puCoEQF46Qh8o0KQ9WZ+C
X-Google-Smtp-Source: AGHT+IEK/oMsux4Vg4cDuhlXiDySJyW7ebfeLef3XLTsjLq5pRmj5pDvIkmPkMXDKCExwolqONtbwg==
X-Received: by 2002:a17:907:72cc:b0:a51:c1db:6578 with SMTP id du12-20020a17090772cc00b00a51c1db6578mr5930059ejc.14.1712648739823;
        Tue, 09 Apr 2024 00:45:39 -0700 (PDT)
Received: from gmail.com (1F2EF1A5.nat.pool.telekom.hu. [31.46.241.165])
        by smtp.gmail.com with ESMTPSA id a17-20020a170906191100b00a46e56c8764sm5321368eje.114.2024.04.09.00.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 00:45:39 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 9 Apr 2024 09:45:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Li RongQing <lirongqing@baidu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, peterz@infradead.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	kvm@vger.kernel.org, seanjc@google.com, szy0127@sjtu.edu.cn,
	thomas.lendacky@amd.com
Subject: Re: [PATCH][RFC] x86,lib: Add wbinvd_on_many_cpus helpers
Message-ID: <ZhTyIadG35HDPNRx@gmail.com>
References: <20240409042056.51757-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409042056.51757-1-lirongqing@baidu.com>


* Li RongQing <lirongqing@baidu.com> wrote:

> wbinvd_on_many_cpus will call smp_call_function_many(), which should
> be more efficient that iterating cpus since it would run wbinvd()
> concurrently locally and remotely
> 
> it can be used by the below patch
> https://patchwork.kernel.org/project/kvm/patch/1860502863.219296.1710395908135.JavaMail.zimbra@sjtu.edu.cn/
> 
> Cc: Zheyun Shen <szy0127@sjtu.edu.cn>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/include/asm/smp.h | 7 +++++++
>  arch/x86/lib/cache-smp.c   | 7 +++++++
>  2 files changed, 14 insertions(+)

The two patches should be submitted together within the same series.

Thanks,

	Ingo

