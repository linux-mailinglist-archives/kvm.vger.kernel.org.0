Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C03446B04
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 23:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhKEWtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 18:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhKEWtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 18:49:50 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D663C061570
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 15:47:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f8so11890391plo.12
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 15:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OxUqrQOKE5rz2Yy9rGFxDjQ64K2p6FbsasTsNrHPkGY=;
        b=oaRJRNUL2SeshzXw5yVr3ynQ87l1WCM717Ekxc3C6L/t2VOi9zgkRI9+8hunUnhNY+
         0msWk0cT4U5n99XcAvfOnCW/Cj2ZMX0HW0XqYw2n2baHGwSd+r0BqxWkJGOeWPcRnCRJ
         aGUE41MrHdgdkXSuZ3EQC+Nz7d+IXcNkJOnIkO2KmNR4z/l2OZ+njSV5O6KHdT6aYcbY
         ZBYX46mufxAAXdVuydJSwdZH300owuXKd0BPFcE0losc9dPeXD5YZBGQd7shvZXvReSC
         fbYPmxHsrrO0XrCG7dBjkChiiU7yzvrnmtABfUE9sqKQXhaAjQsUhpgMl/hrIEon9BXC
         JUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OxUqrQOKE5rz2Yy9rGFxDjQ64K2p6FbsasTsNrHPkGY=;
        b=RQMzxf3wncTv5OTkNTiKMoEq12sswMOYpPtlmMu5uO61K/a/S8Bh9vahFsINQAOKhB
         90YZKG4DvaQQ9qeKXoiZmYT5GgDHYTYPXrQus1w1tAmeF7qsVLll5SEkIGs3H8bAzBY/
         bekfj0BA/PHM9RgxuXTRvcu70B7e4KrpG54mKRZHhZZiGGbtYdBWHfdo98iFEWivEW7C
         wmeEUv4KYQZ75iwSj6T5w01D8T/R/265dojY1g2ru2wlSjDlpXwWc/wGuBLUMMKXOJsn
         SK1aiTww41L3hTaYVu3CVn/dpPfXeCKmI6RzN088EA0UAmE9jSfcqWHkfEObSuo7mfb4
         Nyng==
X-Gm-Message-State: AOAM531EYfXkNcWwRvsvPtWWhns8tLNpIv0ZrJb4oNv4PQ3zw9+LWwxH
        ZpEfkdrakpahqqO7DDIViTkBGw==
X-Google-Smtp-Source: ABdhPJw/vX5xoimWxW7XMyz2ihPOstRLNm8ajQj2qZQu+nXqI+ZsbMHHvfcgSeq6uyqWjYEbfLauKQ==
X-Received: by 2002:a17:902:db07:b0:141:ea12:218b with SMTP id m7-20020a170902db0700b00141ea12218bmr35627640plx.46.1636152429333;
        Fri, 05 Nov 2021 15:47:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s2sm11157690pjs.56.2021.11.05.15.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 15:47:08 -0700 (PDT)
Date:   Fri, 5 Nov 2021 22:47:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V11 4/5] selftest: KVM: Add open sev dev helper
Message-ID: <YYW0aPKZLT6FyUnT@google.com>
References: <20211021174303.385706-1-pgonda@google.com>
 <20211021174303.385706-5-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021174303.385706-5-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021, Peter Gonda wrote:
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..06a6c04010fb 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -31,6 +31,19 @@ static void *align(void *x, size_t size)
>  	return (void *) (((size_t) x + mask) & ~mask);
>  }
>  
> +int open_path_or_exit(const char *path, int flags)
> +{
> +	int fd;
> +
> +	fd = open(path, flags);
> +	if (fd < 0) {
> +		print_skip("%s not available (errno: %d)", path, errno);

While you're here, can you add the strerror(errno) as well?  There are some other
enhancements I'd like to make as some failure modes are really annoying, e.g. if
the max vCPUs test fails/skips due to ulimits, but printing the human friendly
version is an easy one to pick off.

> +		exit(KSFT_SKIP);
> +	}
> +
> +	return fd;
> +}
> +
>  /*
>   * Open KVM_DEV_PATH if available, otherwise exit the entire program.
>   *
> @@ -42,16 +55,7 @@ static void *align(void *x, size_t size)
>   */
>  static int _open_kvm_dev_path_or_exit(int flags)
>  {
> -	int fd;
> -
> -	fd = open(KVM_DEV_PATH, flags);
> -	if (fd < 0) {
> -		print_skip("%s not available, is KVM loaded? (errno: %d)",
> -			   KVM_DEV_PATH, errno);
> -		exit(KSFT_SKIP);
> -	}
> -
> -	return fd;
> +	return open_path_or_exit(KVM_DEV_PATH, flags);
>  }
>  
>  int open_kvm_dev_path_or_exit(void)
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> index 2ac98d70d02b..14a8618efa9c 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> @@ -13,6 +13,8 @@
>  #include "processor.h"
>  #include "svm_util.h"
>  
> +#define SEV_DEV_PATH "/dev/sev"
> +
>  struct gpr64_regs guest_regs;
>  u64 rflags;
>  
> @@ -160,3 +162,14 @@ void nested_svm_check_supported(void)
>  		exit(KSFT_SKIP);
>  	}
>  }
> +
> +/*
> + * Open SEV_DEV_PATH if available, otherwise exit the entire program.
> + *
> + * Return:
> + *   The opened file descriptor of /dev/sev.
> + */
> +int open_sev_dev_path_or_exit(void)
> +{
> +	return open_path_or_exit(SEV_DEV_PATH, 0);
> +}
> -- 
> 2.33.0.1079.g6e70778dc9-goog
> 
