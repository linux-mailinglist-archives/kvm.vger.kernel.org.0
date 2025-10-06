Return-Path: <kvm+bounces-59510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3F5BBD378
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 09:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FA173A8F4E
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 07:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B969A257AC6;
	Mon,  6 Oct 2025 07:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x76G3bbJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B56128819
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 07:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759736002; cv=none; b=oU7jugmWljlOn8pNF3olYpiZwcj2cpMEYy7O0hc7mOJzFvPM5NLU14kT9O4i04yAnAOB+e3fb8eo5Sc/X1lbPs4y0OvuMvTGhMWOMje2BtWC+UUFFXUk5KIsyrjmC1Q/aK3xZAis+HANX8wgg/jJQwQ/SNTV2wuyysZju3lBrvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759736002; c=relaxed/simple;
	bh=SZzGHvqd25HlgCSKTD0VdSNQ1UMIgyKDNBEAI3lCnbE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HbjiMpy1dbG+JLn7Egl/kGlObAKD8A7WQMYdTAYVW6tUAmuTh6S66XI81TfUaHSLlcKZeGPXtNVitl3uV947cWZsTJCulGObpkWsaSCYUO0efIIlAcc0SRaVL/M0j6IZgQWmxNk5u4gGrG8HUp3PQ0ekbbEZwnrxc0U9il2sNpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x76G3bbJ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e52279279so29028375e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 00:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759735998; x=1760340798; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D3ZEr2d7pwTIHaluHUG7JQgfUgOPLmXul/6qgxWDE8g=;
        b=x76G3bbJJU9UulOBMq1iVa2xP4AQ37YYUOpeq1mPs6YeTrMyz/dIp0RM14ATLjUc9e
         MwAKw19Zf1dVPlMMY8i5B/og3vN+nleo/NVGOTyQ+CjZCAKG0MeNc5YtGc11ahDsHPhH
         i58LkRy/SxRXDqq7rEdoOw3tY5M9OJQAh40X6PH7fOa6TTsalvkYrcCQvWSOol5J8hY8
         vsuoe3wxQoddbcaM43aZ7GjSxHZbrbWal+cwgFXG+rP41YmnGhOqqjNnZ1Iv9PWuAPgb
         jcQajjwKcJawsIobNJj5QFuCY1LUuFrOhsQakaP2mRITdnyUngCvcB0c9c+5lRjXJPRi
         BMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759735998; x=1760340798;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D3ZEr2d7pwTIHaluHUG7JQgfUgOPLmXul/6qgxWDE8g=;
        b=pZ/l50d4tGg9SOW+BfeTWsNqfVGs/a2mkBluKOtZ0QjvosFBRXJhH+YvG2z29WehHq
         eaIf1h7H7QQw/ZfY4LPSJwiGNDpnYAhm74KNg0Ewx3xOKY55XTkDQCCgpyii855v4ksX
         dK5WI5vGO2dyCbVQJtTDaowrwdHsWsHyi7lgN9yRtW0dv36F02eAMhX49VXGHIqoviG+
         4vRRyPxozRJK2+yaqfiYV510oG+VStnzq2bmpMl2NM/4/bD9pyhD9qNNpkRiTCOKcPL9
         sBLO+YXwvdmdin0BAWMqhm1i1Yvf4IksBRLtIS6/b7NfkQ7k3Pf/lHrvWpnvsXIIaFRX
         lK9w==
X-Forwarded-Encrypted: i=1; AJvYcCXtW08jeL4/e64PWKU0Agvfvgk0yzWbJUdLJygEBgJYu0DQkCLzzQQlxhq1MF2niWxXTQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI2jD76WG7H/S8PWJd9chzQ9fDLfHwKkRar1Syh4n7JpCL3Fn+
	aj+fNsP8WzBZnv+no0ohGSVYUoUiQWms48aXToRM0TNNEb7iVoMFeOx0ud57IRA0cJk=
X-Gm-Gg: ASbGncvK0KeNedoFERGa+jQ9WVPKiF8+mgKU63yZqk39k2PbDFxfL1fUB0VUlbe87Tf
	16V+rY7SVOYtI7zBYMXAxdq+Vc/6ZRZv8QCT770i86wbfS85Pe6g4HJq1wV63Eoh2EDbMSr6RE3
	0LpXHVC0lXFptgo5fbdHkjvGON/d+NZv6p+66BGlCUJcC+/tl1ZkwLRrWecVrnOJllI8MicvQ2F
	fdn3sp13Oc0CdAGu4IX/k7RdeiSk0bTKMwy8XyFJhCxqJ7pD2BrBypO8RjijLuW74y86qcvl2+V
	fcgOEHh6RSWEeWIS9HE1I7Ii/c6nh4UXhcjrWh88OLwFy4lCRZVti31ubawE6xzilTtjhJOi15X
	SASJ0pyP7ogujDCq1I26c986DqEK+LXW/PXBf1qLKjJP3LK/uUzSmSrqEsqPfCNPB6Mo=
