Return-Path: <kvm+bounces-6481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DAB9835443
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 03:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9CA128290C
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 02:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF0936125;
	Sun, 21 Jan 2024 02:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="iBSoXyXR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E426AF5
	for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 02:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705805716; cv=none; b=b2tudBiJDs3hDma2uY1KFP3iC4zTaZ++U6eVzJaA3efxwmT160wBHgGEzChRWOakJZBjPn9gbQL9vvtcu4W2xmU1oVyC9RfsLo+b8+zN+E7MfwCBq7zYueF2TNqFlchr86ZO9Vt/n2tzTyBMRz4SNkDt8ND95wMCg+iTyJlWJQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705805716; c=relaxed/simple;
	bh=VfUXS2B//6LUUF4rYtF0HnNDEs0Eez2KOmR80rAwJK8=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=mztLtXg5ioOe5CBXyTYQUc7feJ6RLvOxgqAX3sJGYEWAWvk2rMhUg62iL6od+5Za5hEn8sdwckCKK9gx1wjXGKXVSyt6DBUaN6WZQannQYYdl/MV/kc7W/dMFsbikQxvRtvXLDgaQIG8JSzkfo3mkYc8ImtfwCxnfr7J9NBkdqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=iBSoXyXR; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d427518d52so14839075ad.0
        for <kvm@vger.kernel.org>; Sat, 20 Jan 2024 18:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1705805714; x=1706410514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3B+/NUEVrUEstAbkh74NA2n7DEd6z8SVAOvTWJSJMNk=;
        b=iBSoXyXRY4OC9a6afk4ud7lLC2sV+nKwJ3So9UeNuJoI1PwHfqS7VynMNyxr5yk5K3
         u6rLckMzHTD1+fZ7Fv6WwQ4S5J9i9Ve92J1N5bpgGVEIT2tsrycKITlqBJYNLfZSLsdR
         91T40s/hEThcLc60foc4NaMoXhfYvTcA51H5IbyTdfHkWItUgzy91Dd/davI+DGuSUE5
         XX4wGm7prZ2G3PKsG/7/n0cbn2EzyL1G0e5hRU4mpKP7vnGPe4tt4BL8ioR4O2y4/VGH
         mYLBGtdsVuC4Rv9wHMhMYXkT12b87hEgtYx1AzVHMv70QGzSZMH6u7RaS1g6z7lHd1zH
         LPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705805714; x=1706410514;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+/NUEVrUEstAbkh74NA2n7DEd6z8SVAOvTWJSJMNk=;
        b=VcHArME2UWJqwinZSnEbyFe6gfbS74SXyJjBTZgL1M8iVP8oivwqzbJw2ZdcJe6Ffm
         +j3X3o/DBBhkOt9FfZ4fIaHSJCcb08TZ4Rb2eWEWqKdr77RBdCh3XzBaaD6nDioYLiMQ
         IU6ArN3s05I2lNdxaglNUVRatc3zWVTYfQeplgeDJ8KgwzLNzSzCYkuHtWzPio0y9ju6
         XLOFAPcaNMfDGy37cHMuzceVujBmeKzFV6yKrY3ffBvLKVhwKikxp/BF1UEh/MFcZr0C
         iKv5KX6aq40C/H5CVMfR4zW08781ezwrNYf0G0zletWZlYOhvyjP0R5ghyFzw+LzcZhK
         NYOQ==
X-Gm-Message-State: AOJu0YzOmvEs4lMFdNz2jc4XUMyfss1uSb8eHB9p8pmjGWVtr0F1Vot5
	52b2Wk6f6dmJiWWVwpTVbJoYWsvZsfp+aqlWHD3JiejI3vpG7SQ+AFd/cQBzMrg=
X-Google-Smtp-Source: AGHT+IEmqx0ENeontMtkchq1XVGHG78UCHTB+fp+wDGW92tw3dHtI2r8XaVNfgbNubWhYGDtXt8/kA==
X-Received: by 2002:a17:902:efcc:b0:1d0:4802:3b6c with SMTP id ja12-20020a170902efcc00b001d048023b6cmr2278000plb.4.1705805713519;
        Sat, 20 Jan 2024 18:55:13 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id j17-20020a170902f25100b001d70e83f9c3sm4577091plc.242.2024.01.20.18.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 18:55:12 -0800 (PST)
Date: Sat, 20 Jan 2024 18:55:12 -0800 (PST)
X-Google-Original-Date: Sat, 20 Jan 2024 18:55:11 PST (-0800)
Subject:     Re: [PATCH -next v21 23/27] riscv: detect assembler support for .option arch
In-Reply-To: <20240121011341.GA97368@sol.localdomain>
CC: andy.chiu@sifive.com, linux-riscv@lists.infradead.org, anup@brainfault.org,
  atishp@atishpatra.org, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
  Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com, guoren@linux.alibaba.com,
  Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
  trix@redhat.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ebiggers@kernel.org, Nelson Chu <nelson.chu@sifive.com>
Message-ID: <mhng-e4b5de69-859d-43ea-b35d-b568e6a621ef@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Sat, 20 Jan 2024 17:13:41 PST (-0800), ebiggers@kernel.org wrote:
> Hi Andy,
>
> On Mon, Jun 05, 2023 at 11:07:20AM +0000, Andy Chiu wrote:
>> +config AS_HAS_OPTION_ARCH
>> +	# https://reviews.llvm.org/D123515
>> +	def_bool y
>> +	depends on $(as-instr, .option arch$(comma) +m)
>> +	depends on !$(as-instr, .option arch$(comma) -i)
>
> With tip-of-tree clang (llvm-project commit 85a8e5c3e0586e85), I'm seeing
> AS_HAS_OPTION_ARCH be set to n.  It's the second "depends on" that makes it be
> set to n, so apparently clang started accepting ".option arch -i".  What was
> your intent here for checking that ".option arch -i" is not supported?  I'd
> think that just the first "depends on" would be sufficient.

I'm not sure what Andy's rationale was, but de3a913df6e ("RISC-V: 
Clarify the behavior of .option arch directive.") in binutils-gdb 
stopped accepting `.option arch, -i` along with fixing a handful of 
other oddities in our `.option arch` handling.

If that's all this is testing for then we should probably add some sort 
of version check for old binutils (or maybe just ignore it, looks like 
it was a bugfix and the old version was never released).

+Nelson, as he probably knows better than I do.

That said: what does LLVM do if you ask it to turn the "I" base ISA off?  
I'd argue there's no instructions left at that point...

