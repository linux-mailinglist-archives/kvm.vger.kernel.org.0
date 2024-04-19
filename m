Return-Path: <kvm+bounces-15379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F108AB781
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB861F219F8
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F1613D8A8;
	Fri, 19 Apr 2024 23:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMqJXs3a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626964D;
	Fri, 19 Apr 2024 23:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713569886; cv=none; b=BZT9061clg/7o1uCm5lb54LWNLgL4hT6Y4U/XiOkIDG0ER8MLIhM7m+fRlQRF1moydXyiGYXFJvL7w6PF4Ufd2FzAdf4Om79HPHeeDV+YN/ilzHHV0V13BGrUIT9IShhQf5+ZyjlEe+5C9gpqnSlRiwQDI4hRrKbWy3ogZrC2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713569886; c=relaxed/simple;
	bh=YASXITkV2ASgRJeSKmQR9SchGIqfz5jdQ411YQ+n2KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAMsUOdy31dmHplq+3x+ZFbtf7EqZ8qL/7aNZCfqz6ugPbJbQirWn9gT+97mrBxCM4z4Ql8vguNOI8vveL9kpuNGIb2MMaiJEBxeVxeJmnzQvrwpUczccBPpTZ7BC+UNw7RpMDs96RBBGn2+QlfTeAB+5xRkXuIbnSG34Ug47rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMqJXs3a; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5d81b08d6f2so1890230a12.0;
        Fri, 19 Apr 2024 16:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713569884; x=1714174684; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Gwf216v3KsZJ4qYiZY7FSP0+gRY5Pp5+VIKVDcURGo=;
        b=aMqJXs3aJCXUjSloLPP43Y8B9V/skGAWey7uaqCjERqtyLEcXNT4wKxKooa51jFG36
         egTGvL6C2XTFF649LbY8OiY/vaFNXH80oTPhbeXNeU9X5Y+4nzCrdmm36+T5+iqMsFm6
         FjYR8HPVw1ncqFuZNGc9u4oZ5Py7szNOpC064ufC6YAEsjcqIGSCY78zu46BSO8JcHIz
         9tOQTWbztvYF3iUQP7q++Vf9lXx7G+gAPHOFhxnn+9OtXfi3kFhIkFjrgIeDAuMVdv9h
         kjjYL3idwOa8JjOId1f84knb4KwhKyFsOsAfkR7BTfvImOf9TQd9JkrHUs4dXW1asJzi
         Yazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713569884; x=1714174684;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Gwf216v3KsZJ4qYiZY7FSP0+gRY5Pp5+VIKVDcURGo=;
        b=dFqBcg8LS2a74xYV1lVIzdXaaACVfemPy1hZhOK2IuHSdEXmvFkyBegaAyPVplQ4kU
         oeBZ5vAR9yq6iGhjuBWpjNMNlbjsuSu8FhjjxbQiQYDJVKZi/o9IbMsHtWsEHtyCmvKP
         Qm2f/rFCD8qpXG3VNnUPftMefWvCCSCZG/MFqbMLt+sUTGyYmkSGeydomy5dKXnRAZlX
         pH8/3wNBzku7W79TnhmBZe0+F84VETTE76vYAxfcHNHNLJ/wruxnfrEY3Fpk0drnsP6K
         Hu64RrVT4m+ki1OZSbW301xG5u/lNkWH4bgZLOIevFc3/1JDB9FYJdZpV5Xc+PG8wqcF
         +F9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOsudlFklr1r53tPyT4IOVWz8SN+wPAcLIRLudUZ4xYRpVWyBYUDARtk1l+68sAY8Wod5bfkEHPVJ//+SIPgdkNbC2LtkMMjE4JG0mCtNfQiKfrOA2ciTeuijiKI7n2uJwG20Zhay4TDBuN6fWE8nnTI3d8egiVXqkJgfrDngnOZhiKwFYvwwabLAxJ0JxydJgnNPHZY2R6Eq6Y+vvOIGEW7uHYUM1hBKAbNDACZm9FLtOMYxXF7kWlBlUzH5tXChR1/HZIRpS
X-Gm-Message-State: AOJu0YwvnNLQXAonkMwKSN//NFsAty+R1x8X1Jzmmq9EYY1t9rJcoqiU
	g9t7fo2KsoBNhVceYNiwQGgeBOhWPLh091zE6QbK3KRMdiFyfgvc
X-Google-Smtp-Source: AGHT+IEhgR3QjGKkzYQX0nCs1qVhmVHFCFFjDZfmUk9cI+PUJECL3IHXfzZjmkA8FR3ezYxS5oYc7g==
X-Received: by 2002:a05:6a20:12ce:b0:1a9:c4ca:dc74 with SMTP id v14-20020a056a2012ce00b001a9c4cadc74mr4557459pzg.5.1713569884211;
        Fri, 19 Apr 2024 16:38:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gl17-20020a17090b121100b002a2c905158asm2438010pjb.46.2024.04.19.16.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 16:38:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 19 Apr 2024 16:38:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Kees Cook <keescook@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v3 7/7] kunit: Add tests for fault
Message-ID: <b70332b0-3e55-4375-935f-35ef3167a151@roeck-us.net>
References: <20240319104857.70783-1-mic@digikod.net>
 <20240319104857.70783-8-mic@digikod.net>
 <928249cc-e027-4f7f-b43f-502f99a1ea63@roeck-us.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <928249cc-e027-4f7f-b43f-502f99a1ea63@roeck-us.net>

On Fri, Apr 19, 2024 at 03:33:49PM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Tue, Mar 19, 2024 at 11:48:57AM +0100, Mickaël Salaün wrote:
> > Add a test case to check NULL pointer dereference and make sure it would
> > result as a failed test.
> > 
> > The full kunit_fault test suite is marked as skipped when run on UML
> > because it would result to a kernel panic.
> > 
> > Tested with:
> > ./tools/testing/kunit/kunit.py run --arch x86_64 kunit_fault
> > ./tools/testing/kunit/kunit.py run --arch arm64 \
> >   --cross_compile=aarch64-linux-gnu- kunit_fault
> > 
> 
> What is the rationale for adding those tests unconditionally whenever
> CONFIG_KUNIT_TEST is enabled ? This completely messes up my test system
> because it concludes that it is pointless to continue testing
> after the "Unable to handle kernel NULL pointer dereference" backtrace.
> At the same time, it is all or nothing, meaning I can not disable
> it but still run other kunit tests.
> 

Oh, never mind. I just disabled CONFIG_KUNIT_TEST in my test bed
to "solve" the problem. I'll take that as one of those "unintended
consequences" items: Instead of more tests, there are fewer.

Guenter