X-Google-Smtp-Source: AGHT+IEY3Vdz6DSENDPXWHaU3Pw3qJ2jmGm2AQUbIDp0HgmMLAwC9lJKK+vWRw7LBtZ3XAYcVnYPJQ==
X-Received: by 2002:a05:600c:3149:b0:46e:33b2:c8da with SMTP id 5b1f17b1804b1-46e7114829cmr64921245e9.32.1759735998124;
        Mon, 06 Oct 2025 00:33:18 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e619b8507sm243679325e9.3.2025.10.06.00.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 00:33:17 -0700 (PDT)
Date: Mon, 6 Oct 2025 10:33:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not hold
 slots lock
Message-ID: <202510041919.LaZWBcDN-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930172850.598938-1-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-selftests-Add-parallel-KVM_GET_DIRTY_LOG-to-dirty_log_perf_test/20251001-013306
base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
patch link:    https://lore.kernel.org/r/20250930172850.598938-1-jthoughton%40google.com
patch subject: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not hold slots lock
config: x86_64-randconfig-161-20251004 (https://download.01.org/0day-ci/archive/20251004/202510041919.LaZWBcDN-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202510041919.LaZWBcDN-lkp@intel.com/

New smatch warnings:
arch/x86/kvm/../../../virt/kvm/kvm_main.c:2290 kvm_get_dirty_log_protect() error: uninitialized symbol 'flush'.

vim +/flush +2290 arch/x86/kvm/../../../virt/kvm/kvm_main.c

ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2255  	n = kvm_dirty_bitmap_bytes(memslot);
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2256  	if (!protect) {
2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  2257  		/*
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2258  		 * Unlike kvm_get_dirty_log, we never flush, because no flush is
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2259  		 * needed until KVM_CLEAR_DIRTY_LOG.  There is some code
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2260  		 * duplication between this function and kvm_get_dirty_log, but
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2261  		 * hopefully all architecture transition to
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2262  		 * kvm_get_dirty_log_protect and kvm_get_dirty_log can be
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2263  		 * eliminated.
2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  2264  		 */
2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  2265  		dirty_bitmap_buffer = dirty_bitmap;
2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  2266  	} else {
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2267  		bool flush;

flush needs to be initialized to false.

82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2268  
03133347b4452ef virt/kvm/kvm_main.c    Claudio Imbrenda    2018-04-30  2269  		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2270  		memset(dirty_bitmap_buffer, 0, n);
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2271  
531810caa9f4bc9 virt/kvm/kvm_main.c    Ben Gardon          2021-02-02  2272  		KVM_MMU_LOCK(kvm);
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2273  		for (i = 0; i < n / sizeof(long); i++) {
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2274  			unsigned long mask;
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2275  			gfn_t offset;
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2276  
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2277  			if (!dirty_bitmap[i])
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2278  				continue;
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2279  
0dff084607bd555 virt/kvm/kvm_main.c    Sean Christopherson 2020-02-18  2280  			flush = true;
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2281  			mask = xchg(&dirty_bitmap[i], 0);
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2282  			dirty_bitmap_buffer[i] = mask;
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2283  
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2284  			offset = i * BITS_PER_LONG;
58d2930f4ee335a virt/kvm/kvm_main.c    Takuya Yoshikawa    2015-03-17  2285  			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
58d2930f4ee335a virt/kvm/kvm_main.c    Takuya Yoshikawa    2015-03-17  2286  								offset, mask);
58d2930f4ee335a virt/kvm/kvm_main.c    Takuya Yoshikawa    2015-03-17  2287  		}
531810caa9f4bc9 virt/kvm/kvm_main.c    Ben Gardon          2021-02-02  2288  		KVM_MMU_UNLOCK(kvm);
2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  2289  
0dff084607bd555 virt/kvm/kvm_main.c    Sean Christopherson 2020-02-18 @2290  		if (flush)

Either uninitialized or true.  Never false.

619b5072443c05c virt/kvm/kvm_main.c    David Matlack       2023-08-11  2291  			kvm_flush_remote_tlbs_memslot(kvm, memslot);
82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  2292  	}
0dff084607bd555 virt/kvm/kvm_main.c    Sean Christopherson 2020-02-18  2293  
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2294  	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
58d6db349172786 virt/kvm/kvm_main.c    Markus Elfring      2017-01-22  2295  		return -EFAULT;
58d6db349172786 virt/kvm/kvm_main.c    Markus Elfring      2017-01-22  2296  	return 0;
ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  2297  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


