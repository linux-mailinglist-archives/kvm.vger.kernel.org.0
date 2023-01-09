Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A42662CBF
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 18:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbjAIRbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 12:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjAIRbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 12:31:15 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A687B71
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 09:30:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d3so10253008plr.10
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 09:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+OGOp3YNacclAjUZKf14QWTstVsfju4aFmxM8mh9QcM=;
        b=gYOrIqsNh3TIejCdFBJ8rGXy+FmVDIDu1JwTZNjDnelEq9lfitDxSZ4Xjip9F4f7vu
         zX+Q3muznmCnkeLqUhmQ4GTRAbO/Jvqzimt4QlZhDoj4UmUP0CUhWDf6FW1VcYfRXfZu
         RaWieW/AGjdo+zclmMg87Bw+DS5RfoCqU0m8qdZ3pyuTp7qLqNY1CEa4VScd+oKf64W8
         jTJyM0i9LsiLbDAmJstSU84r6v8ybwkfqQh/eutltrHWScHni3fahVOoOqRv3DryM/Qr
         p70qbfv4kjyGMAJ+XTKN2CPKMCN4fv6eePmWQd3KxIrjZ4LtXZ03SrVFKOOc1i3m6OGX
         Lvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OGOp3YNacclAjUZKf14QWTstVsfju4aFmxM8mh9QcM=;
        b=6wqFkwHGasyoRGgTeJtSbsjF25TzgAJx7eMwy1mV2eEsj80WzP/M0Ue7EEA5xNBPaI
         33x+wGlltzecwTvZhcGof7WAnlA2KYL8Q8FlSuuVajItIG0VeGfgOIAEOyzdtU9vcy11
         bo14bzYwZ5y3NePmlBW6EBaCGS/tXc7iPMiPFF44YdKWRhs4Wy1UNQGesETi89mGqbBg
         HkB90UlpQYDCtRcvaSHEpSH9gYHJtL95tD34gQIF59vNECJuuoeWnQ2KruFWEmklHdt5
         yEGo9+4vlbK8ZMvmp36n8+1b9RJ0QG6T7KMjQPAKmXX3MQhoZ8dOXy1wIVgzZX6fGPB7
         sp2Q==
X-Gm-Message-State: AFqh2kq3nli++c6HgH8iLS2jav8vL5vxWEbqPROYVQZ/JYbglh9+fV46
        YktJP6Z7uQidVMl7gqXRcVY86A==
X-Google-Smtp-Source: AMrXdXtHZopbZey2NOOo6ZqccqC+p7nDLSU+eThEGan2FzYSSo+0ly4TezYet/q+4AK+Ibw+sTPxXg==
X-Received: by 2002:a05:6a20:8e1e:b0:a3:49d2:9504 with SMTP id y30-20020a056a208e1e00b000a349d29504mr752012pzj.3.1673285452810;
        Mon, 09 Jan 2023 09:30:52 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x19-20020aa78f13000000b005833bd59fabsm6309795pfr.203.2023.01.09.09.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:30:52 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:30:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Replace 0-length arrays with flexible arrays
Message-ID: <Y7xPSEMOWqz+3kgD@google.com>
References: <20230105190548.never.323-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105190548.never.323-kees@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct kvm_nested_state's
> "data" union 0-length arrays with flexible arrays. (How are the
> sizes of these arrays verified?)

It's not really interpreted as an array, it's a mandatory single-entry "array".

	if (copy_from_user(vmcs12, user_vmx_nested_state->vmcs12, sizeof(*vmcs12)))
		return -EFAULT;

> Detected with GCC 13, using -fstrict-flex-arrays=3:
> 
> arch/x86/kvm/svm/nested.c: In function 'svm_get_nested_state':
> arch/x86/kvm/svm/nested.c:1536:17: error: array subscript 0 is outside array bounds of 'struct kvm_svm_nested_state_data[0]' [-Werror=array-bounds=]
>  1536 |                 &user_kvm_nested_state->data.svm[0];
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from include/uapi/linux/kvm.h:15,
>                  from include/linux/kvm_host.h:40,
>                  from arch/x86/kvm/svm/nested.c:18:
> arch/x86/include/uapi/asm/kvm.h:511:50: note: while referencing 'svm'
>   511 |                 struct kvm_svm_nested_state_data svm[0];
>       |                                                  ^~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Nit on the comment aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/include/uapi/asm/kvm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index e48deab8901d..8ec3dfd641b0 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -502,13 +502,13 @@ struct kvm_nested_state {
>  	} hdr;
>  
>  	/*
> -	 * Define data region as 0 bytes to preserve backwards-compatability
> +	 * Define union of flexible arrays to preserve backwards-compatability

I think I'd actually prefer the "as 0 bytes" comment.  The important part is that
the size of "data" be zero, how that happens is immaterial.

>  	 * to old definition of kvm_nested_state in order to avoid changing
>  	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
>  	 */
>  	union {
> -		struct kvm_vmx_nested_state_data vmx[0];
> -		struct kvm_svm_nested_state_data svm[0];
> +		__DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
> +		__DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data, svm);
>  	} data;
>  };
>  
> -- 
> 2.34.1
> 
