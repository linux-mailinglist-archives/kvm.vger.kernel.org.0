Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AFE678C42
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjAWXyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjAWXyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:54:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC830B18
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:54:22 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so12508112pjl.0
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dq4sejDtpAwwBeadsjod+B2tOf97KA2Eq0yG2ku2xd4=;
        b=if+SovUimClpBxO5KuAKHTaRVACPXCh5hOio0K8Vp7oGRRQ9ZhpdLi8hPKAlfikRio
         n+Tt3bk4Q3OezWMXzvvXfUB6iGwwl5SB5DafD3OA9P9FlGMOhc7mj3+eIOI4AkAC7rgV
         7svHwCOdncyvtS0xgp7ASBC99EWAWgkQcUBZgDSKV+saGt4JCrX6IfuWgANO+Y+0V87b
         00VruGs5ZQZNu/rajnCKclckmqoiJtndLXrwr149XmTVEorJEuy9biP0ycnpyqgZnPYP
         6tkBJsSYmtlP4qfcxYb80PQSdcZ7PK00VMuARgaaj6nbC8UlYyRrliI/spu+ifM20dAw
         c6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dq4sejDtpAwwBeadsjod+B2tOf97KA2Eq0yG2ku2xd4=;
        b=tHee0pp8tXzNY6CDV4KWWzD5JatWd7/l2t3pgVBRLWpb1wZ4stDkkdOLW5s6NUBhKl
         fLZIzqNJ1PxmELFmhDcaMqS5MMf2zWzyOAD66YFuBBpY2mrB6fmSJcPKAXL3LLX8Um+C
         nL7q4Tsw7N4FBLbUU4mNs2ryu/gvlpAIh9WyCN26/EKdHLmGT5LCFMkdZdzJ1olqJQH5
         m2OI1jZKE5dwOptS3hy9+dbRdd7DbSXRLIWO79v/ovUSccSaab4eN9kroaLUD/3zHFjZ
         +Q8EPFA8RIfuy4Ch+oLIOWUwIB5nGEsb2xsH6DTA/xNfWk4jxA/H3L/vXr7mzPjkVU0V
         CrEA==
X-Gm-Message-State: AFqh2krXnv6jW6os3SZlWvcZVmlnjqPTscpzBswy+kGnHO0p/9vguJ3c
        zNvvz3DMcLf+5svXqQYFT9Yd9Q==
X-Google-Smtp-Source: AMrXdXuFrZKaV2dOhJkP+PEdijh3quNzsTVqJPvPHwwraxpXQf8utzeZXdnaw3d0xP6dYsv071bRFw==
X-Received: by 2002:a05:6a20:93a7:b0:b8:ca86:f3ab with SMTP id x39-20020a056a2093a700b000b8ca86f3abmr968614pzh.2.1674518062096;
        Mon, 23 Jan 2023 15:54:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w9-20020a63af09000000b0046fefb18a09sm96718pge.91.2023.01.23.15.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 15:54:21 -0800 (PST)
Date:   Mon, 23 Jan 2023 23:54:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/8] x86/cpu, kvm: Add support for CPUID_80000021_EAX
Message-ID: <Y88eKn3/RKIaqJMv@google.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
 <20230123225700.2224063-2-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123225700.2224063-2-kim.phillips@amd.com>
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

On Mon, Jan 23, 2023, Kim Phillips wrote:
> Add support for CPUID leaf 80000021, EAX. The majority of the features will be
> used in the kernel and thus a separate leaf is appropriate.
> 
> Include KVM's reverse_cpuid entry because features are used by VM guests, too.

Nit, "KVM guests", not "VM guests".
