Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C6840E6CA
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347126AbhIPRZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 13:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348016AbhIPRXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 13:23:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A7C08EA78
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:20:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v19so4922706pjh.2
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pPI/VFw1zzsayAVnvWLbDx7Hpbl9/4fZcCkZww1rQGI=;
        b=U5tiGDAAZOHXxrls9q5Eta2fq2CUA7BHgHHf3T5jpCvkx/QPHyRPhBPfweZG0EMPtM
         /hlDJCtbiPTvlayHon3zcnd9yz7sqPJ5lHP5Z8Pbkh1PbB3UqMcdw2sKBS3NPmvwKQhn
         Ucpy6KMSK1/HxW/9YJBDM1TK4/IJvjzEajlNl5gRxAAB4IUDKR/QTRpPK+BokmdnQUFb
         y6I2Jh720jk1mUDT6GaH6lBgO6Y3F4P5tEomc6Ik8jIVNQpMKX3n/+XkOxEDMFtpYKng
         1XrZKUDHT5h/Mhc78bF1oTYRWj5BBrB4vHRsb/ajjorHArSS1sNlRWp45oEUmsp9X+z/
         gAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pPI/VFw1zzsayAVnvWLbDx7Hpbl9/4fZcCkZww1rQGI=;
        b=T6lDivrRePzETHyaP+ETiH02DVCcey1dA3PhECpCu6YcJSVzdGlZzhghRlohxN5Pso
         L5eP6z9QLU/Eb2koWXofSPTkLLTn/aFVOCRE5TBe7iv+uscN+zhcAgl0HYe96rDiLMEE
         lwwU5CyI9dnkcbuQP5YjX0BrgASnL3ispvtzmXO4TefevBnWy/4o9MiD3Hnn7dCIOCAb
         gaUYe21RbjW29zfkDOaSwbwjGzeiHNehA/a0JNQflOQuLSV/4nyKD2X0U/kV9q2CKR1y
         cvErz8iaTeJ9nxyiIxlQxXO77Zzbh6YP57O5yu8zVEozcgToDGF+fpruA99d4jiX1nmS
         B7JQ==
X-Gm-Message-State: AOAM5324U6LLkach7CxduqfdCU8mIuaBGHCvOGrWYfE5oj/uN7QXjjZH
        fSZSb8PbLMf46h7dP0Fh5iT9ig==
X-Google-Smtp-Source: ABdhPJwOi/rPghzGiGvxWRxUWAxSCfJoIvU2qR/dq192mzrvuKW2ywbsmxspallCqVizxJKSmmm1ww==
X-Received: by 2002:a17:902:82c2:b0:13c:916b:96a with SMTP id u2-20020a17090282c200b0013c916b096amr5611228plz.61.1631809246433;
        Thu, 16 Sep 2021 09:20:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d4sm8224656pjo.12.2021.09.16.09.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 09:20:45 -0700 (PDT)
Date:   Thu, 16 Sep 2021 16:20:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: Re: [PATCH v5 1/4] KVM: x86: Clarify the kvm_run.emulation_failure
 structure layout
Message-ID: <YUNu2npJv2LPBRop@google.com>
References: <20210916083239.2168281-1-david.edmondson@oracle.com>
 <20210916083239.2168281-2-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916083239.2168281-2-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021, David Edmondson wrote:

For all these patches, assuming you want the Author credit to go to your @oracle.com
email, they need an explicit

  From: David Edmondson <david.edmondson@oracle.com>

otherwise git will default to the "From" email header and make the Author
"David Edmondson <dme@dme.org>".  And then checkpatch will rightly complain that
the SOB does not match the Author.

Adding From: can be handled automatically by "git format-patch" via "--from", e.g.

  git format-patch --from="David Edmondson <dme@dme.org>" ...

> Until more flags for kvm_run.emulation_failure flags are defined, it
> is undetermined whether new payload elements corresponding to those
> flags will be additive or alternative. As a hint to userspace that an
> alternative is possible, wrap the current payload elements in a union.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  include/uapi/linux/kvm.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a067410ebea5..8618fe973215 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -402,8 +402,12 @@ struct kvm_run {
>  			__u32 suberror;
>  			__u32 ndata;
>  			__u64 flags;
> -			__u8  insn_size;
> -			__u8  insn_bytes[15];
> +			union {
> +				struct {
> +					__u8  insn_size;
> +					__u8  insn_bytes[15];
> +				};
> +			};
>  		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
> -- 
> 2.33.0
> 
