Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7781C046
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 03:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfENBLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 21:11:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35712 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfENBLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 21:11:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id t87so8153623pfa.2;
        Mon, 13 May 2019 18:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7bWwQ71FfpHzsFq5QCxCU8fpo2zNTpbKmIeTHlAEd/c=;
        b=rfjaphbxiE4QII48Q8F5DTcu12mxhCzzRUNZ/3/DJ0itxrT3RW7IMch44OjkI2Uty5
         N6VcHxo5iWtLrPKOVg4ppTbAevkKhf2awAbQ/8AsS1WoMym3gegA0VY7HDCGzOO6nAZo
         SIYMbAQK4PWjSLE12MUMO3Ch3xRxV21dzLSbUGE+PgEODsdrC3y39ixbYkNuOiENsAMP
         HoTL1ydRLPvlIwKh6WwEfUdkXJN+WNMmTEbpVeI7LPCncCzLeGSMS6MlhfEZ+GSSkXH1
         pKj7Ay9zUzWIwSbvuvGtWGqGn9KinSNsfNlxKMY0AmDOx1T7dxXPM1F0OmqzDqMeiW1R
         Gkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bWwQ71FfpHzsFq5QCxCU8fpo2zNTpbKmIeTHlAEd/c=;
        b=itR2SS2y3kd5Hz99QI2li/5tw0RQuZmDN+wClhZdKuKJEXPDwMB57ZZLbOnBa8w1+z
         yA/tD+KwHGBoelAYXU46WI+beByhWeWPbcnt5algRjpPzZzCr5AUGRWCqzkWhFQf2fMu
         x8dUzmcAKOGIXNof1liVuDbbhcaZ9Qp0OH3PB6GCuykfecNCQeWcr24bZEei1BrgE88J
         06drByslzEEGBrUfWuPguEauCphyO4tRajJPHxZiT1IgdP8GOOHrXsbjcwEdBk9o+Yb6
         cf2Yf2aXOKTB44tGbNzqX5/vVtq0dC66ucsPtIAXXBhup6yglY0OtI6A3NPRxa1CX7UP
         IXKQ==
X-Gm-Message-State: APjAAAWIglrZ2ZA71k6XBIWUlEu/nOqVqhSGmOrBCILLUy0SMujL5BBw
        bP9iIYW7vEx+wWZovcFAmHhWHL02
X-Google-Smtp-Source: APXvYqwHPQMQrrnp4rTTGVcsZe01cI5Ag8q1WhsZNGGgqyKTVaM3E7pv+Mu9BNnxrwYl3UqQxKLmYA==
X-Received: by 2002:a62:7995:: with SMTP id u143mr37347709pfc.61.1557796293202;
        Mon, 13 May 2019 18:11:33 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id r124sm15861316pgr.91.2019.05.13.18.11.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 18:11:32 -0700 (PDT)
Message-ID: <1557796288.1877.0.camel@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Make sure to load LPID for radix
 VCPUs
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Date:   Tue, 14 May 2019 11:11:28 +1000
In-Reply-To: <20190513045818.GA10318@blackberry>
References: <20190513045818.GA10318@blackberry>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-05-13 at 14:58 +1000, Paul Mackerras wrote:
> Commit 70ea13f6e609 ("KVM: PPC: Book3S HV: Flush TLB on secondary
> radix
> threads", 2019-04-29) aimed to make radix guests that are using the
> real-mode entry path load the LPID register and flush the TLB in the
> same place where those things are done for HPT guests.  However, it
> omitted to remove a branch which branches around that code for radix
> guests.  The result is that with indep_thread_mode = N, radix guests
> don't run correctly.  (With indep_threads_mode = Y, which is the
> default, radix guests use a different entry path.)
> 
> This removes the offending branch, and also the load and compare that
> the branch depends on, since the cr7 setting is now unused.
> 
> Reported-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Fixes: 70ea13f6e609 ("KVM: PPC: Book3S HV: Flush TLB on secondary
> radix threads")
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Tested-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index ad1fc01..ad7bee9 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -581,11 +581,8 @@ kvmppc_hv_entry:
>  1:
>  #endif
>  
> -	/* Use cr7 as an indication of radix mode */
>  	ld	r5, HSTATE_KVM_VCORE(r13)
>  	ld	r9, VCORE_KVM(r5)	/* pointer to struct kvm
> */
> -	lbz	r0, KVM_RADIX(r9)
> -	cmpwi	cr7, r0, 0
>  
>  	/*
>  	 * POWER7/POWER8 host -> guest partition switch code.
> @@ -608,9 +605,6 @@ kvmppc_hv_entry:
>  	cmpwi	r6,0
>  	bne	10f
>  
> -	/* Radix has already switched LPID and flushed core TLB */
> -	bne	cr7, 22f
> -
>  	lwz	r7,KVM_LPID(r9)
>  BEGIN_FTR_SECTION
>  	ld	r6,KVM_SDR1(r9)
